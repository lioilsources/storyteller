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
// when the canonical format changes on purpose (bump the version
// strings too); the Dart port's tests read the same file.
var update = flag.Bool("update", false, "rewrite testdata/golden.json")

type goldenCase struct {
	Name            string         `json:"name"`
	Kind            string         `json:"kind"`
	Lang            string         `json:"lang"`
	Inputs          map[string]any `json:"inputs"`
	ModelID         string         `json:"model_id"`
	StyleID         string         `json:"style_id"`
	ModelVer        string         `json:"model_ver"`
	BasePreimage    string         `json:"base_preimage"`
	KeyBase         string         `json:"key_base"`
	VariantPreimage string         `json:"variant_preimage"`
	Key             string         `json:"key"`
	Seed            int64          `json:"seed"`
}

// goldenCases are the cross-language contract. Each one pins a specific
// rule from the package doc so a divergence in either port points at
// the rule that broke.
var goldenCases = []goldenCase{
	{
		Name: "minimal", Kind: "hint", Lang: "cs", ModelID: "qwen3-4b",
		Inputs: map[string]any{},
	},
	{
		Name: "scene_image_tier0", Kind: "scene_image", Lang: "cs",
		ModelID: "flux-schnell", StyleID: "watercolor", ModelVer: "a1b2c3d",
		Inputs: map[string]any{
			"motif_id":       "grimm-2591-012",
			"environment_id": "cz-forest",
			"phase":          "problem",
		},
	},
	{
		// Same content as above, different model — key_base and seed must
		// be identical, key must differ (MODELS_PLAN §0.1, §2).
		Name: "scene_image_tier1_same_base", Kind: "scene_image", Lang: "cs",
		ModelID: "flux-dev", StyleID: "watercolor", ModelVer: "e4f5a6b",
		Inputs: map[string]any{
			"motif_id":       "grimm-2591-012",
			"environment_id": "cz-forest",
			"phase":          "problem",
		},
	},
	{
		Name: "key_order_irrelevant_and_nested", Kind: "outline", Lang: "en", ModelID: "qwen3-4b",
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
		Name: "whitespace_and_case_normalized", Kind: "  Creature_SFX ", Lang: "CS",
		ModelID: " Stable-Audio-Open ", StyleID: " Paper  Collage ", ModelVer: "V1",
		Inputs: map[string]any{
			"creature_id": "  Liška   Bystruška\t",
			"tags":        []string{"Les", "  noc "},
		},
	},
	{
		Name: "nulls_and_empty_strings_dropped", Kind: "translation", Lang: "de", ModelID: "qwen3-4b",
		Inputs: map[string]any{
			"text_id":  "country.cz.blurb",
			"optional": nil,
			"blank":    "   ",
			"present":  true,
		},
	},
	{
		Name: "integers_and_bools", Kind: "daily_offer", Lang: "pl", ModelID: "qwen3-4b",
		Inputs: map[string]any{
			"family_seed": int64(7548411916387868393),
			"day":         20260924,
			"count":       float64(3), // JSON-decoded numbers arrive as float64
			"soft":        false,
			"neg":         -1,
		},
	},
	{
		Name: "escaping", Kind: "hint", Lang: "en", ModelID: "qwen3-4b",
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
			b, v := toBase(c), toVariant(c)
			var err error
			if c.BasePreimage, err = BasePreimage(b); err != nil {
				t.Fatalf("%s: base preimage: %v", c.Name, err)
			}
			if c.KeyBase, err = KeyBase(b); err != nil {
				t.Fatalf("%s: key_base: %v", c.Name, err)
			}
			if c.VariantPreimage, err = VariantPreimage(c.KeyBase, v); err != nil {
				t.Fatalf("%s: variant preimage: %v", c.Name, err)
			}
			if c.Key, err = VariantKey(c.KeyBase, v); err != nil {
				t.Fatalf("%s: key: %v", c.Name, err)
			}
			if c.Seed, err = Seed(c.KeyBase); err != nil {
				t.Fatalf("%s: seed: %v", c.Name, err)
			}
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
			b, v := toBase(c), toVariant(c)
			bp, err := BasePreimage(b)
			if err != nil {
				t.Fatalf("base preimage: %v", err)
			}
			if bp != c.BasePreimage {
				t.Errorf("base preimage mismatch\n got: %q\nwant: %q", bp, c.BasePreimage)
			}
			keyBase, key, err := Key(b, v)
			if err != nil {
				t.Fatalf("key: %v", err)
			}
			if keyBase != c.KeyBase {
				t.Errorf("key_base mismatch\n got: %s\nwant: %s", keyBase, c.KeyBase)
			}
			vp, _ := VariantPreimage(keyBase, v)
			if vp != c.VariantPreimage {
				t.Errorf("variant preimage mismatch\n got: %q\nwant: %q", vp, c.VariantPreimage)
			}
			if key != c.Key {
				t.Errorf("key mismatch\n got: %s\nwant: %s", key, c.Key)
			}
			seed, err := Seed(keyBase)
			if err != nil {
				t.Fatalf("seed: %v", err)
			}
			if seed != c.Seed {
				t.Errorf("seed mismatch: got %d want %d", seed, c.Seed)
			}
		})
	}
}

