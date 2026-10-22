"""Free 10/země (21. 10. 2026): korektura češtiny free pohádek lepším modelem (swarm-director).

qwen36 píše češtinu s chybami (rod, skloňování, „k zlatému“, Lis místo Liška). Director
dostane hotové texty a vrátí opravené — nic nepíše znovu. Dvě fáze, resumovatelné:

  cards  titulek + věta motivu (cards.cs.jsonl)          → free10/cards.fix.cs.jsonl
  hints  nápovědy, které nepsal director (hints.cs.jsonl) → free10/hints.fix.cs.jsonl

Zdroje se nemění; sloučení dělá merge krok před stavbou balíčků (oprava nahradí řádek
se stejným klíčem). Oprava, která neprojde filtry, se zahodí a zůstane původní text.

    python cs_fix.py cards|hints --until 02:30
"""
from pathlib import Path
import argparse, json, os, sys, time
from collections import defaultdict
from datetime import datetime

RAG = Path(os.environ.get("ST_RAG", Path(__file__).resolve().parents[2] / "rag"))  # repo/rag
sys.path.insert(0, str(RAG))
from pydantic import BaseModel
from rag.filters import check_for_age, check_hint, reveals_ending, wrong_language
from rag.io import append_jsonl, stable_id
from rag.llm import LLM

D = RAG / "data"
F = Path(os.environ.get("CS_REVIEW_DIR", "."))  # tales.free10.cs.jsonl a výstupy oprav/hlasování
CHUNK = 16

EDITOR = """Jsi zkušený český redaktor knih pro malé děti (3–8 let). Dostaneš české texty, které napsal slabší jazykový model podle anglické předlohy. Oprav je tak, aby zněly jako od rodilého mluvčího:
- gramatika, shoda rodu (postava ženského rodu = ženské tvary sloves a přídavných jmen), skloňování, vokalizované předložky (ke zlatému, ve dvoře, se sestrou)
- špatně přeložená slova a jména (např. „Lis“ místo „Liška“, doslovné kalky z angličtiny, anglická slova)
- nepřirozený slovosled a obraty, které by česká máma nahlas neřekla
Neměň význam, děj ani formu: titulek zůstane 2–5 slov, věta jedna věta do 20 slov, nápověda jedna otevřená věta do 15 slov, která končí „…“ nebo otázkou a NEPROZRAZUJE konec. Vrať JEN položky, které jsi změnil (se stejným `key`); text, který je v pořádku, vynech. Když je všechno v pořádku, vrať prázdný seznam. Odpovídej jen JSON podle schématu."""


class Item(BaseModel):
    key: str
    text: str


class Fixed(BaseModel):
    items: list[Item]


def tales():
    return [json.loads(l) for l in open(F / "tales.free10.cs.jsonl")]


def ordered(ts):
    """Pořadí souboru: free desítky v2 (150, v binárce), pak kandidáti p1 na střídačku po regionech."""
    return ts


def done_keys(p):
    return {json.loads(l)["fix_key"] for l in open(p)} if p.exists() else set()


def run(jobs, out, until, conc):
    """jobs: (fix_key, user_prompt, originals{key: row}, validate(key, text) -> bool, make(key, row, text) -> dict)."""
    model = os.environ.get("FIX_MODEL", "swarm-director")
    system = ("Reasoning: low\n\n" if model == "lab" else "") + EDITOR  # gpt-oss: myšlení nejde vypnout, jen zkrátit
    llm = LLM(model=model, temperature=0.2, max_tokens=4000, timeout=900, concurrency=conc)
    n = changed = rejected = failed = 0
    t0 = time.time()
    for s in range(0, len(jobs), CHUNK):
        if datetime.now().strftime("%H:%M") >= until and datetime.now().strftime("%H:%M") < "12:00":
            print(f"{datetime.now():%T} čas {until}: konec", flush=True); break
        part = jobs[s : s + CHUNK]
        res = llm.batch([(system, j[1]) for j in part], Fixed)
        rows = []
        for (fk, _, orig, ok, make), r in zip(part, res):
            if isinstance(r, Exception):
                failed += 1; continue
            got = {i.key: i.text.strip() for i in r.items}
            for k, row in orig.items():
                new = got.get(k, "")
                if not new or new == row["text"]:
                    continue
                if not ok(k, new):
                    rejected += 1; continue
                rows.append(make(k, row, new)); changed += 1
            rows.append({"fix_key": fk, "done": True})
            n += 1
        append_jsonl_raw(out, rows)
        rate = n / max(1, time.time() - t0) * 3600
        print(f"{datetime.now():%T} {s + len(part)}/{len(jobs)} ({n} ok, {failed} chyb, {changed} opraveno, {rejected} oprav zamítnuto, {rate:.0f}/h)", flush=True)


