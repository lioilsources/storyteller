# storyteller ("Vyprávěj" / BedTimeStoryTeller)

App that helps a parent tell their child a bedtime story — the app never
narrates, it offers building blocks (characters, tasks, obstacles,
endings), listens, and nudges. Specs:

- [`STORYTELLER_PLAN.md`](./STORYTELLER_PLAN.md) — product, globe mechanic, corpus, architecture
- [`STORYTELLER_OFFLINE_PLAN.md`](./STORYTELLER_OFFLINE_PLAN.md) — content keys, cache layers, nightly pipeline, offline-first
- [`STORYTELLER_MODELS_PLAN.md`](./STORYTELLER_MODELS_PLAN.md) — flux-schnell as tier-0 reference, async higher tiers, model/style registry, variant switching
- [`STORYTELLER_RAG_PLAN.md`](./STORYTELLER_RAG_PLAN.md) — no LLM at runtime: pre-verbalized motifs, hint bank, on-device embeddings + sqlite-vec (not started; open question on Python vs Go for the Spark-side pipeline)

Backend is **all Go** (gateway + corpus tooling) — no Python anywhere in
this repo.

## Layout

| Dir | What |
|---|---|
| `gateway/` | Go HTTP API (`cmd/server`): daily offer, later live-hints/media/library |
| `corpus/` | Go CLI tools that build the motif corpus: `cmd/fetch-gutenberg`, `cmd/extract` |
| `internal/` | Shared Go packages: `models`, `db`, `contentkey` |
| `infra/` | docker-compose (Postgres + Redis for local dev), SQL migrations, Caddy |
| `comfy/` | ComfyUI workflow JSON + style presets (not started) |
| `app/` | Flutter client (not started) — `app/packages/content_key` is the Dart port of `internal/contentkey` |
| `eval/` | Hint-quality / latency / "never narrates for the parent" guard tests (not started) |

## Status (2026-09-24)

What's real and runnable today:

- **`internal/contentkey` + `app/packages/content_key`** — v2 content
  addressing: `key_base` (content) + variant key (model × style × model
  version) + shared seed, per OFFLINE_PLAN §0.1 and MODELS_PLAN §0.1.
  Go and Dart, both tested against the same
  `internal/contentkey/testdata/golden.json` (8 vectors, byte-identical
  across languages). See `internal/contentkey/README.md`.
- **Model/style registry** — `infra/migrations/0003_models` (`models`,
  `styles`, `assets`→`asset_variants`, family quality prefs) +
  `infra/seed/models_styles.sql` (flux-schnell active; flux-dev and
  sdxl-lora shadow; 7 styles from PLAN §1.4, watercolor active).
  `/comfy` has the layout and the input-node convention documented, but
  **no workflow JSON yet** — those get exported from the Spark ComfyUI,
  not written by hand.

- **`corpus/cmd/fetch-gutenberg`** — downloads Grimm, Andersen, Perrault,
  Lang's Fairy Books, and Aesop from Project Gutenberg, strips PG's
  license boilerplate, and splits each anthology into individual tales
  by matching its CONTENTS block against body headings. IDs hand-verified
  against gutenberg.org on 2026-09-24 (see `corpus/README.md`).
- **`corpus/cmd/extract`** — reads those tales and asks an LLM (via
  LiteLLM, OpenAI-compatible) to pull out motifs + ATU/country/age
  classification. Code is complete but **not yet run against the real
  Spark LiteLLM endpoint** — needs `LITELLM_BASE_URL`/`LITELLM_MODEL`.
- **`gateway/cmd/server`** — serves `GET /v1/daily?family=&date=`
  deterministically (same family+date ⇒ same offer everywhere), but from
  a small hand-written seed corpus, not from `corpus_motifs` yet — the
  Postgres-backed `offer.Source` still needs wiring once `extract -load`
  has actually populated the table.
- **`infra/`** — docker-compose for local Postgres+Redis, and migrations
  `0001_init` (plan §2.2 data model), `0002_offline` (misses, jobs,
  packs, manifest_versions, hit_log from the offline plan §2.4/§7;
  environments + creatures from plan §1.1c), `0003_models` (registries,
  asset_variants). **No migration has been applied to a live Postgres
  yet** — no local instance was running when they were written; apply
  them (`0001` → `0002` → `0003`, then `infra/seed/models_styles.sql`)
  before trusting the SQL.

Not started: Flutter app (including the globe/spin mechanic, §1.1b —
plan says do this *first*, next time), ComfyUI workflow exports and the
Go input injector (`internal/comfy`), Erben/Němcová fetcher (they're on
cs.wikisource.org, not Gutenberg — different scraper needed), live-hint
engine, TTS/STT, offline-plan steps 2–8 (`GET /v1/asset/{key}`,
`POST /v1/generate` with the online-lane semaphore, MinIO,
`AssetResolver`, `nightly`, manifest sync, ranker, metrics), models-plan
steps 3–7 (ref2img path, consistency validation, resolver, upgrade jobs,
bench, I2V), and the whole RAG plan.

## Quickstart

```sh
# 1. Fetch the public-domain corpus (Grimm/Andersen/Perrault/Lang/Aesop)
go run ./corpus/cmd/fetch-gutenberg

# 2. (needs a reachable LiteLLM endpoint) extract motifs
LITELLM_BASE_URL=http://<spark-host>:4000/v1 LITELLM_MODEL=<model> \
  go run ./corpus/cmd/extract -limit 5   # smoke test a handful first

# 3. Run the gateway (works right now with zero setup — seed corpus)
go run ./gateway/cmd/server
curl 'localhost:8080/v1/daily?family=demo'
```
