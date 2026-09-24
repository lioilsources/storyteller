# STORYTELLER_OFFLINE_PLAN.md — Online → noční pipeline → offline-first

> Doplněk k STORYTELLER_PLAN.md. Cíl: **jeden Spark**, tisíce rodin. MVP jede online, ale každý dotaz, který se nestihne/nezvládne online, spadne do **noční pipeline**, výsledek se uloží jako offline asset, appka si ho při startu stáhne a **přednostně nabízí to, co už je hotové**. Postupem času se systém sám "vychladí" do offline-first.

## 0. Principy

1. **Vše má content-key.** Každý generovatelný artefakt (osnova, obrázek, zvuk, nápověda, překlad, animace) je deterministická funkce svých vstupů: `key = sha256(kind, model_ver, style, lang, normalized_inputs, seed)`. Stejný key = stejný výsledek, kdekoli a kdykoli.
2. **Čtyři vrstvy cache, dotaz padá dolů:** zařízení → CDN/globální cache → online generování (pokud je kapacita) → **miss queue** (noční pipeline).
3. **Miss není chyba.** Uživatel vždy dostane odpověď: buď hotový asset, nebo **nejbližší hotový** (embedding), nebo levný fallback (placeholder ve stylu, Ken Burns, generická nápověda) a artefakt se dodělá v noci.
4. **Nabídka preferuje hotové.** Všude, kde appka nabízí volby (denní nabídka, glóbus, scény), jsou kandidáti s hotovými assety řazeni nahoru. Uživatel to nevidí jako omezení, vidí "rychlé a krásné".
5. **Spark má dvě dráhy:** `online` (nízká latence, malý podíl GPU, přes den) a `batch` (noc + volná kapacita). Batch nikdy nezablokuje online.
6. **Predikuj zítřek.** Noční pipeline neřeší jen včerejší missy, ale i pravděpodobné zítřejší dotazy.

## 1. Datový tok

```
Klient
  │ request(kind, inputs) → key
  ├─ 1. device pack cache        hit → okamžitě (0 ms)
  ├─ 2. GET cdn/assets/{key}     hit → 50–200 ms
  ├─ 3. POST gateway/generate    online lane má kapacitu? → 1–3 s, uloží do CDN
  └─ 4. miss → gateway zapíše `misses(key, kind, inputs, family, ts)`
              → odpoví fallback (nearest / placeholder) + `pending: true`
              → klient zobrazí fallback, při dalším sync dostane pravý asset

Noc (22:00–07:00 Europe/Prague) na Sparku:
  misses ∪ predictions → dedupe → prioritize → generate → store → build packs → manifest++
Ráno:
  klient sync: GET manifest → diff → stáhne packy → nahradí fallbacky → přeřadí nabídky
```

## 2. Vrstvy

### 2.1 Zařízení (device pack)
- SQLite index `assets(key, kind, path, bytes, last_used, pack_id)` + soubory v app storage.
- **Packy** = zip per `(country|region, style, lang, kind_group)`; kind_group ∈ {`core` (motivy, překlady, ikony), `art`, `audio`, `hints`}. Core je malý (≤ 5 MB) a stahuje se pro všechny země rodiny; art/audio on-demand při prvním výběru země (nebo přednačtení pro "oblíbené" země).
- LRU eviction s limitem (default 1,5 GB, nastavitelné); nikdy nevyhazuje assety uložených pohádek v Knihovně.
- Sync při startu (a na pozadí 1× denně): `GET /v1/manifest?family=&since=` → seznam nových/změněných packů relevantních pro rodinu → download přes CDN, ověření hashem.

### 2.2 CDN / globální cache
- Object storage na JODA (MinIO) jako origin, Cloudflare R2 nebo CF cache před ním. Cesta `assets/{kind}/{key[0:2]}/{key}.{ext}`, immutable, cache-control 1 rok.
- `packs/{pack_id}.zip` + `manifest/{version}.json` (podepsaný).
- Gateway umí `HEAD` lookup bez GPU → hit na této vrstvě je levný.

### 2.3 Online lane (MVP default)
- vLLM + ComfyUI na Sparku s **rezervovaným rozpočtem** (např. 60 % GPU času přes den). Semafor v gateway: max N souběžných online jobů per kind (obrázek 2, LLM 8, TTS 4). Nad limit → rovnou vrstva 4 (miss), ne fronta — uživatel nesmí čekat víc než ~3 s.
- Vše, co online vygeneruje, se okamžitě zapíše do CDN → příště hit.
- Live nápovědy mají absolutní prioritu v online lane (viz §5).

