# Nákupy v aplikaci (placené díly)

Placený díl `region.<KOD>.cs.p<N>` (50 pohádek, STORYTELLER_PACKS_V2_PLAN.md
§1) se prodává jako **non-consumable** produkt `pack_<kod>_<N>`
(`pack_czsk_1`, `pack_afri_2`, …). Jedna cena pro všechny díly. Obchod jen
odemyká; díl se po koupi stáhne z GitHub Releases (`storyteller-content`)
stejně jako free balíčky.

## V appce

- **Kde se kupuje:** karta země na glóbu. Má-li země pohádky v dílu, který
  uživatel nemá a obchod ho prodává, nabídne „Koupit Afrika 1: 50 pohádek
  za 29 Kč“ (místo „Vyprávět“, když ze země zatím nic není), jinak malé
  „+50 · 29 Kč“ vedle „Vyprávět“. Cena je z obchodu (`StoreProduct.price`),
  nikdy natvrdo.
- **Po koupi** se díl rovnou stáhne. Koupený a nestažený díl karta nabízí
  ke stažení (zdarma, bez obchodu).
- **Obnovit nákupy:** „Stažené pohádky“ (ikona na glóbu) → „Obnovit
  nákupy“. Vidět je jen tam, kde obchod něco prodává. Obnovené díly se
  nestahují samy (nový telefon může mít málo místa), nabídne je glóbus.
- **Nárok** je v `entitlements.json` v support dir: produkt, ID transakce,
  účtenka (`serverVerificationData`), datum. Offline start ho zná. Uloží se
  dřív, než se nákup v obchodě dokončí (`completePurchase`); Play vrací
  peníze za nákup nepotvrzený do 3 dnů.
- **Ask to Buy / čekající platba:** „Nákup čeká na schválení“; až projde,
  přijde při příštím spuštění (appka poslouchá obchod od startu, `main.dart`).
- **Bez obchodu nic:** desktop, testy a build bez dílů v manifestu
  nenabízí žádnou koupi. Free appka bez placených dílů v manifestu tedy
  nákupy neukazuje, i když kód obsahuje.
- Vývoj: `--dart-define=STORYTELLER_UNLOCK_ALL=true` = vše koupené.

Kód: `app/lib/packs/store_gateway.dart` (`InAppStoreGateway`),
`pack_providers.dart` (`storeProductsProvider`, `PackDownloads.buyPart`,
`restorePurchases`), glóbus `globe_screen.dart`, list `storage_sheet.dart`.

Zatím **ne**: ověření účtenky na serveru (plan §7 fáze 2, `store.ol1n.com`),
odebrání nároku po refundu, bundle „celý svět“ (rozhodnutí o ceně).

## Produkty — `rag.store_products`

Produkt se zakládá, až je díl **postavený a zmrazený** v
`rag/packs-state.v2.cs.json` (nepoužitý produkt mate review). ID je navždy.

```sh
cd rag
.venv/bin/python -m rag.store_products                     # → store/iap_products.csv
export ASC_KEY_ID=… ASC_ISSUER_ID=… ASC_KEY_PATH=/Volumes/YOTTA/Dev/Distribution/Apple/_Keys/AuthKey_….p8
.venv/bin/python -m rag.store_products --asc               # co v App Store Connect chybí (jen čte)
.venv/bin/python -m rag.store_products --asc --apply --price-usd 0.99
```

`--apply` založí každý chybějící produkt: typ Non-Consumable, Family
Sharing, review note, lokalizace cs + en-US (název ≤ 30, popis ≤ 45 znaků,
skript hlídá), cena podle bodu USA (ostatní země dopočítá Apple), dostupnost
ve všech zemích. Cenu schvaluje uživatel (návrh v plánu: 0,99 $ / 29 Kč).

## App Store Connect — ručně

Jednou:
1. **Agreements, Tax, and Banking:** aktivní Paid Apps agreement (i free
   appka s nákupy ho potřebuje).
2. **App Privacy:** beze změny — nákupy řeší Apple, nárok je jen v zařízení.
3. Sandbox tester: Users and Access → Sandbox → Testers; na iPhonu
   Nastavení → App Store → Sandbox Account.

Pro každý produkt po `--apply`:
1. **Review screenshot** (povinný): karta země s tlačítkem „Koupit …“;
   stejný obrázek poslouží všem dílům.
2. První nákupy se odesílají **spolu s verzí appky** (verze → In-App
   Purchases → vybrat). Další díly lze odeslat samostatně.

Review notes k verzi s nákupy:

> Paid parts are non-consumable unlocks (`pack_<region>_<n>`, 50 tales each).
> Buy: on the globe turn to a country with tales in a paid part (e.g. Czechia),
> tap "Koupit …". The part then downloads from GitHub (lioilsources/storyteller-content).
> Restore: globe → "Stažené pohádky" (storage icon, top right) → "Obnovit nákupy".
> Free content never needs a purchase.

## Google Play

Až bude appka v Play (dnes jen Firebase, plán §5 bod 6): Play Console →
Monetize → In-app products, stejná ID a ceny, license testers pro closed
test. Skript na Play API zatím není.
