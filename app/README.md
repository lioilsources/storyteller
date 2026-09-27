# app

Flutter client (iOS/Android). Riverpod for state (per
STORYTELLER_PLAN.md §2.1); `packages/content_key` is the Dart port of
`internal/contentkey`, used by the (not yet written) `AssetResolver`.

## What's here (2026-09-25)

**Globe** (`lib/globe/`) — the home screen, STORYTELLER_PLAN.md §1.1b.
Drag to rotate, fling to coast (exponential friction, ~2 s), tap a
country to turn to it the short way round, "Roztočit" for the plan's
random landing. Whatever sits dead centre is what you're looking at:
highlighted in amber and named in the card below, with how much we
actually have from there ("224 motivů z 18 pohádek").

It is a plain `CustomPainter` over an orthographic projection
(`globe_projection.dart`), not a 3D scene — the plan offers this as the
cheap option and at 175 countries / 259 rings / 10 354 points it holds
60 fps because back-facing rings are culled before any `Path` is built.
Geometry is Natural Earth 110m (public domain), converted by
`corpus/cmd/build-geo` to `assets/geo/countries.json`: 819 KB → **114
KB**, coordinates rounded to 1 decimal, only each country's largest ring
kept (so Denmark is Jutland, no Zealand). Two countries are dropped for
having no ISO code at all (N. Cyprus, Somaliland).

