"""Zdrojové texty pohádek: v jakém jazyce text máme a kde leží.

Zásada uživatele (2026-10-04): **pokud existuje originál, nic
nepřekládej a ber text z originálu.** Karty, verbalizace a nápovědy v
jazyce X se pro pohádku, jejíž text máme v jazyce X, píšou z toho textu
(jména, oslovení, obraty), ne z anglického popisu motivu `text_en`.
Ostatní pohádky jdou dál z `text_en` — jeden krok od zdroje, nikdy
řetězově přes třetí jazyk.

`source_lang` je jazyk textu, který v korpusu skutečně leží — ne jazyk
tradice. Grimm je u nás anglický překlad z Gutenbergu, takže pro `--lang
en` je „originálem“ ten anglický text a pro `--lang de` žádný originál
nemáme (německý text v korpusu není). Erbenovy slovanské pohádky jsou
české převyprávění ruských, srbských… předloh: pro `--lang cs` je to
text, ze kterého se píše, protože bližší zdroj v korpusu není.
`translated_from` to jen zaznamenává (kde to víme), na výběr zdroje nemá
vliv.

Index `rag/data/tale_sources.jsonl` (jeden řádek na pohádku z
`tales.jsonl`) se staví bez LLM, z metadat fetcherů:

- `fetch-wikisource` píše `<sbírka>/meta.json` s polem `lang` a
  `tales/index.json` s URL stránky;
- `fetch-gutenberg` jazyk nepíše a hlavičku PG (`Language:`) odstraňuje,
  ale celý katalog (`corpus/internal/gutenberg/catalog.go`) jsou
  anglická vydání → `en`. Index to navíc ověřuje počtem anglických
  funkčních slov v textu a nesoulad hlásí.

    python -m rag.sources                        # postaví index + statistika
    python -m rag.sources --estimate --lang cs --regen-from-original
    python -m rag.sources --estimate --lang en
"""

from __future__ import annotations

import argparse
import json
import math
import re
import unicodedata
from collections import Counter
from collections.abc import Callable, Iterable
from dataclasses import dataclass, field
from pathlib import Path
from typing import TypeVar

from pydantic import BaseModel

from .io import DATA_DIR, log, read_jsonl
from .schemas import Motif, Source, TaleRecord

REPO_ROOT = DATA_DIR.parent.parent
RAW_DIR = REPO_ROOT / "corpus" / "data" / "raw"
SOURCES_PATH = DATA_DIR / "tale_sources.jsonl"

# Celý Gutenberg katalog jsou anglická vydání (catalog.go, ověřeno proti
# hlavičce Title:). Přibude-li neanglická kniha, patří sem její sbírka.
GUTENBERG_LANG = "en"
GUTENBERG_LANG_OVERRIDE: dict[str, str] = {}

# Jazyk předlohy, ze které je text, který máme, přeložen — jen tam, kde
# to víme. "" = text je původní, nebo to nevíme. Informativní pole.
TRANSLATED_FROM = {
    "grimm": "de", "andersen": "da", "perrault": "fr", "aesop": "grc",
    "nemcova-srbske": "sr", "erben-slovanske": "mul",
    "kunos-turkish": "tr", "coffee-house": "tr", "rumanian-gaster": "ro",
    "polish-glinski": "pl", "cossack": "uk", "serbian-mijatovich": "sr",
    "busk-patranas": "es", "lang-nights": "ar",
}

# rag.extract dává modelu jen prvních MAX_CHARS znaků pohádky, motivy tedy
# pocházejí odtud — úryvek se hledá ve stejném rozsahu.
EXTRACT_MAX_CHARS = 16000

# Kolik znaků originálu jde do promptu. ~2 400 znaků je ~900 tokenů
# češtiny / ~600 angličtiny (qwen tokenizer, odhad) — vejde se jméno
# postavy z úvodu i scéna, ze které motiv je.
EXCERPT_CHARS = 2400


