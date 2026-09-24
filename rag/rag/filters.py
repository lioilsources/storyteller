"""Rule-based guards baked in at generation time (RAG_PLAN §0.4, PLAN §7).

These are the cheap, deterministic half of the filter stage. The LLM
classifier half (spoiler-vs-chosen-ending, cultural sensitivity) comes
later; nothing here is meant to be clever, just to make the obvious
failures impossible to ship:

  - a hint is one sentence, ≤ 15 words, and does not read like a
    completed plot beat;
  - a hint does not reveal the ending it's paired with;
  - a text meant for 0–6 contains none of the hard-blocked words.
"""

from __future__ import annotations

import re
from dataclasses import dataclass

# Sentence terminators. An ellipsis at the end is fine — hints are
# supposed to trail off.
_SENTENCE_END = re.compile(r"[.!?](?=\s+\S)")

# Hard-blocked in anything shown to 0–6 (PLAN §7). Intentionally short and
# blunt; the LLM classifier handles nuance. Per language, lowercase, matched
# on word boundaries.
HARD_BLOCK: dict[str, tuple[str, ...]] = {
    "en": ("kill", "killed", "blood", "corpse", "murder", "stab", "gun", "torture", "suicide"),
    "cs": ("zabil", "zabít", "zabije", "krev", "mrtvola", "vražda", "bodl", "pistole", "mučení", "sebevražda"),
    "sk": ("zabil", "zabiť", "krv", "mŕtvola", "vražda", "bodol", "pištoľ", "mučenie", "samovražda"),
    "de": ("töten", "getötet", "blut", "leiche", "mord", "erstochen", "pistole", "folter", "selbstmord"),
    "pl": ("zabił", "zabić", "krew", "trup", "morderstwo", "dźgnął", "pistolet", "tortury", "samobójstwo"),
}

# Words that mark a hint as *closing* the plot rather than opening it.
_CLOSING = {
    "en": ("and they lived", "happily ever after", "the end", "finally", "in the end"),
    "cs": ("žili šťastně", "až do smrti", "a byl konec", "nakonec", "zazvonil zvonec"),
    "sk": ("žili šťastne", "až do smrti", "a bol koniec", "nakoniec"),
    "de": ("und wenn sie nicht gestorben", "am ende", "schließlich", "glücklich bis"),
    "pl": ("żyli długo i szczęśliwie", "koniec", "w końcu", "ostatecznie"),
}


@dataclass(frozen=True)
class Verdict:
    ok: bool
    reason: str = ""


def word_count(text: str) -> int:
    return len(re.findall(r"\w+(?:[-'’]\w+)*", text, flags=re.UNICODE))


def is_single_sentence(text: str) -> bool:
    """True if there's no sentence boundary followed by more text."""
    return _SENTENCE_END.search(text.strip()) is None


def contains_hard_block(text: str, lang: str) -> str | None:
    words = HARD_BLOCK.get(lang) or HARD_BLOCK["en"]
    low = text.lower()
    for w in words:
        if re.search(rf"(?<!\w){re.escape(w)}(?!\w)", low):
            return w
    return None


def check_hint(text: str, lang: str, max_words: int = 15) -> Verdict:
    """RAG_PLAN §2.2: one open sentence, ≤ 15 words, never closes the plot."""
    t = text.strip()
    if not t:
        return Verdict(False, "empty")
    if not is_single_sentence(t):
        return Verdict(False, "more than one sentence")
    n = word_count(t)
    if n > max_words:
        return Verdict(False, f"{n} words > {max_words}")
    low = t.lower()
    for phrase in _CLOSING.get(lang, ()) + _CLOSING["en"]:
        if phrase in low:
            return Verdict(False, f"closes the plot: {phrase!r}")
    if (w := contains_hard_block(t, lang)):
        return Verdict(False, f"hard-blocked word: {w!r}")
    return Verdict(True)


def _content_words(text: str, lang: str) -> set[str]:
    stop = _STOP.get(lang, set()) | _STOP["en"]
    return {w for w in re.findall(r"\w+", text.lower()) if len(w) > 3 and w not in stop}


def reveals_ending(hint: str, ending_text: str, lang: str, threshold: float = 0.5) -> bool:
    """Cheap spoiler check: does the hint share most of the ending's content
    words? The LLM 'does this reveal it?' classifier is the real gate;
    this catches the blatant cases without a model call."""
    e = _content_words(ending_text, lang)
    if not e:
        return False
    h = _content_words(hint, lang)
    return len(h & e) / len(e) >= threshold


def check_for_age(text: str, lang: str, age_min: int) -> Verdict:
    """Anything targeted below 6 must be free of hard-blocked words."""
    if age_min < 6 and (w := contains_hard_block(text, lang)):
        return Verdict(False, f"hard-blocked for age {age_min}: {w!r}")
    return Verdict(True)


_STOP: dict[str, set[str]] = {
    "en": {"the", "and", "that", "with", "they", "them", "their", "then", "this", "from", "into", "were", "have", "been"},
    "cs": {"který", "která", "které", "když", "také", "jako", "byla", "byli", "bylo", "svou", "svého", "jeho", "její"},
    "sk": {"ktorý", "ktorá", "ktoré", "keď", "tiež", "ako", "bola", "boli", "bolo", "jeho", "jej"},
    "de": {"und", "dass", "aber", "dann", "wenn", "sich", "ihre", "ihren", "sein", "seine", "wurde", "waren"},
    "pl": {"który", "która", "które", "kiedy", "także", "jako", "była", "byli", "było", "jego", "jej", "swoje"},
}