func toBase(c goldenCase) Base {
	return Base{Kind: c.Kind, Lang: c.Lang, Inputs: c.Inputs}
}

func toVariant(c goldenCase) Variant {
	return Variant{ModelID: c.ModelID, StyleID: c.StyleID, ModelVer: c.ModelVer}
}

func TestVariantsShareBaseAndSeed(t *testing.T) {
	base := Base{Kind: "scene_image", Lang: "cs", Inputs: map[string]any{"motif_id": "m1"}}
	kb0, k0, err := Key(base, Variant{ModelID: "flux-schnell", StyleID: "watercolor", ModelVer: "a"})
	if err != nil {
		t.Fatal(err)
	}
	kb1, k1, err := Key(base, Variant{ModelID: "flux-dev", StyleID: "watercolor", ModelVer: "b"})
	if err != nil {
		t.Fatal(err)
	}
	if kb0 != kb1 {
		t.Fatalf("same content must have the same key_base")
	}
	if k0 == k1 {
		t.Fatalf("different model must give a different variant key")
	}
	s0, _ := Seed(kb0)
	s1, _ := Seed(kb1)
	if s0 != s1 || s0 < 0 {
		t.Fatalf("seed must be derived from key_base and shared: %d vs %d", s0, s1)
	}
}

func TestEachVariantFieldMatters(t *testing.T) {
	kb := strings.Repeat("ab", 32)
	ref := Variant{ModelID: "flux-dev", StyleID: "watercolor", ModelVer: "v1"}
	k, _ := VariantKey(kb, ref)
	for name, v := range map[string]Variant{
		"model":     {ModelID: "flux-schnell", StyleID: "watercolor", ModelVer: "v1"},
		"style":     {ModelID: "flux-dev", StyleID: "papercut", ModelVer: "v1"},
		"model_ver": {ModelID: "flux-dev", StyleID: "watercolor", ModelVer: "v2"},
	} {
		k2, _ := VariantKey(kb, v)
		if k2 == k {
			t.Errorf("changing %s did not change the key", name)
		}
	}
}

func TestKeyOrderIndependent(t *testing.T) {
	a := Base{Kind: "x", Lang: "en", Inputs: map[string]any{"a": 1, "b": 2, "c": []any{"p", "q"}}}
	b := Base{Kind: "x", Lang: "en", Inputs: map[string]any{"c": []any{"p", "q"}, "b": 2, "a": 1}}
	ka, _ := KeyBase(a)
	kb, _ := KeyBase(b)
	if ka != kb {
		t.Fatalf("map insertion order changed the key: %s vs %s", ka, kb)
	}
}

func TestArrayOrderMatters(t *testing.T) {
	a := Base{Kind: "x", Lang: "en", Inputs: map[string]any{"tags": []string{"a", "b"}}}
	b := Base{Kind: "x", Lang: "en", Inputs: map[string]any{"tags": []string{"b", "a"}}}
	ka, _ := KeyBase(a)
	kb, _ := KeyBase(b)
	if ka == kb {
		t.Fatal("array order is supposed to be significant")
	}
}

func TestRejects(t *testing.T) {
	bases := map[string]Base{
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
	for name, b := range bases {
		t.Run(name, func(t *testing.T) {
			if _, err := KeyBase(b); err == nil {
				t.Fatalf("expected an error")
			}
		})
	}

	kb := strings.Repeat("ab", 32)
	if _, err := VariantKey(kb, Variant{}); err == nil {
		t.Fatal("missing model_id should error")
	}
	if _, err := VariantKey("not-hex", Variant{ModelID: "m"}); err == nil {
		t.Fatal("bad key_base should error")
	}
	if _, err := VariantKey(strings.ToUpper(kb), Variant{ModelID: "m"}); err == nil {
		t.Fatal("uppercase hex key_base should error (keys are always lowercase)")
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
	// NBSP, NEL, ideographic space, BOM, em space — all collapse like ASCII space.
	in := string([]rune{0x00a0, 'a', 0x0085, 'b', 0x3000, 'c', 0xfeff, 'd', 0x2003, 'e'})
	if got := Normalize(in); got != "a b c d e" {
		t.Fatalf("got %q", got)
	}
}