class TaleSource(BaseModel):
    """Řádek `tale_sources.jsonl`."""

    source_ref: str
    collection: str
    title: str
    source: str  # gutenberg | wikisource
    source_lang: str  # jazyk textu, který v korpusu máme
    translated_from: str = ""
    path: str = ""  # vůči kořeni repa; "" = text na disku nenalezen
    url: str = ""
    chars: int = 0
    lang_check: str = ""  # "" OK, jinak důvod podezření (heuristika jazyka)


# ---------------------------------------------------------------------
# index
# ---------------------------------------------------------------------


_EN_WORDS = frozenset("the and of to was he she his her they that with for had said not but".split())
_CS_WORDS = frozenset("se na je že ve byl byla bylo jsem ale jak tak když mu ho jí si už".split())


def guess_lang(text: str) -> str:
    """Hrubý odhad en/cs podle funkčních slov — jen pojistka indexu."""
    words = re.findall(r"\w+", text[:5000].lower())
    if not words:
        return ""
    en = sum(w in _EN_WORDS for w in words) / len(words)
    cs = sum(w in _CS_WORDS for w in words) / len(words)
    if max(en, cs) < 0.05:
        return "?"
    return "en" if en > cs else "cs"


def _collection_meta(coll_dir: Path) -> dict:
    p = coll_dir / "meta.json"
    return json.loads(p.read_text(encoding="utf-8")) if p.exists() else {}


def _rel(p: Path) -> str:
    try:
        return str(p.resolve().relative_to(REPO_ROOT.resolve()))
    except ValueError:
        return str(p)


def build_index(raw_dir: Path, tales_path: Path) -> list[TaleSource]:
    """Jeden TaleSource na pohádku z tales.jsonl (bez LLM)."""
    from .extract import discover_tales, source_ref  # extract importuje llm; tady jen čteme disk

    on_disk: dict[str, tuple[str, str, Path, str]] = {}
    urls: dict[Path, str] = {}
    langs: dict[str, str] = {}
    if raw_dir.is_dir():
        for coll_dir in raw_dir.iterdir():
            if coll_dir.is_dir():
                langs[coll_dir.name] = _collection_meta(coll_dir).get("lang", "")
                idx = coll_dir / "tales" / "index.json"
                if idx.exists():
                    for e in json.loads(idx.read_text(encoding="utf-8")):
                        urls[coll_dir / "tales" / e["file"]] = e.get("url", "")
        for source, coll, book, title, path in discover_tales(raw_dir, set()):
            on_disk[source_ref(source, coll, book, path)] = (source, coll, path, title)

    out: list[TaleSource] = []
    for rec in read_jsonl(tales_path, TaleRecord):
        parts = rec.source_ref.split(":")
        source, coll = parts[0], parts[1]
        hit = on_disk.get(rec.source_ref)
        if source == "wikisource":
            lang = langs.get(coll, "")
        else:
            lang = GUTENBERG_LANG_OVERRIDE.get(coll, GUTENBERG_LANG)
        ts = TaleSource(source_ref=rec.source_ref, collection=coll, title=rec.title, source=source,
                        source_lang=lang, translated_from=TRANSLATED_FROM.get(coll, ""))
        if hit:
            path = hit[2]
            text = path.read_text(encoding="utf-8")
            guessed = guess_lang(text)
            ts.path, ts.chars = _rel(path), len(text)
            ts.url = urls.get(path, "") or (f"https://www.gutenberg.org/ebooks/{parts[2]}" if source == "gutenberg" and len(parts) > 3 else "")
            if guessed and guessed != "?" and lang in ("en", "cs") and guessed != lang:
                ts.lang_check = f"text vypadá jako {guessed}"
        else:
            ts.lang_check = "text nenalezen na disku"
        out.append(ts)
    return out


def write_index(rows: Iterable[TaleSource], path: Path) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    tmp = path.with_suffix(".tmp")
    with tmp.open("w", encoding="utf-8") as f:
        for r in rows:
            f.write(r.model_dump_json() + "\n")
    tmp.replace(path)


