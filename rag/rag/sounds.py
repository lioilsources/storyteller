"""Zvuky podle postav a děje: každé postavě jeden zvuk z katalogu, každému
úkolu/problému/konci 1–3 zvukové podněty. Model jen vybírá z uzavřeného
seznamu id z rag/audio/catalog.json — nic nevymýšlí, takže každé id má
(nebo po render-audio dostane) svůj m4a v core balíčku.

    python -m rag.sounds assign --tales rag/data/tales.jsonl   # → character_sounds.jsonl
    python -m rag.sounds cues   --tales rag/data/tales.jsonl   # → sound_cues.jsonl
    python -m rag.sounds discover --tales rag/data/tales.jsonl # → sound_discovery.jsonl
    python -m rag.sounds actions  --tales rag/data/tales.jsonl # → sound_actions.jsonl

`discover` katalog neomezuje: sbírá volným textem, co je v motivu slyšet
(dveře, truhla, studna…), aby se z četností dal katalog akcí rozšířit;
teprve potom `cues` přiřazuje id.

`actions` jde ještě o krok dál: čte celý text pohádky, ne jen motiv, a ke
každému úkolu/problému/konci vypíše, co postavy slyšitelně UDĚLAJÍ
(„Honza bouchl do stolu“, „kůň zařehtal“, „hodil kámen do vody“) — s českým
popiskem tlačítka. Atmosféru (vítr, listí) a hlasy postav nechává stranou.
Zvuk z katalogu se k akci přiřazuje až v dalším kroku.

Výstup je jazykově neutrální (id), takže jeden soubor pro všechny jazyky:
    character_sounds.jsonl  {"motif_id", "sound": "creature-fox"}
    sound_cues.jsonl        {"motif_id", "cues": ["action-thunder"], "mood": "tense"}
    sound_actions.jsonl     {"motif_id", "actions": [{"actor", "action_en", "sound_en", "label_cs"}]}
"""

from __future__ import annotations

import argparse
import json
import re
from pathlib import Path
from typing import Literal

from pydantic import BaseModel, Field, create_model

from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, read_jsonl
from .llm import LLM
from .schemas import TaleRecord
from .sources import TaleSource

AUDIO_CATALOG = Path(__file__).resolve().parents[1] / "audio" / "catalog.json"
CUE_TYPES = ("task", "problem", "ending")
# ~4k tokens of tale text per call (same cap as rag.extract); the few longer tales get truncated.
MAX_TALE_CHARS = 16000

ACTIONS_SYSTEM = """A parent is telling a children's bedtime story out loud; the app lets them tap a button to play one short sound effect at the right moment. You read the WHOLE tale and, for each listed story moment (a task, a problem or the ending), list the things characters audibly DO in that moment of the tale.

Rules:
- An action is something a character or animal physically does that makes a sound a child would recognise with eyes closed: slams a fist on the table, mounts a horse that neighs, throws a stone into the water, breaks a jug, knocks on the door, chops a tree, the dog barks at him.
- NOT actions: anything done with the voice (speaking, shouting, crying, singing, laughing, calling), looking, thinking, feeling, kissing, sitting, reaching, holding, walking into a room (unless steps on a notable surface), and weather or scenery (wind, leaves, a crackling fire are not actions).
- Violence stays gentle: the sound of the thing, never of a body — "sword clashing", "axe striking wood", not cutting flesh, not a body falling.
- Take actions only from the tale text, from the part of the story the moment covers. Do not invent.
- 0 to 4 actions per moment, in story order, each listed once. Fewer is better than padding: a moment with no clearly audible action gets an empty list.
- `actor`: who does it, as the tale names them (English, short).
- `action_en`: the action in plain English, 3–8 words.
- `sound_en`: what is heard, 2–6 words, concrete ("fist thumping wooden table", "horse neighing", "stone splashing into water").
- `label_cs`: the button label in Czech, one short past-tense sentence of 2–5 words naming the actor as a Czech parent would ("Honza bouchl do stolu", "Kůň zařehtal", "Hodil kámen do vody"). Natural Czech, no quotation marks.
Output only JSON matching the schema."""

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


