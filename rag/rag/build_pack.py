"""Stage 6: build_pack — one SQLite file per pack (RAG_PLAN §3, §6):

    core.<lang>.db           generic hints, transitions, outline templates, phase model
    country.<CC>.<lang>.db   that country's motifs, verbalizations, hints, scene prompts, compat

Same schema in both (empty tables are fine) so the client ATTACHes them
all and queries one shape. Vectors go into sqlite-vec `vec0` tables as
int8 with cosine distance; if no embedder is given (tests, or torch not
installed) the vec tables are created empty and `meta.embed_model` is
'' — a pack without vectors is valid but useless for hint retrieval,
and the client must refuse it.

    python -m rag.build_pack --lang cs --core
    python -m rag.build_pack --lang cs --country DE
"""

from __future__ import annotations

import argparse
import json
import sqlite3
from collections.abc import Callable, Sequence
from datetime import UTC, datetime
from pathlib import Path

from .embed import DIM, quantize_int8
from .io import DATA_DIR, log, read_jsonl
from .schemas import Hint, ScenePrompt, TaleRecord, Transition, Verbalization

EmbedFn = Callable[[list[str]], list[list[float]]]  # texts → normalised vectors ("passage:" prefix applied by caller)

PACK_VERSION = 1

SCHEMA = """
CREATE TABLE meta (
    pack_id     TEXT NOT NULL,
    version     INTEGER NOT NULL,
    lang        TEXT NOT NULL,
    country     TEXT,
    embed_model TEXT NOT NULL DEFAULT '',
    embed_ver   TEXT NOT NULL DEFAULT '',
    embed_dim   INTEGER NOT NULL DEFAULT 0,
    built_at    TEXT NOT NULL
);
CREATE TABLE motifs (
    id TEXT PRIMARY KEY, type TEXT NOT NULL, atu TEXT, country_code TEXT, region_code TEXT,
    tags TEXT NOT NULL,            -- JSON array
    age_min INTEGER NOT NULL DEFAULT 0, age_max INTEGER NOT NULL DEFAULT 10,
    soft INTEGER NOT NULL DEFAULT 0, text_en TEXT NOT NULL, environments TEXT NOT NULL DEFAULT '[]'
);
CREATE INDEX motifs_type ON motifs(type, age_min);
CREATE TABLE verbalizations (
    motif_id TEXT NOT NULL REFERENCES motifs(id), lang TEXT NOT NULL,
    age_band TEXT NOT NULL, tone TEXT NOT NULL, length TEXT NOT NULL, text TEXT NOT NULL
);
CREATE INDEX verbalizations_lookup ON verbalizations(motif_id, age_band, length);
CREATE TABLE hint_bank (
    id TEXT PRIMARY KEY, motif_id TEXT, phase TEXT NOT NULL, environment_id TEXT,
    lang TEXT NOT NULL, text TEXT NOT NULL, situation_en TEXT NOT NULL, weight REAL NOT NULL DEFAULT 1.0
);
CREATE INDEX hint_bank_lookup ON hint_bank(lang, phase, motif_id);
CREATE TABLE transitions (
    from_type TEXT NOT NULL, to_type TEXT NOT NULL, tags TEXT NOT NULL, lang TEXT NOT NULL, text TEXT NOT NULL
);
CREATE TABLE compat (motif_a TEXT NOT NULL, motif_b TEXT NOT NULL, score REAL NOT NULL, PRIMARY KEY (motif_a, motif_b));
CREATE TABLE outline_templates (id TEXT PRIMARY KEY, lang TEXT NOT NULL, age_band TEXT NOT NULL, text TEXT NOT NULL);
CREATE TABLE scene_prompts (
    id TEXT PRIMARY KEY, motif_id TEXT NOT NULL, environment_id TEXT, phase TEXT NOT NULL, text_en TEXT NOT NULL
);
CREATE INDEX scene_prompts_lookup ON scene_prompts(motif_id, phase);
CREATE TABLE phase_model (version TEXT PRIMARY KEY, weights_json TEXT NOT NULL);
"""

# Slot-only templates are language-neutral; the LLM-written per-language
# ones (RAG_PLAN §2.3) get added on top once that stage exists.
DEFAULT_TEMPLATES = (
    ("t-4beat", "{character_intro} {transition} {task} {transition} {problem} {transition} {ending}"),
    ("t-problem-first", "{problem} {transition} {character_intro} {transition} {task} {transition} {ending}"),
)


def open_pack(path: Path, *, with_vec: bool = True) -> sqlite3.Connection:
    conn = sqlite3.connect(path)
    if with_vec:
        import sqlite_vec  # bundled loadable extension

        conn.enable_load_extension(True)
        sqlite_vec.load(conn)
        conn.enable_load_extension(False)
    return conn


