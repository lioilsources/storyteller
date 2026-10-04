# CuteKidFonts v0.1.1 — battle test ve StoryTelleru

StoryTeller má ze všech appek nejvíc textu: dlouhé české věty, desítky nápověd, karty s cizími jmény. Proto na něm CuteKidFonts (`cute_kid_fonts`, tag `v0.1.1`) zkoušíme na plno. Cílem je vady najít a zapsat, ne je v appce obcházet. Vady, které patří balíčku, jsou zvlášť v sekci [Pro CuteKidFonts](#pro-cutekidfonts).

Integrace přišla v PR #22, mapování rolí je v `lib/theme/kid_text.dart`. Stav k 2026-10-04, Flutter 3.44.4.

Všechna čísla v dokumentu vyrábějí testy v `test/fonts/`. Kromě asertů zapisují tabulky do `build/cute_kid_fonts_battle/*.md`:

```bash
python3 tool/collect_font_charset.py --data ../rag/data   # znaky + nejdelší texty z dat → test/fixtures/
flutter test test/fonts/                                   # pokrytí, layout, výkon, čitelnost
flutter test test/fonts/layout_battle_test.dart --update-goldens
```

Goldeny fontů (`test/fonts/goldens/`) nesou tag `screenshots` jako `test/screenshots_test.dart`, takže je CI (`--exclude-tags screenshots`) vynechává. Jsou citlivé na rasterizaci (macOS × Linux).

## Mapování rolí

| co | role | velikost | poznámka |
|---|---|---|---|
| nadpis obrazovky (AppBar) | `title` bubble | 26 | paleta peach, 1 řádek |
| nadpis fáze vyprávění | `title` bubble | 26 | max. 2 řádky |
| jméno země na glóbu | `title` bubble | 24 | mint, když odsud máme pohádky |
| nadpisy sekcí osnovy | `upper` bubble | 17 | |
| názvy karet postav a motivů | `title` bubble | 16 / 13 | na tmavém přechodu přes obrázek, 3 / 2 / 1 řádky |
| název motivu v řádku osnovy | `dialog` | 18 | ploše |
| věty osnovy, nápovědy Suflérů | `body` | 18 | ploše přes `KidTheme.of(context).style` |
| návody, popisky, spojky | `body` | 13–16 | spojky a „Nápověda —“ kurzívou |
| obsazení `3/6`, skóre nápovědy | `number` | 20 / 13 | |
| tlačítka, čipy, pole, dialogy | Material téma v Baloo 2 | 16 / w600 | `fontFamily`, ne role (viz nález 6) |
| „Dobrou noc.“ | `titleItalic` bubble | 32 | lavender |

- Plochý text má dál hnědý inkoust appky `#3E2723`. Tmavé barvy palet (cihlová, lesní…) by změnily charakter appky (viz nález 8).
- Změnilo se 5 obrazovek a 7 rout: glóbus, obsazení, výběr úkolu/problému/konce, osnova, Suflér se závěrečným dialogem.

## 1. Pokrytí znaků

Test `test/fonts/glyph_coverage_test.dart`. Znaky sbírá `tool/collect_font_charset.py` ze všech českých dat:

- `cards`, `verbalizations`, `hints` a `transitions` `.cs.jsonl`;
- packy `rag/data/packs/*.db` (verbalizations, hint_bank, transitions, outline_templates, sounds);
- názvy zemí z `assets/geo/countries.json`;
- řetězcové literály v `lib/`.

Celkem 73 393 textů a 190 unikátních znaků: 86 ASCII, 24 českých písmen, 9 typografických znaků, 7 dalších latinek, 6 azbuky, 57 emoji a 1 symbol (`→`).

Každý znak se pro každou roli měří dvakrát, nezávisle:

1. **cmap** fontu: co font deklaruje.
2. **TextPainter**: šířka znaku v řezu *bez* fallbacku proti šířce `.notdef` téhož řezu (plán CuteKidFonts, „Ověření“). Takhle se pozná, co Flutter opravdu vykreslí.

Obě měření se u všech znaků z dat shodla. Známé díry jsou připnuté v `_knownDataGaps`: když se změní balíček nebo data, test spadne.

### Data: znaky mimo primární řez role

| znak | role | kdo ho vykreslí | kde |
|---|---|---|---|
| `б и м н о щ` (azbuka) | všechny | Nunito (fallback, jiný tvar i váha) | **chyba dat**, viz níže |
| `→` | `titleItalic` | Baloo 2 | UI „Pokračovat →“. Appka ho v `titleItalic` nesází, jinak by šipka spadla do jiného písma |
| 57 emoji (`🦊 👑 ⏰ …`) | všechny | nikdo z řetězce → systémový emoji font | očekávané. Emoji v appce stojí v `Text` bez role |

Ostatní znaky z dat mají všechny role v primárním řezu. Patří sem všech 24 použitých českých písmen, `„ “ ‚ ‘ ’ – — … ·` a cizí diakritika `ł ś ź ľ ğ ö ô`.

### Chyba dat: cyrilské homoglyfy v češtině

Fonty odhalily chybu generování (LLM pipeline `rag.verbalize` / hinty): do českých slov se dostala azbuka, která vypadá jako latinka („napodобиá“, „zvоном“, „plщщem“). Celkem 18 znaků v 6 řádcích:

| soubor | řádek / rowid | id | azbuka | kontext |
|---|---|---|---|---|
| `rag/data/verbalizations.cs.jsonl` | ř. 4629 | motif `cda3842b71b56b3e`, 6-10 / neutral / **title** | `м н о` | „…před svatebním zvоном“ |
| `rag/data/verbalizations.cs.jsonl` | ř. 6228 | motif `3d6c9fafa72a1f1a`, 6-10 / playful / sentence | `щ` | „…s roztrhaným plщщem a pachem polévky…“ |
| `rag/data/verbalizations.cs.jsonl` | ř. 7718 | motif `6172138028b6a0ac`, 6-10 / playful / sentence | `б и о` | „…nasadí šál a napodобиá hlas…“ |
| `rag/data/hints.cs.jsonl` | ř. 1533 | hint `889041b8723e51b4` | `щ` | „…pod jeho plщщщem skrývá poklad…“ |
| `rag/data/packs/country.CZ.cs.db` → `hint_bank` | rowid 1533 | hint `889041b8723e51b4` | `щ` | totéž, **v packu CZ** |
| `rag/data/packs/country.WORLD.cs.db` → `verbalizations` | rowid 4416 | motif `6172138028b6a0ac`, 6-10 / playful / sentence | `б и о` | totéž, **v packu WORLD** |

- Řádky v packech uvidí uživatel. V aplikaci se vykreslí Nunitem, tedy jiným písmem uprostřed slova.
- Oprava patří do pipeline: validace `[Ѐ-ӿ]` v českém výstupu verbalize/hints. Pak se mají přegenerovat dotčené řádky a packy.
- Tento PR data nemění.

### Sonda: znaky, které data zatím nemají

Tyhle znaky přijdou s dalšími zeměmi a cizími jmény (`_probe` v testu). V `title`, `upper`, `lower` a `key` (DynaPuff) dopadly takto:

| skupina | DynaPuff (title/upper/lower/key) | Baloo 2 (body/dialog/number) | Grandstander (titleItalic) |
|---|---|---|---|
| evropská diakritika `ł ő ű ş ţ ñ ä ö ü ß ø å æ œ ğ ı ç ą ę ż ć ń ľ ĺ ŕ` | vše | vše | vše |
| pálí / sanskrt IAST: `ā ī ū ṁ ṅ ñ ś` | ano | ano | ano |
| IAST s tečkou pod: `ṃ ṭ ḍ ṇ ḷ ṛ ṝ ṣ` | **fallback Baloo 2** | ano | ano |
| řečtina `α β γ … ά έ ή` | **nikdo** (jen `μ π Δ Σ Ω` z Baloo 2) | jen `π` vlastní, `μ Δ Σ Ω` z Nunita | **nikdo** |
| azbuka | fallback Nunito | fallback Nunito | fallback Nunito |
| typografie `„“‚‘’«»‹›–—…·•°№×÷€§` | ano | ano | ano |
| `′ ″ ʼ` | **fallback Baloo 2** | ano | `ʼ` ano, `′ ″` fallback |

Co z toho plyne:

- Řecká jména z GR packu, až přijdou v originále, se vykreslí systémovým fontem na zařízení. V testech se ukážou jako tofu.
- Pálijská jména v nadpisech budou mít písmena s tečkou pod v jiném písmu.

## 2. Layout

Test `test/fonts/layout_battle_test.dart`.

### Inkoust mimo layoutový box

Text `ŘŮŽ Ďábel gjy`, inkoust se měří z rasteru `KidBubblePainter` a porovnává s hlášenou `size`. Do 1 px je to antialiasing.

| role @ velikost | nad boxem | vpravo |
|---|---|---|
| title @ 16–26 | 1,0 | ≤ 0,6 |
| title @ 48 | 2,0 | — |
| **titleItalic @ 32** | **5,0** | **1,1** |
| **titleItalic @ 48** | **6,0** | **1,1** |
| **number @ 20** | **5,0** | 0,4 |
| body / dialog @ 18 | 0 | ≤ 0,2 |

- Kroužek a háček verzálek v `titleItalic` kreslí 5–6 px nad box. Grandstander má ascent 0,73 em, ale `Ů` sahá do 0,91 em a padding počítá jen s polovinou obrysu. V klipu, například v kartě s `Clip.antiAlias` nebo v AppBaru, se usekne.
- `number` má výšku řádku 1,0 v Baloo 2, takže diakritika verzálek přeteče. Na číslice to nevadí, `Ř` v roli `number` ano.

### Slévání řádků

Dolní inkoust řádku s `gjyp` (dotahy + obrys + extruze) a horní inkoust řádku s `ŘŮŽĎ` (háčky + obrys) jsme porovnali s výškou řádku role. Kladná hodnota znamená, že se dva řádky překrývají.

| role @ velikost | výška řádku | překryv |
|---|---|---|
| title @ 16 (karty) | 18,4 | **5,6 px** |
| title @ 26 (nadpis fáze) | 29,9 | **8,1 px** |
| titleItalic @ 32 | 36,8 | **12,2 px** |
| upper @ 17 | 19,5 | **2,5 px** |
| body @ 18 | 24,3 | −4,3 (OK) |
| dialog @ 18 | 23,4 | −3,4 (OK) |

Víceřádkové bubble názvy karet (máme 3 řádky) a nadpisy fází se slévají: extruze řádku N leží na háčcích řádku N+1. Je to vidět v `test/fonts/goldens/nadpisy-viceradkove.png`. Ploché role jsou v pořádku.

### Mezera mezi slovy

Obrys přidá půl své šířky na obě strany sousedních písmen, takže z mezery zbude:

| role | zbývá z mezery |
|---|---|
| title, key (obrys 0,14 em) | **33 %** |
| upper | 39 % |
| titleItalic | 56 % |

Při 16 px na kartě zbyde 1,1 px. „Princ hledá tu pravou“ se čte jako jedno slovo, viz screenshot 04 a goldeny.

### Nejhorší případy z dat (goldeny)

`test/fonts/goldens/`:

- **`karty-nejdelsi-nazvy.png`**: nejdelší názvy z dat (až 63 znaků, „Liška oklamala, manžel přišel a řekl: 'Hádej, kdo je tady pán!'“) v rozměrech karet appky.
  - Ořez `maxLines` + `…` funguje, nic nepřeteče a nevyhodí výjimku.
  - V dlaždici Suflérů (100 px) se slovo láme **uprostřed** („okl amala, …“), protože bubble písmo nemá zmenšení podle šířky.
  - V osnově (84 px, 13 pt) zbude „Liška ok…“.
  - Přechod plochy jde přes celý blok, takže druhý a třetí řádek mají tmavší plochu než první (nález 3).
- **`karty-text-scale-1_3.png`**: velké písmo systému. BubbleText respektuje `textScaler` a názvy dál ořezává `maxLines`, bez přetečení.
- **`nadpisy-viceradkove.png`**: slévání řádků a kurzíva přes okraj.
- **`napoveda-nejdelsi.png`**: nejdelší nápověda a nejdelší věta (264 znaků) v `body` 18 na kartě nápovědy. Bez problému.

Screenshoty celé appky jsou v `test/screenshots/01–08`. 04–08 se míchají nesemínkovaným `Random()`, takže padají i na master, viz PR #21.

## 3. Výkon

Test `test/fonts/performance_battle_test.dart`. Měří 120 položek s `StoryCardLabel` (bubble `title` 16, 2 řádky) proti `Text` se stejným stylem.

`flutter test` běží v JIT/debug bez GPU, takže absolutní milisekundy neodpovídají telefonu a smysl má jen poměr.

| scénář | BubbleText | Text | poměr |
|---|---|---|---|
| 120 najednou (Column / Wrap): první snímek | 42 ms | 14 ms | 3,1× |
| 120 najednou: vrstev ve stromu | 247 | 8 | 31× |
| `ListView.builder`: první snímek | 16,5 ms | 8,1 ms | 2,0× |
| `ListView.builder`: snímek při scrollu | 4,0 ms | 2,0 ms | 2,0× |

- Jeden bubble BubbleText vysází **4 odstavce** (base, obrys, plocha, lesk) a za snímek je **9× vykreslí**: extruze 3× (obrys + base), obrys, plocha a lesk. Navíc nese vlastní `RepaintBoundary`, tedy jednu vrstvu na položku.
- V dnešní appce je na obrazovce nanejvýš ~12 bubble textů: 3–6 karet a nadpisy. Nápovědy jsou záměrně ploché. Problém by nastal až u výběru z celého packu ve Wrapu.
- Pod `IntrinsicWidth` (AlertDialog) se teoreticky zahazují vysázené paintery. Měření ale rozdíl neukázalo (1,0×), protože RenderBox intrinsic rozměry kešuje.

**Na zařízení změřit** (střední Android, `flutter run --profile`, DevTools → Performance):

1. Výběr postav: 6 karet, opakované „Zamíchat vše“ (AnimatedSwitcher + scale na každé kartě).
2. Suflér: 8× „Ještě jednu“ a scroll.
3. Glóbus při točení. Jméno země se mění každý snímek, což znamená nový layout 4 painterů na každý frame.

Sledovat raster thread (cíl < 8 ms při 120 Hz, resp. < 16 ms při 60 Hz) a počet vrstev v „Performance overlay“.

## 4. Čitelnost

Test `test/fonts/readability_battle_test.dart`. Kontrast WCAG 2 počítá `kidContrastRatio`, poloprůhledné barvy se předem smíchají s pozadím.

| co | kontrast | ≥ 4,5 |
|---|---|---|
| body/dialog inkoust na pozadí / kartě nápovědy | 13,4 / 12,6 | ano |
| návody, „Nápověda —“, skóre (inkoust 60 %) | 3,8–3,9 | **ne** (vada appky, už před fonty) |
| obrys peach / mint / lavender na pozadí i bílé | 6,3–10,1 | ano |
| plocha `mid` proti obrysu: peach / mint / lavender | 3,58 / 4,20 / 4,69 | **peach a mint ne** |
| plocha `light` na krémovém pozadí (bez obrysu) | 1,1–1,2 | ne. Bubble čte jen díky obrysu |
| karta přes světlý obrázek: plocha / obrys proti `black54` | 2,56 / **1,40** | ne |

- Velikosti: hlavní čtený text (osnova, nápovědy, dialogy, názvy motivů v osnově) má **18 pt**. Pod 18 jsou jen sekundární popisky (13–16) a meta údaje (13). To je vědomé rozhodnutí, rodič je čte jednou.
- Na kartách přes světlý obrázek splývá obrys s tmavým přechodem (1,40:1) a písmo drží jen plocha. Na tmavých kresbách je to naopak.
  - Appka může přechod ztmavit.
  - Lepší je řešení v balíčku: volitelný světlý „halo“ obrys pro text na fotkách (nález 9).

## Pro CuteKidFonts

Vady balíčku `cute_kid_fonts` v0.1.1 s návrhem opravy. Do repa CuteKidFonts jsme necommitovali, opravu udělá vlastník. Číslo v závorce odkazuje na sekci výše.

1. **Obrys sní mezery mezi slovy (§2).** V `title`/`key` zbude 33 % mezery, při 16 px 1,1 px.
   - *Oprava:* v `KidRoleSpec.textStyle` pro ne-ploché role přidat `wordSpacing: strokeFactor * size`. Případně o šířku obrysu zvětšit i `letterSpacing`, aby se písmena nedotýkala obrysy.
2. **Víceřádkový bubble se slévá (§2).** Při výšce řádku 1,15 leží extruze a dotahy řádku N na háčcích řádku N+1: 5,6 px při 16 pt, 12 px u `titleItalic` 32.
   - *Oprava:* `height` bubble rolí počítat včetně obrysu a extruze, tedy zhruba `1.15 + strokeFactor + extrusionLayers * extrusionFactor` ≈ 1,40.
   - Nebo v `KidBubblePainter` sázet řádky s `StrutStyle(height: …, forceStrutHeight: true)`.
3. **Přechod plochy jde přes celý blok, ne po řádcích (§2).** Shader se tvoří z `Offset.zero & Size(base.width, base.height)`, takže druhý a další řádek jsou tmavší.
   - *Oprava:* shader z `computeLineMetrics()`. Buď kreslit plochu po řádcích s clipem na řádek, nebo `LinearGradient(tileMode: TileMode.repeated)` s výškou jednoho řádku.
4. **`titleItalic` kreslí 5–6 px nad svůj box a ~1 px vpravo (§2).** Grandstander: `Ů` yMax 0,91 em proti ascentu 0,73 em při výšce 1,15. Padding počítá jen `strokeWidth / 2`.
   - *Oprava:* horní padding odvodit z reálného yMax diakritiky verzálek daného řezu, ne z obrysu. Pro kurzívu přidat pravý padding o sklon (~0,04 em).
   - Do goldenu balíčku přidat `Ů Ř` v `titleItalic`.
5. **`number` má výšku řádku 1,0 v Baloo 2, takže diakritika verzálek přetéká o 5 px (§2).**
   - *Oprava:* `height: 1.2`, nebo v dokumentaci výslovně omezit roli na číslice.
6. **`FontVariation('wght')` v každé roli přebíjí `fontWeight`.** `KidTheme.of(context).style(KidRole.body).copyWith(fontWeight: FontWeight.w800)` zůstane na 400: šířka je stejná, ověřeno sondou. Material, který tučnost řídí `fontWeight`, proto roli neumí ztučnit.
   - Flutter 3.44 osu `wght` u proměnných fontů z `fontWeight` nastavuje sám. Sonda na Baloo 2 bez variací: w400 → 185 px, w800 → 199 px.
   - *Oprava:* vypustit `fontVariations` u vah, které jsou násobkem 100, a nechat jen `fontWeight`. Nebo přidat `style(weight:)`.
   - StoryTeller proto dává Materialu `fontFamily: KidFonts.baloo2`, ne styl role.
7. **Chybí kurzíva pro text.** Baloo 2 nemá italic, takže `body` + `FontStyle.italic` je syntetický sklon. Plán balíčku přitom syntetický skew zakazuje. StoryTeller kurzívu používá na spojky a „Nápověda —“.
   - *Oprava:* role `bodyItalic` s Nunito Italic, které už je v balíčku jako fallback.
8. **Palety jsou uzavřený enum a plochý text nejde přebarvit globálně.** Appka s vlastní barvou textu (StoryTeller: hnědá `#3E2723`) musí `color:` předávat při každém volání, viz `StoryKidStyle.kid`. Žádná paleta navíc není neutrální nebo hnědá.
   - *Oprava:* `KidThemeData.ink` (barva plochého textu) a `KidPalette` jako třída s `const` instancemi, aby šla doplnit vlastní.
9. **README tvrdí, že obrys má ≥ 4,5:1 proti vlastní ploše. Proti spodku přechodu (`mid`) to neplatí** (§4): peach 3,58, mint 4,20.
   - *Oprava:* v `palette_test` měřit i `mid`. Pak buď ztmavit `dark` nebo zesvětlit `mid`, nebo upravit tvrzení v README.
   - Pro text přes fotky přidat volitelný světlý vnější obrys (halo). Tmavý obrys na tmavém přechodu karty má 1,40:1.
10. **Pokrytí znaků mimo češtinu (§1).**
    - DynaPuff nemá IAST s tečkou pod (`ṃ ṭ ḍ ṇ ḷ ṛ ṣ`) ani `′ ″ ʼ`.
    - Řečtinu nemá žádný řez z řetězce, kromě `μ π Δ Σ Ω`.
    - Azbuku má jen Nunito.
    - Grandstander nemá `→`.
    - Akceptační test balíčku (`diacritics_test.dart`) hlídá jen češtinu a pinyin.
    - *Oprava:* rozšířit akceptační sadu o Latin Extended-A, IAST, `„“‚‘–—…→′″` a výslovně rozhodnout, co s řečtinou: přidat řez, nebo zdokumentovat jako systémový fallback.
11. **Úzká šířka láme slovo uprostřed.** Nejdelší slovo z dat „pronásledovatelem“, ale i „oklamala“ v 84 px při 16 pt.
    - *Oprava:* `BubbleText.fit` / `minSize`, tedy zmenšení písma, dokud se nejdelší slovo nevejde. `KidKeyLabel.fit` to už dělá pro klávesy.
12. **Testovací API.**
    - `BubbleText` je vlastní render object, takže ho `find.text` nenajde. StoryTeller si napsal `findKidText` v `test/kid_finders.dart`.
    - Čtečka `cmap` a mapování rodina → soubor fontu jsou jen v testech balíčku, resp. privátní, takže je appka musí kopírovat.
    - *Oprava:* exportovat z `cute_kid_fonts_testing.dart` `findBubbleText`, `kidFontFiles` a `readCmap` / `kidGlyphCoverage(String text, KidRole role)`.
13. **Výkon (§3).** 4 odstavce a 9 vykreslení na snímek, plus vrstva na každý BubbleText. Při 120 položkách najednou to dělá 3,1× čas prvního snímku a 31× vrstev.
    - *Oprava:* `KidBubblePainter` může vrstvy po layoutu jednou nahrát do `ui.Picture` a pak jen `drawPicture`. Podobně to dělá Flame cache.
    - `RepaintBoundary` udělat volitelný (`repaintBoundary: false` pro položky seznamů, které mají vlastní).
14. **Závislost na `flame`.** Ne-Flame appka (StoryTeller) kvůli `cute_kid_fonts_flame.dart` stahuje `flame` a `ordered_set`.
    - *Oprava:* rozdělit na `cute_kid_fonts` a `cute_kid_fonts_flame`, nebo Flame část do samostatného balíčku v monorepu.
15. **Drobnosti.**
    - `RenderBubbleText.describeSemanticsConfiguration` má `textDirection = TextDirection.ltr` natvrdo, správně je směr z widgetu.
    - Baloo 2 má výšku řádku 1,6 em (ascent 1,078, descent 0,524, kvůli dévanágarí). Kdo použije `KidFonts.baloo2` přímo bez `height` role, dostane volné řádkování.

## Pro StoryTeller (ne balíček)

- **Cyrilské homoglyfy v datech** (§1): 6 řádků, z toho 2 v packech CZ a WORLD. Oprava patří do pipeline.
- **Šedý text (inkoust 60 %)** má kontrast 3,8–3,9:1 (§4). Vada byla už před fonty. Návrh: 70–75 % alfa.
- **Dlaždice Suflérů 100 px** láme slovo uprostřed (§2). Až balíček umí `fit`, přepnout. Do té doby je to vědomě ponechané.
- **Spodní lišta obsazení** se s novým písmem smrskla na střed. V PR #22 jsme ji opravili (`width: double.infinity`).
- **Screenshoty 04–08** jsou nedeterministické (nesemínkovaný `Random()` v `cast_controller` a `motif_picker_screen`). Kvůli nim jsou deterministické goldeny fontů zvlášť v `test/fonts/goldens/`.
- Počty na glóbu („785 motivů z 65 pohádek“) zatím nejsou v roli `number`. Text mění PR #21, roli doplníme po jeho merge.
