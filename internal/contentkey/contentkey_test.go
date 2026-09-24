package contentkey

import (
	"bytes"
	"encoding/json"
	"flag"
	"math"
	"os"
	"path/filepath"
	"strings"
	"testing"
)

// -update regenerates testdata/golden.json from goldenCases. Run it only
// when the canonical format changes on purpose (bump the version string
// too); the Dart port's tests read the same file.
var update = flag.Bool("update", false, "rewrite testdata/golden.json")

type goldenCase struct {
	Name     string         `json:"name"`
	Kind     string         `json:"kind"`
	ModelVer string         `json:"model_ver"`
	Style    string         `json:"style"`
	Lang     string         `json:"lang"`
	Variant  int            `json:"variant"`
	Inputs   map[string]any `json:"inputs"`
	Preimage string         `json:"preimage"`
	Key      string         `json:"key"`
	Seed     int64          `json:"seed"`
}

// goldenCases are the cross-language contract. Each one pins a specific
// rule from the package doc so a divergence in either port points at
// the rule that broke.
var goldenCases = []goldenCase{
	{
		Name: "minimal", Kind: "hint", Lang: "cs",
		Inputs: map[string]any{},
	},
	{
		Name: "scene_image_basic", Kind: "scene_image", ModelVer: "flux-schnell@2025-06", Style: "watercolor", Lang: "cs",
		Inputs: map[string]any{
			"motif_id":       "grimm-2591-012",
			"environment_id": "forest",
			"phase":          "problem",
		},
	},
	{
		Name: "key_order_irrelevant_and_nested", Kind: "outline", ModelVer: "qwen3-4b", Lang: "en",
		Inputs: map[string]any{
			"zeta":  "last",
			"alpha": "first",
			"nested": map[string]any{
				"b": []any{"x", "y"},
				"a": 1,
			},
		},
	},
	{
		Name: "whitespace_and_case_normalized", Kind: "  Creature_SFX ", ModelVer: "Stable-Audio-Open", Style: " Paper  Collage ", Lang: "CS",
		Inputs: map[string]any{
			"creature_id": "  Liška   Bystruška\t",
			"tags":        []string{"Les", "  noc "},
		},
	},
	{
		Name: "nulls_and_empty_strings_dropped", Kind: "translation", Lang: "de",
		Inputs: map[string]any{
			"text_id":  "country.cz.blurb",
			"optional": nil,
			"blank":    "   ",
			"present":  true,
		},
	},
	{
		Name: "integers_and_bools", Kind: "daily_offer", Lang: "pl", Variant: 2,
		Inputs: map[string]any{
			"family_seed": int64(7548411916387868393),
			"day":         20260924,
			"count":       float64(3), // JSON-decoded numbers arrive as float64
			"soft":        false,
			"neg":         -1,
		},
	},
	{
		Name: "escaping", Kind: "hint", Lang: "en",
		Inputs: map[string]any{
			"quote":     `say "hi" \ bye`,
			"html":      "<a & b>",
			"unicode":   "žluťoučký kůň — 🦊",
			"newline":   "line1\nline2",
			"list_null": []any{nil, "x"},
		},
	},
}

func TestGolden(t *testing.T) {
	path := filepath.Join("testdata", "golden.json")

	if *update {
		out := make([]goldenCase, 0, len(goldenCases))
		for _, c := range goldenCases {
			r := toRequest(c)
			pre, err := Preimage(r)
			if err != nil {
				t.Fatalf("%s: preimage: %v", c.Name, err)
			}
			key, err := Key(r)
			if err != nil {
				t.Fatalf("%s: key: %v", c.Name, err)
			}
			seed, err := Seed(key)
			if err != nil {
				t.Fatalf("%s: seed: %v", c.Name, err)
			}
			c.Preimage, c.Key, c.Seed = pre, key, seed
			out = append(out, c)
		}
		buf, err := json.MarshalIndent(out, "", "  ")
		if err != nil {
			t.Fatal(err)
		}
		if err := os.MkdirAll("testdata", 0o755); err != nil {
			t.Fatal(err)
		}
		if err := os.WriteFile(path, append(buf, '\n'), 0o644); err != nil {
			t.Fatal(err)
		}
		t.Logf("wrote %d cases to %s", len(out), path)
	}

	buf, err := os.ReadFile(path)
	if err != nil {
		t.Fatalf("read golden (run with -update to create): %v", err)
	}
	// UseNumber: a 19-digit family_seed would otherwise come back as a
	// float64 and lose precision — exactly what the gateway must also do
	// when decoding request bodies.
	dec := json.NewDecoder(bytes.NewReader(buf))
	dec.UseNumber()
	var cases []goldenCase
	if err := dec.Decode(&cases); err != nil {
		t.Fatal(err)
	}
	if len(cases) != len(goldenCases) {
		t.Fatalf("golden.json has %d cases, source has %d — run -update", len(cases), len(goldenCases))
	}

	for _, c := range cases {
		t.Run(c.Name, func(t *testing.T) {
			r := toRequest(c)
			pre, err := Preimage(r)
			if err != nil {
				t.Fatalf("preimage: %v", err)
			}
			if pre != c.Preimage {
				t.Errorf("preimage mismatch\n got: %q\nwant: %q", pre, c.Preimage)
			}
			key, err := Key(r)
			if err != nil {
				t.Fatalf("key: %v", err)
			}
			if key != c.Key {
				t.Errorf("key mismatch\n got: %s\nwant: %s", key, c.Key)
			}
			seed, err := Seed(key)
			if err != nil {
				t.Fatalf("seed: %v", err)
			}
			if seed != c.Seed {
				t.Errorf("seed mismatch: got %d want %d", seed, c.Seed)
			}
		})
	}
}

