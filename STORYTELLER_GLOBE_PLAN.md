# StoryTeller — oživení glóbu (plán pro Opus)

Stav: fáze A–E hotové na větvi `feat/globe-alive` (viz §9), F–G zbývají. Návrh z 2026-10-06. Navazuje na STORYTELLER_PLAN.md §1.1b (glóbus jako
hlavní obrazovka) a na balíčky po kontinentech (§11, `app/lib/packs/`).
Sekce 6 (art) je podle rozhodnutí Directora z téhož dne.

## 0. Proč a co

Glóbus (`app/lib/globe/`) je dnes jen barevné plochy: zelená = máme pohádky,
šedá = nemáme, oranžová = pod středem. Dítě nemá důvod se na něj dívat.
Chceme:

1. **Ikonické stavby** — každá země aspoň jedna (Eiffelovka, Big Ben,
   Pražský hrad, Empire State, Kreml, Tádž Mahal, Sfinga…). Hlavní „kotva“,
   podle které dítě zemi pozná dřív, než umí číst.
2. **Přírodní jevy** schematicky a dětsky — hory, sopky, řeky, jezera,
   pralesy, pouště. Ne geograficky přesně; tak, jak to má dětský atlas.
3. **Zoom**, protože Evropa je na 360 px glóbu ~70 px široká a Česko ~8 px.
   Stejný problém má Karibik + Střední Amerika, JV Asie, západní Afrika,
   Levanta, Kavkaz, Tichomoří.

Nerozbít to, co funguje: tah = otáčení, švih = setrvačnost, ťuk = otočit na
zemi, „Roztočit“ = náhodné přistání, karta země dole, výběr země do
`storyDraftProvider`. Testy v `app/test/globe_test.dart` musí dál projít
(klíče `globe-canvas`, `globe-focus-name`, `globe-download`).

## 1. Hlavní rozhodnutí

### 1.1 Regiony = úrovně detailu, ne sloučené státy

Evropu (bez Ruska) nebudeme slučovat do jednoho „státu“ v datech — výběr
země pro pohádku musí dál fungovat, a Natural Earth nám dává jen polygony
zemí. Místo toho **region je úroveň detailu**:

- Při `zoom < region.minZoom` glóbus region kreslí jako **jeden tvar**:
  bez vnitřních hranic, s jedním společným obrysem, s **jednou hero
  ikonou** (Evropa → Eiffelovka) a s názvem regionu na kartě.
- Ťuk / dvojťuk na region, nebo přistání „Roztočit“ v regionu → **animovaný
  přílet** (zoom + otočení na střed regionu) na `region.zoomTo`. Odtud už
  jsou vidět jednotlivé země, každá se svou ikonou.
- Mimo regiony (Brazílie, Austrálie, Čína, USA, Kanada, Rusko…) se ikony
  kreslí hned při zoomu 1.

Trik na společný obrys bez geometrického union: nejdřív **všechny členské
polygony vytáhnout tlustým obrysem**, potom je vyplnit. Výplně překryjí
vnitřek tahu, zůstane jen vnější hrana regionu. Žádná nová geometrie, žádná
knihovna. Výplň zůstává per země (zelená/šedá), takže mapa pokrytí zůstává
poctivá i ve sloučeném regionu.

### 1.2 Zoom = škálování ortografické projekce

`GlobeProjection` dostane `radius = baseRadius * zoom` a kreslení se ořízne
na viewport (disk je větší než obrazovka). Projekce zůstává ortografická —
při zoomu 4–6 na jeden region je zkreslení u okraje zanedbatelné, protože
jsme na region otočeni čelem. Nic se nepřepisuje, jen se škáluje poloměr a
ořezávají body mimo plátno.

Rozsah `zoom ∈ [1, 8]`. Hodnoty: 1 = celý glóbus (dnešní stav), ~4 = Evropa
na výšku obrazovky, ~6 = Karibik / Levanta, 8 = strop (Lucembursko,
Singapur, ostrovní státy).

