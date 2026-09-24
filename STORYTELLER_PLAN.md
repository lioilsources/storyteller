# STORYTELLER_PLAN.md — "Vyprávěj" (pracovní název)

> Handoff pro Opus / Claude Code. Cíl: appka, která **pomáhá rodičům vyprávět pohádky dětem**. Vypráví rodič, appka jen nabízí stavební kameny, poslouchá a napovídá, generuje obrázky/animace/hlasy s nízkou latencí. Nikdy nevypráví místo rodiče.

## 0. Principy (neměnné)

1. **Rodič je vypravěč.** Appka nikdy nepřehrává celý příběh. Nabízí volby, obrázky, nápovědu, zvuky.
2. **Latence < 1,5 s** od hlasu rodiče k nápovědě, obrázek do ~3 s (flux-schnell, 4 kroky).
3. **Dítě vidí obrázky, ne UI.** Volby a nápovědy vidí jen rodič (druhá obrazovka / horní lišta / hodinky).
4. **Nic nevyžaduje čtení.** Rodič může jen mluvit; appka funguje i s vypnutým displejem (jen hlasy/zvuky).
5. **Multijazyčnost od začátku** — všechny texty generované LLM, žádné hardcoded stringy v příbězích.
6. **Privacy:** hlas dítěte se nikdy neukládá; audio rodiče jen pro STT stream, neperzistuje se (default).

## 1. Produkt

### 1.1 Denní nabídka ("Dnešní pohádka")
Každý den (deterministicky ze `date + user_seed`) appka nabídne:
- **3 postavy** (např. Liška Bystruška, Kovářův syn, Mluvící mlýn) — s obrázkem ve zvoleném stylu
- **3 úkoly** (co musí hrdina udělat)
- **3 problémy** (překážka / záporák / dilema)
- **3 šťastné konce**

Rodič si vybere po jednom (nebo nechá dítě vybrat obrázek), nebo "zamíchat". Výsledek = **osnova příběhu** (4 body), ne text.

Kombinace jsou generované LLM z **korpusu motivů** (viz §3), takže se opakují motivy, ne konkrétní věty. Stejný den = stejná nabídka na všech zařízeních rodiny.

### 1.1b Planeta Země — centrální mechanika (hlavní obrazovka)
Střed appky je **otočný 3D glóbus**. V každém rozhodovacím bodě (postavy → úkol → zápletka/antagonista → řešení → konec) dítě nebo rodič **roztočí planetu** a kde se zastaví (nebo kam ťukne), odtud přijdou 3 nabídky.

- Postavy? Roztočím → Ukrajina → 3 postavy z ukrajinských pohádek.
- Úkol? Roztočím → Indie → 3 úkoly z indických příběhů (Pančatantra, Džátaky…).
- Zápletka/antagonista? Roztočím → např. Japonsko → 3 záporáci/překážky.
- Řešení a konec? Roztočím znovu.

Výsledek: **mix-kultur pohádka** (ukrajinská liška plní indický úkol proti japonskému démonovi a vše vyřeší po islandsku). To je hlavní USP — děti se mimoděk učí zeměpis a folklor.

Pravidla:
- Denní nabídka (§1.1) zůstává jako "rychlý start" bez točení; glóbus je plný režim.
- Zastavení glóbu: "Náhoda" (fyzika setrvačnosti + náhodný zemský bod) nebo "Vyber" (ťuknout na zemi). Oceán → nejbližší země nebo "ostrovní/námořní" motivy.
- Každá země má **min. 12 motivů** (3 na kategorii), jinak se sloučí do regionu (např. "Karibik", "Sahel"). Cílová pokrytost: ~150 zemí/regionů, zbytek fallback na kontinent.
- Po každém roztočení krátká **vizitka země**: vlajka, jedna věta ("V Indii se pohádky vyprávěly tisíce let ve sbírce Pančatantra"), zvuk typického nástroje (volitelně).
- Země se dá "připnout" (celá pohádka z jedné země) nebo "zakázat" (dítě má fázi, kdy chce jen Česko).
- Glóbus je viditelný i během vyprávění (zmenšený v rohu rodičovské lišty) — rodič může uprostřed příběhu roztočit pro "nečekaný host z…".

