// Command build-geo turns Natural Earth's 110m admin-0 countries
// GeoJSON (public domain, STORYTELLER_PLAN.md §1.1b) into the compact
// asset the Flutter globe loads.
//
// The source is ~840KB of nested [lon,lat] pairs at full precision —
// far more than a phone-sized orthographic globe needs. This trims it
// to roughly a tenth by:
//   - keeping only ISO_A2 + name + a centroid + ring geometry,
//   - rounding coordinates to 1 decimal place (~11km at the equator;
//     the globe is ~360px across, so one pixel is ~110km — a second
//     decimal would be invisible),
//   - dropping rings with fewer than `-min-ring` points after rounding
//     (tiny islands that render as sub-pixel specks) while always
//     keeping each country's largest ring so nothing disappears,
//   - flattening each ring to [lon,lat,lon,lat,...] instead of nested
//     pairs, which removes two JSON brackets per coordinate.
//
// Usage:
//
//	go run ./corpus/cmd/build-geo -in /tmp/ne110m.geojson -out app/assets/geo/countries.json
package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"math"
	"os"
	"sort"
)

type geoJSON struct {
	Features []struct {
		Properties map[string]any  `json:"properties"`
		Geometry   json.RawMessage `json:"geometry"`
	} `json:"features"`
}

type geometry struct {
	Type        string          `json:"type"`
	Coordinates json.RawMessage `json:"coordinates"`
}

// Country is one entry in the emitted asset. Field names are single
// letters because this ships to the device: over 177 countries the
// difference is real.
type Country struct {
	ISO    string      `json:"i"`
	Name   string      `json:"n"`
	Lat    float64     `json:"a"` // centroid latitude
	Lon    float64     `json:"o"` // centroid longitude
	Motifs int         `json:"m"` // motifs the corpus has from here (0 = uncovered)
	Tales  int         `json:"t"` // tales those motifs came from
	Ring   [][]float64 `json:"p"` // rings, each flattened [lon,lat,lon,lat,...]
}

// coverage counts what rag.extract actually produced per country, so
// the globe can show real coverage instead of pretending every country
// is equally stocked (STORYTELLER_PLAN.md §1.1b: countries under the
// motif threshold are "zamlžené"). Reading the pipeline's JSONL here —
// rather than in Python next to the pipeline — keeps this on the Go
// side of the split: it's data plumbing for the app asset, no LLM
// involved.
func coverage(path string) (map[string]struct{ Motifs, Tales int }, error) {
	f, err := os.Open(path)
	if err != nil {
		return nil, err
	}
	defer f.Close()

	out := map[string]struct{ Motifs, Tales int }{}
	dec := json.NewDecoder(f)
	for {
		var rec struct {
			Motifs []struct {
				CountryCode string `json:"country_code"`
			} `json:"motifs"`
		}
		if err := dec.Decode(&rec); err != nil {
			if err.Error() == "EOF" {
				break
			}
			return nil, err
		}
		seenTale := map[string]bool{}
		for _, m := range rec.Motifs {
			if m.CountryCode == "" {
				continue
			}
			e := out[m.CountryCode]
			e.Motifs++
			if !seenTale[m.CountryCode] {
				e.Tales++
				seenTale[m.CountryCode] = true
			}
			out[m.CountryCode] = e
		}
	}
	return out, nil
}

