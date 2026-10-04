"""Stage 2: verbalize — per motif × language, a bundle of phrasings
(RAG_PLAN §2.1): 3 age bands × 2 tones × 2 lengths = 12 variants
(the plan's "3 formulations" per cell come from re-running with a
different --formulation seed word; one pass is plenty for MVP).

Originál napřed (rag.sources): motiv z pohádky, jejíž text máme v --lang,
se píše z úryvku toho textu, ne z text_en; řádek nese `source`.

Input: rag/data/tales.jsonl. Output: rag/data/verbalizations.<lang>.jsonl.

    python -m rag.verbalize --lang cs --limit 20
    python -m rag.verbalize --lang cs --regen-from-original
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .filters import check_for_age
from .io import CHUNK, DATA_DIR, append_jsonl, log, read_jsonl
from .llm import LLM
from .schemas import Motif, TaleRecord, Verbalization, VerbalizeOut
from .sources import Job, OriginalResolver, motif_ids, needs_work, sources_by_key

LANG_NAMES = {
    "cs": "Czech", "sk": "Slovak", "en": "English", "de": "German", "pl": "Polish",
    "es": "Spanish", "fr": "French", "it": "Italian", "pt": "Portuguese", "uk": "Ukrainian",
    "hu": "Hungarian", "ro": "Romanian", "nl": "Dutch", "sv": "Swedish", "da": "Danish",
    "fi": "Finnish", "no": "Norwegian", "ja": "Japanese", "ko": "Korean", "zh": "Chinese",
    "ar": "Arabic", "hi": "Hindi", "tr": "Turkish",
}

SYSTEM = """You write short, warm phrasings of fairy-tale motifs for parents telling bedtime stories in {lang_name}.

For the given motif produce exactly 12 variants: every combination of
  age_band ∈ ["0-3", "3-6", "6-10"]  ×  tone ∈ ["neutral", "playful"]  ×  length ∈ ["title", "sentence"].

- title: 2-5 words, like a picture-card caption. sentence: exactly one sentence, ≤ 20 words.
- 0-3: very simple words, concrete, gentle. 3-6: simple but with a little tension. 6-10: richer vocabulary, may hint at cleverness or danger (never gore).
- playful: a wink, a sound word, or a question; neutral: plain and calm.
- Write natively in {lang_name}: locally natural names, animals, places and realia for a {lang_name}-speaking child. Never translate literally.
- Never reveal how the story ends unless the motif itself IS the ending.
Output only JSON matching the schema."""


def motifs_from_tales(path: Path) -> list[Motif]:
    seen: set[str] = set()
    out: list[Motif] = []
    for rec in read_jsonl(path, TaleRecord):
        for m in rec.motifs:
            if m.id not in seen:
                seen.add(m.id)
                out.append(m)
    return out


def plan(tales_path: Path, out_path: Path, lang: str, limit: int, resolver: OriginalResolver, regen: bool = False, only: frozenset[str] | None = None) -> list[Job]:
    """Volání, která běh udělá; z originálu, kde text pohádky máme v [lang]."""
    have = sources_by_key(out_path, Verbalization, lambda v: v.motif_id)
    lang_name = LANG_NAMES.get(lang, lang)
    system = SYSTEM.format(lang_name=lang_name)
    jobs: list[Job] = []
    for m in motifs_from_tales(tales_path):
        if only is not None and m.id not in only:
            continue
        src = resolver.source_for(m)
        if not needs_work(m.id, have, src, regen):
            continue
        base = f"Motif type: {m.type}\nMotif (English): {m.text_en}\nTags: {', '.join(m.tags)}"
        jobs.append(Job(key=m.id, motif=m, system=resolver.system(system, m, lang_name), user=base + resolver.block(m), base_user=base, source=src))
        if limit and len(jobs) >= limit:
            break
    return jobs


def run(tales_path: Path, out_path: Path, lang: str, limit: int, llm: LLM, resolver: OriginalResolver | None = None, regen: bool = False, only: frozenset[str] | None = None) -> tuple[int, int, int]:
    resolver = resolver or OriginalResolver.load(lang, tales_path=tales_path)
    todo = plan(tales_path, out_path, lang, limit, resolver, regen, only)
    log(f"verbalize[{lang}]: {len(todo)} to do ({sum(j.source == 'original' for j in todo)} z originálu{', regen' if regen else ''})")
    if not todo:
        return 0, 0, 0

    ok = failed = dropped = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(j.system, j.user) for j in part], VerbalizeOut)
        rows: list[Verbalization] = []
        for j, res in zip(part, results):
            m = j.motif
            if isinstance(res, Exception):
                log(f"  FAIL {m.id}: {res}")
                failed += 1
                continue
            kept = 0
            for v in res.variants:
                band_min = {"0-3": 0, "3-6": 3, "6-10": 6}[v.age_band]
                if band_min < m.age_min:
                    dropped += 1  # tale is 6+, don't ship a 0-3 phrasing of it
                    continue
                if not check_for_age(v.text, lang, band_min).ok:
                    dropped += 1
                    continue
                rows.append(Verbalization(motif_id=m.id, lang=lang, age_band=v.age_band, tone=v.tone, length=v.length, text=v.text.strip(), source=j.source))
                kept += 1
            ok += 1
            if kept < 4:
                log(f"  thin {m.id}: only {kept} variants survived filters")
        append_jsonl(out_path, rows)
        log(f"verbalize[{lang}]: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed, {dropped} dropped)")
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--lang", required=True, help="target language code, e.g. cs")
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/verbalizations.<lang>.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--regen-from-original", action="store_true", help="přepiš z originálu motivy, které už mají řádky z text_en (staré zůstanou, build_pack vezme nové)")
    ap.add_argument("--same-motifs-as", type=Path, default=None, help="jen motivy, které má tento JSONL (např. rag/data/verbalizations.cs.jsonl)")
    args = ap.parse_args()
    out = args.out or DATA_DIR / f"verbalizations.{args.lang}.jsonl"
    only = motif_ids(args.same_motifs_as) if args.same_motifs_as else None
    ok, failed, dropped = run(args.tales, out, args.lang, args.limit, LLM(), regen=args.regen_from_original, only=only)
    log(f"verbalize[{args.lang}]: {ok} motifs ok, {failed} failed, {dropped} variants dropped by filters → {out}")


if __name__ == "__main__":
    main()
