# StoryTeller — balíčky v2: regiony, díly po 50, free napřed (plán)

Stav: návrh 2026-10-07 podle rozhodnutí uživatele z téhož dne. Nahrazuje
R1/R2 a §6–§7 ve STORYTELLER_MONETIZATION_PLAN.md (tam zůstává historie a
§11 stav implementace). Odhady kapacity pipeline jsou od Directora
(7. 10. ráno), odhady kódu moje; obojí je odhad, ne termín.

## 0. Rozhodnutí (2026-10-07)

| # | Rozhodnutí | Důsledek |
|---|---|---|
| D1 | **Free = 10 pohádek z každého regionu.** | ~15 regionů → ~150 pohádek zdarma, rozprostřených po celém glóbu. Česko přestává být celé zdarma (dnes 127). |
| D2 | **Placené díly po 50 pohádkách, po regionech** („10 je málo za $1“). | Země nemá vlastní balíček; její pohádky jsou v dílech jejího regionu. Glóbus u země ukazuje **celkový počet pohádek napříč všemi balíčky** (free i placenými, staženými i ne). |
| D3 | **Nápovědy (hints) na qwen36** v okně llm. | Director ověří na vzorku, že qwen36 stačí (čeština hints, později překlady). |
| D4 | **Appka je pro rodiče**, ne dětská kategorie. | Bez rodičovské brány a omezení Kids Category; zůstává: žádná reklama, žádná analytika třetích stran, nákupy jen přes store. |
| D5 | **Validátor konzistence** běží před stavbou každého balíčku, free i placeného. | Neúplná pohádka do dílu nejde; díl se vydá, až má 50 (free 10) pohádek, které projdou. |
| D6 | **Fáze 1 česky, Fáze 2 další světový jazyk.** Nejdřív free varianta, placené díly přibývají postupně. | Vstup do App Store s free appkou **bez IAP**; nákupy přijdou aktualizací. |

## 1. Model balíčků

### 1.1 Regiony

Region = skupina zemí, které k sobě jazykově/kulturně patří a dohromady
dají aspoň jeden díl. Návrh (zobrazitelných pohádek dnes, bez stropu 55 na
zemi je víc — viz 1.4):

| Kód | Region | Země | Pohádek (dnes v balíčcích) |
|---|---|---|---|
| CZSK | Česko a Slovensko | CZ SK | 128 |
| DACH | Německy mluvící země | DE AT CH | 90 |
| BRIT | Britské ostrovy | GB IE IM | 105 |
| FRBX | Francie a Benelux | FR BE NL LU | 132 |
| IBER | Iberie | ES PT | 100 |
| MEDI | Itálie, Řecko a Balkán | IT GR RO RS BG HR SI AL MK BA ME XK | 164 |
| NORD | Sever | DK NO SE FI IS EE LV LT | 82 |
| EAST | Východní Evropa a Kavkaz | RU UA BY PL HU MD GE AM AZ | 145 |
| INDI | Indie a jižní Asie | IN LK PK BD NP BT AF | 132 |
| EASI | Východní Asie | CN JP KR KP MN TW | 101 |
| SEAO | Jihovýchodní Asie a Oceánie | PH MY LA MM TH VN KH ID BN TL AU NZ FJ PG VU SB NC | 170 |
| MEAS | Blízký východ a Střední Asie | TR IR IQ SY JO IL LB SA YE AE OM KW QA CY KZ KG TJ TM UZ | 100 |
| AFRI | Afrika | všechny africké | 202 |
| NAMC | Severní Amerika a Karibik | US CA GL MX + Karibik + Střední Amerika | 203 |
| SAME | Jižní Amerika | BR AR CL PE CO VE BO EC PY UY GY SR | 52 |

Tabulka patří do `rag/rag/regions.py` (vedle `continents.py`, které
zůstává pro glóbus a staré balíčky). Každá země právě v jednom regionu;
neznámá země shodí build. Regiony glóbu z `app/assets/geo/regions.json`
(vizuální slučování při zoomu 1) jsou jiná věc a nemusí se shodovat.

**Ke schválení:** složení regionů, zvlášť Afrika jako jeden region (18
zemí, 4 díly) a Rusko ve „Východní Evropě“.

### 1.2 Díly

