// Package contentkey implements the content-addressing scheme from
// STORYTELLER_OFFLINE_PLAN.md §0.1/§2.5 as refined by
// STORYTELLER_MODELS_PLAN.md §0.1: one piece of *content* (what is
// depicted / said) has many *variants* (which model + style + model
// version rendered it).
//
//	key_base = sha256(kind, lang, normalized_inputs)          — the content
//	key      = sha256(key_base, model_id, style_id, model_ver) — one variant of it
//	seed     = first 8 bytes of key_base, masked to 63 bits    — shared by ALL
//	           variants, so tier 1/2 renders of the same content start from
//	           the same noise as the tier 0 reference (MODELS_PLAN §2)
//
// The same bytes must come out of the Dart port
// (app/packages/content_key), so this file deliberately avoids
// encoding/json for the preimages: Go's encoder HTML-escapes <, >, &
// and Dart's doesn't, float formatting differs, and map-key ordering
// differs above the BMP. The canonical form is defined here, in prose,
// and pinned by testdata/golden.json which both implementations test
// against.
//
// Base preimage (lines joined by "\n", no trailing newline):
//
//	storyteller-content-key/v2
//	kind:<norm(kind)>
//	lang:<norm(lang)>
//	inputs:<canonical json of inputs>
//
// Variant preimage:
//
//	storyteller-content-variant/v2
//	base:<key_base, 64 lowercase hex>
//	model:<norm(model_id)>
//	style:<norm(style_id)>
//	model_ver:<norm(model_ver)>
//
// norm(s): trim, collapse internal whitespace runs to one space, lowercase.
// kind, lang and model_id must be non-empty after norm; style_id and
// model_ver may be "" (audio, text, or a model that isn't versioned yet).
//
// Canonical JSON:
//   - objects: keys sorted bytewise; keys must match ^[a-z0-9_]+$ (ASCII —
//     this is what keeps Go and Dart sort order identical); entries whose
//     value is null or an empty/whitespace-only string are dropped
//     (optional fields don't change the key when absent).
//   - strings: norm() applied, then quoted with only `"`, `\` and control
//     chars < 0x20 escaped (\" \\ \n \r \t, everything else \u00xx). No
//     HTML escaping. Raw UTF-8 for everything else.
//   - numbers: integers only, printed in decimal. Any non-integral float
//     is an error — inputs are IDs and enums by design (OFFLINE_PLAN
//     §2.5), never free text or measurements.
//   - bools: true/false. null inside arrays is kept as null.
//   - arrays: order preserved. Callers that mean "set" must sort first.
//   - no whitespace anywhere.
//
// Retries: a failed/degraded render is retried under the *same* key
// (it's still the same content and variant); the orchestrator derives
// the retry seed as Seed(key_base)+attempt. Nothing about a retry
// belongs in the key.
package contentkey

import (
	"crypto/sha256"
	"encoding/hex"
	"encoding/json"
	"errors"
	"fmt"
	"math"
	"regexp"
	"sort"
	"strconv"
	"strings"
)

const (
	baseVersion    = "storyteller-content-key/v2"
	variantVersion = "storyteller-content-variant/v2"
)

// Base identifies a piece of content independent of how it's rendered.
type Base struct {
	Kind   string         // e.g. "scene_image", "hint", "creature_sfx"
	Lang   string         // BCP-47-ish, e.g. "cs"
	Inputs map[string]any // normalized IDs/enums only — see package doc
}

// Variant identifies one rendering of a Base: a row in `models` ×
// `styles` × that model's workflow version (MODELS_PLAN §3).
type Variant struct {
	ModelID  string // models.id, e.g. "flux-schnell"
	StyleID  string // styles.id, e.g. "watercolor"; "" for non-visual kinds
	ModelVer string // models.version (workflow git hash) — bump to roll keys forward
}

var (
	keyPattern = regexp.MustCompile(`^[a-z0-9_]+$`)
	hexPattern = regexp.MustCompile(`^[0-9a-f]{64}$`)
)

// KeyBase returns the lowercase hex sha256 content key for b.
func KeyBase(b Base) (string, error) {
	pre, err := BasePreimage(b)
	if err != nil {
		return "", err
	}
	return hashHex(pre), nil
}