### 1.3 Ikony jsou billboardy ze sprite atlasu

Ikona se **neprojektuje** jako geometrie (otáčela by se a deformovala u
okraje). Projektuje se její kotva (lon, lat), ikona se kreslí vzpřímeně,
velikost `clamp(base * zoom^0.6, 20, 64) * depth`, kde `depth = 0.6 + 0.4 *
cosC` (ikony u okraje koule jsou menší a tlumené; při `cosC < 0.15` se
nekreslí). Všechny ikony v jednom `ui.Image` atlasu a jedno
`canvas.drawAtlas` na snímek — i při 300 ikonách je to levné.

### 1.4 Data ručně v repu, validovaná testem

Ikony, regiony a přírodní prvky jsou JSON v `app/assets/geo/`, autorované
ručně (seznamy vygeneruje LLM, člověk reviduje). Žádný build krok: dat je
pár set řádků a chceme je ladit v editoru. Test `app/test/geo_data_test.dart`
hlídá, že každá země má ikonu, že kotvy leží v polygonu své země a že
každý odkazovaný sprite v atlasu existuje — jinak se překlep tiše ztratí.

## 2. Data

### 2.1 `app/assets/geo/landmarks.json`

```json
[
  {"id": "eiffel", "iso": "FR", "n": "Eiffelova věž", "o": 2.29, "a": 48.86, "s": "eiffel", "p": 3},
  {"id": "prague-castle", "iso": "CZ", "n": "Pražský hrad", "o": 14.40, "a": 50.09, "s": "prague-castle", "p": 3},
  {"id": "sphinx", "iso": "EG", "n": "Sfinga", "o": 31.14, "a": 29.98, "s": "sphinx", "p": 3}
]
```

- `o`/`a` = lon/lat kotvy (konvence z `countries.json`), `s` = jméno
  spritu v atlasu, `p` = priorita 1–3 (3 = hero, kreslí se první, vyhrává
  kolize).
- Minimálně **1 ikona pro každou ze 175 zemí** v `countries.json`; velké
  země 2–4 (USA: Empire State, Golden Gate, Socha svobody, Mount Rushmore).
  Cíl první vlny ~220 staveb.
- Kotva smí být posunutá od skutečné polohy, pokud by se ikona jinak
  překrývala se sousedem nebo ležela na pobřeží mimo polygon (test
  `Country.contains` to odhalí). Pro mikrostáty (VA, MC, SM, LI, AD, MT,
  SG…) je kotva centroid z `countries.json`.

### 2.2 `app/assets/geo/regions.json`

```json
[
  {"code": "EU", "n": "Evropa", "isos": ["AD","AL","AT", "…bez RU…"],
   "hero": "eiffel", "center": {"o": 12, "a": 50}, "minZoom": 3.5, "zoomTo": 4.5},
  {"code": "CAR", "n": "Karibik a Střední Amerika", "isos": ["BZ","GT","HN","SV","NI","CR","PA","CU","JM","HT","DO","PR","…"],
   "hero": "chichen-itza", "center": {"o": -80, "a": 15}, "minZoom": 4, "zoomTo": 5.5},
  {"code": "SEA", "n": "Jihovýchodní Asie", "isos": ["TH","LA","KH","VN","MY","SG","BN","PH","ID","TL","MM"],
   "hero": "angkor-wat", "center": {"o": 108, "a": 8}, "minZoom": 3, "zoomTo": 4},
  {"code": "WAF", "n": "Západní Afrika", "isos": ["SN","GM","GW","GN","SL","LR","CI","GH","TG","BJ","NG","BF","ML","NE","MR"], "hero": "…", "center": {"o": 0, "a": 10}, "minZoom": 3, "zoomTo": 4},
  {"code": "LEV", "n": "Blízký východ", "isos": ["IL","PS","LB","SY","JO","CY","IQ","KW","QA","BH","AE","OM","YE"], "hero": "petra", "center": {"o": 40, "a": 30}, "minZoom": 3.5, "zoomTo": 5},
  {"code": "CAU", "n": "Kavkaz", "isos": ["GE","AM","AZ"], "hero": "…", "center": {"o": 45, "a": 41.5}, "minZoom": 5, "zoomTo": 7},
  {"code": "PAC", "n": "Tichomoří", "isos": ["FJ","VU","SB","PG","WS","TO","KI","…"], "hero": "…", "center": {"o": 170, "a": -15}, "minZoom": 3, "zoomTo": 4}
]
```