Vizuál glóbu: nízkopolygonový/stylizovaný, země se na dotyk zvýrazní ilustrací v aktuálním art stylu (viz §1.4b). Implementace: Flutter + `flutter_scene`/three-like přes `flutter_gl`, nebo jednodušeji 2D ortografická projekce s vlastním shaderem (rychlejší, stačí). Země = GeoJSON (Natural Earth 110m, public domain).

### 1.1c Prostředí a soundboard
Každá země má z korpusu odvozená **prostředí** (les, moře, poušť, hory, step, vesnice, město, palác, podzemí, nebe…) a pro každé prostředí **tvory a postavy**, které se v něm v pohádkách té země vyskytují (cs les: sýček, vlk, hejkal, liška; jp les: tanuki, kitsune, tengu; in džungle: tygr, opice, had, slon).

- Po výběru země/prostředí se rodiči zobrazí **soundboard**: ikona + jméno (přeložené) + jedno ťuknutí = zvuk (< 100 ms). Ambient smyčka prostředí běží potichu na pozadí (volitelně).
- Krátké hudební téma per země/prostředí (10–20 s loop) — hraje při vizitce země a na konci pohádky.
- Hlasové "echo" postav ze soundboardu (věta v TTS hlasem tvora) — viz §1.3.
- Krátké animace tvorů (2–3 s loop, sova mrkne, vlk zavyje) — na tap se přehraje místo statické ikony.
- Datový model: `environments(id, country_code, name_i18n, ambient_url, music_url, art jsonb)`, `creatures(id, environment_id, name_i18n, sound_url, voice_line_url, icon jsonb, anim_url, source_motif_ids[])`.
- Pipeline: `extract` v §3.2 navíc vytáhne `environments[]` a `creatures[]` per pohádka → agregace per země → `country_art` generuje i ikony/animace tvorů, `country_audio` generuje zvuky (viz §2.5).

### 1.1d Překlady
Všechno uživatelsky viditelné existuje ve všech supported jazycích: názvy zemí, vizitky, prostředí, tvorové, motivy, UI. Statické texty se překládají batch (LLM, `*_i18n jsonb`, review Tier 1 člověkem); dynamické texty (osnova, nápovědy) LLM generuje rovnou v jazyce rodiny. Chybějící jazyk → fallback en → on-the-fly překlad + uložení do cache.

### 1.2 Režim vyprávění ("Live")
- Rodič stiskne "Vyprávím" → STT stream.
- Appka sleduje, **kde v osnově rodič je** (postava představena? problém nastal? blíží se konec?).
- Když rodič zaváhá (ticho > 2,5 s nebo řekne "hm… a pak…") → **jemná nápověda**: 1 věta typu "…a v tu chvíli se z lesa ozvalo…" — zobrazí se rodiči, volitelně tichý šepot do sluchátka.
- Nápověda je vždy **otevřená** (nabízí směr, ne text k přečtení).
- Rodič může říct "obrázek" / "co vidí?" → vygeneruje se ilustrace aktuální scény.
- Tlačítko/hlasový povel "konec" → finální ilustrace + krátká animace + uložení do "Knihovny".

### 1.3 Hlasy postav
- Rodič vypráví, ale když řekne repliku postavy, appka může **přehrát krátký zvukový efekt / hlasový "echo"** postavy (např. vrčení draka, smích víly) — ne dabing, jen atmosféra. Volitelné, default off.
- Alternativa "Duet": rodič čte vypravěče, appka mluví hlasem jedné postavy (pro starší děti / unavené rodiče). Explicitně zapnout.

