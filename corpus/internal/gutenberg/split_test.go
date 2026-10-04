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
	seen := map[string]string{}
	for _, b := range Catalog {
		if prev, dup := seen[b.Key()]; dup {
			t.Errorf("id %s listed twice (%q and %q) — it would be fetched and extracted twice", b.Key(), prev, b.Title)
		}
		seen[b.Key()] = b.Title
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

// Shapes SplitByTitles has to cope with, taken from the wave-2 books
// (2026-10-04): a contents listing that must not match (Start skips it),
// footnote and OCR debris after a heading (Georgian 44536, Coxwell), a
// heading wrapped over two lines with a blank between (Eells 24714), a
// notes block cut out between tales, and an End marker.
const titledBook = `
CONTENTS
  THE FROG'S SKIN        15
  KARA KOS SULU          22

PART I

THE FROG'S SKIN [8]

There were once three brothers.

KARA KOS SULU 2

A certain khan was served by a vizier.

NOTES.

Footnote prose that belongs to no tale.

Why the Tiger and the Stag

Fear Each Other

Once upon a time there was a stag.

THE END

Transcriber's notes.
`

func TestSplitByTitles(t *testing.T) {
	titles := []string{"The Frog's Skin", "Kara Kos Sulu", Cut("Notes"), "Why the Tiger and the Stag Fear Each Other"}
	tales, missing := SplitByTitles(titledBook, titles, "PART I", "THE END")
	if len(missing) > 0 {
		t.Fatalf("missing %q", missing)
	}
	want := []Tale{
		{"The Frog's Skin", "There were once three brothers."},
		{"Kara Kos Sulu", "A certain khan was served by a vizier."},
		{"Why the Tiger and the Stag Fear Each Other", "Once upon a time there was a stag."},
	}
	if len(tales) != len(want) {
		t.Fatalf("got %d tales, want %d: %+v", len(tales), len(want), tales)
	}
	for i := range want {
		if tales[i] != want[i] {
			t.Errorf("tale %d = %+v, want %+v", i, tales[i], want[i])
		}
	}
}

func TestSplitByTitlesReportsMissing(t *testing.T) {
	_, missing := SplitByTitles(titledBook, []string{"The Frog's Skin", "The Golden Maiden"}, "PART I", "")
	if len(missing) != 1 || missing[0] != "The Golden Maiden" {
		t.Fatalf("missing = %q, want [The Golden Maiden]", missing)
	}
	if _, missing := SplitByTitles(titledBook, []string{"The Frog's Skin"}, "NO SUCH START", ""); len(missing) != 1 {
		t.Fatalf("an absent Start marker must be reported, got %q", missing)
	}
}

func TestSplitByTitlesSkipsContents(t *testing.T) {
	// Without Start past the contents, "KARA KOS SULU 22" in the listing
	// would match first — that is why Start is required with Titles.
	tales, _ := SplitByTitles(titledBook, []string{"The Frog's Skin", "Kara Kos Sulu"}, "PART I", "NOTES")
	if len(tales) != 2 || !strings.HasPrefix(tales[0].Text, "There were once") {
		t.Fatalf("got %+v", tales)
	}
}
