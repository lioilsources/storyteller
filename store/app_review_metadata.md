# App Store Connect — metadata aplikace

Všechno, co App Store Connect a App Review chtějí, s limitem každého pole.
Texty jsou k přímému zkopírování; čísla v hranatých závorkách jsou skutečná
délka textu (ověřuje `python3 store/check_lengths.py`).

Stav k 2026-10-13, binárka `rag-packs-cs-13`: 150 pohádek zdarma (10 z každého
z 15 regionů), 181 zvuků, bez nákupů v aplikaci, rozhraní i obsah jen česky.
Až se cokoli z toho změní, změň to i tady — texty v obchodě se kontrolují
proti skutečnému stavu aplikace.

## Před odesláním vyřešit

- [ ] **Název záznamu** v App Store Connect je dnes „BedTimeDaddy“, na ploše
      je `CFBundleDisplayName` „Storyteller“ a Android `label` „storyteller“.
      Pro obchod přejmenovat záznam na název níže a jméno na ploše na
      „Pohádkomat“.
- [ ] **Support a Privacy URL neexistují.** Návrhy stránek jsou ve
      `store/pages/` (česky, s anglickým shrnutím); adresy níže předpokládají,
      že se vystaví z `lioilsources/storyteller-content` (`docs/`, Pages už
      tam běží kvůli manifestu).
- [ ] Header a search grafiku zkontrolovat přes Preview v App Store Connect
      (Apple nezveřejňuje ořez).

## URL

| Pole | Hodnota |
|---|---|
| Marketing URL | `https://olin.now/storyteller.html` |
| Support URL | `https://lioilsources.github.io/storyteller-content/support.html` |
| Privacy Policy URL | `https://lioilsources.github.io/storyteller-content/privacy.html` |

Support URL je povinné pro každou lokalizaci zvlášť; stačí stejná adresa.

## Identita

| Pole | Limit | Hodnota |
|---|---|---|
| Bundle ID | — | `com.ol1n.storyteller` |
| Primární jazyk | — | Čeština |
| Primární kategorie | — | Knihy |
| Sekundární kategorie | — | Vzdělávání |
| Copyright | — | `2026 Oldřich Vorechovský` |
| Kategorie Děti | — | **ne** — aplikace je pro rodiče (PACKS_V2 D4) |

Věkové hodnocení: dotazník vyplnit podle obsahu — lidové pohádky s draky,
čerty, upírem a kletbami, bez krve a bez zobrazeného násilí. Poctivá odpověď
je „Kreslené nebo fantastické násilí: zřídka / mírné“, zbytek „žádné“; žádný
obsah od uživatelů, žádná reklama, žádný neomezený web.

## Čeština (cs) — primární lokalizace

### Název (30)

```
Pohádkomat: Tatínku, vyprávěj
```

### Podtitul (30)

```
Pohádku vyprávíš ty, ne mobil
```

### Promotional Text (170)

Dá se měnit bez nového buildu.

```
150 pohádek z celého světa zdarma. Roztoč glóbus, vyber postavy, úkol a konec — a vyprávěj svými slovy. Aplikace jen napovídá, pouští zvuky a ukazuje obrázky.
```

### Keywords (100, čárky bez mezer)

```
pohádky,vyprávění,děti,dobrou noc,uspávání,rodiče,příběhy,Erben,Němcová,glóbus,offline,táta,máma
```

Neopakovat slova z názvu ani kategorii — Apple je indexuje sám.

### Popis (4000)