func main() {
	in := flag.String("in", "/tmp/ne110m.geojson", "Natural Earth 110m admin-0 countries GeoJSON")
	out := flag.String("out", "app/assets/geo/countries.json", "output asset")
	corpus := flag.String("corpus", "rag/data/tales.jsonl", "rag.extract output, for per-country motif counts (optional)")
	precision := flag.Int("precision", 1, "decimal places to keep on coordinates")
	minRing := flag.Int("min-ring", 8, "drop rings with fewer points than this (largest ring per country always kept)")
	flag.Parse()

	cov, err := coverage(*corpus)
	if err != nil {
		log.Printf("no corpus coverage (%v) — every country will render as uncovered", err)
		cov = map[string]struct{ Motifs, Tales int }{}
	}

	raw, readErr := os.ReadFile(*in)
	if readErr != nil {
		log.Fatalf("read %s: %v", *in, readErr)
	}
	var gj geoJSON
	if err := json.Unmarshal(raw, &gj); err != nil {
		log.Fatalf("parse geojson: %v", err)
	}

	scale := math.Pow(10, float64(*precision))
	round := func(v float64) float64 { return math.Round(v*scale) / scale }

	var countries []Country
	var skipped []string
	for _, f := range gj.Features {
		name, _ := f.Properties["NAME"].(string)
		// Natural Earth writes "-99" into ISO_A2 for a handful of
		// entries — including, as a long-standing quirk of this
		// dataset, France and Norway, which obviously do have ISO
		// codes. ISO_A2_EH ("eventual handling") carries the real code
		// for those, so it's the fallback. Anything still "-99" after
		// that is genuinely unassigned (disputed/undetermined) and gets
		// dropped rather than guessed at — it couldn't be matched to a
		// motif's country_code anyway.
		iso := isoCode(f.Properties, "ISO_A2", "ISO_A2_EH", "WB_A2")
		if iso == "" {
			skipped = append(skipped, name)
			continue
		}

		var g geometry
		if err := json.Unmarshal(f.Geometry, &g); err != nil {
			log.Fatalf("%s: parse geometry: %v", name, err)
		}
		rings, err := extractRings(g)
		if err != nil {
			log.Fatalf("%s: %v", name, err)
		}

		// Round, flatten, and measure each ring.
		type sized struct {
			flat []float64
			pts  int
		}
		var all []sized
		for _, ring := range rings {
			flat := make([]float64, 0, len(ring)*2)
			var prevLon, prevLat float64
			for i, pt := range ring {
				lon, lat := round(pt[0]), round(pt[1])
				// Rounding collapses neighbouring points; dropping the
				// duplicates is most of the size win.
				if i > 0 && lon == prevLon && lat == prevLat {
					continue
				}
				flat = append(flat, lon, lat)
				prevLon, prevLat = lon, lat
			}
			if len(flat) >= 6 { // a ring needs 3 points to have any area
				all = append(all, sized{flat: flat, pts: len(flat) / 2})
			}
		}
		if len(all) == 0 {
			skipped = append(skipped, name+" (no ring survived rounding)")
			continue
		}
		sort.Slice(all, func(i, j int) bool { return all[i].pts > all[j].pts })

		kept := [][]float64{all[0].flat} // largest ring always survives
		for _, s := range all[1:] {
			if s.pts >= *minRing {
				kept = append(kept, s.flat)
			}
		}

		lat, lon := centroid(all[0].flat)
		c := cov[iso]
		countries = append(countries, Country{ISO: iso, Name: name, Lat: round(lat), Lon: round(lon), Motifs: c.Motifs, Tales: c.Tales, Ring: kept})
	}

	sort.Slice(countries, func(i, j int) bool { return countries[i].ISO < countries[j].ISO })

	buf, err := json.Marshal(countries)
	if err != nil {
		log.Fatalf("encode: %v", err)
	}
	if err := os.MkdirAll(dir(*out), 0o755); err != nil {
		log.Fatal(err)
	}
	if err := os.WriteFile(*out, buf, 0o644); err != nil {
		log.Fatalf("write %s: %v", *out, err)
	}

	var rings, points int
	for _, c := range countries {
		rings += len(c.Ring)
		for _, r := range c.Ring {
			points += len(r) / 2
		}
	}
	fmt.Printf("%d countries, %d rings, %d points → %s (%.0f KB, from %.0f KB)\n",
		len(countries), rings, points, *out, float64(len(buf))/1024, float64(len(raw))/1024)
	if len(skipped) > 0 {
		fmt.Printf("skipped %d without a usable ISO_A2: %v\n", len(skipped), skipped)
	}
}

// isoCode returns the first property that looks like a real ISO 3166-1
// alpha-2 code, trying each key in order.
func isoCode(props map[string]any, keys ...string) string {
	for _, k := range keys {
		v, _ := props[k].(string)
		if len(v) == 2 && v != "-9" {
			return v
		}
	}
	return ""
}

// extractRings flattens Polygon and MultiPolygon into a list of outer
// rings. Holes (rings after the first in each polygon) are dropped —
// at this scale an enclave is a couple of pixels and the globe paints
// filled shapes, not donuts.
func extractRings(g geometry) ([][][2]float64, error) {
	switch g.Type {
	case "Polygon":
		var poly [][][2]float64
		if err := json.Unmarshal(g.Coordinates, &poly); err != nil {
			return nil, err
		}
		if len(poly) == 0 {
			return nil, nil
		}
		return poly[:1], nil
	case "MultiPolygon":
		var multi [][][][2]float64
		if err := json.Unmarshal(g.Coordinates, &multi); err != nil {
			return nil, err
		}
		var out [][][2]float64
		for _, poly := range multi {
			if len(poly) > 0 {
				out = append(out, poly[0])
			}
		}
		return out, nil
	default:
		return nil, fmt.Errorf("unsupported geometry type %q", g.Type)
	}
}

// centroid is the average of a ring's vertices — not the true area
// centroid, but the globe only uses it to aim the camera at a country
// and to label it, and vertex-average is stable and cheap.
func centroid(flat []float64) (lat, lon float64) {
	var sumLon, sumLat float64
	n := len(flat) / 2
	for i := 0; i < n; i++ {
		sumLon += flat[i*2]
		sumLat += flat[i*2+1]
	}
	return sumLat / float64(n), sumLon / float64(n)
}

func dir(path string) string {
	for i := len(path) - 1; i >= 0; i-- {
		if path[i] == '/' {
			return path[:i]
		}
	}
	return "."
}