def load_index(path: Path = SOURCES_PATH, raw_dir: Path = RAW_DIR, tales_path: Path = DATA_DIR / "tales.jsonl") -> dict[str, TaleSource]:
    """Index ze souboru; chybí-li, postaví se v paměti z korpusu."""
    if path.exists():
        return {r.source_ref: r for r in read_jsonl(path, TaleSource)}
    if not raw_dir.is_dir() or not any(raw_dir.iterdir()):
        raise SystemExit(f"sources: chybí {path} i korpus {raw_dir} — spusť `python -m rag.sources` tam, kde korpus je, a index zkopíruj")
    log(f"sources: {path.name} chybí, stavím index v paměti z {raw_dir}")
    return {r.source_ref: r for r in build_index(raw_dir, tales_path)}


def stats(rows: Iterable[TaleSource], tales_path: Path | None = None) -> str:
    rows = list(rows)
    motifs: Counter[str] = Counter()
    if tales_path and tales_path.exists():
        lang_of = {r.source_ref: r.source_lang for r in rows}
        for rec in read_jsonl(tales_path, TaleRecord):
            motifs[lang_of.get(rec.source_ref, "?")] += len(rec.motifs)
    by_lang = Counter(r.source_lang or "?" for r in rows)
    lines = ["jazyk textu  pohádek  motivů  (sbírky)"]
    for lang, n in by_lang.most_common():
        colls = Counter(r.collection for r in rows if (r.source_lang or "?") == lang)
        lines.append(f"{lang:<11}  {n:>7}  {motifs[lang]:>6}  {len(colls)} sbírek: " + ", ".join(f"{c} {k}" for c, k in sorted(colls.items())[:8]) + (" …" if len(colls) > 8 else ""))
    tr = Counter(f"{r.source_lang}←{r.translated_from}" for r in rows if r.translated_from)
    if tr:
        lines.append("z toho text je překlad (známo): " + ", ".join(f"{k} {v}" for k, v in sorted(tr.items())))
    bad = [r for r in rows if r.lang_check]
    lines.append(f"podezřelé / chybějící texty: {len(bad)}" + "".join(f"\n  {r.source_ref}: {r.lang_check}" for r in bad[:10]))
    return "\n".join(lines)


# ---------------------------------------------------------------------
# úryvek originálu k motivu
# ---------------------------------------------------------------------

