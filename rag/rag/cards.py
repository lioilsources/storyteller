"""Cheap slice of verbalize: for a chosen set of motifs, just the title and
one sentence the app shows (a character's short *name* instead of a
situation caption). Output uses the Verbalization row shape at age band
3-6 / neutral, so build_pack and the app read it with no new table.

Selection per country: up to --characters character motifs and up to
--per-type task/problem/ending motifs, spread round-robin across that
country's tales so one long tale doesn't fill the slot. --images-dir adds
every character that already has card art (backfills names for them).

Originál napřed (rag.sources): motiv z pohádky, jejíž text máme v --lang,
se píše z úryvku toho textu, ne z text_en; řádek nese `source`.

Input: rag/data/tales.jsonl. Output: rag/data/cards.<lang>.jsonl.

    python -m rag.cards --lang cs --characters 20 --per-type 10
    python -m rag.cards --lang cs --regen-from-original
"""

from __future__ import annotations

import argparse
from collections import defaultdict
from pathlib import Path

from .filters import check_for_age, is_single_sentence, word_count, wrong_language
from .io import CHUNK, DATA_DIR, append_jsonl, log, read_jsonl
from .llm import LLM
from .schemas import CardOut, Motif, TaleRecord, Verbalization
from .sources import Job, OriginalResolver, motif_ids, needs_work, sources_by_key
from .verbalize import LANG_NAMES, motifs_from_tales

SYSTEM = """You write picture-card text for a children's storytelling app in {lang_name}.

Given one folk-tale motif, return:
- title: if the motif type is "character", the character's short NAME (1-4 words) as a child would call them in a picture book — a name or an epithet with a noun ('Chytrá liška', 'Kovář Honza', 'Babička Zima'), never a description of what happens. For other types a 2-5 word caption.
- sentence: exactly one sentence, at most 20 words, simple enough for a 3-6 year old. Never reveal how the story ends unless the motif IS the ending.

Write natively in {lang_name}; keep the culture of origin ({origin}) — its names, animals and places, spelled the way {lang_name} books spell them. Never translate literally. Output only JSON matching the schema."""

TYPES = ("task", "problem", "ending")


def select(tales_path: Path, characters: int, per_type: int, countries: set[str] | None, images_dir: Path | None, exclude: frozenset[str] = frozenset()) -> list[tuple[Motif, str]]:
    """(motif, origin) pairs to card, in a stable order."""
    by_slot: dict[tuple[str, str], dict[str, list[Motif]]] = defaultdict(lambda: defaultdict(list))
    origin: dict[str, str] = {}
    pinned: list[Motif] = []
    have_art = {p.stem for p in images_dir.glob("*.jpg")} if images_dir and images_dir.is_dir() else set()
    seen: set[str] = set()
    for rec in read_jsonl(tales_path, TaleRecord):
        for m in rec.motifs:
            if m.id in seen:
                continue
            seen.add(m.id)
            origin[m.id] = m.people or m.country_code or "unknown"
            if m.type == "character" and m.id in have_art:
                pinned.append(m)
                continue
            if not m.country_code or m.country_code in exclude or (countries and m.country_code not in countries) or m.age_min > 6:
                continue
            if m.type == "character" or m.type in TYPES:
                by_slot[(m.country_code, m.type)][m.source_ref].append(m)

    out = list(pinned)
    for (_, mtype), tales in sorted(by_slot.items()):
        cap = characters if mtype == "character" else per_type
        queues = [list(v) for _, v in sorted(tales.items())]
        taken = 0
        while taken < cap and any(queues):
            for q in queues:
                if q and taken < cap:
                    out.append(q.pop(0))
                    taken += 1
    return [(m, origin[m.id]) for m in out]


def same_motifs(tales_path: Path, ids: frozenset[str]) -> list[tuple[Motif, str]]:
    """(motif, origin) pro motivy s danými id, v pořadí tales.jsonl."""
    return [(m, m.people or m.country_code or "unknown") for m in motifs_from_tales(tales_path) if m.id in ids]


def acceptable(out: CardOut, mtype: str, lang: str) -> bool:
    title, sentence = out.title.strip(), out.sentence.strip()
    max_title = 4 if mtype == "character" else 6
    if not title or word_count(title) > max_title or title.endswith((".", "!", "?")):
        return False
    if not is_single_sentence(sentence) or word_count(sentence) > 22:
        return False
    return all(not wrong_language(t, lang) and check_for_age(t, lang, 3).ok for t in (title, sentence))


