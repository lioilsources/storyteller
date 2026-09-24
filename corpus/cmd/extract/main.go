// Command extract reads the tale files fetch-gutenberg wrote under
// corpus/data/raw/<collection>/<id>-tales/, asks an LLM (via LiteLLM,
// OpenAI-compatible) to pull out characters/tasks/problems/endings +
// atu_code/country_code/age_min/soft for each one, and writes the
// result as JSON under corpus/data/motifs/. With -load and
// DATABASE_URL set, it also inserts the rows into corpus_motifs.
//
// STORYTELLER_PLAN.md §3.2, steps "classify" + "extract".
//
// Requires LITELLM_BASE_URL (OpenAI-compatible base, e.g.
// http://<spark-host>:4000/v1) and usually LITELLM_API_KEY — this
// hasn't been run against the real Spark endpoint yet, see
// corpus/README.md.
//
// Usage:
//
//	LITELLM_BASE_URL=http://spark.local:4000/v1 LITELLM_MODEL=qwen3-4b \
//	  go run ./corpus/cmd/extract [-in corpus/data/raw] [-out corpus/data/motifs] [-only grimm] [-limit 5]
package main

import (
	"context"
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"os"
	"path/filepath"
	"strings"

	"github.com/lioilsources/storyteller/corpus/internal/llm"
	"github.com/lioilsources/storyteller/corpus/internal/motif"
	"github.com/lioilsources/storyteller/internal/models"
)

type taleIndexEntry struct {
	Idx   int    `json:"idx"`
	Title string `json:"title"`
	File  string `json:"file"`
}

func main() {
	in := flag.String("in", "corpus/data/raw", "raw tales directory (output of fetch-gutenberg)")
	out := flag.String("out", "corpus/data/motifs", "where to write extracted motif JSON")
	only := flag.String("only", "", "comma-separated collection filter, e.g. grimm,andersen")
	limit := flag.Int("limit", 0, "max tales to process (0 = all) — use a small number for a smoke test")
	load := flag.Bool("load", false, "also insert rows into Postgres corpus_motifs (requires DATABASE_URL)")
	flag.Parse()

	baseURL := os.Getenv("LITELLM_BASE_URL")
	if baseURL == "" {
		log.Fatal("LITELLM_BASE_URL is not set — point it at LiteLLM's OpenAI-compatible base, e.g. http://spark.local:4000/v1")
	}
	model := os.Getenv("LITELLM_MODEL")
	if model == "" {
		log.Fatal("LITELLM_MODEL is not set — see STORYTELLER_PLAN.md §6.1 for candidates (Qwen3-4B / Gemma-3-4B / Llama-3.2-3B)")
	}
	client := llm.New(baseURL, os.Getenv("LITELLM_API_KEY"), model)

	filter := map[string]bool{}
	if *only != "" {
		for _, c := range strings.Split(*only, ",") {
			filter[strings.TrimSpace(c)] = true
		}
	}

	tales, err := discoverTales(*in, filter)
	if err != nil {
		log.Fatalf("discover tales: %v", err)
	}
	if *limit > 0 && len(tales) > *limit {
		tales = tales[:*limit]
	}
	if len(tales) == 0 {
		log.Fatalf("no tales found under %s (run fetch-gutenberg first)", *in)
	}
	fmt.Printf("extracting motifs from %d tales...\n", len(tales))

	ctx := context.Background()
	var allRows []models.CorpusMotif
	ok, failed := 0, 0
	for i, t := range tales {
		fmt.Printf("[%d/%d] %-12s %s ... ", i+1, len(tales), t.collection, t.title)
		rows, ex, err := motif.Extract(ctx, client, t.title, t.text, t.sourceRef)
		if err != nil {
			fmt.Printf("FAILED: %v\n", err)
			failed++
			continue
		}
		if err := writeMotifs(*out, t, rows); err != nil {
			fmt.Printf("extracted but failed to write: %v\n", err)
			failed++
			continue
		}
		fmt.Printf("OK, %d motifs (atu=%s country=%s soft=%v)\n", len(rows), ex.ATUCode, ex.CountryCode, ex.Soft)
		allRows = append(allRows, rows...)
		ok++
	}
	fmt.Printf("\ndone: %d/%d tales extracted, %d failed, %d motifs total\n", ok, len(tales), failed, len(allRows))

	if *load {
		if err := loadIntoPostgres(ctx, allRows); err != nil {
			log.Fatalf("load into Postgres: %v", err)
		}
	}
}

type discoveredTale struct {
	collection string
	bookID     string
	idx        int
	title      string
	text       string
	sourceRef  string
}

// discoverTales walks <in>/<collection>/<id>-tales/index.json written by
// fetch-gutenberg and loads each referenced tale's text.
func discoverTales(inDir string, filter map[string]bool) ([]discoveredTale, error) {
	var out []discoveredTale
	collections, err := os.ReadDir(inDir)
	if err != nil {
		return nil, err
	}
	for _, ce := range collections {
		if !ce.IsDir() {
			continue
		}
		collection := ce.Name()
		if len(filter) > 0 && !filter[collection] {
			continue
		}
		collDir := filepath.Join(inDir, collection)
		bookDirs, err := os.ReadDir(collDir)
		if err != nil {
			return nil, err
		}
		for _, bd := range bookDirs {
			if !bd.IsDir() || !strings.HasSuffix(bd.Name(), "-tales") {
				continue
			}
			bookID := strings.TrimSuffix(bd.Name(), "-tales")
			talesDir := filepath.Join(collDir, bd.Name())
			indexBytes, err := os.ReadFile(filepath.Join(talesDir, "index.json"))
			if err != nil {
				return nil, fmt.Errorf("read index for %s/%s: %w", collection, bd.Name(), err)
			}
			var index []taleIndexEntry
			if err := json.Unmarshal(indexBytes, &index); err != nil {
				return nil, fmt.Errorf("parse index for %s/%s: %w", collection, bd.Name(), err)
			}
			for _, entry := range index {
				textBytes, err := os.ReadFile(filepath.Join(talesDir, entry.File))
				if err != nil {
					return nil, fmt.Errorf("read tale %s/%s/%s: %w", collection, bd.Name(), entry.File, err)
				}
				out = append(out, discoveredTale{
					collection: collection,
					bookID:     bookID,
					idx:        entry.Idx,
					title:      entry.Title,
					text:       string(textBytes),
					sourceRef:  fmt.Sprintf("gutenberg:%s:%s:%s", collection, bookID, strings.TrimSuffix(entry.File, ".txt")),
				})
			}
		}
	}
	return out, nil
}

func writeMotifs(outDir string, t discoveredTale, rows []models.CorpusMotif) error {
	dir := filepath.Join(outDir, t.collection, t.bookID)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	buf, err := json.MarshalIndent(rows, "", "  ")
	if err != nil {
		return err
	}
	fname := fmt.Sprintf("%03d.json", t.idx)
	return os.WriteFile(filepath.Join(dir, fname), buf, 0o644)
}
