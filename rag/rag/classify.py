"""Stage 1b: classify — atu_code, country_code, age_min, soft per tale,
as a separate pass over already extracted tales (PLAN §7 guardrail).

Why a pass of its own: extract asked for these four fields alongside the
motifs, but the schema left them optional and swarm-director skipped them
on every one of 567 tales (2026-09-26) — each tale came back "not soft,
age 0, no ATU, no country". The schema now requires them (see
`schemas._all_required`), and this pass fixes what was already written.
It also keeps the safety-relevant decision in one short, focused prompt
instead of the tail of a long extraction.

Two steps, both resumable:

    python -m rag.classify            # LLM → rag/data/classify.jsonl
    python -m rag.classify --apply    # merge into rag/data/tales.jsonl

`--apply` rewrites tales.jsonl in place (atomically) and updates the
copies on every motif. Motif ids do not depend on these fields, so
downstream stages keep resuming. Country stays ground truth for
single-country collections (`extract.KNOWN_COUNTRY`); the model's answer
is used only where the collection mixes nations.
"""

from __future__ import annotations

import argparse
import os
from pathlib import Path

from .extract import MAX_CHARS, MIXED_ORIGIN, clean_atu, country_for, discover_tales, people_for, source_ref
from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, read_jsonl
from .llm import LLM
from .schemas import ClassifyRecord, TaleClassification, TaleRecord

SYSTEM = """You classify one public-domain fairy tale for a children's bedtime-story app. Answer all four fields.

- atu_code: best-guess Aarne-Thompson-Uther type ("ATU 333"), or "" if no type fits.
- country_code: ISO 3166-1 alpha-2 of the nation whose folk tradition the tale comes from — not the language it is written in. A Russian tale translated into Czech is RU.
- people: that nation or people in English ("Russian", "Yoruba", "Tibetan") — for tales from multi-ethnic states, the people, not just the state.
- age_min: 0, 3, or 6 — the youngest age the tale's content is fine for as told: 0 = gentle, nothing frightening; 3 = mild peril that resolves; 6 = death, killing, cruelty, or real menace.
- soft: true if a retelling for young children should soften anything — violence, death, someone eaten, punished, abandoned, or in lasting danger. Most folk tales are soft=true.
Output only JSON matching the schema."""

COLLECTION_HINT = {
    "erben-slovanske": "K. J. Erben's anthology of tales from many Slavic nations (Czech, Slovak, Polish, Russian, Ukrainian, Belarusian, Serbian, Croatian, Slovene, Bulgarian, Lusatian…); decide which nation this one is from.",
    "lang": "Andrew Lang's Fairy Books, which gather tales from all over the world; decide where this one comes from.",
}


def run(raw_dir: Path, tales_path: Path, out_path: Path, limit: int, llm: LLM) -> tuple[int, int]:
    paths = {source_ref(src, coll, book, p): (coll, title, p) for src, coll, book, title, p in discover_tales(raw_dir, set())}
    refs = [r.source_ref for r in read_jsonl(tales_path, TaleRecord)]
    done = done_keys(out_path, ClassifyRecord, lambda r: r.source_ref)
    todo = [r for r in refs if r not in done and r in paths]
    missing = [r for r in refs if r not in paths]
    if missing:
        log(f"classify: {len(missing)} tales have no source file under {raw_dir}, skipping (e.g. {missing[0]})")
    if limit:
        todo = todo[:limit]
    log(f"classify: {len(refs)} tales, {len(done)} already classified, {len(todo)} to do")

    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        chunk = todo[start : start + CHUNK]
        prompts = []
        for ref in chunk:
            coll, title, path = paths[ref]
            hint = COLLECTION_HINT.get(coll, "")
            text = path.read_text(encoding="utf-8")[:MAX_CHARS]
            prompts.append((SYSTEM, f"Collection: {coll}{' — ' + hint if hint else ''}\nTitle: {title}\n\n{text}"))
        records = []
        for ref, res in zip(chunk, llm.batch(prompts, TaleClassification)):
            if isinstance(res, Exception):
                log(f"  FAIL {ref}: {res}")
                failed += 1
                continue
            records.append(ClassifyRecord(source_ref=ref, classification=res, model=llm.model))
            log(f"  ok   {ref}: atu={res.atu_code or '-'} cc={res.country_code or '-'} age={res.age_min} soft={res.soft}")
            ok += 1
        append_jsonl(out_path, records)
        log(f"classify: {start + len(chunk)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def apply(tales_path: Path, class_path: Path) -> tuple[int, int, int]:
    """Merge classify.jsonl into tales.jsonl. Returns (updated, unclassified, mixed-without-country)."""
    classes = {r.source_ref: r.classification for r in read_jsonl(class_path, ClassifyRecord)}
    updated = unclassified = no_country = 0
    out: list[TaleRecord] = []
    for rec in read_jsonl(tales_path, TaleRecord):
        c = classes.get(rec.source_ref)
        if c is None:
            unclassified += 1
            out.append(rec)
            continue
        coll = rec.source_ref.split(":")[1]
        country = country_for(coll, c.country_code)
        people = people_for(coll, c.people)
        atu = clean_atu(c.atu_code)
        ex = rec.extraction
        ex.atu_code, ex.country_code, ex.people, ex.age_min, ex.soft = atu, country, people, c.age_min, c.soft
        for m in rec.motifs:
            m.atu_code, m.country_code, m.people, m.age_min, m.soft = atu, country, people, c.age_min, c.soft
        if coll in MIXED_ORIGIN and not country:
            no_country += 1
        updated += 1
        out.append(rec)
    tmp = tales_path.with_suffix(".jsonl.tmp")
    tmp.unlink(missing_ok=True)
    append_jsonl(tmp, out)
    os.replace(tmp, tales_path)
    return updated, unclassified, no_country


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--in", dest="raw_dir", type=Path, default=Path("corpus/data/raw"), help="Go fetcher output (repo-relative)")
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--out", type=Path, default=DATA_DIR / "classify.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--apply", action="store_true", help="merge --out into --tales instead of calling the LLM")
    args = ap.parse_args()
    if args.apply:
        updated, unclassified, no_country = apply(args.tales, args.out)
        log(f"classify --apply: {updated} tales updated, {unclassified} not classified yet, {no_country} mixed-origin tales still without country → {args.tales}")
        return
    ok, failed = run(args.raw_dir, args.tales, args.out, args.limit, LLM())
    log(f"classify: {ok} ok, {failed} failed → {args.out}")


if __name__ == "__main__":
    main()