### 1.4 Vizuál
- **Art styly** (výběr v settings, per-příběh přepis): akvarel, papírová koláž, pastelka, anime-lite, dřevořez, 3D plastelína, česká klasika (inspirace lidovou ilustrací, ne konkrétním ilustrátorem).
- **Konzistence postav** napříč scénami: referenční obrázek postavy + IP-Adapter / redux na flux-schnell; případně LoRA per styl.
- **Arts pro země (§1.4b):** pro každou zaindexovanou zemi/region předgenerovaná sada v každém art stylu: ikona země na glóbu (256px), hero ilustrace (typická krajina + folklorní motiv), 3 základní postavy, 1 antagonista, 1 "kouzelný předmět". ~150 zemí × 7 stylů × ~7 obrázků ≈ 7 500 obrázků, flux-schnell na GB10 ≈ 3–4 h. Uloženo jako static assety (CDN přes Cloudflare), verzované per styl. Prompty generuje LLM z tagů země (krajina, oblečení, architektura, zvířata, nástroje) — obecné kulturní prvky, ne konkrétní chráněné postavy.
- **Animace:** 3–5 s loop (dech, mrkání, vítr, oheň) ze statického obrázku přes stávající video službu na comfyui.ol1n.com; generuje se na pozadí, zobrazí se, až je hotová (fallback = Ken Burns efekt na statice, okamžitě).

### 1.5 Knihovna
- Každá odvyprávěná pohádka = osnova + ilustrace + (volitelně) transkript rodiče + datum.
- Export: PDF "knížka" (obrázky + osnova), sdílení s druhým rodičem/prarodiči.
- "Vyprávěj znovu" — dítě chce stejnou pohádku desetkrát. Vždy stejná osnova, obrázky se nemění.

### 1.6 Jazyky
- Tier 1 (launch): cs, sk, en, de, pl
- Tier 2: es, fr, it, pt, uk, hu, ro, nl, sv, da, fi, no
- Tier 3: ja, ko, zh, ar, hi, tr… (STT/TTS kvalita dle dostupných modelů)
- Motivy korpusu jsou jazykově neutrální (ATU index), LLM generuje lokálně znějící jména a reálie (u polské verze polská jména, u japonské japonské prostředí).

## 2. Architektura

```
Flutter app (iOS/Android/iPad)
   │  WebSocket (audio stream + events)   HTTPS (REST)
   ▼
story-gateway (Go)  ← Caddy ← Cloudflare Tunnel  (JODA)
   ├─ session state (Postgres + Redis)
   ├─ daily-offer generator (cron, LLM)
   ├─ live-hint engine (STT stream → LLM stream)
   ├─ media-orchestrator (queue → Spark)
   └─ library / export / auth
        │
        ▼ Spark (GB10)
   ├─ vLLM via LiteLLM (osnovy, nápovědy, překlady)
   ├─ STT: faster-whisper / whisper-streaming (turbo) — jazyk auto
   ├─ TTS: Kokoro / XTTS-v2 / F5-TTS (nízká latence, klonování ne)
   ├─ ComfyUI: flux-schnell + IP-Adapter/redux, styl-LoRA
   └─ ComfyUI video: stávající služba comfyui.ol1n.com (animace loop)
```

### 2.1 Repo layout (monorepo `lioilsources/storyteller`)
```
/app            Flutter (Riverpod, go_router, record/just_audio, web_socket_channel)
/gateway        Go (chi, sqlc, golang-migrate, nhooyr/websocket)
/corpus         skripty na stažení + normalizaci pohádek, ATU index, motif DB
/comfy          workflows (JSON) + style presets + character-ref pipeline
/infra          docker-compose (JODA), Caddy, LiteLLM config, Spark services
/eval           testy nápověd (latence, "nevypráví za rodiče" guard)
```

> **Rozhodnutí 2026-09-24:** backend je celý v **Go** — i `/corpus` jsou Go CLI nástroje (`corpus/cmd/*`), žádný Python. Sdílené balíčky (`models`, `db`, `contentkey`) žijí v `/internal`, jeden Go modul pro celé repo.

