"""Stage 2: verbalize — per motif × language, a bundle of phrasings
(RAG_PLAN §2.1): 3 age bands × 2 tones × 2 lengths = 12 variants
(the plan's "3 formulations" per cell come from re-running with a
different --formulation seed word; one pass is plenty for MVP).

Input: rag/data/tales.jsonl. Output: rag/data/verbalizations.<lang>.jsonl.

    python -m rag.verbalize --lang cs --limit 20
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .filters import check_for_age
from .io import DATA_DIR, append_jsonl, done_keys, log, read_jsonl
from .llm import LLM
from .schemas import AGE_BANDS, Motif, TaleRecord, Verbalization, VerbalizeOut

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


def run(tales_path: Path, out_path: Path, lang: str, limit: int, llm: LLM) -> tuple[int, int, int]:
    motifs = motifs_from_tales(tales_path)
    done = done_keys(out_path, Verbalization, lambda v: v.motif_id)
    todo = [m for m in motifs if m.id not in done]
    if limit:
        todo = todo[:limit]
    log(f"verbalize[{lang}]: {len(motifs)} motifs, {len(done)} done, {len(todo)} to do")
    if not todo:
        return 0, 0, 0

    system = SYSTEM.format(lang_name=LANG_NAMES.get(lang, lang))
    prompts = [(system, f"Motif type: {m.type}\nMotif (English): {m.text_en}\nTags: {', '.join(m.tags)}") for m in todo]
    results = llm.batch(prompts, VerbalizeOut)

    ok = failed = dropped = 0
    rows: list[Verbalization] = []
    for m, res in zip(todo, results):
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
            rows.append(Verbalization(motif_id=m.id, lang=lang, age_band=v.age_band, tone=v.tone, length=v.length, text=v.text.strip()))
            kept += 1
        ok += 1
        if kept < 4:
            log(f"  thin {m.id}: only {kept} variants survived filters")
    append_jsonl(out_path, rows)
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--lang", required=True, help="target language code, e.g. cs")
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/verbalizations.<lang>.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()
    out = args.out or DATA_DIR / f"verbalizations.{args.lang}.jsonl"
    ok, failed, dropped = run(args.tales, out, args.lang, args.limit, LLM())
    log(f"verbalize[{args.lang}]: {ok} motifs ok, {failed} failed, {dropped} variants dropped by filters → {out}")


if __name__ == "__main__":
    main()
