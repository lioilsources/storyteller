# contentkey

`key = sha256(kind, model_ver, style, lang, normalized_inputs, variant)`,
`seed = first 8 bytes of key` — STORYTELLER_OFFLINE_PLAN.md §0.1 / §2.5.
Every generatable artefact (image, sound, hint, translation, outline…)
is addressed by this key on device, on the CDN, in `assets`/`misses`/
`jobs`, and in ComfyUI/vLLM seeds.

Two implementations, one contract:

| | |
|---|---|
| Go | this package — used by gateway and the nightly pipeline |
| Dart | `app/packages/content_key` — used by the Flutter `AssetResolver` |
| Contract | `testdata/golden.json` — both test suites assert every case byte-for-byte (preimage, key, seed) |

The canonical format is spelled out in `contentkey.go`'s package doc.
The short version of *why it's hand-rolled* instead of `encoding/json` /
`jsonEncode`: the two languages disagree on HTML escaping (`<>&`), float
formatting (`1` vs `1.0`), whitespace classes, and map-key sort order
outside ASCII. So the format forbids the ambiguous cases (ASCII
`[a-z0-9_]` keys, integers only, explicit whitespace set) and both sides
write the bytes themselves.

## Changing the format

1. Bump `version` (`storyteller-content-key/v1` → `v2`) in **both** files.
   Old keys stay valid forever — old assets don't need regenerating,
   they just stop being found for new requests, exactly like a
   `model_ver` bump.
2. `go test ./internal/contentkey -update` regenerates `golden.json`.
3. `cd app/packages/content_key && dart test` must go green without any
   Dart change other than the version string. If it doesn't, the Dart
   port has diverged — fix that, don't edit the golden file by hand.

## Running the tests

```sh
go test ./internal/contentkey
cd app/packages/content_key && dart pub get && dart test
```
