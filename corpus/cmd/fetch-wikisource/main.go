// Command fetch-wikisource downloads the public-domain tale collections
// listed in corpus/internal/wikisource.Catalog and writes one plain-text
// file per tale into corpus/data/raw, in the same shape as
// fetch-gutenberg so `rag.extract` can read either without caring.
//
// This exists for the Czech canon: Erben and Němcová are not on Project
// Gutenberg, so §3.1's "všechny pohádky světa" cannot include Czech at
// all without this fetcher.
//
// Usage:
//
//	go run ./corpus/cmd/fetch-wikisource [-only nemcova,erben] [-out corpus/data/raw] [-delay 400ms]
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

	"github.com/lioilsources/storyteller/corpus/internal/wikisource"
)

func main() {
	only := flag.String("only", "", "comma-separated collection filter, e.g. nemcova,erben (default: all)")
	out := flag.String("out", "corpus/data/raw", "output directory")
	delay := flag.Duration("delay", 400*time.Millisecond, "delay between page requests (Wikimedia asks bots to go easy)")
	flag.Parse()

	filter := map[string]bool{}
	if *only != "" {
		for _, c := range strings.Split(*only, ",") {
			filter[strings.TrimSpace(c)] = true
		}
	}
	sources := wikisource.ByCollections(filter)
	if len(sources) == 0 {
		log.Fatalf("no collections matched -only=%q", *only)
	}

	client := &http.Client{Timeout: 60 * time.Second}
	var talesTotal, sourcesOK int
	var allSkipped []string

	for i, s := range sources {
		origin := s.Country
		if s.MixedOrigin {
			origin = "mixed"
		}
		fmt.Printf("fetching %-55s (%s, %s)... ", s.Title, s.Collection, origin)

		api := &wikisource.Client{HTTP: client, Lang: s.Lang}
		titles, err := pageTitles(api, s)
		if err != nil {
			fmt.Printf("FAILED: %v\n", err)
			continue
		}
		fmt.Printf("%d pages\n", len(titles))

		n, skipped, err := fetchAll(api, s, titles, *out, *delay)
		if err != nil {
			fmt.Printf("  FAILED after %d tales: %v\n", n, err)
			continue
		}
		for _, sk := range skipped {
			fmt.Printf("  skipped: %s\n", sk)
		}
		allSkipped = append(allSkipped, skipped...)
		talesTotal += n
		sourcesOK++
		if i < len(sources)-1 {
			time.Sleep(*delay)
		}
	}

	fmt.Printf("\ndone: %d/%d collections, %d tales written under %s/\n", sourcesOK, len(sources), talesTotal, *out)

	// One unusable page shouldn't cost us the other 25 in its volume, but
	// it must not pass unnoticed either: a silent thin corpus is the
	// failure mode that only surfaces much later as missing motifs.
	if len(allSkipped) > 0 {
		fmt.Printf("%d page(s) skipped — see above\n", len(allSkipped))
		os.Exit(1)
	}
}

func pageTitles(api *wikisource.Client, s wikisource.Source) ([]string, error) {
	if s.Prefix != "" {
		return api.Subpages(s.Prefix)
	}
	return s.Pages, nil
}

// Meta is the sidecar written next to each collection, mirroring
// gutenberg.Meta so downstream code can treat the two the same.
type Meta struct {
	Collection  string    `json:"collection"`
	Title       string    `json:"title"`
	Author      string    `json:"author"`
	Lang        string    `json:"lang"`
	Country     string    `json:"country,omitempty"`
	MixedOrigin bool      `json:"mixed_origin,omitempty"`
	SourceURL   string    `json:"source_url"`
	License     string    `json:"license"`
	FetchedAt   time.Time `json:"fetched_at"`
	Tales       int       `json:"tales"`
}

