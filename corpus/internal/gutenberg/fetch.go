package gutenberg

import (
	"encoding/json"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"regexp"
	"strings"
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
	titleHeader = regexp.MustCompile(`(?m)^Title:\s*(.+?)\s*$`)
)

// HeaderTitle reads the "Title:" line Gutenberg puts in the first few
// hundred bytes of every plain-text file, before the START marker.
func HeaderTitle(raw string) string {
	if m := titleHeader.FindStringSubmatch(raw); m != nil {
		return m[1]
	}
	return ""
}

// CheckTitle compares the fetched file's own header against the title we
// expected from the catalog.
//
// Gutenberg IDs are stable in practice, but they are also just integers
// in a URL: one transposed digit in the catalog silently yields a real
// book that is not the one we meant, and the mistake only surfaces much
// later as nonsense motifs. Comparison is loose on purpose — Gutenberg
// writes "Grimms' Fairy Tales" with a typographic apostrophe in some
// files and an ASCII one in others, and sometimes appends a subtitle.
func CheckTitle(b Book, raw string) error {
	got := HeaderTitle(raw)
	if got == "" {
		return fmt.Errorf("book %d: no Title: header — is this a Gutenberg text file?", b.ID)
	}
	if !titlesMatch(got, b.Title) {
		return fmt.Errorf("book %d: catalog says %q but the file says %q — wrong ID?", b.ID, b.Title, got)
	}
	return nil
}

func titlesMatch(got, want string) bool {
	norm := func(s string) string {
		s = strings.ToLower(s)
		var b strings.Builder
		for _, r := range s {
			if r >= 'a' && r <= 'z' || r >= '0' && r <= '9' {
				b.WriteRune(r)
			}
		}
		return b.String()
	}
	g, w := norm(got), norm(want)
	return strings.HasPrefix(g, w) || strings.HasPrefix(w, g)
}

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
	rawBytes, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("fetch %d: read body: %w", b.ID, err)
	}
	raw := string(rawBytes)

	// Verify before writing anything: a wrong ID should leave no file
	// behind for a later run to mistake for real corpus.
	if err := CheckTitle(b, raw); err != nil {
		return "", err
	}

	body := StripBoilerplate(raw)

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
