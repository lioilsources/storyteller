"""Validátor konzistence balíčků (STORYTELLER_PACKS_V2_PLAN.md §3, D5).

Běží před stavbou každého dílu (`rag.region_packs`): pohádka, která
neprojde, do dílu nejde a čeká; díl se staví, až má plný počet pohádek,
které prošly. Report je zároveň seznam práce pro pipeline („AFRI: 37
pohádek bez nápověd“).

Dvě úrovně, aby se free varianta nedržela na tom, co svět ještě nemá:

    A  free desítka regionu       B  placené díly
    úkol + problém + konec s titulkem a větou             (obě)
    každý zobrazený motiv má kartu                        (obě)
    ≥ 1 postava s kartou          ≥ 2
    ≥ 3 nápovědy ve vlastní fázi  ≥ 5 ve všech pěti fázích   (konce nápovědy nemají)
    titulek + věta                12 variant verbalizace
    od každého typu (úkol, problém, konec) aspoň jeden motiv
    se scénou ve všech pěti fázích                        (obě)
    každá postava má zvuk z katalogu                      (obě)
    texty: neprázdné, bez cyrilice v latinkovém jazyce, v jazyce balíčku

Co tu není: nápisy v obrázcích. OCR (tools/find-lettering.swift) je
nespolehlivé (hlásí ornamenty, „Toronto“ přehlédlo), vadné rendery
vyřazuje pipeline do rag/data/rejected/ a sem se nedostanou.

Kontroly hotového zipu (počet pohádek, region, pack_tales, sha256,
vektory) jsou v `check_pack` — rozpočet na pohádku hlídá
pack_builder.check_budget při stavbě.

    python -m rag.pack_check --lang cs                    # všechny regiony, úroveň A
    python -m rag.pack_check --lang cs --region AFRI --level B --tales
"""

from __future__ import annotations

import argparse
import hashlib
import json
import sqlite3
import tempfile
import zipfile
from collections import Counter, defaultdict
from dataclasses import dataclass, field
from pathlib import Path

from . import regions
from .build_pack import _CYRILLIC, LATIN_LANGS, motif_sound_rows, usable_hints
from .io import DATA_DIR, log, read_jsonl
from .schemas import PHASES, TaleRecord
from .sources import guess_lang

AUDIO_CATALOG = Path(__file__).resolve().parents[1] / "audio" / "catalog.json"
BEATS = ("task", "problem", "ending")
CHECKS = ("motifs", "cards", "characters", "hints", "verbalizations", "scenes", "sounds", "texts")


@dataclass(frozen=True)
class Level:
    name: str
    characters: int
    hints: int
    all_phases: bool
    variants: int


LEVELS = {
    "A": Level("A", characters=1, hints=3, all_phases=False, variants=2),
    "B": Level("B", characters=2, hints=5, all_phases=True, variants=12),
}


def catalog_sound_ids(catalog: Path = AUDIO_CATALOG) -> set[str]:
    """Id zvuků, jak je build_pack.sound_rows ukládá do core balíčku."""
    c = json.loads(catalog.read_text(encoding="utf-8"))
    ids = {f"music-{env}-{mood}" for env in c["music"]["environments"] for mood in c["music"]["moods"]}
    ids |= {f"creature-{k}" for k in c["sfx"]["creatures"]} | {f"action-{k}" for k in c["sfx"]["actions"]}
    return ids