# Motivy z rag.extract nemají offsety (MotifExtraction je jen seznam vět),
# takže se místo v textu hledá heuristikou: klíčová slova motivu + kde
# v příběhu bývá daný typ motivu. Pro neanglický text se anglická slova
# motivu mapují na kmeny cílového jazyka malým slovníkem pohádkových
# reálií (ASCII, bez diakritiky, staré „w“ = „v“).
CUES: dict[str, dict[str, tuple[str, ...]]] = {
    "cs": {
        "fox": ("lis",), "wolf": ("vlk", "vlc"), "bear": ("medved",), "hare": ("zajic",), "rabbit": ("kralik", "zajic"),
        "cat": ("kock", "kocour"), "dog": ("pes", "psa", "psem", "psi"), "horse": ("kun", "kone", "konic"), "cow": ("krav",),
        "goat": ("koz",), "sheep": ("ovc", "beran"), "pig": ("prase", "svin"), "rooster": ("kohout",), "hen": ("slepic",),
        "bird": ("ptak", "ptac", "ptack"), "raven": ("havran", "vran"), "crow": ("vran",), "eagle": ("orel", "orl"), "owl": ("sov", "vyr"),
        "dove": ("holub", "holoub"), "fish": ("ryb",), "snake": ("had", "hadi"), "serpent": ("had",), "frog": ("zab",), "mouse": ("mys",),
        "dragon": ("drak", "sarkan", "zmek", "zmij"), "giant": ("obr",), "dwarf": ("trpasl", "skritek", "muzik"), "witch": ("carodej", "jezibab", "bab"),
        "devil": ("cert", "dabel", "dabl"), "fairy": ("vil", "sudic", "vil"), "sprite": ("vodnik", "skritek"), "ghost": ("duch", "strasidl"),
        "king": ("kral",), "queen": ("kralovn",), "prince": ("kralovic", "princ"), "princess": ("princezn", "kralovn", "kralovsk"),
        "emperor": ("cisar",), "lord": ("pan",), "knight": ("rytir",), "soldier": ("vojak", "vojack"), "hunter": ("mysliv", "lovec"),
        "shepherd": ("pastyr", "ovcak", "pasack"), "miller": ("mlynar", "mlyn"), "smith": ("kovar",), "tailor": ("krejc",),
        "farmer": ("sedlak", "rolnik", "chalupnik"), "peasant": ("sedlak", "chalupnik"), "merchant": ("kupec", "kupc"),
        "beggar": ("zebrak",), "widow": ("vdov",), "orphan": ("sirot", "sirotek"), "stepmother": ("macech",), "stepdaughter": ("pastork",),
        "mother": ("matk", "mamink", "mati"), "father": ("otec", "otc", "tatik"), "son": ("syn",), "daughter": ("dcer",),
        "brother": ("bratr", "brat"), "sister": ("sestr",), "old": ("star",), "grandmother": ("babick", "bab"), "grandfather": ("dedecek", "ded"),
        "girl": ("divk", "devc", "dcer"), "boy": ("chlap", "hoch"), "youngest": ("nejmlads",), "wife": ("zen", "manzel"), "husband": ("muz", "manzel"),
        "bride": ("nevest",), "rich": ("bohac", "bohat"), "poor": ("chud",), "clever": ("chytr",), "stupid": ("hloup",), "lazy": ("lin",),
        "gold": ("zlat",), "golden": ("zlat",), "silver": ("stribr",), "treasure": ("poklad",), "money": ("penez", "penize", "dukat", "zlatk"),
        "ring": ("prsten",), "apple": ("jablk", "jablek"), "bread": ("chleb",), "water": ("vod",), "well": ("studn",), "spring": ("pramen", "studanka"),
        "castle": ("hrad", "zamk", "zamek"), "palace": ("palac", "zamk"), "cottage": ("chalup", "chaloup", "chaloupk"), "mill": ("mlyn",),
        "church": ("kostel", "kaple"), "forest": ("les",), "wood": ("les",), "mountain": ("hor",), "mountains": ("hor",), "hill": ("kopec", "vrch"),
        "river": ("rek", "rec"), "lake": ("jezer",), "sea": ("mor",), "garden": ("zahrad",), "field": ("pole", "poli"), "road": ("cest",),
        "glass": ("sklen", "sklenen"), "sword": ("mec",), "shoe": ("strevic", "bot"), "hair": ("vlas",), "star": ("hvezd",), "sun": ("slunc",),
        "moon": ("mesic",), "wind": ("vitr", "vetr"), "winter": ("zim",), "night": ("noc",), "death": ("smrt",), "magic": ("kouzl", "carov"),
        "enchanted": ("zaklet", "zaklin"), "spell": ("kouzl", "zaklet"), "curse": ("prokl", "zaklet"), "riddle": ("hadank",), "task": ("ukol",),
        "wedding": ("svatb", "veselk"), "marry": ("vzit", "ozenit", "svatb"), "hero": ("junak", "hrdin"), "servant": ("sluh", "sluzk", "celed"),
        "saint": ("svat",), "god": ("buh", "boh", "pambu"), "shoemaker": ("sevc",), "fisherman": ("rybar",), "woodcutter": ("drevorub",),
        "life": ("ziv",), "pearl": ("perl",), "meadow": ("louk",), "maiden": ("pann", "divk"), "twelve": ("dvanact",),
        "ant": ("mravenc", "mravenec"), "fly": ("mouch", "much"), "animal": ("zvir",), "speech": ("mluv", "rec"), "veil": ("zavoj", "rousk"),
        "water sprite": ("vodnik",), "goblin": ("skritek", "hejkal"), "troll": ("obr",), "nymph": ("vil", "rusalk"),
    },
}

_TYPE_POS = {"character": 0.1, "task": 0.25, "problem": 0.5, "ending": 0.9}
_PHASE_POS = {"intro": 0.1, "task": 0.25, "problem": 0.5, "climax": 0.7, "ending": 0.75}
# Neend-motivy (a všechny nápovědy) nedostanou závěr pohádky: model by ho
# rád převyprávěl a karta/nápověda nesmí prozradit konec.
_SPOILER_TAIL = 0.2
_EN_STOP = frozenset("the a an and or of to in on at by for with from into who whom whose that this which their his her its they them he she it is are was were be been being has have had must can will would not but as so very".split())


