-- Offline-first plumbing (STORYTELLER_OFFLINE_PLAN.md §2.4, §3, §7) and
-- environments/creatures from STORYTELLER_PLAN.md §1.1c.

-- ---------------------------------------------------------------------
-- Generated assets, keyed by content key (internal/contentkey).
-- One row per artefact that exists in object storage. HEAD lookups in the
-- gateway hit this table, not MinIO/R2 (OFFLINE_PLAN §2.2).
-- ---------------------------------------------------------------------
CREATE TABLE assets (
    key         CHAR(64) PRIMARY KEY,               -- sha256 hex
    kind        TEXT NOT NULL,
    model_ver   TEXT NOT NULL DEFAULT '',
    style       TEXT NOT NULL DEFAULT '',
    lang        TEXT NOT NULL DEFAULT '',
    path        TEXT NOT NULL,                      -- assets/{kind}/{key[0:2]}/{key}.{ext}
    bytes       BIGINT NOT NULL DEFAULT 0,
    source      TEXT NOT NULL DEFAULT 'online'      -- online | nightly | prediction
                CHECK (source IN ('online', 'nightly', 'prediction')),
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now()
);
CREATE INDEX idx_assets_kind ON assets(kind);
CREATE INDEX idx_assets_created ON assets(created_at);

-- ---------------------------------------------------------------------
-- Layer 4: a request nobody could serve from device/CDN/online lane.
-- Not an error — the nightly run picks these up (§2.4 step 1).
-- ---------------------------------------------------------------------
CREATE TABLE misses (
    id                  UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key                 CHAR(64) NOT NULL,
    kind                TEXT NOT NULL,
    inputs              JSONB NOT NULL,             -- the normalized request, enough to regenerate
    family_id           UUID REFERENCES families(id) ON DELETE SET NULL,
    ts                  TIMESTAMPTZ NOT NULL DEFAULT now(),
    served_fallback_key CHAR(64)                    -- what the client got instead (nearest/placeholder), if anything
);
CREATE INDEX idx_misses_key ON misses(key);
CREATE INDEX idx_misses_ts ON misses(ts);

-- ---------------------------------------------------------------------
-- Nightly work queue. One row per key after dedupe; demand = how many
-- distinct families wanted it (§2.4 steps 2–3).
-- ---------------------------------------------------------------------
CREATE TABLE jobs (
    id            UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    key           CHAR(64) NOT NULL UNIQUE,
    kind          TEXT NOT NULL,
    inputs        JSONB NOT NULL,
    priority      DOUBLE PRECISION NOT NULL DEFAULT 0,   -- the §2.4 score; higher first
    demand        INT NOT NULL DEFAULT 1,
    is_prediction BOOLEAN NOT NULL DEFAULT false,
    status        TEXT NOT NULL DEFAULT 'queued'
                  CHECK (status IN ('queued', 'running', 'done', 'failed', 'deferred')),
    attempts      INT NOT NULL DEFAULT 0,
    result_path   TEXT,
    error         TEXT,
    created_at    TIMESTAMPTZ NOT NULL DEFAULT now(),
    started_at    TIMESTAMPTZ,
    done_at       TIMESTAMPTZ
);
CREATE INDEX idx_jobs_queue ON jobs(status, priority DESC) WHERE status IN ('queued', 'deferred');

-- ---------------------------------------------------------------------
-- Device download units (§2.1): zip per (country|region, style, lang,
-- kind_group). Rebuilt incrementally by the nightly run.
-- ---------------------------------------------------------------------
CREATE TABLE packs (
    id            TEXT PRIMARY KEY,                   -- e.g. "cz-watercolor-cs-art"
    country_code  TEXT REFERENCES countries(code),
    region_code   TEXT REFERENCES regions(code),
    style         TEXT NOT NULL DEFAULT '',
    lang          TEXT NOT NULL DEFAULT '',
    kind_group    TEXT NOT NULL CHECK (kind_group IN ('core', 'art', 'audio', 'hints')),
    version       INT NOT NULL DEFAULT 1,
    bytes         BIGINT NOT NULL DEFAULT 0,
    manifest_hash CHAR(64),
    path          TEXT,                               -- packs/{id}.zip
    built_at      TIMESTAMPTZ,
    CHECK (country_code IS NOT NULL OR region_code IS NOT NULL)
);
CREATE INDEX idx_packs_country ON packs(country_code);

CREATE TABLE pack_assets (
    pack_id   TEXT NOT NULL REFERENCES packs(id) ON DELETE CASCADE,
    asset_key CHAR(64) NOT NULL REFERENCES assets(key) ON DELETE CASCADE,
    PRIMARY KEY (pack_id, asset_key)
);

CREATE TABLE manifest_versions (
    version     BIGSERIAL PRIMARY KEY,
    created_at  TIMESTAMPTZ NOT NULL DEFAULT now(),
    changes     JSONB NOT NULL DEFAULT '{}'           -- {"packs_added": [...], "packs_updated": [...], "packs_removed": [...]}
);

-- ---------------------------------------------------------------------
-- Which cache layer answered (§7 metrics, §3 prediction feedback).
-- Append-only; roll up nightly, prune after a few weeks.
-- ---------------------------------------------------------------------
CREATE TABLE hit_log (
    id         BIGSERIAL PRIMARY KEY,
    ts         TIMESTAMPTZ NOT NULL DEFAULT now(),
    family_id  UUID,
    key        CHAR(64) NOT NULL,
    kind       TEXT NOT NULL,
    layer      TEXT NOT NULL CHECK (layer IN ('device', 'cdn', 'online', 'miss')),
    latency_ms INT
);
CREATE INDEX idx_hit_log_ts ON hit_log(ts);

-- ---------------------------------------------------------------------
-- STORYTELLER_PLAN.md §1.1c — environments per country and the creatures
-- that live in them (soundboard).
-- ---------------------------------------------------------------------
CREATE TABLE environments (
    id            TEXT PRIMARY KEY,                    -- e.g. "cz-forest"
    country_code  TEXT NOT NULL REFERENCES countries(code),
    kind          TEXT NOT NULL,                       -- forest | sea | desert | mountains | steppe | village | town | palace | underground | sky ...
    name_i18n     JSONB NOT NULL DEFAULT '{}',
    ambient_url   TEXT,
    music_url     TEXT,
    art           JSONB NOT NULL DEFAULT '{}'          -- {style: {icon_url, hero_url}}
);
CREATE INDEX idx_environments_country ON environments(country_code);

CREATE TABLE creatures (
    id                TEXT PRIMARY KEY,                -- e.g. "cz-forest-hejkal"
    environment_id    TEXT NOT NULL REFERENCES environments(id) ON DELETE CASCADE,
    name_i18n         JSONB NOT NULL DEFAULT '{}',
    sound_url         TEXT,
    voice_line_url    TEXT,
    icon              JSONB NOT NULL DEFAULT '{}',     -- {style: url}
    anim_url          TEXT,
    source_motif_ids  UUID[] NOT NULL DEFAULT '{}'
);
CREATE INDEX idx_creatures_environment ON creatures(environment_id);