```
Pohádkomat nevypráví za tebe. Pomůže ti vyprávět.

Večer u postele, dítě chce pohádku a tobě zrovna žádná nenaskakuje. Pohádkomat ti podá stavební kameny — postavy, úkol pro hrdinu, problém, který se postaví do cesty, a konec — a pak ti drží osnovu před očima. Vyprávíš ty, svému dítěti, svými slovy. Aplikace nemluví a nic nečte nahlas.

ZAČÍNÁ SE NA GLÓBU
Roztoč planetu a ťukni na zemi. Ta určí, z jaké tradice bude dnešní pohádka: z Česka, Japonska, Brazílie nebo třeba z Grónska. Každá země má na glóbu svou stavbu, podle které ji dítě pozná dřív, než umí číst — Pražský hrad, Eiffelovku, pyramidy, Tádž Mahal.

150 POHÁDEK ZDARMA
Deset pohádek z každého z patnácti regionů světa, rovnou v telefonu. Popelka, Chytrá horákyně, Pták Ohnivák a liška Ryška, Sněhová královna, Baba Jaga, Jack a fazole, Živá voda a desítky dalších, které jsi nejspíš nikdy neslyšel.

OD POSTAV K OSNOVĚ
Vyber jednu až šest postav; každou můžeš vyměnit za jinou. Přidej úkol, problém a konec. Z toho se složí „pohádka v kostce“ — jedna obrazovka, na kterou se při vyprávění díváš.

SUFLÉR
Při vyprávění tě Suflér vede krok za krokem: kdo v tom bude, co si hrdina předsevzal, co se pokazilo, jak to dopadlo. Když se zasekneš, řekni si o nápovědu. Nedostaneš větu k přečtení, dostaneš šťouchnutí, od kterého se odrazíš. Ke každému kroku je ilustrace, kterou můžeš dítěti ukázat.

ZVUKY, KTERÉ PUSTÍŠ TY
Tichá melodie podle prostředí — les, zahrada, palác, moře. K tomu zvuky postav a děje z tvé pohádky: liška, sova, drak, vítr, hrom, kouzlo. Nic nehraje samo; zvuk pustíš, až se do vyprávění hodí.

Z POHÁDEK, NE Z HLAVY STROJE
Motivy pocházejí ze skutečných pohádek ve veřejném vlastnictví: Erben, Němcová, bratři Grimmové, Andersen, Perrault a sbírky z Afriky, Asie, Kavkazu a obou Amerik. České pohádky vycházejí z českých originálů, ne ze zpětného překladu.

FUNGUJE BEZ PŘIPOJENÍ
Všech 150 pohádek, obrázky, nápovědy i zvuky jsou v telefonu. Hledání nápověd běží přímo v zařízení. Žádný účet, žádná registrace.

BEZ REKLAM A SLEDOVÁNÍ
Žádná reklama, žádná analytika, žádný sběr dat. Aplikace je pro rodiče — telefon držíš ty, dítě poslouchá tebe.

Aplikace je zatím celá v češtině.
```

### What's New (4000)

První verze v App Store toto pole nemá. Pro další verzi:

```
• 150 pohádek zdarma: deset z každého z patnácti regionů světa.
• Zvuky postav a děje přímo k pohádce, kterou vyprávíš.
• Ilustrace ke každému kroku vyprávění.
```

## Angličtina (en-US) — volitelná druhá lokalizace

Listing v jazyce, který aplikace neumí, je povolený; popis to proto říká
hned na začátku i na konci. Bez této lokalizace uvidí zahraniční obchody
český text.

### Name (30)

```
Pohádkomat: Daddy, Tell a Tale
```

### Subtitle (30)

```
You tell the bedtime story
```

### Promotional Text (170)

```
150 folk tales from around the world, free. Spin the globe, pick characters, a quest and an ending, then tell it in your own words. In Czech only for now.
```

### Keywords (100)

```
czech,fairy,folk,bedtime,stories,storytelling,kids,parents,prompter,globe,offline,grimm,andersen
```

### Description (4000)

```
Pohádkomat is in Czech only for now — the interface and all 150 tales.

It does not tell the story for you. It helps you tell it.

Bedtime, your child wants a story, and nothing comes to mind. Pohádkomat hands you the building blocks — characters, a quest for the hero, a problem that gets in the way, and an ending — and then keeps the outline in front of you. You tell the story, to your child, in your own words. The app does not speak and reads nothing aloud.

START ON THE GLOBE
Spin the planet and tap a country. It decides which tradition tonight's tale comes from. Every country has its own landmark on the globe, so a child can recognise it before they can read.

150 TALES, FREE
Ten tales from each of fifteen regions of the world, already on your phone: Cinderella, The Snow Queen, Baba Yaga, Jack and the Beanstalk, The Water of Life, and dozens you have probably never heard.

FROM CAST TO OUTLINE
Pick one to six characters and swap any of them. Add a quest, a problem and an ending. They fold into a one-screen outline you glance at while telling.

THE PROMPTER
The prompter walks you through the tale step by step. When you get stuck, ask for a hint: not a sentence to read out, but a nudge to push off from. Every step has an illustration you can show your child.

SOUNDS YOU PLAY
A quiet melody that fits the setting, plus sounds of the characters and events of your tale — a fox, an owl, a dragon, wind, thunder, a spell. Nothing plays by itself.

FROM REAL TALES
The motifs come from public-domain folk and fairy tales: Erben, Němcová, the Brothers Grimm, Andersen, Perrault, and collections from Africa, Asia, the Caucasus and the Americas.

WORKS OFFLINE
All 150 tales, pictures, hints and sounds are on the device. Hint search runs on the device. No account, no sign-up.

NO ADS, NO TRACKING
No ads, no analytics, no data collection. The app is for parents — you hold the phone, your child listens to you.

Language: Czech.
```

