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

// Catalog was hand-verified on 2026-09-24 by fetching each book's text
// and checking its "Title:" header against the expected title — see
// corpus/README.md. IDs on gutenberg.org are stable, but re-verify if a
// fetch ever comes back with an unexpected title.
var Catalog = []Book{
	{ID: 2591, Title: "Grimms' Fairy Tales", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 5314, Title: "Household Tales by Brothers Grimm", Author: "Jacob & Wilhelm Grimm", Collection: "grimm"},
	{ID: 1597, Title: "Andersen's Fairy Tales", Author: "Hans Christian Andersen", Collection: "andersen"},
	{ID: 29021, Title: "The Fairy Tales of Charles Perrault", Author: "Charles Perrault", Collection: "perrault"},
	{ID: 503, Title: "The Blue Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 540, Title: "The Red Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 7277, Title: "The Green Fairy Book", Author: "Andrew Lang", Collection: "lang"},
	{ID: 640, Title: "The Yellow Fairy Book", Author: "Andrew Lang", Collection: "lang"},
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
