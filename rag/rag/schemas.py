"""Pydantic schemas for every LLM output and every JSONL record.

The LLM is asked for these shapes via JSON-schema structured output
(rag.llm), and the same models validate what comes back — so a small
local model that ignores the schema fails loudly here instead of
poisoning a pack. Field docs double as the prompt's field descriptions.
"""

from __future__ import annotations

from typing import Literal

from pydantic import BaseModel, ConfigDict, Field, field_validator

MotifType = Literal["character", "task", "problem", "ending"]
Phase = Literal["intro", "task", "problem", "climax", "ending"]
AgeBand = Literal["0-3", "3-6", "6-10"]
Tone = Literal["neutral", "playful"]
Length = Literal["title", "sentence"]

PHASES: tuple[Phase, ...] = ("intro", "task", "problem", "climax", "ending")
AGE_BANDS: tuple[AgeBand, ...] = ("0-3", "3-6", "6-10")


def _clean_list(items: list[str]) -> list[str]:
    out: list[str] = []
    seen: set[str] = set()
    for s in items:
        s = " ".join(s.split())
        if s and s.lower() not in seen:
            seen.add(s.lower())
            out.append(s)
    return out


# ---------------------------------------------------------------------
# extract (PLAN §3.2 classify+extract, plus environments/creatures §1.1c)
# ---------------------------------------------------------------------


class CreatureOut(BaseModel):
    name_en: str = Field(description="Generic creature or folk figure, e.g. 'owl', 'water sprite'. No proper names.")
    environment: str = Field(description="One of the environments listed for this tale.")


def _all_required(schema: dict) -> None:
    """Make every property required in the JSON schema the model sees.

    Guided decoding treats a property outside `required` as optional, and
    swarm-director (Nemotron-3-Super) then simply leaves it out: on
    2026-09-26 all 567 extracted tales came back without atu_code,
    country_code, age_min and soft, which validated silently to their
    defaults (every tale "not soft", "age 0"). Defaults stay for validation;
    only the schema sent to the model demands every field.
    """
    schema["required"] = list(schema.get("properties", {}))


class TaleClassification(BaseModel):
    """Per-tale classification — the part of extraction that gates content
    (age bands, softening) and colours the globe (country)."""

    model_config = ConfigDict(json_schema_extra=_all_required)

    atu_code: str = Field("", description="Best-guess Aarne-Thompson-Uther type, e.g. 'ATU 333', or '' if unsure.")
    country_code: str = Field("", description="ISO 3166-1 alpha-2 of the tale's tradition of origin (DE for Grimm, DK for Andersen, FR for Perrault) — not the translation's language.")
    age_min: int = Field(0, description="0, 3, or 6 — youngest age the tale's content is fine for as-is.")
    soft: bool = Field(False, description="True if the tale contains violence, death, or peril a retelling for young children should soften.")

    @field_validator("age_min", mode="after")
    @classmethod
    def _age(cls, v: int) -> int:
        return 6 if v >= 6 else 3 if v >= 3 else 0

    @field_validator("country_code", mode="after")
    @classmethod
    def _cc(cls, v: str) -> str:
        v = v.strip().upper()
        return v if len(v) == 2 and v.isalpha() else ""


class MotifExtraction(TaleClassification):
    """Everything the LLM extracts from one public-domain tale."""

    characters: list[str] = Field(default_factory=list, description="1-4 archetype sentences, reusable across retellings, no proper names.")
    tasks: list[str] = Field(default_factory=list, description="1-3 sentences: what the hero must accomplish.")
    problems: list[str] = Field(default_factory=list, description="1-3 sentences: obstacle / antagonist / dilemma.")
    endings: list[str] = Field(default_factory=list, description="1-2 sentences: how it resolves happily.")
    tags: list[str] = Field(default_factory=list, description="3-8 lowercase keywords: setting, creatures, themes.")
    environments: list[str] = Field(default_factory=list, description="Settings the tale moves through: forest, sea, desert, mountains, steppe, village, town, palace, underground, sky, river, cottage, market…")
    creatures: list[CreatureOut] = Field(default_factory=list, description="Creatures and folk figures that appear, each tied to one of the environments.")

    @field_validator("characters", "tasks", "problems", "endings", "tags", "environments", mode="after")
    @classmethod
    def _dedupe(cls, v: list[str]) -> list[str]:
        return _clean_list(v)


