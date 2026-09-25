// Package wikisource fetches public-domain fairy tales from Wikisource
// (STORYTELLER_PLAN.md §3.1). It exists because the Czech canon — Erben
// and Němcová — is not on Project Gutenberg at all: those texts live on
// cs.wikisource.org, which serves them through the MediaWiki API rather
// than as one big plain-text anthology.
//
// The practical consequence is that splitting works the other way round
// from `internal/gutenberg`: there is no CONTENTS block to parse,
// because each tale is already its own page. We enumerate subpages and
// fetch them one at a time.
package wikisource

// Source is one collection worth pulling motifs from.
//
// Either Prefix or Pages is set, never both:
//   - Prefix enumerates every subpage of a container page (Němcová's
//     "Národní Báchorky a Powěsti/…"), which is how Wikisource models a
//     multi-tale volume.
//   - Pages lists standalone pages that share no common parent, which is
//     how Erben's individual tales sit on cs.wikisource.
type Source struct {
	Collection string
	Title      string
	Author     string
	Lang       string

	// Country is the ISO-3166-1 alpha-2 code every tale in this source
	// comes from, when the whole collection shares one origin. Empty
	// means the collection is deliberately multi-country and the origin
	// has to be decided per tale (see MixedOrigin).
	Country string

	// MixedOrigin marks a collection that gathers tales from several
	// nations, so `rag.extract`'s KNOWN_COUNTRY override must NOT be
	// applied to it — the model has to attribute each tale itself.
	MixedOrigin bool

	Prefix string
	Pages  []string
}

// Catalog was verified on 2026-09-25 against the live cs.wikisource.org
// API: every Prefix was enumerated (26 / 115 / 5 subpages) and every
// entry in Pages was confirmed to exist. Titles are kept in Wikisource's
// own spelling, including the 19th-century orthography of "Národní
// Báchorky a Powěsti" — that is the actual page name, not a typo.
var Catalog = []Source{
	{
		Collection: "nemcova",
		Title:      "Národní Báchorky a Powěsti",
		Author:     "Božena Němcová",
		Lang:       "cs",
		Country:    "CZ",
		Prefix:     "Národní Báchorky a Powěsti/",
	},
	{
		Collection: "erben",
		Title:      "České pohádky (jednotlivé)",
		Author:     "Karel Jaromír Erben",
		Lang:       "cs",
		Country:    "CZ",
		// Erben's tales are not collected under one container page on
		// cs.wikisource; these are the prose fairy tales, deliberately
		// without the Kytice ballads (verse, and far too dark for this
		// app's purpose).
		Pages: []string{
			"Zlatovláska (Erben)",
			"Tři zlaté vlasy Děda-Vševěda",
			"Jirka s kozú",
			"Král tchoř",
			"Máj (almanach 1858)/Pták Ohnivák a liška Ryška",
		},
	},
	{
		Collection:  "erben-slovanske",
		Title:       "Vybrané báje a pověsti národní jiných větví slovanských",
		Author:      "Karel Jaromír Erben",
		Lang:        "cs",
		MixedOrigin: true, // Russian, Bulgarian, Serbian, Polish, Croatian…
		Prefix:      "Vybrané báje a pověsti národní jiných větví slovanských/",
	},
	{
		Collection: "nemcova-srbske",
		Title:      "Srbské pohádky",
		Author:     "Božena Němcová",
		Lang:       "cs",
		Country:    "RS",
		Prefix:     "Srbské pohádky/",
	},
}

// ByCollections filters the catalog; an empty set returns everything.
func ByCollections(names map[string]bool) []Source {
	if len(names) == 0 {
		return Catalog
	}
	var out []Source
	for _, s := range Catalog {
		if names[s.Collection] {
			out = append(out, s)
		}
	}
	return out
}
