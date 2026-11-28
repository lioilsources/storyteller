# Anonymous usage statistics

Pohádkomat sends a small set of anonymous events through
[`ol1n_telemetry`](https://github.com/lioilsources/Ol1nTelemetry) so the
owner can see where new parents drop off before their first told tale, how
long the prompter is used, which helpers (hints, sounds, shuffles) anyone
uses, and where downloads and purchases fail. This file is the **event
dictionary**: the constant `appDictionary`
(`lib/telemetry/telemetry_dictionary.dart`) and this document list exactly
the same events and properties, and `test/telemetry_test.dart` fails when
they drift apart. The plan behind it is `Prompts/04-PLAN-analytika.md` in
DevConventions.

Adding an event or a property is a change to the privacy policy
(`store/pages/privacy.html`, published from `lioilsources/storyteller-content`)
and to the store privacy answers (`store/privacy_answers.md`). Ask the owner
first.

## Rules

The rules of `ol1n_telemetry` apply unchanged: no persistent identifier,
cohorts computed on the device, only enums, bands and numbers, no key → no
network, off wipes the queue at once. See the package README.

For this app in particular: **nothing about the tale**. No country, cast,
motif, hint text, sound name, nothing the parent types into "Co se zrovna
děje?" (only that the field was used at all), nothing about the child. The
region is one of the fifteen pack regions of the manifest.

The app is for parents and is not in the App Store Kids category or Google
Play Families (`store/app_review_metadata.md`, PACKS_V2 D4). If that ever
changes, measuring stops (plan §4.14) until the owner decides otherwise.

## Configuration

| `--dart-define` | Meaning |
|---|---|
| `TELEMETRY_KEY` | The app's key at the collector. Empty → nothing is sent. |
| `TELEMETRY_HOST` | The collector, `https` only. Empty → nothing is sent. |
| `TELEMETRY_DEBUG` | `true` prints events to the console instead of sending them. |

`release-ios.yml` and `release-android.yml` pass both from the GitHub
secrets of the same names; an absent secret makes a silent build. The key
and the collector's address never go into this public repository. Without a
key the "Nastavení" button on the globe (the on/off switch) is not shown.

Queue and counters live in `<application support>/telemetry/`
(`FileTelemetryStore`). `days_band` is `pre` when `content/`, `rag_packs/`
or `entitlements.json` already existed there at the first launch with
measuring: the app was used before.

`tester` is true in `STORYTELLER_UNLOCK_ALL` builds.

## Screens

go_router names each page `state.name ?? state.path`; the routes have no
names, so the observer maps route paths (`kScreenRoutes`). Bottom sheets
(stažené pohádky, nastavení) and dialogs do not change the screen.

| Route | Screen |
|---|---|
| `/globe` | `globe` |
| `/cast` | `cast` |
| `/task` | `task` |
| `/problem` | `problem` |
| `/ending` | `ending` |
| `/osnova` | `osnova` |
| `/vypravim` | `narrate` |

## Activation

The first tale told to the end: "Konec" on the last beat of the prompter
(`narrate_end` with `result: ok`). Once per install.

## Features

For `feature_use` and `feature_snapshot`: does an experienced parent use
them, or never find them?

| Feature | Used when |
|---|---|
| `globe_spin` | "Roztočit" on the globe |
| `landmark_tap` | a tap on a landmark or nature icon on the globe |
| `cast_reroll` | a cast card tapped for another character, or "Zamíchat vše" |
| `cast_resize` | a character added or removed |
| `motif_shuffle` | "Zamíchat" on the task, problem or ending picker |
| `hint` | "Napověz" / "Ještě jednu" in the prompter |
| `situation` | something typed into "Co se zrovna děje?" (never the text) |
| `music` | the background melody switched on or off |
| `sound_effect` | a character or event sound played |
| `storage` | "Stažené pohádky" opened |

## Common properties

Sent with every event.

| Property | Type | Values |
|---|---|---|
| `app_version` | enum | the app version (`kAppVersion`, checked against `pubspec.yaml`) |
| `platform` | enum | `ios`, `android`, `macos`, `windows`, `linux`, `other` |
| `lang` | enum | the app's language: `cs` (the app is Czech only) |
| `session_band` | band | session number: `1`, `2`, `3-5`, `6-10`, `11+` |
| `days_band` | band | days since measuring began: `0`, `1`, `2-6`, `7-29`, `30+`, `pre` |
| `first_session` | bool | the very first session of a new install |
| `tester` | bool | tester build or tester device |

## Events

### `app_open`

Cold start, or a new session after more than 30 minutes in the background.
Answers: what a new user does after the first launch (funnel start), and
whether they come back (2nd, 3rd, 6th, 11th session; day 1, 2, 7, 30).

| Property | Type | Values |
|---|---|---|
| `start` | enum | `cold`, `resume` |
| `session_band_first` | bool | the first session of this install in its `session_band` |
| `days_band_first` | bool | the first session of this install in its `days_band` |
| `campaign` | campaign | optional; QR campaign of a new install, `^[a-z0-9-]{1,24}$` (not sent by this app yet) |

### `screen_view`

A screen appeared. Answers: the path of the first session, and skipping
back and forth (A → B → A).

| Property | Type | Values |
|---|---|---|
| `screen` | enum | `globe`, `cast`, `task`, `problem`, `ending`, `osnova`, `narrate`, `other` |
| `prev` | enum | the previous screen, or `none` |

### `screen_leave`

A screen was left. Answers: how long on which screen (median, 90th
percentile), and screens with a long stay and no action.

| Property | Type | Values |
|---|---|---|
| `screen` | enum | as in `screen_view` |
| `secs` | int | foreground seconds on the screen |
| `actions` | int | app events, feature uses and locked taps during the stay |

### `session_pause`

The app went to the background or is closing. Sent at once. Answers: when
and where people stop.

| Property | Type | Values |
|---|---|---|
| `active_secs` | int | foreground seconds in this session |
| `screen` | enum | the screen at the time, or `none` |
| `screen_secs` | int | foreground seconds on that screen |

### `activation`

The first tale told to the end on this install (see Activation). Answers:
how many new installs get to the first real use, and how fast.

| Property | Type | Values |
|---|---|---|
| `secs` | int | seconds since this session's `app_open` |

### `feature_use`

The first use of a feature in a session. Answers: what experienced parents
use.

| Property | Type | Values |
|---|---|---|
| `feature` | enum | `globe_spin`, `landmark_tap`, `cast_reroll`, `cast_resize`, `motif_shuffle`, `hint`, `situation`, `music`, `sound_effect`, `storage` |

### `feature_snapshot`

After `app_open` of the 3rd, 6th and 11th session: which features this
install has ever used. Answers: what experienced parents never use.

| Property | Type | Values |
|---|---|---|
| `f_globe_spin` | bool | "Roztočit" used |
| `f_landmark_tap` | bool | a globe icon tapped |
| `f_cast_reroll` | bool | a character swapped |
| `f_cast_resize` | bool | a character added or removed |
| `f_motif_shuffle` | bool | a picker shuffled |
| `f_hint` | bool | a hint asked for |
| `f_situation` | bool | "Co se zrovna děje?" used |
| `f_music` | bool | the melody played |
| `f_sound_effect` | bool | a sound played |
| `f_storage` | bool | "Stažené pohádky" opened |
| `features_used` | int | how many of them |

### `error_shown`

The user saw an error. Answers: where an experienced parent struggles.

| Property | Type | Values |
|---|---|---|
| `kind` | enum | `globe_load` (the planet did not load), `offline` (a download without a connection), `download` (a download failed), `purchase` (the store said the purchase failed), `restore` (restoring purchases failed), `hint` (hint search failed) |
| `screen` | enum | the screen at the time, or `none` |

### `locked_tap`

A tap on something unavailable. Answers: where people want something the
app does not have.

| Property | Type | Values |
|---|---|---|
| `target` | enum | `country_empty`: the disabled "Vyprávět z …" of a grey country with no tales |

### `compose_start`

"Vyprávět z …" on the globe: a new story begins. Answers: the first-session
funnel (globe → story), and which traditions are picked.

| Property | Type | Values |
|---|---|---|
| `region` | enum | the pack region of the country: `czsk`, `dach`, `brit`, `frbx`, `iber`, `medi`, `nord`, `east`, `indi`, `easi`, `seao`, `meas`, `afri`, `namc`, `same`, or `other` |

### `compose_end`

The story was put together ("Vyprávím →" on the osnova, `ok`), dropped
("Znovu", or another country picked: `cancel`) or left in the background.
Answers: where in cast → task → problem → ending → osnova parents give up,
and how long putting a story together takes.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `cancel`, `error`, `background` |
| `secs` | int | foreground seconds |
| `step` | enum | the furthest step reached: `cast`, `task`, `problem`, `ending`, `osnova` |
| `cast` | int | characters in the story, once the cast was settled (else 0) |

### `narrate_start`

The prompter ("Vyprávíš") opened with a complete story. Answers: the
first-session funnel (story → telling).

| Property | Type | Values |
|---|---|---|
| `source` | enum | `pack` (motifs from the tale packs), `curated` (the built-in cards) |

### `narrate_end`

"Konec" on the last beat (`ok`, this is the activation), the prompter left
without it (`cancel`), or the app left in the background. Answers: whether
tales get told to the end, how long telling takes, and how much hints and
sounds are used while telling.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `cancel`, `error`, `background` |
| `secs` | int | foreground seconds |
| `beat` | int | the furthest beat reached, 1–4 |
| `hints` | int | hints shown |
| `sounds` | int | melody and sound taps |

### `hint_show`

A hint was shown. Answers: at which beat parents get stuck, and whether the
pack's hints or the generic ones carry the load.

| Property | Type | Values |
|---|---|---|
| `beat` | enum | `cast`, `task`, `problem`, `ending` |
| `source` | enum | `pack` (retrieved from the tale pack), `template` (generic), `fallback` (generic, because the pack had nothing) |

### `download_start`

A pack download began: a region's free tales, a bought part, or a
country's scenes. Answers: how many get more tales than the bundled ones.

| Property | Type | Values |
|---|---|---|
| `kind` | enum | `region_free`, `part`, `scenes` |
| `region` | enum | as in `compose_start` |

### `download_end`

The download ended. Answers: how often and how downloads fail, and how long
they take.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `cancel`, `error`, `background`, `offline` |
| `secs` | int | foreground seconds |

### `purchase_start`

"Koupit …" on the globe: the store's purchase sheet opens. Answers: how
many reach a purchase.

| Property | Type | Values |
|---|---|---|
| `region` | enum | as in `compose_start` |

### `purchase_end`

The store answered. Answers: how many purchases go through, are cancelled,
wait for approval (Ask to Buy) or fail.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `cancel`, `error`, `background`, `pending` |
| `secs` | int | foreground seconds |

### `purchase_restore`

"Obnovit nákupy" finished. Answers: whether restoring works for those who
need it.

| Property | Type | Values |
|---|---|---|
| `result` | enum | `ok`, `none` (nothing to restore), `error` |
| `parts` | int | parts restored |

## Reading the data

`store-metrics report pohadkomat` on the collector's host (plan §5.4).
Tester builds are left out of the default report.
