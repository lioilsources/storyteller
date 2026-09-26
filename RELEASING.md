# Releasing

Test builds go out through the shared CI/CD template in
**`/Volumes/YOTTA/Dev/Distribution`** — that repo is the source of truth, not
this file. iOS → TestFlight, Android → Firebase App Distribution, both driven by
a `v*` tag.

- `Distribution/SKILL.md` — the full new-app procedure, step by step
- `Distribution/CLAUDE.md` — the signing/secret traps that cost real time
- `Distribution/workflows/` — golden workflow templates (edit bugs **there**)
- `Distribution/scripts/{align-project.sh,setup-gh-secrets.sh}`

This file only records what is specific to Storyteller.

## Status (2026-09-26)

An earlier version of this section claimed the repo had no GitHub remote and
that nothing here had ever run. **That was wrong when it was written** — it was
carried over from a template and never checked against `git remote -v`. The real
state:

| Workflow | Runs | State |
|---|---|---|
| `release-ios.yml` | 3 | **Working.** Builds 1.0.0+2 and 1.0.0+3 uploaded to TestFlight (2026-09-25, `No errors uploading archive`). The first run failed on `pod install` with no Podfile; fixed. |
| `ci.yml` | 4 | **Working since 2026-09-26.** The first three failed: `flutter analyze` walks `app/packages/*` but `flutter pub get` in `app/` does not resolve them, and the golden screenshot tests compare pixels against a developer Mac. |
| `release-android.yml` | 2 | **Failing.** See below. |

The repo is `lioilsources/storyteller` (private), remote `origin`, default branch
`master`. All 15 secrets `setup-gh-secrets.sh` sets are in place (2026-09-25
12:01).

Build numbers come from `github.run_number`, not from `pubspec.yaml` — the
workflow rewrites `version:` before archiving, so the `+1` committed in
`pubspec.yaml` never reaches TestFlight and duplicate-build rejections can't
happen.

### What is still blocked

**Android / Firebase.** Both runs failed and will keep failing: the two Firebase
secrets are missing and nothing has been created on the Firebase side.
`setup-gh-secrets.sh` does **not** set these two — they are step 4 in
Distribution's `SKILL.md` and have to be done by hand:

```sh
gh secret set FIREBASE_ANDROID_APP_ID --repo lioilsources/storyteller --body "1:xxx:android:xxx"
gh secret set FIREBASE_SERVICE_ACCOUNT_KEY --repo lioilsources/storyteller < service-account.json
```

before which you need, in the Firebase console: an Android app with package name
`com.ol1n.storyteller`, its `google-services.json` saved to
`app/android/app/`, and a service account with the *Firebase App Distribution
Admin* role. The golden template also hardcodes the tester group alias `Alfa`;
it must exist under that exact alias or the upload is an HTTP 400.

**Local iOS release builds.** Still unverified, and expected to fail: the
Release config is Manual signing with a `CI_PROFILE_NAME` placeholder that only
CI substitutes. `flutter run` and `flutter build apk --debug` are unaffected
(Debug/Profile are Automatic). See "Open conflict: iOS signing style" below.

## Identity

| | |
|---|---|
| iOS bundle id | `com.ol1n.storyteller` |
| Android `applicationId` | `com.ol1n.storyteller` |
| Android `namespace` | `com.lioilsources.storyteller` (unchanged — see below) |
| Apple Team ID | `P82HWPG7FN` (already in `project.pbxproj`) |
| Distribution folder key | `Storyteller` |
| Repo (planned) | `lioilsources/storyteller` |
| Flutter | 3.44.4 / Dart 3.12.2 |

The bundle id **was changed** as part of this setup: the Flutter project was on
`com.lioilsources.storyteller`, which is not the `com.ol1n.<appname>` convention
every Distribution script and doc assumes. Nothing is published anywhere yet, so
renaming was free. `namespace` deliberately stayed on the old value: it is the
Kotlin package `MainActivity` actually lives in
(`app/android/app/src/main/kotlin/com/lioilsources/storyteller/`), and the
manifest's `.MainActivity` resolves against it. Only `applicationId` — what Play
and Firebase see — follows the convention.

