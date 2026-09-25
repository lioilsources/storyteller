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

Two shapes of contents block broke this and were fixed on 2026-09-25.
Gutenberg marks italics with underscores, so the Olive and Lilac books
write `_CONTENTS_` and `_The Blue Parrot_`; `stripEmphasis` now handles
that, and those two volumes split into 29 + 33 tales instead of one blob
each. The **Orange Fairy Book (3027) still does not split**: its contents
block is reflowed into a paragraph, so there are no per-title lines to
read at all, and it stays on the whole-book fallback along with
*Household Tales* (5314). Two books out of seventeen.

The fetcher now also **verifies every download against the catalog**
(`CheckTitle`): a Gutenberg ID is just an integer in a URL, so one
transposed digit yields a real book that is not the one we meant, and the
mistake would only surface much later as nonsense motifs. A mismatch
fails before anything is written. The tale directory is likewise cleared
before each write — improving the splitter changes both the count and the
filenames, and an older run's orphans would otherwise be extracted as
extra "tales" (this happened, with the Olive and Lilac whole-book blobs).

Catalog (IDs verified live against gutenberg.org's `Title:` header):

| Collection | Books | Tales |
|---|---|---|
| `grimm` | 2591 Grimms' Fairy Tales, 5314 Household Tales | 65 |
| `andersen` | 1597 Andersen's Fairy Tales | 18 |
| `perrault` | 29021 The Fairy Tales of Charles Perrault | 10 |
| `lang` | all twelve coloured Fairy Books (503, 540, 7277, 640, 5615, 6746, 641, 2435, 3282, 3027, 27826, 28096) | 358 |
| `aesop` | 21 Three Hundred Aesop's Fables | 312 |

Lang is the volume that matters for the globe (§1.1b): unlike Grimm (all
German) or Andersen (all Danish), each Lang book gathers tales from a
dozen nations, which is what most of the planet needs before it stops
being grey. The flip side is that their origin **cannot** be assigned per
collection, only per tale — `rag.extract`'s `KNOWN_COUNTRY` override must
not be applied to `lang`.

Aesop deliberately stays at one edition: Gutenberg carries several
translations of the same ~300 fables, and adding them would duplicate the
corpus and burn LLM time re-extracting tales we already have.

## `cmd/fetch-wikisource`

Exists because **the Czech canon is not on Project Gutenberg at all**.
Erben and Němcová live on cs.wikisource.org, which serves tales through
the MediaWiki API as one page per tale rather than as one big anthology —
so splitting works the other way round: enumerate subpages, fetch each.

`internal/wikisource/plaintext.go` reduces the rendered HTML to prose.
Wikisource marks its own apparatus with `ws-noexport`, which makes most
of this reliable; on top of that every `<table>` is dropped whole,
because on these pages tables are always navigation or the "Údaje o
textu" licence box, never story. Without that the extractor would happily
report a character named Božena Němcová.

| Collection | Source | Origin | Tales |
|---|---|---|---|
| `nemcova` | Národní Báchorky a Powěsti | CZ | 25 |
| `erben` | individual prose tales (Zlatovláska, Tři zlaté vlasy…) | CZ | 5 |
| `erben-slovanske` | Vybrané báje a pověsti národní jiných větví slovanských | **mixed** | 115 |
| `nemcova-srbske` | Srbské pohádky | RS | 5 |

Erben's Slavic volume is marked `MixedOrigin`: it collects Russian,
Bulgarian, Serbian, Polish and Croatian tales, so like `lang` it must not
get a blanket country tag. Kytice is deliberately excluded — verse, and
far too dark for this app's purpose.

Two traps worth knowing, both found by running it:

- **`action=parse` does not follow redirects** unless you ask. Without
  `redirects=1` the API cheerfully renders the redirect *stub* — a
  55-character "Přesměrování na:" page — and you get a successful
  response containing no tale. Subpage listings therefore also filter
  redirects out (`apfilterredir=nonredirects`), or a third of Němcová
  would be fetched twice: cs.wikisource keeps a redirect for every tale
  whose title was modernised, e.g. "…se zlatou **hvězdou** na čele" →
  "…se zlatou **hwězdou** na čele".
- A page reduced to under 200 characters is reported and skipped rather
  than written, and the command exits non-zero if anything was skipped.
  One unusable page shouldn't cost the other 25 in its volume, but a
  silently thin corpus is the failure mode that only surfaces much later
  as missing motifs.

```sh
go run ./corpus/cmd/fetch-wikisource                 # everything
go run ./corpus/cmd/fetch-wikisource -only nemcova   # just one collection
```

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