// minTaleChars is the floor below which a "tale" is certainly not one.
// The shortest real tale fetched on 2026-09-25 (a Serbian etiological
// story, 5 paragraphs) is ~2.3 kB, so 200 bytes only ever catches
// apparatus: redirect stubs, empty container pages, or a PlainText
// reduction that ate the body.
const minTaleChars = 200

func fetchAll(api *wikisource.Client, s wikisource.Source, titles []string, outDir string, delay time.Duration) (written int, skipped []string, err error) {
	dir := filepath.Join(outDir, s.Collection, "tales")
	// Cleared for the same reason as in fetch-gutenberg: a re-run with
	// different page names must not leave last run's files behind for the
	// extractor to pick up as extra tales.
	if err := os.RemoveAll(dir); err != nil {
		return 0, nil, err
	}
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return 0, nil, err
	}

	index := make([]map[string]any, 0, len(titles))
	seen := map[string]bool{}
	for i, title := range titles {
		if i > 0 {
			time.Sleep(delay)
		}
		page, err := api.Page(title)
		if err != nil {
			return written, skipped, err
		}
		// Redirects are followed, so two requested titles can land on
		// the same page. Writing both would double-count the tale in
		// every per-country total the globe shows.
		if seen[page.Title] {
			continue
		}
		seen[page.Title] = true

		if n := len(strings.TrimSpace(page.Text)); n < minTaleChars {
			skipped = append(skipped, fmt.Sprintf("%s (%d chars of text — not a tale?)", title, n))
			continue
		}

		// Keep the tale's own name, not the container prefix.
		short := page.Title
		if idx := strings.LastIndex(short, "/"); idx >= 0 {
			short = short[idx+1:]
		}
		fname := fmt.Sprintf("%03d-%s.txt", i, slugify(short))
		if err := os.WriteFile(filepath.Join(dir, fname), []byte(page.Text), 0o644); err != nil {
			return written, skipped, err
		}
		entry := map[string]any{
			"idx":   i,
			"title": short,
			"page":  page.Title,
			"file":  fname,
			"url":   page.URL,
		}
		if page.Title != title {
			entry["requested"] = title // a redirect was followed
		}
		index = append(index, entry)
		written++
	}

	indexJSON, err := json.MarshalIndent(index, "", "  ")
	if err != nil {
		return written, skipped, err
	}
	if err := os.WriteFile(filepath.Join(dir, "index.json"), indexJSON, 0o644); err != nil {
		return written, skipped, err
	}

	meta := Meta{
		Collection:  s.Collection,
		Title:       s.Title,
		Author:      s.Author,
		Lang:        s.Lang,
		Country:     s.Country,
		MixedOrigin: s.MixedOrigin,
		SourceURL:   fmt.Sprintf("https://%s.wikisource.org/", s.Lang),
		License:     "public domain (author died >70 years ago); Wikisource text under CC BY-SA 4.0 for any editorial apparatus, which this fetcher strips",
		FetchedAt:   time.Now().UTC(),
		Tales:       written,
	}
	metaJSON, err := json.MarshalIndent(meta, "", "  ")
	if err != nil {
		return written, skipped, err
	}
	return written, skipped, os.WriteFile(filepath.Join(outDir, s.Collection, "meta.json"), metaJSON, 0o644)
}

// slugify matches fetch-gutenberg's, except that it keeps Czech letters
// legible by transliterating them instead of collapsing every accented
// character into a dash (which would turn "Chytrá horákyně" into
// "chytr-hor-ky-").
func slugify(s string) string {
	s = strings.ToLower(strings.TrimSpace(s))
	var b strings.Builder
	lastDash := false
	for _, r := range s {
		if repl, ok := translit[r]; ok {
			b.WriteString(repl)
			lastDash = false
			continue
		}
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

var translit = map[rune]string{
	'á': "a", 'č': "c", 'ď': "d", 'é': "e", 'ě': "e", 'í': "i", 'ň': "n",
	'ó': "o", 'ř': "r", 'š': "s", 'ť': "t", 'ú': "u", 'ů': "u", 'ý': "y", 'ž': "z",
}
