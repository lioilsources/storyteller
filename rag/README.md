# rag — offline LLM + RAG pipeline (Python)

Implements `STORYTELLER_RAG_PLAN.md`: everything an LLM ever says is
generated here, on Spark, in batch, and shipped to the app as SQLite
packs. The app never calls a model — it embeds the transcript on-device
and does retrieval (RAG_PLAN §0.1, §3).

**Language split (decided 2026-09-24):** this directory is the one place
Python is allowed in the repo — LLM calls, embeddings, ONNX, sqlite-vec.
Gateway and corpus *fetching* stay Go. The former Go `corpus/cmd/extract`
was removed in favour of `rag.extract`.

## Stages

| module | RAG_PLAN | in → out | LLM |
|---|---|---|---|
| `rag.extract` | PLAN §3.2 (+ §1.1c environments/creatures) | `corpus/data/raw` (Go fetcher) → `data/tales.jsonl` | yes |
| `rag.sources` | — | `corpus/data/raw` + tales → `data/tale_sources.jsonl` (jazyk a cesta k textu každé pohádky) | no |
| `rag.verbalize` | §2.1 | tales → `data/verbalizations.<lang>.jsonl` (12 variants/motif) | yes |
| `rag.hints` | §2.2 | tales → `data/hints.<lang>.jsonl` (8/(motif,phase) + generic per (phase,env)) | yes |
| `rag.transitions` | §2.3 | → `data/transitions.<lang>.jsonl` (~100/lang) | yes |
| `rag.scene_prompts` | §2.4 | tales → `data/scene_prompts.jsonl` (English, style-neutral) | yes |
| `rag.embed` | §2.6 | e5-small wrapper + **int8 contract** | no |
| `rag.build_pack` | §6 | JSONL → `data/packs/core.<lang>.db`, `country.<CC>.<lang>.db` (sqlite-vec) | no |
| `rag.pack_builder` | MONETIZATION §6, §11 | tales + JSONL → `data/dist/`: free balíčky po kontinentech (`continent.<K>.<lang>.free`, Evropa i jako `bundle/*.db` do binárky), placené po zemích, `manifest.json` schema 3 | no |
| `rag.parity_check` | §8.1 | fp32 sentence-transformers vs ONNX int8, cos > 0.99 | no |

Not written yet: `compat` LLM scoring (heuristic jaccard+ATU is in
`build_pack`), `phase_labels` + `phase_model` training, the LLM spoiler
classifier (rule-based `reveals_ending` is in `filters`), `country_art`
/ `country_audio` prompt generation.

Every LLM stage is **resumable**: it skips keys already present in its
output JSONL, so a killed run continues. Every id is deterministic
(`rag.io.stable_id`) — re-extracting the same tale yields the same
motif ids.

## Setup

```sh
cd rag
python3 -m venv .venv && .venv/bin/pip install -e '.[dev]'
.venv/bin/python -m pytest            # no network, no models
# on Spark, additionally:
.venv/bin/pip install -e '.[embed,pg]'
```

Config: `LITELLM_BASE_URL` (OpenAI-compatible base, e.g.
`http://<spark>:4000/v1`), `LITELLM_MODEL`, optional `LITELLM_API_KEY` and
`LITELLM_CONCURRENCY` (parallel requests, default 8 — lower it on a shared
`swarm-director`, where the library enrichment already holds 12 of 16 slots).
`LITELLM_TIMEOUT` (seconds per request, default 120) — on that same shared
director a verbalize call took 159 s (720 tokens at ~4.5 tok/s per
sequence, 2026-09-26), so every request timed out at 120 s; use ~600.

## Originál napřed (zásada 2026-10-04)

> **Pokud existuje originál, nic nepřekládej a ber text z originálu.**

Karty (`rag.cards`), verbalizace (`rag.verbalize`) a nápovědy
(`rag.hints`) v jazyce X se pro pohádku, jejíž text máme v jazyce X,
píšou **z textu té pohádky** — jména, oslovení a obraty z originálu —
ne z anglického popisu motivu `text_en`. Ostatní pohádky jdou dál z
`text_en`: jeden krok od zdroje, nikdy řetězově přes třetí jazyk (žádná
EN věta z češtiny, žádná DE věta z anglického překladu Grimma).

„Originál“ tu znamená **text, který v korpusu skutečně leží**, ne jazyk
tradice:

| text v korpusu | pohádek | motivů | originál pro |
|---|---|---|---|
| `cs` — cs.wikisource (Němcová, Erben, Erbenovy slovanské, Srbské pohádky) | 150 | 1 956 | `--lang cs` |
| `en` — celý Gutenberg katalog (Grimm, Andersen, Lang, Aesop, světová vlna…) | 2 433 | 28 138 | `--lang en` |

