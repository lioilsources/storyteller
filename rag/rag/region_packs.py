"""Stage 7 v2: balíčky po regionech + manifest schema 4
(STORYTELLER_PACKS_V2_PLAN.md §1, §3; nahrazuje kontinenty a placené země
z rag.pack_builder).

Každý region (rag/rag/regions.py) má:

    region.<KOD>.<lang>.free    přesně 10 pohádek, zdarma, v binárce appky
    region.<KOD>.<lang>.p<N>    díl N, přesně 50 pohádek, produkt pack_<kod>_<N>

Pořadí pohádek regionu je **fronta** ve stavu (rag/packs-state.v2.<lang>.json,
commitovaný): na střídačku po zemích (ne 50 řeckých za sebou), v zemi podle
připravenosti, pohádky se stálou vadou (bez titulku úkolu/problému/konce,
bez karty, bez postavy, s cyrilicí) až na konci. Fronta se jen
prodlužuje — nová pohádka jde na konec, pořadí starých se nemění, takže
pipeline ví, pro které pohádky má nápovědy, scény a zvuky dělat napřed
(`--plan` vypíše frontu do rag/data/tale_order.<lang>.jsonl).

Díl vznikne, až ho je z čeho postavit: free desítka = prvních 10 pohádek
fronty, které projdou validátorem (rag.pack_check) na úrovni A, díl =
dalších 50 na úrovni B. Pohádka, která neprojde, čeká a díl si vezme
další ve frontě; díl „na 32“ nevzniká. Jednou postavený díl je
**zmrazený**: seznam pohádek se nemění (koupené nesmí zmizet), nová verze
jen opravuje obsah. Placené díly se nestaví, dokud region nemá free.

Výstup (rag/data/dist/):

    manifest.v4.json                        → storyteller-content GitHub Pages
    free-v2/region-<k>-free-v<n>.zip        → release free-v2
    region-<k>-p<N>-v<n>/<k>-p<N>.zip       → release region-<k>-p<N>-v<n>
    bundle/region.<KOD>.<lang>.free.db      → binárka appky (rag-packs release)
    sizes.v4.json

Manifest je nový soubor vedle manifest.json (schema 3): klienti do 1.6
dál čtou ten starý a jejich balíčky zůstávají v release free-v1.

    python -m rag.region_packs --lang cs --plan          # jen fronta a co chybí
    python -m rag.region_packs --lang cs                 # postavit, co projde
    python -m rag.region_packs --lang cs --region AFRI --waive sounds
"""

from __future__ import annotations

import argparse
import json
from collections import Counter, defaultdict
from pathlib import Path

from . import pack_builder as pb
from . import regions
from .build_pack import EmbedFn
from .io import log
from .pack_check import CHECKS, LEVELS, Corpus, check_pack, check_tale

FREE_TALES = 10
PART_TALES = 50
SCHEMA = 4
MIN_APP_VERSION = "1.7.0"
# Vady, které pipeline nespraví dalším během nápověd/scén/zvuků: pohádka
# s nimi jde na konec fronty.
STATIC_CHECKS = frozenset({"motifs", "cards", "characters", "texts"})
# Free díly všech regionů jsou v binárce, ať glóbus po instalaci svítí všude.
BUNDLED = frozenset(regions.ORDER)


class PackError(Exception):
    pass


def readiness(c: Corpus, ref: str) -> float:
    """Jako pack_builder.score_tales, bez nápověd: ty přibývají během práce
    podle fronty a nesmějí ji zpětně přeskládat."""
    shown = [m for m in c.tales[ref].motifs if m.id in c.titles]
    return 3 * len(shown) + 2 * sum(m.id in c.art for m in shown)