def create_schema(conn: sqlite3.Connection, *, with_vec: bool = True) -> None:
    conn.executescript(SCHEMA)
    if with_vec:
        conn.execute(f"CREATE VIRTUAL TABLE hint_vec  USING vec0(id TEXT PRIMARY KEY, trigger_embedding int8[{DIM}] distance_metric=cosine)")
        conn.execute(f"CREATE VIRTUAL TABLE scene_vec USING vec0(id TEXT PRIMARY KEY, embedding int8[{DIM}] distance_metric=cosine)")


def jaccard(a: Sequence[str], b: Sequence[str]) -> float:
    sa, sb = set(a), set(b)
    return len(sa & sb) / len(sa | sb) if sa or sb else 0.0


def atu_neighbour(a: str, b: str) -> float:
    """1.0 if same ATU, 0.5 if within ±5 in the same ATU band, else 0."""
    def num(s: str) -> int | None:
        digits = "".join(ch for ch in s if ch.isdigit())
        return int(digits) if digits else None

    na, nb = num(a), num(b)
    if na is None or nb is None:
        return 0.0
    if na == nb:
        return 1.0
    return 0.5 if abs(na - nb) <= 5 else 0.0


def build(
    out_path: Path,
    lang: str,
    *,
    country: str | None,
    tales_path: Path,
    verbalizations_path: Path | None,
    hints_path: Path | None,
    transitions_path: Path | None,
    scene_prompts_path: Path | None,
    embed: EmbedFn | None,
    embed_model: str = "",
    embed_ver: str = "",
) -> dict[str, int]:
    """Build one pack. `country=None` builds the core pack (generic hints,
    transitions, templates — no motifs). Returns row counts."""
    if out_path.exists():
        out_path.unlink()
    out_path.parent.mkdir(parents=True, exist_ok=True)
    with_vec = True
    try:
        conn = open_pack(out_path, with_vec=True)
    except (ImportError, sqlite3.OperationalError) as e:
        log(f"build_pack: sqlite-vec unavailable ({e}); building without vector tables")
        with_vec = False
        conn = open_pack(out_path, with_vec=False)
    create_schema(conn, with_vec=with_vec)

    pack_id = f"country.{country}.{lang}" if country else f"core.{lang}"
    counts: dict[str, int] = {}

    # motifs (country packs only)
    motif_ids: set[str] = set()
    if country:
        rows = []
        for rec in read_jsonl(tales_path, TaleRecord):
            for m in rec.motifs:
                if m.country_code == country and m.id not in motif_ids:
                    motif_ids.add(m.id)
                    rows.append((m.id, m.type, m.atu_code, m.country_code, m.region_code, json.dumps(m.tags), m.age_min, 10, int(m.soft), m.text_en, json.dumps(m.environments)))
        conn.executemany("INSERT INTO motifs VALUES (?,?,?,?,?,?,?,?,?,?,?)", rows)
        counts["motifs"] = len(rows)

        if verbalizations_path:
            vrows = [(v.motif_id, v.lang, v.age_band, v.tone, v.length, v.text) for v in read_jsonl(verbalizations_path, Verbalization) if v.motif_id in motif_ids]
            conn.executemany("INSERT INTO verbalizations VALUES (?,?,?,?,?,?)", vrows)
            counts["verbalizations"] = len(vrows)

        # compat: heuristic half of RAG_PLAN §2.3 (LLM-scored pairs come later)
        motifs = conn.execute("SELECT id, type, atu, tags FROM motifs").fetchall()
        crows = []
        order = {"character": 0, "task": 1, "problem": 2, "ending": 3}
        for i, (ida, ta, atua, tagsa) in enumerate(motifs):
            for idb, tb, atub, tagsb in motifs[i + 1:]:
                if ta == tb or abs(order[ta] - order[tb]) != 1:
                    continue  # only adjacent beats are ever composed
                s = jaccard(json.loads(tagsa), json.loads(tagsb)) + 0.5 * atu_neighbour(atua or "", atub or "")
                if s > 0:
                    crows.append((ida, idb, round(s, 4)))
        conn.executemany("INSERT INTO compat VALUES (?,?,?)", crows)
        counts["compat"] = len(crows)

    # hints: country pack → this country's motifs; core pack → generic (motif_id NULL)
    if hints_path:
        hints = [h for h in read_jsonl(hints_path, Hint) if h.lang == lang and ((h.motif_id in motif_ids) if country else (h.motif_id is None))]
        conn.executemany("INSERT INTO hint_bank VALUES (?,?,?,?,?,?,?,?)", [(h.id, h.motif_id, h.phase, h.environment_id, h.lang, h.text, h.situation_en, h.weight) for h in hints])
        counts["hint_bank"] = len(hints)
        if hints and embed and with_vec:
            vecs = embed([h.situation_en for h in hints])
            conn.executemany("INSERT INTO hint_vec(id, trigger_embedding) VALUES (?, vec_int8(?))", [(h.id, quantize_int8(v)) for h, v in zip(hints, vecs)])
            counts["hint_vec"] = len(vecs)

    if country and scene_prompts_path:
        sps = [s for s in read_jsonl(scene_prompts_path, ScenePrompt) if s.motif_id in motif_ids]
        conn.executemany("INSERT INTO scene_prompts VALUES (?,?,?,?,?)", [(s.id, s.motif_id, s.environment_id, s.phase, s.text_en) for s in sps])
        counts["scene_prompts"] = len(sps)
        if sps and embed and with_vec:
            vecs = embed([s.text_en for s in sps])
            conn.executemany("INSERT INTO scene_vec(id, embedding) VALUES (?, vec_int8(?))", [(s.id, quantize_int8(v)) for s, v in zip(sps, vecs)])
            counts["scene_vec"] = len(vecs)

    if not country:
        if transitions_path:
            trows = [(t.from_type, t.to_type, json.dumps(t.tags), t.lang, t.text) for t in read_jsonl(transitions_path, Transition) if t.lang == lang]
            conn.executemany("INSERT INTO transitions VALUES (?,?,?,?,?)", trows)
            counts["transitions"] = len(trows)
        conn.executemany("INSERT INTO outline_templates VALUES (?,?,?,?)", [(tid, lang, "3-6", text) for tid, text in DEFAULT_TEMPLATES])
        counts["outline_templates"] = len(DEFAULT_TEMPLATES)

    conn.execute(
        "INSERT INTO meta VALUES (?,?,?,?,?,?,?,?)",
        (pack_id, PACK_VERSION, lang, country, embed_model if (embed and with_vec) else "", embed_ver if (embed and with_vec) else "", DIM if (embed and with_vec) else 0, datetime.now(UTC).isoformat(timespec="seconds")),
    )
    conn.commit()
    conn.execute("VACUUM")
    conn.close()
    counts["bytes"] = out_path.stat().st_size
    return counts


