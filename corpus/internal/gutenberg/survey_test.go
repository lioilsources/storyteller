package gutenberg

import (
	"fmt"
	"os"
	"path/filepath"
	"sort"
	"strings"
	"testing"
)

// TestSurvey is a manual tool, not a regression test: point SPLIT_SURVEY_DIR
// at a directory of raw Gutenberg .txt files (<id>.txt) and it prints how
// many tales SplitTales finds in each — how candidate books were triaged
// for the catalog on 2026-09-27.
//
//	SPLIT_SURVEY_DIR=/path/to/txt go test ./corpus/internal/gutenberg -run Survey -v
func TestSurvey(t *testing.T) {
	dir := os.Getenv("SPLIT_SURVEY_DIR")
	if dir == "" {
		t.Skip("SPLIT_SURVEY_DIR not set")
	}
	files, _ := filepath.Glob(filepath.Join(dir, "*.txt"))
	sort.Strings(files)
	for _, f := range files {
		raw, err := os.ReadFile(f)
		if err != nil {
			continue
		}
		title := HeaderTitle(string(raw))
		tales := SplitTales(StripBoilerplate(string(raw)), title)
		first := ""
		if len(tales) > 0 {
			first = tales[0].Title
		}
		fmt.Printf("SURVEY\t%s\t%d\t%s\t%s\n", strings.TrimSuffix(filepath.Base(f), ".txt"), len(tales), title, first)
	}
}
