# storyteller ("Vyprávěj" / BedTimeStoryTeller)

App that helps a parent tell their child a bedtime story — the app never
narrates, it offers building blocks (characters, tasks, obstacles,
endings), listens, and nudges. Full product spec: [`STORYTELLER_PLAN.md`](./STORYTELLER_PLAN.md).

Backend is **all Go** (gateway + corpus tooling) — no Python anywhere in
this repo.

## Layout

| Dir | What |
|---|---|
| `gateway/` | Go HTTP API (`cmd/server`): daily offer, later live-hints/media/library |
| `corpus/` | Go CLI tools that build the motif corpus: `cmd/fetch-gutenberg`, `cmd/extract` |
| `internal/` | Shared Go packages (`models`, `db`) used by both `gateway/` and `corpus/` |
| `infra/` | docker-compose (Postgres + Redis for local dev), SQL migrations, Caddy |
| `comfy/` | ComfyUI workflow JSON + style presets (not started) |
| `app/` | Flutter client (not started) |
| `eval/` | Hint-quality / latency / "never narrates for the parent" guard tests (not started) |

## Status (2026-09-24)

What's real and runnable today:

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
- **`infra/`** — docker-compose for local Postgres+Redis, and the full
  `0001_init` migration for every table in the plan's §2.2 data model.

Not started: Flutter app (including the globe/spin mechanic, §1.1b —
plan says do this *first*, next time), ComfyUI workflows, Erben/Němcová
fetcher (they're on cs.wikisource.org, not Gutenberg — different scraper
needed), live-hint engine, TTS/STT.

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
