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

## flux-schnell v ComfyUI (30. 9., Ol1nLLM `feat/comfy-flux-schnell`, model `flux-schnell-comfy`)

20 postav, pixar-3d, DINO k dnešní kartě (brána 0,80):

| varianta | DINO ø | nad branou |
|---|---|---|
| img2img 0,5 / 0,65 / 0,8 | 0,96 / 0,95 / 0,92 | 100 % |
| img2img 0,85–1,0 | 0,63 | 15 % — pixelově totéž, reference zahozena |
| txt2img + hloubkový ControlNet 0,4 / 0,55 / 0,7 | 0,80 / 0,79 / 0,77 | 65 / 60 / 55 % |
| txt2img (pro srovnání NIM 0,66 / 20 %) | 0,63 | 15 % |

- **Se 4 kroky jde denoise nastavit jen skokově**: ComfyUI natáhne rozvrh na `int(4/denoise)` kroků a pustí
  poslední 4, takže 0,85–1,0 = plné přemalování. Mezistupně jen s víc kroky (např. 12).
- img2img drží postavu, ale Pixar přebírá málo; hloubkový ControlNet drží siluetu a Pixar pouští naplno.
- NIM vs ComfyUI: jiný počáteční šum při stejném seedu (jiná kompozice) a NIM běží jako TensorRT FP4
  (`gb10x1-fp4-fp8`), ComfyUI bf16→fp8 — „hladší“ Pixar look z NIM je zčásti FP4 kvantizace.

## Rodina SDXL / Illustrious / Pony (30. 9.–1. 10., 9 modelů × 8 postav)

Podíl postav nad branou DINO 0,80 (Lustify a WAI jen na 4 postavách, které nejsou lidé):

| model | txt2img (bez/akv/pixar/LoRA) | img2img (bez/akv/pixar/LoRA) | repose (bez/akv/pixar/LoRA) |
|---|---|---|---|
| CyberRealistic | 0/0/0/25 | 100/100/100/75 | 62/75/50/50 |
| RealVis | 0/12/25/12 | 100/88/88/75 | 75/62/50/50 |
| Lustify | 0/0/0/0 | 100/100/100/75 | 50/75/25/25 |
| Animagine | 0/0/12/0 | 100/88/88/100 | 75/88/75/75 |
| NoobAI | 0/0/0/0 | 100/75/100/100 | 62/50/62/75 |
| Hassaku | 0/0/0/0 | 100/88/100/100 | 75/62/62/75 |
| WAI | 25/25/0/0 | 100/75/50/50 | 75/75/50/50 |
| Pony | 0/0/0/0 | 100/100/100/100 | 50/50/50/88 |
| Atomix Pony | 0/0/0/0 | 100/75/75/62 | 50/75/50/38 |

Pixar LoRA: SDXL „Pixar Style (SDXL)“ (Civitai v211735, `pixar style`), Illustrious a Pony „Pixar 3D cinematic
style“ (v2179605 / v1905413). Bez reference (txt2img) neudrží postavu žádný SDXL model. Arch:
claude.ai/artifact/5SWKc9mm19SsHzuQfcDdJk. Verdikt podle pohledu doplní uživatel.