(stav `tales.jsonl` 2026-09-28; `python -m rag.sources` vypíše aktuální.)
Grimm je tedy pro `en` „originál“ (anglický překlad z Gutenbergu), pro
`de` ne — německý text v korpusu není, takže `de` jde z `text_en`.
Erbenovy slovanské pohádky jsou české převyprávění ruských, srbských…
předloh; pro `cs` je to nejbližší zdroj, který máme. `translated_from`
v indexu to eviduje, výběr zdroje to neovlivňuje.

**Index** `data/tale_sources.jsonl` (`python -m rag.sources`, bez LLM):
`source_ref`, `source_lang`, `translated_from`, `path` (vůči kořeni
repa), `url`, `chars`, `lang_check`. Jazyk bere z `meta.json` fetch-
wikisource (`lang`); Gutenberg katalog jsou anglická vydání (`en`,
přepis v `GUTENBERG_LANG_OVERRIDE`), ověřuje se počtem funkčních slov.
Chybí-li index, stage si ho postaví v paměti z `corpus/data/raw`; chybí-li
i korpus, skončí chybou. `tales.jsonl` se nemění.

**Úryvek.** Motivy z `rag.extract` nemají offsety, místo v textu se proto
hledá heuristikou (`sources.excerpt`): úvod pohádky (jména) + okno kolem
odstavce s nejvíc klíčovými slovy motivu (idf váhy; pro češtinu přes
malý slovník `CUES` en→cs kmenů, bez diakritiky a se staročeským
„w“ = „v“), v remíze podle toho, kde typ motivu / fáze nápovědy v příběhu
bývá. Jen z prvních 16 000 znaků (to viděl extract) a, kromě motivů typu
`ending`, **bez poslední pětiny textu** — karta ani nápověda nesmí
prozradit konec. Rozpočet `EXCERPT_CHARS` = 2 400 znaků (~900 tokenů
češtiny, ~560 angličtiny). K promptu se přidá `ORIGINAL_RULE`: použij
jména a formulace z úryvku, nepřekládej anglický motiv (ten jen říká,
o kterou chvíli jde), starý/nářeční pravopis piš dnešním.

**Původ řádku.** `Verbalization` (cards i verbalize) a `Hint` nesou
`source: "original" | "text_en"`; staré řádky pole nemají a čtou se jako
`text_en` (tak vznikly). `build_pack` pro každý motiv (karty, verbalizace)
a každé (motiv, fáze) (nápovědy) bere jen řádky z `original`, pokud nějaké
jsou — staré řádky se nemažou.

**Přegenerování** `--regen-from-original` (cards, verbalize, hints):
vezme jen klíče, které už ve výstupu jsou, píšou se z originálu a řádek z
originálu ještě nemají; připíše nové řádky vedle starých. Resumable jako
všechno ostatní. Nový jazyk ve stejném rozsahu jako hotový:
`--same-motifs-as rag/data/<stage>.cs.jsonl`.

```sh
python -m rag.sources                                    # index + statistika
python -m rag.sources --estimate --lang cs --regen-from-original   # objem a čas
python -m rag.cards     --lang cs --regen-from-original
python -m rag.verbalize --lang cs --regen-from-original
python -m rag.hints     --lang cs --regen-from-original
```

Odhad času (`--estimate`) počítá s kalibrací qwen36 / `openclaw-default`
(2,4 req/s při ~1 300 tokenech vstupu, concurrency 12) jako rozpětí: od
„vstup navíc nic nestojí“ po „propustnost klesá úměrně vstupu“.

## Reading the corpus off disk

There are two fetchers and therefore two on-disk layouts.
`fetch-gutenberg` writes one directory per book
(`grimm/2591-tales/`), because a Gutenberg anthology is one file that
gets split. `fetch-wikisource` writes a single `tales/` directory per
collection, because Wikisource already serves one page per tale and
there is no book id to speak of.

`discover_tales()` handles both. It used to match only `*-tales`, which
meant the entire Czech corpus sat on disk and was **never seen** — no
error, no warning, just 150 tales that quietly did not exist. The
provenance string keeps its old four-part shape for Gutenberg
(`gutenberg:grimm:2591:000-the-golden-bird`) and drops the empty book id
for Wikisource (`wikisource:nemcova:000-chytra-horakyne`); the Gutenberg
shape is load-bearing, because it is the dedupe key of the 93 records
already extracted.

Each collection is either single-country (`KNOWN_COUNTRY`) or explicitly
multi-country (`MIXED_ORIGIN`: `lang`, `erben-slovanske`). A collection
in neither is reported at the start of a run rather than silently taking
the model's per-tale guess. This matters more than it sounds: the globe
colours countries by where their motifs come from, so a Lang tale from
Japan tagged `DE` is not a slightly-off record, it's a wrong map.

Runs are chunked (`CHUNK = 25`) and flushed to disk after each chunk.
The corpus is ~900 tales now; a single batch would mean one network
hiccup at tale 890 throwing away hours of work. Re-running resumes,
because `done_keys()` reads what is already written.

## Status (2026-09-25)

