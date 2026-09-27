// Command render-audio renders the Suflér soundboard from rag/audio/catalog.json
// on Spark's audio service: one looping background track per environment and
// mood (ACE-Step), one short sound per creature and per action (MOSS). Each
// WAV is transcoded to AAC .m4a, because iOS can't play the service's OGG.
// rag.build_pack packs them into core.<lang>.db.
//
//	go run ./internal/audiogen/cmd/render-audio -catalog rag/audio/catalog.json -out rag/data/sounds
//
// The audio models and swarm-director don't fit on Spark together: stop the
// director first, `make up-audio`, render, then bring the director back.
// Resumable: an id whose .m4a exists is skipped.
package main

import (
	"context"
	"crypto/sha256"
	"encoding/binary"
	"encoding/json"
	"flag"
	"log"
	"os"
	"os/exec"
	"path/filepath"
	"sort"
	"sync"
	"sync/atomic"
	"time"

	"github.com/lioilsources/storyteller/internal/audiogen"
)

type entry struct {
	CS     string   `json:"cs"`
	Prompt string   `json:"prompt"`
	Match  []string `json:"match"`
}

type catalog struct {
	Music struct {
		DurationS    float64           `json:"duration_s"`
		Style        string            `json:"style"`
		Moods        map[string]string `json:"moods"`
		Environments map[string]entry  `json:"environments"`
	} `json:"music"`
	Sfx struct {
		DurationS float64          `json:"duration_s"`
		Style     string           `json:"style"`
		Creatures map[string]entry `json:"creatures"`
		Actions   map[string]entry `json:"actions"`
	} `json:"sfx"`
}

type task struct {
	id, prompt string
	music      bool
	dur        float64
}

// seed: stable per sound, below 2^32 (the NIMs reject bigger, and the audio
// service passes it straight to its models too).
func seed(id string) int64 {
	h := sha256.Sum256([]byte("sound\x1f" + id))
	return int64(binary.BigEndian.Uint32(h[:4]))
}

func main() {
	url := flag.String("url", "http://192.168.88.66:8093", "audio service base URL (Spark LAN)")
	path := flag.String("catalog", "rag/audio/catalog.json", "")
	out := flag.String("out", "rag/data/sounds", "one <id>.m4a per sound")
	conc := flag.Int("concurrency", 2, "")
	only := flag.String("only", "", "music | sfx — render just one half")
	flag.Parse()

	raw, err := os.ReadFile(*path)
	if err != nil {
		log.Fatal(err)
	}
	var c catalog
	if err := json.Unmarshal(raw, &c); err != nil {
		log.Fatal(err)
	}
	var tasks []task
	if *only != "sfx" {
		for env, e := range c.Music.Environments {
			for mood, m := range c.Music.Moods {
				tasks = append(tasks, task{id: "music-" + env + "-" + mood, prompt: e.Prompt + ", " + m + ", " + c.Music.Style, music: true, dur: c.Music.DurationS})
			}
		}
	}
	if *only != "music" {
		for k, e := range c.Sfx.Creatures {
			tasks = append(tasks, task{id: "creature-" + k, prompt: e.Prompt + ", " + c.Sfx.Style, dur: c.Sfx.DurationS})
		}
		for k, e := range c.Sfx.Actions {
			tasks = append(tasks, task{id: "action-" + k, prompt: e.Prompt + ", " + c.Sfx.Style, dur: c.Sfx.DurationS})
		}
	}
	sort.Slice(tasks, func(i, j int) bool { return tasks[i].id < tasks[j].id })
	if err := os.MkdirAll(*out, 0o755); err != nil {
		log.Fatal(err)
	}

	client := audiogen.NewClient(*url)
	var ok, skipped, failed atomic.Int64
	jobs := make(chan task)
	var wg sync.WaitGroup
	for range *conc {
		wg.Add(1)
		go func() {
			defer wg.Done()
			for t := range jobs {
				dst := filepath.Join(*out, t.id+".m4a")
				if _, err := os.Stat(dst); err == nil {
					skipped.Add(1)
					continue
				}
				var wav []byte
				var err error
				for try := range 3 {
					ctx, cancel := context.WithTimeout(context.Background(), 15*time.Minute) // first music job loads 10 GB of weights
					if t.music {
						wav, err = client.Music(ctx, audiogen.MusicRequest{Prompt: t.prompt, DurationS: t.dur, Seed: seed(t.id), Instrumental: true, Loop: true, Format: "wav", Variations: 1})
					} else {
						wav, err = client.Sfx(ctx, audiogen.SfxRequest{Prompt: t.prompt, DurationS: t.dur, Seed: seed(t.id), Mono: true, Format: "wav", Variations: 1})
					}
					cancel()
					if err == nil {
						break
					}
					log.Printf("  %s try %d: %v", t.id, try+1, err)
					time.Sleep(time.Duration(try+1) * 5 * time.Second)
				}
				if err == nil {
					err = toM4A(wav, dst, t.music)
				}
				if err != nil {
					log.Printf("  %s FAILED: %v", t.id, err)
					failed.Add(1)
					continue
				}
				if n := ok.Add(1); n%10 == 0 {
					log.Printf("rendered %d/%d", n, len(tasks))
				}
			}
		}()
	}
	start := time.Now()
	for _, t := range tasks {
		jobs <- t
	}
	close(jobs)
	wg.Wait()
	log.Printf("done in %s: %d rendered, %d already there, %d failed", time.Since(start).Round(time.Second), ok.Load(), skipped.Load(), failed.Load())
	if failed.Load() > 0 {
		os.Exit(1)
	}
}

// toM4A transcodes to AAC in an .m4a: iOS plays neither OGG nor (reliably)
// raw WAV from memory, and AAC keeps the pack small.
func toM4A(wav []byte, dst string, music bool) error {
	src := dst + ".wav"
	if err := os.WriteFile(src, wav, 0o644); err != nil {
		return err
	}
	defer os.Remove(src)
	args := []string{"-y", "-loglevel", "error", "-i", src, "-c:a", "aac"}
	if music {
		args = append(args, "-b:a", "128k", "-ac", "2")
	} else {
		args = append(args, "-b:a", "96k", "-ac", "1")
	}
	tmp := dst + ".tmp.m4a"
	args = append(args, "-movflags", "+faststart", tmp)
	if out, err := exec.Command("ffmpeg", args...).CombinedOutput(); err != nil {
		os.Remove(tmp)
		return &exec.ExitError{Stderr: out}
	}
	return os.Rename(tmp, dst)
}