func toRequest(c goldenCase) Request {
	return Request{Kind: c.Kind, ModelVer: c.ModelVer, Style: c.Style, Lang: c.Lang, Variant: c.Variant, Inputs: c.Inputs}
}

func TestKeyOrderIndependent(t *testing.T) {
	a := Request{Kind: "x", Lang: "en", Inputs: map[string]any{"a": 1, "b": 2, "c": []any{"p", "q"}}}
	b := Request{Kind: "x", Lang: "en", Inputs: map[string]any{"c": []any{"p", "q"}, "b": 2, "a": 1}}
	ka, _ := Key(a)
	kb, _ := Key(b)
	if ka != kb {
		t.Fatalf("map insertion order changed the key: %s vs %s", ka, kb)
	}
}

func TestArrayOrderMatters(t *testing.T) {
	a := Request{Kind: "x", Lang: "en", Inputs: map[string]any{"tags": []string{"a", "b"}}}
	b := Request{Kind: "x", Lang: "en", Inputs: map[string]any{"tags": []string{"b", "a"}}}
	ka, _ := Key(a)
	kb, _ := Key(b)
	if ka == kb {
		t.Fatal("array order is supposed to be significant")
	}
}

func TestVariantChangesKeyAndSeed(t *testing.T) {
	base := Request{Kind: "scene_image", Lang: "cs", Inputs: map[string]any{"m": "1"}}
	k0, _ := Key(base)
	base.Variant = 1
	k1, _ := Key(base)
	if k0 == k1 {
		t.Fatal("variant must change the key")
	}
	s0, _ := Seed(k0)
	s1, _ := Seed(k1)
	if s0 == s1 {
		t.Fatal("different keys produced the same seed (astronomically unlikely — check Seed)")
	}
	if s0 < 0 || s1 < 0 {
		t.Fatal("seed must be non-negative")
	}
}

func TestModelVerRollsKeysForward(t *testing.T) {
	a := Request{Kind: "scene_image", ModelVer: "flux-schnell@2025-06", Lang: "cs", Inputs: map[string]any{"m": "1"}}
	b := a
	b.ModelVer = "flux-schnell@2026-01"
	ka, _ := Key(a)
	kb, _ := Key(b)
	if ka == kb {
		t.Fatal("model_ver must be part of the key (OFFLINE_PLAN §2.5)")
	}
}

func TestRejects(t *testing.T) {
	cases := map[string]Request{
		"missing kind":      {Lang: "en"},
		"missing lang":      {Kind: "x"},
		"non-integral":      {Kind: "x", Lang: "en", Inputs: map[string]any{"n": 1.5}},
		"NaN":               {Kind: "x", Lang: "en", Inputs: map[string]any{"n": math.NaN()}},
		"uppercase key":     {Kind: "x", Lang: "en", Inputs: map[string]any{"MotifId": "1"}},
		"dashed key":        {Kind: "x", Lang: "en", Inputs: map[string]any{"motif-id": "1"}},
		"non-ascii key":     {Kind: "x", Lang: "en", Inputs: map[string]any{"klíč": "1"}},
		"unsupported value": {Kind: "x", Lang: "en", Inputs: map[string]any{"v": struct{}{}}},
		"nested bad key":    {Kind: "x", Lang: "en", Inputs: map[string]any{"ok": map[string]any{"Bad": 1}}},
	}
	for name, r := range cases {
		t.Run(name, func(t *testing.T) {
			if _, err := Key(r); err == nil {
				t.Fatalf("expected an error")
			}
		})
	}
}

func TestSeedValidation(t *testing.T) {
	if _, err := Seed("abc"); err == nil {
		t.Fatal("short key should error")
	}
	if _, err := Seed(strings.Repeat("zz", 32)); err == nil {
		t.Fatal("non-hex key should error")
	}
}

func TestAssetPath(t *testing.T) {
	key := strings.Repeat("ab", 32)
	got := AssetPath("Scene_Image", key, ".webp")
	want := "assets/scene_image/ab/" + key + ".webp"
	if got != want {
		t.Fatalf("got %s want %s", got, want)
	}
}

func TestNormalizeWhitespaceSet(t *testing.T) {
	// NBSP, NEL, ideographic space, BOM — all collapse like ASCII space.
	in := string([]rune{0x00a0, 'a', 0x0085, 'b', 0x3000, 'c', 0xfeff, 'd', 0x2003, 'e'})
	if got := Normalize(in); got != "a b c d e" {
		t.Fatalf("got %q", got)
	}
}
