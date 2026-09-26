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
| `corpus/` | Go: `cmd/fetch-gutenberg` + `cmd/fetch-wikisource` (download + split public-domain tales), `cmd/build-geo` (Natural Earth → the globe's asset) |
| `rag/` | Python: LLM stages (`extract`, `verbalize`, `hints`, `transitions`, `scene_prompts`), `embed`, `build_pack` → SQLite+sqlite-vec packs, `parity_check` |
| `internal/` | Shared Go packages: `models`, `db`, `contentkey`, `comfy` (ComfyUI client), `nimqueue` (gen-queue/NIM client) |
| `infra/` | docker-compose (Postgres + Redis for local dev), SQL migrations, Caddy |
| `comfy/` | ComfyUI workflow JSON + style presets — `flux-dev/` is real and verified, others not started |
| `app/` | Flutter client — full flow (Globus→Postavy→Úkol→Problém→Konec→Osnova→Suflér) is real; `app/packages/content_key` is the Dart port of `internal/contentkey` |
| `eval/` | Hint-quality / latency / "never narrates for the parent" guard tests (not started) |

## Status (2026-09-25)

What's real and runnable today:

- **`app/` (Flutter)** — full flow: **Globus → Postavy → Úkol →
  Problém → Konec → Osnova → Suflér**, routed with `go_router`, state in a
  shared `storyDraftProvider`. The globe (§1.1b) is the home screen:
  spins with inertia, highlights and names whatever is at the centre,
  and **acts as the filter** for everything downstream — pick Denmark
  and the cast and all three motif pickers show only Danish material.
  It doubles as an honest coverage map: green = countries the corpus
  really has motifs from (today only DE/DK/FR), grey = nothing yet, and
  a grey country's entry button is disabled rather than quietly falling
  back to another tradition. Geometry is Natural Earth 110m via
  `corpus/cmd/build-geo` (819 KB → 114 KB asset).
  **All art is real**, no gradients-only placeholders left: Postavy has
  14 flux-schnell character renders; Úkol/Problém/Konec got 27 more,
  generated from real motifs `rag.extract` found in the 93-tale corpus
  — not invented text. Czech labels hand-translated (no LLM was up at
  generation time). No backend call anywhere yet. 28 tests,
  `flutter analyze` clean, real `flutter build apk --debug` succeeded.
  See `app/README.md`.
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

- **`corpus/` fetchers** — **913 tales staged** as of 2026-09-25, up from
  544. `cmd/fetch-gutenberg` pulls Grimm, Andersen, Perrault, **all
  twelve** of Lang's coloured Fairy Books and Aesop (763 tales), strips
  PG's boilerplate, and splits each anthology by matching its CONTENTS
  block against body headings; it now verifies each download against the
  catalog's expected title, so a mistyped ID fails loudly instead of
  yielding plausible nonsense. `cmd/fetch-wikisource` covers what
  Gutenberg does not have at all — the Czech canon: Němcová's *Národní
  Báchorky a Powěsti*, Erben's prose tales and his Slavic collection, 150
  tales off cs.wikisource via the MediaWiki API. Two books
  (Orange Fairy Book, Household Tales) still resist splitting and are
  stored whole; see `corpus/README.md`.
  **None of the 447 newly staged tales has been through `rag.extract`
  yet** — they are text on disk, not motifs, so the globe is still green
  for only DE/DK/FR.
- **`rag/`** (Python) — `extract` run for real, at scale, twice, against
  two different resident models on Spark via `ai-gateway`
  (`http://192.168.88.66:8080/v1`, LAN, no auth): **93/93 tales**
  (Grimm+Andersen+Perrault, 1128 motifs) extracted with `swarm-director`
  (Nemotron-3-Super-120B — better Czech than `translate`, e.g. "liška"
  not "Lis"). Found and fixed two bugs against `translate`'s run
  (`country_code` wrong for 2/5 tales, `atu_code` had the title stuck to
  it — `rag/rag/extract.py`'s `KNOWN_COUNTRY`/`clean_atu`). **Real
  unfixed safety gap found against `swarm-director`'s run: `soft` was
  `False` and `atu_code` empty on all 93/93**, including tales with
  clearly dark content (Blue Beard's murdered wives, confirmed by
  inspection) — do not trust `soft`/`age_min` from this run for any
  age-gating without re-classifying. `verbalize`/`hints`/`transitions`/
  `scene_prompts` still untried as LLM stages; 24 task/problem/ending
  motifs were hand-translated into the app instead (see `app/README.md`)
  since no LLM was reachable at the time. 23 tests pass offline. See
  `rag/README.md`.
- **Release pipeline → TestFlight** (`.github/workflows/`, `RELEASING.md`) —
  **the app ships.** `release-ios.yml` has uploaded two builds to
  TestFlight (1.0.0+2 and 1.0.0+3, both 2026-09-25); build numbers come
  from `github.run_number`, so `pubspec.yaml`'s `+1` never reaches
  App Store Connect and duplicate-build rejections can't happen. `ci.yml`
  (Flutter analyze+test, Go build+test) is green since 2026-09-26.
  **`release-android.yml` does not work**: the two Firebase secrets are
  missing and no Firebase Android app exists — `setup-gh-secrets.sh`
  doesn't set those, they're a manual step. Workflows come from the
  `Distribution` repo's golden templates via `align-project.sh`; local
  deviations are listed in `RELEASING.md` so a future re-align doesn't
  silently revert them.
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

Not started: the rest of the Flutter app — the "Dnes" 3×4-shortcut
screen, library, settings, any real network call, `AssetResolver`.
Live narration (§1.2) exists only as the prompter: the parent taps for
an open hint, there is no STT, no automatic sense of where in the
outline they are, no closing illustration and no saving.
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
