# comfy

Go client for ComfyUI's HTTP API: load a workflow (`comfy/workflows/`
convention, see `comfy/README.md`), inject values by node title,
submit, poll, download. Used by the (not yet written) media-orchestrator
to render MODELS_PLAN tiers.

## Status (2026-09-24)

Written and unit-tested against an in-process mock HTTP server
(`httptest`), 17 tests. **Never run against a real ComfyUI instance** —
`comfyui.ol1n.com` (the instance named in STORYTELLER_PLAN.md §2) is
network-reachable but returns 403 (gated, no credentials available
here). The request/response shapes assumed (`/prompt`, `/history/{id}`,
`/view`, `/upload/image`) are ComfyUI's documented API, not guessed,
but "documented" isn't "verified live" — treat the first real run as a
integration smoke test, not a formality.

Also blocked on there being no real workflow JSON yet:
`comfy/workflows/flux-schnell/txt2img.json` doesn't exist. It has to
come from exporting the actual graph in Spark's ComfyUI (API format,
"Save (API Format)"), with its nodes titled per the `IN_*` convention —
this package can't produce that file, only consume it.

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

## Manual smoke test, once there's access

```sh
go run ./internal/comfy/cmd/render-smoke \
  -url http://spark.local:8188 -model-dir comfy/workflows/flux-schnell \
  -prompt "a fox in a forest, soft watercolor illustration" -out /tmp/out.png
```

Run this — and actually open `/tmp/out.png` and look at it — before
trusting any automated stage built on top of `internal/comfy`. It only
needs a reachable ComfyUI URL and a real exported `txt2img.json`;
nothing else in the repo has to be ready first.
