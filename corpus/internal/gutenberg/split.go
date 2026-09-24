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
	contentsHeading = regexp.MustCompile(`(?i)^contents\.?:?\s*$`)
	listPrefix      = regexp.MustCompile(`^\s*(?:[0-9]+|[IVXLCivxlc]+)\.\s*`)
	pageNumSuffix   = regexp.MustCompile(`\s{2,}[0-9]+\s*$`) // strips a trailing "...   21" page number some contents blocks append
)

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
		if contentsHeading.MatchString(strings.TrimSpace(line)) {
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
	for _, title := range candidates {
		if seen[title] {
			continue
		}
		for i := bodyStart; i < len(lines); i++ {
			if strings.EqualFold(strings.TrimSpace(lines[i]), title) {
				matches = append(matches, match{title: title, line: i})
				seen[title] = true
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
// line, i.e. an actual paragraph) or a run of blank lines, whichever
// comes first — that's where the contents block ends. It returns the
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
			if blankRun >= 4 {
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
		line = strings.TrimSpace(line)
		if line == "" {
			continue
		}
		titles = append(titles, line)
	}
	return titles, i
}