Regiony jsou jen **vizuální** — `rag/rag/continents.py` a balíčky se
nemění. Jedna země smí být nejvýš v jednom regionu (test). `EU` se liší od
kontinentu EU v `continents.py` tím, že nemá Rusko a Island/Grónsko se
rozhodnou podle toho, jak to vypadá (asi Island ano, Grónsko ne).

### 2.3 `app/assets/geo/features.json` — příroda

Čtyři tvary, všechny schematické:

| `t` | příklad | geometrie | kreslení |
|---|---|---|---|
| `peak` | Everest, Fudži (sopka), Kilimandžáro, Matterhorn, Vesuv | bod | sprite `mountain` / `volcano` |
| `range` | Alpy, Himaláj, Andy, Skalisté hory, Ural | lomená čára 3–8 bodů | řetěz 3–7 malých `mountain` spritů podél čáry, hustota podle zoomu |
| `river` | Nil, Amazonka, Dunaj, Mississippi, Jang-c’-ťiang, Volha | lomená čára 4–12 bodů | modrý vlnitý tah (kvadratická Bézierova křivka přes body), šířka `1.5 * zoom^0.5` |
| `area` | Sahara, Amazonský prales, Konžský prales, Gobi, Bajkal, Viktoriino jezero, Velký bariérový útes | polygon 4–10 bodů | výplň s texturou: poušť = tečky, prales = rozsypané `tree` sprity, jezero = plná modrá |

```json
{"id": "nile", "t": "river", "n": "Nil", "pts": [[32.9,0.4],[31.6,4.9],[32.5,15.6],[32.9,24.1],[31.2,30.1],[31.0,31.5]]}
{"id": "sahara", "t": "area", "n": "Sahara", "pts": [[-15,20],[-5,28],[10,31],[25,30],[35,22],[30,16],[10,15],[-10,16]]}
{"id": "fuji", "t": "peak", "n": "Fudži", "s": "volcano", "o": 138.73, "a": 35.36}
```

Prvky nemají `iso` — Dunaj protéká deseti státy. Na kartě se ukáže jen
název, když dítě na prvek ťukne. První vlna ~40 prvků: 10 řek, 8 pohoří, 8
vrcholů/sopek, 6 pouští, 4 pralesy, 4 jezera, 1 útes.

### 2.4 Jak vzniknou seznamy

`rag/rag/landmarks.py` (Python, vedle ostatních LLM skriptů): pro každou
zemi z `countries.json` požádat Claude o 1–4 stavby, které pozná
předškolák z obrázků (ne „nejvýznamnější“, ale **nejrozpoznatelnější
siluetou**), s lon/lat a českým názvem ve 2–3 slovech. Výstup JSONL →
ruční review v jednom průchodu (175 řádků, hodina práce) → `landmarks.json`.
Pro přírodu stejně, ale seznam je krátký a napíše se rovnou ručně.

## 3. Mechanika zoomu (`app/lib/globe/`)

### 3.1 `globe_projection.dart`

- `radius` už je parametr; zoom se dělá v `GlobeScreen` (`radius = base *
  _zoom`). Nic se nemění kromě přidání `double cosC(lon, lat)` (teď je to
  privátní výpočet uvnitř `project`) — ikony potřebují hloubku pro
  velikost/tlumení a `isVisible` je jen jeho znaménko.

### 3.2 `country.dart`

