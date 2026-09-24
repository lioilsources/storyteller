# STORYTELLER_PLAN.md — "Vyprávěj" (pracovní název, produkt: BedTimeStoryTeller)

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

Vizuál glóbu: nízkopolygonový/stylizovaný, země se na dotyk zvýrazní ilustrací v aktuálním art stylu (viz §1.4). Implementace: Flutter + `flutter_scene`/three-like přes `flutter_gl`, nebo jednodušeji 2D ortografická projekce s vlastním shaderem (rychlejší, stačí). Země = GeoJSON (Natural Earth 110m, public domain).

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
- **Arts pro země:** pro každou zaindexovanou zemi/region předgenerovaná sada v každém art stylu: ikona země na glóbu (256px), hero ilustrace (typická krajina + folklorní motiv), 3 základní postavy, 1 antagonista, 1 "kouzelný předmět". ~150 zemí × 7 stylů × ~7 obrázků ≈ 7 500 obrázků, flux-schnell na GB10 ≈ 3–4 h. Uloženo jako static assety (CDN přes Cloudflare), verzované per styl. Prompty generuje LLM z tagů země (krajina, oblečení, architektura, zvířata, nástroje) — obecné kulturní prvky, ne konkrétní chráněné postavy.
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

Backend (gateway i corpus tooling) je celý v **Go** — žádný Python v produkčním pipeline.

### 2.1 Repo layout (monorepo `lioilsources/storyteller`, jeden Go modul)
```
/app            Flutter (Riverpod, go_router, record/just_audio, web_socket_channel)
/gateway        Go (cmd/server, chi/stdlib router, sqlc/pgx, nhooyr/websocket)
/corpus         Go CLI nástroje: fetch (Gutenberg aj.), clean, extract (LLM), dedupe, load
/comfy          workflows (JSON) + style presets + character-ref pipeline
/infra          docker-compose (JODA), Caddy, LiteLLM config, migrace
/eval           testy nápověd (latence, "nevypráví za rodiče" guard)
/internal       sdílené Go balíčky (models, db) mezi /gateway a /corpus
```

### 2.2 Datový model (Postgres)
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

## 3. Korpus pohádek

**Právně:** stahovat jen **public domain / open licence**. Žádné moderní chráněné texty. Korpus slouží k extrakci **motivů** (postavy, úkoly, překážky, konce), ne k reprodukci textu uživatelům.

### 3.1 Zdroje
- Project Gutenberg (Grimm, Andersen, Perrault, Lang's Fairy Books, Arabian Nights, Æsop…)
- Wikisource (cs: Erben, Němcová, Kulda; sk, pl, de, fr, ru… národní klasiky)
- ATU index (Aarne–Thompson–Uther) — typologie zápletek; Thompson Motif-Index — motivy
- Internet Archive (jen PD skeny, OCR) — folklorní sbírky 19. stol.
- Folklore datasety na HF (zkontrolovat licenci každého)
- Volitelně: SurLaLune / Ashliman's Folktexts jako index (odkazy na PD texty)

### 3.2 Pipeline (`/corpus`, Go CLI nástroje pod `cmd/`)
1. `fetch-gutenberg` — per-zdroj stahovače, uložit raw + metadata (jazyk, autor, rok, licence, URL). ✅ implementováno (Grimm, Andersen, Perrault, Lang, Aesop).
2. `clean` (součást fetch/extract) — odstranit hlavičky Gutenbergu, rozdělit na jednotlivé pohádky podle obsahu (CONTENTS blok).
3. `classify` — LLM přiřadí ATU typ + **zemi/region původu** (ISO 3166, podle sběratele/sbírky, ne podle jazyka vydání) + věk-vhodnost (0–3 / 3–6 / 6–10); vyřadit brutální varianty nebo označit `soft: true`.
4. `extract` — LLM z každé pohádky vytáhne strukturovaně: `characters[]`, `tasks[]`, `problems[]`, `endings[]` (každý 1 věta, en) + `tags` (les, moře, král, zvíře, kouzlo…). ✅ prototyp implementován (`corpus/cmd/extract`).
5. `dedupe` — embedding + clustering, sloučit duplicity napříč jazyky/variantami.
6. `load` → `corpus_motifs` (cíl: 5–20k motivů; stačí bohatě).
6b. `coverage` — report zemí pod 12 motivů → doplnit cílenými zdroji (Ashliman index podle země, Wikisource národní sekce, UNESCO/PD folklorní sbírky), zbytek sloučit do regionu. Cíl před launchem: 150 zemí/regionů.
6c. `country_art` — z tagů každé země vygenerovat prompty a přes ComfyUI naplnit `countries.art` pro všechny styly.
7. Denní generátor pak **kombinuje** motivy z různých ATU typů (liška z ATU 1–299 + úkol z ATU 300–749 + konec z jiné) → nové, ale "pohádkově správné" osnovy.

Vše běží jednorázově na Sparku, výsledek je malá tabulka — appka za běhu korpus netahá.

## 4. Flutter app

- **Obrazovky:** Glóbus (domovská) → Roztoč × 4–5 fází (každá: glóbus → vizitka země → 3 karty) → Osnova (mapa s vlaječkami vybraných zemí) → …; Dnes (3×4 karty) jako zkratka → Osnova (potvrzení) → Vyprávím (fullscreen obrázek pro dítě, dole tenký pruh pro rodiče) → Konec → Knihovna → Nastavení (jazyk, styl, hlasy, privacy).
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

0. Glóbus prototyp ve Flutteru (spin + zastavení na zemi + hit-test) — ověřit, že je to zábavné na dotyk, dřív než cokoliv jiného. **(zatím neuděláno — viz stav níž)**
1. Založit monorepo, `corpus/cmd/fetch-gutenberg` + `corpus/cmd/extract` (LLM přes LiteLLM na Sparku), naplnit `corpus_motifs` z Grimm + Erben + Němcová. **(fetch-gutenberg hotovo pro Grimm/Andersen/Perrault/Lang/Aesop; Erben/Němcová jsou na cs.wikisource.org, ne Gutenberg — samostatný fetcher, zatím TODO; extract prototyp hotov, běh proti Spark LiteLLM zatím neotestován)**
2. `gateway`: endpoint `GET /v1/daily?family=&date=` vracející 3×4 nabídku z motivů (LLM kombinace, cache per den). **(hotovo jako deterministický seed-pick, zatím bez LLM kombinace a bez Postgres — in-memory fallback korpus)**
3. Flutter obrazovka "Dnes" napojená na tento endpoint, obrázky zatím placeholder → pak comfy. **(zatím neuděláno)**

## Stav (2026-09-24)

Viz `README.md` v rootu repa pro aktuální stav a co spustit dál.
