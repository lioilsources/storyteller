// Command render-motifs renders one card image per RAG pack motif with
// flux-schnell (gen-queue on Spark), in the same watercolor style as the
// hand-picked cards in app/assets/motifs/. rag.build_pack then embeds the
// images into the pack (table motif_images), so art ships with the data.
//
// Input is a JSON array of {"id", "text_en"} — rag/data/motif_cards.json,
// exported from the pack by rag.build_pack --export-cards. Resumable: a
// motif whose <id>.jpg already exists is skipped.
//
//	go run ./internal/nimqueue/cmd/render-motifs \
//	  -in rag/data/motif_cards.json -out rag/data/motif_images
//
// flux-schnell and swarm-director don't fit on Spark together: stop the
// director before running this, bring it back after.
package main

import (
	"context"
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"flag"
	"log"
	"os"
	"path/filepath"
	"sync"
	"sync/atomic"
	"time"

	"github.com/lioilsources/storyteller/internal/contentkey"
	"github.com/lioilsources/storyteller/internal/nimqueue"
)

// style matches the prompts behind app/assets/motifs/*.jpg (2026-09-25):
// the motif sentence itself, then the look.
const style = ", soft watercolor illustration for a children's picture book, gentle warm colors, no text, no watermark, no signature"

type card struct {
	ID     string `json:"id"`
	TextEn string `json:"text_en"`
}

// seed is stable per motif: contentkey.Seed over sha256("motif-card", id),
// so a re-render of the same motif gives the same picture. The flux-schnell
// NIM rejects seeds ≥ 2^32 with HTTP 422 (found 2026-09-27: every job of the
// first run failed on it), so only the low 32 bits go out.
func seed(id string) int64 {
	h := sha256.Sum256([]byte("motif-card\x1f" + id))
	s, err := contentkey.Seed(hex.EncodeToString(h[:]))
	if err != nil {
		panic(err) // a sha256 hex digest always satisfies Seed
	}
	return s & 0xffffffff
}

func main() {
	url := flag.String("url", "http://192.168.88.66:8091", "gen-queue base URL (Spark LAN)")
	in := flag.String("in", "rag/data/motif_cards.json", "JSON array of {id, text_en}")
	out := flag.String("out", "rag/data/motif_images", "output dir, one <id>.jpg per motif")
	conc := flag.Int("concurrency", 2, "parallel jobs; gen-queue serialises on the one GPU anyway")
	flag.Parse()

	raw, err := os.ReadFile(*in)
	if err != nil {
		log.Fatal(err)
	}
	var cards []card
	if err := json.Unmarshal(raw, &cards); err != nil {
		log.Fatal(err)
	}
	if err := os.MkdirAll(*out, 0o755); err != nil {
		log.Fatal(err)
	}

	client := nimqueue.NewClient(*url)
	var ok, skipped, failed atomic.Int64
	jobs := make(chan card)
	var wg sync.WaitGroup
	for range *conc {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for c := range jobs {
				path := filepath.Join(*out, c.ID+".jpg")
				if _, err := os.Stat(path); err == nil {
					skipped.Add(1)
					continue
				}
				var img []byte
				var err error
				for try := range 3 {
					ctx, cancel := context.WithTimeout(context.Background(), 90*time.Second)
					img, err = client.GenerateSchnell(ctx, nimqueue.SchnellRequest{Prompt: c.TextEn + style, Width: 1024, Height: 1024, Steps: 4, Seed: seed(c.ID)})
					cancel()
					if err == nil {
						break
					}
					log.Printf("  %s try %d: %v", c.ID, try+1, err)
					time.Sleep(time.Duration(try+1) * 3 * time.Second)
				}
				if err != nil {
					failed.Add(1)
					continue
				}
				// gen-queue labels it image/png but the bytes are JPEG (README).
				tmp := path + ".tmp"
				if err := os.WriteFile(tmp, img, 0o644); err == nil {
					err = os.Rename(tmp, path)
				}
				if err != nil {
					log.Printf("  %s write: %v", c.ID, err)
					failed.Add(1)
					continue
				}
				if n := ok.Add(1); n%10 == 0 {
					log.Printf("rendered %d/%d", n, len(cards))
				}
			}
		}()
	}
	start := time.Now()
	for _, c := range cards {
		jobs <- c
	}
	close(jobs)
	wg.Wait()
	log.Printf("done in %s: %d rendered, %d already there, %d failed", time.Since(start).Round(time.Second), ok.Load(), skipped.Load(), failed.Load())
	if failed.Load() > 0 {
		os.Exit(1)
	}
}
