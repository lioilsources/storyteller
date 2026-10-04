package gutenberg

import (
	"regexp"
	"strings"
)

// Tale is one individual story split out of an anthology's body text.
type Tale struct {
	Title string
	Text  string
}

var (
	contentsHeading = regexp.MustCompile(`(?i)^(?:table\s+of\s+)?contents\.?:?\s*$`)
	// A numbered entry: "12. Title", "12 Title", "XII. Title", "XII  Title".
	// Roman numerals need a period or two spaces — with one space, "CIVIL
	// WAR" would lose its first word.
	listPrefix = regexp.MustCompile(`^\s*(?:[0-9]+\.?\s+|[0-9]+\.|[IVXLCivxlc]+\.\s*|[IVXLCivxlc]+\s{2,})`)
	// A trailing page number: "Title   21", "Title 21", "Title ....... 21".
	pageNumSuffix = regexp.MustCompile(`(?:\s*\.{2,}\s*|\s+)[0-9]+\s*$`)
)

// normTitle is how a contents entry and a body heading are compared: no
// emphasis markup and no trailing period, because many books write
// "THE LION." in one place and "The Lion" in the other.
func normTitle(s string) string {
	return strings.TrimSpace(strings.TrimRight(stripEmphasis(s), "."))
}

// stripEmphasis removes the markup Project Gutenberg's plain-text
// editions wrap headings in. Underscores are their convention for
// italics, so the Olive and Lilac Fairy Books write `_CONTENTS_` and
// `_The Blue Parrot_` where the older volumes write `CONTENTS` and `The
// Blue Parrot` — and one of them even quotes a title as
// `'_A Long-bow Story_'`. Without this both volumes fell back to being
// stored as a single 30-tale blob.
func stripEmphasis(s string) string {
	return strings.Trim(strings.TrimSpace(s), "_*'\"")
}

// SplitTales finds the anthology's "CONTENTS" block, treats each entry
// as a chapter title, and locates that exact title again as a standalone
// line in the body to use as a split point.
//
// This works because Project Gutenberg's Grimm/Lang/Andersen/Perrault
// anthologies consistently repeat each contents entry verbatim as its
// section heading in the body (verified by hand against Grimms' Fairy
// Tales, ID 2591, on 2026-09-24 — see corpus/README.md). It is a
// heuristic, not a guarantee: anthologies that don't follow this
// convention fall back to being returned as a single Tale so the
// pipeline never silently drops text.
func SplitTales(body string, bookTitle string) []Tale {
	lines := strings.Split(body, "\n")

	contentsStart := -1
	for i, line := range lines {
		if contentsHeading.MatchString(stripEmphasis(line)) {
			contentsStart = i + 1
			break
		}
	}
	if contentsStart == -1 {
		return []Tale{{Title: bookTitle, Text: strings.TrimSpace(body)}}
	}

	candidates, consumed := collectCandidateTitles(lines[contentsStart:])
	if len(candidates) < 2 {
		return []Tale{{Title: bookTitle, Text: strings.TrimSpace(body)}}
	}

	// bodyStart: skip past the contents block itself (consumed lines)
	// so a title doesn't match its own listing.
	bodyStart := contentsStart + consumed

	type match struct {
		title string
		line  int
	}
	var matches []match
	seen := map[string]bool{}
	from := bodyStart // tales appear in contents order, so each search starts after the previous hit
	for _, title := range candidates {
		if seen[title] {
			continue
		}
		for i := from; i < len(lines); i++ {
			// Compared with emphasis stripped from both sides: a volume
			// is not always consistent about italicising a heading in
			// the contents and in the body.
			// Body headings may carry the number too ("1.  DINEWAN THE
			// EMU…", Australian Legendary Tales); a whole-line match is
			// still required, so prose starting with a digit can't hit.
			if strings.EqualFold(normTitle(lines[i]), title) || strings.EqualFold(normTitle(listPrefix.ReplaceAllString(lines[i], "")), title) {
				matches = append(matches, match{title: title, line: i})
				seen[title] = true
				from = i + 1
				break
			}
		}
	}
	if len(matches) < 2 {
		return []Tale{{Title: bookTitle, Text: strings.TrimSpace(body)}}
	}

	tales := make([]Tale, 0, len(matches))
	for i, m := range matches {
		end := len(lines)
		if i+1 < len(matches) {
			end = matches[i+1].line
		}
		text := strings.TrimSpace(strings.Join(lines[m.line+1:end], "\n"))
		if text == "" {
			continue
		}
		tales = append(tales, Tale{Title: m.title, Text: text})
	}
	return tales
}