@dataclass
class Corpus:
    """Všechno, co validátor o pohádkách potřebuje, načtené jednou."""

    lang: str
    tales: dict[str, TaleRecord] = field(default_factory=dict)
    titles: dict[str, str] = field(default_factory=dict)
    sentences: dict[str, str] = field(default_factory=dict)
    variants: Counter = field(default_factory=Counter)  # motif → řádků verbalizace (karta = 2)
    art: set[str] = field(default_factory=set)
    hints: Counter = field(default_factory=Counter)  # (motif, fáze) → počet
    bad_text: set[str] = field(default_factory=set)  # motivy s prázdným/cyrilským textem
    scenes: Counter = field(default_factory=Counter)  # (motif, fáze) → scén s obrázkem
    sounds: dict[str, set[str]] = field(default_factory=dict)  # motif → id zvuků
    sound_ids: set[str] = field(default_factory=set)

    @classmethod
    def load(cls, lang: str, *, data_dir: Path = DATA_DIR, tales_path: Path | None = None, images_dir: Path | None = None, scene_images_dir: Path | None = None, catalog: Path = AUDIO_CATALOG) -> Corpus:
        c = cls(lang)
        for rec in read_jsonl(tales_path or data_dir / "tales.jsonl", TaleRecord):
            c.tales[rec.source_ref] = rec
        latin = lang in LATIN_LANGS

        def bad(text: str) -> bool:
            return not text.strip() or (latin and bool(_CYRILLIC.search(text)))

        # Karta vyhrává nad verbalizací, jako v build_pack.build.
        for name in (f"verbalizations.{lang}.jsonl", f"cards.{lang}.jsonl"):
            p = data_dir / name
            if not p.exists():
                continue
            for line in p.open(encoding="utf-8"):
                v = json.loads(line)
                if v.get("lang") != lang:
                    continue
                mid, text = v["motif_id"], v.get("text", "")
                c.variants[mid] += 1
                (c.titles if v.get("length") == "title" else c.sentences)[mid] = text
                if bad(text):
                    c.bad_text.add(mid)
        hp = data_dir / f"hints.{lang}.jsonl"
        if hp.exists():
            rows: dict[str, tuple[str, str | None, str, str]] = {}
            for line in hp.open(encoding="utf-8"):
                h = json.loads(line)
                if h.get("lang") == lang and h.get("motif_id"):
                    rows.setdefault(h["id"], (h["id"], h["motif_id"], h["phase"], h.get("text", "")))
            for i in usable_hints(rows.values(), lang):  # vadnou balíček nenese
                c.hints[(rows[i][1], rows[i][2])] += 1
        images_dir = images_dir or data_dir / "motif_images"
        if images_dir.is_dir():
            c.art = {p.stem for p in images_dir.glob("*.jpg")}
        scene_images_dir = scene_images_dir or data_dir / "scene_images"
        sp = data_dir / "scene_prompts.jsonl"
        if sp.exists() and scene_images_dir.is_dir():
            rendered = {p.stem for p in scene_images_dir.glob("*.jpg")}
            for line in sp.open(encoding="utf-8"):
                s = json.loads(line)
                if s["id"] in rendered:
                    c.scenes[(s["motif_id"], s["phase"])] += 1
        for mid, sid, _ in motif_sound_rows(data_dir):
            c.sounds.setdefault(mid, set()).add(sid)
        if catalog.exists():
            c.sound_ids = catalog_sound_ids(catalog)
        return c

    def country(self, ref: str) -> str:
        return next((m.country_code for m in self.tales[ref].motifs if m.country_code), "")


def check_tale(c: Corpus, ref: str, level: Level) -> dict[str, str]:
    """Co pohádce [ref] chybí do úrovně [level]: {kontrola: popis}; prázdné = prošla."""
    rec = c.tales[ref]
    out: dict[str, str] = {}
    shown = [m for m in rec.motifs if m.id in c.titles]
    beats = [m for m in shown if m.type in BEATS]
    chars = [m for m in rec.motifs if m.type == "character"]

    missing = [t for t in BEATS if not any(m.type == t for m in beats)]
    if missing:
        out["motifs"] = "bez titulku: " + ", ".join(missing)
    no_art = [m.id for m in shown if m.id not in c.art]
    if no_art:
        out["cards"] = f"{len(no_art)} z {len(shown)} zobrazených motivů bez karty"
    if chars:
        ok = sum(m.id in c.titles and m.id in c.art for m in chars)
        need = min(level.characters, len(chars))
        if ok < need:
            out["characters"] = f"{ok} postav s titulkem a kartou, chce {need}"

    def phases(m) -> tuple[str, ...]:
        return PHASES if level.all_phases else (m.type,)

    # Konce nápovědy nemají a mít nebudou: rag.hints je přeskakuje, nápověda
    # ke konci by ho prozradila.
    targets = [m for m in (shown if level.all_phases else beats) if m.type != "ending"]
    short = [(m.id, p) for m in targets for p in phases(m) if c.hints[(m.id, p)] < level.hints]
    if short:
        out["hints"] = f"{len(short)} z {sum(len(phases(m)) for m in targets)} (motiv, fáze) má méně než {level.hints} nápovědy"
    thin = [m.id for m in beats if m.id not in c.sentences or c.variants[m.id] < level.variants]
    if thin:
        out["verbalizations"] = f"{len(thin)} z {len(beats)} motivů bez věty" if level.variants <= 2 else f"{len(thin)} z {len(beats)} motivů má méně než {level.variants} variant"
    no_scene = [t for t in BEATS if any(m.type == t for m in beats) and not any(m.type == t and all(c.scenes[(m.id, p)] for p in PHASES) for m in beats)]
    if no_scene:
        out["scenes"] = "žádný motiv se scénou ve všech fázích: " + ", ".join(no_scene)
    # Suflér nabízí jen zvuky postav a právě vyprávěného motivu; co tu
    # chybí, je v appce tlačítko, které není.
    effects = {s for s in c.sound_ids if not s.startswith("music-")}
    mute = [m.id for m in chars if m.id in c.titles and not (c.sounds.get(m.id, set()) & effects)]
    silent = [m.id for m in beats if not (c.sounds.get(m.id, set()) & effects)]
    if mute or silent:
        out["sounds"] = ", ".join(
            x for x in (f"{len(mute)} postav bez zvuku z katalogu" if mute else "", f"{len(silent)} z {len(beats)} motivů děje bez zvuku" if silent else "") if x
        )
    bad = [m.id for m in shown if m.id in c.bad_text]
    text = " ".join(c.sentences.get(m.id, "") for m in shown)
    if bad:
        out["texts"] = f"{len(bad)} motivů s prázdným nebo cyrilským textem"
    elif c.lang in ("cs", "en") and len(text) > 200 and guess_lang(text) not in (c.lang, "?"):
        out["texts"] = f"věty nejsou v jazyce {c.lang}"
    return out


