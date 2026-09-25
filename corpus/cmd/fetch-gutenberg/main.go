// Command fetch-gutenberg downloads the public-domain fairy tale
// anthologies listed in corpus/internal/gutenberg.Catalog, strips
// Project Gutenberg's license boilerplate, splits each anthology into
// individual tales, and writes both the raw per-book text and the
// per-tale split into corpus/data/raw.
//
// This is step 1 of STORYTELLER_PLAN.md §3.2 ("fetch" + "clean").
//
// Usage:
//
//	go run ./corpus/cmd/fetch-gutenberg [-only grimm,andersen] [-out corpus/data/raw] [-delay 1s]
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"os"
	"path/filepath"
	"strings"
	"time"

	"github.com/lioilsources/storyteller/corpus/internal/gutenberg"
)

func main() {
	only := flag.String("only", "", "comma-separated collection filter, e.g. grimm,andersen (default: all)")
	out := flag.String("out", "corpus/data/raw", "output directory")
	delay := flag.Duration("delay", time.Second, "delay between requests (be polite to gutenberg.org)")
	flag.Parse()

	filter := map[string]bool{}
	if *only != "" {
		for _, c := range strings.Split(*only, ",") {
			filter[strings.TrimSpace(c)] = true
		}
	}
	books := gutenberg.ByCollections(filter)
	if len(books) == 0 {
		log.Fatalf("no books matched -only=%q", *only)
	}

	client := &http.Client{Timeout: 60 * time.Second}

	var talesTotal, booksOK int
	for i, b := range books {
		if i > 0 {
			time.Sleep(*delay)
		}
		fmt.Printf("fetching #%d %-45s (%s, id %d)... ", i+1, b.Title, b.Collection, b.ID)

		body, err := gutenberg.Fetch(client, b, *out)
		if err != nil {
			fmt.Printf("FAILED: %v\n", err)
			continue
		}

		tales := gutenberg.SplitTales(body, b.Title)
		if err := writeTales(*out, b, tales); err != nil {
			fmt.Printf("fetched but failed to write split tales: %v\n", err)
			continue
		}

		fallback := len(tales) == 1 && tales[0].Title == b.Title
		if fallback {
			fmt.Printf("OK, but split found no CONTENTS block — saved as one tale (needs a manual look)\n")
		} else {
			fmt.Printf("OK, %d tales\n", len(tales))
		}
		talesTotal += len(tales)
		booksOK++
	}

	fmt.Printf("\ndone: %d/%d books fetched, %d tales split, written under %s/\n", booksOK, len(books), talesTotal, *out)
}

func writeTales(outDir string, b gutenberg.Book, tales []gutenberg.Tale) error {
	dir := filepath.Join(outDir, b.Collection, fmt.Sprintf("%d-tales", b.ID))
	// Clear the directory first. Improving the splitter changes both the
	// number of tales and their filenames, so writing over the top of an
	// older run leaves orphans behind — and those orphans are whole-book
	// blobs that `rag.extract` would happily process as one more "tale",
	// quietly double-counting a volume. Found exactly this way on
	// 2026-09-25 with the Olive and Lilac books.
	if err := os.RemoveAll(dir); err != nil {
		return err
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return err
	}
	index := make([]map[string]any, 0, len(tales))
	for i, t := range tales {
		slug := slugify(t.Title)
		fname := fmt.Sprintf("%03d-%s.txt", i, slug)
		if err := os.WriteFile(filepath.Join(dir, fname), []byte(t.Text), 0o644); err != nil {
			return err
		}
		index = append(index, map[string]any{"idx": i, "title": t.Title, "file": fname})
	}
	indexJSON, err := json.MarshalIndent(index, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(filepath.Join(dir, "index.json"), indexJSON, 0o644)
}

func slugify(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	var b strings.Builder
	lastDash := false
	for _, r := range s {
		switch {
		case r >= 'a' && r <= 'z' || r >= '0' && r <= '9':
			b.WriteRune(r)
			lastDash = false
		default:
			if !lastDash {
				b.WriteByte('-')
				lastDash = true
			}
		}
	}
	out := strings.Trim(b.String(), "-")
	if len(out) > 60 {
		out = out[:60]
	}
	if out == "" {
		out = "untitled"
	}
	return out
}
