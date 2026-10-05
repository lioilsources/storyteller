"""Stage 7: pack_builder — downloadable content packs + manifest
(STORYTELLER_MONETIZATION_PLAN.md §3, §5, §6, §8, §11).

Per country two tiers of tales:

    free   the 5 best tales — never behind the store
    paid   up to 50 more — unlocked by the `pack_<cc>` in-app purchase

Free tales ship per continent (rozhodnutí 2026-10-03, kvůli velikosti):
one pack `continent.<K>.<lang>.free` holds the free tales of every
country of continent K (rag/rag/continents.py). Europe (continents.BUNDLED)
goes into the app binary next to core — its raw SQLite file is written
to dist/bundle/ for the rag-packs-<lang>-N release that
app/rag_packs.sha256 pins; the other continents are free downloads.
Paid packs stay per country.

A third, separate kind (rozhodnutí 2026-10-05): `scenes.<CC>.<lang>.free`,
every rendered scene of one country's tales without the per-tale
budget — the bundled continent pack keeps only what fits 1.2 MB a tale
(Česko 1 408 of 16 145 scenes). It holds scene_prompts (id, motif, phase)
and scene_images only, no motifs, texts or vectors: the app finds a beat's
scene by motif+phase in the bundled pack first, then here, then shows the
motif's card (app/lib/rag/rag_store.dart, narration_screen.dart).

Each pack is one zip holding `pack.json` and a `rag.build_pack` SQLite
file limited to that pack's tales, so the app opens it exactly like the
bundled packs. The media (card art, scene art) is inside the SQLite
file; music and creature sounds are global and live in the core pack.

Which tale is in which tier is decided once and kept in
rag/packs-state.<lang>.json (committed): a tale never moves from free to
paid under a user who has it, and a new tale fills free only while free
has room. The same file keeps each pack's version and content hash — a
rebuild whose content didn't change keeps its version and byte-identical
zip, so the manifest's sha256 keeps matching the published asset.

Output (rag/data/dist/):

    manifest.json                          → storyteller-content GitHub Pages
    free-v1/continent-<k>-free-v<n>.zip    → release free-v1 assets
    free-v1/scenes-<cc>-v<n>.zip           → release free-v1 assets
    pack-<cc>-v<n>/<cc>-lite.zip           → release pack-<cc>-v<n>
    bundle/continent.EU.<lang>.free.db     → app binary (rag-packs release)
    sizes.json                             → per-pack sizes, for the plan

    python -m rag.pack_builder --lang cs              # every country
    python -m rag.pack_builder --lang cs --country GH
"""

from __future__ import annotations

import argparse
import hashlib
import os
import json
import sqlite3
import tempfile
import zipfile
from collections import defaultdict
from collections.abc import Callable
from concurrent.futures import ProcessPoolExecutor
from dataclasses import dataclass
from pathlib import Path

from . import continents
from .build_pack import EmbedFn, _card_or_none, build, create_schema, open_pack
from .io import DATA_DIR, log, read_jsonl
from .schemas import ScenePrompt, TaleRecord, Verbalization

RAG_DIR = Path(__file__).resolve().parents[1]
STATE_DIR = RAG_DIR
GEO = RAG_DIR.parent / "app" / "assets" / "geo" / "countries.json"

FREE_TALES = 5
PAID_TALES = 50

# Rozhodnutí 2026-10-04: celé Česko zdarma (domácí země) — všechny jeho
# zobrazitelné pohádky jsou free (tedy v balíčku Evropy v binárce) a placený
# balíček nemá. Ostatní země R1: 5 zdarma, zbytek placený.
FREE_ALL_COUNTRIES = frozenset({"CZ"})

# §3 budget for one tale, lite tier: text, hints and card/scene art of its
# motifs. The plan's 6 images (3 characters + 1-2 places + 1 motif, 90 KB
# WebP each) don't match what a tale carries here — a card per shown
# motif plus scene art, ≈34 KB JPEG at 512 px; Czech tales reach 20
# (2026-09-29). The byte limit is the plan's; the count only stops runaways.
TALE_BUDGET_BYTES = 1_200_000
TALE_MAX_IMAGES = 24

