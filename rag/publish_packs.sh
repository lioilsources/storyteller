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
# nestahuje; v release je pro budoucí aktualizace bez vydání appky)
# a scénové balíčky (scenes-<cc>-v<n>.zip, „Česko – všechny scény“,
# ~270 MB — pod limitem 2 GB na asset release).
# dist/bundle/ (Evropa jako .db pro binárku) jde jinam: release
# rag-packs-<lang>-N v lioilsources/storyteller, viz app/rag_packs.sha256.
set -euo pipefail
dist=${1:?dist dir from rag.pack_builder}
content=${2:?local checkout of lioilsources/storyteller-content}
repo=lioilsources/storyteller-content

# Balíčky v2 (rag.region_packs, STORYTELLER_PACKS_V2_PLAN.md): free-v2 nese
# free desítky regionů (region-<k>-free-v<n>.zip), region-<k>-p<N>-v<n>
# placené díly; manifest.v4.json jde vedle manifest.json (ten dál čtou
# klienti do 1.6). dist/bundle/region.*.free.db + manifest.v4.json patří do
# release rag-packs-<lang>-N (binárka).
for dir in "$dist"/free-v1 "$dist"/pack-* "$dist"/free-v2 "$dist"/region-*; do
  [ -d "$dir" ] || continue
  tag=$(basename "$dir")
  gh release view "$tag" -R "$repo" >/dev/null 2>&1 ||
    gh release create "$tag" -R "$repo" -t "$tag" -n "Storyteller content packs ($tag)"
  gh release upload "$tag" "$dir"/*.zip -R "$repo" --clobber
done

mkdir -p "$content/docs"
for m in manifest.json manifest.v4.json; do
  [ -f "$dist/$m" ] || continue
  cp "$dist/$m" "$content/docs/$m"
  git -C "$content" add "docs/$m"
done
git -C "$content" diff --cached --quiet || git -C "$content" commit -m "manifest: $(date +%F)"
git -C "$content" push
