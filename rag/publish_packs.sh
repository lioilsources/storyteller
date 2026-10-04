#!/usr/bin/env bash
# Publish rag.pack_builder output (STORYTELLER_MONETIZATION_PLAN.md §6, §8.4):
#   release assets  → github.com/lioilsources/storyteller-content releases
#   manifest.json   → the same repo's GitHub Pages (docs/manifest.json)
#
# Run where `gh` is logged in (Mac). Idempotent: an existing release is
# reused and assets are replaced (--clobber) — safe because pack_builder
# only changes a zip's bytes together with its version, i.e. its name.
#
#   rag/publish_packs.sh rag/data/dist ~/src/storyteller-content
#
# free-v1 nese balíčky kontinentů (continent-<k>-free-v<n>.zip), včetně
# Evropy, kterou appka má v binárce (manifest "bundled": true, klient ji
# nestahuje; v release je pro budoucí aktualizace bez vydání appky).
# dist/bundle/ (Evropa jako .db pro binárku) jde jinam: release
# rag-packs-<lang>-N v lioilsources/storyteller, viz app/rag_packs.sha256.
set -euo pipefail
dist=${1:?dist dir from rag.pack_builder}
content=${2:?local checkout of lioilsources/storyteller-content}
repo=lioilsources/storyteller-content

for dir in "$dist"/free-v1 "$dist"/pack-*; do
  [ -d "$dir" ] || continue
  tag=$(basename "$dir")
  gh release view "$tag" -R "$repo" >/dev/null 2>&1 ||
    gh release create "$tag" -R "$repo" -t "$tag" -n "Storyteller content packs ($tag)"
  gh release upload "$tag" "$dir"/*.zip -R "$repo" --clobber
done

mkdir -p "$content/docs"
cp "$dist/manifest.json" "$content/docs/manifest.json"
git -C "$content" add docs/manifest.json
git -C "$content" diff --cached --quiet || git -C "$content" commit -m "manifest: $(date +%F)"
git -C "$content" push