def _fold(s: str) -> str:
    """Malá písmena, bez diakritiky, staročeské „w“ → „v“."""
    s = unicodedata.normalize("NFKD", s.lower())
    s = "".join(ch for ch in s if not unicodedata.combining(ch))
    return s.replace("w", "v")


def keywords(motif_text: str, tags: Iterable[str], lang: str) -> list[str]:
    """Kmeny, podle kterých se v textu jazyka [lang] hledá místo motivu."""
    words = [w for w in re.findall(r"[a-z]+", " ".join([motif_text, *tags]).lower()) if w not in _EN_STOP and len(w) > 2]
    if lang == "en":
        return sorted({w[:5] for w in words})
    cues = CUES.get(lang, {})
    out: set[str] = set()
    low = " ".join([motif_text, *tags]).lower()
    for en, stems in cues.items():
        if " " in en and en in low:
            out.update(stems)
    for w in words:
        out.update(cues.get(w, ()))
        if w.endswith("s"):
            out.update(cues.get(w[:-1], ()))
    return sorted(out)


def _paragraphs(text: str, max_len: int = 600) -> list[tuple[int, str]]:
    """(offset, odstavec); dlouhé odstavce se lámou po větách."""
    out: list[tuple[int, str]] = []
    for m in re.finditer(r"\S(?:.*?\S)?(?=[ \t]*\n\s*\n|\s*\Z)", text, flags=re.S):
        start, para = m.start(), m.group(0)
        while len(para) > max_len:
            cut = max(para.rfind(". ", 0, max_len), para.rfind("! ", 0, max_len), para.rfind("? ", 0, max_len), para.rfind("“ ", 0, max_len))
            cut = cut + 2 if cut > max_len // 3 else max_len
            out.append((start, para[:cut].strip()))
            start, para = start + cut, para[cut:].lstrip()
        if para:
            out.append((start, para))
    return out


def excerpt(text: str, *, mtype: str, motif_text: str, tags: Iterable[str] = (), lang: str, budget: int = EXCERPT_CHARS, phase: str | None = None) -> str:
    """Úryvek originálu, ze kterého motiv nejspíš pochází.

    Úvod pohádky (jména postav) + okno kolem odstavce s nejvíc klíčovými
    slovy motivu, v remíze blíž k místu, kde typ motivu v příběhu bývá.
    Pro jiný typ než `ending` se poslední pětina textu nebere (spoiler).
    Mezery mezi kusy značí „[…]“.
    """
    text = text[:EXTRACT_MAX_CHARS].strip()
    if not text:
        return ""
    limit = len(text) if mtype == "ending" else int(len(text) * (1 - _SPOILER_TAIL))
    paras = [(o, p) for o, p in _paragraphs(text) if o < limit] or _paragraphs(text)[:1]
    if sum(len(p) + 2 for _, p in paras) <= budget:
        return "\n\n".join(p for _, p in paras)

    keys = keywords(motif_text, tags, lang)
    target = _PHASE_POS.get(phase or "", _TYPE_POS.get(mtype, 0.5))
    folded = [_fold(p) for _, p in paras]

    words = [re.findall(r"\w+", f) for f in folded]
    hit = [{k for k in keys if any(w.startswith(k) for w in ws)} for ws in words]
    # Slovo, které je v každém odstavci (jméno hrdiny, „zlatý“ ve
    # Zlatovlásce), místo neurčí — váha jako idf.
    df = Counter(k for h in hit for k in h)
    weight = {k: math.log((len(paras) + 1) / (df[k] + 0.5)) for k in df}

    def score(i: int) -> float:
        pos = paras[i][0] / max(limit, 1)
        return sum(weight[k] for k in hit[i]) + 0.75 * (1 - abs(pos - target))

    # Úvod (kdo je kdo a jak se jmenuje, ~třetina rozpočtu) jde do úryvku
    # vždy; scéna motivu se proto hledá až za ním. Bez jediného zásahu
    # klíčových slov rozhodne jen poloha typu motivu.
    opening: list[int] = []
    acc = 0
    for i, (_, p) in enumerate(paras):
        if opening and acc + len(p) > budget // 3:
            break
        opening.append(i)
        acc += len(p) + 2
    rest = [i for i in range(len(paras)) if i not in opening] or opening
    with_hits = [i for i in rest if hit[i]]
    best = max(with_hits or rest, key=lambda i: (score(i), -i))
    chosen: set[int] = set()
    used = 0

    def take(i: int) -> bool:
        nonlocal used
        n = len(paras[i][1]) + 2
        if i in chosen:
            return True
        if used + n > budget and chosen:
            return False
        chosen.add(i)
        used += n
        return True

    take(best)  # vždy, i kdyby sám přetekl rozpočet (zkrátí se níž)
    for i in opening:
        if not take(i):
            break
    # okno kolem nejlepšího odstavce, střídavě dopředu a dozadu
    lo, hi = best - 1, best + 1
    while lo >= 0 or hi < len(paras):
        grew = False
        if hi < len(paras) and take(hi):
            hi, grew = hi + 1, True
        if lo >= 0 and take(lo):
            lo, grew = lo - 1, True
        if not grew:
            break
    parts: list[str] = []
    prev = -1
    for i in sorted(chosen):
        if parts and i != prev + 1:
            parts.append("[…]")
        p = paras[i][1]
        parts.append(p if len(p) <= budget else p[:budget].rsplit(" ", 1)[0] + " …")
        prev = i
    return "\n\n".join(parts)


