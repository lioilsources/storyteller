"""Zvuky podle postav a děje: každé postavě jeden zvuk z katalogu, každému
úkolu/problému/konci 1–3 zvukové podněty. Model jen vybírá z uzavřeného
seznamu id z rag/audio/catalog.json — nic nevymýšlí, takže každé id má
(nebo po render-audio dostane) svůj m4a v core balíčku.

    python -m rag.sounds assign --tales rag/data/tales.jsonl   # → character_sounds.jsonl
    python -m rag.sounds cues   --tales rag/data/tales.jsonl   # → sound_cues.jsonl
    python -m rag.sounds discover --tales rag/data/tales.jsonl # → sound_discovery.jsonl

`discover` katalog neomezuje: sbírá volným textem, co je v motivu slyšet
(dveře, truhla, studna…), aby se z četností dal katalog akcí rozšířit;
teprve potom `cues` přiřazuje id.

Výstup je jazykově neutrální (id), takže jeden soubor pro všechny jazyky:
    character_sounds.jsonl  {"motif_id", "sound": "creature-fox"}
    sound_cues.jsonl        {"motif_id", "cues": ["action-thunder"], "mood": "tense"}
"""

from __future__ import annotations

import argparse
import json
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field, create_model

from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, read_jsonl
from .llm import LLM
from .schemas import TaleRecord

AUDIO_CATALOG = Path(__file__).resolve().parents[1] / "audio" / "catalog.json"
CUE_TYPES = ("task", "problem", "ending")

ASSIGN_SYSTEM = """A children's bedtime-story app plays one short non-verbal sound when a character enters the story. Pick the ONE sound from the list that fits the character best.
- An animal or a magical being gets its own sound when the list has it; otherwise the closest one.
- A person gets the sound of their role (king, old-woman, soldier, craftsman …); family words (mother, youngest son, sister) only when no role fits.
- Judge by WHO the character is, not by what they own or meet: "a king who owns a golden horse" is king.
- `villager` is the last resort for a person nothing else fits.

Sounds:
{options}

Output only JSON matching the schema."""

CUES_SYSTEM = """A children's bedtime-story app offers a parent a few sound effects while they tell one part of a story. For the given story motif pick 1 to 3 sounds from the list that could really be heard in that moment, most fitting first, and the mood of the background music.
- Pick only what the motif itself suggests (a storm, a door, a gallop, a spell); do not pad to three.
- mood: `calm` for warm, safe, happy moments; `tense` for danger, mystery, trickery.

Sounds:
{options}

Output only JSON matching the schema."""


DISCOVER_SYSTEM = """A parent is telling a children's bedtime story out loud. For the given story motif list 1 to 3 short sound effects that would really be heard at that moment — things happening (a door closing, a chest opening, an axe chopping, a bucket in a well) or the place itself (a market crowd, a crackling hearth, a creaking mill).
- English, 2–5 words each, a concrete physical sound: "heavy door creaking shut", not "tension" or "sadness".
- No speech, no singing words, no music, no animal or character voices (those come from elsewhere).
- Only what this motif suggests; do not pad to three.
Output only JSON matching the schema."""


class DiscoverOut(BaseModel):
    sounds: list[str] = Field(min_length=1, max_length=3, description="1–3 short concrete sound effects, English, 2–5 words each.")


class DiscoveredSounds(BaseModel):
    motif_id: str
    sounds: list[str]


class CharacterSound(BaseModel):
    motif_id: str
    sound: str


class SoundCues(BaseModel):
    motif_id: str
    cues: list[str]
    mood: str


def load_catalog(path: Path = AUDIO_CATALOG) -> dict:
    return json.loads(path.read_text(encoding="utf-8"))


def options(section: dict) -> str:
    return "\n".join(f"- {k}: {e['prompt']}" for k, e in section.items())


