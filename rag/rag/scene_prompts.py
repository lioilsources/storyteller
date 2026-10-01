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


def run(tales_path: Path, out_path: Path, limit: int, llm: LLM) -> tuple[int, int, int]:
    units: list[tuple[str, str | None, str, str]] = []  # (motif_id, env, phase, user)
    for rec in read_jsonl(tales_path, TaleRecord):
        for m in rec.motifs:
            envs = m.environments or [None]  # type: ignore[list-item]
            for env in envs[:2]:  # cap: 2 environments × 5 phases per motif
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
    args = ap.parse_args()
    ok, failed, dropped = run(args.tales, args.out, args.limit, LLM())
    log(f"scene_prompts: {ok} ok, {failed} failed, {dropped} dropped → {args.out}")


if __name__ == "__main__":
    main()