class Motif(BaseModel):
    """One row of `motifs` — the unit everything downstream keys on.

    id is deterministic: sha256(source_ref, type, text_en)[:16], so re-running
    extract on the same tale yields the same ids and downstream stages can
    resume instead of regenerating.
    """

    id: str
    type: MotifType
    text_en: str
    tags: list[str] = []
    atu_code: str = ""
    country_code: str = ""
    region_code: str = ""
    age_min: int = 0
    soft: bool = False
    source_ref: str
    environments: list[str] = []


class TaleRecord(BaseModel):
    """extract's JSONL record: one tale's classification + its motifs."""

    source_ref: str
    title: str
    extraction: MotifExtraction
    motifs: list[Motif]


class ClassifyRecord(BaseModel):
    """classify's JSONL record — a separate pass over already extracted tales."""

    source_ref: str
    classification: TaleClassification
    model: str = ""


# ---------------------------------------------------------------------
# verbalize (RAG_PLAN §2.1)
# ---------------------------------------------------------------------


class VerbalizationVariant(BaseModel):
    age_band: AgeBand
    tone: Tone
    length: Length
    text: str = Field(description="title: 2-5 words. sentence: exactly one sentence, ≤ 20 words. In the requested language, locally natural names/realia.")


class VerbalizeOut(BaseModel):
    variants: list[VerbalizationVariant]


class Verbalization(BaseModel):
    """One row of `verbalizations`."""

    motif_id: str
    lang: str
    age_band: AgeBand
    tone: Tone
    length: Length
    text: str


# ---------------------------------------------------------------------
# hint_bank (RAG_PLAN §2.2)
# ---------------------------------------------------------------------


class HintOut(BaseModel):
    text: str = Field(description="ONE open-ended sentence, ≤ 15 words, in the requested language. Offers a direction, never completes the plot, never reveals the ending. Often trails off with '…' or asks the child a question.")
    situation: str = Field(description="One neutral sentence in English describing the moment in the telling where this hint fits (what has just happened, what the parent seems stuck on). Used for retrieval, not shown.")


class HintsOut(BaseModel):
    hints: list[HintOut]


class Hint(BaseModel):
    """One row of `hint_bank` (+ its trigger text, embedded later)."""

    id: str
    motif_id: str | None
    phase: Phase
    environment_id: str | None
    lang: str
    text: str
    situation_en: str
    weight: float = 1.0


# ---------------------------------------------------------------------
# transitions (RAG_PLAN §2.3)
# ---------------------------------------------------------------------


class TransitionOut(BaseModel):
    tags: list[str] = Field(description="1-3 lowercase tags from the given list this transition suits (e.g. forest, sea, king).")
    text: str = Field(description="A connective phrase leading into the next beat, ≤ 12 words, ends with '…' or ','. In the requested language.")


class TransitionsOut(BaseModel):
    transitions: list[TransitionOut]


class Transition(BaseModel):
    from_type: MotifType
    to_type: MotifType
    tags: list[str]
    lang: str
    text: str


# ---------------------------------------------------------------------
# scene_prompts (RAG_PLAN §2.4)
# ---------------------------------------------------------------------


class ScenePromptOut(BaseModel):
    text_en: str = Field(description="Style-neutral description of the scene in English for an image model: composition, characters (use the slot {character_refs} where the hero appears), setting, mood, time of day. No style words, no artist names, no text/logos. ≤ 60 words.")


class ScenePrompt(BaseModel):
    id: str
    motif_id: str
    environment_id: str | None
    phase: Phase
    text_en: str