## Step 0 — create the remote (nothing below works without it)

```sh
cd /Volumes/YOTTA/Dev/storyteller
gh repo create lioilsources/storyteller --private --source=. --remote=origin
# or, if the repo already exists on GitHub:
# git remote add origin git@github.com:lioilsources/storyteller.git
git push -u origin master
```

Note the branch is `master`, not `main`. `ci.yml` triggers on `branches: ['**']`
so that is fine, but `Distribution/SKILL.md` step 8 says `git push origin main`.

## Step 1 — manual console setup (only these are left)

Details and screenshots-worth-of-detail: `Distribution/SKILL.md` steps 1–3.
What this app needs, with its own values:

**Apple Developer** — App ID `com.ol1n.storyteller` (Explicit), then an App
Store distribution provisioning profile for it. Save the download to:

```
/Volumes/YOTTA/Dev/Distribution/Apple/Storyteller/<anything>.mobileprovision
```

`setup-gh-secrets.sh` reads it from exactly that path. The iOS distribution
certificate and the App Store Connect API key are already shared across all
apps — nothing to create.

**App Store Connect** — My Apps → `+` → New App, platform iOS, bundle id
`com.ol1n.storyteller` from the dropdown, SKU `ol1nstoryteller`. Without the app
record the TestFlight upload fails with *"Cannot determine the Apple ID from
Bundle ID"* even though build and signing succeeded.

**Google Play** — create the app, then build and upload the first AAB **by
hand**; Play refuses API/CI uploads until one manual release exists.

```sh
cd /Volumes/YOTTA/Dev/storyteller/app && flutter build appbundle --release
```

That local build is unsigned-for-upload until a keystore exists (step 2 creates
it), so run it after step 2 or it will be debug-signed and Play will reject it.

**Firebase** — add an Android app with package name `com.ol1n.storyteller`, then
place two files where the secrets script looks for them:

```
Distribution/Android/Storyteller/google-services.json          ← app id lookup
Distribution/Android/_GoogleConsole/Firebase/<project>-*.json  ← service account
```

and a copy of `google-services.json` into `app/android/app/`. The service
account must be the Firebase one (`firebase-adminsdk-…`), **not** the Google
Play publisher SA — the latter has no App Distribution permission and CI dies
with HTTP 403. It needs the *Firebase App Distribution Admin* role
(`roles/firebaseappdistro.admin`).

**Firebase tester group** — `release-android.yml` uploads to the group alias
`Alfa` (hardcoded in the golden template). Create that group, by that exact
alias — it is case-sensitive and it is the alias, not the display name. A
missing group is an HTTP 400 at upload time.

## Step 2 — the two scripts

`align-project.sh` **is already done** — it was run for this repo with:

```sh
/Volumes/YOTTA/Dev/Distribution/scripts/align-project.sh \
  --target /Volumes/YOTTA/Dev/storyteller \
  --app-dir app \
  --app-name Storyteller \
  --bundle-id com.ol1n.storyteller \
  --repo lioilsources/storyteller
```

Re-run it (with `--dry-run` first) after any fix lands in
`Distribution/workflows/`. It will report a diff on `ci.yml` and on the two
release workflows' header comments — see "Local deviations" below.

Then the secrets, which is the only step left that touches credentials:

```sh
export BW_SESSION=$(bw unlock --raw)          # export, not just set
/Volumes/YOTTA/Dev/Distribution/scripts/setup-gh-secrets.sh \
  --repo lioilsources/storyteller \
  --app Storyteller \
  --bundle-id com.ol1n.storyteller
```

