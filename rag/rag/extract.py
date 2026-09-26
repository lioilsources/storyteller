"""Stage 1: classify + extract motifs from the tales `corpus/cmd/fetch-gutenberg`
(Go) wrote under corpus/data/raw/<collection>/<id>-tales/.

PLAN §3.2 steps 3+4 folded into one LLM call per tale, extended with
environments/creatures (PLAN §1.1c). Output: rag/data/tales.jsonl, one
TaleRecord per tale, with deterministic motif ids so downstream stages
can resume.

    python -m rag.extract --only grimm --limit 5     # smoke test first
    python -m rag.extract                            # everything
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path

from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, stable_id
from .llm import LLM
from .schemas import Motif, MotifExtraction, TaleRecord

# Real finding from the first live run against 5 Grimm tales
# (2026-09-24, model "translate" / Qwen3-32B-AWQ via the LAN gateway):
# the model got country_code wrong for 2/5 tales (Die Bremer
# Stadtmusikanten and Der alte Sultan — unambiguously Grimm/German —
# both came back "FR"). For single-country collections we already KNOW
# the country from which anthology the tale was fetched from (PLAN §3.1)
# — there's no need to trust an LLM guess we can just check against
# ground truth we already have. Lang's Fairy Books is a genuinely
# multi-country anthology (that's the whole point of it), so it's the
# one collection left to the model's per-tale judgement.
KNOWN_COUNTRY = {
    "grimm": "DE",
    "andersen": "DK",
    "perrault": "FR",
    "aesop": "GR",
    # cs.wikisource (2026-09-25). Němcová's Národní Báchorky and Erben's
    # prose tales are Czech; her Srbské pohádky are Serbian tales she
    # translated, so the tradition is RS even though the text is Czech.
    "nemcova": "CZ",
    "erben": "CZ",
    "nemcova-srbske": "RS",
}

# Collections that deliberately gather tales from many nations, where the
# origin can only be decided per tale. Listed explicitly rather than left
# implicit, so that adding a collection and forgetting to classify it is
# a loud failure instead of a silent per-tale guess.
MIXED_ORIGIN = {"lang", "erben-slovanske"}

# Same run: atu_code came back as "554 The Golden Bird" instead of a
# bare code — the model tacked the tale's own title onto the number.
# Keep only the leading ATU-shaped token.
_ATU_TOKEN = re.compile(r"^\s*(?:ATU?\s*)?(\d{1,4}[A-Za-z]?)\b")


def clean_atu(code: str) -> str:
    m = _ATU_TOKEN.match(code)
    return f"ATU {m.group(1)}" if m else ""

SYSTEM = """You extract structured, reusable story motifs for a children's bedtime-story app from one public-domain fairy tale.

