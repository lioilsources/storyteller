"""Stage 5: scene_prompts — style-neutral English image prompts per
(motif, environment, phase) (RAG_PLAN §2.4). Runtime fills
{character_refs} and wraps with the style's prefix/suffix from the
`styles` registry (MODELS_PLAN §3); the result is the `prompt` input of
the ComfyUI workflow (comfy/README.md).

Language-independent (image prompts are English), so one file:
rag/data/scene_prompts.jsonl.

    python -m rag.scene_prompts --limit 20
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path

from .filters import contains_hard_block, word_count
from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, read_jsonl, stable_id
from .llm import LLM
from .schemas import PHASES, ScenePrompt, ScenePromptOut, TaleRecord

SYSTEM = """You write image-generation prompts for illustrations in a children's bedtime-story app.

Given a story motif, an environment, and the story phase, describe ONE scene in ≤ 60 English words for an image model:
- composition and camera (wide shot / close-up), the hero as the literal slot {character_refs} (write it exactly like that — it is replaced with the character description at runtime), the setting, mood, time of day, weather.
- STYLE-NEUTRAL: no art style words, no medium, no artist or illustrator names, no "illustration of". Style is added later.
- child-safe: no blood, weapons drawn at anyone, gore, or horror; danger is suggested (shadow, distance, expression), never shown.
- no text, letters, logos, or captions in the scene.
The text MUST contain the literal token {character_refs} exactly once, as the hero (e.g. "{character_refs} stands at the well"); a prompt without it is discarded.
Output only JSON matching the schema."""


def titled_ids(cards_path: Path) -> frozenset[str]:
    """Motivy s titulkem v cards.<lang>.jsonl — jen ty pickery ukážou."""
    ids: set[str] = set()
    with cards_path.open(encoding="utf-8") as f:
        for line in f:
            if '"title"' in line:
                r = json.loads(line)
                if r.get("length") == "title" and r.get("text"):
                    ids.add(r["motif_id"])
    return frozenset(ids)


def run(
    tales_path: Path,
    out_path: Path,
    limit: int,
    llm: LLM,
    types: frozenset[str] | None = None,
    envs_per_motif: int = 2,
    per_type: int = 0,
    titled: frozenset[str] | None = None,
) -> tuple[int, int, int]:
    """types/per_type/titled zužují svět na to, co balíček unese: per_type=1
    je 1 motiv od typu na pohádku (pack_check úroveň A), vyšší číslo při
    dalším běhu přidá další motivy (hotové se přeskočí)."""
    units: list[tuple[str, str | None, str, str]] = []  # (motif_id, env, phase, user)
    for rec in read_jsonl(tales_path, TaleRecord):
        taken: dict[str, int] = {}
        for m in rec.motifs:
            if types is not None and m.type not in types:
                continue
            if titled is not None and m.id not in titled:
                continue
            if per_type and taken.get(m.type, 0) >= per_type:
                continue
            taken[m.type] = taken.get(m.type, 0) + 1
            envs = m.environments or [None]  # type: ignore[list-item]
            for env in envs[:envs_per_motif]:  # cap: environments × 5 phases per motif
                for phase in PHASES:
                    user = f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironment: {env or 'unspecified'}\nPhase: {phase}"
                    units.append((m.id, env, phase, user))

    def key(mid: str, env: str | None, phase: str) -> str:
        return f"{mid}|{env or ''}|{phase}"

    done = done_keys(out_path, ScenePrompt, lambda s: key(s.motif_id, s.environment_id, s.phase))
    todo = [u for u in units if key(u[0], u[1], u[2]) not in done]
    if limit:
        todo = todo[:limit]
    log(f"scene_prompts: {len(units)} units, {len(done)} done, {len(todo)} to do")
    if not todo:
        return 0, 0, 0

    prompts = [(SYSTEM, u) for _, _, _, u in todo]
    ok = failed = dropped = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch(prompts[start : start + CHUNK], ScenePromptOut)
        rows: list[ScenePrompt] = []
        for (mid, env, phase, _), res in zip(part, results):
            if isinstance(res, Exception):
                log(f"  FAIL {key(mid, env, phase)}: {res}")
                failed += 1
                continue
            text = " ".join(res.text_en.split())
            if word_count(text) > 70 or contains_hard_block(text, "en") or "{character_refs}" not in text:
                dropped += 1
                continue
            rows.append(ScenePrompt(id=stable_id(mid, env or "", phase), motif_id=mid, environment_id=env, phase=phase, text_en=text))  # type: ignore[arg-type]
            ok += 1
        append_jsonl(out_path, rows)
        log(f"scene_prompts: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed, {dropped} dropped)")
    return ok, failed, dropped


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--out", type=Path, default=DATA_DIR / "scene_prompts.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--types", default="", help="jen tyto typy motivů, čárkou (např. task,problem,ending); prázdné = všechny")
    ap.add_argument("--envs", type=int, default=2, help="prostředí na motiv")
    ap.add_argument("--per-type", type=int, default=0, help="nejvýš N motivů od typu na pohádku (0 = všechny)")
    ap.add_argument("--titled", type=Path, default=None, help="jen motivy s titulkem v tomto cards.<lang>.jsonl")
    args = ap.parse_args()
    types = frozenset(t for t in args.types.split(",") if t) or None
    titled = titled_ids(args.titled) if args.titled else None
    ok, failed, dropped = run(args.tales, args.out, args.limit, LLM(), types=types, envs_per_motif=args.envs, per_type=args.per_type, titled=titled)
    log(f"scene_prompts: {ok} ok, {failed} failed, {dropped} dropped → {args.out}")


if __name__ == "__main__":
    main()