def passes(c: Corpus, ref: str, level: Level, waive: frozenset[str] = frozenset()) -> bool:
    return not (set(check_tale(c, ref, level)) - waive)


def report(c: Corpus, level: Level, only: set[str] | None = None, waive: frozenset[str] = frozenset()) -> dict[str, dict]:
    """Po regionech: kolik pohádek prošlo a co chybí těm ostatním."""
    out: dict[str, dict] = {}
    per: dict[str, list[str]] = defaultdict(list)
    for ref in c.tales:
        cc = c.country(ref)
        if cc and any(m.id in c.titles for m in c.tales[ref].motifs):
            per[regions.region_of(cc)].append(ref)
    for k in regions.ORDER:
        if only and k not in only:
            continue
        fails: dict[str, dict[str, str]] = {}
        why: Counter = Counter()
        for ref in sorted(per.get(k, [])):
            problems = {n: d for n, d in check_tale(c, ref, level).items() if n not in waive}
            if problems:
                fails[ref] = problems
                why.update(problems.keys())
        out[k] = {"tales": len(per.get(k, [])), "ok": len(per.get(k, [])) - len(fails), "missing": dict(why.most_common()), "failed": fails}
    return out


def check_pack(zip_path: Path, *, region: str, refs: list[str], expect: int, sha256: str, vectors: bool = True) -> list[str]:
    """Kontroly hotového dílu; vrací seznam chyb (prázdný = v pořádku)."""
    errs: list[str] = []
    if len(refs) != expect:
        errs.append(f"{len(refs)} pohádek, díl má mít přesně {expect}")
    if len(set(refs)) != len(refs):
        errs.append("pohádka je v dílu dvakrát")
    if hashlib.sha256(zip_path.read_bytes()).hexdigest() != sha256:
        errs.append("sha256 v manifestu nesedí na soubor")
    with zipfile.ZipFile(zip_path) as z, tempfile.TemporaryDirectory() as tmp:
        meta = json.loads(z.read("pack.json"))
        (name, f), = meta["files"].items()
        data = z.read(name)
        if hashlib.sha256(data).hexdigest() != f["sha256"]:
            errs.append("sha256 v pack.json nesedí na databázi")
        db = Path(tmp) / name
        db.write_bytes(data)
        conn = sqlite3.connect(db)
        try:
            rows = conn.execute("SELECT source_ref, country_code FROM pack_tales").fetchall()
            if sorted(r for r, _ in rows) != sorted(refs):
                errs.append("pack_tales nesedí na seznam pohádek dílu")
            foreign = sorted({cc for _, cc in rows if regions.REGION_OF.get(cc) != region})
            if foreign:
                errs.append(f"země mimo region {region}: {', '.join(foreign)}")
            model, dim = conn.execute("SELECT embed_model, embed_dim FROM meta").fetchone()
            hints, embs = conn.execute("SELECT (SELECT COUNT(*) FROM hint_bank), (SELECT COUNT(*) FROM hint_emb)").fetchone()
            if vectors and (not model or not dim or hints != embs):
                errs.append(f"vektory nápověd chybí nebo nesedí ({embs} z {hints}, model '{model}')")
        finally:
            conn.close()
    return errs


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--lang", required=True)
    ap.add_argument("--level", choices=sorted(LEVELS), default="A")
    ap.add_argument("--region", default="", help="čárkami oddělené kódy regionů; výchozí všechny")
    ap.add_argument("--waive", default="", help=f"kontroly, které se nepočítají: {', '.join(CHECKS)}")
    ap.add_argument("--tales", action="store_true", help="vypsat i jednotlivé pohádky, které neprošly")
    ap.add_argument("--json", type=Path, help="celý report jako JSON")
    ap.add_argument("--data", type=Path, default=DATA_DIR, help="adresář s tales.jsonl a výstupy pipeline")
    args = ap.parse_args()
    only = {r.strip().upper() for r in args.region.split(",") if r.strip()} or None
    waive = frozenset(w.strip() for w in args.waive.split(",") if w.strip())
    if waive - set(CHECKS):
        ap.error(f"neznámá kontrola: {', '.join(sorted(waive - set(CHECKS)))}")
    rep = report(Corpus.load(args.lang, data_dir=args.data), LEVELS[args.level], only, waive)
    for k, r in rep.items():
        missing = ", ".join(f"{n} {v}" for n, v in r["missing"].items()) or "nic"
        log(f"{k}: {r['ok']} z {r['tales']} pohádek prošlo úrovní {args.level}; chybí: {missing}")
        if args.tales:
            for ref, problems in r["failed"].items():
                log(f"  {ref}: " + "; ".join(f"{n}: {d}" for n, d in problems.items()))
    if args.json:
        args.json.write_text(json.dumps(rep, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")


if __name__ == "__main__":
    main()
