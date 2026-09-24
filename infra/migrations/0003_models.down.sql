ALTER TABLE families
    DROP COLUMN IF EXISTS animations,
    DROP COLUMN IF EXISTS allow_upgrades,
    DROP COLUMN IF EXISTS quality_mode;

DROP INDEX IF EXISTS idx_asset_variants_base;

ALTER TABLE asset_variants ADD COLUMN style TEXT NOT NULL DEFAULT '';
ALTER TABLE asset_variants
    DROP COLUMN IF EXISTS status,
    DROP COLUMN IF EXISTS consistency,
    DROP COLUMN IF EXISTS height,
    DROP COLUMN IF EXISTS width,
    DROP COLUMN IF EXISTS style_id,
    DROP COLUMN IF EXISTS model_id,
    DROP COLUMN IF EXISTS key_base;

ALTER INDEX idx_asset_variants_created RENAME TO idx_assets_created;
ALTER INDEX idx_asset_variants_kind    RENAME TO idx_assets_kind;
ALTER TABLE asset_variants RENAME TO assets;

DROP TABLE IF EXISTS styles;
DROP TABLE IF EXISTS models;