- `region.<KOD>.<lang>.free` — **přesně 10** pohádek regionu, zdarma, bez IAP.
- `region.<KOD>.<lang>.p<N>` — díl N, **přesně 50** pohádek, produkt
  `pack_<kod>_<N>` (non-consumable), jedna cena pro všechny díly.
- Díl je po vydání **zmrazený**: seznam pohádek se nemění (koupené
  nesmí zmizet). Nová verze dílu jen opravuje obsah (lepší nápovědy,
  dorenderované scény) a klient ji stáhne jako aktualizaci.
- Nové pohádky plní **další díl**. Díl se vydá, až má 50 pohádek, které
  projdou validátorem (§3); do té doby čeká. Nikdy nevzniká díl „na 32“.
- Výběr do dílu: skóre připravenosti z `score_tales` + rozprostření po
  zemích regionu (round-robin po zemích, ne 50 řeckých za sebou) + free
  desítka totéž (max 1–2 pohádky na zemi, aby bylo na glóbu vidět co
  nejvíc zemí).
- Trvalé přiřazení v `rag/packs-state.<lang>.json` jako dnes: pohádka,
  která jednou je v dílu, v něm zůstává.

Dnešní stav 1 906 pohádek → ~33 dílů; po zrušení stropu 55 na zemi
(2 770 zobrazitelných) → ~52 dílů. Nezaplní se poslední díl regionu, dokud
nepřibude obsah.

### 1.3 Manifest schema 4

```json
{
  "schema": 4, "lang": "cs", "min_app_version": "1.7.0",
  "regions": {
    "afri": {"name": {"cs": "Afrika"}, "countries": ["DZ", "..."],
             "free": {"version": 1, "size": 0, "sha256": "", "tales": 10, "file": "free-v2/region-afri-free-v1.zip"},
             "parts": [{"n": 1, "product_id": "pack_afri_1", "version": 1, "size": 0, "sha256": "", "tales": 50, "file": "region-afri-p1-v1/afri-p1.zip"}]}
  },
  "countries": {"EG": {"name": {"en": "Egypt"}, "region": "AFRI", "tales": 48,
                        "in": {"free": 1, "parts": {"1": 12, "2": 20, "3": 15}}}},
  "scenes": {"...": "jako dnes"}
}
```

`countries[cc].tales` a `in` jsou to, co glóbus ukazuje (D2) **bez stažení
čehokoli**: „Egypt: 48 pohádek · 1 zdarma, 47 v dílech Afrika 1–3“.
Klient umí schema 3 i 4 po dobu přechodu (starý klient nové ignoruje).

### 1.4 Migrace z dnešních balíčků

- Kontinentální free balíčky a placené balíčky zemí **končí**. Platící
  uživatelé zatím nejsou, takže nikomu nic nemizí.
- Strop `PAID_TALES = 50` na zemi padá; stropem je kapacita dílů.
- `FREE_ALL_COUNTRIES = {CZ}` padá (D1). Česko má free 10 (v dílu CZSK
  free, SK přidá 1–2) a díly CZSK 1, 2, (3).
- Binárka: core + **všechny free díly** (~150 pohádek ≈ 15 × ~5 MB ≈
  75 MB, méně než dnešní Evropa 104 MB), aby glóbus hned po instalaci
  svítil všude. Pokud by to bylo moc, v binárce jen CZSK free a ostatní
  free díly se stáhnou jedním klepnutím (dnešní mechanika kontinentů).
- „Česko – všechny scény“ (269 MB) zůstává jako samostatný free doplněk
  ke dvěma českým dílům, nebo se scény rozdělí do dílů. Rozhodnout
  podle velikosti dílu (§3 rozpočet 1,2 MB/pohádka → díl ≤ 60 MB).

## 2. Appka

### 2.1 Glóbus a karta země (D2)

Tři stavy země místo dnešních dvou:

| Stav | Barva | Karta |
|---|---|---|
| nic v korpusu | šedá | „Odsud zatím žádné pohádky nemáme.“ |
| **v balíčku, nestaženo/nekoupeno** | světle zelená (nebo zelená s tečkovaným okrajem) | „48 pohádek · 1 zdarma, 47 v dílech Afrika 1–3“ + tlačítko „Stáhnout Afrika zdarma (10 pohádek, 5 MB)“ / později „Koupit Afrika 1 (50 pohádek)“ |
| staženo | zelená | „Vyprávět z Egypt →“ + „48 pohádek, máš 13“ |