### 2.2 Datový model (Postgres, sqlc)
- `families(id, locale, art_style, settings jsonb)`
- `daily_offers(id, family_id, date, characters jsonb[3], tasks jsonb[3], problems jsonb[3], endings jsonb[3], seed)`
- `stories(id, family_id, outline jsonb, style, lang, created_at, title)`
- `scenes(id, story_id, idx, prompt, image_url, anim_url, status)`
- `characters(id, family_id, name, description, ref_image_url, style)` — znovupoužitelné napříč pohádkami
- `hints(id, story_id, ts, text, accepted bool)` — pro učení, co rodič používá
- `corpus_motifs(id, atu_code, type: character|task|problem|ending, text_en, tags[], source_ref, country_code, region_code)`
- `countries(code, region_code, name_i18n jsonb, centroid, polygon_ref, folklore_blurb_i18n jsonb, motif_count, art jsonb{style→urls})`
- `regions(code, name_i18n, country_codes[])` — fallback pro řídce pokryté země
- `spins(id, story_id, phase, country_code, picked_motif_id)` — log roztočení pro učení a statistiku "kde už jsme byli"

### 2.3 Live-hint engine (kritická cesta)
1. Klient streamuje 16 kHz PCM Opus po WS (chunk 200 ms).
2. Gateway → whisper-streaming, partial transcripts každých ~500 ms.
3. Sliding window posledních ~60 s transkriptu + osnova → LLM (malý model, 4–8B, `max_tokens≈40`, streaming) s promptem: "Rodič vypráví. Osnova: … Rodič je právě u: … Navrhni JEDNU otevřenou větu, jak pokračovat. Nikdy nedokončuj příběh, nikdy neprozrazuj konec dřív než rodič."
4. Trigger nápovědy: ticho > 2,5 s **nebo** klíčová fráze ("napověz", "a pak?", "hmm") **nebo** manuální tap.
5. Předpočítávání: LLM generuje kandidáta nápovědy *průběžně* na pozadí (každých 10 s), takže v okamžiku ticha je připravená → latence ≈ 0.
6. Fáze-tracker: samostatný levný klasifikátor (nebo LLM s JSON výstupem) určuje `phase ∈ {intro, task, problem, climax, ending}` → řídí, které nápovědy jsou přípustné a kdy automaticky spustit ilustraci.

### 2.4 Media-orchestrator
- Job queue (reuse z AiStack pokud sedí; jinak Postgres `SKIP LOCKED`).
- Priorita: `hint-audio` > `scene-image` > `character-image` > `animation` > `export-pdf`.
- flux-schnell: 4 kroky, 768×768 → ~1–2 s na GB10; před vyprávěním se **předgenerují** 3 postavy + úvodní scéna, takže start je okamžitý.
- Cache podle `hash(prompt, style, char_refs)`.

### 2.5 Online vs. předpřipravené

Pravidlo: **co má zaznít/ukázat se okamžitě po ťuknutí = předpřipravené; co je unikátní pro tento příběh = online.**

| Předpřipravené (batch na Sparku, static assety na CDN) | Online (per session, Spark) |
|---|---|
| Korpus, motivy, prostředí, tvorové per země | Kombinace motivů → osnova, denní nabídka |
| Country arts, ikony prostředí, portréty typických postav (všechny styly) | Ilustrace konkrétní scény (flux-schnell, 1–3 s, z předpřipravených referencí) |
| Soundboard: zvuky tvorů, ambient smyčky, hudební témata | Nápovědy v live režimu (LLM stream) |
| Hlasová echa postav (TTS) | Animační loop konkrétní scény (na pozadí, Ken Burns fallback) |
| Krátké animace tvorů | Překlad dynamických textů |
| Překlady statických textů | |

**Audio pipeline (`country_audio`):** zvuky tvorů — Stable Audio Open / AudioLDM2 (text→sfx, 2–4 s) + pro reálná zvířata volitelně PD nahrávky (Freesound CC0, xeno-canto CC); ambienty — Stable Audio Open (30 s loop, crossfade); hudba — MusicGen/Stable Audio (10–20 s, per země tagy: nástroje, tempo). Odhad objemu: ~7 000 sfx + ~1 000 ambientů + ~300 témat; na GB10 1–2 dny batch. Normalizace LUFS, Opus 48k, ~150 MB per země-pack ve všech stylech → **stahuje se per země on-demand**, ne celý svět.

**Online/offline strategie** (miss queue → noční pipeline → packy → ranker preferující hotové) je rozpracovaná v **STORYTELLER_OFFLINE_PLAN.md**; víceúrovňové modely (flux-schnell jako reference, vyšší tiery async, přepínání stylů/modelů z lokální DB) v **STORYTELLER_MODELS_PLAN.md** — čti spolu s tímto dokumentem.