MIN_APP_VERSION = "1.4.0"

# Countries with a downloadable all-scenes pack, and their Czech name in
# the app. Scene art there is 448 px WebP q60, not the cards' 512 px q70:
# measured 2026-10-05 on 120 random Czech scenes, 16.2 vs 22.0 KB (−26 %,
# 16 145 scenes ≈ 268 instead of 364 MB) at SSIM 0.877 vs 0.894 against
# the render shown at phone width; side by side at 2.3× zoom the
# difference is a slightly softer edge, nothing a child would see.
# 384 px / q50 would save more but blurs faces (SSIM 0.856).
SCENES = {"CZ": "Česko – všechny scény"}
SCENE_PX = 448
SCENE_QUALITY = 60

# 3: free balíčky po kontinentech (sekce "continents"), země nesou jen placený.
SCHEMA = 3
CONTENT_REPO = "https://github.com/lioilsources/storyteller-content"
LICENCE = "Tales: public domain (Project Gutenberg and others, see source_ref). Text and art: generated for Storyteller."

# Fixed so equal content → equal bytes (see build(built_at=…)); zip entries likewise.
PINNED_TIME = "2026-01-01T00:00:00+00:00"
ZIP_TIME = (2026, 1, 1, 0, 0, 0)


class BudgetError(Exception):
    pass


@dataclass
class Tale:
    ref: str
    country: str
    motif_ids: list[str]
    score: float


def _titled(lang: str) -> set[str]:
    out: set[str] = set()
    for p in (DATA_DIR / f"verbalizations.{lang}.jsonl", DATA_DIR / f"cards.{lang}.jsonl"):
        if p.exists():
            out |= {v.motif_id for v in read_jsonl(p, Verbalization) if v.lang == lang and v.length == "title"}
    return out


def score_tales(tales_path: Path, lang: str, images_dir: Path, hint_counts: dict[str, int]) -> dict[str, list[Tale]]:
    """Tales per country that the app can show something from, best first.

    "Best" is readiness, not literary merit (the plan's LLM ranking of
    universality/playfulness is a later stage): shown motifs, card art and
    hints. Ties break on source_ref so the order is stable.
    """
    titled = _titled(lang)
    art = {p.stem for p in images_dir.glob("*.jpg")} if images_dir.is_dir() else set()
    per: dict[str, list[Tale]] = defaultdict(list)
    for rec in read_jsonl(tales_path, TaleRecord):
        ms = [m for m in rec.motifs if m.country_code]
        if not ms:
            continue
        shown = [m for m in ms if m.id in titled]
        if not shown:
            continue
        cc = ms[0].country_code
        score = 3 * len(shown) + 2 * sum(m.id in art for m in shown) + 0.1 * sum(hint_counts.get(m.id, 0) for m in shown)
        per[cc].append(Tale(rec.source_ref, cc, [m.id for m in ms], score))
    for cc in per:
        per[cc].sort(key=lambda t: (-t.score, t.ref))
    return per


def assign_tiers(state: dict, ranked: dict[str, list[Tale]]) -> None:
    """Extend state["countries"][cc]["free"/"paid"] with new tales, never moving
    one from free to paid. A FREE_ALL_COUNTRIES country takes every tale into
    free (paid ones from an older state move there too — only ever a gift)."""
    for cc, tales in ranked.items():
        c = state["countries"].setdefault(cc, {"free": [], "paid": []})
        all_free = cc in FREE_ALL_COUNTRIES
        if all_free and c["paid"]:
            c["free"] += c["paid"]
            c["paid"] = []
        placed = set(c["free"]) | set(c["paid"])
        for t in tales:
            if t.ref in placed:
                continue
            if all_free or len(c["free"]) < FREE_TALES:
                c["free"].append(t.ref)
            elif len(c["paid"]) < PAID_TALES:
                c["paid"].append(t.ref)
            placed.add(t.ref)


