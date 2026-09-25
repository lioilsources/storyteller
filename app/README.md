# app

Flutter client (iOS/Android). Riverpod for state (per
STORYTELLER_PLAN.md §2.1); `packages/content_key` is the Dart port of
`internal/contentkey`, used by the (not yet written) `AssetResolver`.

## What's here (2026-09-24)

**Cast composer prototype** (`lib/cast/`) — the current `home:` screen.
Implements STORYTELLER_PLAN.md §1.1a, added this session: reroll one
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

5 widget tests (`flutter test`), including the warm→cold transition.
`flutter analyze`: clean. `flutter build apk --debug`: succeeds with
the real assets bundled (`pubspec.yaml` → `assets: [assets/cast/]`).

The plan's own recommended *first* screen was the globe (§1.1b), not
this one — this session built the cast composer instead because it's
the higher-interaction-risk piece (explicit choice, see conversation).
The globe is still not started.

## Screens (2026-09-24)

The full story-assembly flow now exists: **Postavy → Úkol → Problém →
Konec → Osnova**, routed with `go_router` (`lib/main.dart`), state
accumulated in `storyDraftProvider` (`lib/story/story_draft.dart`) so
popping back doesn't lose later choices. Task/problem/ending share one
generic `MotifPickerScreen` (`lib/motifs/`) — pick 1 of 3 shown, or
shuffle for 3 new ones; no per-card reroll or add/remove there, those
stay singular regardless of cast size (§1.1a). `OsnovaScreen`
(`lib/story/`) shows the assembled result and a `Vyprávím →` button
that's honest about not being built yet (shows a SnackBar, not a fake
success).

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

8 widget tests total (5 cast-composer + 3 full-flow/shuffle/reset).
One real bug worth knowing if you touch `main.dart`: a top-level
`final router = GoRouter(...)` is a module-level singleton in Dart — it
survives across separate `pumpWidget()` calls in different tests (same
isolate), so one test's navigation state leaks into the next. Fixed by
building the router inside `StorytellerApp`'s `State` (`late final`),
so each widget-tree instance gets its own; production still only ever
creates one `StorytellerApp` element, so this changes nothing there.

## Not started

Globe (§1.1b — the plan's own recommended *first* screen, still not
built), Vyprávím (live narration), Knihovna, Nastavení, any real
network call (`gateway/cmd/server` exists and works — this app doesn't
call it yet), `AssetResolver`, audio (`record`/`just_audio`).

## Running it

```sh
flutter pub get
flutter test            # 5 tests, no device needed
flutter run              # needs a connected device or simulator
```
