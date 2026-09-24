-- STORYTELLER_MODELS_PLAN.md §3: model/style registries, asset variants,
-- family quality preferences.
--
-- `assets` (0002) becomes `asset_variants`: same rows, now keyed by the
-- v2 content key (internal/contentkey) with key_base + (model_id,
-- style_id, model_ver) split out. Renaming keeps pack_assets' FK intact.

-- ---------------------------------------------------------------------
-- Registries. Data, not code: adding a model or style is a row + a
-- workflow under /comfy, no release (MODELS_PLAN §0.4).
-- ---------------------------------------------------------------------
CREATE TABLE models (
    id                TEXT PRIMARY KEY,               -- 'flux-schnell', 'flux-dev', 'sdxl-lora', 'wan22-i2v', ...
    kind              TEXT NOT NULL CHECK (kind IN ('image', 'video', 'audio', 'tts', 'text')),
    tier              SMALLINT NOT NULL CHECK (tier BETWEEN 0 AND 3),
    lora_driven       BOOLEAN NOT NULL DEFAULT false, -- the "s" in tier 1s: quality comes from a style LoRA, not the base model
    backend           TEXT NOT NULL DEFAULT 'comfy',  -- comfy | vllm | tts
    workflow_txt2img  TEXT,                           -- paths under /comfy/workflows/{id}/
    workflow_ref2img  TEXT,
    workflow_i2v      TEXT,
    version           TEXT NOT NULL DEFAULT '',       -- workflow git hash; part of the variant key
    cost_sec          REAL,                           -- measured on GB10 by /comfy/bench, per 768² asset
    quality           REAL,                           -- 0–1, manual / A-B
    status            TEXT NOT NULL DEFAULT 'shadow' CHECK (status IN ('active', 'shadow', 'retired')),
    notes             TEXT
);

CREATE TABLE styles (
    id               TEXT PRIMARY KEY,                -- 'watercolor', 'papercut', 'crayon', 'anime-lite', 'woodcut', 'clay', 'folk'
    name_i18n        JSONB NOT NULL DEFAULT '{}',
    preferred_model  TEXT REFERENCES models(id),
    allowed_models   TEXT[] NOT NULL DEFAULT '{}',
    prompt_prefix    TEXT NOT NULL DEFAULT '',
    prompt_suffix    TEXT NOT NULL DEFAULT '',
    negative         TEXT NOT NULL DEFAULT '',
    lora_path        TEXT,
    lora_strength    REAL,
    ref_strength     REAL NOT NULL DEFAULT 0.6,       -- reference influence for ref2img (MODELS_PLAN §2)
    preview_url      TEXT,
    status           TEXT NOT NULL DEFAULT 'shadow' CHECK (status IN ('active', 'shadow', 'retired')),
    sort_order       INT NOT NULL DEFAULT 100
);

-- ---------------------------------------------------------------------
-- assets → asset_variants
-- ---------------------------------------------------------------------
ALTER TABLE assets RENAME TO asset_variants;
ALTER INDEX idx_assets_kind    RENAME TO idx_asset_variants_kind;
ALTER INDEX idx_assets_created RENAME TO idx_asset_variants_created;

ALTER TABLE asset_variants
    ADD COLUMN key_base     CHAR(64),
    ADD COLUMN model_id     TEXT REFERENCES models(id),
    ADD COLUMN style_id     TEXT REFERENCES styles(id),
    ADD COLUMN width        INT,
    ADD COLUMN height       INT,
    ADD COLUMN consistency  REAL,                     -- DINOv2 cos to the tier-0 reference; NULL for tier 0 itself / non-image
    ADD COLUMN status       TEXT NOT NULL DEFAULT 'ready'
                            CHECK (status IN ('ready', 'degraded', 'pending', 'failed'));

-- `style` (0002) is superseded by style_id → drop to avoid two truths.
ALTER TABLE asset_variants DROP COLUMN style;

-- Nothing has been inserted anywhere yet, so the new NOT NULLs are safe.
ALTER TABLE asset_variants
    ALTER COLUMN key_base SET NOT NULL,
    ALTER COLUMN model_id SET NOT NULL;

-- The lookup the resolver does: "all variants of this content in this
-- style", then pick the best tier (MODELS_PLAN §4).
CREATE INDEX idx_asset_variants_base ON asset_variants(key_base, style_id, model_id);

-- ---------------------------------------------------------------------
-- family_prefs (MODELS_PLAN §3) folded into families: families.art_style
-- already IS the style preference, so a separate table would create a
-- second source of truth for it.
-- ---------------------------------------------------------------------
ALTER TABLE families
    ADD COLUMN quality_mode   TEXT NOT NULL DEFAULT 'auto' CHECK (quality_mode IN ('fast', 'best', 'auto')),
    ADD COLUMN allow_upgrades BOOLEAN NOT NULL DEFAULT true,
    ADD COLUMN animations     BOOLEAN NOT NULL DEFAULT true;