def append_jsonl_raw(p, rows):
    with open(p, "a") as f:
        for r in rows:
            f.write(json.dumps(r, ensure_ascii=False) + "\n")


def cards_jobs():
    out = F / "cards.fix.cs.jsonl"
    have = done_keys(out)
    cards = defaultdict(dict)
    for l in open(D / "cards.cs.jsonl"):
        r = json.loads(l)
        cards[r["motif_id"]][r["length"]] = r  # poslední vyhrává, stejně jako build_pack
    jobs = []
    for t in ordered(tales()):
        fk = "cards|" + t["source_ref"]
        if fk in have:
            continue
        orig, lines = {}, []
        for m in t["motifs"]:
            if not m.get("country_code") or m["id"] not in cards:
                continue
            for ln, r in cards[m["id"]].items():
                k = f"{m['id']}|{ln}"
                orig[k] = r
                lines.append(f"- key {k} ({'titulek' if ln == 'title' else 'věta'}; anglicky: {m['text_en']})\n  {r['text']}")
        if not orig:
            continue
        age = t["extraction"].get("age_min", 6)
        user = f"Pohádka: {t['title']}\nKarty motivů (titulek a věta pro rodiče):\n" + "\n".join(lines)

        def ok(k, text, age=age):
            if wrong_language(text, "cs"):
                return False
            if k.endswith("|title"):
                return 1 <= len(text.split()) <= 6
            return len(text.split()) <= 24 and check_for_age(text, "cs", age).ok

        make = lambda k, row, text, fk=fk: {"fix_key": fk, **row, "text": text, "old": row["text"]}
        jobs.append((fk, user, orig, ok, make))
    return jobs, out


def hints_jobs():
    out = F / "hints.fix.cs.jsonl"
    have = done_keys(out)
    director = {json.loads(l)["id"] for l in open(os.environ.get("DIRECTOR_HINTS", "/dev/null"))}
    units = defaultdict(list)
    for l in open(D / "hints.cs.jsonl"):
        r = json.loads(l)
        if r.get("motif_id"):
            units[r["motif_id"]].append(r)
    jobs = []
    for t in ordered(tales()):
        endings = t["extraction"]["endings"]
        for m in t["motifs"]:
            if m["type"] == "ending" or not m.get("country_code"):
                continue
            allrows = units.get(m["id"], [])
            orig_ph = {r["phase"] for r in allrows if r.get("source") == "original"}
            seen = set()
            by_phase = defaultdict(list)
            for r in allrows:  # jen to, co build_pack opravdu vezme (prefer_original, bez duplicit)
                if r["phase"] in orig_ph and r.get("source") != "original":
                    continue
                if r["id"] in seen:
                    continue
                seen.add(r["id"])
                if r["id"] not in director:
                    by_phase[r["phase"]].append(r)
            for ph, rows in by_phase.items():
                fk = f"hints|{m['id']}|{ph}"
                if fk in have:
                    continue
                orig = {r["id"]: r for r in rows}
                user = f"Pohádka: {t['title']}\nMotiv (anglicky): {m['text_en']}\nFáze příběhu: {ph}\nNápovědy pro rodiče, který se při vyprávění zasekl:\n" + "\n".join(f"- key {r['id']}: {r['text']}" for r in rows)

                def ok(k, text, endings=endings):
                    return check_hint(text, "cs").ok and not any(reveals_ending(text, e, "cs") for e in endings)

                def make(k, row, text, fk=fk):
                    return {"fix_key": fk, **row, "id": stable_id(row["motif_id"], "", row["phase"], "cs", text.lower()), "text": text, "source": (row.get("source") or "text_en"), "replaces": row["id"], "old": row["text"]}

                jobs.append((fk, user, orig, ok, make))
    return jobs, out


if __name__ == "__main__":
    ap = argparse.ArgumentParser()
    ap.add_argument("phase", choices=["cards", "hints"])
    ap.add_argument("--until", default="02:30")
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--concurrency", type=int, default=8)
    a = ap.parse_args()
    jobs, out = (cards_jobs if a.phase == "cards" else hints_jobs)()
    if a.limit:
        jobs = jobs[: a.limit]
    print(f"{datetime.now():%T} {a.phase}: {len(jobs)} úloh → {out}", flush=True)
    run(jobs, out, a.until, a.concurrency)
