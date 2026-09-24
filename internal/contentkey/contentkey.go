// Package contentkey implements STORYTELLER_OFFLINE_PLAN.md §0.1 / §2.5:
// every generatable artefact is a deterministic function of its inputs,
//
//	key  = sha256(kind, model_ver, style, lang, normalized_inputs, variant)
//	seed = first 8 bytes of key (masked to 63 bits so every consumer —
//	       ComfyUI, vLLM, Dart int — can hold it without sign surprises)
//
// The same key must come out of the Dart port (app/packages/content_key)
// byte-for-byte, so this file deliberately avoids encoding/json for the
// preimage: Go's encoder HTML-escapes <, >, & and Dart's doesn't, float
// formatting differs, and map-key ordering differs above the BMP. The
// canonical form is defined here, in prose, and pinned by
// testdata/golden.json which both implementations test against.
//
// Canonical preimage (lines joined by "\n", no trailing newline):
//
//	storyteller-content-key/v1
//	kind:<norm(kind)>
//	model:<norm(model_ver)>
//	style:<norm(style)>
//	lang:<norm(lang)>
//	variant:<decimal int>
//	inputs:<canonical json of inputs>
//
// norm(s): trim, collapse internal whitespace runs to one space, lowercase.
// kind and lang must be non-empty after norm; style/model_ver may be "".
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
//     is an error — inputs are IDs and enums by design (§2.5), never
//     free text or measurements.
//   - bools: true/false. null inside arrays is kept as null.
//   - arrays: order preserved. Callers that mean "set" must sort first.
//   - no whitespace anywhere.
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

const version = "storyteller-content-key/v1"

// Request describes one artefact to be generated.
type Request struct {
	Kind     string         // e.g. "scene_image", "hint", "creature_sfx"
	ModelVer string         // e.g. "flux-schnell@2025-06" — bump to roll all keys forward
	Style    string         // art style id; "" for non-visual kinds
	Lang     string         // BCP-47-ish, e.g. "cs"
	Variant  int            // 0 normally; >0 to force a regeneration with a different seed
	Inputs   map[string]any // normalized IDs/enums only — see package doc
}

var keyPattern = regexp.MustCompile(`^[a-z0-9_]+$`)

// Key returns the lowercase hex sha256 content key for r.
func Key(r Request) (string, error) {
	pre, err := Preimage(r)
	if err != nil {
		return "", err
	}
	sum := sha256.Sum256([]byte(pre))
	return hex.EncodeToString(sum[:]), nil
}

// Seed derives the generation seed from a key: first 8 bytes, big-endian,
// top bit cleared so the result is a non-negative int64.
func Seed(key string) (int64, error) {
	if len(key) != 64 {
		return 0, fmt.Errorf("contentkey: key must be 64 hex chars, got %d", len(key))
	}
	b, err := hex.DecodeString(key[:16])
	if err != nil {
		return 0, fmt.Errorf("contentkey: bad key: %w", err)
	}
	var v uint64
	for _, x := range b {
		v = v<<8 | uint64(x)
	}
	return int64(v & 0x7fffffffffffffff), nil
}

// AssetPath is the immutable CDN path from OFFLINE_PLAN §2.2:
// assets/{kind}/{key[0:2]}/{key}.{ext}
func AssetPath(kind, key, ext string) string {
	ext = strings.TrimPrefix(ext, ".")
	return fmt.Sprintf("assets/%s/%s/%s.%s", Normalize(kind), key[:2], key, ext)
}

// Preimage returns the exact string that gets hashed. Exported so tests,
// debugging tools, and the Dart port can compare intermediate output.
func Preimage(r Request) (string, error) {
	kind := Normalize(r.Kind)
	if kind == "" {
		return "", errors.New("contentkey: kind is required")
	}
	lang := Normalize(r.Lang)
	if lang == "" {
		return "", errors.New("contentkey: lang is required")
	}
	inputs, err := canonicalObject(r.Inputs)
	if err != nil {
		return "", err
	}
	var b strings.Builder
	b.WriteString(version)
	b.WriteString("\nkind:")
	b.WriteString(kind)
	b.WriteString("\nmodel:")
	b.WriteString(Normalize(r.ModelVer))
	b.WriteString("\nstyle:")
	b.WriteString(Normalize(r.Style))
	b.WriteString("\nlang:")
	b.WriteString(lang)
	b.WriteString("\nvariant:")
	b.WriteString(strconv.Itoa(r.Variant))
	b.WriteString("\ninputs:")
	b.WriteString(inputs)
	return b.String(), nil
}

// Normalize trims, collapses whitespace runs to a single space, and
// lowercases. Applied to every string that enters the preimage.
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