- Přidat `bbox` (minLon, minLat, maxLon, maxLat) spočítaný při načtení.
  Při zoomu 6 jsou mimo plátno stovky polygonů; `_pathFor` je dnes staví
  všechny. Culling: projektovat 4 rohy + střed bboxu, pokud nic nepadne do
  plátna rozšířeného o 20 %, zemi přeskočit. (Antimeridiánové země — RU,
  FJ, KI — mají bbox přes celý svět, ty cullingem jen propadnou, jako dnes.)
- `CountryIndex.at()` zůstává. Nový `LandmarkIndex` a `RegionIndex`
  (vlastní soubory `landmark.dart`, `region.dart`) načítané ve
  `FutureProvider`ech stejně jako `countryIndexProvider`, aby šly v testech
  předhodit hotové.

### 3.3 `globe_screen.dart` — stav a gesta

Nový stav: `_zoom` (1.0), `_zoomAnim` (AnimationController ~450 ms,
`Curves.easeInOutCubic`, animuje současně `_lat`, `_lon`, `_zoom`).

| gesto | dnes | nově |
|---|---|---|
| tah | otáčení | otáčení, stupně/px dělené `_zoom` |
| švih | setrvačnost | stejná, rychlost dělená `_zoom`; tření stejné |
| ťuk na zemi | otočit na ni | zoom 1 + země v regionu → přílet na `region.zoomTo`; jinak otočit (jako dnes) |
| ťuk na ikonu | — | otočit na kotvu, karta ukáže název ikony + zemi |
| dvojťuk | — | zoom ×2 do místa ťuku (strop 8) |
| pinch | — | `onScaleUpdate`: `_zoom *= details.scale` (po snímku), střed otáčení pod prsty se drží; pan a pinch jdou oba přes `GestureDetector.onScaleUpdate` (Flutter neumí pan + scale paralelně jinak) |
| „Roztočit“ | náhodný švih | nejdřív animace zpět na zoom 1 (pokud > 1.2), pak švih; po zastavení v regionu auto-přílet do něj a teprve pak se vybere země pod středem |
| tlačítko „Celá planeta“ | — | malé tlačítko vpravo dole nad kartou, vidět jen při `_zoom > 1.2`, animuje na zoom 1 |

`_turnTo` dnes skočí okamžitě; nahradit animací přes stejný controller
(krátká, 300 ms) — s ikonami okamžitý skok vypadá jako chyba.

### 3.4 Karta země (`_CountryCard`)

- **Region pod středem při zoomu < minZoom:** titul „Evropa“, podtitul
  „31 zemí · ťukni a přibliž se“, hero ikona vlevo, tlačítko „Přiblížit“
  místo „Použít“. Tlačítko „Použít“ nikdy nevybere region — pohádka
  potřebuje zemi.
- **Země:** jako dnes, navíc ikona země vlevo (její hero sprite) a pod
  názvem země řádek s názvem stavby („Pražský hrad“). Když je pod středem
  přírodní prvek (ťuk na něj), řádek ukáže jeho název.
- Klíče `globe-focus-name` a `globe-download` zůstávají na stejných
  widgetech.

### 3.5 Text nápovědy nahoře

„Roztoč planetu nebo ťukni na zemi. Zelené země už mají pohádky…“ doplnit
o „Přibliž si Evropu dvěma prsty.“ jen při zoomu 1; při zoomu > 1 místo
toho „Ťukni na stavbu.“ Jedna věta, ne odstavec.

## 4. Vykreslení (`globe_painter.dart`)

Pořadí vrstev na snímek:

1. oceán (jako dnes)
2. **obrysy regionů** (jen při `zoom < region.minZoom`): členské polygony
   `stroke` šířky 2.5 barvou `_landStroke` tmavší
3. výplně zemí (zelená/šedá, zvýrazněná jako dnes) + tenké obrysy; u
   členů sloučeného regionu se tenký obrys **vynechá**
