"""Druhý průchod korektury (22. 10. 2026): jiný model hlasuje o každé opravě z cs_fix.py.

Pro každou opravu (řádek s "old" v cards.fix / hints.fix) dostane soudce anglickou předlohu
a dvě české verze v náhodném pořadí (A/B, ať nevyhrává pozice) a řekne, která je lepší,
nebo že jsou stejně dobré. Výsledek → votes.<fáze>.cs.jsonl; merge pak vezme jen opravy
s verdiktem "better". Resumovatelné (přeskočí už odhlasované klíče).

    LITELLM_BASE_URL=… LITELLM_MODEL=swarm-director python cs_vote.py cards|hints [--limit N] [--until 02:30]
"""
from pathlib import Path
import argparse, json, os, random, sys
from datetime import datetime

RAG = Path(os.environ.get("ST_RAG", Path(__file__).resolve().parents[2] / "rag"))  # repo/rag
sys.path.insert(0, str(RAG))
from typing import Literal
from pydantic import BaseModel
from rag.llm import LLM

D = RAG / "data"
F = Path(os.environ.get("CS_REVIEW_DIR", "."))  # tales.free10.cs.jsonl a výstupy oprav/hlasování
BATCH = 12  # dvojic v jednom dotazu

JUDGE = """Jsi přísný český jazykový korektor knih pro malé děti. U každé položky dostaneš anglickou předlohu a dvě české verze A a B téhož textu. Rozhodni, která je lepší češtinou A ZÁROVEŇ věrně drží význam předlohy:
- chyba v gramatice, pádu, rodu, pravopisu (např. „pomocí kouzelným kamenem“, „Pýšný“) je vždy horší
- vypuštěný nebo změněný děj či vlastnost postavy oproti předloze je horší, i když je věta hezčí
- když jsou obě správně a liší se jen stylem, odpověz "same"
Vrať pro každou položku `key` a `winner`: "A", "B" nebo "same". Odpovídej jen JSON podle schématu."""


class Vote(BaseModel):
    key: str
    winner: Literal["A", "B", "same"]


class Votes(BaseModel):
    votes: list[Vote]


def english():
    en = {}
    for l in open(D / "tales.jsonl"):
        for m in json.loads(l)["motifs"]:
            en[m["id"]] = m["text_en"]
    return en


def pairs(phase):
    src = F / f"{phase}.fix.cs.jsonl"
    out = F / f"votes.{phase}.cs.jsonl"
    done = {json.loads(l)["key"] for l in open(out)} if out.exists() else set()
    en = english()
    rows = []
    for l in open(src):
        r = json.loads(l)
        if "old" not in r:
            continue
        key = f"{r['motif_id']}|{r['length']}" if phase == "cards" else r["replaces"]
        if key in done:
            continue
        rows.append((key, en.get(r["motif_id"], ""), r["old"], r["text"]))
    return rows, out


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("phase", choices=["cards", "hints"])
    ap.add_argument("--limit", type=int, default=0)
    ap.add_argument("--concurrency", type=int, default=12)
    ap.add_argument("--until", default="", help="HH:MM, kdy přestat (ráno patří SPARK jiným)")
    a = ap.parse_args()
    rows, out = pairs(a.phase)
    if a.limit:
        rows = rows[: a.limit]
    model = os.environ.get("LITELLM_MODEL", "swarm-director")
    llm = LLM(model=model, temperature=0.0, max_tokens=3000, timeout=600, concurrency=a.concurrency)
    rnd = random.Random(42)
    print(f"{datetime.now():%T} {a.phase}: {len(rows)} oprav k hlasování ({model}) → {out}", flush=True)
    tally = {"better": 0, "worse": 0, "same": 0}
    batches = [rows[i : i + BATCH] for i in range(0, len(rows), BATCH)]
    for s in range(0, len(batches), a.concurrency * 2):
        now = datetime.now().strftime("%H:%M")
        if a.until and a.until <= now < "12:00":
            print(f"{datetime.now():%T} čas {a.until}: konec", flush=True); break
        chunk = batches[s : s + a.concurrency * 2]
        prompts, flips = [], []
        for b in chunk:
            fl = [rnd.random() < 0.5 for _ in b]  # True = oprava je A
            flips.append(fl)
            prompts.append((JUDGE, "\n\n".join(
                f"key {k}\nanglicky: {e}\nA: {new if f else old}\nB: {old if f else new}" for (k, e, old, new), f in zip(b, fl))))
        res = llm.batch(prompts, Votes)
        lines = []
        for b, fl, r in zip(chunk, flips, res):
            if isinstance(r, Exception):
                continue
            got = {v.key: v.winner for v in r.votes}
            for (k, _, old, new), f in zip(b, fl):
                w = got.get(k)
                if w is None:
                    continue
                verdict = "same" if w == "same" else ("better" if (w == "A") == f else "worse")
                tally[verdict] += 1
                lines.append(json.dumps({"key": k, "verdict": verdict, "judge": model, "old": old, "new": new}, ensure_ascii=False))
        with open(out, "a") as fh:
            fh.write("".join(l + "\n" for l in lines))
        print(f"{datetime.now():%T} {min((s + len(chunk)) * BATCH, len(rows))}/{len(rows)} {tally}", flush=True)


if __name__ == "__main__":
    main()
