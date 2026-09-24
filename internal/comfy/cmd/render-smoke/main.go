// Command render-smoke does one manual end-to-end render against a
// real ComfyUI instance — the first thing to run once there's both a
// reachable ComfyUI URL and a real exported workflow (comfy/README.md),
// before trusting anything built on top of internal/comfy.
//
// Usage:
//
//	go run ./internal/comfy/cmd/render-smoke \
//	  -url http://spark.local:8188 -model-dir comfy/workflows/flux-schnell \
//	  -prompt "a fox in a forest, soft watercolor illustration" -out /tmp/out.png
package main

import (
	"context"
	"flag"
	"log"
	"os"
	"time"

	"github.com/lioilsources/storyteller/internal/comfy"
)

func main() {
	url := flag.String("url", "", "ComfyUI base URL, e.g. http://spark.local:8188")
	modelDir := flag.String("model-dir", "comfy/workflows/flux-schnell", "directory holding <stage>.json + inputs.json")
	stage := flag.String("stage", "txt2img", "workflow stage: txt2img | ref2img | i2v")
	prompt := flag.String("prompt", "a fox in a forest, soft watercolor illustration", "")
	negative := flag.String("negative", "text, watermark, signature, deformed", "")
	seed := flag.Int64("seed", 42, "")
	out := flag.String("out", "render-smoke.png", "output file")
	timeout := flag.Duration("timeout", 30*time.Second, "MODELS_PLAN tier 0 is ~1-2s on GB10; raise this for higher tiers")
	flag.Parse()

	if *url == "" {
		log.Fatal("-url is required, e.g. -url http://spark.local:8188")
	}

	wf, inputMap, err := comfy.LoadStage(*modelDir, *stage)
	if err != nil {
		log.Fatalf("load workflow: %v", err)
	}

	client := comfy.NewClient(*url)
	ctx, cancel := context.WithTimeout(context.Background(), *timeout+10*time.Second)
	defer cancel()

	log.Printf("submitting to %s (stage=%s, seed=%d)...", *url, *stage, *seed)
	img, err := comfy.Render(ctx, client, wf, inputMap, map[string]any{
		"prompt":   *prompt,
		"negative": *negative,
		"seed":     *seed,
	}, comfy.RenderOpts{Timeout: *timeout})
	if err != nil {
		log.Fatalf("render: %v", err)
	}

	if err := os.WriteFile(*out, img, 0o644); err != nil {
		log.Fatalf("write %s: %v", *out, err)
	}
	log.Printf("OK: wrote %d bytes to %s — open it and actually look at it", len(img), *out)
}