Pass `--bundle-id` explicitly: without it the script defaults to
`com.ol1n.${APP_NAME}` = `com.ol1n.Storyteller` (capital S) when matching
`google-services.json`. It has a case-insensitive fallback, so it would probably
still find the Firebase app id — but do not rely on that.

There is **no `keytool` step to run by hand**. The script generates
`Distribution/Android/Storyteller/upload-keystore.jks` itself, stores the
password in Bitwarden as item `Storyteller Android Signing`, and uploads the
base64. Commit the generated keystore in the Distribution repo afterwards and
**never delete it** — Play requires the same upload key for every future update.

## GitHub secrets

Set by `setup-gh-secrets.sh`; these are the exact names, read out of the script.

| Secret | Read by | Source |
|---|---|---|
| `IOS_P12_BASE64` | release-ios | Bitwarden note `CI / IOS_P12_BASE64` (shared) |
| `IOS_P12_PASSWORD` | release-ios | Bitwarden `CI / IOS_P12_PASSWORD` |
| `IOS_KEYCHAIN_PASSWORD` | release-ios | Bitwarden `CI / IOS_KEYCHAIN_PASSWORD` |
| `IOS_TEAM_ID` | release-ios | Bitwarden `CI / IOS_TEAM_ID` |
| `IOS_PROVISION_PROFILE_BASE64` | release-ios | `Apple/Storyteller/*.mobileprovision` |
| `APP_STORE_CONNECT_API_KEY_ID` | release-ios | Bitwarden `CI / ASC_API_KEY_ID` |
| `APP_STORE_CONNECT_API_ISSUER_ID` | release-ios | Bitwarden `CI / ASC_API_ISSUER_ID`, with a hardcoded fallback in the script |
| `APP_STORE_CONNECT_API_KEY_BASE64` | release-ios | base64 of `Apple/_Keys/AuthKey_*.p8` |
| `ANDROID_KEYSTORE_BASE64` | release-android | `Android/Storyteller/upload-keystore.jks` |
| `ANDROID_KEYSTORE_PASSWORD` | release-android | Bitwarden `Storyteller Android Signing` |
| `ANDROID_KEY_ALIAS` | release-android | `upload` |
| `ANDROID_KEY_PASSWORD` | release-android | same as the keystore password |
| `FIREBASE_ANDROID_APP_ID` | release-android | `mobilesdk_app_id` from `google-services.json` |
| `FIREBASE_SERVICE_ACCOUNT_KEY` | release-android | `Android/_GoogleConsole/Firebase/*.json` |

The script also sets three older aliases — `APPSTORE_ISSUER_ID`,
`APPSTORE_API_KEY_ID`, `APPSTORE_API_PRIVATE_KEY` — that **no workflow in this
repo reads**. Harmless; do not wire anything new to them.

`ci.yml` needs no secrets at all.

## Releasing

```sh
git tag v0.1.0-alpha
git push origin v0.1.0-alpha
```

Both release workflows also have `workflow_dispatch`. Any tag matching `v*`
starts iOS and Android in parallel; whichever reaches the GitHub Release step
second fails with `already_exists`, which is why the Android job has
`continue-on-error: true` there.

Results land in App Store Connect → TestFlight (processing 10–30 min), Firebase
Console → App Distribution → Releases, and the repo's Releases page.

## Local deviations from the golden templates

Worth knowing, because `align-project.sh` will want to overwrite them:

- **`ci.yml` is hand-adapted.** Flutter is pinned to `3.44.x`, not golden's
  `3.41.x` — `app/pubspec.yaml` requires Dart `^3.12.2`, so `flutter pub get`
  simply fails on 3.41. It also gains a `go` job (`go build ./...`,
  `go test ./...`) because this repo is not Flutter-only. The Python package in
  `rag/` is **not** in CI: its tests want an editable install in `rag/.venv`,
  which CI does not have, and a job that cannot pass is worse than an admitted
  gap. `rag/` tests stay local.