def extend_queues(state: dict, c: Corpus) -> None:
    """Doplní do front regionů pohádky, které v nich ještě nejsou."""
    new: dict[str, dict[str, list[str]]] = defaultdict(lambda: defaultdict(list))
    queued = {ref for r in state["regions"].values() for ref in r["queue"]}
    for ref, rec in c.tales.items():
        cc = c.country(ref)
        if not cc or ref in queued or not any(m.id in c.titles for m in rec.motifs):
            continue
        new[regions.region_of(cc)][cc].append(ref)
    for k, by_country in new.items():
        r = state["regions"].setdefault(k, {"queue": []})
        sound, flawed = [], []
        for cc in by_country:
            by_country[cc].sort(key=lambda ref: (-readiness(c, ref), ref))
        # Na střídačku po zemích, největší země první; zvlášť zdravé a vadné.
        order = sorted(by_country, key=lambda cc: (-len(by_country[cc]), cc))
        ok = {ref: not (set(check_tale(c, ref, LEVELS["A"])) & STATIC_CHECKS) for cc in order for ref in by_country[cc]}
        for bucket, want in ((sound, True), (flawed, False)):
            lists = {cc: [ref for ref in by_country[cc] if ok[ref] is want] for cc in order}
            while any(lists.values()):
                for cc in order:
                    if lists[cc]:
                        bucket.append(lists[cc].pop(0))
        r["queue"] += sound + flawed


def _take(c: Corpus, queue: list[str], taken: set[str], n: int, level: str, waive: frozenset[str]) -> list[str]:
    out: list[str] = []
    for ref in queue:
        if len(out) == n:
            break
        if ref not in taken and ref in c.tales and not (set(check_tale(c, ref, LEVELS[level])) - waive):
            out.append(ref)
    return out


def plan_rows(state: dict, c: Corpus) -> list[dict]:
    """Fronta jako seznam práce pro pipeline: free všech regionů, pak 1. díly, …
    Zmrazené díly podle stavu, zbytek fronty po 10 a po 50 v pořadí fronty."""
    rows: list[dict] = []
    for k in regions.ORDER:
        r = state["regions"].get(k)
        if not r:
            continue
        frozen = {ref: "free" for ref in r.get("free", {}).get("tales", [])}
        for i, p in enumerate(r.get("parts", [])):
            frozen.update({ref: f"p{i + 1}" for ref in p["tales"]})
        rest = [ref for ref in r["queue"] if ref not in frozen]
        if "free" not in r:
            frozen.update({ref: "free" for ref in rest[:FREE_TALES]})
            rest = rest[FREE_TALES:]
        first = len(r.get("parts", [])) + 1
        for i, ref in enumerate(rest):
            frozen[ref] = f"p{first + i // PART_TALES}"
        rank: Counter = Counter()
        sizes = Counter(frozen.values())
        for ref in r["queue"]:
            pack = frozen[ref]
            rank[pack] += 1
            problems = check_tale(c, ref, LEVELS["A" if pack == "free" else "B"]) if ref in c.tales else {"motifs": "pohádka zmizela z korpusu"}
            rows.append({"region": k, "pack": pack, "rank": rank[pack], "country": c.country(ref) if ref in c.tales else "", "source_ref": ref, "missing": sorted(problems), "partial": pack != "free" and sizes[pack] < PART_TALES})
    rows.sort(key=lambda o: (0 if o["pack"] == "free" else int(o["pack"][1:]), o["rank"], regions.ORDER.index(o["region"])))
    return rows


def _entry(built: dict) -> dict:
    return {"version": built["version"], "size": built["size"], "sha256": built["sha256"], "tales": built["tales"], "file": built["file"]}


