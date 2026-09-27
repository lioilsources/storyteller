package gutenberg

import (
	"strings"
	"testing"
)

// The three contents-block shapes Gutenberg's fairy-tale volumes
// actually use, copied from the real fetched texts. All three were found
// by reading fetch output rather than by guessing, and two of them broke
// the splitter until 2026-09-25.
//
// Note the run of four blank lines between each contents block and the
// body: that gap is what actually ends the block (collectCandidateTitles
// stops at four), and it was measured in the real files — Grimm 2591,
// Olive 27826 and Lilac 28096 all use exactly four. Shorten it here and
// the collector reads on into the body, mistakes its short prose lines
// for titles, and the split silently degrades to the whole-book
// fallback. That is a genuine fragility of the heuristic, not a quirk of
// these fixtures.
const (
	// The original shape (Grimms' Fairy Tales, id 2591): bare heading,
	// one title per line.
	plainContents = `
CONTENTS

THE GOLDEN BIRD

HANS IN LUCK




THE GOLDEN BIRD

A certain king had a beautiful garden.

HANS IN LUCK

Some men are born to good luck.
`

	// Olive / Lilac Fairy Books (27826, 28096): heading and titles
	// italicised with underscores, and a PAGE column.
	emphasisedContents = `
_CONTENTS_

                                            PAGE

_Madschun_                                     1

_The Blue Parrot_                              9




_Madschun_

Once upon a time there lived a rich merchant.

_The Blue Parrot_

In a small town in Persia there lived a king.
`

	// Orange Fairy Book (3027): the contents block is reflowed into a
	// paragraph, so there are no per-title lines to read at all.
	reflowedContents = `
                   CONTENTS

The Story of the Hero Makoma The Magic Mirror Story of the King who
would see Paradise How Isuro the Rabbit tricked Gudu

       The Story of the Hero Makoma        From the Senna

Once upon a time, in the town of Senna, there lived a boy.
`
)

func TestSplitTalesPlainContents(t *testing.T) {
	tales := SplitTales(plainContents, "Grimms' Fairy Tales")
	if len(tales) != 2 {
		t.Fatalf("want 2 tales, got %d: %+v", len(tales), titlesOf(tales))
	}
	if tales[0].Title != "THE GOLDEN BIRD" {
		t.Errorf("first title = %q", tales[0].Title)
	}
	if !strings.Contains(tales[0].Text, "beautiful garden") {
		t.Errorf("first tale body wrong: %q", tales[0].Text)
	}
	if strings.Contains(tales[0].Text, "HANS IN LUCK") {
		t.Errorf("first tale ran into the second: %q", tales[0].Text)
	}
}

func TestSplitTalesUnderscoreEmphasis(t *testing.T) {
	// This is the Olive/Lilac regression: before stripEmphasis, neither
	// `_CONTENTS_` nor `_Madschun_` matched, and a 30-tale volume came
	// back as one blob.
	tales := SplitTales(emphasisedContents, "The Olive Fairy Book")
	if len(tales) != 2 {
		t.Fatalf("want 2 tales, got %d: %+v", len(tales), titlesOf(tales))
	}
	for i, want := range []string{"Madschun", "The Blue Parrot"} {
		if tales[i].Title != want {
			t.Errorf("tale %d title = %q, want %q (underscores must be stripped)", i, tales[i].Title, want)
		}
	}
	if !strings.Contains(tales[1].Text, "king") {
		t.Errorf("second tale body wrong: %q", tales[1].Text)
	}
}

func TestSplitTalesReflowedContentsFallsBackWhole(t *testing.T) {
	// The Orange Fairy Book is still unsplittable, and that is the
	// documented behaviour: return the whole book as one Tale rather
	// than invent boundaries. This test exists so that if someone later
	// teaches the splitter to handle reflowed contents, they notice this
	// expectation and update it deliberately.
	tales := SplitTales(reflowedContents, "The Orange Fairy Book")
	if len(tales) != 1 {
		t.Fatalf("want the whole-book fallback (1 tale), got %d: %+v", len(tales), titlesOf(tales))
	}
	if tales[0].Title != "The Orange Fairy Book" {
		t.Errorf("fallback should be titled after the book, got %q", tales[0].Title)
	}
}

