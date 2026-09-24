# STORYTELLER_MODELS_PLAN.md — flux-schnell jako reference, ostatní modely asynchronně, přepínání modelů/stylů z offline DB

> Doplněk k STORYTELLER_PLAN.md a STORYTELLER_OFFLINE_PLAN.md. Cíl: **flux-schnell je vždy první a rychlý** (online nebo predikovaný), ostatní (kvalitnější / stylově specifické / video) modely se **dogenerují asynchronně pro stejný obsah** a appka mezi nimi **přepíná okamžitě z lokální DB**, bez nového dotazu na Spark.

## 0. Principy

1. **Jeden obsah, více variant.** Klíč obsahu se dělí na `key_base` (co je na obrázku: motivy, postavy, prostředí, scéna, jazyk) a `variant = (model_id, style_id, model_ver)`. Asset = `(key_base, variant)`.
2. **Schnell = tier 0 = reference.** Pro každý `key_base` existuje jako první schnell varianta (1–2 s). Všechny vyšší tiery se generují **z ní jako reference** (kompozice, barvy, postavy), takže přepnutí modelu nezmění *co* je na obrázku, jen *jak* vypadá.
3. **Vyšší tiery jsou vždy async.** Nikdy neblokují UI; padají do noční/idle pipeline z OFFLINE_PLAN (§2.4) jako `upgrade` joby.
4. **Modely a styly jsou data, ne kód.** Registry v DB + ComfyUI workflow JSON v repu. Nový styl/model = nový řádek + workflow, bez releasu appky; klient si stáhne katalog v manifestu.
5. **Přepínání = dotaz do lokální SQLite.** Co je stažené, přepne se okamžitě; co není, ukáže nejlepší dostupný tier + zařadí miss.
6. **Konzistence napříč variantami je měřená**, ne doufaná: DINO/SSIM podobnost k referenci pod prahem → varianta se zahodí a regeneruje s silnějším vlivem reference.

## 1. Model tiery a role

| Tier | Role | Kandidáti na GB10 (ComfyUI) | Odhad / asset 768² | Kdy |
|---|---|---|---|---|
| 0 | **reference** (rychlý draft, online i predikce) | FLUX.1-schnell, 4 kroky | 1–2 s | vždy první |
| 1 | kvalitní statika | FLUX.1-dev / Krea, Qwen-Image, HiDream | 8–20 s | noc / idle |
| 1s | stylové (LoRA-driven) | SDXL + styl LoRA, FLUX-dev + styl LoRA (akvarel, koláž, dřevořez…) | 5–15 s | noc / idle |
| 2 | animace (I2V z tier 0/1) | Wan 2.2 I2V, LTX-Video, stávající video služba | 30–120 s | noc, jen pro použité scény |
| 3 | audio (nezávislé na obrázku) | Stable Audio Open, MusicGen, Kokoro/XTTS | různé | noc, per země |

Tier 1 vs 1s: některé styly mají "nativní" model (akvarel = SDXL+LoRA vypadá lépe než FLUX s promptem). Style registry říká, který model je pro styl **preferovaný** a které jsou **povolené**.

## 2. Referenční propagace (jak se z tier 0 dělá tier 1/2)

```
key_base ──► tier0: schnell txt2img (seed z key_base)
                │
                ├─► tier1/1s: ref2img — stejný prompt + reference:
                │     • FLUX-dev: Redux (image conditioning) + denoise 0.55–0.7
                │     • SDXL+LoRA: IP-Adapter (0.5–0.7) + ControlNet depth/canny z tier0
                │     • Qwen-Image / HiDream: img2img denoise 0.6 + prompt
                │     postavy: navíc IP-Adapter na referenční portrét postavy (z country pack)
                │
                └─► tier2: img2video — vstupní snímek = nejlepší dostupný tier (1 > 0)
                          + motion prompt z fáze příběhu (klid / vítr / hrozba / oslava)
```

- **Validace konzistence:** `DINOv2 cos(ref, variant) ≥ 0.80` a **stejný počet hlavních postav** (lehký detektor / VLM otázka "kolik postav, jaká zvířata"). Pod práh → regenerovat s vyšší silou reference (max 2×), pak označit `degraded` a nechat schnell.
- **Child filter** na každé variantě zvlášť (jiný model = jiné selhání).
- **Seed:** stejný seed z `key_base` pro všechny tiery — pomáhá stabilitě.
- Postavy napříč pohádkami: referenční portrét postavy (country pack) je **vždy** dodatečná reference, ať je tier jakýkoli, jinak se liška mezi scénami mění.