Počty jdou z manifestu (1.3), ne z nainstalovaných packů. `taleCounts()`
z packů dál říká, kolik je **k dispozici teď**.

### 2.2 Nákupy (až po free variantě)

- `StoreGateway` nad `in_app_purchase`: produkty `pack_<kod>_<N>`, nárok
  uložen lokálně, **Obnovit nákupy** v nastavení (App Review to chce i
  mimo dětskou kategorii).
- Produkty se zakládají skriptem přes App Store Connect API, ~52 ks na
  start a další s každým dílem — ruční zakládání neškáluje.
- D4: žádná rodičovská brána; stačí standardní StoreKit dialog.

### 2.3 Zvuky a hudba podle postav a děje

Dnes: 88 globálních zvuků v core, hudba podle prostředí × nálady, SFX
přes `match` klíčová slova. Návrh:

1. **Zvuk na postavu** (3 064 postav s kartou): pipeline přiřadí každé
   postavě 1 zvuk z katalogu (pole `sound` v postavě), kde v katalogu
   není (např. „vodník“), vygeneruje MOSS SFX. Director: 1–2 dopoledne.
2. **Discovery děje**: z `motifs[].tags` a fází už dnes plyne nálada;
   doplnit per motiv 1–3 „zvukové podněty“ (bouře, les v noci, trh) jako
   součást hints generace na qwen36 (jedno pole navíc, žádný další průchod).
3. **Hudba na pohádku** odkládám: 2 770 smyček = dny renderu a ~1 GB.
   Zůstává hudba podle prostředí; případně 1 smyčka na region (15 ks).

## 3. Validátor konzistence (D5)

`rag/rag/pack_check.py`, volá ho `pack_builder` před každým `build_one`;
samostatně `python -m rag.pack_check --lang cs --region AFRI --report`.
Dvě úrovně, aby se free varianta nedržela na úrovni, kterou svět ještě
nemá:

| Kontrola | Úroveň A (free varianta, Fáze 1a) | Úroveň B (placené díly) |
|---|---|---|
| motivy s titulkem | ≥ 1 úkol, ≥ 1 problém, ≥ 1 konec | totéž |
| karty motivů | každý zobrazený motiv má obrázek, žádný s nápisem (OCR) | totéž |
| postavy | ≥ 1 postava s titulkem a kartou, pokud pohádka postavy má | ≥ 2 |
| nápovědy | ≥ 3 na motiv a fázi pro úkol/problém/konec | ≥ 5, všechny fáze |
| verbalizace | titulek + 1 věta | 12 variant (3 věky × tóny) |
| scény | ≥ 1 scéna na fázi pro úkol/problém/konec (svět), CZ plné | totéž |
| zvuky | každá postava má `sound`, který v katalogu existuje | totéž |
| texty | bez cyrilských homoglyfů, bez prázdných řetězců, čeština (heuristika `sources.lang_check`) | totéž |
| rozpočet | ≤ 1,2 MB na pohádku, ≤ 48 obrázků | totéž |
| embed | vektory hints v modelu/dim z `rag_store.dart` | totéž |
| díl | přesně 10 / 50 pohádek, všechny z regionu, žádná ve dvou dílech, `pack_tales` sedí na obsah, sha256 v manifestu sedí na soubor | totéž |

Výstup: report per pohádka (co chybí) → pohádka, která neprojde,
**vypadne z dílu a čeká**; díl bez 50 prošlých se nestaví. Report je
zároveň seznam práce pro Directora („AFRI: 37 pohádek bez hints“).

## 4. Fáze a odhad

Kapacita (Director): flux-schnell 10–14 tis. obrázků/den; qwen36 ~8 tis.
jednotek/h v okně llm (19:15–00:50), na directoru jen ~1 900/den.
Předpoklad: D3 projde (vzorek hints z qwen36 je dobrý). Okno llm se
dělí — angličtina, české hints a prompty scén jdou **po sobě**; pořadí
podle D6: **české hints napřed**, angličtina až ve Fázi 2.

### Fáze 1a — free varianta (cíl: App Store, free appka bez IAP)

