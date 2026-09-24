-- Initial schema, STORYTELLER_PLAN.md §2.2. Written for golang-migrate
-- (name pattern <version>_<name>.up.sql / .down.sql) — swap in sqlc
-- generation once the gateway's queries stabilize.

CREATE EXTENSION IF NOT EXISTS pgcrypto; -- for gen_random_uuid()

CREATE TABLE regions (
    code            TEXT PRIMARY KEY,
    name_i18n       JSONB NOT NULL DEFAULT '{}',
    country_codes   TEXT[] NOT NULL DEFAULT '{}'
);

CREATE TABLE countries (
    code                TEXT PRIMARY KEY,          -- ISO 3166-1 alpha-2
    region_code         TEXT REFERENCES regions(code),
    name_i18n           JSONB NOT NULL DEFAULT '{}',
    centroid_lat        DOUBLE PRECISION,
    centroid_lon        DOUBLE PRECISION,
    polygon_ref         TEXT,                       -- ref into the Natural Earth 110m GeoJSON bundled with the app
    folklore_blurb_i18n JSONB NOT NULL DEFAULT '{}',
    motif_count         INT NOT NULL DEFAULT 0,
    art                 JSONB NOT NULL DEFAULT '{}'  -- {style: {icon_url, hero_url, ...}}
);
CREATE INDEX idx_countries_region ON countries(region_code);

CREATE TABLE families (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    locale      TEXT NOT NULL DEFAULT 'cs',
    art_style   TEXT NOT NULL DEFAULT 'watercolor',
    settings    JSONB NOT NULL DEFAULT '{}',
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE corpus_motifs (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    atu_code      TEXT,
    type          TEXT NOT NULL CHECK (type IN ('character', 'task', 'problem', 'ending')),
    text_en       TEXT NOT NULL,
    tags          TEXT[] NOT NULL DEFAULT '{}',
    source_ref    TEXT,
    country_code  TEXT REFERENCES countries(code),
    region_code   TEXT REFERENCES regions(code),
    age_min       SMALLINT NOT NULL DEFAULT 0,
    soft          BOOLEAN NOT NULL DEFAULT false,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_corpus_motifs_type ON corpus_motifs(type);
CREATE INDEX idx_corpus_motifs_country ON corpus_motifs(country_code);

CREATE TABLE characters (
    id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    family_id       UUID NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    name            TEXT NOT NULL,
    description     TEXT,
    ref_image_url   TEXT,
    style           TEXT,
    created_at      TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_characters_family ON characters(family_id);

CREATE TABLE daily_offers (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    family_id   UUID NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    date        DATE NOT NULL,
    characters  JSONB NOT NULL,
    tasks       JSONB NOT NULL,
    problems    JSONB NOT NULL,
    endings     JSONB NOT NULL,
    seed        BIGINT NOT NULL,
    UNIQUE (family_id, date)
);

CREATE TABLE stories (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    family_id   UUID NOT NULL REFERENCES families(id) ON DELETE CASCADE,
    outline     JSONB NOT NULL,
    style       TEXT,
    lang        TEXT,
    title       TEXT,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_stories_family ON stories(family_id);

CREATE TABLE scenes (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id    UUID NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    idx         INT NOT NULL,
    prompt      TEXT,
    image_url   TEXT,
    anim_url    TEXT,
    status      TEXT NOT NULL DEFAULT 'pending'
);
CREATE INDEX idx_scenes_story ON scenes(story_id);

CREATE TABLE hints (
    id          UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id    UUID NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    ts          TIMESTAMPTZ NOT NULL DEFAULT now(),
    text        TEXT NOT NULL,
    accepted    BOOLEAN
);
CREATE INDEX idx_hints_story ON hints(story_id);

CREATE TABLE spins (
    id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    story_id          UUID NOT NULL REFERENCES stories(id) ON DELETE CASCADE,
    phase             TEXT NOT NULL,
    country_code      TEXT REFERENCES countries(code),
    picked_motif_id   UUID REFERENCES corpus_motifs(id),
    created_at        TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_spins_story ON spins(story_id);