# ---------------------------------------------------------------------
# výběr zdroje pro generování
# ---------------------------------------------------------------------

ORIGINAL_RULE = """

ORIGINAL TEXT: the user message also carries an excerpt of this tale's own text in {lang_name}. Write FROM IT: use the names, epithets, animals, objects and turns of phrase the tale itself uses. Do not translate the English motif — it only says which moment of the tale is meant. Old or dialect spelling (Czech 'w' for 'v', 'de' for 'the') is written in today's standard spelling; the names and words themselves stay. The excerpt is source material only: every rule above (length, age, never reveal the ending) still applies."""


@dataclass
class OriginalResolver:
    """Rozhoduje, z čeho se motiv v jazyce `lang` píše, a dodá úryvek.

    `source_for(m)` je "original", když text pohádky motivu máme právě v
    jazyce `lang`, jinak "text_en".
    """

    lang: str
    index: dict[str, TaleSource]
    budget: int = EXCERPT_CHARS
    root: Path = REPO_ROOT
    _texts: dict[str, str] = field(default_factory=dict)

    @classmethod
    def load(cls, lang: str, *, budget: int = EXCERPT_CHARS, sources_path: Path = SOURCES_PATH, tales_path: Path = DATA_DIR / "tales.jsonl") -> OriginalResolver:
        return cls(lang=lang, index=load_index(sources_path, RAW_DIR, tales_path), budget=budget)

    def source_for(self, m: Motif) -> Source:
        ts = self.index.get(m.source_ref)
        return "original" if ts is not None and ts.source_lang == self.lang else "text_en"

    def text(self, source_ref: str) -> str:
        if source_ref not in self._texts:
            ts = self.index[source_ref]
            p = self.root / ts.path if ts.path else None
            if p is None or not p.exists():
                # Zásada: originál existuje → nepřekládat. Tiše spadnout na
                # text_en by vyrobilo přesně ty řádky, které se mají nahradit.
                raise FileNotFoundError(f"originál {source_ref} ({ts.path or 'bez cesty'}) není pod {self.root} — zkopíruj corpus/data/raw")
            self._texts[source_ref] = p.read_text(encoding="utf-8")
        return self._texts[source_ref]

    def block(self, m: Motif, phase: str | None = None) -> str:
        """Kus uživatelského promptu s úryvkem originálu ("" pro text_en)."""
        if self.source_for(m) != "original":
            return ""
        ts = self.index[m.source_ref]
        ex = excerpt(self.text(m.source_ref), mtype=m.type, motif_text=m.text_en, tags=m.tags, lang=self.lang, budget=self.budget, phase=phase)
        return f"\nTale: {ts.title}\nOriginal text excerpt (the tale's own wording):\n<<<\n{ex}\n>>>"

    def system(self, system: str, m: Motif, lang_name: str) -> str:
        return system + ORIGINAL_RULE.format(lang_name=lang_name) if self.source_for(m) == "original" else system

    def missing(self, motifs: Iterable[Motif]) -> list[str]:
        """source_refy, které potřebují originál, ale text chybí."""
        refs = {m.source_ref for m in motifs if self.source_for(m) == "original"}
        return sorted(r for r in refs if not self.index[r].path or not (self.root / self.index[r].path).exists())


