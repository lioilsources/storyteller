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
| `internal/` | Shared Go packages: `models`, `db`, `contentkey`, `comfy` (ComfyUI client), `nimqueue` (gen-queue/NIM client) |
| `infra/` | docker-compose (Postgres + Redis for local dev), SQL migrations, Caddy |
| `comfy/` | ComfyUI workflow JSON + style presets — `flux-dev/` is real and verified, others not started |
| `app/` | Flutter client — full story-assembly flow (Postavy→Úkol→Problém→Konec→Osnova) is real; `app/packages/content_key` is the Dart port of `internal/contentkey` |
| `eval/` | Hint-quality / latency / "never narrates for the parent" guard tests (not started) |

## Status (2026-09-24)

What's real and runnable today:

- **`app/` (Flutter)** — full story-assembly flow: **Postavy → Úkol →
  Problém → Konec → Osnova**, routed with `go_router`, state in a
  shared `storyDraftProvider`. Postavy (§1.1a: reroll one/all,
  add/remove 1–6) has real art — 14 flux-schnell renders
  (`internal/nimqueue`, watercolor, ~2-6s each), bundled as
  `assets/cast/*.jpg`. Úkol/Problém/Konec (simpler "pick 1 of 3 or
  shuffle" mechanic, no add/remove) are still hand-written mock motifs
  with placeholder gradients — next up once RAG gives real content. No
  backend call anywhere yet. 8 widget tests, `flutter analyze` clean,
  real `flutter build apk --debug` succeeded. See `app/README.md`.
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
  `Kiran/pipeline` workflow). flux-dev runs ~45s/20 steps — a real
  tier-1 render. See `internal/comfy/README.md` and `comfy/README.md`.
- **`internal/nimqueue` + real tier-0 renders** — flux-schnell doesn't
  run on ComfyUI here at all; it's served through AiStack's
  **gen-queue** (async job queue in front of the NIM container — submit
  → poll → download, protocol reverse-engineered from Ol1nLLM's actual
  Flutter client + gen-queue's Go source). Reachable **unauthenticated
  on the LAN at `http://192.168.88.66:8091`**, same as the gateway and
  ComfyUI. Two real renders (`cmd/generate-smoke`): a watercolor fox and
  a papercut-collage fox+badger scene, **2-4 seconds each** — the plans'
  actual "tier 0, fast" budget, unlike flux-dev's 45s. 12 tests against
  a mock server built from the verified contract. A second NIM
  container (flux-dev, for parity) was tried and abandoned — hung twice
  in a row on this Spark box; not pursued since flux-dev already works
  via ComfyUI and doesn't need to be fast. See `internal/nimqueue/README.md`.

- **`corpus/cmd/fetch-gutenberg`** — downloads Grimm, Andersen, Perrault,
  Lang's Fairy Books, and Aesop from Project Gutenberg, strips PG's
  license boilerplate, and splits each anthology into individual tales
  by matching its CONTENTS block against body headings. IDs hand-verified
  against gutenberg.org on 2026-09-24 (see `corpus/README.md`).
- **`rag/`** (Python) — every LLM stage of RAG_PLAN §2, **`extract` and
  `verbalize` now run for real** against Spark's `translate` model
  (Qwen3-32B, reached at `http://192.168.88.66:8080/v1` — `ai-gateway`
  on the LAN, no auth needed, unlike the Cloudflare-gated
  `llm.ol1n.com`). Found and fixed two real extraction bugs
  (`country_code` wrong for 2/5 Grimm tales, `atu_code` had the tale's
  title stuck to it); found and flagged one unfixed translation quality
  issue ("fox" → "Lis", not a Czech word). `hints`/`transitions`/
  `scene_prompts` still untried. 23 tests pass offline. See
  `rag/README.md`.
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
cast/task/problem/ending/osnova flow instead, explicit choice), the
"Dnes" 3×4-shortcut screen, live narration, library, settings, any real
network call, `AssetResolver`.
`sdxl-lora` ComfyUI workflow (tier 1s), Erben/Němcová fetcher (they're
on cs.wikisource.org, not Gutenberg — different scraper needed),
live-hint engine, TTS/STT, offline-plan steps 2–8 (`GET /v1/asset/{key}`,
`POST /v1/generate` with the online-lane semaphore, MinIO,
`AssetResolver`, `nightly`, manifest sync, ranker, metrics), models-plan
steps 3–7 (ref2img for character consistency, DINOv2 validation,
resolver picking `comfy` vs `nim` per model row, upgrade jobs, bench,
I2V), RAG-plan
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
