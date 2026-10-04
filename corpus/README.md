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

### World coverage, wave 2 (2026-10-04)

Regions that were still grey: South and Central America, South-East Asia,
the Arabian Peninsula, Central Asia and the Caucasus. Candidates came from
Gutenberg's own catalog (`pg_catalog.csv`, subject headings `Tales /
Folklore / Legends -- <place>`) and from Internet Archive. Every text is
English (`Lang: "en"`): none of these traditions has an original in a
language we create content in, and the rule is original-or-English, never
a translation that went through Czech.

| Collection | Source | Origin | Tales |
|---|---|---|---|
| `finger-silver-lands` | PG 68292 Finger, *Tales from Silver Lands* (1924) | mixed; per tale HN GY AR GT×3 UY CO BR BO, rest model | 19 |
| `eells-brazil` | PG 21678 + 24714 Eells, *Tales of Giants from Brazil*, *Fairy Tales from Brazil* | BR | 12 + 18 |
| `wait-el-dorado` | PG 42823 Wait, *The Stories of El Dorado* (1904) | mixed (Maya, Aztec, Inca, Muisca…) | 25 |
| `shan-griggs` | PG 32375 Griggs, *Shan Folk Lore Stories* | MM (Shan) | 9 |
| `burma-pagoda` | PG 36171 "Mimosa", *Told on the Pagoda: Tales of Burmah* | MM | 7 |
| `skeat-malay` | IA `fablesandfolktal00skeauoft` Skeat, *Fables and Folk-Tales from an Eastern Forest* (1901) | MY | 26 |
| `araby-chandler` | PG 73256 *Told in the Gardens of Araby* (1905) | mixed (Levant / Yemen) | 9 |
| `georgian-wardrop` | PG 44536 Wardrop, *Georgian Folk Tales* (Georgian, Mingrelian, Gurian) | GE | 38 |
| `armenian-seklemian` | PG 46944 Seklemian, *The Golden Maiden* | AM | 25 |
| `caucasian-gulbat` | PG 35577 Gulbat, *Caucasian Legends* | mixed | 11 |
| `coxwell-central-asia` | IA `siberian-and-other-folk-tales` Coxwell, *Siberian and Other Folk-Tales* (1925), Kirghiz, Turkoman and Darvash (Pamir) sections only | per tale KZ×7 TM TJ, rest model | 13 |

Three mechanisms were added for these books, all in `catalog.go`:

- **`Titles` (+ `Start`, `End`)** — an explicit, hand-checked list of the
  tale headings as printed in the body, for books whose contents block the
  CONTENTS heuristic cannot read: roman numerals with a single space
  (Finger), entries ending in commas and headings with footnote marks
  (Wardrop), no contents heading at all (Seklemian), headings wrapped
  over two lines (Eells), OCR text (both Internet Archive books).
  `Start` begins the search past the contents listing (required — the
  listing would otherwise match first), `End` stops the last tale before
  notes, glossaries or verse. `Cut("Notes")` entries cut a block out
  between tales. Every listed title must be found or the book fails; the
  CONTENTS heuristic itself is unchanged (split of all 69 existing books
  verified identical before/after).
- **`TaleCountry`** — the ISO code of single tales in a mixed book where
  the book itself names the place ("In Colombia, it seems…"). Written to
  `index.json` as `"country"`; `rag.extract` and `rag.classify --apply`
  prefer it to the model's guess.
- **`Archive`** — an Internet Archive item instead of a Gutenberg ID,
  only for books Gutenberg lacks. The item's metadata title is checked
  like PG's `Title:` header, the sidecar records `"source": "archive"`
  (so `source_ref` reads `archive:skeat-malay:…`) and a `License` saying
  why the text is public domain.

The sidecar `<key>.json` now also carries `"lang"` (same key as
`fetch-wikisource`'s meta). Seklemian's *Golden-Headed Fish* is cut on
purpose — Lang retold it in the Olive Fairy Book and it is already in
the corpus as AM.

Looked at and left out: Lewis Spence's *Myths of Mexico and Peru* (PG
53080) and *Popol Vuh* (56550) are commentary, not tales (Finger retells
the Popol Vuh); *Malayan Literature* (7095) is epic verse; *Armenian
Legends and Poems* (54036) is mostly poetry; *Folk-lore in Borneo* (30233)
is a monograph without separable tales; Skinner's *Myths and Legends
beyond our Borders* (IA, 1899) is short historical anecdote in poor OCR;
Laval's *Cuentos populares en Chile* (PG 63424), Palma's *Tradiciones
peruanas* (21282) and Pavie's *Contes du Cambodge, du Laos et du Siam*
(IA, 1903) are Spanish / French, neither original-language-we-write nor
English. No public-domain English collection was found for Thailand,
Vietnam, Cambodia, Indonesia, Nepal, Bhutan, Uzbekistan, Kyrgyzstan as
such (Coxwell's "Kirghiz" are mostly Kazakh), Azerbaijan or the Gulf
states.

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

Output: `corpus/data/raw/<collection>/<id>.txt` (+ `.json` metadata; `<id>` is the Gutenberg ID or the Internet Archive identifier) for
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