- **`ci.yml` also resolves and tests `app/packages/content_key` separately.**
  `flutter analyze` in `app/` walks the sibling packages but `flutter pub get`
  in `app/` does not resolve them, so the analyzer reported `test`/`expect` as
  undefined and reddened the first three runs. It passes locally only because a
  developer has run `pub get` in there at some point — which is exactly the
  class of bug CI exists to catch.
- **`ci.yml` excludes the golden screenshots** (`--exclude-tags screenshots`).
  They compare pixels against captures from a developer Mac, so a runner's Skia
  or font version fails them for a difference that is not a regression.
- **`release-android.yml` carries a local header comment** recording that it has
  failed both runs and why. `release-ios.yml`'s header was dropped once it
  shipped a build. Bodies are the golden templates verbatim apart from the
  `tyrian_mobile`→`app`, `Kiran`→`Storyteller`, `com.ol1n.kiran`→
  `com.ol1n.storyteller` substitutions; `align-project.sh --dry-run` reports the
  comment as a diff.
- **`app/android/app/build.gradle.kts` now reads `key.properties`.** The golden
  `release-android.yml` writes `android/key.properties` and
  `android/app/release.keystore` and then just calls
  `flutter build appbundle --release` — which silently produces **debug-signed**
  artifacts unless Gradle is wired to read that file. The Flutter template here
  was not wired (it had `signingConfig = signingConfigs.getByName("debug")` and a
  TODO). It is now, with a fallback to debug signing when `key.properties` is
  absent, so `flutter build apk --debug` and `flutter run` keep working with no
  keystore on the machine. This wiring is **not** installed by
  `align-project.sh`; check it survives any future re-align.

## Open conflict: iOS signing style

`Distribution/SKILL.md` step 4 and `Distribution/CLAUDE.md` disagree about how
iOS should be signed, and `align-project.sh` implements the older of the two.

What is in this repo now (what the script does): `project.pbxproj` Release config
carries `CODE_SIGN_STYLE = Manual`, `CODE_SIGN_IDENTITY = "Apple Distribution"`
and `PROVISIONING_PROFILE_SPECIFIER = "CI_PROFILE_NAME"`, a placeholder that CI
`sed`-replaces with the profile UUID.

`SKILL.md` step 4 calls that approach **abandoned** ("opuštěný") because the
placeholder breaks local builds — `"Runner" requires a provisioning profile` on
`flutter run --release` / `flutter build ipa` — and prescribes instead: leave
`CODE_SIGN_STYLE = Automatic` in the project, archive with
`CODE_SIGNING_ALLOWED=NO`, and sign only at export via `ExportOptions.plist`.
The script has a note admitting it "zatím generuje starý placeholder+sed
přístup".

Nothing was hand-fixed here, so this repo is on the older approach, consistent
with the golden workflow that pairs with it. Two consequences:

1. Local **release** iOS builds from this checkout will likely fail until either
   the real profile is installed or the config is switched to Automatic. Debug
   and Profile configs were set to `Automatic` + `Apple Development`, so
   `flutter run` and `flutter build apk --debug` are unaffected.
2. If the first CI run fails on `Pods-Runner does not support provisioning
   profiles` or `"Runner" requires a provisioning profile`, that is this known
   conflict — fix it in `Distribution/workflows/release-ios.yml` and
   `align-project.sh`, then re-align, rather than patching this repo alone.

## Other things align-project.sh changed here

- `app/ios/ExportOptions.plist` — created, with `REPLACE_WITH_YOUR_TEAM_ID` and
  `REPLACE_WITH_YOUR_ADHOC_PROFILE_NAME` placeholders. CI overwrites both with
  PlistBuddy at export time, so the placeholders are expected to stay in git.
- `app/ios/Runner/Info.plist` — `ITSAppUsesNonExemptEncryption = false`, so
  TestFlight stops asking about export compliance on every build. Flip it to
  `true` if real crypto is ever added.