def nearest_hints(conn: sqlite3.Connection, query_vec: Sequence[float], *, phase: str, motif_ids: Sequence[str], k: int = 8) -> list[tuple[str, str, float]]:
    """The runtime query from RAG_PLAN §3, here for tests and for the
    Dart side to copy: (id, text, similarity) best-first. sqlite-vec's
    cosine `distance` is 1 - cos."""
    placeholders = ",".join("?" * len(motif_ids)) or "NULL"
    rows = conn.execute(
        f"""
        SELECT h.id, h.text, 1.0 - v.distance AS sim
        FROM hint_vec v JOIN hint_bank h ON h.id = v.id
        WHERE v.trigger_embedding MATCH vec_int8(?) AND v.k = ?
          AND h.phase = ? AND (h.motif_id IS NULL OR h.motif_id IN ({placeholders}))
        ORDER BY v.distance
        """,
        (quantize_int8(query_vec), k * 4, phase, *motif_ids),
    ).fetchall()
    return [(r[0], r[1], float(r[2])) for r in rows[:k]]


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--core", action="store_true")
    g.add_argument("--country", help="ISO 3166-1 alpha-2, e.g. DE")
    ap.add_argument("--out-dir", type=Path, default=DATA_DIR / "packs")
    ap.add_argument("--no-embed", action="store_true", help="skip vectors (pack won't support retrieval)")
    ap.add_argument("--embed-model", default=None)
    args = ap.parse_args()

    embed: EmbedFn | None = None
    embed_model = embed_ver = ""
    if not args.no_embed:
        from .embed import DEFAULT_MODEL, Embedder

        e = Embedder(args.embed_model or DEFAULT_MODEL)
        embed, embed_model, embed_ver = e.passages, e.model_name, e.version

    country = args.country.upper() if args.country else None
    out = args.out_dir / (f"country.{country}.{args.lang}.db" if country else f"core.{args.lang}.db")
    counts = build(
        out, args.lang, country=country,
        tales_path=DATA_DIR / "tales.jsonl",
        verbalizations_path=DATA_DIR / f"verbalizations.{args.lang}.jsonl",
        hints_path=DATA_DIR / f"hints.{args.lang}.jsonl",
        transitions_path=DATA_DIR / f"transitions.{args.lang}.jsonl",
        scene_prompts_path=DATA_DIR / "scene_prompts.jsonl",
        embed=embed, embed_model=embed_model, embed_ver=embed_ver,
    )
    log(f"build_pack: {out} → " + ", ".join(f"{k}={v}" for k, v in counts.items()))


if __name__ == "__main__":
    main()
