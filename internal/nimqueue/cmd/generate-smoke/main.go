// Command generate-smoke does one manual end-to-end flux-schnell
// generation against a real gen-queue — the nimqueue equivalent of
// internal/comfy/cmd/render-smoke.
//
// Usage:
//
//	go run ./internal/nimqueue/cmd/generate-smoke \
//	  -url http://192.168.88.66:8091 \
//	  -prompt "a fox in a forest, soft watercolor illustration" -out /tmp/out.jpg
package main

import (
	"context"
	"flag"
	"log"
	"os"
	"time"

	"github.com/lioilsources/storyteller/internal/nimqueue"
)

func main() {
	url := flag.String("url", "http://192.168.88.66:8091", "gen-queue base URL (LAN default, no auth needed)")
	cfID := flag.String("cf-id", "", "CF-Access-Client-Id (only needed for the public llm.ol1n.com route)")
	cfSecret := flag.String("cf-secret", "", "CF-Access-Client-Secret")
	prompt := flag.String("prompt", "a fox in a forest, soft watercolor illustration", "")
	seed := flag.Int64("seed", 42, "")
	out := flag.String("out", "generate-smoke.jpg", "output file — really a JPEG despite gen-queue's image/png header, see README")
	timeout := flag.Duration("timeout", 15*time.Second, "MODELS_PLAN tier 0: observed ~2-4s live")
	flag.Parse()

	client := nimqueue.NewClient(*url)
	client.CFAccessClientID = *cfID
	client.CFAccessClientSecret = *cfSecret

	ctx, cancel := context.WithTimeout(context.Background(), *timeout+10*time.Second)
	defer cancel()

	log.Printf("submitting to %s (flux-schnell, seed=%d)...", *url, *seed)
	start := time.Now()
	img, err := client.GenerateSchnell(ctx, nimqueue.SchnellRequest{
		Prompt: *prompt, Width: 1024, Height: 1024, Steps: 4, Seed: *seed,
	})
	if err != nil {
		log.Fatalf("generate: %v", err)
	}

	if err := os.WriteFile(*out, img, 0o644); err != nil {
		log.Fatalf("write %s: %v", *out, err)
	}
	log.Printf("OK: wrote %d bytes to %s in %s — open it and actually look at it", len(img), *out, time.Since(start).Round(time.Millisecond))
}