## 3. Registry (DB, součást manifestu → klient)

```sql
models(
  id text pk,            -- 'flux-schnell', 'flux-dev', 'sdxl-lora', 'wan22-i2v', 'stable-audio-open'
  kind text,             -- image | video | audio | tts
  tier int,
  backend text,          -- 'comfy'
  workflow_txt2img text, workflow_ref2img text, workflow_i2v text,  -- cesty v /comfy
  version text,          -- vstupuje do variant key
  cost_sec real,         -- měřeno na GB10, aktualizuje pipeline
  quality real,          -- 0–1, ruční/AB
  status text            -- active | shadow | retired
)
styles(
  id text pk,            -- 'watercolor', 'papercut', 'crayon', 'anime-lite', 'woodcut', 'clay', 'folk'
  name_i18n jsonb,
  preferred_model text references models,
  allowed_models text[],
  prompt_prefix text, prompt_suffix text, negative text,
  lora_path text, lora_strength real,
  ref_strength real,     -- síla reference pro ref2img u tohoto stylu
  preview_url text,      -- ukázka pro settings
  status text
)
asset_variants(
  key_base text, model_id text, style_id text, model_ver text,
  key text pk,           -- sha256(key_base, model_id, style_id, model_ver)
  path text, bytes int, width int, height int,
  consistency real, status text,   -- ready | degraded | pending | failed
  created_at timestamptz,
  primary key (key)
)
create index on asset_variants(key_base, style_id, model_id);
family_prefs(family_id, style_id, quality_mode text /* fast | best | auto */, allow_upgrades bool)
```

Klient má tytéž tři tabulky v SQLite (models, styles jako katalog z manifestu; asset_variants jen pro stažené).

## 4. Resolver na klientovi

```
resolve(key_base, style, quality_mode):
  wanted = quality_mode == fast ? [tier0] : styles[style].allowed sorted by tier desc
  for model in wanted:
     v = local.get(key_base, model, style)      → hit: return v (0 ms)
  for model in wanted:
     v = cdn.head(key_base, model, style)       → hit: download, return
  v = local.get(key_base, 'flux-schnell', *)    → jakýkoli styl schnell jako nouzovka
  online: if quality_mode != best_only and lane_has_capacity → schnell txt2img (1–2 s), uložit
  else: enqueue miss(key_base, style, tier0) ; return placeholder
  // vždy navíc:
  if best_local_tier < styles[style].preferred tier → enqueue upgrade(key_base, style, preferred_model)  (tichý, deduplikovaný)
```

- UI ukáže **badge kvality** (⚡ rychlá / ✦ krásná / ▶ animace) a **přepínač stylu/modelu** v rodičovské liště. Přepnutí = nový `resolve` s jiným `style`/`model`; pokud je lokálně, změna je okamžitá (crossfade 300 ms).
- Když dorazí upgrade (sync nebo push), obrázek se **tiše vymění** při příštím zobrazení, nikdy uprostřed vyprávění (rušilo by dítě) — výjimka: rodič klikne "vylepšit teď".
- Knihovna: uložená pohádka si pamatuje `variant` použitou při vyprávění; "Vyprávěj znovu" nabídne "zobrazit v krásné kvalitě", ale default drží, co dítě zná.

## 5. Upgrade pipeline (rozšíření noční pipeline z OFFLINE_PLAN §2.4)

Nové zdroje jobů:
1. **`hit_log` tier 0** — každý schnell asset, který byl reálně zobrazen (ne jen předgenerován) → upgrade na `preferred_model` stylu rodiny. Priorita = počet zobrazení × recency.
2. **Explicitní** "vylepšit" z appky → nejvyšší priorita, dokončeno idle-lane i přes den, pokud je kapacita.
3. **Přepnutí stylu** rodinou → celá poslední pohádka + denní nabídka v novém stylu (tier 0 hned online pokud lze, tier 1 v noci).
4. **Animace (tier 2)** jen pro scény typu `intro`, `climax`, `ending` uložených pohádek a pro hero ilustrace prostředí — ne pro všechno.
5. **Nový styl/model v registry (`shadow`)** → pipeline vygeneruje vzorky pro top-100 `key_base` globálně → ruční/AB kontrola → `active`.

