"""Stage 1: classify + extract motifs from the tales `corpus/cmd/fetch-gutenberg`
(Go) wrote under corpus/data/raw/<collection>/<id>-tales/.

PLAN §3.2 steps 3+4 folded into one LLM call per tale, extended with
environments/creatures (PLAN §1.1c). Output: rag/data/tales.jsonl, one
TaleRecord per tale, with deterministic motif ids so downstream stages
can resume.

    python -m rag.extract --only grimm --limit 5     # smoke test first
    python -m rag.extract                            # everything
"""

from __future__ import annotations

import argparse
import functools
import json
import re
from pathlib import Path

from .io import CHUNK, DATA_DIR, append_jsonl, done_keys, log, stable_id
from .llm import LLM
from .schemas import Motif, MotifExtraction, TaleRecord

# Real finding from the first live run against 5 Grimm tales
# (2026-09-24, model "translate" / Qwen3-32B-AWQ via the LAN gateway):
# the model got country_code wrong for 2/5 tales (Die Bremer
# Stadtmusikanten and Der alte Sultan — unambiguously Grimm/German —
# both came back "FR"). For single-country collections we already KNOW
# the country from which anthology the tale was fetched from (PLAN §3.1)
# — there's no need to trust an LLM guess we can just check against
# ground truth we already have. Lang's Fairy Books is a genuinely
# multi-country anthology (that's the whole point of it), so it's the
# one collection left to the model's per-tale judgement.
KNOWN_COUNTRY = {
    "grimm": "DE",
    "andersen": "DK",
    "perrault": "FR",
    "aesop": "GR",
    # cs.wikisource (2026-09-25). Němcová's Národní Báchorky and Erben's
    # prose tales are Czech; her Srbské pohádky are Serbian tales she
    # translated, so the tradition is RS even though the text is Czech.
    "nemcova": "CZ",
    "erben": "CZ",
    "nemcova-srbske": "RS",
    # World coverage, wave 1 (2026-09-27) — see corpus/internal/gutenberg/catalog.go.
    "dayrell-nigeria": "NG", "barker-westafrica": "GH", "cronise": "SL", "zanzibar": "TZ",
    "honey": "ZA", "bourhill": "ZA",
    "kunos-turkish": "TR", "coffee-house": "TR", "korean-griffis": "KR", "korean-gale": "KR",
    "chinese-macgowan": "CN", "chinese-pitman": "CN", "philippine-cole": "PH", "philippine-bayliss": "PH",
    "ceylon-parker": "LK", "khasi": "IN", "simla": "IN", "indus-oral": "PK",
    "parker-australian": "AU", "hawaii-thrum": "US",
    "rasmussen-eskimo": "GL", "eskimo-animal": "US", "canadian-macmillan": "CA", "timiskaming": "CA",
    "janvier-mexico": "MX", "beckwith-jamaica": "JM",
    "cossack": "UA", "dutch-griffis": "NL", "belgian-griffis": "BE", "boschere-flanders": "BE",
    "swiss-griffis": "CH", "tirol-busk": "AT", "busk-patranas": "ES", "azores-eells": "PT",
    "rumanian-gaster": "RO", "serbian-mijatovich": "RS", "manx": "IM", "scottish-grierson": "GB", "welsh-griffis": "GB",
    # World coverage, wave 2 (2026-10-04) — see corpus/internal/gutenberg/catalog.go.
    "eells-brazil": "BR", "shan-griggs": "MM", "burma-pagoda": "MM", "skeat-malay": "MY",
    "georgian-wardrop": "GE", "armenian-seklemian": "AM",
}

# The people whose tradition a whole collection is, where that is known —
# stored next to the country (and instead of it for NO_COUNTRY). Anything
# not listed here is the model's per-tale answer.
KNOWN_PEOPLE = {
    "parker-australian": "Yuwaalaraay",  # K. Langloh Parker's own attribution (Euahlayi / Narran)
    "hawaii-thrum": "Hawaiian",
    "tibet-jewett": "Tibetan",
    "rasmussen-eskimo": "Greenlandic Inuit",
    "khasi": "Khasi",
    "zanzibar": "Swahili",
    "manx": "Manx",
    "scottish-grierson": "Scottish",
    "welsh-griffis": "Welsh",
    "boschere-flanders": "Flemish",
    "shan-griggs": "Shan",
    "skeat-malay": "Malay",
}

# Traditions whose country tag is contested: the people is stored, the
# country left empty, and the globe doesn't claim them for any state
# (user decision 2026-09-27: "ulož národ").
NO_COUNTRY = {"tibet-jewett"}

# Collections that deliberately gather tales from many nations, where the
# origin can only be decided per tale. Listed explicitly rather than left
# implicit, so that adding a collection and forgetting to classify it is
# a loud failure instead of a silent per-tale guess.
MIXED_ORIGIN = {
    "lang", "erben-slovanske",
    "nassau", "lang-nights", "punjab-steel", "bengal-day", "laos", "sind-guzarat", "busk-kalmouk",
    "skinner-possessions", "polish-glinski", "sellers-spain-portugal",
    # Wave 2. Finger and Coxwell carry a per-tale "country" in index.json
    # where the book names the place (catalog.go TaleCountry); the rest of
    # their tales, and all of Wait / Chandler / Gulbat, are the model's call.
    "finger-silver-lands", "wait-el-dorado", "araby-chandler", "caucasian-gulbat", "coxwell-central-asia",
}


