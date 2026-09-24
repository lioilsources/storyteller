"""Stage 3: hint_bank — open-ended nudges per (motif, phase, lang), plus
generic per-(phase, environment) fallbacks (RAG_PLAN §2.2).

Each hint carries a `situation_en`: an English description of the
moment it fits. That, not the hint text, is what gets embedded as the
trigger (transcript ↔ situation matches far better than transcript ↔
hint). Rule filters (one sentence, ≤ 15 words, no closing phrases, no
blatant spoiler of the tale's ending) run here; the LLM spoiler
classifier is a later stage.

    python -m rag.hints --lang cs --limit 10
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .filters import check_hint, reveals_ending
from .io import DATA_DIR, append_jsonl, done_keys, log, read_jsonl, stable_id
from .llm import LLM
from .schemas import PHASES, Hint, HintsOut, TaleRecord
from .verbalize import LANG_NAMES

SYSTEM = """You help a parent who is telling a bedtime story out loud and has just paused, unsure how to go on. You write HINTS in {lang_name}.

A hint is ONE open-ended sentence, at most 15 words, that offers a direction without telling the story for them: it trails off ("…and just then, from the bushes came…"), or asks the child ("…what do you think the fox did next?"). It NEVER completes the plot beat and NEVER reveals or implies how the story ends.

Produce 8 hints for the given motif at the given story phase:
  intro   = the character is being introduced / the world set up
  task    = the hero learns what they must do and sets out
  problem = the obstacle or antagonist appears
  climax  = the hardest moment, before it resolves
  ending  = winding down — hints here invite the child to imagine the aftermath, still without stating the resolution

For each hint also give `situation`: one plain English sentence describing the moment in the telling where it fits (what has just happened, what the parent is stuck on). Output only JSON matching the schema."""

GENERIC_SYSTEM = SYSTEM + "\n\nThere is no specific motif: write hints that work for ANY story at this phase set in the given environment."

ENVIRONMENTS = ("forest", "sea", "river", "mountains", "village", "town", "palace", "cottage", "market", "underground", "sky", "desert", "garden")


def run(tales_path: Path, out_path: Path, lang: str, limit: int, llm: LLM, generic: bool = True) -> tuple[int, int, int]:
    # (motif, ending texts of its tale) — the tale's endings are what a hint must not spoil.
    units: list[tuple[str | None, str | None, str, list[str], str]] = []  # (motif_id, env, phase, endings, user_prompt)
    for rec in read_jsonl(tales_path, TaleRecord):
        endings = rec.extraction.endings
        for m in rec.motifs:
            if m.type == "ending":
                continue  # hints about the ending motif itself would be spoilers by construction
            for phase in PHASES:
                user = f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironments: {', '.join(m.environments) or 'unspecified'}\nPhase: {phase}"
                units.append((m.id, None, phase, endings, user))
    if generic:
        for env in ENVIRONMENTS:
            for phase in PHASES:
                units.append((None, env, phase, [], f"Environment: {env}\nPhase: {phase}"))

    def key(mid: str | None, env: str | None, phase: str) -> str:
        return f"{mid or ''}|{env or ''}|{phase}"

    done = done_keys(out_path, Hint, lambda h: key(h.motif_id, h.environment_id, h.phase))
    todo = [u for u in units if key(u[0], u[1], u[2]) not in done]
    if limit:
        todo = todo[:limit]
    log(f"hints[{lang}]: {len(units)} (motif,phase) units, {len(done)} done, {len(todo)} to do")
    if not todo:
        return 0, 0, 0

    lang_name = LANG_NAMES.get(lang, lang)
    prompts = [((GENERIC_SYSTEM if mid is None else SYSTEM).format(lang_name=lang_name), user) for mid, _, _, _, user in todo]
    results = llm.batch(prompts, HintsOut)

    ok = failed = dropped = 0
    rows: list[Hint] = []
    for (mid, env, phase, endings, _), res in zip(todo, results):
        if isinstance(res, Exception):
            log(f"  FAIL {key(mid, env, phase)}: {res}")
            failed += 1
            continue
        kept = 0
        for h in res.hints:
            text = h.text.strip()
            v = check_hint(text, lang)
            if not v.ok:
                dropped += 1
                continue
            if any(reveals_ending(text, e, lang) for e in endings):
                dropped += 1
                continue
            rows.append(
                Hint(
                    id=stable_id(mid or "", env or "", phase, lang, text.lower()),
                    motif_id=mid,
                    phase=phase,  # type: ignore[arg-type]
                    environment_id=env,
                    lang=lang,
                    text=text,
                    situation_en=h.situation.strip(),
                )
            )
            kept += 1
        ok += 1
        if kept < 4:
            log(f"  thin {key(mid, env, phase)}: only {kept}/8 survived filters")
    append_jsonl(out_path, rows)
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--lang", required=True)
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/hints.<lang>.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--no-generic", action="store_true", help="skip the per-(phase, environment) fallback hints")
    args = ap.parse_args()
    out = args.out or DATA_DIR / f"hints.{args.lang}.jsonl"
    ok, failed, dropped = run(args.tales, out, args.lang, args.limit, LLM(), generic=not args.no_generic)
    log(f"hints[{args.lang}]: {ok} units ok, {failed} failed, {dropped} hints dropped by filters → {out}")


if __name__ == "__main__":
    main()
