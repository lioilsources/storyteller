"""Stage 3: hint_bank — open-ended nudges per (motif, phase, lang), plus
generic per-(phase, environment) fallbacks (RAG_PLAN §2.2).

Each hint carries a `situation_en`: an English description of the
moment it fits. That, not the hint text, is what gets embedded as the
trigger (transcript ↔ situation matches far better than transcript ↔
hint). Rule filters (one sentence, ≤ 15 words, no closing phrases, no
blatant spoiler of the tale's ending) run here; the LLM spoiler
classifier is a later stage.

Originál napřed (rag.sources): nápověda k motivu z pohádky, jejíž text
máme v --lang, se píše z úryvku toho textu; řádek nese `source`.

    python -m rag.hints --lang cs --limit 10
    python -m rag.hints --lang cs --regen-from-original
"""

from __future__ import annotations

import argparse
from pathlib import Path

from .filters import check_hint, reveals_ending
from .io import CHUNK, DATA_DIR, append_jsonl, log, read_jsonl, stable_id
from .llm import LLM
from .schemas import PHASES, Hint, HintsOut, TaleRecord
from .sources import Job, OriginalResolver, motif_ids, needs_work, sources_by_key
from .verbalize import LANG_NAMES

SYSTEM = """You help a parent who is telling a bedtime story out loud and has just paused, unsure how to go on. You write HINTS in {lang_name}.

A hint is ONE open-ended sentence, at most 15 words, that offers a direction without telling the story for them: it trails off ("…and just then, from the bushes came…"), or asks the child ("…what do you think the fox did next?"). It NEVER completes the plot beat and NEVER reveals or implies how the story ends.

Produce 8 hints for the given motif at the given story phase:
  intro   = the character is being introduced / the world set up
  task    = the hero learns what they must do and sets out
  problem = the obstacle or antagonist appears
  climax  = the hardest moment, before it resolves
  ending  = winding down — hints here invite the child to imagine the aftermath, still without stating the resolution

For each hint also give `situation`: one plain English sentence describing the moment in the telling where it fits (what has just happened, what the parent is stuck on).

LANGUAGE: every `text` is in {lang_name}, written natively for a {lang_name}-speaking child — the examples above are in English only to show the form. `situation` stays in English. Output only JSON matching the schema."""

GENERIC_SYSTEM = SYSTEM + "\n\nThere is no specific motif: write hints that work for ANY story at this phase set in the given environment."

ENVIRONMENTS = ("forest", "sea", "river", "mountains", "village", "town", "palace", "cottage", "market", "underground", "sky", "desert", "garden")


def key(mid: str | None, env: str | None, phase: str) -> str:
    return f"{mid or ''}|{env or ''}|{phase}"


def plan(tales_path: Path, out_path: Path, lang: str, limit: int, resolver: OriginalResolver, regen: bool = False, generic: bool = True, only: frozenset[str] | None = None) -> list[Job]:
    """Volání, která běh udělá. Motivová nápověda z pohádky, jejíž text máme
    v [lang], dostane úryvek originálu (okno podle fáze, bez závěru
    pohádky). Generické nápovědy nemají pohádku → vždy text_en; regen je
    nechá být. Job.extra = (env, phase, endings)."""
    lang_name = LANG_NAMES.get(lang, lang)
    have = sources_by_key(out_path, Hint, lambda h: key(h.motif_id, h.environment_id, h.phase))
    jobs: list[Job] = []
    for rec in read_jsonl(tales_path, TaleRecord):
        endings = rec.extraction.endings  # what a hint must not spoil
        for m in rec.motifs:
            if m.type == "ending":
                continue  # hints about the ending motif itself would be spoilers by construction
            if only is not None and m.id not in only:
                continue
            src = resolver.source_for(m)
            for phase in PHASES:
                k = key(m.id, None, phase)
                if not needs_work(k, have, src, regen):
                    continue
                base = f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironments: {', '.join(m.environments) or 'unspecified'}\nPhase: {phase}\nWrite `text` in: {lang_name}"
                jobs.append(Job(key=k, motif=m, system=resolver.system(SYSTEM.format(lang_name=lang_name), m, lang_name), user=base + resolver.block(m, phase), base_user=base, source=src, extra=(None, phase, endings)))
                if limit and len(jobs) >= limit:
                    return jobs
    if generic and not regen:
        for env in ENVIRONMENTS:
            for phase in PHASES:
                k = key(None, env, phase)
                if k in have:
                    continue
                user = f"Environment: {env}\nPhase: {phase}\nWrite `text` in: {lang_name}"
                jobs.append(Job(key=k, motif=None, system=GENERIC_SYSTEM.format(lang_name=lang_name), user=user, base_user=user, source="text_en", extra=(env, phase, [])))
                if limit and len(jobs) >= limit:
                    return jobs
    return jobs


def run(tales_path: Path, out_path: Path, lang: str, limit: int, llm: LLM, generic: bool = True, resolver: OriginalResolver | None = None, regen: bool = False, only: frozenset[str] | None = None) -> tuple[int, int, int]:
    resolver = resolver or OriginalResolver.load(lang, tales_path=tales_path)
    todo = plan(tales_path, out_path, lang, limit, resolver, regen, generic, only)
    log(f"hints[{lang}]: {len(todo)} units to do ({sum(j.source == 'original' for j in todo)} z originálu{', regen' if regen else ''})")
    if not todo:
        return 0, 0, 0

    ok = failed = dropped = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(j.system, j.user) for j in part], HintsOut)
        rows: list[Hint] = []
        for j, res in zip(part, results):
            env, phase, endings = j.extra
            mid = j.motif.id if j.motif else None
            if isinstance(res, Exception):
                log(f"  FAIL {j.key}: {res}")
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
                        source=j.source,
                    )
                )
                kept += 1
            ok += 1
            if kept < 4:
                log(f"  thin {j.key}: only {kept}/8 survived filters")
        append_jsonl(out_path, rows)
        log(f"hints[{lang}]: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed, {dropped} dropped)")
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--lang", required=True)
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/hints.<lang>.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--no-generic", action="store_true", help="skip the per-(phase, environment) fallback hints")
    ap.add_argument("--regen-from-original", action="store_true", help="přepiš z originálu (motiv, fáze), které už mají nápovědy z text_en (staré zůstanou, build_pack vezme nové)")
    ap.add_argument("--same-motifs-as", type=Path, default=None, help="jen motivy, které má tento JSONL (např. rag/data/hints.cs.jsonl); generické nápovědy zůstávají")
    args = ap.parse_args()
    out = args.out or DATA_DIR / f"hints.{args.lang}.jsonl"
    only = motif_ids(args.same_motifs_as) if args.same_motifs_as else None
    ok, failed, dropped = run(args.tales, out, args.lang, args.limit, LLM(), generic=not args.no_generic, regen=args.regen_from_original, only=only)
    log(f"hints[{args.lang}]: {ok} units ok, {failed} failed, {dropped} hints dropped by filters → {out}")


if __name__ == "__main__":
    main()