// VariantKey returns the asset key for one rendering of keyBase.
func VariantKey(keyBase string, v Variant) (string, error) {
	pre, err := VariantPreimage(keyBase, v)
	if err != nil {
		return "", err
	}
	return hashHex(pre), nil
}

// Key is KeyBase + VariantKey in one call. Returns both because callers
// almost always need key_base too (asset_variants rows, seed).
func Key(b Base, v Variant) (keyBase, key string, err error) {
	keyBase, err = KeyBase(b)
	if err != nil {
		return "", "", err
	}
	key, err = VariantKey(keyBase, v)
	if err != nil {
		return "", "", err
	}
	return keyBase, key, nil
}

// Seed derives the generation seed from a key_base: first 8 bytes,
// big-endian, top bit cleared so the result is a non-negative int64.
// Pass key_base, not the variant key — every variant of the same
// content shares one seed on purpose.
func Seed(keyBase string) (int64, error) {
	if !hexPattern.MatchString(keyBase) {
		return 0, fmt.Errorf("contentkey: key_base must be 64 lowercase hex chars")
	}
	b, _ := hex.DecodeString(keyBase[:16])
	var v uint64
	for _, x := range b {
		v = v<<8 | uint64(x)
	}
	return int64(v & 0x7fffffffffffffff), nil
}

// AssetPath is the immutable CDN path from OFFLINE_PLAN §2.2:
// assets/{kind}/{key[0:2]}/{key}.{ext} — key is the variant key.
func AssetPath(kind, key, ext string) string {
	ext = strings.TrimPrefix(ext, ".")
	return fmt.Sprintf("assets/%s/%s/%s.%s", Normalize(kind), key[:2], key, ext)
}

// BasePreimage returns the exact string hashed by KeyBase. Exported so
// tests, debugging tools, and the Dart port can compare intermediates.
func BasePreimage(b Base) (string, error) {
	kind := Normalize(b.Kind)
	if kind == "" {
		return "", errors.New("contentkey: kind is required")
	}
	lang := Normalize(b.Lang)
	if lang == "" {
		return "", errors.New("contentkey: lang is required")
	}
	inputs, err := canonicalObject(b.Inputs)
	if err != nil {
		return "", err
	}
	return baseVersion + "\nkind:" + kind + "\nlang:" + lang + "\ninputs:" + inputs, nil
}

// VariantPreimage returns the exact string hashed by VariantKey.
func VariantPreimage(keyBase string, v Variant) (string, error) {
	if !hexPattern.MatchString(keyBase) {
		return "", errors.New("contentkey: key_base must be 64 lowercase hex chars")
	}
	model := Normalize(v.ModelID)
	if model == "" {
		return "", errors.New("contentkey: model_id is required")
	}
	return variantVersion +
		"\nbase:" + keyBase +
		"\nmodel:" + model +
		"\nstyle:" + Normalize(v.StyleID) +
		"\nmodel_ver:" + Normalize(v.ModelVer), nil
}

func hashHex(s string) string {
	sum := sha256.Sum256([]byte(s))
	return hex.EncodeToString(sum[:])
}

// Normalize trims, collapses whitespace runs to a single space, and
// lowercases. Applied to every string that enters a preimage.
//
// Lowercasing uses each language's default Unicode mapping; those agree
// for ASCII and for Latin diacritics (cs/sk/pl/de…), which is all the
// IDs use. Don't put Turkish dotted-I or Greek final-sigma text into
// inputs and expect Go and Dart to agree.
func Normalize(s string) string {
	fields := strings.FieldsFunc(s, isSpace)
	return strings.ToLower(strings.Join(fields, " "))
}

// isSpace is the explicit whitespace set shared with the Dart port —
// the union of Go's unicode.IsSpace and Dart's RegExp \s, so neither
// side's built-in definition can drift the key.
func isSpace(r rune) bool {
	switch r {
	case '\t', '\n', '\v', '\f', '\r', ' ',
		0x0085, 0x00A0, 0x1680, 0x2028, 0x2029, 0x202F, 0x205F, 0x3000, 0xFEFF:
		return true
	}
	return r >= 0x2000 && r <= 0x200A
}