func TestSplitTalesNoContentsFallsBackWhole(t *testing.T) {
	body := "Just some prose with no contents block at all.\n"
	tales := SplitTales(body, "Some Book")
	if len(tales) != 1 || tales[0].Title != "Some Book" {
		t.Fatalf("want whole-book fallback, got %+v", titlesOf(tales))
	}
	if !strings.Contains(tales[0].Text, "no contents block") {
		t.Error("fallback dropped the text")
	}
}

func TestStripEmphasis(t *testing.T) {
	cases := map[string]string{
		"_CONTENTS_":           "CONTENTS",
		"'_A Long-bow Story_'": "A Long-bow Story",
		"   _Madschun_   ":     "Madschun",
		"THE GOLDEN BIRD":      "THE GOLDEN BIRD",
		`"Quoted"`:             "Quoted",
		"*starred*":            "starred",
		"Mid_word_underscores": "Mid_word_underscores",
	}
	for in, want := range cases {
		if got := stripEmphasis(in); got != want {
			t.Errorf("stripEmphasis(%q) = %q, want %q", in, got, want)
		}
	}
}

func TestCheckTitleCatchesAWrongID(t *testing.T) {
	book := Book{ID: 503, Title: "The Blue Fairy Book", Collection: "lang"}

	ok := "Title: The Blue Fairy Book\nAuthor: Andrew Lang\n"
	if err := CheckTitle(book, ok); err != nil {
		t.Errorf("exact title should pass: %v", err)
	}

	// Gutenberg is inconsistent about apostrophes and subtitles, so the
	// comparison has to tolerate both.
	loose := "Title: The Blue Fairy Book, and Other Stories\n"
	if err := CheckTitle(book, loose); err != nil {
		t.Errorf("subtitle should still pass: %v", err)
	}

	wrong := "Title: The Red Fairy Book\nAuthor: Andrew Lang\n"
	if err := CheckTitle(book, wrong); err == nil {
		t.Error("a different book must be rejected — this is the guard against a mistyped catalog ID")
	}

	if err := CheckTitle(book, "no header here at all\n"); err == nil {
		t.Error("a file with no Title: header must be rejected")
	}
}

func TestCatalogHasNoDuplicateIDs(t *testing.T) {
	seen := map[int]string{}
	for _, b := range Catalog {
		if prev, dup := seen[b.ID]; dup {
			t.Errorf("id %d listed twice (%q and %q) — it would be fetched and extracted twice", b.ID, prev, b.Title)
		}
		seen[b.ID] = b.Title
	}
}

func titlesOf(tales []Tale) []string {
	out := make([]string, len(tales))
	for i, t := range tales {
		out[i] = t.Title
	}
	return out
}

func TestLenientContentsVariants(t *testing.T) {
	body := `TABLE OF CONTENTS

1  THE LION AND THE HARE ............ 3


2  How the Tortoise Won 11

XII. The Last Tale.
CIVIL WAR AT SEA  40

THE LION AND THE HARE.

The lion was hungry.

HOW THE TORTOISE WON

The tortoise was slow.

THE LAST TALE

The end.

CIVIL WAR AT SEA

Waves.
`
	tales := SplitTales(body, "book")
	var got []string
	for _, tl := range tales {
		got = append(got, tl.Title)
	}
	want := []string{"THE LION AND THE HARE", "How the Tortoise Won", "The Last Tale", "CIVIL WAR AT SEA"}
	if strings.Join(got, "|") != strings.Join(want, "|") {
		t.Fatalf("titles = %q, want %q", got, want)
	}
	if tales[0].Text != "The lion was hungry." {
		t.Fatalf("first tale text = %q", tales[0].Text)
	}
}
