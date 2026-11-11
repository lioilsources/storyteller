# cs-review — korektura češtiny v obsahu StoryTelleru

Dva skripty a noční spouštěč, které opravují českou češtinu v textech balíčků
(titulky a věty karet motivů, nápovědy) a hlídají, aby oprava text nezhoršila.
Vznikly 21.–22. 10. 2026 před stavbou placených dílů balíčků v2.

## Proč to existuje

Většinu českých textů (`rag/data/cards.cs.jsonl`, `hints.cs.jsonl`) napsal
**qwen36** — na SPARKu je nejrychlejší, a proto psal skoro všechno. Česky ale
umí špatně: chyby v rodě („Co držel Anka“), skloňování a předložkách
(„k zlatému hradu“, „ze nebe“), nedopsaná slova („synův taj“), špatně
přeložená jména („Lis“ místo „Liška“). Free desítky jsou v binárce appky
a placené díly si lidé mají koupit — takové chyby tam být nesmí.

Přepsat všechno lepším modelem nejde: jen nápovědy free + kandidátů na p1
jsou desítky tisíc jednotek (~40 h). Korektura je levnější: model dostane
hotový text a vrátí **jen položky, které změnil**.

Výběr modelů podle `AiStack/bench` (automatické skóre, 21. 10. 2026):

| model | A2 volná čeština | A3 překlad do češtiny | tok/s 1× / 4× | JSON |
|---|---|---|---|---|
| swarm-director | 90 % | 92 % | 15 / 42 | 100 % |
| gpt-oss-120b | 100 % | 92 % | 35 / 100 | 76 % |
| qwen36 | 100 % | 83 % | 80 / 215 | 56 % |

- **Opravuje gpt-oss-120b** (`cs_fix.py`): stejně dobrá čeština jako director,
  2,3× rychlejší. První noc: 1 018 pohádek (karty) za ~5 h, 4 819 oprav.
- **Hlasuje director** (`cs_vote.py`): gpt-oss asi v 10 % případů text
  zhoršil („pomocí kouzelným kamenem“, „Pýšný“, „přinesl kouzelný kůň“)
  nebo škrtl kus děje. Proto o každé opravě rozhoduje *jiný* model (vlastní
  opravy by si model chválil): dostane anglickou předlohu a obě verze
  v náhodném pořadí A/B a řekne lepší / horší / stejné. Do balíčků jde jen
  oprava s verdiktem „better“. Odpověď je krátká, takže pomalost directora
  tady nevadí.

## Soubory

- `cs_fix.py cards|hints` — korektura; čte `tales.free10.cs.jsonl` (pořadí
  práce: free desítky v2, pak kandidáti p1 na střídačku po regionech), píše
  `cards.fix.cs.jsonl` / `hints.fix.cs.jsonl` (opravený řádek + `old`).
  Oprava, která neprojde filtry `rag.filters`, se zahodí. Resumovatelné.
- `cs_vote.py cards|hints` — hlasování → `votes.<fáze>.cs.jsonl`
  (`better` / `worse` / `same`). Resumovatelné.
- `night.sh` — jedna noc na SPARKu: od 01:00 (po okně PromoClown heartbeatu)
  director hlasuje, pak gpt-oss opravuje do 06:30, pak zpět rozvrh (llm).
  Director ani gpt-oss nesmí běžet vedle flux-schnell/ComfyUI a spolu se
  do paměti nevejdou — střídají se.
- `env.example.sh` — co nastavit; skutečný `env.sh` patří do pracovního
  adresáře mimo repo (obsahuje LAN adresu).

## Jak to pustit

```sh
mkdir -p ~/ops-director/free10 && cp tools/cs-review/env.example.sh ~/ops-director/free10/env.sh  # upravit
# tales.free10.cs.jsonl = pohádky v pořadí práce (řádky z rag/data/tales.jsonl)
cd tools/cs-review && CS_REVIEW_DIR=~/ops-director/free10 nohup caffeinate -i ./night.sh >> ~/ops-director/free10/night.log 2>&1 &
```

## Co ještě chybí

- **Sloučení**: opravy s `better` nahradit v `cards.cs.jsonl` (klíč
  `motif_id` + `length`) a `hints.cs.jsonl` (`replaces` → nové `id`) před
  `python -m rag.region_packs`. Zatím ručně, po kontrole vzorku člověkem.
- Free desítky jsou zmrazené jen co do *seznamu* pohádek — opravený text
  znamená novou verzi free balíčku (a binárky), ne porušení zmrazení.
