# comfy

Go client for ComfyUI's HTTP API: load a workflow (`comfy/workflows/`
convention, see `comfy/README.md`), inject values by node title,
submit, poll, download. Used by the (not yet written) media-orchestrator
to render MODELS_PLAN tiers.

## Status (2026-09-24)

**Verified live.** `comfyui.ol1n.com` (STORYTELLER_PLAN.md §2) returns
403 from here (Cloudflare Access-gated, no credentials touched), but
the same ComfyUI is also reachable directly on the LAN at
`http://192.168.88.66:8188` with **zero auth** — confirmed via
`/system_stats`. `cmd/render-smoke` ran a real `flux-dev` txt2img
(`comfy/workflows/flux-dev/`, adapted from a working sibling-project
workflow — see `comfy/README.md`) end to end: submit → poll → download
→ a correct 1024×1024 watercolor illustration, ~45s. 17 unit tests
against a mock server still pass unchanged; this was the first time any
of it touched a real server, and it worked without modification.

**Real finding:** flux-schnell (the plans' assumed tier 0) is not a
ComfyUI checkpoint on this Spark instance — only flux-dev and
flux-dev-kontext are (`GET /object_info/UNETLoader`). flux-schnell is
served via AiStack's NIM pass-through instead, a different HTTP
contract this package doesn't implement. See `comfy/README.md` for the
full note. `flux-dev` at 20 steps (~45s) is not the plans' "1-2s tier 0"
either — it's a real tier-1 render, useful for testing the pipeline,
not yet a fast reference.

## API surface

```go
wf, inputMap, err := comfy.LoadStage("comfy/workflows/flux-schnell", "txt2img")
client := comfy.NewClient("http://spark.local:8188")
img, err := comfy.Render(ctx, client, wf, inputMap, map[string]any{
    "prompt":   style.PromptPrefix + scenePrompt.TextEN + style.PromptSuffix,
    "negative": style.Negative,
    "seed":     contentkey.Seed(keyBase), // same seed for every tier of this content
}, comfy.RenderOpts{Timeout: 30 * time.Second}) // MODELS_PLAN tier 0 ≈ 1-2s; leave headroom
```

For ref2img (tier 1/1s, character consistency — MODELS_PLAN §2):
`client.UploadImage(ctx, "fox-ref.png", refBytes)` first, then pass the
returned server-side filename as `values["ref_image"]`.

## Manual smoke test — already run, reuse this exact command

```sh
go run ./internal/comfy/cmd/render-smoke \
  -url http://192.168.88.66:8188 -model-dir comfy/workflows/flux-dev \
  -prompt "soft watercolor children's book illustration of a clever fox standing at the edge of a misty forest at dawn, gentle wet-on-wet washes, warm light, simple shapes" \
  -negative "scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs" \
  -seed 42 -timeout 90s -out /tmp/storyteller-smoke.png
```

Ran 2026-09-24: 1024×1024 PNG, 1.3MB, ~45s, looked correct on
inspection. `192.168.88.66` is Spark's current LAN IP (DHCP-looking,
not a stable DNS name — re-verify with `curl .../system_stats` if this
stops working). Off-LAN, go through `https://comfyui.ol1n.com` instead
with `CF-Access-Client-Id`/`CF-Access-Client-Secret` headers (see
`Ol1nLLM/backend/comfyui/README.md` for the exact CF Access setup — its
credentials weren't read or used for this).
