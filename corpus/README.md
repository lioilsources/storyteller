# corpus

Go CLI tools that build the motif corpus described in `STORYTELLER_PLAN.md`
§3. Legal note: only public-domain / open-licence sources — we extract
*motifs* (archetypal characters/tasks/problems/endings), never reproduce
the source text to end users.

## `cmd/fetch-gutenberg`

Downloads a hand-verified catalog of Project Gutenberg fairy tale
anthologies (`internal/gutenberg/catalog.go`), strips PG's license
boilerplate (between the `*** START OF ... ***` / `*** END OF ... ***`
markers every PG text file carries), and splits each anthology into
individual tales.

**Splitting heuristic:** these anthologies open with a `CONTENTS:` block
listing every tale title, and repeat each title verbatim as a standalone
heading line in the body. `internal/gutenberg/split.go` finds the
contents block, then locates each title again in the body to use as a
split point. Verified by hand against *Grimms' Fairy Tales* (Gutenberg ID
2591) on 2026-09-24 — line 49 `THE GOLDEN BIRD` in the contents block
matches line 125 in the body exactly. If a book's contents block isn't
found or fewer than 2 titles match in the body, the whole book is
returned as one "tale" instead of silently dropping text — check for
`OK, but split found no CONTENTS block` in the fetcher's output and spot-
check that book's split quality before trusting it for `extract`.

Catalog (IDs verified live against gutenberg.org's `Title:` header):

| Collection | Books |
|---|---|
| `grimm` | 2591 Grimms' Fairy Tales, 5314 Household Tales |
| `andersen` | 1597 Andersen's Fairy Tales |
| `perrault` | 29021 The Fairy Tales of Charles Perrault |
| `lang` | 503 Blue, 540 Red, 7277 Green, 640 Yellow Fairy Book |
| `aesop` | 21 Three Hundred Aesop's Fables |

```sh
go run ./corpus/cmd/fetch-gutenberg                  # everything
go run ./corpus/cmd/fetch-gutenberg -only grimm       # just one collection
```

Output: `corpus/data/raw/<collection>/<id>.txt` (+ `.json` metadata) for
the full stripped book, and `corpus/data/raw/<collection>/<id>-tales/`
for the per-tale split (`NNN-slug.txt` + `index.json`).

### Not yet fetched: Erben, Němcová

The plan (§8) wants Grimm + Erben + Němcová. Erben and Němcová are on
**cs.wikisource.org**, not Project Gutenberg — different site, different
scraper (MediaWiki API, not a flat text file). That's a separate command
(e.g. `cmd/fetch-wikisource-cs`), not yet written.

## Next stage: `rag/` (Python)

Classification + motif extraction (PLAN §3.2 steps 3–4) is `rag.extract`
in the Python `rag/` package — it reads the `<id>-tales/` directories
this fetcher writes. The Go `cmd/extract` that used to live here was
removed on 2026-09-24 when LLM work moved to Python (see `rag/README.md`).

## Still TODO for §3.2's full pipeline

`dedupe` (embedding + clustering across languages/variants), `coverage`
(report countries under 12 motifs), `country_art` (batch ComfyUI prompts
per country/style) — none started; all belong in `rag/` now.
