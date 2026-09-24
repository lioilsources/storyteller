# storyteller ("Vyprávěj" / BedTimeStoryTeller)

App that helps a parent tell their child a bedtime story — the app never
narrates, it offers building blocks (characters, tasks, obstacles,
endings), listens, and nudges. Specs:

- [`STORYTELLER_PLAN.md`](./STORYTELLER_PLAN.md) — product, globe mechanic, corpus, architecture
- [`STORYTELLER_OFFLINE_PLAN.md`](./STORYTELLER_OFFLINE_PLAN.md) — content keys, cache layers, nightly pipeline, offline-first
- [`STORYTELLER_MODELS_PLAN.md`](./STORYTELLER_MODELS_PLAN.md) — flux-schnell as tier-0 reference, async higher tiers, model/style registry, variant switching
- [`STORYTELLER_RAG_PLAN.md`](./STORYTELLER_RAG_PLAN.md) — no LLM at runtime: pre-verbalized motifs, hint bank, on-device embeddings + sqlite-vec

Language split: **Go** for the gateway, corpus fetching, and the media
orchestrator; **Python** only in `rag/` — the offline LLM + RAG pipeline
(extract, verbalize, hints, embeddings, pack building). Nothing in
`rag/` runs at app runtime.

## Layout

| Dir | What |
|---|---|
| `gateway/` | Go HTTP API (`cmd/server`): daily offer, later live-hints/media/library |
| `corpus/` | Go: `cmd/fetch-gutenberg` (download + split public-domain anthologies) |
| `rag/` | Python: LLM stages (`extract`, `verbalize`, `hints`, `transitions`, `scene_prompts`), `embed`, `build_pack` → SQLite+sqlite-vec packs, `parity_check` |
| `internal/` | Shared Go packages: `models`, `db`, `contentkey`, `comfy` |
| `infra/` | docker-compose (Postgres + Redis for local dev), SQL migrations, Caddy |
| `comfy/` | ComfyUI workflow JSON + style presets — layout/convention only, no workflow JSON yet |
| `app/` | Flutter client — cast composer prototype (§1.1a) is the only real screen; `app/packages/content_key` is the Dart port of `internal/contentkey` |
| `eval/` | Hint-quality / latency / "never narrates for the parent" guard tests (not started) |

## Status (2026-09-24)

What's real and runnable today:

- **`app/` (Flutter)** — cast composer prototype: STORYTELLER_PLAN.md
  §1.1a (added this session), reroll one/all + add/remove cast members
  1–6, "hot artwork" prefetch-budget simulation with a loading fallback.
  Placeholder art only, no backend call. 5 widget tests, `flutter
  analyze` clean, and a real `flutter build apk --debug` succeeded. See
  `app/README.md`.
- **`internal/contentkey` + `app/packages/content_key`** — v2 content
  addressing: `key_base` (content) + variant key (model × style × model
  version) + shared seed, per OFFLINE_PLAN §0.1 and MODELS_PLAN §0.1.
  Go and Dart, both tested against the same
  `internal/contentkey/testdata/golden.json` (8 vectors, byte-identical
  across languages). See `internal/contentkey/README.md`.
- **Model/style registry** — `infra/migrations/0003_models` (`models`,
  `styles`, `assets`→`asset_variants`, family quality prefs) +
  `infra/seed/models_styles.sql` (7 styles from PLAN §1.4, watercolor
  active; models all `shadow` — see below for why flux-schnell's
  `backend` is `nim`, not `comfy`).
