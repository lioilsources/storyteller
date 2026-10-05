package gutenberg

import (
	"regexp"
	"strings"
	"testing"
)

var isoCountry = regexp.MustCompile(`^[A-Z]{2}$`)

// The catalog is data, but data the fetcher trusts blindly; these are
// the invariants whose violation would only show up much later, as a
// wrong or silently missing tale.
func TestCatalogInvariants(t *testing.T) {
	for _, b := range Catalog {
		name := b.Collection + "/" + b.Key()
		if b.Lang == "" {
			t.Errorf("%s: no Lang — the pipeline must know what language it reads", name)
		}
		if b.Archive != nil {
			if b.ID != 0 {
				t.Errorf("%s: Archive book with a Gutenberg ID", name)
			}
			if b.License == "" {
				t.Errorf("%s: Archive book without License (no PG header vouches for it)", name)
			}
			if b.Archive.ID == "" || b.Archive.File == "" {
				t.Errorf("%s: Archive needs both ID and File", name)
			}
			if len(b.Titles) == 0 {
				t.Errorf("%s: Archive (OCR) books must use explicit Titles", name)
			}
		} else if b.ID <= 0 {
			t.Errorf("%s: no Gutenberg ID", name)
		}
		if len(b.Titles) > 0 && b.Start == "" {
			t.Errorf("%s: Titles without Start would match the contents listing", name)
		}
		listed := map[string]bool{}
		for _, title := range b.Titles {
			if !strings.HasPrefix(title, CutPrefix) {
				listed[title] = true
			}
		}
		for title, cc := range b.TaleCountry {
			if !listed[title] {
				t.Errorf("%s: TaleCountry %q is not one of its Titles", name, title)
			}
			if !isoCountry.MatchString(cc) {
				t.Errorf("%s: TaleCountry %q = %q is not ISO 3166-1 alpha-2", name, title, cc)
			}
		}
	}
}