| Práce | Kdo | Odhad |
|---|---|---|
| `regions.py`, `pack_builder` v2 (díly, free 10/region, schema 4, trvalý stav), `pack_check.py` úroveň A | kód | 3 dny |
| hints pro **150 free pohádek** napřed (≈ 6–7 tis. jednotek) | qwen36 | 1 večer |
| scény pro free pohádky světa, ~15 na pohádku ≈ 2 000 obrázků + prompty | qwen36 + flux | 1 večer + ½ dne |
| zvuk na postavu pro free pohádky | okno comfy | 1 dopoledne |
| klient: manifest 4, tři stavy na glóbu, stažení free dílu regionu, počty z manifestu, odstranění kontinentů | kód | 3 dny |
| build + publikace free dílů, binárka, release | | ½ dne |
| App Store: listing (text z olin.now je), screenshoty (máme), privacy, review notes | | 1 den + review Applu 1–3 dny |

**Odhad: ~2 týdny do podání, 2,5 týdne v App Store.** Kritická cesta je
kód (6 dní) + review; pipeline se vejde vedle.

### Fáze 1b — placené díly (přibývají postupně)

| Práce | Kdo | Odhad |
|---|---|---|
| hints pro zbylých ~2 600 pohádek (~110 tis. jednotek) | qwen36 | 2–4 večery |
| plné verbalizace | qwen36 | 1–2 večery |
| scény světa ~15/pohádka ≈ 40 tis. obrázků | flux | 3–4 dny oken |
| zvuk na postavu, všech 3 064 | comfy | 1–2 dopoledne |
| `StoreGateway` (in_app_purchase), restore, produkty přes ASC API, UI koupě na kartě země | kód | 4 dny |
| validátor úroveň B, první díly: CZSK 1–2, pak regiony podle připravenosti | | průběžně, 1 h na díl |

**Odhad: první placené díly ~2 týdny po free variantě;** zbytek světa
přibývá tempem pipeline, celý korpus (~52 dílů) do ~4 týdnů od startu.

### Fáze 1c — zvuky a hudba podle děje (§2.3 bod 2–3)

1–3 dopoledne pipeline + 1–2 dny kódu; nezávislé na dílech, může jít
kdykoli po 1a.

### Fáze 2 — další světový jazyk (angličtina napřed)

Co jazyk stojí (odhad; přesná čísla doplní Director):

| Složka | Rozsah | Odhad |
|---|---|---|
| karty (titulek + věta) pro 25 585 motivů | qwen36; `cards.en.jsonl` už 8 780 řádků | zbytek 1 večer |
| verbalizace + hints celého korpusu | qwen36 | 3–5 večerů; **po dílech** jen zlomek (free + 4 díly ≈ 350 pohádek ≈ ½ večera) |
| transitions, outline templates, popisky zvuků, názvy regionů | malé | hodiny |
| balíčky `*.en.*` (stejný builder, `--lang en`) | kód hotový | 0 |
| **UI appky**: 169 českých řetězců natvrdo v kódu → Flutter l10n (ARB), výběr jazyka | kód | 3 dny |
| písmo: CuteKidFonts pokrývá latinku; CJK/cyrilice by chtěly jiný font | kód | 0 pro en/de/fr/es, 2 dny pro ja/ko/ru |
| vyhledávání hints: e5-small je vícejazyčný, vektory se přepočítají při buildu | 0 | 0 |
| store listing a olin.now | text máme (11 jazyků) | ½ dne |
| ověření kvality angličtiny vzorkem (Director, D3) | | 1 večer |

**Angličtina: ~1,5 týdne** (3 dny UI + pipeline po dílech + ověření),
každý další latinkový jazyk ~1 týden, CJK +2 dny. Obrázky jsou jazykově
neutrální (nápisy filtruje OCR), takže art se neopakuje.

## 5. Co se musí rozhodnout před kódem

1. Složení regionů (1.1) — hlavně Afrika jako celek a Rusko.
2. Cena dílu (návrh 0,99 $ / 29 Kč za 50 pohádek) a bundle „celý svět“.
3. Binárka: všechny free díly (~75 MB), nebo jen CZSK a zbytek ke stažení.
4. Free desítka: čistě podle připravenosti, nebo ručně vybrané „výkladní“
   pohádky na region (doporučuju ruční výběr pro CZSK, zbytek automaticky).
5. Osud balíčku „Česko – všechny scény“ (1.4).
6. Android: Firebase pro release pořád chybí; pro App Store nevadí, pro
   Play ano.

## 6. Mimo rozsah

Hudba na pohádku (2.3/3), server pro ověření účtenek (MONETIZATION §R5
fáze 2), šifrování balíčků, předplatné.