4. `area` prvky (pouště, pralesy, jezera) — výplň se vzorem, ořez na
   plátno; vzor je `ImageShader` z malé dlaždice (tečky písku) nebo
   rozsypané sprity s deterministickým seedem z `id`
5. `river` — vlnitý tah
6. `range` — řetěz spritů
7. **ikony** (`peak` + landmarks): seřadit podle `p` sestupně, pak podle
   `cosC`; greedy umístění — ikona se vynechá, když její obdélník
   (rozšířený o 4 px) protíná už umístěnou. Při zoomu 1 v regionu se kreslí
   jen hero. Výsledek umístění (`List<PlacedIcon>` s obdélníky) painter
   vrací přes callback nebo pole v `GlobeScreen`, aby ťuk mohl trefit ikonu
   bez druhého průchodu.
8. zvýrazněná země (jako dnes, nad sousedy)
9. limb shading (jako dnes)

`shouldRepaint` doplnit o `zoom`, `landmarks`, `features`, `regions`
(porovnání referencí jako u `coveredIsos`).

Ikony animují „vyskočení“ při příletu do regionu: každá ikona má
`appearT ∈ [0,1]` řízený stejným controllerem s malým náhodným offsetem
(`id.hashCode % 7 * 30 ms`), scale `elasticOut`. Když je `_zoom` pod
`minZoom`, `appearT = 0`.

### 4.1 Atlas (`sprite_atlas.dart`)

- Sprity přijdou v balíčku **`globe.icons`** (viz 6.1, rozhodnutí
  Directora): zip s `atlas.webp` (RGBA, 256 px na sprite, max 4096×4096;
  druhý atlas, kdyby bylo víc než 256 spritů) + `atlas.json` (`{name: [x,
  y, w, h]}`). Vyrábí ho `app/tool/build_globe_atlas.py` z adresáře
  jednotlivých spritů (`rag/data/globe_sprites/<name>.webp`).
- Balíček je `bundled: true` jako Evropa — kopie zipu je v binárce
  (`app/assets/rag/packs/`, pin v `app/rag_packs.sha256`) a `PackRepository`
  ho umí přepsat novější verzí z manifestu bez vydání appky. Načtení:
  `SpriteAtlas.load(dir)` → `ui.Image` + mapa; `FutureProvider` nad
  `packRepositoryProvider`, přepočítá se při `installedPacksRevisionProvider`.
- Painter kreslí `canvas.drawAtlas(image, transforms, rects, colors,
  blendMode, cullRect, paint)` — jedno volání na všechny ikony.
- **Placeholder do doby, než je art:** `PlaceholderSprites` kreslí
  z `Path` tři tvary (dům se špičkou pro stavby, trojúhelník pro horu,
  kapka pro přírodu) v barvě podle typu. Mechanika, kolize, zoom, karta a
  testy se dělají proti placeholderům; výměna za atlas je jen záměna
  `drawPath` → `drawAtlas`. **Nečekat s mechanikou na art.**

## 5. Testy

`app/test/globe_test.dart` rozšířit, `app/test/geo_data_test.dart` přidat:

- data: každá země v `countries.json` má ≥ 1 landmark; každá kotva leží v
  polygonu své země (pro antimeridiánové země aspoň do 12° od centroidu,
  jako `oceanSnapDegrees`); každé `s` existuje v atlasu (nebo v
  placeholderech); každá země nejvýš v jednom regionu; `hero` každého
  regionu patří zemi z regionu.
- gesta: pinch přes `TestGesture` zvedne zoom; dvojťuk zoomuje; „Celá
  planeta“ vrátí zoom 1; tah při zoomu 4 otočí o čtvrtinu úhlu než při 1.
- region: s zoomem 1 a středem na Německu karta hlásí „Evropa“ a tlačítko
  „Přiblížit“; po ťuku je `_zoom ≥ 3.5` a karta hlásí zemi.