class SoundAction(BaseModel):
    actor: str = Field(description="Who does it, as the tale names them. English, short.")
    action_en: str = Field(description="The audible action in plain English, 3–8 words.")
    sound_en: str = Field(description="What is heard, 2–6 words, concrete.")
    label_cs: str = Field(description="Czech button label: one short past-tense sentence, 2–5 words, naming the actor.")


class SoundActions(BaseModel):
    motif_id: str
    actions: list[SoundAction]


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


HEARD_RULE = """

Each motif comes with `Heard`: the sounds found in that moment of the story. Pick ONLY catalog sounds that are the same sound as one of the `Heard` items (a door for a door, not a gate for a chest), at most one per item, in the order of `Heard`. If nothing in the list is the same sound, pick the single closest one and stop. Never add wind, steps or any other sound that `Heard` does not mention."""


def cues(tales_path: Path, out_path: Path, limit: int, llm: LLM, catalog: dict | None = None, heard_path: Path | None = None) -> tuple[int, int]:
    c = catalog or load_catalog()
    actions = c["sfx"]["actions"]
    Cues = create_model(
        "Cues",
        cues=(list[Literal[tuple(actions)]], Field(min_length=1, max_length=3, description="1–3 sound keys, most fitting first.")),  # type: ignore[valid-type]
        mood=(Literal[tuple(c["music"]["moods"])], Field(description="Mood of the background music.")),  # type: ignore[valid-type]
    )
    system = CUES_SYSTEM.format(options=options(actions))
    heard: dict[str, list[str]] = {}
    if heard_path is not None:
        heard = {r.motif_id: r.sounds for r in read_jsonl(heard_path, DiscoveredSounds)}
        system += HEARD_RULE

    def user(m) -> str:  # noqa: ANN001
        base = f"Motif type: {m.type}\nMotif: {m.text_en}\nTags: {', '.join(m.tags)}\nEnvironments: {', '.join(m.environments) or 'unspecified'}"
        return base + (f"\nHeard: {'; '.join(heard[m.id])}" if heard.get(m.id) else "")

    done = done_keys(out_path, SoundCues, lambda r: r.motif_id)
    todo = [m for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.type in CUE_TYPES and m.id not in done]
    if limit:
        todo = todo[:limit]
    log(f"sounds cues: {len(todo)} motifs to do, {len(done)} done")
    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        results = llm.batch([(system, user(m)) for m in part], Cues)
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


def actions(tales_path: Path, out_path: Path, limit: int, llm: LLM, sources_path: Path, root: Path) -> tuple[int, int]:
    """One call per tale: the whole text plus its task/problem/ending motifs →
    the audible actions of each motif. Tales whose text is not on disk are skipped."""
    sources = {s.source_ref: s for s in read_jsonl(sources_path, TaleSource) if s.path}
    done = done_keys(out_path, SoundActions, lambda r: r.motif_id)
    todo: list[tuple[TaleRecord, Path]] = []
    no_text = 0
    for rec in read_jsonl(tales_path, TaleRecord):
        if all(m.id in done for m in rec.motifs if m.type in CUE_TYPES):
            continue
        src = sources.get(rec.source_ref)
        if src is None or not (root / src.path).exists():
            no_text += 1
            continue
        todo.append((rec, root / src.path))
    if limit:
        todo = todo[:limit]
    log(f"sounds actions: {len(todo)} tales to do, {no_text} without text on disk")

    def prompt(rec: TaleRecord, path: Path) -> tuple[str, str, type[BaseModel]]:
        motifs = [m for m in rec.motifs if m.type in CUE_TYPES]
        ids = tuple(m.id for m in motifs)
        Item = create_model(
            "Item",
            motif_id=(Literal[ids], Field(description="Id of the story moment.")),  # type: ignore[valid-type]
            actions=(list[SoundAction], Field(max_length=4, description="0–4 audible actions in story order.")),
        )
        Out = create_model("Out", moments=(list[Item], Field(description="One item per listed story moment, in the given order.")))  # type: ignore[valid-type]
        text = path.read_text(encoding="utf-8", errors="replace")[:MAX_TALE_CHARS]
        lines = [f"Tale: {rec.title}", "Characters: " + "; ".join(rec.extraction.characters), "", "Story moments:"]
        lines += [f"- {m.id} ({m.type}): {m.text_en}" for m in motifs]
        lines += ["", "Tale text:", text]
        return ACTIONS_SYSTEM, "\n".join(lines), Out

    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        prompts = [prompt(rec, path) for rec, path in part]
        # Each tale has its own schema (its motif ids), so llm.batch's one-schema signature doesn't fit.
        results = _batch_mixed(llm, prompts)
        rows: list[SoundActions] = []
        for (rec, _), res in zip(part, results):
            if isinstance(res, Exception):
                log(f"  FAIL {rec.source_ref}: {res}")
                failed += 1
                continue
            got = {item.motif_id: item.actions for item in res.moments}  # type: ignore[attr-defined]
            seen: set[str] = set()  # the same action listed under two motifs of one tale stays with the first
            for m in rec.motifs:
                if m.type in CUE_TYPES and m.id not in done:
                    kept = []
                    for a in got.get(m.id, []):
                        key = a.label_cs.strip().lower()
                        if key in seen or _is_voice(a):
                            continue
                        seen.add(key)
                        kept.append(SoundAction(**a.model_dump()))
                    rows.append(SoundActions(motif_id=m.id, actions=kept))
            ok += 1
        append_jsonl(out_path, rows)
        log(f"sounds actions: {start + len(part)}/{len(todo)} tales done ({ok} ok, {failed} failed)")
    return ok, failed