def assign(tales_path: Path, out_path: Path, limit: int, llm: LLM, catalog: dict | None = None) -> tuple[int, int]:
    creatures = (catalog or load_catalog())["sfx"]["creatures"]
    keys = tuple(creatures)
    Pick = create_model("Pick", key=(Literal[keys], Field(description="Key of the chosen sound.")))  # type: ignore[valid-type]
    system = ASSIGN_SYSTEM.format(options=options(creatures))

    done = done_keys(out_path, CharacterSound, lambda r: r.motif_id)
    todo = [m for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.type == "character" and m.id not in done]
    if limit:
        todo = todo[:limit]
    log(f"sounds assign: {len(todo)} characters to do, {len(done)} done")
    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(system, f"Character: {m.text_en}\nTags: {', '.join(m.tags)}") for m in part], Pick)
        rows: list[CharacterSound] = []
        for m, res in zip(part, results):
            if isinstance(res, Exception):
                log(f"  FAIL {m.id}: {res}")
                failed += 1
                continue
            rows.append(CharacterSound(motif_id=m.id, sound=f"creature-{res.key}"))  # type: ignore[attr-defined]
            ok += 1
        append_jsonl(out_path, rows)
        log(f"sounds assign: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def cues(tales_path: Path, out_path: Path, limit: int, llm: LLM, catalog: dict | None = None) -> tuple[int, int]:
    c = catalog or load_catalog()
    actions = c["sfx"]["actions"]
    Cues = create_model(
        "Cues",
        cues=(list[Literal[tuple(actions)]], Field(min_length=1, max_length=3, description="1–3 sound keys, most fitting first.")),  # type: ignore[valid-type]
        mood=(Literal[tuple(c["music"]["moods"])], Field(description="Mood of the background music.")),  # type: ignore[valid-type]
    )
    system = CUES_SYSTEM.format(options=options(actions))

    done = done_keys(out_path, SoundCues, lambda r: r.motif_id)
    todo = [m for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.type in CUE_TYPES and m.id not in done]
    if limit:
        todo = todo[:limit]
    log(f"sounds cues: {len(todo)} motifs to do, {len(done)} done")
    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(system, f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironments: {', '.join(m.environments) or 'unspecified'}") for m in part], Cues)
        rows: list[SoundCues] = []
        for m, res in zip(part, results):
            if isinstance(res, Exception):
                log(f"  FAIL {m.id}: {res}")
                failed += 1
                continue
            picked = list(dict.fromkeys(res.cues))  # type: ignore[attr-defined]
            rows.append(SoundCues(motif_id=m.id, cues=[f"action-{k}" for k in picked], mood=res.mood))  # type: ignore[attr-defined]
            ok += 1
        append_jsonl(out_path, rows)
        log(f"sounds cues: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def discover(tales_path: Path, out_path: Path, limit: int, llm: LLM) -> tuple[int, int]:
    done = done_keys(out_path, DiscoveredSounds, lambda r: r.motif_id)
    todo = [m for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.type in CUE_TYPES and m.id not in done]
    if limit:
        todo = todo[:limit]
    log(f"sounds discover: {len(todo)} motifs to do, {len(done)} done")
    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(DISCOVER_SYSTEM, f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironments: {', '.join(m.environments) or 'unspecified'}") for m in part], DiscoverOut)
        rows: list[DiscoveredSounds] = []
        for m, res in zip(part, results):
            if isinstance(res, Exception):
                log(f"  FAIL {m.id}: {res}")
                failed += 1
                continue
            rows.append(DiscoveredSounds(motif_id=m.id, sounds=[" ".join(x.lower().split()) for x in res.sounds if x.strip()]))
            ok += 1
        append_jsonl(out_path, rows)
        log(f"sounds discover: {start + len(part)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("stage", choices=("assign", "cues", "discover"))
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/character_sounds.jsonl / sound_cues.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    args = ap.parse_args()
    if args.stage == "assign":
        out = args.out or DATA_DIR / "character_sounds.jsonl"
        ok, failed = assign(args.tales, out, args.limit, LLM(max_tokens=60, temperature=0.0))
    elif args.stage == "discover":
        out = args.out or DATA_DIR / "sound_discovery.jsonl"
        ok, failed = discover(args.tales, out, args.limit, LLM(max_tokens=120, temperature=0.2))
    else:
        out = args.out or DATA_DIR / "sound_cues.jsonl"
        ok, failed = cues(args.tales, out, args.limit, LLM(max_tokens=120, temperature=0.0))
    log(f"sounds {args.stage}: {ok} ok, {failed} failed → {out}")


if __name__ == "__main__":
    main()