// collectCandidateTitles reads short heading-like lines right after
// "CONTENTS:" until it hits something that looks like prose (a long
// line, i.e. an actual paragraph) or a run of 7+ blank lines (some books
// double-space their contents), whichever comes first — that's where the contents block ends. It returns the
// titles found and how many lines (relative to the start of `lines`)
// it consumed, so the caller knows where the contents block actually
// ends and can search for body matches after that point, not within it.
func collectCandidateTitles(lines []string) (titles []string, consumed int) {
	const maxTitleLen = 100
	const maxScan = 500

	blankRun := 0
	i := 0
	for ; i < len(lines) && i < maxScan; i++ {
		line := strings.TrimSpace(lines[i])
		if line == "" {
			blankRun++
			if blankRun >= 7 {
				i++
				break
			}
			continue
		}
		blankRun = 0
		line = pageNumSuffix.ReplaceAllString(line, "")
		if len(line) > maxTitleLen {
			break // prose started; do not consume this line
		}
		line = listPrefix.ReplaceAllString(line, "")
		line = normTitle(line)
		if line == "" {
			continue
		}
		// The first title coming round again means the body has started:
		// a contents block never lists a tale twice. This, not the blank
		// run, is what ends double-spaced contents blocks (PG wraps prose
		// at ~70 characters, so "a long line" rarely marks the end).
		if strings.EqualFold(line, "page") {
			continue // the column header over the page numbers
		}
		// One of the first three titles coming round again ends the block.
		// Not just the first — contents often open with "Preface", which
		// sits before the contents in the body and never repeats (Crimson
		// Fairy Book, 2435). Not any title — Aesop and Grimm legitimately
		// list two tales under the same name, deep in the list.
		if repeatsEarly(titles, line) {
			break
		}
		titles = append(titles, line)
	}
	return titles, i
}

func repeatsEarly(titles []string, line string) bool {
	for i := 0; i < len(titles) && i < 3; i++ {
		if strings.EqualFold(line, titles[i]) {
			return true
		}
	}
	return false
}

// CutPrefix marks an entry in Book.Titles as a cut point rather than a
// tale: the section from that heading to the next one is dropped. For
// notes, proverbs and similar blocks that sit between tales and would
// otherwise be glued onto the end of the tale before them.
const CutPrefix = "!"

// Cut returns title as a cut-point entry for Book.Titles.
func Cut(title string) string { return CutPrefix + title }

var (
	spaceRun = regexp.MustCompile(`\s+`)
	// What OCR and footnotes leave after a heading: "KARA KOS SULU 2",
	// "CONKIAJGHARUNA [8]", "THE TRICK OF THE FOX*", "… FATHER AND SON x".
	headingJunk = regexp.MustCompile(`(?:\s*(?:\[\d+\]|\*+|\b\d{1,3}\b|\bx\b|[.,;:?!]))+$`)
)

// headingKey is how SplitByTitles compares a listed title with a body
// line: lower case, whitespace runs collapsed, emphasis/quotes and
// trailing punctuation or footnote markers removed. Deliberately looser
// than normTitle — it is only ever used against an explicit,
// hand-checked title list, and every title must be found.
func headingKey(s string) string {
	s = strings.ToLower(spaceRun.ReplaceAllString(strings.TrimSpace(s), " "))
	for {
		prev := s
		s = headingJunk.ReplaceAllString(s, "")
		s = strings.Trim(stripEmphasis(s), "“”‘’")
		if s == prev {
			return s
		}
	}
}

// SplitByTitles splits body at an explicit list of headings (Book.Titles)
// instead of reading a CONTENTS block. The search starts at the first
// line beginning with start and stops at the first later line beginning
// with end (if end is non-empty); titles are found in order, each as a
// whole line or as a heading wrapped over two lines. Entries made with
// Cut end the previous tale but produce none themselves.
//
// It returns the titles it could not find; callers treat any missing
// title as a failure, since an explicit list is a promise about the
// book.
func SplitByTitles(body string, titles []string, start, end string) (tales []Tale, missing []string) {
	lines := strings.Split(body, "\n")
	from := findLinePrefix(lines, 0, start)
	if from < 0 {
		return nil, []string{"start marker " + start}
	}
	stop := len(lines)
	if end != "" {
		if i := findLinePrefix(lines, from+1, end); i >= 0 {
			stop = i
		} else {
			return nil, []string{"end marker " + end}
		}
	}

	type hit struct {
		title    string
		cut      bool
		at, body int // heading line, first line after the heading
	}
	var hits []hit
	for _, t := range titles {
		cut := strings.HasPrefix(t, CutPrefix)
		name := strings.TrimPrefix(t, CutPrefix)
		want := headingKey(name)
		found := false
		for i := from; i < stop; i++ {
			if headingKey(lines[i]) == want {
				hits = append(hits, hit{name, cut, i, i + 1})
				from, found = i+1, true
				break
			}
			// A wrapped heading: the next non-blank line, at most one
			// blank line further down (Eells' Brazil headings are
			// set as "Why the Tiger and the Stag" / "" / "Fear Each Other").
			j := i + 1
			if j < stop && strings.TrimSpace(lines[j]) == "" {
				j++
			}
			if strings.TrimSpace(lines[i]) != "" && j < stop && strings.TrimSpace(lines[j]) != "" &&
				headingKey(lines[i]+" "+lines[j]) == want {
				hits = append(hits, hit{name, cut, i, j + 1})
				from, found = j+1, true
				break
			}
		}
		if !found {
			missing = append(missing, name)
		}
	}

	for i, h := range hits {
		if h.cut {
			continue
		}
		e := stop
		if i+1 < len(hits) {
			e = hits[i+1].at
		}
		text := strings.TrimSpace(strings.Join(lines[h.body:e], "\n"))
		if text == "" {
			continue
		}
		tales = append(tales, Tale{Title: h.title, Text: text})
	}
	return tales, missing
}

func findLinePrefix(lines []string, from int, prefix string) int {
	p := strings.ToLower(spaceRun.ReplaceAllString(strings.TrimSpace(prefix), " "))
	for i := from; i < len(lines); i++ {
		l := strings.ToLower(spaceRun.ReplaceAllString(strings.TrimSpace(lines[i]), " "))
		if strings.HasPrefix(l, p) {
			return i
		}
	}
	return -1
}
