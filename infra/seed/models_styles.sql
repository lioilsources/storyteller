-- Seed for the model/style registries (STORYTELLER_MODELS_PLAN.md §9.2):
-- one tier 0 (flux-schnell, active), one tier 1 (FLUX-dev + Redux),
-- one tier 1s (SDXL + watercolor LoRA), and the seven styles from
-- STORYTELLER_PLAN.md §1.4. Idempotent — safe to re-run.
--
-- Everything except flux-schnell/watercolor starts as `shadow`
-- (MODELS_PLAN §5.5): the nightly pipeline renders samples, someone
-- looks at them, then it's flipped to `active`. `version` is empty until
-- the corresponding /comfy workflow exists — a model with no version
-- must not be used for generation (its variant keys would be wrong to
-- roll forward later).
--
--   psql "$DATABASE_URL" -f infra/seed/models_styles.sql

INSERT INTO models (id, kind, tier, lora_driven, backend, workflow_txt2img, workflow_ref2img, workflow_i2v, version, status, notes) VALUES
  ('flux-schnell', 'image', 0, false, 'comfy',
   'comfy/workflows/flux-schnell/txt2img.json', NULL, NULL,
   '', 'active',
   'Tier 0 reference. 4 steps, 768². Always rendered first; every higher tier conditions on this.'),
  ('flux-dev', 'image', 1, false, 'comfy',
   'comfy/workflows/flux-dev/txt2img.json', 'comfy/workflows/flux-dev/ref2img.json', NULL,
   '', 'shadow',
   'Tier 1 quality. ref2img = Redux image conditioning + denoise 0.55–0.7 (MODELS_PLAN §2).'),
  ('sdxl-lora', 'image', 1, true, 'comfy',
   'comfy/workflows/sdxl-lora/txt2img.json', 'comfy/workflows/sdxl-lora/ref2img.json', NULL,
   '', 'shadow',
   'Tier 1s style-native. ref2img = IP-Adapter 0.5–0.7 + ControlNet depth/canny from tier 0. LoRA comes from styles.lora_path.')
ON CONFLICT (id) DO UPDATE SET
  kind = EXCLUDED.kind, tier = EXCLUDED.tier, lora_driven = EXCLUDED.lora_driven, backend = EXCLUDED.backend,
  workflow_txt2img = EXCLUDED.workflow_txt2img, workflow_ref2img = EXCLUDED.workflow_ref2img,
  workflow_i2v = EXCLUDED.workflow_i2v, notes = EXCLUDED.notes;
  -- deliberately NOT overwriting version/status/cost_sec/quality: those are owned by the pipeline / a human.

-- Shared child-safety negative prompt (PLAN §7). Styles append their own.
-- Prompts describe technique only — no artist or illustrator names (PLAN §1.4).
INSERT INTO styles (id, name_i18n, preferred_model, allowed_models, prompt_prefix, prompt_suffix, negative, lora_path, lora_strength, ref_strength, status, sort_order) VALUES
  ('watercolor',
   '{"en": "Watercolor", "cs": "Akvarel", "sk": "Akvarel", "de": "Aquarell", "pl": "Akwarela"}',
   'sdxl-lora', '{flux-schnell,sdxl-lora,flux-dev}',
   'soft watercolor children''s book illustration, ',
   ', gentle wet-on-wet washes, visible paper texture, warm light, simple shapes',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs',
   NULL, 0.8, 0.6, 'active', 10),
  ('papercut',
   '{"en": "Paper collage", "cs": "Papírová koláž", "sk": "Papierová koláž", "de": "Papiercollage", "pl": "Kolaż papierowy"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'layered paper cut-out collage illustration for children, ',
   ', flat torn-paper shapes, subtle drop shadows between layers, bright matte colors',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs',
   NULL, NULL, 0.6, 'shadow', 20),
  ('crayon',
   '{"en": "Crayon", "cs": "Pastelka", "sk": "Pastelka", "de": "Wachsmalstift", "pl": "Kredka"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'wax crayon drawing by a child''s illustrator, ',
   ', waxy strokes, slightly uneven outlines, cheerful primary colors, white paper background',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs',
   NULL, NULL, 0.6, 'shadow', 30),
  ('anime-lite',
   '{"en": "Anime (soft)", "cs": "Anime (jemné)", "sk": "Anime (jemné)", "de": "Anime (sanft)", "pl": "Anime (łagodne)"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'soft anime-style illustration for young children, ',
   ', big friendly eyes, clean lineart, pastel cel shading, calm composition',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs, mature',
   NULL, NULL, 0.6, 'shadow', 40),
  ('woodcut',
   '{"en": "Woodcut", "cs": "Dřevořez", "sk": "Drevorez", "de": "Holzschnitt", "pl": "Drzeworyt"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'friendly woodcut print illustration, ',
   ', bold carved outlines, limited two- or three-color palette, visible grain, folk-book feel',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs',
   NULL, NULL, 0.65, 'shadow', 50),
  ('clay',
   '{"en": "Clay", "cs": "Plastelína", "sk": "Plastelína", "de": "Knete", "pl": "Plastelina"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'stop-motion plasticine clay figures, ',
   ', soft studio lighting, fingerprint texture on the clay, shallow depth of field, miniature set',
   'scary, violence, blood, weapon, horror, dark, text, watermark, signature, deformed, extra limbs',
   NULL, NULL, 0.6, 'shadow', 60),
  ('folk',
   '{"en": "Folk classic", "cs": "Česká klasika", "sk": "Ľudová klasika", "de": "Volkskunst", "pl": "Ludowa klasyka"}',
   'flux-dev', '{flux-schnell,flux-dev,sdxl-lora}',
   'central european folk-art storybook illustration, ',
   ', decorative floral borders, embroidered-pattern motifs, earthy reds and blues, flat perspective',
   'scary, violence, blood, weapon, horror, dark, realistic photo, text, watermark, signature, deformed, extra limbs',
   NULL, NULL, 0.65, 'shadow', 70)
ON CONFLICT (id) DO UPDATE SET
  name_i18n = EXCLUDED.name_i18n, preferred_model = EXCLUDED.preferred_model, allowed_models = EXCLUDED.allowed_models,
  prompt_prefix = EXCLUDED.prompt_prefix, prompt_suffix = EXCLUDED.prompt_suffix, negative = EXCLUDED.negative,
  ref_strength = EXCLUDED.ref_strength, sort_order = EXCLUDED.sort_order;
  -- NOT overwriting lora_path/lora_strength/preview_url/status: set by hand once the LoRA is placed on Spark and samples reviewed.
