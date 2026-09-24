// Package models holds the shared domain types that mirror the Postgres
// schema described in STORYTELLER_PLAN.md §2.2. Both /gateway and /corpus
// depend on this package so the two never drift apart.
package models

import "time"

// MotifType is one of the four building blocks a daily offer or a globe
// spin picks from.
type MotifType string

const (
	MotifCharacter MotifType = "character"
	MotifTask      MotifType = "task"
	MotifProblem   MotifType = "problem"
	MotifEnding    MotifType = "ending"
)

// Family is one household using the app. Settings holds free-form
// preferences such as banned motifs ("no wolves").
type Family struct {
	ID        string         `json:"id"`
	Locale    string         `json:"locale"`
	ArtStyle  string         `json:"art_style"`
	Settings  map[string]any `json:"settings"`
	CreatedAt time.Time      `json:"created_at"`
}

// Region groups countries that individually fall below the minimum motif
// count (§1.1b) so the globe still has something to offer there.
type Region struct {
	Code         string         `json:"code"`
	NameI18n     map[string]any `json:"name_i18n"`
	CountryCodes []string       `json:"country_codes"`
}

// Country is one stop on the globe. Art holds per-style asset URLs, e.g.
// {"watercolor": {"icon_url": "...", "hero_url": "..."}}.
type Country struct {
	Code              string         `json:"code"` // ISO 3166-1 alpha-2
	RegionCode        string         `json:"region_code,omitempty"`
	NameI18n          map[string]any `json:"name_i18n"`
	CentroidLat       float64        `json:"centroid_lat"`
	CentroidLon       float64        `json:"centroid_lon"`
	PolygonRef        string         `json:"polygon_ref,omitempty"`
	FolkloreBlurbI18n map[string]any `json:"folklore_blurb_i18n"`
	MotifCount        int            `json:"motif_count"`
	Art               map[string]any `json:"art"`
}

// CorpusMotif is one atomic building block extracted from a public-domain
// fairy tale: a character, a task, a problem, or an ending, tied to the
// country/region it originates from.
type CorpusMotif struct {
	ID          string    `json:"id"`
	ATUCode     string    `json:"atu_code,omitempty"`
	Type        MotifType `json:"type"`
	TextEN      string    `json:"text_en"`
	Tags        []string  `json:"tags"`
	SourceRef   string    `json:"source_ref,omitempty"`
	CountryCode string    `json:"country_code,omitempty"`
	RegionCode  string    `json:"region_code,omitempty"`
	AgeMin      int       `json:"age_min"`
	Soft        bool      `json:"soft"`
	CreatedAt   time.Time `json:"created_at"`
}

// DailyOffer is the deterministic 3x4 grid a family sees for one date.
type DailyOffer struct {
	ID         string        `json:"id"`
	FamilyID   string        `json:"family_id"`
	Date       string        `json:"date"` // YYYY-MM-DD
	Seed       int64         `json:"seed"`
	Characters []CorpusMotif `json:"characters"`
	Tasks      []CorpusMotif `json:"tasks"`
	Problems   []CorpusMotif `json:"problems"`
	Endings    []CorpusMotif `json:"endings"`
}

// Character is a reusable, family-specific character with a reference
// image for IP-Adapter consistency across scenes.
type Character struct {
	ID          string    `json:"id"`
	FamilyID    string    `json:"family_id"`
	Name        string    `json:"name"`
	Description string    `json:"description,omitempty"`
	RefImageURL string    `json:"ref_image_url,omitempty"`
	Style       string    `json:"style,omitempty"`
	CreatedAt   time.Time `json:"created_at"`
}

// Story is one told-or-being-told fairy tale: the outline plus metadata.
type Story struct {
	ID        string         `json:"id"`
	FamilyID  string         `json:"family_id"`
	Outline   map[string]any `json:"outline"`
	Style     string         `json:"style"`
	Lang      string         `json:"lang"`
	Title     string         `json:"title,omitempty"`
	CreatedAt time.Time      `json:"created_at"`
}

// Scene is one illustrated beat within a story.
type Scene struct {
	ID       string `json:"id"`
	StoryID  string `json:"story_id"`
	Idx      int    `json:"idx"`
	Prompt   string `json:"prompt,omitempty"`
	ImageURL string `json:"image_url,omitempty"`
	AnimURL  string `json:"anim_url,omitempty"`
	Status   string `json:"status"`
}

// Hint is one nudge offered to the parent during live narration, and
// whether they used it — the learning signal referenced in §6.
type Hint struct {
	ID       string    `json:"id"`
	StoryID  string    `json:"story_id"`
	Ts       time.Time `json:"ts"`
	Text     string    `json:"text"`
	Accepted *bool     `json:"accepted,omitempty"`
}

// Spin logs one globe spin during story assembly: which phase, which
// country it landed on, and which motif got picked.
type Spin struct {
	ID            string    `json:"id"`
	StoryID       string    `json:"story_id"`
	Phase         string    `json:"phase"`
	CountryCode   string    `json:"country_code,omitempty"`
	PickedMotifID string    `json:"picked_motif_id,omitempty"`
	CreatedAt     time.Time `json:"created_at"`
}