**The globe is also an honest coverage map, and a filter.** Green
countries are ones `rag.extract` actually produced motifs for — today
exactly DE (785 motifs / 65 tales), DK (224/18), FR (119/10); everything
else is grey (§1.1b's "zamlžené" countries). Picking a country writes it
into `storyDraftProvider` and *restarts* the draft, and every pool
downstream is narrowed to that tradition: the cast composer, and all
three motif pickers. A grey country's "Vyprávět z …" button is
deliberately **disabled** — letting it through would fall back to the
full pool and serve a German tale under a Czech label, which is the one
thing the globe promises not to do. The opening view aims at whichever
country has the most motifs (derived from the asset, not hardcoded), so
the app never starts on a dead end.

Consequence worth knowing: a narrow tradition shows *fewer* cards rather
than padding from elsewhere. France has one motif per category, so its
picker shows one card and "Zamíchat" is dead; Germany has 5 characters
against `maxCastSize` 6, so "Přidat postavu" runs out at 5/6.

**Cast composer prototype** (`lib/cast/`) — reached from the globe.
Implements STORYTELLER_PLAN.md §1.1a: reroll one
card / reroll all / add / remove, cast size 1–6. This screen exists to
validate the *interaction*, not to demo the backend — no network call
anywhere in it.

**The art is real, not placeholder.** `assets/cast/*.jpg` are 14 actual
flux-schnell renders (watercolor style), generated 2026-09-24 via
`internal/nimqueue` against the live NIM container on Spark, ~2-6s
each — see the session notes for exact prompts/seeds. The gradient
(`CastMember.gradient`) is kept only as a base layer / fallback if an
asset is ever missing (`Image.asset`'s `errorBuilder`). One honest
finding worth remembering: the "four princesses" prompt rendered only
three — diffusion models don't reliably hit an exact requested count,
relevant once real prompts start encoding cast size (§1.1a).

The one thing worth understanding before touching it: `CastComposerController`
simulates the "hot artwork" design from §1.1a with a `prewarmBudget`
counter (default 3) shared across reroll/add — draws while it's > 0
resolve instantly (as if pre-warmed), draws after it's exhausted take a
900–1600ms delay and show a loading veil (as if falling back to an
online tier-0 render, MODELS_PLAN §4). This is a stand-in for the real
prefetch-pool mechanism, not the real thing.

## Screens (2026-09-25)

The full flow now exists: **Globus → Postavy → Úkol → Problém →
Konec → Osnova → Suflér**, routed with `go_router` (`lib/main.dart`),
state accumulated in `storyDraftProvider` (`lib/story/story_draft.dart`)
so popping back doesn't lose later choices. Task/problem/ending share
one generic `MotifPickerScreen` (`lib/motifs/`) — pick 1 of 3 shown, or
shuffle for 3 new ones; no per-card reroll or add/remove there, those
stay singular regardless of cast size (§1.1a). `OsnovaScreen`
(`lib/story/`) shows the assembled result, and `Vyprávím →` leads into
the prompter (see below).

**Art status by screen: all real now.** Postavy has 14 flux-schnell
renders (`assets/cast/`). Úkol/Problém/Konec (2026-09-25) are no longer
hand-invented mock text — `lib/motifs/motif.dart`'s 24 entries (8 per
category) are motifs `rag.extract` actually found in the 93-tale corpus
(Grimm/Andersen/Perrault), with real art (`assets/motifs/*.jpg`, 3.4MB,
flux-schnell) rendered from the same English motif text. Czech labels
were hand-translated, not LLM-generated — no LLM was reachable at the
time (`swarm-director` down until 1AM, `translate` stopped earlier for
memory) — this is the manual equivalent of the not-yet-written
`rag.verbalize`-at-scale pass, done for one curated batch. Source
English text is in each `Motif`'s generation history, not stored in the
app (only the Czech label + the rendered image ship).

**39 tests** (6 cast-composer, 3 full-flow/shuffle/reset, 11 prompter, 19 globe:
projection maths, country lookup against the real asset, rotate/fling/
tap, and the country filter end to end). `flutter analyze` clean,
`flutter build apk --debug` succeeds with all assets bundled.

Three traps worth knowing before you touch this, all of them cost real
time here:

1. **Asset I/O does not complete inside `testWidgets`.** The fake-async
   zone never resolves a real `rootBundle.loadString`, so a screen that
   loads the geo asset in `initState` can only ever be pumped in its
   loading state — and a `pumpAndSettle` waiting for it burns the full
   10-minute test timeout rather than failing. That's why the index is a
   `countryIndexProvider` (`lib/globe/country.dart`) the tests override
   with an already-parsed one (`test/globe_entry.dart`).
2. **Never leave an animation mounted forever.** `pumpAndSettle` waits
   for the frame pipeline to go quiet, so a permanent
   `CircularProgressIndicator` hangs it. The globe's loading state is
   plain text for exactly this reason, and its `Ticker` runs only while
   the sphere actually has momentum (also the battery-correct choice).
3. **A top-level `final router = GoRouter(...)` is a module-level
   singleton** in Dart — it survives across separate `pumpWidget()`
   calls in different tests (same isolate), so one test's navigation
   state leaks into the next. Fixed by building the router inside
   `StorytellerApp`'s `State` (`late final`); production only ever
   creates one `StorytellerApp` element, so nothing changes there.

And one bug that only a test caught: the country filter was implemented
in `MotifPickerScreen` but passed to **none** of the three picker
routes, so it silently did nothing for task/problem/ending while
appearing to work for the cast. The three routes are now built from one
`_motifRoute` helper (`lib/main.dart`) so they cannot drift apart again.

## Not started

STT and the automatic "where in the outline are you" of §1.2 (the
prompter below is the manual half), the closing illustration, Knihovna,
Nastavení, any real network call (`gateway/cmd/server` exists and works
— this app doesn't call it yet), `AssetResolver`, audio
(`record`/`just_audio`).

Also: only 3 countries are green. The texts for the rest are now staged
(913 tales including the whole Czech canon and all twelve Lang volumes),
but **none of the 447 new ones has been through `rag.extract`**, so
they're text on disk, not motifs, and the globe can't colour them.

## Suflér (`lib/narrate/`)

"Vyprávím →" on the outline used to show a SnackBar admitting live
narration wasn't built. It now opens the prompter: the parent walks the
four beats their outline already fixed (Kdo → Úkol → Problém → Konec),
sees what they picked for each, and taps **Napověz** for an open prompt
when they get stuck.

What §1.2 also asks for and this deliberately **does not do**: listen
via STT, work out where in the outline the parent is, and offer the hint
unprompted after 2.5 s of silence. All three are expensive, and none of
them answers the question this screen exists to answer — *are the
prompts any use at all when you're telling a child a story?* If they
aren't, speech recognition wouldn't save them, it would only make them
cost more. Same for the closing illustration and saving into Knihovna:
the end-of-story dialog says plainly that neither exists.

Every prompt is a question or an unfinished thought, never a sentence
you could read aloud as the story — that's the §7 promise that the app
never narrates for the parent, and a test enforces it (each prompt must
end in `?` or `…`).

**Two Czech rules the prompts obey**, both found by looking at a
rendered screen rather than at code:

1. `{postava}` may only stand in the **nominative, as the subject**. The
   labels are descriptive phrases from the corpus ("Král se strašidelným
   hradem"), not names, and nothing declines them — "Podle čeho bys
   *Král se strašidelným hradem* poznal?" needs the accusative "Krále",
   which we cannot produce. The prompt gets rephrased instead.
2. **No pronoun may refer to the character.** "Kdo *jí* to poradil?"
   assumes a feminine character and half the cast isn't. Czech lets you
   drop the pronoun, so the prompts do.

Both are tested (the second by scanning for gendered pronouns, the first
by a crude preposition check on the raw templates). A declension library
would lift rule 1 and a per-character gender field would lift rule 2;
neither exists, and the rephrased prompts read fine.

## RAG na zařízení (`lib/rag/`, `packages/rag_embed`)

Zatím jen embedder a jeho kontrola shody (RAG_PLAN §8.1) — **nic z UI ho
ještě nevolá**; `RagStore` a Suflér nad retrievalem jsou další krok.

Vektor, který spočítá telefon, musí být tentýž, jaký `rag.build_pack`
uložil do packu, jinak je retrieval tiše k ničemu. Tři vrstvy, každá
testovaná proti výstupu Pythonu:

- **tokenizace** — `packages/rag_embed`, `dart_sentencepiece_tokenizer` nad
  HF `tokenizer.json`: 1314/1314 případů ID-shodných s HF tokenizerem
  (NBSP, ligatury, emoji, ořez na 512 tokenů). `dart test` v balíčku;
  bez tokenizeru (`E5_TOKENIZER_JSON`) se tenhle test přeskočí.
- **pooling + int8** — mean pooling, L2, `round(x·127)` **half-to-even**
  jako Python `round` (Dart `round()` je half-away-from-zero).
- **model** — `integration_test/embed_parity_test.dart` na simulátoru:
  206/206 int8 vektorů bajtově shodných s Pythonem, min cos 0,9997 proti
  sentence-transformers, embed 5,5 ms (p50, simulátor na Macu).

Model je `e5_small_int8emb.onnx` (173 MB): int8 jen embedding tabulka.
Plně int8 váhy (113 MB) propadly (min cos 0,968), per-channel int8 prošel
na 10 vzorcích `rag.parity_check`, ale ne na 206 reálných textech (0,989).

Model ani tokenizer nejsou v gitu (GitHub odmítá > 100 MB). Lokálně je
zkopíruj do `assets/rag/` z exportu (`rag/`, ONNX export e5-small); CI je
stahuje z release `rag-model-e5small-1` a ověřuje proti
`app/rag_model.sha256`.

```sh
flutter test integration_test/embed_parity_test.dart -d <simulátor>
```

iOS jede přes **CocoaPods, ne SwiftPM** (`pubspec.yaml` → `flutter.config`):
`xcodebuild` resolve binárního targetu `flutter_onnxruntime` visel hodiny
bez jediného spojení, přičemž tentýž zip curl stáhne za 9 s. Minimum iOS 16.

## Screenshots

`test/screenshots/*.png` are rendered headlessly from the real widget
tree — no device, no simulator:

```sh
flutter test test/screenshots_test.dart --update-goldens
```

Without `--update-goldens` the same file is a visual regression suite. It
is tagged `screenshots` and excluded from the normal run, because goldens
fail on harmless Skia and font changes:

```sh
flutter test --exclude-tags screenshots
```

Two things make it work where a naive golden test gives black boxes and
blank cards: real fonts are loaded by hand from the SDK (the test
environment otherwise renders every glyph as a rectangle), and asset
images are decoded inside `tester.runAsync`, because decoding is real
async work the fake-async zone never completes.

It earned its keep immediately: the first run showed a `RenderFlex`
overflow painting debug stripes over the cast composer's "Pokračovat →"
button at 412dp — a perfectly ordinary Android width. Fixed by making
that bar a `Wrap`.

## Known gaps you can see in the screenshots

- **Country names are English** ("Germany", "Czechia") — they come
  straight from Natural Earth's `NAME` field. §1.1d (translations) has
  not been done; the rest of the UI is Czech, so this reads as a bug and
  is one.
- **Some motif art contains garbled pseudo-text** (a wine cellar with
  "br celire" on the wall). flux-schnell cannot write, and the prompts
  did not say so. Worth a negative prompt before the next art batch.

## Running it

```sh
flutter pub get
flutter test --exclude-tags screenshots   # 39 tests, no device needed
flutter run                                # needs a connected device or simulator
```
