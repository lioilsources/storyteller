"""Stage 4: transitions — connective phrases between outline beats
(RAG_PLAN §2.3): per (from_type → to_type, lang), tagged so the outline
composer can pick one matching the neighbouring motifs' tags.

Small, fixed workload (~200 per language). Output: rag/data/transitions.<lang>.jsonl.

    python -m rag.transitions --lang cs
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .filters import check_for_age, word_count
from .io import DATA_DIR, append_jsonl, done_keys, log
from .llm import LLM
from .schemas import Transition, TransitionsOut
from .verbalize import LANG_NAMES

# The outline is character → task → problem → ending (PLAN §1.1); we also
# want problem → task (a setback that sends the hero back out) and
# character → problem (stories that open with trouble).
PAIRS = (("character", "task"), ("task", "problem"), ("problem", "ending"), ("problem", "task"), ("character", "problem"))

TAGS = ("forest", "sea", "river", "mountains", "village", "town", "palace", "cottage", "market", "road", "night", "winter", "king", "animal", "magic", "trick", "journey", "kindness")

SYSTEM = """You write connective phrases for parents telling bedtime stories in {lang_name} — the little bridges between story beats.

Given a transition from one kind of beat to the next, produce 20 varied phrases. Each:
- ≤ 12 words, in {lang_name}, natural spoken storytelling register ("But before he set out,…", "Just then,…", "And so, the next morning,…").
- ends with "…" or "," — it leads INTO the next beat, it does not contain it.
- carries 1-3 tags from this list that it suits especially well: {tags}. Include several with no strong setting (tag them "journey" or "night" only when apt).
- never mentions how the story ends.
Output only JSON matching the schema."""


def run(out_path: Path, lang: str, llm: LLM) -> tuple[int, int, int]:
    done = done_keys(out_path, Transition, lambda t: f"{t.from_type}>{t.to_type}")
    todo = [(a, b) for a, b in PAIRS if f"{a}>{b}" not in done]
    log(f"transitions[{lang}]: {len(PAIRS)} pairs, {len(done)} done, {len(todo)} to do")
    if not todo:
        return 0, 0, 0

    system = SYSTEM.format(lang_name=LANG_NAMES.get(lang, lang), tags=", ".join(TAGS))
    prompts = [(system, f"From beat: {a}\nTo beat: {b}") for a, b in todo]
    results = llm.batch(prompts, TransitionsOut)

    ok = failed = dropped = 0
    rows: list[Transition] = []
    for (a, b), res in zip(todo, results):
        if isinstance(res, Exception):
            log(f"  FAIL {a}>{b}: {res}")
            failed += 1
            continue
        for t in res.transitions:
            text = t.text.strip()
            tags = [x for x in (s.strip().lower() for s in t.tags) if x in TAGS]
            if word_count(text) > 12 or not check_for_age(text, lang, 0).ok:
                dropped += 1
                continue
            rows.append(Transition(from_type=a, to_type=b, tags=tags, lang=lang, text=text))  # type: ignore[arg-type]
        ok += 1
    append_jsonl(out_path, rows)
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/transitions.<lang>.jsonl")
    args = ap.parse_args()
    out = args.out or DATA_DIR / f"transitions.{args.lang}.jsonl"
    ok, failed, dropped = run(out, args.lang, LLM())
    log(f"transitions[{args.lang}]: {ok} pairs ok, {failed} failed, {dropped} dropped → {out}")


if __name__ == "__main__":
    main()