def content_hash(db: Path) -> str:
    """sha256 over every row but meta.built_at — what "changed" means for a
    version bump. The sqlite-vec tables (and their shadow tables) are
    skipped: they need the extension to read and hold the same vectors as
    the *_emb tables, which are hashed."""
    h = hashlib.sha256()
    conn = sqlite3.connect(db)
    try:
        tables = [r[0] for r in conn.execute("SELECT name FROM sqlite_master WHERE type = 'table' AND sql NOT LIKE 'CREATE VIRTUAL%' ORDER BY name")]
        for t in tables:
            if t == "meta" or "_vec" in t:
                continue
            h.update(t.encode())
            for row in conn.execute(f'SELECT * FROM "{t}" ORDER BY 1'):
                h.update(repr(row).encode())
    finally:
        conn.close()
    return h.hexdigest()


def trim_scene_art(db: Path, tale_motifs: dict[str, list[str]]) -> int:
    """Drop scene art (never card art) from a tale over the §3 budget until
    it fits: the scene_prompts slice rendered ~100 scenes for the first two
    Erben tales (2026-09-27). The scene text stays; the app shows a scene
    without art as text. Deterministic — keeps the lowest scene ids."""
    conn = sqlite3.connect(db)
    dropped = 0
    try:
        for ids in tale_motifs.values():
            q = ",".join("?" * len(ids))
            cards_n, cards_b = conn.execute(f"SELECT COUNT(*), COALESCE(SUM(LENGTH(jpeg)),0) FROM motif_images WHERE motif_id IN ({q})", ids).fetchone()
            other = conn.execute(f"SELECT COALESCE(SUM(LENGTH(text)),0) FROM verbalizations WHERE motif_id IN ({q})", ids).fetchone()[0]
            other += conn.execute(f"SELECT COALESCE(SUM(LENGTH(h.text) + LENGTH(h.situation_en) + LENGTH(e.emb)),0) FROM hint_bank h JOIN hint_emb e ON e.id = h.id WHERE h.motif_id IN ({q})", ids).fetchone()[0]
            room_b, room_n = TALE_BUDGET_BYTES - cards_b - other, TALE_MAX_IMAGES - cards_n
            rows = conn.execute(f"SELECT i.scene_id, LENGTH(i.jpeg) FROM scene_images i JOIN scene_prompts s ON s.id = i.scene_id WHERE s.motif_id IN ({q}) ORDER BY i.scene_id", ids).fetchall()
            kept_b = kept_n = 0
            for sid, n in rows:
                if kept_n < room_n and kept_b + n <= room_b:
                    kept_b, kept_n = kept_b + n, kept_n + 1
                else:
                    conn.execute("DELETE FROM scene_images WHERE scene_id = ?", (sid,))
                    dropped += 1
        conn.commit()
        if dropped:
            conn.execute("VACUUM")
    finally:
        conn.close()
    return dropped


def check_budget(db: Path, tale_motifs: dict[str, list[str]]) -> dict[str, int]:
    """Bytes per tale; raises BudgetError naming every tale over the §3 limit."""
    conn = sqlite3.connect(db)
    over: list[str] = []
    sizes: dict[str, int] = {}
    try:
        for ref, ids in tale_motifs.items():
            q = ",".join("?" * len(ids))
            imgs = conn.execute(f"SELECT COUNT(*), COALESCE(SUM(LENGTH(jpeg)),0) FROM motif_images WHERE motif_id IN ({q})", ids).fetchone()
            scenes = conn.execute(f"SELECT COUNT(*), COALESCE(SUM(LENGTH(i.jpeg)),0) FROM scene_images i JOIN scene_prompts s ON s.id = i.scene_id WHERE s.motif_id IN ({q})", ids).fetchone()
            text = conn.execute(f"SELECT COALESCE(SUM(LENGTH(text)),0) FROM verbalizations WHERE motif_id IN ({q})", ids).fetchone()[0]
            hints = conn.execute(f"SELECT COALESCE(SUM(LENGTH(h.text) + LENGTH(h.situation_en) + LENGTH(e.emb)),0) FROM hint_bank h JOIN hint_emb e ON e.id = h.id WHERE h.motif_id IN ({q})", ids).fetchone()[0]
            n = imgs[1] + scenes[1] + text + hints
            sizes[ref] = n
            if n > TALE_BUDGET_BYTES or imgs[0] + scenes[0] > TALE_MAX_IMAGES:
                over.append(f"{ref}: {n} B, {imgs[0] + scenes[0]} images")
    finally:
        conn.close()
    if over:
        raise BudgetError("over the §3 per-tale budget:\n  " + "\n  ".join(over))
    return sizes