**Offline režim:** stažené country-packy (arts + audio + motivy + překlady) stačí na kompletní vyprávění bez nápověd a bez scénických ilustrací; online se jen přidává.

## 3. Korpus pohádek

**Právně:** stahovat jen **public domain / open licence**. Žádné moderní chráněné texty. Korpus slouží k extrakci **motivů** (postavy, úkoly, překážky, konce), ne k reprodukci textu uživatelům.

### 3.1 Zdroje
- Project Gutenberg (Grimm, Andersen, Perrault, Lang's Fairy Books, Arabian Nights, Æsop…)
- Wikisource (cs: Erben, Němcová, Kulda; sk, pl, de, fr, ru… národní klasiky)
- ATU index (Aarne–Thompson–Uther) — typologie zápletek; Thompson Motif-Index — motivy
- Internet Archive (jen PD skeny, OCR) — folklorní sbírky 19. stol.
- Folklore datasety na HF (zkontrolovat licenci každého)
- Volitelně: SurLaLune / Ashliman's Folktexts jako index (odkazy na PD texty)

### 3.2 Pipeline (`/corpus`)
1. `fetch` — per-zdroj scrapery, uložit raw + metadata (jazyk, autor, rok, licence, URL).
2. `clean` — odstranit hlavičky Gutenbergu, rozdělit na jednotlivé pohádky.
3. `classify` — LLM přiřadí ATU typ + **zemi/region původu** (ISO 3166, podle sběratele/sbírky, ne podle jazyka vydání) + věk-vhodnost + věk-vhodnost (0–3 / 3–6 / 6–10); vyřadit brutální varianty nebo označit `soft: true`.
4. `extract` — LLM z každé pohádky vytáhne strukturovaně: `characters[]`, `tasks[]`, `problems[]`, `endings[]` (každý 1 věta, en) + `tags` (les, moře, král, zvíře, kouzlo…).
5. `dedupe` — embedding + clustering, sloučit duplicity napříč jazyky/variantami.
6. `load` → `corpus_motifs` (cíl: 5–20k motivů; stačí bohatě).
6b. `coverage` — report zemí pod 12 motivů → doplnit cílenými zdroji (Ashliman index podle země, Wikisource národní sekce, UNESCO/PD folklorní sbírky), zbytek sloučit do regionu. Cíl před launchem: 150 zemí/regionů.
6c. `country_art` — z tagů každé země vygenerovat prompty a přes ComfyUI naplnit `countries.art` pro všechny styly.
7. Denní generátor pak **kombinuje** motivy z různých ATU typů (liška z ATU 1–299 + úkol z ATU 300–749 + konec z jiné) → nové, ale "pohádkově správné" osnovy.

Vše běží jednorázově na Sparku, výsledek je malá tabulka — appka za běhu korpus netahá.

## 4. Flutter app

- **Obrazovky:** Glóbus (domovská) → Roztoč × 4–5 fází (každá: glóbus → vizitka země → 3 karty) → Osnova (mapa s vlaječkami vybraných zemí) → … ; Dnes (3×4 karty) jako zkratka → Osnova (potvrzení) → Vyprávím (fullscreen obrázek pro dítě, dole tenký pruh pro rodiče) → Konec → Knihovna → Nastavení (jazyk, styl, hlasy, privacy).
- **Rodičovský pruh:** aktuální fáze, tlačítko "napověz", "obrázek", "zvuk", mikrofon stav. Na iPadu volitelně split: dítě vidí obrázek, rodič mobil jako "dálkové".
- **Druhé zařízení:** rodičův telefon = ovladač, tablet/TV (Chromecast/AirPlay) = obraz. Sync přes gateway session.
- **Offline fallback:** včera stažená denní nabídka + obrázky se cachují; bez sítě funguje vyprávění bez nápověd a generování.
- **Audio:** `record` pro stream, `just_audio` pro efekty, ducking při TTS.

## 5. Milníky

| M | Obsah | Odhad |
|---|---|---|
| M0 | Korpus: fetch+extract 500 pohádek (Grimm, Erben, Němcová, Lang), naplnit `corpus_motifs` | 3 dny |
| M1 | Gateway: denní nabídka + osnova + Postgres; Flutter: obrazovka Dnes + Osnova | 4 dny |
| M1b | Glóbus: Flutter ortografická projekce + spin fyzika + hit-test na Natural Earth GeoJSON; `GET /v1/spin?phase=&country=` → 3 motivy; vizitka země | 5 dní |
| M2b | Country arts: batch pipeline pro ~150 zemí × styly, CDN, cache | 2 dny |
| M2c | Prostředí + tvorové extrakce, soundboard UI, `country_audio` batch (sfx, ambient, hudba), country-packy on-demand | 5 dní |
| M2 | Media: comfy workflow flux-schnell + styl presety + konzistence postav; předgenerování | 4 dny |
| M3 | Live: WS audio → whisper-streaming → hint LLM → zobrazení; latence < 1,5 s | 5 dní |
| M4 | TTS efekty/hlasy postav, animace loop přes video službu, Knihovna + PDF export | 4 dny |
| M5 | i18n Tier 1, second-screen, offline fallback, privacy defaults | 3 dny |
| M6 | TestFlight + Play internal test, 5 rodin, ladění nápověd podle `hints.accepted` | 1 týden |

## 6. Otevřené otázky (rozhodnout před M3)

1. Malý model pro nápovědy: Qwen3-4B / Gemma-3-4B / Llama-3.2-3B na vLLM — benchmark latence a kvality v cs.
2. STT: whisper-streaming vs. Moonshine vs. Parakeet — cs kvalita a latence.
3. TTS bez klonování hlasů (privacy) — Kokoro stačí pro efekty? Pro "Duet" XTTS/F5?
4. Monetizace: free = 1 pohádka/den, 1 styl; premium = neomezeno, všechny styly, export, second-screen. Rodinné sdílení.
5. Provoz na vlastním Sparku vs. cloud GPU při růstu — architektura musí umožnit přepnout media-orchestrator na externí endpoint.

## 7. Guardrails obsahu

- Dětský filtr na výstupu LLM i promptu pro obrázky (žádné násilí explicitně, žádný horor pro 0–6, `soft` varianty motivů).
- Obrázky: negativní prompty, NSFW check (CLIP-based) před zobrazením.
- Nápověda nikdy nesmí obsahovat víc než 1 větu a nikdy konec.
- Rodič může kdykoli "zakázat motiv" (např. vlk) — uloží se do `families.settings`.

## 8. První krok pro Opus

0. Glóbus prototyp ve Flutteru (spin + zastavení na zemi + hit-test) — ověřit, že je to zábavné na dotyk, dřív než cokoliv jiného. **(zatím neuděláno)**
1. Založit monorepo, `/corpus/fetch_gutenberg.py` + `extract.py` (LLM přes LiteLLM na Sparku), naplnit `corpus_motifs` z Grimm + Erben + Němcová. **(v Go: `corpus/cmd/fetch-gutenberg` hotovo a ověřeno — 9 knih, 535 pohádek; `corpus/cmd/extract` napsáno, neběželo proti Spark LiteLLM; Erben/Němcová = cs.wikisource.org, samostatný fetcher TODO)**
2. `gateway`: endpoint `GET /v1/daily?family=&date=` vracející 3×4 nabídku z motivů (LLM kombinace, cache per den). **(deterministický seed-pick hotov, zatím ze seed korpusu, bez LLM a bez Postgresu)**
3. Flutter obrazovka "Dnes" napojená na tento endpoint, obrázky zatím placeholder → pak comfy. **(zatím neuděláno)**

Kroky pro offline/noční pipeline: **STORYTELLER_OFFLINE_PLAN.md §8** (krok 1 — `content_key` Go + Dart — hotov). Kroky pro model tiery / varianty: **STORYTELLER_MODELS_PLAN.md §9** (krok 1 — `key_base` + `variant`, `asset_variants` — hotov; krok 2 částečně).

## Stav

Aktuální stav a co spustit: `README.md` v rootu repa.