func canonicalObject(m map[string]any) (string, error) {
	keys := make([]string, 0, len(m))
	for k := range m {
		if !keyPattern.MatchString(k) {
			return "", fmt.Errorf("contentkey: input key %q must match ^[a-z0-9_]+$", k)
		}
		keys = append(keys, k)
	}
	sort.Strings(keys)

	var b strings.Builder
	b.WriteByte('{')
	first := true
	for _, k := range keys {
		v := m[k]
		if v == nil {
			continue
		}
		if s, ok := v.(string); ok && Normalize(s) == "" {
			continue
		}
		if !first {
			b.WriteByte(',')
		}
		first = false
		writeString(&b, k)
		b.WriteByte(':')
		if err := canonicalValue(&b, v); err != nil {
			return "", err
		}
	}
	b.WriteByte('}')
	return b.String(), nil
}

func canonicalValue(b *strings.Builder, v any) error {
	switch x := v.(type) {
	case nil:
		b.WriteString("null")
	case bool:
		if x {
			b.WriteString("true")
		} else {
			b.WriteString("false")
		}
	case string:
		writeString(b, Normalize(x))
	case int:
		b.WriteString(strconv.FormatInt(int64(x), 10))
	case int8:
		b.WriteString(strconv.FormatInt(int64(x), 10))
	case int16:
		b.WriteString(strconv.FormatInt(int64(x), 10))
	case int32:
		b.WriteString(strconv.FormatInt(int64(x), 10))
	case int64:
		b.WriteString(strconv.FormatInt(x, 10))
	case uint:
		b.WriteString(strconv.FormatUint(uint64(x), 10))
	case uint8:
		b.WriteString(strconv.FormatUint(uint64(x), 10))
	case uint16:
		b.WriteString(strconv.FormatUint(uint64(x), 10))
	case uint32:
		b.WriteString(strconv.FormatUint(uint64(x), 10))
	case uint64:
		b.WriteString(strconv.FormatUint(x, 10))
	case float32:
		return writeFloat(b, float64(x))
	case float64:
		return writeFloat(b, x)
	case json.Number:
		// Decoders using UseNumber() hand us the literal text; accept it
		// only if it parses as an int64 — same rule as floats, no
		// precision loss on 19-digit seeds.
		n, err := x.Int64()
		if err != nil {
			return fmt.Errorf("contentkey: number %q is not an int64: %w", string(x), err)
		}
		b.WriteString(strconv.FormatInt(n, 10))
	case []any:
		b.WriteByte('[')
		for i, e := range x {
			if i > 0 {
				b.WriteByte(',')
			}
			if err := canonicalValue(b, e); err != nil {
				return err
			}
		}
		b.WriteByte(']')
	case []string:
		b.WriteByte('[')
		for i, e := range x {
			if i > 0 {
				b.WriteByte(',')
			}
			writeString(b, Normalize(e))
		}
		b.WriteByte(']')
	case map[string]any:
		s, err := canonicalObject(x)
		if err != nil {
			return err
		}
		b.WriteString(s)
	default:
		return fmt.Errorf("contentkey: unsupported input value type %T", v)
	}
	return nil
}

// writeFloat accepts a float only when it is integral (JSON decoding in
// Go yields float64 for every number) — 3.0 is fine, 3.5 is not.
func writeFloat(b *strings.Builder, f float64) error {
	if math.IsNaN(f) || math.IsInf(f, 0) || f != math.Trunc(f) {
		return fmt.Errorf("contentkey: non-integral number %v not allowed in inputs", f)
	}
	if math.Abs(f) > 1<<53 {
		return fmt.Errorf("contentkey: number %v exceeds 2^53 and would lose precision", f)
	}
	b.WriteString(strconv.FormatInt(int64(f), 10))
	return nil
}

func writeString(b *strings.Builder, s string) {
	b.WriteByte('"')
	for _, r := range s {
		switch r {
		case '"':
			b.WriteString(`\"`)
		case '\\':
			b.WriteString(`\\`)
		case '\n':
			b.WriteString(`\n`)
		case '\r':
			b.WriteString(`\r`)
		case '\t':
			b.WriteString(`\t`)
		default:
			if r < 0x20 {
				fmt.Fprintf(b, `\u%04x`, r)
			} else {
				b.WriteRune(r)
			}
		}
	}
	b.WriteByte('"')
}