### 2.4 Miss queue + noční pipeline
Tabulky:
- `misses(id, key, kind, inputs jsonb, family_id, ts, served_fallback_key)`
- `jobs(id, key, kind, inputs, priority, status, attempts, result_path, created_at, done_at)`
- `packs(id, country_code, style, lang, kind_group, version, bytes, manifest_hash)`
- `manifest_versions(version, created_at, changes jsonb)`

Noční běh (`nightly.go`, spouští cron na JODA, práce běží na Sparku):
1. **Collect** — všechny missy za den + predikce (§3) → `jobs`.
2. **Dedupe** podle key; sloučit rodiny → `demand = count(distinct family)`.
3. **Prioritize** — `score = w1·demand + w2·recency + w3·is_prediction_confidence + w4·kind_weight` (nápovědy a core > art > audio > animace). Deadline: co se nestihne do 07:00, přechází do dalšího dne s bonusem.
4. **Generate** — ComfyUI batch (queue prompt batch, stejný workflow, seed z key), vLLM batch (offline inference, `max_num_seqs` vysoko), TTS/audio batch. Sledovat GPU utilization; online lane dostane přednost, pokud přijde noční online provoz (rodiny v jiných zónách → Tier 2 jazyky).
5. **Validate** — NSFW/child filter, kontrola formátu, minimální kvalita (CLIP skóre prompt↔obrázek pod práh → regenerovat s jiným seedem, max 2×).
6. **Store** → MinIO/R2 pod key; **build packs** — přeskládat změněné packy (inkrementálně, ne celé), nová `manifest_version`.
7. **Notify** — pending záznamy u rodin → push "Tvá včerejší pohádka má nové obrázky" (volitelné, default off).
8. **Report** — hit-rate per vrstva, počet missů, co se nestihlo, GPU hodiny.

### 2.5 Determinismus (aby offline == online)
- Seed = prvních 8 B z key. Stejné modely, stejné workflow JSON verzované v repu; `model_ver` je součást key → upgrade modelu = nové keys, staré assety zůstávají platné (žádná invalidace, jen postupné nahrazení).
- Prompty se sestavují z **normalizovaných** vstupů (motif_id, environment_id, style_id, lang), ne z volného textu; volný text (transkript rodiče) se do key nikdy nedává, jde přes embedding→nearest.

## 3. Predikce zítřejších dotazů

Noční pipeline si sama vyrábí práci, aby ráno byla hit-rate co nejvyšší:
- **Denní nabídka na zítra** pro všechny aktivní rodiny je deterministická → vygenerovat všechny její postavy + úvodní scény + nápovědový bank předem (100 % hit ráno).
- **Kombinatorika glóbu:** pro top-N zemí rodiny (připnuté, historicky vybírané, geograficky blízké domovu) předgenerovat `core+art` ve stylu rodiny.
- **Popularita napříč rodinami:** motivy/země/styly s nejvíc missy globálně → celé packy.
- **Sousedství:** pokud rodina má pack pro CZ, přednačíst SK/PL/DE/AT (levné, pravděpodobné).
- **Scény:** pro každou uloženou osnovu dogenerovat 2–3 pravděpodobné scény (intro, problém, konec) v obou nejčastějších stylech rodiny.
- Rozpočet predikcí: max X GPU-hodin/noc, řazeno podle očekávané hit-rate (učí se z `hit_log`).

## 4. Přednostní nabízení hotového

Všechna místa, kde appka nabízí kandidáty, procházejí jedním rankerem:
```
rank(candidate) = base_relevance
               + 0.6 · has_local_asset
               + 0.3 · has_cdn_asset
               + 0.1 · asset_freshness
               − 0.5 · shown_recently
```
- **Denní nabídka:** ze 3×4 kandidátů bere přednostně motivy s hotovými portréty/ikonami; garance min. 1 kandidát na kategorii i bez assetu (aby se nabídka nezacyklila jen na hotové).
- **Glóbus:** po zastavení na zemi bez packu → nabídne 3 motivy z **regionu** s hotovými assety + tichý miss pro tu zemi; příště už hit. Vizuálně země bez packu na glóbu lehce "zamlžené" — dítě je může stále vybrat, rodič ví, že první obrázek bude fallback.
- **Scény při vyprávění:** požadovaná scéna → embedding → nearest hotová scéna se stejnými postavami a prostředím (cos ≥ 0,85 → použij rovnou, jinak online/miss).
- **Soundboard:** zobrazuje jen tvory se staženým zvukem; ostatní jako "stahuji…" ikonu.
- Diverzita: ranker má strop, kolikrát v týdnu smí stejný hotový asset "vyhrát" — jinak by offline-first vedlo k monotónnosti.