RATE_SYSTEM = """A children's bedtime-story app plays a short sound effect when the parent taps a button. For each listed action, judge whether it makes a sound that a child would clearly recognise with eyes closed.
- 2: clear, distinct sound (axe chopping wood, door slamming, horse neighing, stone splashing into water, coins clinking).
- 1: faint or vague sound (fabric rustling, footsteps on the ground, someone sitting down).
- 0: no real sound, or only a voice, or a sound of a body being hurt (kissing, hugging, kneeling, looking, walking up to someone, a body falling, cutting flesh).
Output only JSON matching the schema."""


class RatedAction(SoundAction):
    audible: int = Field(ge=0, le=2)


class RatedActions(BaseModel):
    motif_id: str
    actions: list[RatedAction]


def rate(actions_path: Path, tales_path: Path, out_path: Path, limit: int, llm: LLM) -> tuple[int, int]:
    """Second, cheap pass over sound_actions.jsonl: one call per tale scores every action 0–2."""
    acts = {r.motif_id: r.actions for r in read_jsonl(actions_path, SoundActions)}
    done = done_keys(out_path, RatedActions, lambda r: r.motif_id)
    todo: list[list[str]] = []
    for rec in read_jsonl(tales_path, TaleRecord):
        ids = [m.id for m in rec.motifs if m.type in CUE_TYPES and m.id in acts and m.id not in done]
        if ids:
            todo.append(ids)
    if limit:
        todo = todo[:limit]
    log(f"sounds rate: {len(todo)} tales to do")

    def prompt(ids: list[str]) -> tuple[str, str, type[BaseModel]]:
        flat = [a for i in ids for a in acts[i]]
        Out = create_model("Out", scores=(list[Literal[0, 1, 2]], Field(min_length=len(flat), max_length=len(flat), description="One score per action, in the given order.")))  # type: ignore[valid-type]
        lines = [f"{n}. {a.actor}: {a.action_en} — heard: {a.sound_en}" for n, a in enumerate(flat, 1)]
        return RATE_SYSTEM, "Actions:\n" + "\n".join(lines), Out

    ok = failed = 0
    for start in range(0, len(todo), CHUNK):
        part = todo[start : start + CHUNK]
        prompts = [prompt(ids) for ids in part]
        # A tale with no actions at all needs no call.
        results = _batch_mixed(llm, [p for p, ids in zip(prompts, part) if any(acts[i] for i in ids)])
        it = iter(results)
        rows: list[RatedActions] = []
        for ids in part:
            res = next(it) if any(acts[i] for i in ids) else None
            if isinstance(res, Exception):
                log(f"  FAIL {ids[0]}: {res}")
                failed += 1
                continue
            scores = iter(res.scores if res is not None else [])  # type: ignore[attr-defined]
            for i in ids:
                rows.append(RatedActions(motif_id=i, actions=[RatedAction(**a.model_dump(), audible=next(scores)) for a in acts[i]]))
            ok += 1
        append_jsonl(out_path, rows)
        log(f"sounds rate: {start + len(part)}/{len(todo)} tales done ({ok} ok, {failed} failed)")
    return ok, failed


