# contentkey

Content addressing for every generatable artefact — OFFLINE_PLAN §0.1/§2.5
as split by MODELS_PLAN §0.1:

```
key_base = sha256(kind, lang, normalized_inputs)           ← the content ("what")
key      = sha256(key_base, model_id, style_id, model_ver)  ← one variant ("how")
seed     = first 8 bytes of key_base, 63-bit               ← shared by all variants
```

`key` names a row in `asset_variants`, a CDN path
(`assets/{kind}/{key[0:2]}/{key}.ext`), a device cache entry, and a
`misses`/`jobs` row. `key_base` groups every rendering of the same
content so the resolver can pick the best available tier, and the seed
being shared is what lets a tier-1 render start from the same noise as
its tier-0 reference.

Two implementations, one contract:

| | |
|---|---|
| Go | this package — gateway, nightly pipeline, orchestrator |
| Dart | `app/packages/content_key` — the Flutter `AssetResolver` |
| Contract | `testdata/golden.json` — both suites assert every case byte-for-byte (base preimage, key_base, variant preimage, key, seed) |

The canonical format is spelled out in `contentkey.go`'s package doc.
The short version of *why it's hand-rolled* instead of `encoding/json` /
`jsonEncode`: the two languages disagree on HTML escaping (`<>&`), float
formatting (`1` vs `1.0`), whitespace classes, and map-key sort order
outside ASCII. So the format forbids the ambiguous cases (ASCII
`[a-z0-9_]` keys, integers only, explicit whitespace set) and both sides
write the bytes themselves.

Retries don't touch the key: a degraded render is re-done under the same
`key` with seed `Seed(key_base)+attempt` chosen by the orchestrator.

## History

- **v2** (2026-09-24) — base/variant split. v1 (single flat key with a
  `variant int`) was never persisted anywhere, so there is no migration.

## Changing the format

1. Bump `baseVersion` / `variantVersion` (`…/v2` → `…/v3`) in **both**
   implementations. Old keys stay valid forever — old assets don't need
   regenerating, they just stop being found for new requests, exactly
   like a `model_ver` bump.
2. `go test ./internal/contentkey -update` regenerates `golden.json`.
3. `cd app/packages/content_key && dart test` must go green without any
   Dart change other than the version strings. If it doesn't, the Dart
   port has diverged — fix that, don't edit the golden file by hand.

## Running the tests

```sh
go test ./internal/contentkey
cd app/packages/content_key && dart pub get && dart test
```