def build_all(lang: str, only: set[str] | None, *, embed: EmbedFn | None, embed_model: str, embed_ver: str, dist: Path, state_path: Path, data_dir: Path | None = None, tales_path: Path | None = None, images_dir: Path | None = None, scene_images_dir: Path | None = None, waive: frozenset[str] = frozenset(), plan_only: bool = False) -> dict:
    """Postaví díly regionů [only] (výchozí všech), které projdou
    validátorem, a přepíše manifest; ostatní regiony v manifestu zůstanou,
    jak byly. [waive]: kontroly, které se nepočítají (zapíše se do
    pack.json dílu). [plan_only]: jen doplnit frontu a vrátit manifest beze změny."""
    data_dir = data_dir or pb.DATA_DIR
    tales_path = tales_path or data_dir / "tales.jsonl"
    images_dir = images_dir or data_dir / "motif_images"
    scene_images_dir = scene_images_dir or data_dir / "scene_images"
    c = Corpus.load(lang, data_dir=data_dir, tales_path=tales_path, images_dir=images_dir, scene_images_dir=scene_images_dir)
    state = json.loads(state_path.read_text(encoding="utf-8")) if state_path.exists() else {"lang": lang, "regions": {}}
    extend_queues(state, c)

    manifest_path = dist / "manifest.v4.json"
    manifest = json.loads(manifest_path.read_text(encoding="utf-8")) if manifest_path.exists() else {}
    if plan_only:
        state_path.write_text(json.dumps(state, ensure_ascii=False, indent=1, sort_keys=True) + "\n", encoding="utf-8")
        return manifest
    manifest.update({
        "schema": SCHEMA, "lang": lang, "min_app_version": MIN_APP_VERSION,
        "base_urls": {"free": f"{pb.CONTENT_REPO}/releases/download/free-v2/", "paid": f"{pb.CONTENT_REPO}/releases/download/"},
    })
    old = dist / "manifest.json"  # „Česko – všechny scény“ staví dál rag.pack_builder
    if "scenes" not in manifest and old.exists():
        manifest["scenes"] = json.loads(old.read_text(encoding="utf-8")).get("scenes", {})
    manifest.setdefault("scenes", {})
    mr = manifest.setdefault("regions", {})
    sizes_path = dist / "sizes.v4.json"
    sizes = json.loads(sizes_path.read_text(encoding="utf-8")) if sizes_path.exists() else {}
    kw = dict(tales_path=tales_path, embed=embed, embed_model=embed_model, embed_ver=embed_ver, images_dir=images_dir, scene_images_dir=scene_images_dir)
    vectors = embed is not None

    def build(k: str, tier: str, refs: list[str], entry: dict, rel, expect: int, bundle: bool) -> dict:
        ccs = sorted({c.country(ref) for ref in refs})
        meta = {"region": k, "countries": ccs, "tier": tier}
        if waive:
            meta["waived"] = sorted(waive)
        built = pb.build_one(f"region.{k}.{lang}.{tier}", rel, refs, lang, entry, dist, label=f"region:{k}", countries=frozenset(ccs), pack_meta=meta, bundle=dist / "bundle" if bundle else None, **kw)
        assert built is not None
        errs = check_pack(dist / rel(built["version"]), region=k, refs=refs, expect=expect, sha256=built["sha256"], vectors=vectors)
        if errs:
            raise PackError(f"region.{k}.{lang}.{tier}: " + "; ".join(errs))
        sizes[f"region.{k}.{tier}"] = {"zip": built["size"], "db": built["db_size"], "tales": built["tales"], "images": built["images"], "countries": len(ccs)}
        return built

    for k in regions.ORDER:
        r = state["regions"].get(k)
        if not r or (only and k not in only):
            continue
        low = k.lower()
        taken = set(r.get("free", {}).get("tales", [])) | {ref for p in r.get("parts", []) for ref in p["tales"]}
        if "free" not in r:
            picked = _take(c, r["queue"], taken, FREE_TALES, "A", waive)
            if len(picked) < FREE_TALES:
                log(f"region_packs: {k}: free čeká, úrovní A prošlo {len(picked)} z {FREE_TALES} potřebných pohádek")
                continue
            r["free"] = {"tales": picked}
            taken |= set(picked)
        free = build(k, "free", r["free"]["tales"], r["free"], lambda v: f"free-v2/region-{low}-free-v{v}.zip", FREE_TALES, k in BUNDLED)
        parts = r.setdefault("parts", [])
        while True:
            picked = _take(c, r["queue"], taken, PART_TALES, "B", waive)
            if len(picked) < PART_TALES:
                break
            parts.append({"tales": picked})
            taken |= set(picked)
        mparts = []
        for i, p in enumerate(parts):
            n = i + 1
            built = build(k, f"p{n}", p["tales"], p, lambda v, n=n: f"region-{low}-p{n}-v{v}/{low}-p{n}.zip", PART_TALES, False)
            mparts.append({"n": n, "product_id": f"pack_{low}_{n}", **_entry(built)})
        mr[low] = {"name": regions.NAMES[k], "bundled": k in BUNDLED, "countries": sorted({c.country(ref) for ref in r["queue"] if ref in c.tales}), "free": _entry(free), "parts": mparts}
    manifest["regions"] = {k.lower(): mr[k.lower()] for k in regions.ORDER if k.lower() in mr}

    # Země: kolik pohádek je v kterém dílu — glóbus to ukazuje bez stahování.
    names = pb.country_names()
    mc: dict[str, dict] = {}
    for k in regions.ORDER:
        r = state["regions"].get(k)
        if not r or k.lower() not in manifest["regions"]:
            continue
        where = {ref: "free" for ref in r.get("free", {}).get("tales", [])}
        for i, p in enumerate(r.get("parts", [])):
            where.update({ref: str(i + 1) for ref in p["tales"]})
        for ref in r["queue"]:
            if ref not in c.tales:
                continue
            cc = c.country(ref)
            e = mc.setdefault(cc.lower(), {"name": {"en": names.get(cc, cc)}, "region": k, "tales": 0, "in": {"free": 0, "parts": {}}, "coming": 0})
            w = where.get(ref)
            if w is None:
                e["coming"] += 1
                continue
            e["tales"] += 1
            if w == "free":
                e["in"]["free"] += 1
            else:
                e["in"]["parts"][w] = e["in"]["parts"].get(w, 0) + 1
    manifest["countries"] = dict(sorted(mc.items()))

    dist.mkdir(parents=True, exist_ok=True)
    manifest_path.write_text(json.dumps(manifest, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")
    sizes_path.write_text(json.dumps(dict(sorted(sizes.items())), indent=1) + "\n", encoding="utf-8")
    state_path.write_text(json.dumps(state, ensure_ascii=False, indent=1, sort_keys=True) + "\n", encoding="utf-8")
    return manifest


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    ap.add_argument("--region", default="", help="čárkami oddělené kódy regionů; výchozí všechny")
    ap.add_argument("--data", type=Path, default=pb.DATA_DIR, help="adresář s tales.jsonl a výstupy pipeline")
    ap.add_argument("--dist", type=Path, help="výchozí <data>/dist")
    ap.add_argument("--plan", action="store_true", help="nic nestavět: doplnit frontu a vypsat ji do <data>/tale_order.<lang>.jsonl")
    ap.add_argument("--waive", default="", help=f"kontroly validátoru, které se nepočítají: {', '.join(CHECKS)}")
    ap.add_argument("--no-embed", action="store_true", help="jen testy: balíček bez vektorů appka odmítne")
    args = ap.parse_args()
    only = {r.strip().upper() for r in args.region.split(",") if r.strip()} or None
    if only and only - set(regions.ORDER):
        ap.error(f"neznámý region: {', '.join(sorted(only - set(regions.ORDER)))}")
    waive = frozenset(w.strip() for w in args.waive.split(",") if w.strip())
    if waive - set(CHECKS):
        ap.error(f"neznámá kontrola: {', '.join(sorted(waive - set(CHECKS)))}")
    pb.DATA_DIR = args.data  # build_one bere karty, nápovědy a scény odtud
    dist = args.dist or args.data / "dist"
    state_path = pb.STATE_DIR / f"packs-state.v2.{args.lang}.json"
    embed: EmbedFn | None = None
    embed_model = embed_ver = ""
    if not args.no_embed and not args.plan:
        from .embed import DEFAULT_MODEL, Embedder

        e = Embedder(DEFAULT_MODEL)
        embed, embed_model, embed_ver = e.passages, e.model_name, e.version
    m = build_all(args.lang, only, embed=embed, embed_model=embed_model, embed_ver=embed_ver, dist=dist, state_path=state_path, data_dir=args.data, waive=waive, plan_only=args.plan)
    if args.plan:
        state = json.loads(state_path.read_text(encoding="utf-8"))
        rows = plan_rows(state, Corpus.load(args.lang, data_dir=args.data))
        out = args.data / f"tale_order.{args.lang}.jsonl"
        out.write_text("".join(json.dumps(o, ensure_ascii=False) + "\n" for o in rows), encoding="utf-8")
        free = [o for o in rows if o["pack"] == "free"]
        log(f"region_packs: fronta {len(rows)} pohádek → {out}; free {len(free)}, z toho úrovní A dnes projde {sum(not o['missing'] for o in free)}")
        return
    log(f"region_packs: manifest s {len(m.get('regions', {}))} regiony a {len(m.get('countries', {}))} zeměmi → {dist / 'manifest.v4.json'}")


if __name__ == "__main__":
    main()