Rozpočet: `upgrade` joby mají vlastní strop GPU-hodin/noc (např. 40 %), zbytek missy a predikce. Řazení uvnitř: tier 1 preferovaného stylu > tier 1s alternativ > tier 2.

Packy: `art` pack per (země, styl) obsahuje **všechny dostupné tiery** pro daný styl, ale klient v `fast` módu stahuje jen tier 0 podmnožinu (manifest má per-pack seznam variant a velikostí). `best` mód dostahuje tier 1 na Wi-Fi.

## 6. ComfyUI workflow konvence (`/comfy`)

```
/comfy/workflows/{model_id}/txt2img.json
/comfy/workflows/{model_id}/ref2img.json      # vstupy: prompt, ref_image, ref_strength, char_ref[], seed
/comfy/workflows/{model_id}/i2v.json          # vstupy: image, motion_prompt, seconds, seed
/comfy/styles/{style_id}.yaml                  # prompt_prefix/suffix, negative, lora, ref_strength, preferred_model
/comfy/bench/                                  # skript: změří cost_sec per model a zapíše do registry
```
- Všechny workflowy mají **stejné pojmenované vstupní uzly** (`IN_PROMPT`, `IN_REF`, `IN_SEED`, `IN_LORA`…), orchestrátor je plní generickým injektorem — přidání modelu = nový adresář, žádná změna v Go.
- Verze workflow = git hash → `models.version` → součást variant key.
- VRAM na GB10: modely se načítají podle noční fronty **v dávkách per model** (nejdřív všechny FLUX-dev joby, pak SDXL, pak Wan), aby se neswapovaly váhy; unified memory 128 GB to zvládne, ale přepínání stojí sekundy až desítky sekund.

## 7. Nastavení pro rodiče

- **Styl:** galerie stylů s náhledem (stejná scéna ve všech stylech = dobrá ukázka propagace z reference).
- **Kvalita:** `Rychlá` (jen schnell, nejmenší data) / `Krásná` (dostahuje tier 1 na Wi-Fi) / `Auto` (krásná pro uložené pohádky, rychlá pro denní nabídku).
- **Animace:** zap/vyp (data + baterie).
- Per pohádka: přepsat styl na "dnes chceme koláž".

## 8. Metriky

- % zobrazených assetů per tier (cíl: po 2 týdnech 70 % zobrazení v tier 1 u `best` rodin)
- doba od prvního zobrazení tier 0 → dostupný tier 1 (cíl < 24 h)
- consistency score distribuce per (model, styl); % `degraded`
- cost_sec per model (trend při změnách workflow)
- vliv přepínání stylu na retenci (kolik rodin přepíná, které styly vítězí)

## 9. Kroky pro Opuse

1. Rozdělit `content_key` na `key_base` + `variant`; migrace `asset_variants`; index. **✅ `internal/contentkey` v2 + Dart port, `infra/migrations/0003_models`**
2. `models` + `styles` registry, seed 1 tier 0 (schnell) + 1 tier 1 (FLUX-dev Redux) + 1 tier 1s (SDXL + akvarel LoRA); `/comfy` konvence a generický injektor vstupů. **✅ tabulky + seed v `infra/seed/models_styles.sql`; injektor hotov jako dva klienti podle `backend` sloupce — `internal/comfy` (ComfyUI, ověřeno naživo: flux-dev, ~45s/20 kroků) a `internal/nimqueue` (gen-queue/NIM, ověřeno naživo: flux-schnell, 2–4s — skutečný tier 0). Reálný nález 2026-09-24: schnell na tomhle Sparku vůbec neběží v ComfyUI, jen přes NIM; druhý NIM kontejner pro flux-dev (kvůli paritě) se dvakrát zasekl a byl opuštěn — dev zůstává na ComfyUI, kde funguje. ref2img (Redux) zatím nenapsáno.**
3. `ref2img` cesta v orchestrátoru + validace DINOv2/počet postav + child filter per varianta. **(zatím TODO — viz výše, jen txt2img obou backendů je ověřený)**
4. Klient: `AssetResolver.resolve` s quality_mode, badge, přepínač stylu, tichá výměna po syncu.
5. Upgrade joby z `hit_log` v noční pipeline s vlastním rozpočtem; packy s variantami + `fast/best` podmnožiny v manifestu.
6. `bench` skript → `cost_sec`; dashboard tierů.
7. Tier 2 (I2V) pro intro/climax/ending uložených pohádek.