MATCH_SYSTEM = """A children's story app has a fixed library of short sound effects. For each action, pick the library sound that IS the same sound (a door slam for a door slam, not a chest lid for a door), or "none" when no candidate is the same sound. A close-enough generic match is fine (any splash into water → splash; any horse hooves → gallop; knocking on any door → knock). Output only JSON matching the schema."""

# Character-role sounds never stand for an action; animals and magical beings may (horse neighing → creature-horse).
PEOPLE = frozenset(
    "king queen prince princess hero-boy hero-girl child old-man old-woman mother father stepmother siblings soldier knight hunter farmer "
    "shepherd fisherman craftsman merchant thief servant trickster wizard fairy dwarf ghost holy-man musician monster mermaid god villager "
    "witch devil giant".split()
)
MATCH_GROUP = 12  # actions per call


class MatchedAction(RatedAction):
    sound: str  # catalog id, "" when the catalog has nothing alike


class MatchedActions(BaseModel):
    motif_id: str
    actions: list[MatchedAction]


def match(rated_path: Path, out_path: Path, llm: LLM, min_audible: int = 1, k: int = 8, catalog: dict | None = None) -> tuple[int, int]:
    """Each action with audible ≥ min_audible gets a catalog sound: e5 embeddings
    shortlist k candidates, the LLM picks the same sound or none."""
    from sentence_transformers import SentenceTransformer

    from .embed import DEFAULT_MODEL

    c = catalog or load_catalog()
    sounds = [(f"action-{key}", e["prompt"]) for key, e in c["sfx"]["actions"].items()]
    sounds += [(f"creature-{key}", e["prompt"]) for key, e in c["sfx"]["creatures"].items() if key not in PEOPLE]
    rows = [r for r in read_jsonl(rated_path, RatedActions)]
    flat = [(ri, ai) for ri, r in enumerate(rows) for ai, a in enumerate(r.actions) if a.audible >= min_audible]
    log(f"sounds match: {len(flat)} actions (audible ≥ {min_audible}), {len(sounds)} catalog sounds")

    model = SentenceTransformer(DEFAULT_MODEL)
    sv = model.encode([f"passage: {p}" for _, p in sounds], normalize_embeddings=True)
    av = model.encode([f"query: {rows[ri].actions[ai].sound_en}" for ri, ai in flat], normalize_embeddings=True)
    cands = [[sounds[i] for i in row.argsort()[::-1][:k]] for row in av @ sv.T]

    groups = [list(range(s, min(s + MATCH_GROUP, len(flat)))) for s in range(0, len(flat), MATCH_GROUP)]
    prompts = []
    for g in groups:
        ids = tuple(sorted({sid for n in g for sid, _ in cands[n]} | {"none"}))
        Out = create_model("Out", picks=(list[Literal[ids]], Field(min_length=len(g), max_length=len(g))))  # type: ignore[valid-type]
        lines = []
        for j, n in enumerate(g, 1):
            a = rows[flat[n][0]].actions[flat[n][1]]
            lines.append(f"{j}. {a.action_en} — heard: {a.sound_en}\n   candidates: " + "; ".join(f"{sid} ({p})" for sid, p in cands[n]))
        prompts.append((MATCH_SYSTEM, "\n".join(lines), Out))
    results = _batch_mixed(llm, prompts)

    picked: dict[tuple[int, int], str] = {}
    ok = failed = 0
    for g, res in zip(groups, results):
        if isinstance(res, Exception):
            log(f"  FAIL group at {g[0]}: {res}")
            failed += 1
            continue
        for n, p in zip(g, res.picks):  # type: ignore[attr-defined]
            picked[flat[n]] = "" if p == "none" else p
        ok += 1
    out = [
        MatchedActions(motif_id=r.motif_id, actions=[MatchedAction(**a.model_dump(), sound=picked[(ri, ai)]) for ai, a in enumerate(r.actions) if (ri, ai) in picked])
        for ri, r in enumerate(rows)
    ]
    out_path.write_text("".join(m.model_dump_json() + "\n" for m in out), encoding="utf-8")
    log(f"sounds match: {sum(1 for v in picked.values() if v)} matched, {sum(1 for v in picked.values() if not v)} none")
    return ok, failed