@dataclass
class Job:
    """Jedno LLM volání stage: klíč pro resume, prompt a zdroj, ze kterého se píše."""

    key: object
    motif: Motif | None
    system: str
    user: str
    base_user: str  # prompt bez úryvku originálu (pro odhad objemu)
    source: Source
    extra: object = None


K = TypeVar("K")
R = TypeVar("R", bound=BaseModel)


def sources_by_key(path: Path, model: type[R], key: Callable[[R], K]) -> dict[K, set[str]]:
    """{klíč: {zdroje řádků}} z výstupního JSONL; staré řádky bez pole
    `source` jsou "text_en" (default schématu)."""
    out: dict[K, set[str]] = {}
    for r in read_jsonl(path, model):
        out.setdefault(key(r), set()).add(getattr(r, "source", "text_en"))
    return out


def motif_ids(path: Path) -> frozenset[str]:
    """motif_id všech řádků JSONL (cards/verbalizations/hints libovolného
    jazyka) — pro `--same-motifs-as`: nový jazyk ve stejném rozsahu jako
    už hotový."""
    if not path.exists():
        raise SystemExit(f"{path} neexistuje")
    out: set[str] = set()
    with path.open(encoding="utf-8") as f:
        for line in f:
            if line.strip() and (mid := json.loads(line).get("motif_id")):
                out.add(mid)
    return frozenset(out)


def needs_work(key: K, have: dict[K, set[str]], source: Source, regen: bool) -> bool:
    """Má se jednotka `key` (teď psaná ze `source`) generovat?

    Běžný běh: jen co ještě nemá žádný řádek (resumable jako dosud).
    `--regen-from-original`: jen co už řádky má, píše se z originálu, a
    řádek z originálu ještě nemá — staré text_en řádky zůstanou v souboru,
    build_pack pak vezme originální.
    """
    if not regen:
        return key not in have
    return source == "original" and key in have and "original" not in have[key]


def prefer_original(rows: list[R], key: Callable[[R], K]) -> list[R]:
    """Pro každý klíč, který má aspoň jeden řádek ze zdroje "original",
    zahodí jeho řádky z "text_en". Pořadí zachová."""
    orig = {key(r) for r in rows if getattr(r, "source", "text_en") == "original"}
    return [r for r in rows if getattr(r, "source", "text_en") == "original" or key(r) not in orig]


# ---------------------------------------------------------------------
# odhad objemu (bez LLM)
# ---------------------------------------------------------------------

# Kalibrace od uživatele (2026-10-04): qwen36 / openclaw-default přes
# gateway, concurrency 12, ~2,4 req/s při ~1 300 tokenech vstupu.
BASE_RPS = 2.4
BASE_IN_TOKENS = 1300
CHARS_PER_TOKEN = {"cs": 2.6, "en": 4.0}


