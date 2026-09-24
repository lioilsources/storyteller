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
// preferences such as banned motifs ("no wolves"). QualityMode /
// AllowUpgrades / Animations are MODELS_PLAN §7 (family_prefs folded in
// here — ArtStyle is styles.id).
type Family struct {
	ID            string         `json:"id"`
	Locale        string         `json:"locale"`
	ArtStyle      string         `json:"art_style"`
	QualityMode   string         `json:"quality_mode"` // fast | best | auto
	AllowUpgrades bool           `json:"allow_upgrades"`
	Animations    bool           `json:"animations"`
	Settings      map[string]any `json:"settings"`
	CreatedAt     time.Time      `json:"created_at"`
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

// --- STORYTELLER_PLAN.md §1.1c: environments + creatures (soundboard) ---

// Environment is one setting within a country (forest, sea, palace…)
// with its ambient loop, music theme, and per-style art.
type Environment struct {
	ID          string         `json:"id"`
	CountryCode string         `json:"country_code"`
	Kind        string         `json:"kind"`
	NameI18n    map[string]any `json:"name_i18n"`
	AmbientURL  string         `json:"ambient_url,omitempty"`
	MusicURL    string         `json:"music_url,omitempty"`
	Art         map[string]any `json:"art"`
}

// Creature is one soundboard entry living in an Environment.
type Creature struct {
	ID             string         `json:"id"`
	EnvironmentID  string         `json:"environment_id"`
	NameI18n       map[string]any `json:"name_i18n"`
	SoundURL       string         `json:"sound_url,omitempty"`
	VoiceLineURL   string         `json:"voice_line_url,omitempty"`
	Icon           map[string]any `json:"icon"`
	AnimURL        string         `json:"anim_url,omitempty"`
	SourceMotifIDs []string       `json:"source_motif_ids"`
}

// --- STORYTELLER_OFFLINE_PLAN.md §2.4: assets, miss queue, packs ---

// AssetSource says which lane produced an asset.
type AssetSource string

const (
	AssetSourceOnline     AssetSource = "online"
	AssetSourceNightly    AssetSource = "nightly"
	AssetSourcePrediction AssetSource = "prediction"
)

// VariantStatus is asset_variants.status.
type VariantStatus string

const (
	VariantReady    VariantStatus = "ready"
	VariantDegraded VariantStatus = "degraded" // failed consistency twice; kept, but tier 0 is preferred over it
	VariantPending  VariantStatus = "pending"
	VariantFailed   VariantStatus = "failed"
)

// AssetVariant is one rendering of one piece of content
// (STORYTELLER_MODELS_PLAN.md §0.1): Key = contentkey.VariantKey(KeyBase,
// {ModelID, StyleID, ModelVer}). Rows live in object storage under Path.
type AssetVariant struct {
	Key         string        `json:"key"`
	KeyBase     string        `json:"key_base"`
	Kind        string        `json:"kind"`
	Lang        string        `json:"lang"`
	ModelID     string        `json:"model_id"`
	StyleID     string        `json:"style_id,omitempty"`
	ModelVer    string        `json:"model_ver"`
	Path        string        `json:"path"`
	Bytes       int64         `json:"bytes"`
	Width       int           `json:"width,omitempty"`
	Height      int           `json:"height,omitempty"`
	Consistency *float64      `json:"consistency,omitempty"` // DINOv2 cos to the tier-0 reference
	Status      VariantStatus `json:"status"`
	Source      AssetSource   `json:"source"`
	CreatedAt   time.Time     `json:"created_at"`
}

// --- STORYTELLER_MODELS_PLAN.md §3: registries ---

// RegistryStatus is the lifecycle of a model or style: shadow → active → retired.
type RegistryStatus string

const (
	RegistryActive  RegistryStatus = "active"
	RegistryShadow  RegistryStatus = "shadow"
	RegistryRetired RegistryStatus = "retired"
)

// Model is one row of the `models` registry. Tier 0 is the flux-schnell
// reference every other tier conditions on; LoraDriven marks "tier 1s".
type Model struct {
	ID              string         `json:"id"`
	Kind            string         `json:"kind"` // image | video | audio | tts | text
	Tier            int            `json:"tier"`
	LoraDriven      bool           `json:"lora_driven"`
	Backend         string         `json:"backend"`
	WorkflowTxt2Img string         `json:"workflow_txt2img,omitempty"`
	WorkflowRef2Img string         `json:"workflow_ref2img,omitempty"`
	WorkflowI2V     string         `json:"workflow_i2v,omitempty"`
	Version         string         `json:"version"` // workflow git hash — part of the variant key
	CostSec         *float64       `json:"cost_sec,omitempty"`
	Quality         *float64       `json:"quality,omitempty"`
	Status          RegistryStatus `json:"status"`
	Notes           string         `json:"notes,omitempty"`
}

// Style is one row of the `styles` registry — the prompt decoration and
// reference strength for one art style, plus which models may render it.
type Style struct {
	ID             string         `json:"id"`
	NameI18n       map[string]any `json:"name_i18n"`
	PreferredModel string         `json:"preferred_model,omitempty"`
	AllowedModels  []string       `json:"allowed_models"`
	PromptPrefix   string         `json:"prompt_prefix"`
	PromptSuffix   string         `json:"prompt_suffix"`
	Negative       string         `json:"negative"`
	LoraPath       string         `json:"lora_path,omitempty"`
	LoraStrength   *float64       `json:"lora_strength,omitempty"`
	RefStrength    float64        `json:"ref_strength"`
	PreviewURL     string         `json:"preview_url,omitempty"`
	Status         RegistryStatus `json:"status"`
	SortOrder      int            `json:"sort_order"`
}

// Miss records a request no cache layer could serve; the nightly run
// turns these into Jobs.
type Miss struct {
	ID                string         `json:"id"`
	Key               string         `json:"key"`
	Kind              string         `json:"kind"`
	Inputs            map[string]any `json:"inputs"`
	FamilyID          string         `json:"family_id,omitempty"`
	Ts                time.Time      `json:"ts"`
	ServedFallbackKey string         `json:"served_fallback_key,omitempty"`
}

// JobStatus is the nightly queue state machine.
type JobStatus string

const (
	JobQueued   JobStatus = "queued"
	JobRunning  JobStatus = "running"
	JobDone     JobStatus = "done"
	JobFailed   JobStatus = "failed"
	JobDeferred JobStatus = "deferred" // didn't fit before 07:00, carries a bonus into the next night
)

// Job is one deduplicated unit of nightly work.
type Job struct {
	ID           string         `json:"id"`
	Key          string         `json:"key"`
	Kind         string         `json:"kind"`
	Inputs       map[string]any `json:"inputs"`
	Priority     float64        `json:"priority"`
	Demand       int            `json:"demand"`
	IsPrediction bool           `json:"is_prediction"`
	Status       JobStatus      `json:"status"`
	Attempts     int            `json:"attempts"`
	ResultPath   string         `json:"result_path,omitempty"`
	Error        string         `json:"error,omitempty"`
	CreatedAt    time.Time      `json:"created_at"`
	StartedAt    *time.Time     `json:"started_at,omitempty"`
	DoneAt       *time.Time     `json:"done_at,omitempty"`
}

// Pack is one device download unit: zip per (country|region, style,
// lang, kind_group).
type Pack struct {
	ID           string     `json:"id"`
	CountryCode  string     `json:"country_code,omitempty"`
	RegionCode   string     `json:"region_code,omitempty"`
	Style        string     `json:"style"`
	Lang         string     `json:"lang"`
	KindGroup    string     `json:"kind_group"` // core | art | audio | hints
	Version      int        `json:"version"`
	Bytes        int64      `json:"bytes"`
	ManifestHash string     `json:"manifest_hash,omitempty"`
	Path         string     `json:"path,omitempty"`
	BuiltAt      *time.Time `json:"built_at,omitempty"`
}

// ManifestVersion is one published snapshot of the pack catalogue that
// clients diff against on sync.
type ManifestVersion struct {
	Version   int64          `json:"version"`
	CreatedAt time.Time      `json:"created_at"`
	Changes   map[string]any `json:"changes"`
}