# Front and back matter the CONTENTS-based splitter hands over as "tales"
# (18 of the 1687 in world wave 1): prefaces, glossaries, informant lists.
# Deliberately no "the end" — THE END OF THE WORLD is a tale.
FRONT_MATTER = re.compile(
    r"^(preface|introduct|glossar|notes?\b|appendix|index\b|contents|bibliograph|list of|illustrations|footnotes|"
    r"translator|foreword|dedication|native text|a note\b|to the reader|pronunciation|postscript|prelude)",
    re.IGNORECASE,
)


def is_front_matter(title: str) -> bool:
    return bool(FRONT_MATTER.match(title.strip().strip("_*'\"")))


def country_for(collection: str, model_country: str, tale_country: str = "") -> str:
    """Ground truth for single-country collections, nothing for contested
    traditions, the fetcher's per-tale origin where the book states it
    (`tale_country`), the model's per-tale answer otherwise."""
    if collection in NO_COUNTRY:
        return ""
    return tale_country or KNOWN_COUNTRY.get(collection, model_country)


@functools.cache
def _index_countries(index_path: Path) -> dict[str, str]:
    if not index_path.exists():
        return {}
    return {e["file"]: e["country"] for e in json.loads(index_path.read_text(encoding="utf-8")) if e.get("country")}


def tale_country(path: Path) -> str:
    """The origin `fetch-gutenberg` wrote for this one tale (index.json
    "country", from catalog.go TaleCountry), or "" — e.g. Finger's "In
    Colombia, it seems…" inside a book of tales from a dozen countries."""
    return _index_countries(path.parent / "index.json").get(path.name, "")


def people_for(collection: str, model_people: str) -> str:
    return KNOWN_PEOPLE.get(collection, model_people)

# Same run: atu_code came back as "554 The Golden Bird" instead of a
# bare code — the model tacked the tale's own title onto the number.
# Keep only the leading ATU-shaped token.
_ATU_TOKEN = re.compile(r"^\s*(?:ATU?\s*)?(\d{1,4}[A-Za-z]?)\b")


def clean_atu(code: str) -> str:
    m = _ATU_TOKEN.match(code)
    return f"ATU {m.group(1)}" if m else ""

SYSTEM = """You extract structured, reusable story motifs for a children's bedtime-story app from one public-domain fairy tale.

Rules:
- Each entry in characters/tasks/problems/endings is ONE short English sentence (a motif, not a summary), reusable across different retellings, not tied to this tale's names or wording.
- characters: archetypes ("a clever fox who talks its way out of trouble"), 1-4. tasks: what the hero must accomplish, 1-3. problems: obstacle/antagonist/dilemma, 1-3. endings: happy resolution, 1-2.
- tags: 3-8 lowercase keywords (setting, creatures, themes).
- environments: the settings the tale moves through, lowercase single words from: forest, sea, river, lake, desert, mountains, steppe, village, town, palace, cottage, market, underground, sky, garden, mill, road.
- creatures: creatures and folk figures that appear (generic: "owl", "wolf", "water sprite", "dragon"), each tied to one of the environments you listed.
- atu_code: best-guess ATU type or "". country_code: ISO 3166-1 alpha-2 of the tale's tradition of origin (DE Grimm, DK Andersen, FR Perrault, GR Aesop), not the translation's language. people: the nation or people whose tradition it is, in English ("Czech", "Yoruba", "Tibetan").
- age_min: 0, 3, or 6. soft: true if violence/death/peril should be softened for young children.
- Never invent motifs not grounded in the text. Output only JSON matching the schema."""

MAX_CHARS = 16000  # ~4k tokens of tale; Grimm tales are far shorter, Lang's longest ones get truncated


def discover_tales(raw_dir: Path, only: set[str]) -> list[tuple[str, str, str, str, Path]]:
    """(source, collection, book_id, title, path) for every split tale.

    Two on-disk layouts, because there are two fetchers. `fetch-gutenberg`
    writes one directory per book (`grimm/2591-tales/`), since a Gutenberg
    anthology is one file that gets split. `fetch-wikisource` writes a
    single `tales/` directory per collection, since Wikisource already
    serves one page per tale and there is no book id to speak of.

    Matching only `*-tales` used to skip every Wikisource collection in
    silence — the Czech corpus was on disk and invisible here.
    """
    out: list[tuple[str, str, str, str, Path]] = []
    for coll in sorted(p for p in raw_dir.iterdir() if p.is_dir()):
        if only and coll.name not in only:
            continue
        for book in sorted(p for p in coll.iterdir() if p.is_dir()):
            index_path = book / "index.json"
            if not index_path.exists():
                continue
            if book.name == "tales":
                source, book_id = "wikisource", ""
            elif book.name.endswith("-tales"):
                book_id = book.name.removesuffix("-tales")
                source = _book_source(coll / f"{book_id}.json")
            else:
                continue
            index = json.loads(index_path.read_text(encoding="utf-8"))
            for entry in index:
                out.append((source, coll.name, book_id, entry["title"], book / entry["file"]))
    return out