Rules:
- Each entry in characters/tasks/problems/endings is ONE short English sentence (a motif, not a summary), reusable across different retellings, not tied to this tale's names or wording.
- characters: archetypes ("a clever fox who talks its way out of trouble"), 1-4. tasks: what the hero must accomplish, 1-3. problems: obstacle/antagonist/dilemma, 1-3. endings: happy resolution, 1-2.
- tags: 3-8 lowercase keywords (setting, creatures, themes).
- environments: the settings the tale moves through, lowercase single words from: forest, sea, river, lake, desert, mountains, steppe, village, town, palace, cottage, market, underground, sky, garden, mill, road.
- creatures: creatures and folk figures that appear (generic: "owl", "wolf", "water sprite", "dragon"), each tied to one of the environments you listed.
- atu_code: best-guess ATU type or "". country_code: ISO 3166-1 alpha-2 of the tale's tradition of origin (DE Grimm, DK Andersen, FR Perrault, GR Aesop), not the translation's language.
- age_min: 0, 3, or 6. soft: true if violence/death/peril should be softened for young children.
- Never invent motifs not grounded in the text. Output only JSON matching the schema."""

MAX_CHARS = 16000  # ~4k tokens of tale; Grimm tales are far shorter, Lang's longest ones get truncated


def discover_tales(raw_dir: Path, only: set[str]) -> list[tuple[str, str, str, str, Path]]:
    """(source, collection, book_id, title, path) for every split tale.

    Two on-disk layouts, because there are two fetchers. `fetch-gutenberg`
    writes one directory per book (`grimm/2591-tales/`), since a Gutenberg
    anthology is one file that gets split. `fetch-wikisource` writes a
    single `tales/` directory per collection, since Wikisource already
    serves one page per tale and there is no book id to speak of.

    Matching only `*-tales` used to skip every Wikisource collection in
    silence — the Czech corpus was on disk and invisible here.
    """
    out: list[tuple[str, str, str, str, Path]] = []
    for coll in sorted(p for p in raw_dir.iterdir() if p.is_dir()):
        if only and coll.name not in only:
            continue
        for book in sorted(p for p in coll.iterdir() if p.is_dir()):
            index_path = book / "index.json"
            if not index_path.exists():
                continue
            if book.name == "tales":
                source, book_id = "wikisource", ""
            elif book.name.endswith("-tales"):
                source, book_id = "gutenberg", book.name.removesuffix("-tales")
            else:
                continue
            index = json.loads(index_path.read_text(encoding="utf-8"))
            for entry in index:
                out.append((source, coll.name, book_id, entry["title"], book / entry["file"]))
    return out


def source_ref(source: str, collection: str, book_id: str, path: Path) -> str:
    """Stable dedupe key, also the provenance string stored on every motif.

    Empty parts are dropped so a Wikisource tale (no book id) reads
    `wikisource:nemcova:000-chytra-horakyne`, while a Gutenberg one keeps
    the exact four-part shape the first 93 records already use — change
    that and every one of them re-extracts.
    """
    return ":".join(p for p in (source, collection, book_id, path.stem) if p)


def to_motifs(ref: str, ex: MotifExtraction) -> list[Motif]:
    rows: list[Motif] = []
    for mtype, texts in (
        ("character", ex.characters),
        ("task", ex.tasks),
        ("problem", ex.problems),
        ("ending", ex.endings),
    ):
        for text in texts:
            rows.append(
                Motif(
                    id=stable_id(ref, mtype, text.lower()),
                    type=mtype,  # type: ignore[arg-type]
                    text_en=text,
                    tags=ex.tags,
                    atu_code=ex.atu_code,
                    country_code=ex.country_code,
                    age_min=ex.age_min,
                    soft=ex.soft,
                    source_ref=ref,
                    environments=ex.environments,
                )
            )
    return rows




def run(raw_dir: Path, out_path: Path, only: set[str], limit: int, llm: LLM) -> tuple[int, int]:
    tales = discover_tales(raw_dir, only)
    done = done_keys(out_path, TaleRecord, lambda r: r.source_ref)
    todo = [t for t in tales if source_ref(t[0], t[1], t[2], t[4]) not in done]
    if limit:
        todo = todo[:limit]
    log(f"extract: {len(tales)} tales found, {len(done)} already done, {len(todo)} to do")

    unclassified = {c for _, c, _, _, _ in todo} - set(KNOWN_COUNTRY) - MIXED_ORIGIN
    if unclassified:
        log(f"extract: WARNING collections with no origin rule: {sorted(unclassified)} — "
            "each tale's country will be the model's guess; add them to KNOWN_COUNTRY or MIXED_ORIGIN")
    if not todo:
        return 0, 0

    ok, failed = 0, 0
    for start in range(0, len(todo), CHUNK):
        batch = todo[start : start + CHUNK]
        prompts = [
            (SYSTEM, f"Title: {title}\n\nText:\n{path.read_text(encoding='utf-8')[:MAX_CHARS]}")
            for _, _, _, title, path in batch
        ]
        results = llm.batch(prompts, MotifExtraction)

        records: list[TaleRecord] = []
        for (source, coll, book, title, path), res in zip(batch, results):
            ref = source_ref(source, coll, book, path)
            if isinstance(res, Exception):
                log(f"  FAIL {ref}: {res}")
                failed += 1
                continue
            res = res.model_copy(update={
                "atu_code": clean_atu(res.atu_code),
                "country_code": KNOWN_COUNTRY.get(coll, res.country_code),
            })
            records.append(TaleRecord(source_ref=ref, title=title, extraction=res, motifs=to_motifs(ref, res)))
            ok += 1
            log(f"  ok   {ref}: {len(records[-1].motifs)} motifs, atu={res.atu_code or '-'} cc={res.country_code or '-'} soft={res.soft}")
        append_jsonl(out_path, records)
        log(f"extract: {start + len(batch)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--in", dest="raw_dir", type=Path, default=Path("corpus/data/raw"), help="Go fetcher output (repo-relative)")
    ap.add_argument("--out", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--only", default="", help="comma-separated collections, e.g. grimm,andersen")
    ap.add_argument("--limit", type=int, default=0, help="max tales this run (0 = all)")
    args = ap.parse_args()

    only = {s.strip() for s in args.only.split(",") if s.strip()}
    ok, failed = run(args.raw_dir, args.out, only, args.limit, LLM())
    log(f"extract: done, {ok} ok, {failed} failed → {args.out}")


if __name__ == "__main__":
    main()