def write_zip(out: Path, members: dict[str, bytes]) -> None:
    """Deterministic zip: sorted names, fixed timestamps. The SQLite file
    compresses (text, vectors); the JPEGs inside it don't, but they're
    BLOBs in the same file, so one deflate for the whole thing."""
    out.parent.mkdir(parents=True, exist_ok=True)
    with zipfile.ZipFile(out, "w") as z:
        for name in sorted(members):
            info = zipfile.ZipInfo(name, ZIP_TIME)
            info.compress_type = zipfile.ZIP_DEFLATED
            info.external_attr = 0o644 << 16
            z.writestr(info, members[name], compresslevel=9)


def sha256_file(p: Path) -> str:
    h = hashlib.sha256()
    with p.open("rb") as f:
        for chunk in iter(lambda: f.read(1 << 20), b""):
            h.update(chunk)
    return h.hexdigest()


def build_one(pack_id: str, rel: Callable[[int], str], refs: list[str], lang: str, state_entry: dict, dist: Path, *, label: str, countries: frozenset[str], pack_meta: dict, tales_path: Path, embed: EmbedFn | None, embed_model: str, embed_ver: str, images_dir: Path, scene_images_dir: Path, bundle: Path | None = None) -> dict | None:
    """Build one pack's zip at dist/[rel](version); returns its manifest entry (None if
    it has no tales). The version in [state_entry] bumps only when the
    content hash changes. [bundle]: also keep the raw SQLite file there
    (the continent the app binary carries)."""
    if not refs:
        return None
    tale_motifs: dict[str, list[str]] = defaultdict(list)
    wanted = set(refs)
    for rec in read_jsonl(tales_path, TaleRecord):
        if rec.source_ref in wanted:
            tale_motifs[rec.source_ref] = [m.id for m in rec.motifs]
    db_name = f"{pack_id}.db"
    with tempfile.TemporaryDirectory() as tmp:
        db = Path(tmp) / db_name
        counts = build(
            db, lang, country=label, countries=countries, tales_path=tales_path,
            verbalizations_path=DATA_DIR / f"verbalizations.{lang}.jsonl",
            hints_path=DATA_DIR / f"hints.{lang}.jsonl", transitions_path=None,
            scene_prompts_path=DATA_DIR / "scene_prompts.jsonl",
            embed=embed, embed_model=embed_model, embed_ver=embed_ver,
            images_dir=images_dir, scene_images_dir=scene_images_dir,
            cards_path=DATA_DIR / f"cards.{lang}.jsonl",
            source_refs=frozenset(refs), pack_id=pack_id, compat=False, built_at=PINNED_TIME,
        )
        trimmed = trim_scene_art(db, tale_motifs)
        if trimmed:
            log(f"pack_builder: {pack_id}: {trimmed} scene images over the per-tale budget dropped")
        sizes = check_budget(db, tale_motifs)
        chash = content_hash(db)
        if state_entry.get("hash") != chash:
            state_entry["version"] = state_entry.get("version", 0) + 1
            state_entry["hash"] = chash
        version = state_entry["version"]
        data = db.read_bytes()
        conn = sqlite3.connect(db)
        try:
            images = conn.execute("SELECT (SELECT COUNT(*) FROM motif_images) + (SELECT COUNT(*) FROM scene_images)").fetchone()[0]
        finally:
            conn.close()
        if bundle is not None:
            bundle.mkdir(parents=True, exist_ok=True)
            (bundle / db_name).write_bytes(data)
    pack_json = {
        "id": pack_id, "lang": lang, "version": version, **pack_meta,
        "min_app_version": MIN_APP_VERSION, "licence": LICENCE, "tales": sorted(refs),
        "files": {db_name: {"size": len(data), "sha256": hashlib.sha256(data).hexdigest()}},
    }
    members = {"pack.json": json.dumps(pack_json, ensure_ascii=False, indent=1, sort_keys=True).encode(), db_name: data}
    out = dist / rel(version)
    write_zip(out, members)
    log(f"pack_builder: {rel(version)} {out.stat().st_size} B, {len(refs)} tales, max {max(sizes.values())} B/tale, " + ", ".join(f"{k}={v}" for k, v in counts.items() if k in ("motifs", "motif_images", "hint_bank")))
    return {"version": version, "size": out.stat().st_size, "sha256": sha256_file(out), "tales": len(refs), "db_size": len(data), "images": images, "file": out.name}