# The model keeps slipping voices in despite the rules; the app never plays speech.
_VOICE = re.compile(r"\b(voices?|speak\w*|speech|talk\w*|shout\w*|scream\w*|yell\w*|cry|cries|crying|weep\w*|sob\w*|sing\w*|songs?|laugh\w*|giggl\w*|call\w*|whisper\w*|pray\w*|curs\w*|words|sigh\w*|silence)\b")


def _is_voice(a: SoundAction) -> bool:
    return _VOICE.search(f"{a.sound_en} {a.action_en}".lower()) is not None


def _batch_mixed(llm: LLM, prompts: list[tuple[str, str, type[BaseModel]]]) -> list[BaseModel | Exception]:
    """llm.batch with a different schema per item."""
    import asyncio

    sem = asyncio.Semaphore(llm.concurrency)

    async def one(system: str, user: str, schema: type[BaseModel]) -> BaseModel | Exception:
        async with sem:
            try:
                return await asyncio.to_thread(llm.chat, system, user, schema)
            except Exception as e:  # noqa: BLE001 — surfaced to the caller per item
                return e

    async def run() -> list[BaseModel | Exception]:
        return await asyncio.gather(*(one(s, u, o) for s, u, o in prompts))

    return asyncio.run(run())


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("stage", choices=("assign", "cues", "discover", "actions", "rate", "match"))
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--out", type=Path, default=None, help="default rag/data/character_sounds.jsonl / sound_cues.jsonl / sound_actions.jsonl")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--heard", type=Path, default=None, help="cues: sound_discovery.jsonl — vybírat jen zvuky, které sběr u motivu našel (žádná výplň)")
    ap.add_argument("--sources", type=Path, default=DATA_DIR / "tale_sources.jsonl", help="actions: kde leží text pohádky")
    ap.add_argument("--root", type=Path, default=Path(__file__).resolve().parents[2], help="actions: kořen repa, vůči němuž jsou cesty v --sources")
    ap.add_argument("--actions", type=Path, default=DATA_DIR / "sound_actions.jsonl", help="rate: výstup kroku actions")
    ap.add_argument("--rated", type=Path, default=DATA_DIR / "sound_actions.rated.jsonl", help="match: výstup kroku rate")
    ap.add_argument("--min-audible", type=int, default=1, help="match: nejnižší známka akce, která do nabídky smí")
    args = ap.parse_args()
    if args.stage == "match":
        out = args.out or DATA_DIR / "sound_actions.matched.jsonl"
        ok, failed = match(args.rated, out, LLM(max_tokens=600, temperature=0.0), args.min_audible)
    elif args.stage == "rate":
        out = args.out or DATA_DIR / "sound_actions.rated.jsonl"
        ok, failed = rate(args.actions, args.tales, out, args.limit, LLM(max_tokens=800, temperature=0.0))
    elif args.stage == "actions":
        out = args.out or DATA_DIR / "sound_actions.jsonl"
        ok, failed = actions(args.tales, out, args.limit, LLM(max_tokens=4000, temperature=0.2), args.sources, args.root)
    elif args.stage == "assign":
        out = args.out or DATA_DIR / "character_sounds.jsonl"
        ok, failed = assign(args.tales, out, args.limit, LLM(max_tokens=60, temperature=0.0))
    elif args.stage == "discover":
        out = args.out or DATA_DIR / "sound_discovery.jsonl"
        ok, failed = discover(args.tales, out, args.limit, LLM(max_tokens=120, temperature=0.2))
    else:
        out = args.out or DATA_DIR / "sound_cues.jsonl"
        ok, failed = cues(args.tales, out, args.limit, LLM(max_tokens=120, temperature=0.0), heard_path=args.heard)
    log(f"sounds {args.stage}: {ok} ok, {failed} failed → {out}")


if __name__ == "__main__":
    main()
