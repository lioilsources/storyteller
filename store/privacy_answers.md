# Odpovědi do formulářů o soukromí

Připravené odpovědi pro **App Store Connect → App Privacy** a **Google Play
Console → Data safety** pro verzi s anonymními statistikami
(`app/docs/telemetry.md`). Vychází z plánu `Prompts/04-PLAN-analytika.md` §7
v DevConventions. Před vyplněním ověř aktuální znění formulářů; formuláře
vyplňuje Olin.

Pořadí: zveřejnit politiku (`store/pages/privacy.html` →
`lioilsources/storyteller-content`, `docs/privacy.html`) → vyplnit tyto
formuláře → nastavit `TELEMETRY_KEY` a `TELEMETRY_HOST` → vydat. Dokud
tajemství nejsou nastavená, build nic neposílá a platí dosavadní odpověď
„nic nesbíráme“.

## Co se sbírá (shrnutí pro oba formuláře)

- Události používání: obrazovky a čas na nich, kroky skládání pohádky, jestli
  se dovyprávěla, kolik nápověd a zvuků, použité funkce, výsledek a trvání
  stahování a nákupů, zobrazené chyby. Jen výčty, pásma a čísla.
- Žádný identifikátor (ani instalace, ani zařízení, ani reklamní). Náhodné ID
  relace jen v paměti.
- Nic o obsahu pohádky, nic z pole „Co se zrovna děje?“, nic o dítěti.
- Země: příjemce ji odvodí z připojení, IP se neukládá.
- Příjemce: vývojář, vlastní server v EU (Česko). Nikomu se nepředává.
- Uchování 12 měsíců. Vypínač v aplikaci (Nastavení na glóbu).

## App Store Connect — App Privacy

**Data Collection:** „Yes, we collect data from this app“.

| Data type | Collected | Purposes | Linked to user | Used for tracking |
|---|---|---|---|---|
| Usage Data → **Product Interaction** | ano | App Functionality ne, **Analytics** ano, nic jiného | **No** | **No** |
| Diagnostics → **Performance Data** | ano (trvání stahování balíčků) | **Analytics** | **No** | **No** |

Všechno ostatní (Contact Info, Health, Financial Info, Location, Sensitive
Info, Contacts, User Content, Browsing History, Search History, Identifiers,
Purchases, Crash Data, Other Diagnostic Data, Other Data): **nesbíráno**.

Poznámky k rozhodnutí:

- **Location → Coarse Location:** země se ukládá na serveru z hlavičky
  připojení, aplikace ji neposílá. Kirian ji v App Privacy i v
  `PrivacyInfo.xcprivacy` uvádí jako Coarse Location. Tady podle zadání
  uvedena není; **rozhodne Olin**, ať je to ve všech appkách stejně. Když
  ano, doplnit řádek sem i do `app/ios/Runner/PrivacyInfo.xcprivacy`.
- **Purchases:** nákupy dílů vyřizuje App Store; do statistik jde jen
  výsledek (`ok`, `cancel`, `pending`, `error`), ne produkt ani cena. Apple
  definuje Purchases jako historii nákupů účtu nebo osoby; anonymní výsledek
  bez identifikátoru za to nepovažujeme. Ověřit při vyplňování.
- `app/ios/Runner/PrivacyInfo.xcprivacy` obsahuje přesně tyto dva typy,
  nepropojené, bez sledování, účel Analytics.

## Google Play Console — Data safety

**Does your app collect or share any of the required user data types?** Ano.

**Is all of the user data collected by your app encrypted in transit?** Ano
(HTTPS).

**Do you provide a way for users to request that their data is deleted?**
Ne. Data nejsou vázaná na uživatele ani zařízení, jednotlivce v nich nejde
najít. Odesílání jde kdykoli vypnout a vypnutí smaže neodeslané záznamy.
Zmíněno v politice (§ GDPR).

| Kategorie → typ | Collected | Shared | Ephemeral | Required / optional | Purpose |
|---|---|---|---|---|---|
| App activity → **App interactions** | ano | ne | ne | **Optional** (vypínač v aplikaci) | **Analytics** |
| App info and performance → **Diagnostics** | ano (trvání stahování) | ne | ne | Optional | Analytics |

Ostatní typy: nesbíráno. Location → Approximate location: totéž rozhodnutí
jako u Coarse Location výše (Google definuje approximate location jako
oblast ≥ 3 km², země do ní spadá, pokud ji vývojář ukládá).

**Target audience and content:** beze změny, aplikace není v programu
Families a cílová skupina nezahrnuje děti (aplikace je pro rodiče). Kdyby
se to změnilo, měření se musí vypnout (plán §4.14).

## Mimo repo, co se musí změnit spolu se zapnutím

- App Store Connect → App Privacy (výše).
- Google Play Console → Data safety (výše).
- `lioilsources/storyteller-content` → `docs/privacy.html` a
  `docs/support.html` (zveřejněná politika, kopie `store/pages/`).
- Stránka appky na olin.now (`storyteller.html`), pokud tvrdí, že appka nic
  nesbírá.
- Popis v App Store (cs i en) podle `store/app_review_metadata.md`, sekce
  „BEZ REKLAM A BEZ ÚČTU“ / „NO ADS, NO ACCOUNT“, a poznámky pro recenzenta.
