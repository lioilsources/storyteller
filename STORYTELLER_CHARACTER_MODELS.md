# Postavy StoryTelleru v jiných modelech — výsledky labu

Výstup plánu `STORYTELLER_CHARACTER_MODELS_LAB_PLAN.md` (§4). Měřeno 29. 9. 2026 v labu Ol1nLLM
(`tools/lab`, větev `feat/lab-storyteller-characters`), archy v `Ol1nLLM/docs/sheets/storyteller-cast-wave-*.html`.

## Verdikt uživatele (30. 9. 2026) — použít pro tier 2 artworky

| styl | model | poznámka |
|---|---|---|
| **pixar-3d** | **flux-schnell** | nejlepší Pixar look; bez LoRA, jen stylový blok `pixar-3d` |
| **watercolor** | **juggernaut-xl** | |
| **baseline** (bez stylu) | **flux-manga** (= flux-dev tier 1) | |

Rozhodnuto pohledem do archů vln A a B, ne z metrik. Až se budou tvořit tier 2 artworky, tohle je
výchozí `preferred_model` per styl (`infra/seed/models_styles.sql`).

## Reference, nebo prompt? (vlna B, 20 postav, DINOv2 k dnešní kartě, brána ≥ 0,80)

| postup | flux-dev | Juggernaut | Illustrious | flux-schnell |
|---|---|---|---|---|
| img2img z reference, bez stylu | 90 % (0,89) | 90 % (0,88) | 85 % (0,88) | – |
| img2img, akvarel | 90 % (0,92) | 90 % (0,88) | 80 % (0,86) | – |
| img2img, pixar-3d | 90 % (0,87) | 80 % (0,86) | 75 % (0,86) | – |
| repose (ControlNet hloubka), bez stylu | 40 % | 50 % | 35 % | – |
| txt2img, stejný prompt a seed, bez stylu | 20 % (0,67) | 0 % | 0 % | 35 % |
| txt2img, akvarel | 15 % | 10 % | 0 % | 85 % (= dnešní tier 0) |
| txt2img, pixar-3d | 10 % | 5 % | 0 % | 20 % |

Procento = podíl postav nad bránou, v závorce průměrná podobnost.

- **Bez reference se postava nezachová**: jiný model pod stejným promptem a seedem nakreslí jinou postavu.
  Tier vyšší než 0 proto potřebuje `ref2img` (MODELS_PLAN §9 krok 3).
- **img2img z reference** (flux = Kontext, SDXL = img2img s presetovým denoise) drží postavu i při změně
  stylu. Vysoká shoda ale může znamenat i slabý přenos stylu, to rozhoduje pohled do archů (verdikt výše).
- Pixar od flux-schnell (verdikt) je **txt2img** — flux-schnell v labu nemá img2img, takže pixar tier 2
  z flux-schnell zatím postavu z tier 0 nedrží (20 % nad bránou). Při stavbě tier 2 to vyřešit: buď
  flux-schnell jako tier 0 rovnou v pixar stylu, nebo pixar přes Kontext/img2img jiného modelu.

## Otevřené

- Vlny C–E (Pixar LoRA, knoby) neproběhly — verdikt pixar-3d je bez LoRA.
- `ref2img` workflow ve `comfy/workflows/` zatím nevznikl.