def _scene_art(path: Path) -> bytes | None:
    return _card_or_none(path, SCENE_PX, SCENE_QUALITY)


def build_scenes_db(db: Path, cc: str, lang: str, *, tales_path: Path, scene_prompts_path: Path, scene_images_dir: Path, workers: int | None = None) -> int:
    """The SQLite file of `scenes.<cc>.<lang>.free`: build_pack's schema
    (so RagStore opens it like any pack), but only scene_prompts with
    their art — no motifs, verbalizations, hints or vectors, and
    scene_prompts.text_en left empty (the app never reads it). Every scene
    of [cc]'s tales that has a render; no budget. Returns images stored."""
    if not scene_prompts_path.exists() or not scene_images_dir.is_dir():
        return 0
    ids = {m.id for rec in read_jsonl(tales_path, TaleRecord) for m in rec.motifs if m.country_code == cc}
    sps = sorted((s for s in read_jsonl(scene_prompts_path, ScenePrompt) if s.motif_id in ids and (scene_images_dir / f"{s.id}.jpg").exists()), key=lambda s: s.id)
    if not sps:
        return 0
    if db.exists():
        db.unlink()
    conn = open_pack(db, with_vec=False)
    try:
        create_schema(conn, with_vec=False)
        # 16 k renders × ~70 ms of WebP method 6: in parallel, results in order.
        with ProcessPoolExecutor(max_workers=workers or os.cpu_count()) as ex:
            art = list(ex.map(_scene_art, [scene_images_dir / f"{s.id}.jpg" for s in sps], chunksize=64))
        kept = [(s, a) for s, a in zip(sps, art) if a]
        conn.executemany("INSERT INTO scene_prompts VALUES (?,?,?,?,?)", [(s.id, s.motif_id, s.environment_id, s.phase, "") for s, _ in kept])
        conn.executemany("INSERT INTO scene_images VALUES (?,?)", [(s.id, a) for s, a in kept])
        conn.execute("INSERT INTO meta VALUES (?,?,?,?,?,?,?,?)", (f"scenes.{cc}.{lang}.free", 1, lang, f"scenes:{cc}", "", "", 0, PINNED_TIME))
        conn.commit()
        conn.execute("VACUUM")
    finally:
        conn.close()
    return len(kept)


def build_scenes(cc: str, lang: str, state_entry: dict, dist: Path, *, tales_path: Path, scene_prompts_path: Path, scene_images_dir: Path) -> dict | None:
    """dist/free-v1/scenes-<cc>-v<n>.zip; its manifest entry, or None when
    [cc] has no rendered scene. Versioned like build_one (bumps only when
    the content hash changes)."""
    pack_id = f"scenes.{cc}.{lang}.free"
    db_name = f"{pack_id}.db"
    with tempfile.TemporaryDirectory() as tmp:
        db = Path(tmp) / db_name
        images = build_scenes_db(db, cc, lang, tales_path=tales_path, scene_prompts_path=scene_prompts_path, scene_images_dir=scene_images_dir)
        if not images:
            return None
        chash = content_hash(db)
        if state_entry.get("hash") != chash:
            state_entry["version"] = state_entry.get("version", 0) + 1
            state_entry["hash"] = chash
        version = state_entry["version"]
        data = db.read_bytes()
    pack_json = {
        "id": pack_id, "lang": lang, "version": version, "country": cc, "tier": "free", "kind": "scenes",
        "min_app_version": MIN_APP_VERSION, "licence": LICENCE, "images": images,
        "files": {db_name: {"size": len(data), "sha256": hashlib.sha256(data).hexdigest()}},
    }
    rel = f"free-v1/scenes-{cc.lower()}-v{version}.zip"
    out = dist / rel
    write_zip(out, {"pack.json": json.dumps(pack_json, ensure_ascii=False, indent=1, sort_keys=True).encode(), db_name: data})
    log(f"pack_builder: {rel} {out.stat().st_size} B, {images} scene images ({SCENE_PX} px WebP q{SCENE_QUALITY})")
    return {"version": version, "size": out.stat().st_size, "sha256": sha256_file(out), "images": images, "db_size": len(data), "file": out.name}