- ťuk na ikonu: `PlacedIcon` pod ťukem → karta ukáže „Eiffelova věž“.
- umístění: dvě ikony se stejnou kotvou → umístí se jen ta s vyšší `p`.
- výkon: `GlobePainter.paint` při zoomu 6 nad Evropou staví < 60 cest
  (culling funguje) — měřit počítadlem v painteru pod `assert`.
- screenshoty (`app/test/screenshots_test.dart`, `app/test/failures/`):
  přidat snímek „glóbus zoom 1“ a „Evropa zoom 4.5“ s placeholdery; po
  dodání artu zlaté obrázky přegenerovat.

## 6. Art — rozhodnutí Directora (2026-10-06)

Director dělá renderovací pipeline (karty, scény) a rozhodl za art takto.
Opus se toho drží; změny stylu nebo kapacity řeší s ním, ne sám.

### 6.1 Technika a uložení

- **Rastr přes flux-schnell (NIM), ne SVG.** Render 1024², výřez pozadí,
  zmenšení na RGBA WebP 256 px (+ varianta 128 px pro mapu). Nálepka s
  tlustým obrysem se ve 24–64 px čte dobře; LLM-generované SVG budov
  vychází hranaté a nepoznatelné. flux-schnell je Apache-2.0, komerčně
  čistý.
- **Výřez pozadí:** generovat na ploché jednobarevné pozadí, vyříznout v
  ComfyUI-RMBG (BiRefNet, ~4 s/obrázek, **jen v okně 07–13**) nebo
  klíčováním na Macu (rembg).
- **Past: flux ignoruje „no text“.** U staveb hrozí nápisy, cedule, hodiny
  s čísly (Big Ben!). Každý render projet OCR přes `tools/find-lettering.swift`,
  vadné přerenderovat s `-reroll`.
- **Uložení: samostatný balíček `globe.icons`** ve schématu manifestu 3
  (`app/lib/packs/pack_manifest.dart`), `bundled: true` jako Evropa. Zveřejňuje
  se přes `storyteller-content` (`rag/publish_packs.sh`) a aktualizuje bez
  vydání appky — stačí zvednout verzi. Ne do `assets/` (aktualizace by
  chtěly release), ne do `core.cs.db` (core je jen v binárce). ~250 × ~15 KB
  ≈ 4 MB.

Pro Opus to znamená: `PackManifest` dostane sekci `icons` (version, size,
sha256, file) a `PackRepository` typ balíčku bez země a bez kontinentu,
`installIcons()` + `iconsDir()`. Manifest v `rag/rag/pack_builder.py` ho
musí emitovat; v `rag/data/dist/bundle/` musí vzniknout kopie pro binárku.

### 6.2 Styl

- Style guide neexistuje, framing je v kódu:
  `internal/nimqueue/cmd/render-motifs/main.go`, mapa `framings`
  (`watercolor` tier 0, `pixar-3d` = pixar-v1). Seed nezávisí na stylu.
- **Přidat framing `-style sticker`:** „Cute sticker icon of <X>, thick
  white outline, soft flat shading, consistent top-left light, centered,
  single object, plain flat <barva> background“. Prompt popisuje **objekt,
  ne scénu**.
- Ověřené vzory nálepkového stylu na flux-schnell: SwypeKids
  `drafts/stickers/*/prompts.json` + `run_batch.py` (3 kola), Mutants styl
  „nálepka“.
- Příroda: `mountain`, `volcano`, `tree` jako sprity ve stejném framingu;
  řeky a jezera jsou jen barva, poušť dlaždice `sand` 64×64. Celkem ~6
  přírodních spritů.

### 6.3 Seznam a review

- **Stavby:** Claude vygeneruje 1–2 ikonické stavby na zemi pro země
  z manifestu `storyteller-content` → `countries` (dnes 98), plus ruční
  review seznamu. Pozn. k 2.1: země mimo manifest (zbytek ze 175 v
  `countries.json`) dostanou ikonu ve druhé vlně — glóbus musí snést zemi
  bez ikony (nic se nekreslí, karta bez řádku stavby). Test z §5 „každá země
  má ikonu“ se proto zapíná až po druhé vlně; do té doby hlídá jen země
  z manifestu.
