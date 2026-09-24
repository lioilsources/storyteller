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

## Not started

Everything else: globe (§1.1b), daily offer / Dnes screen, Vyprávím
(live narration), Knihovna, Nastavení, go_router, any real network call
(`gateway/cmd/server` exists and works — this app doesn't call it yet),
`AssetResolver`, audio (`record`/`just_audio`).

## Running it

```sh
flutter pub get
flutter test            # 5 tests, no device needed
flutter run              # needs a connected device or simulator
```
