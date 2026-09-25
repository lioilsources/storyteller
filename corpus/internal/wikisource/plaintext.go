package wikisource

import (
	"strings"

	"golang.org/x/net/html"
	"golang.org/x/net/html/atom"
)

// dropClasses are the classes Wikisource itself uses to mark things that
// are not part of the work: `ws-noexport` is their own convention for
// navigation and apparatus, and the rest is MediaWiki chrome.
var dropClasses = []string{
	"ws-noexport", // prev/next navigation, header boxes
	"reference",   // footnote markers, e.g. [1]
	"reflist",     // the footnote list itself
	"mw-editsection",
	"noprint",
	"navigacePaP", // the per-volume navigation table
	"textinfo",    // the "Údaje o textu" metadata box
}

// PlainText reduces one MediaWiki-rendered HTML fragment to the prose a
// language model should see.
//
// Two decisions worth knowing. First, every <table> is dropped whole:
// on these pages tables are always apparatus (navigation, the "Údaje o
// textu" box), never part of the tale, and keeping them would feed the
// extractor the author's name and licence text as if it were story. If a
// tale ever genuinely contains a table this will silently eat it — the
// tradeoff is deliberate and worth revisiting if a tale comes back
// suspiciously short. Second, block elements become blank lines rather
// than single newlines, because `rag.extract` splits on paragraphs.
func PlainText(fragment string) (string, error) {
	doc, err := html.Parse(strings.NewReader(fragment))
	if err != nil {
		return "", err
	}
	var b strings.Builder
	walk(doc, &b)
	return tidy(b.String()), nil
}

func walk(n *html.Node, b *strings.Builder) {
	if n.Type == html.ElementNode {
		switch n.DataAtom {
		case atom.Table, atom.Style, atom.Script, atom.Sup:
			return
		}
		if hasDroppedClass(n) {
			return
		}
	}
	if n.Type == html.TextNode {
		b.WriteString(n.Data)
	}
	if n.Type == html.ElementNode && n.DataAtom == atom.Br {
		b.WriteString("\n")
	}

	for c := n.FirstChild; c != nil; c = c.NextSibling {
		walk(c, b)
	}

	if n.Type == html.ElementNode && isBlock(n.DataAtom) {
		b.WriteString("\n\n")
	}
}

func isBlock(a atom.Atom) bool {
	switch a {
	case atom.P, atom.Div, atom.H1, atom.H2, atom.H3, atom.H4, atom.H5, atom.H6,
		atom.Li, atom.Blockquote, atom.Pre, atom.Hr, atom.Section:
		return true
	}
	return false
}

func hasDroppedClass(n *html.Node) bool {
	for _, attr := range n.Attr {
		if attr.Key != "class" {
			continue
		}
		for _, cls := range strings.Fields(attr.Val) {
			for _, drop := range dropClasses {
				if cls == drop {
					return true
				}
			}
		}
	}
	return false
}

// tidy collapses the whitespace the walk leaves behind: trailing spaces
// on every line, and runs of blank lines down to one.
func tidy(s string) string {
	s = strings.ReplaceAll(s, " ", " ") // non-breaking spaces are everywhere in wikitext
	lines := strings.Split(s, "\n")
	out := make([]string, 0, len(lines))
	blank := 0
	for _, ln := range lines {
		ln = strings.TrimRight(ln, " \t")
		if strings.TrimSpace(ln) == "" {
			blank++
			if blank > 1 {
				continue
			}
			out = append(out, "")
			continue
		}
		blank = 0
		out = append(out, ln)
	}
	return strings.TrimSpace(strings.Join(out, "\n")) + "\n"
}