## 5. Co nejde plně offline a jak to řešit

| Funkce | Online | Offline náhrada |
|---|---|---|
| Live nápovědy (LLM stream) | vLLM na Sparku, absolutní priorita | **Hint bank**: noční pipeline vygeneruje per (motif, phase, lang) 5–8 otevřených vět → v packu `hints`; klient vybírá podle fáze a tichého rotování. Později volitelně on-device malý model (Gemma 3n / Qwen 0.6B přes llama.cpp) pro personalizaci |
| Fáze-tracker | LLM | On-device: klíčová slova z osnovy + jednoduchý klasifikátor (nebo tentýž malý model) |
| STT | whisper-streaming na Sparku | On-device: Apple Speech / Android SpeechRecognizer / whisper tiny přes `whisper_flutter` — stačí pro detekci ticha a klíčových frází |
| Scénická ilustrace | flux-schnell | nearest hotová scéna / Ken Burns na hero ilustraci prostředí |
| Animace scény | video služba | 2–3 s loop tvorů z packu, parallax na vrstvách |
| TTS echo postav | TTS na Sparku | předgenerované věty v packu `audio` |
| Denní nabídka | LLM | deterministická → vždy předgenerovaná den dopředu (nikdy online) |
| Překlady | LLM | v packu; chybějící → en fallback + miss |

## 6. Fáze zavedení

| Fáze | Stav | Kritérium přechodu |
|---|---|---|
| **F0 – MVP online** | vše online, ale **od prvního dne** loguje missy a zapisuje výstupy do CDN pod key; manifest/sync existuje, packy jen `core` | funguje s 5 rodinami |
| **F1 – noční pipeline** | missy + predikce denní nabídky se generují v noci; packy `art` | CDN hit-rate > 60 % |
| **F2 – offline-first** | ranker preferuje hotové; hint bank; on-device STT; country-packy on-demand | device+CDN hit-rate > 90 %, online lane < 30 % GPU přes den |
| **F3 – škálování** | free tier jen z packů (bez online generování), premium = online lane; případně druhý GPU box nebo cloud burst jen pro batch | Spark utilization plán |

## 7. Metriky (dashboard v gateway)

- hit-rate per vrstva (device / CDN / online / miss) per kind, denně
- p50/p95 latence online lane per kind
- velikost miss fronty ráno a večer, % nestihnutých
- GPU-hodiny: online vs. batch vs. predikce; hit-rate predikcí (kolik predikovaných assetů bylo do 7 dnů použito)
- velikost packů, průměrné stažení per rodina, evictions

## 8. Implementační kroky pro Opuse

1. `content_key` package (Go + Dart port): normalizace vstupů, key, seed. Testy na stabilitu. **✅ `internal/contentkey` (Go) + `app/packages/content_key` (Dart), sdílené golden vektory v `internal/contentkey/testdata/golden.json` — obě implementace se proti nim testují.**
2. Gateway: `GET /v1/asset/{key}` (302 na CDN nebo 404+miss), `POST /v1/generate` s semaforem online lane a zápisem do CDN, `misses` tabulka. **(tabulky v `infra/migrations/0002_offline.up.sql`; endpointy TODO)**
3. MinIO na JODA + Caddy `cdn.ol1n.com` (později R2). Immutable cesty, hash ověření.
4. Flutter: `AssetResolver` (device → CDN → generate → fallback) jako jediný vstupní bod pro všechny obrázky/zvuky/texty; SQLite index; LRU.
5. `nightly`: collect → dedupe → prioritize → generate (ComfyUI batch, vLLM offline) → validate → store → packs → manifest. Cron 22:00 na JODA, SSH/API na Spark.
6. Manifest + sync v klientovi; predikce denní nabídky jako první predikční zdroj.
7. Ranker s `has_local_asset` bonusem; hint bank generátor; on-device STT.
8. Dashboard metrik.