def estimate(lang: str, regen: bool, data_dir: Path = DATA_DIR, sources_path: Path | None = None, exclude_cards: frozenset[str] = frozenset(), root: Path = REPO_ROOT, like: str = "") -> str:
    """Kolik LLM volání by běh cards + verbalize + hints udělal a jak dlouho.
    Čte jen JSONL v [data_dir] a texty pod [root]; nic nevolá."""
    from . import cards, hints, verbalize

    tales_path = data_dir / "tales.jsonl"
    res = OriginalResolver(lang=lang, index=load_index(sources_path or data_dir / SOURCES_PATH.name, root / "corpus" / "data" / "raw", tales_path), root=root)
    out: list[str] = []
    total_s = [0.0, 0.0]
    for name, plan in (
        ("cards", lambda: cards.plan(tales_path, data_dir / f"cards.{lang}.jsonl", lang,
                                     cards.same_motifs(tales_path, motif_ids(data_dir / f"cards.{like}.jsonl")) if like else cards.select(tales_path, 20, 10, None, data_dir / "motif_images", exclude_cards), res, regen)),
        ("verbalize", lambda: verbalize.plan(tales_path, data_dir / f"verbalizations.{lang}.jsonl", lang, 0, res, regen, motif_ids(data_dir / f"verbalizations.{like}.jsonl") if like else None)),
        ("hints", lambda: hints.plan(tales_path, data_dir / f"hints.{lang}.jsonl", lang, 0, res, regen, not regen, motif_ids(data_dir / f"hints.{like}.jsonl") if like else None)),
    ):
        items = plan()
        n = len(items)
        n_orig = sum(1 for it in items if it.source == "original")
        extra = [len(it.user) - len(it.base_user) for it in items if it.source == "original"]
        cpt = CHARS_PER_TOKEN.get(lang, 3.0)
        extra_tok = (sum(extra) / len(extra) / cpt) if extra else 0.0
        # Mez: (a) vstup nic nestojí — 2,4 req/s; (b) propustnost klesá
        # úměrně vstupu (prefill-bound) pro řádky z originálu.
        t_fast = n / BASE_RPS
        t_slow = (n - n_orig) / BASE_RPS + n_orig / (BASE_RPS * BASE_IN_TOKENS / (BASE_IN_TOKENS + extra_tok))
        total_s[0] += t_fast
        total_s[1] += t_slow
        out.append(f"{name:<10} volání {n:>7}  z originálu {n_orig:>7}  +vstup ~{extra_tok:4.0f} tok  čas {t_fast / 3600:5.2f}–{t_slow / 3600:5.2f} h")
    out.append(f"{'celkem':<10} {'':>40}  čas {total_s[0] / 3600:5.2f}–{total_s[1] / 3600:5.2f} h")
    return "\n".join(out)


def main() -> None:
    ap = argparse.ArgumentParser(description=__doc__, formatter_class=argparse.RawDescriptionHelpFormatter)
    ap.add_argument("--raw", type=Path, default=RAW_DIR, help="výstup Go fetcherů")
    ap.add_argument("--tales", type=Path, default=DATA_DIR / "tales.jsonl")
    ap.add_argument("--out", type=Path, default=SOURCES_PATH)
    ap.add_argument("--data-dir", type=Path, default=DATA_DIR, help="--estimate: kde leží tales.jsonl a výstupy stage (jen čtení)")
    ap.add_argument("--root", type=Path, default=REPO_ROOT, help="--estimate: kořen repa, vůči kterému jsou cesty k textům v indexu")
    ap.add_argument("--estimate", action="store_true", help="místo stavby indexu spočítej volání a čas pro --lang")
    ap.add_argument("--lang", default="")
    ap.add_argument("--regen-from-original", action="store_true")
    ap.add_argument("--same-motifs-as", default="", help="--estimate: rozsah jako hotový jazyk (např. cs), viz --same-motifs-as u stage")
    ap.add_argument("--exclude", default="", help="--estimate: země vynechané v cards (jako rag.cards --exclude)")
    args = ap.parse_args()
    if args.estimate:
        if not args.lang:
            ap.error("--estimate potřebuje --lang")
        exclude = frozenset(c.strip().upper() for c in args.exclude.split(",") if c.strip())
        print(estimate(args.lang, args.regen_from_original, args.data_dir, args.out, exclude, args.root, args.same_motifs_as))
        return
    rows = build_index(args.raw, args.tales)
    write_index(rows, args.out)
    log(f"sources: {len(rows)} pohádek → {args.out}")
    print(stats(rows, args.tales))


if __name__ == "__main__":
    main()