def plan(tales_path: Path, out_path: Path, lang: str, picks: list[tuple[Motif, str]], resolver: OriginalResolver, regen: bool = False) -> list[Job]:
    """Volání, která běh udělá. Motiv z pohádky, jejíž text máme v [lang],
    se píše z úryvku originálu (rag.sources), ostatní z text_en.

    regen: místo `picks` vezme motivy, které už v [out_path] kartu mají,
    ale jen z text_en, a jejich pohádka má originál v [lang]."""
    have = sources_by_key(out_path, Verbalization, lambda v: v.motif_id)
    if regen:
        picks = same_motifs(tales_path, frozenset(have))
    lang_name = LANG_NAMES.get(lang, lang)
    jobs: list[Job] = []
    for m, o in picks:
        src = resolver.source_for(m)
        if not needs_work(m.id, have, src, regen):
            continue
        base = f"Motif type: {m.type}\nMotif (English): {m.text_en}\nTags: {', '.join(m.tags)}"
        jobs.append(Job(key=m.id, motif=m, system=resolver.system(SYSTEM.format(lang_name=lang_name, origin=o), m, lang_name), user=base + resolver.block(m), base_user=base, source=src))
    return jobs


def run(tales_path: Path, out_path: Path, lang: str, picks: list[tuple[Motif, str]], llm: LLM, resolver: OriginalResolver | None = None, regen: bool = False) -> tuple[int, int, int]:
    resolver = resolver or OriginalResolver.load(lang, tales_path=tales_path)
    todo = plan(tales_path, out_path, lang, picks, resolver, regen)
    n_orig = sum(j.source == "original" for j in todo)
    log(f"cards[{lang}]: {len(picks)} picked, {len(todo)} to do ({n_orig} z originálu{', regen' if regen else ''})")
    ok = failed = dropped = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(j.system, j.user) for j in part], CardOut)
        rows: list[Verbalization] = []
        for j, res in zip(part, results):
            m = j.motif
            if isinstance(res, Exception):
                log(f"  FAIL {m.id}: {res}")
                failed += 1
            elif not acceptable(res, m.type, lang):
                log(f"  drop {m.id}: {res.title!r} / {res.sentence!r}")
                dropped += 1
            else:
                for length, text in (("title", res.title), ("sentence", res.sentence)):
                    rows.append(Verbalization(motif_id=m.id, lang=lang, age_band="3-6", tone="neutral", length=length, text=text.strip(), source=j.source))
                ok += 1
        append_jsonl(out_path, rows)
        log(f"cards[{lang}]: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed, {dropped} dropped)")
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--lang", required=True)
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/cards.<lang>.jsonl")
    ap.add_argument("--characters", type=int, default=20, help="character motifs per country")
    ap.add_argument("--per-type", type=int, default=10, help="task/problem/ending motifs per country, each")
    ap.add_argument("--countries", default="", help="comma list of ISO codes; default all")
    ap.add_argument("--exclude", default="CZ", help="countries already verbalized in full (their art-pinned characters still get names)")
    ap.add_argument("--images-dir", type=Path, default=DATA_DIR / "motif_images", help="characters with art here are always included")
    ap.add_argument("--dry-run", action="store_true", help="print per-country pick counts and exit")
    ap.add_argument("--same-motifs-as", type=Path, default=None, help="místo výběru: přesně motivy z tohoto JSONL (např. rag/data/cards.cs.jsonl)")
    ap.add_argument("--regen-from-original", action="store_true", help="přepiš z originálu karty, které už existují z text_en (staré řádky zůstanou, build_pack vezme nové)")
    args = ap.parse_args()
    countries = {c.strip().upper() for c in args.countries.split(",") if c.strip()} or None
    exclude = frozenset(c.strip().upper() for c in args.exclude.split(",") if c.strip())
    picks = select(args.tales, args.characters, args.per_type, countries, args.images_dir, exclude)
    if args.same_motifs_as:
        picks = same_motifs(args.tales, motif_ids(args.same_motifs_as))
    if args.dry_run:
        per: dict[str, int] = defaultdict(int)
        for m, _ in picks:
            per[f"{m.country_code or '-'}:{m.type}"] += 1
        for k in sorted(per):
            print(k, per[k])
        print("total", len(picks))
        return
    out = args.out or DATA_DIR / f"cards.{args.lang}.jsonl"
    ok, failed, dropped = run(args.tales, out, args.lang, picks, LLM(), regen=args.regen_from_original)
    log(f"cards[{args.lang}]: {ok} ok, {failed} failed, {dropped} dropped → {out}")


if __name__ == "__main__":
    main()
