// Package gutenberg fetches and splits public-domain fairy tale
// anthologies from Project Gutenberg (STORYTELLER_PLAN.md §3.1).
package gutenberg

// Book is one Project Gutenberg ebook worth pulling motifs from.
// Collection groups related volumes (e.g. all four Lang "Fairy Books")
// so fetched files land in one subdirectory.
type Book struct {
	ID         int
	Title      string
	Author     string
	Collection string
}

// Catalog IDs are verified, not guessed: every entry's expected Title
// below was checked against the "Title:" header of the actual fetched
// text — the original nine by hand on 2026-09-24, the eight Lang volumes
// added on 2026-09-25 by enumerating Lang's Gutenberg author page (author
// id 79) and reading each candidate's header. `Fetch` now re-checks the
// header on every run, so a wrong or re-numbered ID fails loudly instead
// of silently saving the wrong book.
//
// Lang's twelve "coloured fairy books" are the reason this catalog is
// worth having: unlike Grimm (all German) or Andersen (all Danish), each
// Lang volume gathers tales from a dozen different nations, which is what
// the globe (§1.1b) needs before most of the planet stops being grey.
// Note the flip side — their origin cannot be assigned per collection,
// only per tale, so `rag.extract`'s KNOWN_COUNTRY override must not be
// applied to them.
var Catalog = []Book{
	{ID: 2591, Title: "Grimms' Fairy Tales", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 5314, Title: "Household Tales by Brothers Grimm", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 1597, Title: "Andersen's Fairy Tales", Author: "Hans Christian Andersen", Collection: "andersen"},
	{ID: 29021, Title: "The Fairy Tales of Charles Perrault", Author: "Charles Perrault", Collection: "perrault"},

	// Lang, all twelve volumes.
	{ID: 503, Title: "The Blue Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 540, Title: "The Red Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 7277, Title: "The Green Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 640, Title: "The Yellow Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 5615, Title: "The Pink Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 6746, Title: "The Grey Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 641, Title: "The Violet Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 2435, Title: "The Crimson Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 3282, Title: "The Brown Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 3027, Title: "The Orange Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 27826, Title: "The Olive Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 28096, Title: "The Lilac Fairy Book", Author: "Andrew Lang", Collection: "lang"},

	// Aesop stays at one edition on purpose. Gutenberg carries several
	// translations of the same ~300 fables; adding them would duplicate
	// the corpus and burn LLM time re-extracting tales we already have.
	{ID: 21, Title: "Three Hundred Aesop's Fables", Author: "Aesop (trans. Townsend)", Collection: "aesop"},
}

// ByCollections filters the catalog; an empty set returns everything.
func ByCollections(names map[string]bool) []Book {
	if len(names) == 0 {
		return Catalog
	}
	var out []Book
	for _, b := range Catalog {
		if names[b.Collection] {
			out = append(out, b)
		}
	}
	return out
}
