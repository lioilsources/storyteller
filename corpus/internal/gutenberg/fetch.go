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
	ArchiveID  string    `json:"archive_id,omitempty"`
	Source     string    `json:"source"` // "gutenberg" | "archive", first part of source_ref
	Title      string    `json:"title"`
	Author     string    `json:"author"`
	Collection string    `json:"collection"`
	Lang       string    `json:"lang"` // language of the text, same key as fetch-wikisource
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

// Fetch downloads one book, verifies it is the book the catalog means,
// strips PG boilerplate, and writes <outDir>/<collection>/<key>.txt +
// <key>.json (key: Book.Key). Returns the cleaned body.
func Fetch(client *http.Client, b Book, outDir string) (string, error) {
	var url, body, license string
	var err error
	if b.Archive != nil {
		url, body, err = fetchArchive(client, b)
		license = b.License
	} else {
		url = TextURL(b.ID)
		var raw string
		if raw, err = get(client, url); err == nil {
			// Verify before writing anything: a wrong ID should leave no
			// file behind for a later run to mistake for real corpus.
			if err = CheckTitle(b, raw); err == nil {
				body = StripBoilerplate(raw)
			}
		}
		license = "public domain (Project Gutenberg; see file for PG's own terms on redistribution of the full text)"
	}
	if err != nil {
		return "", err
	}

	dir := filepath.Join(outDir, b.Collection)
	if err := os.MkdirAll(dir, 0o755); err != nil {
		return "", err
	}
	txtPath := filepath.Join(dir, b.Key()+".txt")
	if err := os.WriteFile(txtPath, []byte(body), 0o644); err != nil {
		return "", err
	}

	meta := Meta{
		ID:         b.ID,
		Source:     b.Source(),
		Title:      b.Title,
		Author:     b.Author,
		Collection: b.Collection,
		Lang:       b.Lang,
		SourceURL:  url,
		License:    license,
		FetchedAt:  time.Now().UTC(),
	}
	if b.Archive != nil {
		meta.ArchiveID = b.Archive.ID
	}
	metaJSON, err := json.MarshalIndent(meta, "", "  ")
	if err != nil {
		return "", err
	}
	jsonPath := filepath.Join(dir, b.Key()+".json")
	if err := os.WriteFile(jsonPath, metaJSON, 0o644); err != nil {
		return "", err
	}

	return body, nil
}

const userAgent = "storyteller-corpus-fetcher/0.1 (+https://github.com/lioilsources/storyteller; contact: oldrich.vorechovsky.jr@gmail.com)"

func get(client *http.Client, url string) (string, error) {
	req, err := http.NewRequest(http.MethodGet, url, nil)
	if err != nil {
		return "", err
	}
	// Identify ourselves honestly, per Gutenberg's request for bulk/bot
	// traffic — a small courtesy, not enforced by them for single files.
	req.Header.Set("User-Agent", userAgent)
	resp, err := client.Do(req)
	if err != nil {
		return "", fmt.Errorf("fetch %s: %w", url, err)
	}
	defer resp.Body.Close()
	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("fetch %s: unexpected status %s", url, resp.Status)
	}
	raw, err := io.ReadAll(resp.Body)
	if err != nil {
		return "", fmt.Errorf("fetch %s: read body: %w", url, err)
	}
	return string(raw), nil
}

// ArchiveMetadataURL is the Internet Archive item metadata endpoint.
func ArchiveMetadataURL(id string) string { return "https://archive.org/metadata/" + id }

// ArchiveFileURL is the download URL of one file inside an item.
func ArchiveFileURL(a ArchiveItem) string {
	return "https://archive.org/download/" + a.ID + "/" + strings.ReplaceAll(a.File, " ", "%20")
}

// fetchArchive is the Internet Archive counterpart of the Gutenberg
// path: the item's own metadata title plays the role of PG's "Title:"
// header (an identifier is as easy to mistype as a Gutenberg ID), and
// the OCR text has no licence boilerplate to strip.
func fetchArchive(client *http.Client, b Book) (url, body string, err error) {
	mraw, err := get(client, ArchiveMetadataURL(b.Archive.ID))
	if err != nil {
		return "", "", err
	}
	var m struct {
		Metadata struct {
			Title string `json:"title"`
		} `json:"metadata"`
	}
	if err := json.Unmarshal([]byte(mraw), &m); err != nil {
		return "", "", fmt.Errorf("archive %s: metadata: %w", b.Archive.ID, err)
	}
	if m.Metadata.Title == "" {
		return "", "", fmt.Errorf("archive %s: item has no title — wrong identifier?", b.Archive.ID)
	}
	if !titlesMatch(m.Metadata.Title, b.Title) {
		return "", "", fmt.Errorf("archive %s: catalog says %q but the item says %q — wrong identifier?", b.Archive.ID, b.Title, m.Metadata.Title)
	}
	url = ArchiveFileURL(*b.Archive)
	body, err = get(client, url)
	if err != nil {
		return "", "", err
	}
	return url, strings.ReplaceAll(body, "\r\n", "\n"), nil
}