def _book_source(meta_path: Path) -> str:
    """`fetch-gutenberg` also fetches a few Internet Archive books
    (catalog.go Archive) into the same layout; their sidecar says
    "source": "archive". Older sidecars have no such key and are all
    Gutenberg."""
    if meta_path.exists():
        return json.loads(meta_path.read_text(encoding="utf-8")).get("source") or "gutenberg"
    return "gutenberg"


def source_ref(source: str, collection: str, book_id: str, path: Path) -> str:
    """Stable dedupe key, also the provenance string stored on every motif.

    Empty parts are dropped so a Wikisource tale (no book id) reads
    `wikisource:nemcova:000-chytra-horakyne`, while a Gutenberg one keeps
    the exact four-part shape the first 93 records already use — change
    that and every one of them re-extracts.
    """
    return ":".join(p for p in (source, collection, book_id, path.stem) if p)


def to_motifs(ref: str, ex: MotifExtraction) -> list[Motif]:
    rows: list[Motif] = []
    for mtype, texts in (
        ("character", ex.characters),
        ("task", ex.tasks),
        ("problem", ex.problems),
        ("ending", ex.endings),
    ):
        for text in texts:
            rows.append(
                Motif(
                    id=stable_id(ref, mtype, text.lower()),
                    type=mtype,  # type: ignore[arg-type]
                    text_en=text,
                    tags=ex.tags,
                    atu_code=ex.atu_code,
                    country_code=ex.country_code,
                    people=ex.people,
                    age_min=ex.age_min,
                    soft=ex.soft,
                    source_ref=ref,
                    environments=ex.environments,
                )
            )
    return rows




def run(raw_dir: Path, out_path: Path, only: set[str], limit: int, llm: LLM) -> tuple[int, int]:
    tales = discover_tales(raw_dir, only)
    done = done_keys(out_path, TaleRecord, lambda r: r.source_ref)
    skipped = [t for t in tales if is_front_matter(t[3])]
    if skipped:
        log(f"extract: skipping {len(skipped)} front/back-matter entries (e.g. {skipped[0][3]!r})")
    tales = [t for t in tales if not is_front_matter(t[3])]
    todo = [t for t in tales if source_ref(t[0], t[1], t[2], t[4]) not in done]
    if limit:
        todo = todo[:limit]
    log(f"extract: {len(tales)} tales found, {len(done)} already done, {len(todo)} to do")

    unclassified = {c for _, c, _, _, _ in todo} - set(KNOWN_COUNTRY) - MIXED_ORIGIN - NO_COUNTRY
    if unclassified:
        log(f"extract: WARNING collections with no origin rule: {sorted(unclassified)} — "
            "each tale's country will be the model's guess; add them to KNOWN_COUNTRY or MIXED_ORIGIN")
    if not todo:
        return 0, 0

    ok, failed = 0, 0
    for start in range(0, len(todo), CHUNK):
        batch = todo[start : start + CHUNK]
        prompts = [
            (SYSTEM, f"Title: {title}\n\nText:\n{path.read_text(encoding='utf-8')[:MAX_CHARS]}")
            for _, _, _, title, path in batch
        ]
        results = llm.batch(prompts, MotifExtraction)

        records: list[TaleRecord] = []
        for (source, coll, book, title, path), res in zip(batch, results):
            ref = source_ref(source, coll, book, path)
            if isinstance(res, Exception):
                log(f"  FAIL {ref}: {res}")
                failed += 1
                continue
            res = res.model_copy(update={
                "atu_code": clean_atu(res.atu_code),
                "country_code": country_for(coll, res.country_code, tale_country(path)),
                "people": people_for(coll, res.people),
            })
            records.append(TaleRecord(source_ref=ref, title=title, extraction=res, motifs=to_motifs(ref, res)))
            ok += 1
            log(f"  ok   {ref}: {len(records[-1].motifs)} motifs, atu={res.atu_code or '-'} cc={res.country_code or '-'} soft={res.soft}")
        append_jsonl(out_path, records)
        log(f"extract: {start + len(batch)}/{len(todo)} done ({ok} ok, {failed} failed)")
    return ok, failed


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--in", dest="raw_dir", type=Path, default=Path("corpus/data/raw"), help="Go fetcher output (repo-relative)")
    ap.add_argument("--out", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--only", default="", help="comma-separated collections, e.g. grimm,andersen")
    ap.add_argument("--limit", type=int, default=0, help="max tales this run (0 = all)")
    args = ap.parse_args()

    only = {s.strip() for s in args.only.split(",") if s.strip()}
    ok, failed = run(args.raw_dir, args.out, only, args.limit, LLM())
    log(f"extract: done, {ok} ok, {failed} failed → {args.out}")


if __name__ == "__main__":
    main()
