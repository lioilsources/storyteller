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
from .sources import prefer_original

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
-- Same int8 vectors as hint_vec, as plain BLOBs: readable without the
-- sqlite-vec extension. The app ranks them by cosine in Dart (a few
-- thousand × 384 bytes is < 5 ms), so the device needs no native vec0 yet.
CREATE TABLE hint_emb (id TEXT PRIMARY KEY REFERENCES hint_bank(id), emb BLOB NOT NULL);
CREATE TABLE transitions (
    from_type TEXT NOT NULL, to_type TEXT NOT NULL, tags TEXT NOT NULL, lang TEXT NOT NULL, text TEXT NOT NULL
);
CREATE TABLE compat (motif_a TEXT NOT NULL, motif_b TEXT NOT NULL, score REAL NOT NULL, PRIMARY KEY (motif_a, motif_b));
CREATE TABLE outline_templates (id TEXT PRIMARY KEY, lang TEXT NOT NULL, age_band TEXT NOT NULL, text TEXT NOT NULL);
CREATE TABLE scene_prompts (
    id TEXT PRIMARY KEY, motif_id TEXT NOT NULL, environment_id TEXT, phase TEXT NOT NULL, text_en TEXT NOT NULL
);
CREATE INDEX scene_prompts_lookup ON scene_prompts(motif_id, phase);
-- scene_vec's int8 vectors as plain BLOBs, for the app's Dart-side cosine
-- (same reason as hint_emb).
CREATE TABLE scene_emb (id TEXT PRIMARY KEY REFERENCES scene_prompts(id), emb BLOB NOT NULL);
CREATE TABLE phase_model (version TEXT PRIMARY KEY, weights_json TEXT NOT NULL);
-- Card art per motif (flux-schnell, internal/nimqueue/cmd/render-motifs),
-- 512 px JPEG, so a pack carries its own pictures.
CREATE TABLE motif_images (motif_id TEXT PRIMARY KEY REFERENCES motifs(id), jpeg BLOB NOT NULL);
-- Which creatures appear in a motif's tale — what the soundboard offers.
CREATE TABLE motif_creatures (motif_id TEXT NOT NULL REFERENCES motifs(id), creature TEXT NOT NULL, PRIMARY KEY (motif_id, creature));
-- Soundboard (core pack): rag/audio/catalog.json rendered by
-- internal/audiogen/cmd/render-audio. kind = music | creature | action;
-- key = environment (music) or catalog key; match = JSON array of motif
-- tags / environments / creatures that make the app offer it. No speech.
CREATE TABLE sounds (id TEXT PRIMARY KEY, kind TEXT NOT NULL, key TEXT NOT NULL, mood TEXT, label_cs TEXT NOT NULL, match TEXT NOT NULL DEFAULT '[]', m4a BLOB NOT NULL);
-- Scene illustrations (scene_prompts rendered with a generic hero), same format.
CREATE TABLE scene_images (scene_id TEXT PRIMARY KEY REFERENCES scene_prompts(id), jpeg BLOB NOT NULL);
-- Zdrojové pohádky, ze kterých pack má motivy (z rag/data/tales.jsonl):
-- tabulka motifs nemá tale_id, a glóbus chce „N motivů z M pohádek“.
-- Řádek na pohádku, ne součet na zemi: appka sčítá DISTINCT source_ref
-- přes všechny otevřené packy, takže pohádka ve vestavěném i staženém
-- packu se nepočítá dvakrát. motifs = motivy pohádky v packu, shown =
-- z nich task/problem/ending s titulkem v jazyce packu (co ukážou pickery).
CREATE TABLE pack_tales (source_ref TEXT PRIMARY KEY, country_code TEXT NOT NULL, motifs INTEGER NOT NULL, shown INTEGER NOT NULL);
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
    images_dir: Path | None = None,
    scene_images_dir: Path | None = None,
    sounds_dir: Path | None = None,
    audio_catalog: Path | None = None,
    embed_model: str = "",
    embed_ver: str = "",
    cards_path: Path | None = None,
    exclude_countries: frozenset[str] = frozenset(),
    countries: frozenset[str] | None = None,
    source_refs: frozenset[str] | None = None,
    pack_id: str | None = None,
    compat: bool = True,
    built_at: str | None = None,
) -> dict[str, int]:
    """Build one pack. `country=None` builds the core pack (generic hints,
    transitions, templates — no motifs). `country=WORLD` builds one pack of
    every country not in [exclude_countries] (those have packs of their own),
    without compat. [source_refs] limits a country pack to those tales
    (rag.pack_builder's free/paid tiers). [built_at] pins meta.built_at so the
    same input gives a byte-identical file — pack_builder's zips are
    verified by sha256 against the manifest. [countries] (s `country` jako
    popiskem do meta, např. `continent:EU`) bere motivy právě z těchto zemí —
    kontinentální free balíčky z rag.pack_builder. Returns row counts."""
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

    pack_id = pack_id or (f"country.{country}.{lang}" if country else f"core.{lang}")
    counts: dict[str, int] = {}

    # motifs (country packs only)
    motif_ids: set[str] = set()
    tale_motifs: dict[str, list] = {}  # source_ref → motivy pohádky v packu (pro pack_tales)

    def here(cc: str | None) -> bool:
        if countries is not None:
            return cc in countries
        return cc == country or (country == WORLD and bool(cc) and cc not in exclude_countries)

    if country:
        rows = []
        for rec in read_jsonl(tales_path, TaleRecord):
            for m in rec.motifs:
                if source_refs is not None and m.source_ref not in source_refs:
                    continue
                if m.id not in motif_ids and here(m.country_code):
                    motif_ids.add(m.id)
                    tale_motifs.setdefault(rec.source_ref, []).append(m)
                    rows.append((m.id, m.type, m.atu_code, m.country_code, m.region_code, json.dumps(m.tags), m.age_min, 10, int(m.soft), m.text_en, json.dumps(m.environments)))
        conn.executemany("INSERT INTO motifs VALUES (?,?,?,?,?,?,?,?,?,?,?)", rows)
        counts["motifs"] = len(rows)

        crows = {(m.id, c.name_en.strip().lower()) for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.id in motif_ids for c in rec.extraction.creatures}
        conn.executemany("INSERT INTO motif_creatures VALUES (?,?)", sorted(crows))
        counts["motif_creatures"] = len(crows)

        if verbalizations_path:
            # A motif with a card (rag.cards) shows only the card: for a
            # character its title is a name, which must win over verbalize's
            # situation captions.
            # Within each file a motif re-generated from the tale's original
            # text (rag.sources, --regen-from-original) drops its older
            # text_en rows.
            carded = [v for v in read_jsonl(cards_path, Verbalization) if v.motif_id in motif_ids] if cards_path and cards_path.exists() else []
            carded = prefer_original(carded, lambda v: v.motif_id)
            card_ids = {v.motif_id for v in carded}
            verb = [v for v in read_jsonl(verbalizations_path, Verbalization) if v.motif_id in motif_ids and v.motif_id not in card_ids] if verbalizations_path.exists() else []
            verb = prefer_original(verb, lambda v: v.motif_id)
            vrows = [(v.motif_id, v.lang, v.age_band, v.tone, v.length, v.text) for v in verb + carded]
            conn.executemany("INSERT INTO verbalizations VALUES (?,?,?,?,?,?)", vrows)
            counts["verbalizations"] = len(vrows)

        titled = {r[0] for r in conn.execute("SELECT DISTINCT motif_id FROM verbalizations WHERE lang = ? AND length = 'title'", (lang,))}
        trows = [
            (ref, ms[0].country_code, len(ms), sum(m.type in ("task", "problem", "ending") and m.id in titled for m in ms))
            for ref, ms in sorted(tale_motifs.items())
        ]
        conn.executemany("INSERT INTO pack_tales VALUES (?,?,?,?)", trows)
        counts["pack_tales"] = len(trows)

        # compat: heuristic half of RAG_PLAN §2.3 (LLM-scored pairs come later).
        # Nothing reads it yet; skipped for WORLD, where it's quadratic in size.
        motifs = conn.execute("SELECT id, type, atu, tags FROM motifs").fetchall() if compat and country != WORLD else []
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

        if images_dir and images_dir.is_dir():
            irows = [(mid, jpg) for mid in sorted(motif_ids) if (images_dir / f"{mid}.jpg").exists() and (jpg := _card_or_none(images_dir / f"{mid}.jpg"))]
            conn.executemany("INSERT INTO motif_images VALUES (?,?)", irows)
            counts["motif_images"] = len(irows)

    # hints: country pack → this country's motifs; core pack → generic (motif_id NULL)
    if hints_path:
        hints = [h for h in read_jsonl(hints_path, Hint) if h.lang == lang and ((h.motif_id in motif_ids) if country else (h.motif_id is None))]
        # (motif, phase) re-generated from the original drops its text_en hints;
        # ids are text hashes, so a regenerated twin of an old hint is kept once.
        hints = prefer_original(hints, lambda h: (h.motif_id, h.environment_id, h.phase))
        seen: set[str] = set()
        hints = [h for h in hints if not (h.id in seen or seen.add(h.id))]
        conn.executemany("INSERT INTO hint_bank VALUES (?,?,?,?,?,?,?,?)", [(h.id, h.motif_id, h.phase, h.environment_id, h.lang, h.text, h.situation_en, h.weight) for h in hints])
        counts["hint_bank"] = len(hints)
        if hints and embed:
            q = [quantize_int8(v) for v in embed([h.situation_en for h in hints])]
            conn.executemany("INSERT INTO hint_emb(id, emb) VALUES (?, ?)", [(h.id, b) for h, b in zip(hints, q)])
            counts["hint_emb"] = len(q)
            if with_vec:
                conn.executemany("INSERT INTO hint_vec(id, trigger_embedding) VALUES (?, vec_int8(?))", [(h.id, b) for h, b in zip(hints, q)])
                counts["hint_vec"] = len(q)

    if country and scene_prompts_path:
        sps = [s for s in read_jsonl(scene_prompts_path, ScenePrompt) if s.motif_id in motif_ids]
        conn.executemany("INSERT INTO scene_prompts VALUES (?,?,?,?,?)", [(s.id, s.motif_id, s.environment_id, s.phase, s.text_en) for s in sps])
        counts["scene_prompts"] = len(sps)
        if sps and embed:
            q = [quantize_int8(v) for v in embed([s.text_en for s in sps])]
            conn.executemany("INSERT INTO scene_emb(id, emb) VALUES (?, ?)", [(s.id, b) for s, b in zip(sps, q)])
            counts["scene_emb"] = len(q)
            if with_vec:
                conn.executemany("INSERT INTO scene_vec(id, embedding) VALUES (?, vec_int8(?))", [(s.id, b) for s, b in zip(sps, q)])
                counts["scene_vec"] = len(q)
        if sps and scene_images_dir and scene_images_dir.is_dir():
            srows = [(s.id, jpg) for s in sps if (scene_images_dir / f"{s.id}.jpg").exists() and (jpg := _card_or_none(scene_images_dir / f"{s.id}.jpg"))]
            conn.executemany("INSERT INTO scene_images VALUES (?,?)", srows)
            counts["scene_images"] = len(srows)

    if not country:
        if transitions_path:
            trows = [(t.from_type, t.to_type, json.dumps(t.tags), t.lang, t.text) for t in read_jsonl(transitions_path, Transition) if t.lang == lang]
            conn.executemany("INSERT INTO transitions VALUES (?,?,?,?,?)", trows)
            counts["transitions"] = len(trows)
        conn.executemany("INSERT INTO outline_templates VALUES (?,?,?,?)", [(tid, lang, "3-6", text) for tid, text in DEFAULT_TEMPLATES])
        counts["outline_templates"] = len(DEFAULT_TEMPLATES)

        if sounds_dir and audio_catalog and sounds_dir.is_dir() and audio_catalog.exists():
            srows = sound_rows(audio_catalog, sounds_dir)
            conn.executemany("INSERT INTO sounds VALUES (?,?,?,?,?,?,?)", srows)
            counts["sounds"] = len(srows)

    conn.execute(
        "INSERT INTO meta VALUES (?,?,?,?,?,?,?,?)",
        (pack_id, PACK_VERSION, lang, country, embed_model if (embed and with_vec) else "", embed_ver if (embed and with_vec) else "", DIM if (embed and with_vec) else 0, built_at or datetime.now(UTC).isoformat(timespec="seconds")),
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


CARD_PX = 512
CARD_QUALITY = 70


def card_jpeg(path: Path, px: int = CARD_PX, quality: int = CARD_QUALITY) -> bytes:
    """A render downscaled for a phone card — 1024² flux output is ~150 KB,
    this is ~40 KB and still sharper than the 140 px tile shows. [px] and
    [quality] jinak jen scénový balíček (rag.pack_builder.SCENE_PX)."""
    import io

    from PIL import Image

    with Image.open(path) as im:
        # flux-schnell likes to sign its "watercolours" in a corner ("©ni
        # Solell", 2026-09-27) and ignores "no watermark" in the prompt, so
        # the outer 7 % goes before downscaling; the card crops anyway.
        w, h = im.size
        m = round(min(w, h) * 0.07)
        im = im.convert("RGB").crop((m, m, w - m, h - m)).resize((px, px), Image.LANCZOS)
        buf = io.BytesIO()
        # WebP q70 (2026-10-05): poloviční velikost proti JPEG q82 při stejném
        # 512 px a na kresbě bez viditelného rozdílu — jinak se Evropa s celým
        # Českem (karty + scény) do binárky nevešla (198 MB). Sloupec se dál
        # jmenuje `jpeg`; appka bajty jen předá Image.memory, ten WebP umí.
        im.save(buf, "WEBP", quality=quality, method=6)
        return buf.getvalue()


def _card_or_none(path: Path, px: int = CARD_PX, quality: int = CARD_QUALITY) -> bytes | None:
    """card_jpeg, ale rozpracovaný soubor (render-motifs do složky právě
    zapisuje, 2026-10-04) build neshodí — obrázek se jen vynechá."""
    try:
        return card_jpeg(path, px, quality)
    except OSError as e:  # PIL: UnidentifiedImageError i truncated jsou OSError
        log(f"build_pack: {path.name} skipped ({e})")
        return None


def export_cards(out: Path, lang: str, country: str, types: Sequence[str] = ("character", "task", "problem", "ending"), exclude_countries: frozenset[str] = frozenset()) -> int:
    """Motifs the app can show (cast, task, problem, ending with a title in [lang])
    as [{id, text_en}] for internal/nimqueue/cmd/render-motifs."""
    titled = set()
    for p in (DATA_DIR / f"verbalizations.{lang}.jsonl", DATA_DIR / f"cards.{lang}.jsonl"):
        if p.exists():
            titled |= {v.motif_id for v in read_jsonl(p, Verbalization) if v.lang == lang and v.length == "title"}
    cards: dict[str, str] = {}
    for rec in read_jsonl(DATA_DIR / "tales.jsonl", TaleRecord):
        for m in rec.motifs:
            here = m.country_code == country or (country == WORLD and m.country_code and m.country_code not in exclude_countries)
            if here and m.type in types and m.id in titled:
                cards.setdefault(m.id, m.text_en)
    out.write_text(json.dumps([{"id": k, "text_en": v} for k, v in cards.items()], ensure_ascii=False, indent=1), encoding="utf-8")
    return len(cards)


# --country WORLD: every country without a pack of its own, in one file.
WORLD = "WORLD"


# The runtime slot scene_prompts leave for the chosen cast (RAG_PLAN §2.4).
# Pre-rendered scenes can't know the cast, so they get a neutral hero.
GENERIC_HERO = "a young hero"


AUDIO_CATALOG = Path(__file__).resolve().parents[1] / "audio" / "catalog.json"


def sound_rows(catalog: Path, sounds_dir: Path) -> list[tuple]:
    """(id, kind, key, mood, label_cs, match, m4a) for every rendered sound in the catalog."""
    c = json.loads(catalog.read_text(encoding="utf-8"))
    rows: list[tuple] = []

    def add(sid: str, kind: str, key: str, mood: str | None, label: str, match: list[str]) -> None:
        f = sounds_dir / f"{sid}.m4a"
        if f.exists():
            rows.append((sid, kind, key, mood, label, json.dumps(match, ensure_ascii=False), f.read_bytes()))

    for env, e in c["music"]["environments"].items():
        for mood in c["music"]["moods"]:
            add(f"music-{env}-{mood}", "music", env, mood, e["cs"], [env])
    for kind, section in (("creature", "creatures"), ("action", "actions")):
        for key, e in c["sfx"][section].items():
            add(f"{kind}-{key}", kind, key, None, e["cs"], e.get("match", []))
    return rows


def export_scenes(out: Path, country: str) -> int:
    """scene_prompts of [country]'s motifs as [{id, text_en}] for
    render-motifs -kind scene, with {character_refs} → a generic hero."""
    ids = {m.id for rec in read_jsonl(DATA_DIR / "tales.jsonl", TaleRecord) for m in rec.motifs if m.country_code == country}
    scenes = [{"id": s.id, "text_en": s.text_en.replace("{character_refs}", GENERIC_HERO)} for s in read_jsonl(DATA_DIR / "scene_prompts.jsonl", ScenePrompt) if s.motif_id in ids]
    out.write_text(json.dumps(scenes, ensure_ascii=False, indent=1), encoding="utf-8")
    return len(scenes)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    g = ap.add_mutually_exclusive_group(required=True)
    g.add_argument("--core", action="store_true")
    g.add_argument("--country", help="ISO 3166-1 alpha-2, e.g. DE")
    ap.add_argument("--out-dir", type=Path, default=DATA_DIR / "packs")
    ap.add_argument("--no-embed", action="store_true", help="skip vectors (pack won't support retrieval)")
    ap.add_argument("--embed-model", default=None)
    ap.add_argument("--images-dir", type=Path, default=DATA_DIR / "motif_images", help="<motif_id>.jpg card renders to embed (country packs)")
    ap.add_argument("--export-cards", type=Path, default=None, help="instead of building: write the motifs to render as JSON (needs --country)")
    ap.add_argument("--scene-images-dir", type=Path, default=DATA_DIR / "scene_images", help="<scene_id>.jpg renders to embed (country packs)")
    ap.add_argument("--export-scenes", type=Path, default=None, help="instead of building: write the scene prompts to render as JSON (needs --country)")
    ap.add_argument("--exclude", default="CZ", help="--country WORLD: comma list of countries that have their own pack")
    ap.add_argument("--card-types", default="character,task,problem,ending", help="--export-cards: motif types to export")
    ap.add_argument("--sounds-dir", type=Path, default=DATA_DIR / "sounds", help="<id>.m4a from render-audio (core pack)")
    args = ap.parse_args()
    exclude = frozenset(c.strip().upper() for c in args.exclude.split(",") if c.strip())

    if args.export_scenes:
        if not args.country:
            ap.error("--export-scenes needs --country")
        n = export_scenes(args.export_scenes, args.country.upper())
        log(f"build_pack: {n} scenes → {args.export_scenes}")
        return
    if args.export_cards:
        if not args.country:
            ap.error("--export-cards needs --country")
        n = export_cards(args.export_cards, args.lang, args.country.upper(), types=tuple(args.card_types.split(",")), exclude_countries=exclude)
        log(f"build_pack: {n} motif cards → {args.export_cards}")
        return

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
        embed=embed, embed_model=embed_model, embed_ver=embed_ver, images_dir=args.images_dir, scene_images_dir=args.scene_images_dir,
        sounds_dir=args.sounds_dir, audio_catalog=AUDIO_CATALOG,
        cards_path=DATA_DIR / f"cards.{args.lang}.jsonl", exclude_countries=exclude,
    )
    log(f"build_pack: {out} → " + ", ".join(f"{k}={v}" for k, v in counts.items()))


if __name__ == "__main__":
    main()
