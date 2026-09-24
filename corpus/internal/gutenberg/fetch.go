package gutenberg

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"time"
)

// TextURL is Project Gutenberg's canonical UTF-8 plain-text URL pattern,
// confirmed live for every book in Catalog on 2026-09-24.
func TextURL(id int) string {
	return fmt.Sprintf("https://www.gutenberg.org/cache/epub/%d/pg%d.txt", id, id)
}

// Meta is the sidecar JSON saved next to each raw text file.
type Meta struct {
	ID         int       `json:"id"`
	Title      string    `json:"title"`
	Author     string    `json:"author"`
	Collection string    `json:"collection"`
	SourceURL  string    `json:"source_url"`
	License    string    `json:"license"`
	FetchedAt  time.Time `json:"fetched_at"`
}

var (
	startMarker = regexp.MustCompile(`(?m)^\*\*\*\s*START OF THE PROJECT GUTENBERG EBOOK.*\*\*\*\s*$`)
	endMarker   = regexp.MustCompile(`(?m)^\*\*\*\s*END OF THE PROJECT GUTENBERG EBOOK.*\*\*\*\s*$`)
)

// StripBoilerplate removes Project Gutenberg's license header/footer,
// keeping only the licensed-for-reuse body between the START/END
// markers every PG text file carries.
func StripBoilerplate(raw string) string {
	body := raw
	if loc := startMarker.FindStringIndex(body); loc != nil {
		body = body[loc[1]:]
	}
	if loc := endMarker.FindStringIndex(body); loc != nil {
		body = body[:loc[0]]
	}
	return body
}

// Fetch downloads one book, strips PG boilerplate, and writes
// <outDir>/<collection>/<id>.txt + <id>.json. Returns the cleaned body.
func Fetch(client *http.Client, b Book, outDir string) (string, error) {
	url := TextURL(b.ID)
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return "", err
	}
	// Identify ourselves honestly, per Gutenberg's request for bulk/bot
	// traffic — a small courtesy, not enforced by them for single files.
	req.Header.Set("User-Agent", "storyteller-corpus-fetcher/0.1 (+https://github.com/lioilsources/storyteller; contact: oldrich.vorechovsky.jr@gmail.com)")

	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("fetch %d: %w", b.ID, err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("fetch %d: unexpected status %s", b.ID, resp.Status)
	}
	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("fetch %d: read body: %w", b.ID, err)
	}

	body := StripBoilerplate(string(raw))

	dir := filepath.Join(outDir, b.Collection)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", err
	}
	txtPath := filepath.Join(dir, fmt.Sprintf("%d.txt", b.ID))
	if err := os.WriteFile(txtPath, []byte(body), 0o644); err != nil {
		return "", err
	}

	meta := Meta{
		ID:         b.ID,
		Title:      b.Title,
		Author:     b.Author,
		Collection: b.Collection,
		SourceURL:  url,
		License:    "public domain (Project Gutenberg; see file for PG's own terms on redistribution of the full text)",
		FetchedAt:  time.Now().UTC(),
	}
	metaJSON, err := json.MarshalIndent(meta, "", "  ")
	if err != nil {
		return "", err
	}
	jsonPath := filepath.Join(dir, fmt.Sprintf("%d.json", b.ID))
	if err := os.WriteFile(jsonPath, metaJSON, 0o644); err != nil {
		return "", err
	}

	return body, nil
}