- **`internal/comfy` + a real render** — the ComfyUI client: load a
  workflow + `inputs.json`, inject values by node title (fails loudly
  on anything undeclared), submit/poll/download/upload against
  ComfyUI's HTTP API, `Render` chaining all of it, `cmd/render-smoke`
  for manual runs. 17 tests against a mock server, **plus one real run**:
  `comfyui.ol1n.com` (PLAN §2) is 403 (Cloudflare Access-gated) from
  here, but the same ComfyUI is reachable **on the LAN at
  `http://192.168.88.66:8188`, no auth at all** — found by checking
  sibling projects (`Ol1nLLM`, `Kiran`, `MangaPrompts`,
  `ComfyUI-Custom-SPARK`) per user request. Rendered a real
  1024×1024 watercolor fox illustration end to end
  (`comfy/workflows/flux-dev/`, adapted from a working
  `Kiran/pipeline` workflow). **Real finding:** this Spark instance has
  no flux-schnell ComfyUI checkpoint — flux-schnell is served only via
  AiStack's NIM pass-through, a different HTTP contract `internal/comfy`
  doesn't implement. flux-dev (verified) runs ~45s/20 steps — a real
  tier-1 render, not the plans' "1-2s tier 0". See
  `internal/comfy/README.md` and `comfy/README.md`.

- **`corpus/cmd/fetch-gutenberg`** — downloads Grimm, Andersen, Perrault,
  Lang's Fairy Books, and Aesop from Project Gutenberg, strips PG's
  license boilerplate, and splits each anthology into individual tales
  by matching its CONTENTS block against body headings. IDs hand-verified
  against gutenberg.org on 2026-09-24 (see `corpus/README.md`).
- **`rag/`** (Python) — every LLM stage of RAG_PLAN §2 (`extract`,
  `verbalize`, `hints`, `transitions`, `scene_prompts`; resumable JSONL,
  pydantic-validated structured output, rule filters), `embed` (e5-small
  + the int8 contract), `build_pack` (SQLite + sqlite-vec packs, RAG_PLAN
  §6) and `parity_check` (§8.1). 21 tests pass without network or
  models, including a real sqlite-vec int8 cosine query. **No stage has
  run against a live LiteLLM endpoint yet**, and no embedding model has
  been pulled — see `rag/README.md`.
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

Not started: the rest of the Flutter app — globe/spin mechanic (§1.1b,
which the plan itself recommends doing *first*; this session built the
cast composer instead, explicit choice), daily offer screen, live
narration, library, settings, any real network call, `AssetResolver`.
ComfyUI workflow exports (need Spark access), Erben/Němcová fetcher
(they're on cs.wikisource.org, not Gutenberg — different scraper
needed), live-hint engine, TTS/STT, offline-plan steps 2–8
(`GET /v1/asset/{key}`, `POST /v1/generate` with the online-lane
semaphore, MinIO, `AssetResolver`, `nightly`, manifest sync, ranker,
metrics), models-plan steps 3–7 (ref2img path beyond the client itself,
consistency validation, resolver, upgrade jobs, bench, I2V), RAG-plan
`compat` LLM scoring / `phase_model` / spoiler classifier / the Flutter
`RagStore`+`Embedder`, and RAG §8.1 (embedding parity — the gate before
any real pack).

**What's actually blocking real artwork now:** the render path itself
isn't blocked anymore — LAN ComfyUI works, `internal/comfy` is proven.
What's still needed: a reachable `LITELLM_BASE_URL` (so `rag.extract`/
`rag.scene_prompts` can turn the 535 fetched tales into real motifs and
scene prompts instead of hand-written test fixtures), a fast tier-0
path (either a NIM HTTP client for flux-schnell, or accepting flux-dev
as an interim slower reference), and `ref2img`/character-consistency
workflows for cross-scene continuity.

## Quickstart

```sh
# 1. Fetch the public-domain corpus (Grimm/Andersen/Perrault/Lang/Aesop)
go run ./corpus/cmd/fetch-gutenberg

# 2. (needs a reachable LiteLLM endpoint) extract motifs — Python
cd rag && python3 -m venv .venv && .venv/bin/pip install -e '.[dev]' && cd ..
LITELLM_BASE_URL=http://<spark-host>:4000/v1 LITELLM_MODEL=<model> \
  rag/.venv/bin/python -m rag.extract --only grimm --limit 5   # smoke test first

# 3. Run the gateway (works right now with zero setup — seed corpus)
go run ./gateway/cmd/server
curl 'localhost:8080/v1/daily?family=demo'
```