**`rag.extract` has now run for real at scale**, against two different
Spark-resident models, both reached at `http://192.168.88.66:8080/v1`
via `ai-gateway` (`0.0.0.0:8080`, LAN, **no auth needed** — unlike
`llm.ol1n.com`, Cloudflare Access-gated).

**Run 1 — `translate`** (Qwen3-32B-AWQ via TensorRT-LLM,
`AiStack/deploy/docker-compose.translate.yaml`, started in its `lean`
memory profile): 5 Grimm tales, plus 3 motifs through `rag.verbalize`.
Two real bugs found and fixed — see `KNOWN_COUNTRY`/`clean_atu` in
`rag/extract.py` and their tests:
- `country_code` wrong for 2/5 tales (Die Bremer Stadtmusikanten, Der
  alte Sultan — both unambiguously Grimm/German — came back `FR`).
  Fixed by overriding with ground truth for single-country collections
  (grimm/andersen/perrault/aesop) instead of trusting a per-tale LLM
  guess; Lang's Fairy Books is genuinely multi-country and still left
  to the model.
- `atu_code` came back as `"554 The Golden Bird"` — the model tacked
  the tale's own title onto the number. `clean_atu()` keeps only the
  leading ATU-shaped token.

One **unfixed** quality issue from that run, flagged not patched (it's
model output quality, not a code bug): `rag.verbalize` translated "a
clever fox" as "**Lis**" in one Czech title — not a real Czech word for
fox (should be liška/lišák). The other 11/12 variants read as natural,
correct Czech.

**Run 2 — `swarm-director`** (Nemotron-3-Super-120B-A12B-NVFP4, a
resident vLLM process, not a docker-compose service — found already
running, shared with a concurrent 12-worker corpus-enrichment job from
an unrelated project): **93/93 tales** — the full Grimm (65) + Andersen
(18) + Perrault (10) — extracted successfully after 2-3 retries per
batch (resumable design: reruns only pick up what's missing), 1128
motifs (355 characters, 292 tasks, 296 problems, 185 endings). Czech
quality measurably better than `translate` (same fox sentence came back
"liška", correctly). Failures along the way were 502s/timeouts from
resource contention, not extraction bugs.

**Real unfixed safety gap, found against `swarm-director`'s run:**
`soft` was `False` and `atu_code` empty on **all 93/93** tales,
including ones with unambiguously dark content — spot-checked "Blue
Beard" (a husband who has murdered his previous wives, a closet full of
the evidence, an explicit murder threat) and it came back
`soft: False, age_min: 0`. **Do not use `soft`/`age_min` from this run
for any age-gating or content filtering without re-classifying** — this
is exactly the STORYTELLER_PLAN.md §7 guardrail the field exists for,
and this model silently doesn't populate it. The motif *text* itself
(characters/tasks/problems/endings) reads as good quality and was used
as-is for art-generation prompts (see `app/README.md`), which don't
depend on the safety classification the way age-gated verbalization
would.

Whether `translate` (correct `soft`, worse Czech, smaller/crippled
context when memory-starved) or `swarm-director` (no `soft`, better
Czech, contended with another team's job) is the right production
choice — or whether classification needs to be its own separate LLM
pass from motif extraction — is an open call, not made here.

**What has not run yet:** `rag.hints`, `rag.transitions`,
`rag.scene_prompts` (same endpoint, just not exercised); the embedder
(`sentence-transformers` not installed here, and the HF cache on this
Mac has `multilingual-e5-large`, not `-small` — large is 1024-d and too
big for phones, so the small model must still be pulled); `parity_check` — **done 2026-09-27**, see `app/README.md` → "RAG na
zařízení": the shipped model is the int8-embedding-table export; note that
`parity_check`'s 10 repeated samples passed a model that 206 real texts
failed, so check against real pack texts, not only the built-in samples.

Always smoke-test a stage with `--limit 5` against a fresh endpoint
first; small local models don't always honour `response_format`, and
the fallback path is only as good as their JSON — and even when the
JSON is well-formed, spot-check the *content* (see the two bugs above).

## Contracts the app side depends on

- **Pack schema** — `build_pack.SCHEMA` + the two `vec0` tables. The Dart
  `RagStore` ATTACHes `core.<lang>.db` and `country.<CC>.<lang>.db` and
  queries one shape. Bump `PACK_VERSION` on any schema change.
- **int8 quantization** — `embed.quantize_int8`: L2-normalised vector,
  `round(x*127)`, clamp to ±127, signed bytes. The Dart embedder must
  produce identical bytes for identical floats; sqlite-vec compares with
  `vec_int8(?)` and `distance_metric=cosine` (distance = 1 − cos).
- **e5 prefixes** — stored texts are embedded as `passage: …`, the
  transcript window as `query: …`. Swapping them degrades retrieval.
- **Retrieval query** — `build_pack.nearest_hints` is the reference SQL
  for RAG_PLAN §3 (phase filter + outline motifs + generic fallback,
  cosine order).
- **`meta.embed_model` / `embed_dim`** — a pack whose `embed_model` is
  empty or whose model differs from the device model must be refused.