## Review Information

| Pole | Hodnota |
|---|---|
| Sign-in required | No |
| Demo account | Not applicable — no accounts exist |
| Contact | Oldřich Vorechovský · oldrich.vorechovsky.jr@gmail.com |

Poznámky pro recenzenta (anglicky):

```
Pohádkomat helps a parent tell a bedtime story in their own words. It is a
prompter, not an audiobook: the app never narrates.

The interface and all content are in Czech. To walk through it:
1. The home screen is a globe. Tap "Přiblížit Evropa →", then tap the Czech
   Republic and "Vyprávět z … →".
2. "Kdo bude v pohádce?" — the cast. Tap "Pokračovat →".
3. Pick one card on each of the next three screens (quest, problem, ending).
4. "Osnova" shows the outline. Tap "Vyprávím →".
5. The prompter: "Dál →" moves to the next step, the light-bulb button gives
   a hint, the buttons under "Zvuky" play sounds.

There are no accounts, no in-app purchases and no ads in this version. All
150 tales ship inside the app; nothing needs a network connection. The only
network request is an anonymous download of a static content manifest from
GitHub Pages (lioilsources.github.io/storyteller-content). Hint search uses a
small embedding model that runs on the device.

All tales are derived from public-domain sources (Project Gutenberg,
Wikisource). Illustrations and sounds were generated for the app.

The app is intended for parents and is not in the Kids category.
```

## App Privacy (dotazník)

Odpověď: **„No, we do not collect data from this app“**. V aplikaci není
analytika, hlášení pádů ani reklamní síť. Jediný síťový provoz je anonymní
stažení manifestu obsahu (a případně balíčků pohádek) z GitHub Pages /
GitHub Releases; nic se neodesílá. Text, který rodič napíše nebo nadiktuje do
pole „Co se zrovna děje?“, zařízení neopouští — diktování obstarává
klávesnice systému, aplikace sama o mikrofon nežádá.

## Screenshoty a grafika

Postup (z `app/`, balíčky a model v `assets/rag/` podle
`.github/workflows/release-ios.yml`):

```sh
tool/store_screenshots.sh        # simulátor → build/store_screenshots/ (1320×2868)
python3 tool/appstore_shots.py   # → store/appstore_screenshots/<cíl>/
python3 tool/store_header.py     # → store/appstore_creative/
```

| Složka | Rozměr | Slot v App Store Connect |
|---|---|---|
| `appstore_screenshots/iphone-6.9/` | 1290×2796 | iPhone 6,9" (povinný) |
| `appstore_screenshots/iphone-6.3/` | 1206×2622 | iPhone 6,1" / 6,3" |
| `appstore_screenshots/ipad-13/` | 2064×2752 | iPad 13" (povinný, target je `1,2`) |
| `appstore_creative/header-3840x1646.png` | 3840×1646 | Header |
| `appstore_creative/search-3840x2560.png` | 3840×2560 | Search Results |

Sedm scén, všechny z jedné pohádky (Erbenův „Pták Ohnivák a liška Ryška“):
`01_globe`, `02_globe_zeme`, `03_cast`, `04_task`, `05_osnova`, `06_sufler`,
`07_zvuky`. Česky, bez titulků a rámečků zařízení, RGB bez alfa kanálu.
Simulátor `Pohadkomat-iPhone` (iPhone 17 Pro Max); když chybí:
`xcrun simctl create Pohadkomat-iPhone "iPhone 17 Pro Max"`.

Google Play sady zatím nejsou — Android vydání je zablokované (RELEASING.md).
