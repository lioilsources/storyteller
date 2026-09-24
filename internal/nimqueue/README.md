# nimqueue

Go client for AiStack's **gen-queue** — the async job queue in front of
the NVIDIA NIM image containers on Spark (flux-schnell, flux-kontext).
This is the real tier-0 path (MODELS_PLAN §1): flux-schnell, ~2-4s
end to end, verified live.

## Status (2026-09-24) — verified live, not just tested against a mock

Full submit → poll → download cycle run for real from this Mac against
`http://192.168.88.66:8091` (gen-queue, published `0.0.0.0:8091` on
Spark's LAN, **no auth needed** — same pattern as `ai-gateway:8080`
and ComfyUI:8188). A watercolor fox prompt came back **done in ~2
seconds** (one poll at a 2s interval), 324KB image, genuinely good
quality. 12 unit tests pass against a mock server built from the same
verified contract.

## Why this exists instead of extending internal/comfy

gen-queue is a completely different protocol from ComfyUI's node-graph
`/prompt` API: submit returns `202` + a job id immediately, the actual
NIM inference happens server-side, and the client polls
`GET /nim/{model}/jobs/{id}` until `done`/`error`, then downloads via
`GET /nim/{model}/jobs/{id}/result`. It exists specifically to dodge
Cloudflare's 100s edge timeout and survive iOS app suspension — see
`AiStack/services/gen-queue`. Protocol reverse-engineered by reading
Ol1nLLM's `lib/services/flux_nim_service.dart` and
`lib/services/flux_kontext_nim_service.dart` (the same client the
production Flutter app uses) plus gen-queue's own Go source
(`AiStack/services/gen-queue/internal/api/handlers.go`,
`internal/backend/backend.go`).

## Real finding: flux-dev is not in this queue

`gen-queue`'s router only registers `/nim/flux-schnell/...` and
`/nim/flux-kontext/...` (`handlers.go:26-32`) — **not** flux-dev. So
`nimqueue.Model` only has two values, deliberately. flux-dev keeps
working through `internal/comfy` against Spark's own ComfyUI instead
(slower — ~45s at 20 steps — but it's the only path that actually
exists for it). Attempting to run flux-dev as a third NIM container
alongside translate hung twice in a row on this Spark box (silent after
finishing its file cache checks, 0% GPU, no error) — abandoned in
favor of this: flux-schnell via gen-queue is both the properly-wired
path *and* the actual "tier 0, fast" role MODELS_PLAN wants.

## Auth

None needed for the LAN path used above. `CFAccessClientID`/
`CFAccessClientSecret` on `Client` exist for the public route
(`https://llm.ol1n.com/nim/...`, Cloudflare Access-gated) — set both or
neither; this session never touched those credentials.

## Gotcha: the result is JPEG bytes with a PNG content-type header

`GET .../result` sets `Content-Type: image/png` but the bytes are a
real JPEG (verified: magic bytes checked, `file` agrees) — this matches
a note in Ol1nLLM's own `CLAUDE.md`. `Result()` returns raw bytes and
does not try to "fix" this; don't trust the header, don't assume `.png`
means PNG anywhere in this pipeline.

## Usage

```go
c := nimqueue.NewClient("http://192.168.88.66:8091") // LAN, verified
img, err := c.GenerateSchnell(ctx, nimqueue.SchnellRequest{
    Prompt: "soft watercolor illustration of a fox in a forest",
    Width: 1024, Height: 1024, Steps: 4,
    Seed: contentkey.Seed(keyBase), // same seed as every other tier
})
```
