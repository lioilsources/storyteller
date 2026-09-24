# comfy

ComfyUI workflows, style presets, and the bench script — the "models
and styles are data, not code" half of STORYTELLER_MODELS_PLAN.md (§0.4,
§6). The other half is the `models` / `styles` registry in Postgres
(`infra/migrations/0003_models.up.sql`, seeded by
`infra/seed/models_styles.sql`).

## Layout

```
comfy/
  workflows/{model_id}/txt2img.json    # ComfyUI *API format* export
  workflows/{model_id}/ref2img.json    # inputs: prompt, negative, ref_image, ref_strength, char_ref[], seed
  workflows/{model_id}/i2v.json        # inputs: image, motion_prompt, seconds, seed
  workflows/{model_id}/inputs.json     # logical input → (node title, input field), see below
  styles/{style_id}.yaml               # editable source for one `styles` row
  bench/                               # measures cost_sec per model on GB10 → registry
```

`{model_id}` matches `models.id` exactly (`flux-schnell`, `flux-dev`,
`sdxl-lora`, …).

| model | status | txt2img | verified live |
|---|---|---|---|
| `flux-schnell` | shadow (tier 0) | **N/A — not a ComfyUI checkpoint** | — |
| `flux-dev` | shadow (tier 1) | `flux-dev/txt2img.json` | ✅ 2026-09-24, real render, LAN ComfyUI |
| `sdxl-lora` | shadow (tier 1s) | none yet | — |

Nothing here is fabricated: a workflow JSON only lands in this directory
once it has actually been run against a real ComfyUI and produced a
real image.

**Real finding, 2026-09-24 (see the conversation, not just this file):**
this repo's assumption that tier 0 = flux-schnell served by ComfyUI is
wrong for the actual Spark instance (`http://192.168.88.66:8188` on the
LAN, no auth — confirmed live). `GET /object_info/UNETLoader` lists
`flux1-dev.safetensors` and `flux1-dev-kontext_fp8_scaled.safetensors`
but no schnell checkpoint; flux-schnell is served only through
AiStack's NIM pass-through (a different HTTP contract, not ComfyUI's
`/prompt`/`/history`/`/view`). `flux-dev/txt2img.json` (adapted from
`Kiran/pipeline/internal/comfyuiimage/workflows/flux_sprite.json`, a
working sibling-project workflow) was run for real and produced a
correct watercolor illustration — but at 20 steps, ~45s, nowhere near
the "1-2s tier 0" the plans assume. A real tier-0 fast path still needs
either a NIM HTTP client (new, not `internal/comfy`) or a lower-step
ComfyUI config once/if a schnell checkpoint is placed on Spark.

## Input-node convention

Every workflow exposes the same *logical* inputs so the orchestrator
can fill any model's workflow with one generic injector and adding a
model never touches Go (MODELS_PLAN §6):

| logical input | meaning |
|---|---|
| `prompt` | positive prompt (style prefix/suffix already applied) |
| `negative` | negative prompt |
| `seed` | `contentkey.Seed(key_base)` — same for every tier of the same content |
| `ref_image` | tier-0 reference (ref2img / i2v only) |
| `ref_strength` | `styles.ref_strength` (ref2img only) |
| `char_ref_1..n` | character portrait references from the country pack |
| `lora_name`, `lora_strength` | from `styles.lora_path` / `lora_strength` (LoRA-driven models only) |
| `motion_prompt`, `seconds` | i2v only |
| `width`, `height` | output size |

In the workflow itself, the node that receives each input carries the
title `IN_<LOGICAL_NAME_UPPERCASED>` (`IN_PROMPT`, `IN_SEED`,
`IN_REF_IMAGE`…). Because the *field* that must be set differs per node
type (`CLIPTextEncode.text`, `KSampler.seed`, `LoadImage.image`,
`IPAdapterAdvanced.weight`…), each workflow ships a sidecar
`inputs.json` naming the field:

```json
{
  "prompt":       {"node": "IN_PROMPT",       "field": "text"},
  "negative":     {"node": "IN_NEGATIVE",     "field": "text"},
  "seed":         {"node": "IN_SEED",         "field": "seed"},
  "ref_image":    {"node": "IN_REF_IMAGE",    "field": "image"},
  "ref_strength": {"node": "IN_REF_STRENGTH", "field": "weight"}
}
```

Titles survive ComfyUI's API-format export as `_meta.title`; arbitrary
extra `_meta` keys don't, which is why the mapping lives next to the
file instead of inside it. The injector — **`internal/comfy`, written
and tested against a mock ComfyUI server, never against a real one** —
loads the workflow (`comfy.LoadStage`), resolves each logical input
through `inputs.json`, finds the node by `_meta.title`
(`comfy.Inject`), sets `inputs[field]`, and fails loudly on any input
the workflow doesn't declare. `comfy.Client` submits (`POST /prompt`),
polls (`GET /history/{id}`), downloads (`GET /view`), and uploads
reference images (`POST /upload/image`) for ref2img/character
consistency; `comfy.Render` chains all of that into one call. See
`internal/comfy`'s tests for exact request/response shapes assumed —
those are ComfyUI's documented API, not guessed, but have never been
checked against a live instance.

## Versioning

`models.version` identifies exactly which workflow rendered an asset.
It's part of every variant key (`internal/contentkey`), so editing a
workflow rolls all of that model's keys forward — old assets stay
valid, they just stop being found for new requests. The plan's original
idea was the git hash of the workflow directory; `flux-dev`'s seed row
instead uses `sha256(txt2img.json)[:12]` (simpler to compute by hand
right now, same effect — a stable value that changes iff the file
does). Update the registry row when you change a workflow; the
`bench/` script will do this automatically once it exists — pick
whichever scheme it implements and make both consistent.

## Styles

`styles/{style_id}.yaml` is meant to be the human-edited source for the
`styles` table (prompt prefix/suffix, negative, LoRA, ref_strength,
preferred model). Until a loader exists, the truth is the seed SQL —
keep them in sync by hand, or just edit the SQL.