- **Příroda:** pevný katalog ~20–30 typů, mapování na místa ručně přes
  geodata (`features.json`), ne LLM. Tagy `environments` v motivech jsou pro
  scény, na glóbus se nehodí.
- **Review:** HTML arch po vzoru `rag/data/pixar-review.html` vedle
  obrázků — klik = vadná, export JSON pro reroll. Kritérium: pozná to
  pětileté dítě na 48 px?

### 6.4 Kapacita a spouštění

- flux-schnell ~2,7 s/obrázek sólo, 5–10 s ve sdílené frontě. 250 ikon × 3
  varianty = 750 rendrů ≈ 1 h v jednom okně (07:15–12:50 nebo 19:15–00:50).
- Ve všech oknech teď jedou karty StoryTelleru (zbývá ~10 tis., 1–2 dny);
  ikony se vedle toho do fronty vejdou.
- **Opus dávku pouští sám** přes HTTP z Macu: gen-queue
  `http://192.168.88.66:8091`, souběžnost 2 — ale **předem ji ohlásí
  Directorovi** (čas a počet). Na SPARKu nic nestartovat. Výřez pozadí v
  ComfyUI jen 07–13.
- API, povolené rozměry NIM a pasti: AiStack `docs/IMAGE-GEN-GUIDE.md`.

### 6.5 Pořadí výroby

1. hero ikony regionů (7) + největší země mimo regiony (~20) → ověřit styl
   na glóbu při zoomu 1
2. Evropa kompletní (~45) → ověřit zoom 4.5
3. zbytek zemí z manifestu (~50), potom druhá vlna mimo manifest
4. příroda (6 spritů)

## 7. Fáze pro Opus

| fáze | co | hotovo když |
|---|---|---|
| **A. data** | `landmarks.json` (175+), `regions.json` (7), `features.json` (~40), `rag/rag/landmarks.py`, `geo_data_test.dart` | test projde, každá země má ikonu |
| **B. zoom** | `_zoom`, pinch/dvojťuk, culling přes bbox, animovaný `_turnTo`, „Celá planeta“, text nápovědy | pinch na Evropu, země jdou rozlišit, 60 fps na iPhone 11 při zoomu 6 |
| **C. regiony** | `RegionIndex`, sloučený obrys, karta regionu, auto-přílet po „Roztočit“ | Roztočit → přistání v Evropě → přílet → vybraná země |
| **D. ikony (placeholder)** | `SpriteAtlas` + `PlaceholderSprites`, greedy umístění, `PlacedIcon` hit-test, animace vyskočení, řádek na kartě | ťuk na placeholder u Paříže → „Eiffelova věž, Francie“ |
| **E. příroda** | čtyři typy kreslení, vzory, seed | Nil, Sahara, Alpy, Fudži vidět a nepřekáží ikonám |
| **F. balíček `globe.icons`** | sekce `icons` v manifestu (Dart + `pack_builder.py`), `installIcons`, bundled kopie, `build_globe_atlas.py`, `SpriteAtlas` nad balíčkem | prázdný/placeholder atlas se nainstaluje a načte z balíčku, test v `pack_repository_test.dart` |
| **G. art** | framing `sticker` v `render-motifs`, seznam staveb (6.3), dávka ohlášená Directorovi, OCR kontrola, review arch, výměna placeholderů, nové zlaté screenshoty | glóbus bez placeholderů pro země z manifestu, atlas ≤ 4 MB |

A–F jdou bez renderů. G čeká na okno ve frontě (6.4) a na Directorův
souhlas s časem dávky. Každá fáze = jedna větev + PR, jako dosud
(`feat/globe-zoom`, `feat/globe-regions`, …).

## 8. Mimo rozsah (zatím)

- Vlajky a zvuk nástroje z §1.1b — až po ikonách; vlajka se vejde na kartu
  vedle hero ikony.
