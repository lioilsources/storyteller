package wikisource

import (
	"strings"
	"testing"
)

// The fragments below are trimmed from the real API response for
// "Národní Báchorky a Powěsti/Chytrá horákyně" (cs.wikisource.org,
// action=parse&prop=text, fetched 2026-09-25). Keeping real markup here
// rather than invented HTML is the point: these tests exist to catch
// Wikisource changing its apparatus, and invented markup would pass
// happily while the live pages broke.
const realPageFragment = `<div class="mw-content-ltr mw-parser-output" lang="cs" dir="ltr"><table class="navigacePaP toccolours ws-noexport">
<tbody><tr>
<td colspan="3"><b><a href="/wiki/N%C3%A1rodn%C3%AD_B%C3%A1chorky_a_Pow%C4%9Bsti">Národní Báchorky a Powěsti</a></b><br /><i><a href="/wiki/Autor:Bo%C5%BEena_N%C4%9Bmcov%C3%A1">Božena Němcová</a></i>
</td></tr>
<tr>
<td class="pre"><a href="/wiki/Kdo_je_hloup%C4%9Bj%C5%A1%C3%AD">Kdo je hloupější</a>
</td>
<td class="act"><b>Chytrá horákyně</b>
</td></tr></tbody></table>
<table class="textinfo wikitable rightbox">
<tbody><tr><th colspan="2">Údaje o&#160;textu</th></tr><tr>
<td>Titulek:</td>
<td id="ws-title">Chytrá horákyně</td>
</tr><tr>
<td>Licence:</td>
<td id="ws-license">PD old 70</td>
</tr></tbody></table>
<p>Byl jeden chudý člověk a ten měl dceru.<sup class="reference">[1]</sup>
</p>
<p>„Co tu chceš?“ optal se ho pán.
</p>
<div class="reflist"><p>1. Vysvětlivka editora.</p></div>
</div>`

func TestPlainTextKeepsProseAndDropsApparatus(t *testing.T) {
	got, err := PlainText(realPageFragment)
	if err != nil {
		t.Fatalf("PlainText: %v", err)
	}

	for _, want := range []string{
		"Byl jeden chudý člověk a ten měl dceru.",
		"„Co tu chceš?“ optal se ho pán.",
	} {
		if !strings.Contains(got, want) {
			t.Errorf("prose missing from output: %q\ngot:\n%s", want, got)
		}
	}

	// Everything below is apparatus. Any of it reaching `rag.extract`
	// would show up as a "character" called Božena Němcová or a motif
	// about licensing.
	for _, unwanted := range []string{
		"Božena Němcová",
		"Kdo je hloupější",
		"Údaje o",
		"PD old 70",
		"Titulek",
		"[1]",         // the footnote marker
		"Vysvětlivka", // the footnote body
	} {
		if strings.Contains(got, unwanted) {
			t.Errorf("apparatus leaked into output: %q\ngot:\n%s", unwanted, got)
		}
	}
}

func TestPlainTextSeparatesParagraphsWithBlankLines(t *testing.T) {
	// rag.extract splits on paragraph boundaries, so two sentences that
	// were separate <p>s must not end up glued into one line.
	got, err := PlainText(`<div><p>První odstavec.</p><p>Druhý odstavec.</p></div>`)
	if err != nil {
		t.Fatalf("PlainText: %v", err)
	}
	if !strings.Contains(got, "První odstavec.\n\nDruhý odstavec.") {
		t.Errorf("paragraphs not separated by a blank line, got %q", got)
	}
}

func TestPlainTextKeepsLineBreaksInVerse(t *testing.T) {
	// Several Erben pages are verse, rendered with <br/>; collapsing
	// those would turn a poem into one long line.
	got, err := PlainText(`<div class="poem"><p>Hoj, ty Štědrý večere,<br/>ty tajemný svátku!</p></div>`)
	if err != nil {
		t.Fatalf("PlainText: %v", err)
	}
	if !strings.Contains(got, "Hoj, ty Štědrý večere,\nty tajemný svátku!") {
		t.Errorf("verse line break lost, got %q", got)
	}
}

func TestPlainTextCollapsesBlankRuns(t *testing.T) {
	got, err := PlainText(`<div><p>A.</p><div></div><div></div><p>B.</p></div>`)
	if err != nil {
		t.Fatalf("PlainText: %v", err)
	}
	if strings.Contains(got, "\n\n\n") {
		t.Errorf("more than one blank line survived, got %q", got)
	}
}

func TestPlainTextNormalizesNonBreakingSpace(t *testing.T) {
	got, err := PlainText("<p>v roce</p>")
	if err != nil {
		t.Fatalf("PlainText: %v", err)
	}
	if strings.Contains(got, " ") {
		t.Errorf("non-breaking space survived, got %q", got)
	}
	if !strings.Contains(got, "v roce") {
		t.Errorf("expected a plain space, got %q", got)
	}
}

func TestCatalogIsCoherent(t *testing.T) {
	seen := map[string]bool{}
	for _, s := range Catalog {
		if seen[s.Collection] {
			t.Errorf("duplicate collection %q — the two would write into the same directory", s.Collection)
		}
		seen[s.Collection] = true

		if (s.Prefix == "") == (len(s.Pages) == 0) {
			t.Errorf("%s: set exactly one of Prefix or Pages", s.Collection)
		}
		if s.Lang == "" {
			t.Errorf("%s: Lang is required — it picks the Wikisource host", s.Collection)
		}
		// A single-country collection carries its origin; a mixed one
		// must not, or `rag.extract` would blanket-tag foreign tales.
		if s.MixedOrigin && s.Country != "" {
			t.Errorf("%s: MixedOrigin collections must not claim a Country (has %q)", s.Collection, s.Country)
		}
		if !s.MixedOrigin && len(s.Country) != 2 {
			t.Errorf("%s: want a 2-letter ISO country code, got %q", s.Collection, s.Country)
		}
	}
}
