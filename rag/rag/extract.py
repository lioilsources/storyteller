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
import json
import re
from pathlib import Path

from .io import DATA_DIR, append_jsonl, done_keys, log, stable_id
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
}

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
- atu_code: best-guess ATU type or "". country_code: ISO 3166-1 alpha-2 of the tale's tradition of origin (DE Grimm, DK Andersen, FR Perrault, GR Aesop), not the translation's language.
- age_min: 0, 3, or 6. soft: true if violence/death/peril should be softened for young children.
- Never invent motifs not grounded in the text. Output only JSON matching the schema."""

MAX_CHARS = 16000  # ~4k tokens of tale; Grimm tales are far shorter, Lang's longest ones get truncated


def discover_tales(raw_dir: Path, only: set[str]) -> list[tuple[str, str, str, Path]]:
    """(collection, book_id, title, path) for every tale the Go fetcher split."""
    out: list[tuple[str, str, str, Path]] = []
    for coll in sorted(p for p in raw_dir.iterdir() if p.is_dir()):
        if only and coll.name not in only:
            continue
        for book in sorted(p for p in coll.iterdir() if p.is_dir() and p.name.endswith("-tales")):
            index = json.loads((book / "index.json").read_text(encoding="utf-8"))
            for entry in index:
                out.append((coll.name, book.name.removesuffix("-tales"), entry["title"], book / entry["file"]))
    return out


def source_ref(collection: str, book_id: str, path: Path) -> str:
    return f"gutenberg:{collection}:{book_id}:{path.stem}"


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
    todo = [(c, b, t, p) for c, b, t, p in tales if source_ref(c, b, p) not in done]
    if limit:
        todo = todo[:limit]
    log(f"extract: {len(tales)} tales found, {len(done)} already done, {len(todo)} to do")
    if not todo:
        return 0, 0

    prompts = []
    for coll, book, title, path in todo:
        text = path.read_text(encoding="utf-8")[:MAX_CHARS]
        prompts.append((SYSTEM, f"Title: {title}\n\nText:\n{text}"))

    results = llm.batch(prompts, MotifExtraction)

    ok, failed = 0, 0
    records: list[TaleRecord] = []
    for (coll, book, title, path), res in zip(todo, results):
        ref = source_ref(coll, book, path)
        if isinstance(res, Exception):
            log(f"  FAIL {ref}: {res}")
            failed += 1
            continue
        res = res.model_copy(update={
            "atu_code": clean_atu(res.atu_code),
            "country_code": KNOWN_COUNTRY.get(coll, res.country_code),
        })
        records.append(TaleRecord(source_ref=ref, title=title, extraction=res, motifs=to_motifs(ref, res)))
        ok += 1
        log(f"  ok   {ref}: {len(records[-1].motifs)} motifs, atu={res.atu_code or '-'} cc={res.country_code or '-'} soft={res.soft}")
    append_jsonl(out_path, records)
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