def country_names() -> dict[str, str]:
    try:
        return {c["i"]: c["n"] for c in json.loads(GEO.read_text(encoding="utf-8"))}
    except (OSError, ValueError):
        return {}


def build_all(lang: str, countries: set[str] | None, *, embed: EmbedFn | None, embed_model: str, embed_ver: str, dist: Path, state_path: Path, tales_path: Path = DATA_DIR / "tales.jsonl", images_dir: Path = DATA_DIR / "motif_images", scene_images_dir: Path = DATA_DIR / "scene_images", scene_prompts_path: Path | None = None) -> dict:
    """[countries] limits the paid packs built to those countries and the
    free packs to their continents (a continent pack always holds every
    country of the continent the state knows)."""
    state = json.loads(state_path.read_text(encoding="utf-8")) if state_path.exists() else {"lang": lang, "countries": {}}
    scene_prompts_path = scene_prompts_path or DATA_DIR / "scene_prompts.jsonl"
    hint_counts: dict[str, int] = defaultdict(int)
    hp = DATA_DIR / f"hints.{lang}.jsonl"
    if hp.exists():
        for line in hp.open(encoding="utf-8"):
            mid = json.loads(line).get("motif_id")
            if mid:
                hint_counts[mid] += 1
    ranked = score_tales(tales_path, lang, images_dir, hint_counts)
    if countries:
        ranked = {cc: t for cc, t in ranked.items() if cc in countries}
    for cc in ranked:
        continents.continent_of(cc)  # unknown country → fail before building anything
    assign_tiers(state, ranked)

    manifest_path = dist / "manifest.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else {}
    if manifest.get("schema") != SCHEMA:
        manifest = {}  # schema 2 had free packs per country; nothing of it carries over
    manifest.update({
        "schema": SCHEMA, "lang": lang, "min_app_version": MIN_APP_VERSION,
        "base_urls": {"free": f"{CONTENT_REPO}/releases/download/free-v1/", "paid": f"{CONTENT_REPO}/releases/download/"},
    })
    names = country_names()
    kw = dict(tales_path=tales_path, embed=embed, embed_model=embed_model, embed_ver=embed_ver, images_dir=images_dir, scene_images_dir=scene_images_dir)
    sizes_path = dist / "sizes.json"
    sizes = json.loads(sizes_path.read_text(encoding="utf-8")) if sizes_path.exists() else {}

    # free: one pack per continent
    by_cont: dict[str, list[str]] = defaultdict(list)
    for cc in sorted(state["countries"]):
        by_cont[continents.continent_of(cc)].append(cc)
    todo = {continents.continent_of(cc) for cc in ranked}
    mk = manifest.setdefault("continents", {})
    for k in sorted(todo):
        ccs = [cc for cc in by_cont[k] if state["countries"][cc]["free"]]
        refs = [r for cc in ccs for r in state["countries"][cc]["free"]]
        entry = state.setdefault("continents", {}).setdefault(k, {})
        low = k.lower()
        bundled = k in continents.BUNDLED
        free = build_one(
            f"continent.{k}.{lang}.free", lambda v: f"free-v1/continent-{low}-free-v{v}.zip", refs, lang, entry, dist,
            label=f"continent:{k}", countries=frozenset(ccs), pack_meta={"continent": k, "countries": ccs, "tier": "free"},
            bundle=dist / "bundle" if bundled else None, **kw,
        ) if refs else None
        if free is None:
            mk.pop(low, None)
            continue
        mk[low] = {
            "name": continents.NAMES[k], "bundled": bundled, "countries": ccs,
            "free": {"version": free["version"], "size": free["size"], "sha256": free["sha256"], "tales": free["tales"], "file": free["file"]},
        }
        sizes[f"continent.{k}"] = {"zip": free["size"], "db": free["db_size"], "tales": free["tales"], "images": free["images"], "countries": len(ccs), "bundled": bundled}
    manifest["continents"] = dict(sorted(mk.items()))

    # paid: per country, as before
    mc = manifest.setdefault("countries", {})
    for cc in sorted(ranked):
        entry = state["countries"][cc]
        low = cc.lower()
        pentry = entry.setdefault("paid_pack", {})
        paid = build_one(
            f"country.{cc}.{lang}.paid", lambda v: f"pack-{low}-v{v}/{low}-lite.zip", entry["paid"], lang, pentry, dist,
            label=cc, countries=frozenset({cc}), pack_meta={"country": cc, "tier": "lite"}, **kw,
        )
        c: dict = {"name": {"en": names.get(cc, cc)}, "continent": continents.continent_of(cc), "free_tales": len(entry["free"])}
        if paid:
            c["paid"] = {"product_id": f"pack_{low}", "version": paid["version"], "tales": paid["tales"], "tiers": {"lite": {"size": paid["size"], "sha256": paid["sha256"]}}}
            sizes[f"country.{cc}.paid"] = {"zip": paid["size"], "db": paid["db_size"], "tales": paid["tales"], "images": paid["images"]}
        mc[low] = c
    manifest["countries"] = dict(sorted(mc.items()))

    # scenes: every rendered scene of a country, free, outside the binary
    ms = manifest.setdefault("scenes", {})
    for cc in sorted(SCENES):
        if countries and cc not in countries:
            continue
        sentry = state.setdefault("scenes", {}).setdefault(cc, {})
        sc = build_scenes(cc, lang, sentry, dist, tales_path=tales_path, scene_prompts_path=scene_prompts_path, scene_images_dir=scene_images_dir)
        if sc is None:
            ms.pop(cc.lower(), None)
            continue
        ms[cc.lower()] = {
            "name": {"cs": SCENES[cc]}, "country": cc,
            "free": {"version": sc["version"], "size": sc["size"], "sha256": sc["sha256"], "images": sc["images"], "file": sc["file"]},
        }
        sizes[f"scenes.{cc}"] = {"zip": sc["size"], "db": sc["db_size"], "images": sc["images"], "px": SCENE_PX, "quality": SCENE_QUALITY}
    manifest["scenes"] = dict(sorted(ms.items()))
    dist.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    sizes_path.write_text(json.dumps(dict(sorted(sizes.items())), indent=1) + "\n", encoding="utf-8")
    state_path.write_text(json.dumps(state, ensure_ascii=False, indent=1, sort_keys=True) + "\n", encoding="utf-8")
    return manifest


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    ap.add_argument("--country", default="", help="comma list of ISO codes; default every country with showable tales")
    ap.add_argument("--dist", type=Path, default=DATA_DIR / "dist")
    ap.add_argument("--no-embed", action="store_true", help="tests only: packs without vectors are refused by the app")
    args = ap.parse_args()
    embed: EmbedFn | None = None
    embed_model = embed_ver = ""
    if not args.no_embed:
        from .embed import DEFAULT_MODEL, Embedder

        e = Embedder(DEFAULT_MODEL)
        embed, embed_model, embed_ver = e.passages, e.model_name, e.version
    countries = {c.strip().upper() for c in args.country.split(",") if c.strip()} or None
    m = build_all(args.lang, countries, embed=embed, embed_model=embed_model, embed_ver=embed_ver, dist=args.dist, state_path=STATE_DIR / f"packs-state.{args.lang}.json")
    log(f"pack_builder: manifest with {len(m['countries'])} countries → {args.dist / 'manifest.json'}")


if __name__ == "__main__":
    main()