- Noc/den, mraky, animovaná voda — vizuální cukr, až bude obsah.
- Ikony jako filtr motivů („pohádky od Eiffelovky“) — ikona je jen kotva
  země, motivy jdou dál per země/balíček.
- Změny v `rag/rag/continents.py`, manifestu balíčků nebo `countries.json`
  — glóbus čte, nic z toho nepřepisuje.

## 9. Stav implementace

### 2026-10-06, větev `feat/globe-alive`: fáze A–E s placeholdery

Hotovo: data (239 staveb pro všech 175 zemí, 7 regionů, 64 přírodních
prvků), zoom 1–8 (pinch, tlačítka, culling), sloučené regiony s příletem,
ikony s řešením kolizí a ťukem, příroda (řeky, pohoří, vrcholy, pouště,
pralesy, jezera). Ikony staveb jsou **kreslené placeholdery** (věž, kupole,
hrad, chrám, dům podle hashe jména) — skutečný art je fáze G.

Odchylky od plánu výše a proč:

| Plán | Skutečnost | Důvod |
|---|---|---|
| dvojťuk = zoom ×2 (§3.3) | tlačítka + / − / „Celá planeta“ vpravo dole | `onDoubleTap` zdrží každý jednoduchý ťuk o 300 ms; na glóbu, kde je ťuk hlavní gesto, je to znát. Pinch zůstává. |
| `regions.json` → `hero` = id stavby (§2.2) | `hero` = ISO země, bere se její hlavní stavba | region nezávisí na jménech v `landmarks.json` |
| ťuk na hero ikonu sloučeného regionu = přílet na ikonu | hero ikona sloučeného regionu ťuk nezachytává, rozhoduje země pod prstem | ikona Evropy je při zoomu 1 přes půl Evropy; ťuk na Německo končil ve Francii |
| ťuk na řeku/poušť ukáže název (§2.3) | název přírody se bere ze **středu pohledu**, stejně jako země | ťuk na Saharu je zároveň ťuk na Alžírsko; výběr země má přednost |
| animace „vyskočení“ ikon (§4) | není | až s artem, na placeholderech se nedá posoudit |
| jedno `drawAtlas` (§1.3, §4.1) | `drawImageRect` na ikonu | po kolizích je na plátně nejvýš ~80 ikon; `SpriteAtlas` je připravený, loader z balíčku je fáze F |
| test „každá země má ikonu“ až po druhé vlně (§6.3) | platí hned | data mají všech 175 zemí; po vlnách půjde jen art |
| větev + PR na fázi (§7) | jedna větev, jeden PR | fáze A–E na sebe navazují v týchž souborech |
| útes (Velký bariérový) | chybí | leží v moři, potřebuje vlastní typ kreslení |

Zoom regionů po odladění na snímcích: Evropa `minZoom` 2,6 / `zoomTo` 3,6
(v §1.2 odhad 4–4,5 počítal s menším plátnem).

Výběr staveb, který stojí za lidské oko (z reportu k datům): DK Malá mořská
víla je posunutá o 2° do Jutska (polygon nemá Sjælland); CL má věž Costanera
místo moai (Velikonoční ostrov není v polygonu); IL Bahá’í svatyně v Haifě a
PS chrám Narození Páně (vyhnutí se Jeruzalému); SA Kingdom Centre místo
Kaaby; KP Tedongská brána místo režimních monumentů. Na hraně pravidla
„jen stavby“: US Mount Rushmore, CA iglú, PA zdymadlo, US/KZ rakety na
rampě, CN terakotový válečník.

Ověření: `flutter test --exclude-tags screenshots` (87 testů),
`python3 app/tool/check_landmarks.py`, snímky `app/test/screenshots/01–03`
a `09–12` (`flutter test test/screenshots_test.dart --update-goldens`).
Na zařízení zatím nespuštěno — plynulost pinche a 60 fps při zoomu 6 jsou
neověřené.
