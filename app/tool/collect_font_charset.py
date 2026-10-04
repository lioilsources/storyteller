#!/usr/bin/env python3
"""Posbírá všechny znaky, které StoryTeller může ukázat, pro battle test
fontů CuteKidFonts (docs/cute-kid-fonts-battle-test.md).

Zdroje:
  - rag/data/{cards,verbalizations,hints,transitions}.cs.jsonl
  - rag/data/packs/*.db (verbalizations, hint_bank, transitions,
    outline_templates, sounds.label_cs)
  - app/assets/geo/countries.json (názvy zemí)
  - řetězcové literály v app/lib (UI, kurátorské postavy a motivy)

Výstup (commitovaný, aby testy nepotřebovaly rag/data, které je gitignored):
  test/fixtures/font_charset.json   znak → počet, zdroje, ukázky
  test/fixtures/font_layout_samples.json   nejdelší názvy/věty/nápovědy

    python3 tool/collect_font_charset.py [--data ../rag/data]
"""
import argparse
import json
import re
import sqlite3
import unicodedata
from collections import Counter, defaultdict
from pathlib import Path

APP = Path(__file__).resolve().parent.parent

ap = argparse.ArgumentParser()
ap.add_argument("--data", default=str(APP.parent / "rag" / "data"))
args = ap.parse_args()
DATA = Path(args.data)

# (zdroj, druh, text) — druh: title | sentence | hint | transition | ui | country | sound | outline
items: list[tuple[str, str, str]] = []

for name in ["cards", "verbalizations", "hints", "transitions"]:
    p = DATA / f"{name}.cs.jsonl"
    if not p.exists():
        continue
    for line in p.open(encoding="utf-8"):
        row = json.loads(line)
        kind = {"hints": "hint", "transitions": "transition"}.get(name) or row.get("length", "sentence")
        items.append((p.name, kind, row["text"]))

for db in sorted((DATA / "packs").glob("*.db")):
    con = sqlite3.connect(f"file:{db}?mode=ro", uri=True)
    q = {
        "verbalizations": "SELECT length, text FROM verbalizations",
        "hint_bank": "SELECT 'hint', text FROM hint_bank",
        "transitions": "SELECT 'transition', text FROM transitions",
        "outline_templates": "SELECT 'outline', text FROM outline_templates",
        "sounds": "SELECT 'sound', label_cs FROM sounds",
    }
    tables = {r[0] for r in con.execute("SELECT name FROM sqlite_master WHERE type='table'")}
    for t, sql in q.items():
        if t in tables:
            for kind, text in con.execute(sql):
                items.append((f"{db.name}:{t}", kind, text))
    con.close()

for c in json.loads((APP / "assets/geo/countries.json").read_text(encoding="utf-8")):
    items.append(("countries.json", "country", c["n"]))

lit = re.compile(r"""'((?:[^'\\\n]|\\.)*)'|"((?:[^"\\\n]|\\.)*)\"""")
for f in sorted((APP / "lib").rglob("*.dart")):
    for line in f.read_text(encoding="utf-8").splitlines():
        if line.strip().startswith(("//", "import ", "export ")):
            continue
        for m in lit.finditer(line):
            s = m.group(1) if m.group(1) is not None else m.group(2)
            if s and not s.startswith(("assets/", "package:")):
                items.append((f"lib/{f.relative_to(APP / 'lib')}", "ui", s.replace("\\'", "'")))

count: Counter[str] = Counter()
sources: dict[str, Counter[str]] = defaultdict(Counter)
examples: dict[str, list[str]] = defaultdict(list)
for src, kind, text in items:
    for i, ch in enumerate(text):
        if ch in "\n\r\t":
            continue
        count[ch] += 1
        sources[ch][src.split(":")[0] if ".db" not in src else src] += 1
        ex = examples[ch]
        if len(ex) < 3:
            lo, hi = max(0, i - 25), min(len(text), i + 25)
            snippet = f"[{src}] …{text[lo:hi]}…"
            if snippet not in ex:
                ex.append(snippet)

def cat(ch: str) -> str:
    o = ord(ch)
    if o < 0x80:
        return "ascii"
    if ch in "áčďéěíňóřšťúůýžÁČĎÉĚÍŇÓŘŠŤÚŮÝŽ":
        return "czech"
    if 0x0370 <= o <= 0x03FF or 0x1F00 <= o <= 0x1FFF:
        return "greek"
    if 0x0400 <= o <= 0x04FF:
        return "cyrillic"
    if unicodedata.category(ch).startswith("P") or 0x2000 <= o <= 0x206F:
        return "punctuation"
    if o >= 0x1F000 or 0x2300 <= o <= 0x23FF or 0x2600 <= o <= 0x27BF or o in (0xFE0F, 0x200D):
        return "emoji"
    if unicodedata.category(ch).startswith("L") or unicodedata.category(ch) == "Mn":
        return "latin-ext" if o < 0x2000 else "other-letter"
    return "other"

chars = []
for ch, n in sorted(count.items(), key=lambda kv: ord(kv[0])):
    chars.append({
        "char": ch,
        "cp": f"U+{ord(ch):04X}",
        "name": unicodedata.name(ch, "?"),
        "category": cat(ch),
        "count": n,
        "sources": dict(sources[ch].most_common()),
        "examples": examples[ch],
    })

out = APP / "test/fixtures"
(out / "font_charset.json").write_text(
    json.dumps({"total_texts": len(items), "chars": chars}, ensure_ascii=False, indent=1) + "\n",
    encoding="utf-8",
)

def longest(kind_set, n=5, key=len):
    seen, res = set(), []
    for src, kind, text in sorted(items, key=lambda it: -key(it[2])):
        if kind in kind_set and text not in seen:
            seen.add(text)
            res.append({"source": src, "text": text, "length": len(text)})
            if len(res) == n:
                break
    return res

def longest_word(t: str) -> int:
    return max((len(w) for w in t.split()), default=0)

samples = {
    "titles": longest({"title"}, 8),
    "titles_longest_word": longest({"title"}, 5, key=longest_word),
    "sentences": longest({"sentence"}, 5),
    "hints": longest({"hint"}, 5),
    "transitions": longest({"transition"}, 3),
    "countries": longest({"country"}, 5),
    "sounds": longest({"sound"}, 5),
}
(out / "font_layout_samples.json").write_text(json.dumps(samples, ensure_ascii=False, indent=1) + "\n", encoding="utf-8")

by_cat = Counter(c["category"] for c in chars)
print(f"{len(items)} textů, {len(chars)} unikátních znaků: {dict(by_cat)}")
for c in chars:
    if c["category"] not in ("ascii", "czech"):
        print(c["cp"], c["char"], c["name"], c["count"], list(c["sources"])[:3])
