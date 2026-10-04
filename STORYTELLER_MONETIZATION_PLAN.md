# STORYTELLER_MONETIZATION_PLAN.md

Handoff pro Opus / Claude Code. Navazuje na `STORYTELLER_PLAN.md`, `STORYTELLER_OFFLINE_PLAN.md`, `STORYTELLER_MODELS_PLAN.md`, `STORYTELLER_RAG_PLAN.md`. Vztahuje se výhradně k monetizaci, balíčkování obsahu a distribuci balíčků.

> **Stav implementace (2026-10-04) a odchylky od plánu jsou v §11 na konci.** Rozhodnutí z 3.–4. 10. 2026: R1 potvrzené, free obsah po kontinentech (Evropa v binárce), D-U-N-S je, repo `storyteller-content` založené.

---

## 1. Cíl

Free app pokrývá **všechny země** na glóbu. V každé zemi je zdarma **5 pohádek** — jejich postavy, motivy, nápovědy, grafika, hudba, zvuky, hlasy. Za každou zemi lze dokoupit **balíček 50 dalších pohádek** (non-consumable IAP). Balíčky se **nestahují ze storu, ale z GitHub Pages** (stejný pattern jako Lexify), IAP slouží jen jako odemknutí.

Opus: před implementací si otevři repo Lexify a zkopíruj přesně jeho loader (manifest → download → verify → unzip → registrace v lokální DB). StoryTeller má navíc: hudbu, zvuky a animace, takže pattern rozšiř, nepřepisuj.

---

## 2. Rozhodnutí, která plán předpokládá (potvrdit s Ol1nem před kódem)

| # | Rozhodnutí | Předpoklad v tomto plánu |
|---|-----------|--------------------------|
| R1 | "5 pohádek zdarma" = 5 **na zemi**, ne 5 celkem | **Potvrzeno (2026-10-03):** 5 na zemi (≈ 975 free pohádek při 195 zemích). **Výjimka (2026-10-04): Česko celé zdarma** — všechny jeho pohádky jsou free (v binárce), placený balíček CZ neexistuje. |
| R2 | Free obsah je v binárce, nebo se dotahuje | **Rozhodnuto (2026-10-03): po kontinentech.** Binárka = core + free **Evropa** (5 pohádek z každé evropské země). Ostatní kontinenty = jeden free balíček na kontinent ke stažení zdarma. Placené balíčky zůstávají po zemích. Viz §11. |
| R3 | Postavy nemluví | Žádné namluvené repliky. Zvuky = hudba + soundboard tvorů + SFX. Pokud by hlasy někdy přibyly, půjdou jako oddělený per-jazyk sub-pack (~18 MB / 50 pohádek / jazyk), ne do hlavního packu |
| R4 | Hosting velkých packů | Manifest + free packy = GitHub Pages. **Placené packy = GitHub Releases** (nebo Cloudflare R2), Pages je pro 195 × 150 MB nepoužitelný — viz §6 |
| R5 | Ochrana placených packů | MVP: nešifrovat, spoléhat na obskurnost URL + IAP gate. Fáze 2: AES-GCM klíč vydaný z `store.ol1n.com` po ověření účtenky |
| R6 | Kvalita assetů | Dvě úrovně: **lite** (default pro mobil) a **full** (volitelné dostažení). Čísla níže jsou pro obě |

---

## 3. Obsahová jednotka = jedna pohádka

Vše je odvozeno od tohoto rozpočtu. Opus: tyto limity vynucuj v pipeline (fail buildu packu, když je pohádka nad limit).

| Asset | Formát | Počet / pohádka | lite | full |
|-------|--------|-----------------|------|------|
| Text: postavy, úkoly, zápletka, řešení, nápovědy (všechny jazyky) | JSON, gzip | 1 | 30 KB | 30 KB |
| Obrázky: 3 postavy + 1–2 prostředí + 1 motiv | WebP q80 | 6 | 6 × 90 KB (768 px) = **540 KB** | 6 × 220 KB (1024 px) = **1,3 MB** |
| Krátké animace (loop 2–3 s) | WebM VP9 / Lottie | 2 | 0 (vypnuto) | 2 × 600 KB = **1,2 MB** |
| Hudba (60–90 s loop) | Opus 48 / 80 kbps | 1 | **450 KB** | **750 KB** |
| Zvuky / soundboard tvorů | Opus 48 kbps, 1–3 s | 8 | 8 × 25 KB = **200 KB** | 8 × 40 KB = **320 KB** |
| **Celkem** | | | **≈ 1,2 MB** | **≈ 3,6 MB** |

Sdílené per-země (jednou na zemi, ne na pohádku): prostředí země (les, moře…) + soundboard tvorů země + ambient = **~4 MB lite / ~10 MB full**. Sdílené globální (glóbus, UI, fonty, ikonky stylů): v binárce.

---

## 4. Kolik zabere free appka

### Binárka (bez obsahu)
- Flutter release: Android AAB ~20–25 MB stažení, iOS ~35–45 MB (iOS je vždy větší, nepočítat s menším)
- Glóbus: textura 4k WebP ~3 MB + normal/specular ~2 MB, mesh, shader ~1 MB → **~6 MB**
- UI, fonty (latinka + azbuka + CJK subset pro překlady!), ikony, Rive/Lottie animace UI → **~8 MB** (CJK fonty umí být 10+ MB samy — subsetovat přes `google_fonts` lazy load nebo `pyftsubset`)
- **Binárka: ~35 MB Android / ~55 MB iOS**

### Free obsah jedné země
- 5 pohádek × 1,2 MB (lite) = 6 MB + sdílené 4 MB = **~10 MB lite**
- 5 × 3,6 + 10 = **~28 MB full**

### Free obsah všech zemí (195)
- lite: 195 × 10 MB = **~2 GB**
- full: 195 × 28 MB = **~5,5 GB**

→ Proto R2: **nebundlovat.** Do binárky jdou 2–3 země (≈ 30 MB lite), zbytek jako free packy on-demand. Google Play limit base APK je 200 MB, iOS začne nad 200 MB blokovat stahování přes mobilní data — samo o sobě je to argument.

### Výsledek pro store
| | Android | iOS |
|--|---------|-----|
| Stažení ze storu (binárka + 3 startovní země lite) | **~65 MB** | **~85 MB** |
| Po první návštěvě dalších 10 zemí (lite) | +100 MB | +100 MB |
| Uživatel, který "roztočil" 50 zemí | ~550 MB | ~570 MB |

Opus: v nastavení dej **"Uvolnit místo"** — smaže obsah zemí, které uživatel nenavštívil > 30 dní, mimo zakoupené (ty se mažou jen ručně a jdou kdykoli znovu stáhnout).

---

## 5. Kolik zabere balíček 50 pohádek

| Varianta | Výpočet | Velikost |
|----------|---------|----------|
| **lite** (default) | 50 × 1,2 MB | **~60 MB** |
| **full** | 50 × 3,6 MB | **~180 MB** |

Sdílené per-země assety v placeném packu **nejsou** — jsou už ve free packu země (prerekvizita: placený pack vyžaduje nainstalovaný free pack téže země). Pokud placené pohádky přidávají nová prostředí/tvory, jdou jako `country_extra_<cc>` (~3–5 MB), počítej +5 MB.

Praktické zaokrouhlení pro komunikaci uživateli: **"~60 MB, s HD grafikou a animacemi ~200 MB."**

Celkový objem k vygenerování a hostování: 195 × 60 MB = **~12 GB lite**, 195 × 180 MB = **~35 GB full**. Toto číslo řídí volbu hostingu v §6 a je to i práce pro Spark (9 750 pohádek × 6 obrázků = ~58 k obrázků, 9 750 hudebních loopů, ~78 k SFX) — plánovat v `STORYTELLER_OFFLINE_PLAN.md` nightly pipeline jako dlouhoběžící job, generovat po zemích podle priority (CZ, SK, DE, AT, PL, UK, US… podle locale uživatelů).

---

## 6. Hosting a distribuce

### GitHub Pages — limity, které tady kousnou
- Repo doporučeno < 1 GB, tvrdě naráží kolem 5 GB
- Soft limit **100 GB bandwidth / měsíc** a 10 buildů / h
- Git objekt > 100 MB je odmítnut (bez LFS; LFS Pages neservíruje)
- Jen 100 GB/měsíc = **~1 600 stažení lite packu** nebo ~550 full packů měsíčně, včetně free packů. Při úspěchu appky to padne první měsíc.

### Doporučené rozdělení (pattern Lexify zachován pro manifest a free)
| Co | Kde | Proč |
|----|-----|------|
| `manifest.json`, katalog zemí, verze packů, checksumy, náhledy | **GitHub Pages** (`storyteller-content` repo) | malé, verzované, stejné jako Lexify |
| Free packy zemí (195 × 10 MB = 2 GB) | **GitHub Releases** téhož repa — release `free-v1`, asset per země | Releases se nepočítají do velikosti repa, asset až 2 GB, bez 100 GB soft limitu |
| Placené packy (12–35 GB) | **GitHub Releases** — release `pack-<cc>-v1`, assety `<cc>-lite.zip`, `<cc>-full.zip` | totéž; URL nejsou zveřejněné v manifestu, klient si je skládá až po IAP |
| Fallback / fáze 2 | **Cloudflare R2** (10 GB free, egress zdarma, vlastní doména `cdn.ol1n.com`) | až bude Releases pomalé nebo bude potřeba šifrování a signed URL z `store.ol1n.com` |

Release URL pattern: `https://github.com/lioilsources/storyteller-content/releases/download/pack-cz-v1/cz-lite.zip` — stabilní, cachované CDN, redirect na `objects.githubusercontent.com` (klient musí následovat redirect; Dio to dělá).

Opus: udělej hosting **konfigurovatelný přes manifest** (`base_urls: {pages, releases, r2}`), aby přesun na R2 byl změna manifestu, ne release appky.

### Formát packu
```
cz-lite.zip
├─ pack.json          # id, country, tier, version, size, sha256 per file, min_app_version, licence
├─ stories/
│  ├─ cz-006/         # 6..55 pro placený, 1..5 free
│  │  ├─ story.json   # texty ve všech jazycích, nápovědy, reference na assety
│  │  ├─ img/*.webp
│  │  ├─ music.opus
│  │  └─ sfx/*.opus
└─ shared/            # jen ve free packu / country_extra
```
Zip bez komprese pro média (už jsou komprimovaná), `deflate` jen pro JSON. Stahovat s `Range` + resume, ověřit sha256 celku před rozbalením, rozbalit do `getApplicationSupportDirectory()/packs/<id>/`, pak atomicky přepnout symlink/záznam v SQLite `installed_packs`.

Manifest (`manifest.json`, GitHub Pages):
```json
{
  "schema": 2,
  "base_urls": { "free": "https://github.com/.../releases/download/free-v1/", "paid": "https://github.com/.../releases/download/" },
  "countries": {
    "cz": { "name": {"cs":"Česko","en":"Czechia"}, "free": {"version":1,"size":10485760,"sha256":"…"},
            "paid": {"product_id":"pack_cz","version":1,"tiers":{"lite":{"size":62914560},"full":{"size":188743680}}} }
  }
}
```
Placené URL se v manifestu **neuvádějí**, klient skládá `paid + pack-<cc>-v<version>/<cc>-<tier>.zip` až po ověření nároku. (Není to bezpečnost, jen nezvaní neplatiče přímo.)

---

## 7. IAP a nároky

- Flutter `in_app_purchase` (oficiální), jedna abstrakce `StoreGateway` nad StoreKit 2 / Play Billing 7+
- Produkty **non-consumable**: `pack_<cc>` (194 ks — CZ je celé zdarma, `pack_cz` není — generuj přes Play Developer API / App Store Connect API skriptem, ručně to nejde)
- Bundly: `bundle_<continent>` (7 ks), `bundle_world` (1 ks). Bundle odemyká všechny `pack_<cc>` kontinentu; nárok = union
- **Ceník (návrh, tier v obchodech):** země 2,99 € · kontinent 14,99 € · svět 34,99 € (≈ 12 zemí; psychologicky "všechno za cenu jedné hry"). Alternativa k otestování: roční předplatné "Celý svět" 19,99 €/rok, ale offline packy + subscription = musí se řešit expirace obsahu; pro MVP **jen non-consumable**.
- Nárok uložit lokálně (SQLite `entitlements`, podepsaný store receipt), **Restore purchases** povinné (Apple review), ověření na serveru ve fázi 2 (`store.ol1n.com`, Go, verify receipt → vydá klíč/signed URL)
- Free packy IAP nevyžadují — nikdy nesmí stahování free obsahu narazit na store (Apple: obsah zdarma nesmí být za "platební zdí")
- Play/Apple pravidla: digitální obsah **musí** jít přes store billing (žádné Stripe v appce), ale stahování obsahu z vlastního hostingu po nákupu je v pořádku. V review notes napiš, že packy se stahují z GitHub, a dej reviewerovi promo kód / tester účet.
- Po nákupu: automaticky stáhnout lite, nabídnout full jako "Stáhnout HD (180 MB)"

---

## 8. Změny v pipeline (Spark)

1. Každá pohádka dostane `tier` (free 1–5 / paid 6–55) už v RAG kroku — free pohádky musí být **nejlepší z země**, ne první vygenerované; nechat LLM ohodnotit a vybrat top 5 podle univerzálnosti/hravosti
2. Exportní krok `build_pack --country cz --tier lite|full` → zip + `pack.json` + řádek do manifestu; deterministický, idempotentní
3. Enforce rozpočet §3 (resize, re-encode, fail nad limit)
4. `gh release create pack-cz-v1 cz-lite.zip cz-full.zip` z pipeline; manifest commit + push → Pages
5. Verzování: bump `version` = klient nabídne update, staré release nemazat 2 verze zpět

---

## 9. Fáze

| Fáze | Obsah | Výstup |
|------|-------|--------|
| 0 | Potvrdit R1–R6, přečíst Lexify loader | rozhodnutí v tomto souboru |
| 1 | `pack_builder` v pipeline + manifest schema 2 + 3 startovní země (cz, sk, en) lite | `storyteller-content` repo, první release |
| 2 | Klient: manifest sync, free pack download/resume/verify, storage manager "Uvolnit místo" | free appka funguje pro všechny země on-demand |
| 3 | IAP: `StoreGateway`, `pack_<cc>` + bundly, restore, paid download gate | closed test s licenčními testery |
| 4 | full tier, UI volby kvality | |
| 5 | `store.ol1n.com` verify + R2 + šifrování packů (jen pokud pirátství reálně bolí) | |

---

## 10. Otevřené otázky pro Ol1na
1. R1: opravdu 5 free **na zemi**? (Alternativa: 5 free celkem + náhled každé země zdarma — free obsah pak 10 MB místo 2 GB, ale glóbus je z 97 % zamčený.)
2. Chceš `bundle_world` jako non-consumable, nebo raději předplatné (opakovaný příjem, ale komplikace s offline expirací)?
3. ~~Organizační Play účet přes D-U-N-S už je?~~ **D-U-N-S Ol1n má (2026-10-03), organizační Play účet si nastaví sám.** Do té doby closed test s 12 testery platí jako dřív.

Zodpovězeno: 1. ano, 5 na zemi (R1), free obsah se dělí po kontinentech (R2).

---

## 11. Stav implementace

### 2026-10-04, větev `feat/packs-continents` (navazuje na `feat/content-packs`)

Rozhodnutí 3.–4. 10. 2026 a co z nich je v kódu:

| Rozhodnutí | Stav |
|------------|------|
| R1: 5 pohádek zdarma na zemi | potvrzeno; `FREE_TALES = 5` v `pack_builder` beze změny |
| Celé Česko zdarma (2026-10-04) | `FREE_ALL_COUNTRIES = {"CZ"}` v `pack_builder`: všechny zobrazitelné české pohádky jdou do free (tedy do balíčku Evropy v binárce), CZ nemá placený balíček ani produkt `pack_cz`; placené pohádky ze staršího stavu se převedou do free. Zvolena varianta „CZ celé uvnitř Evropy“, ne samostatný CZ balíček: žádný nový typ balíčku, klient beze změny. |
| Free obsah po kontinentech, Evropa v binárce | hotovo v pipeline i klientu (níže) |
| D-U-N-S | Ol1n má; organizační Play účet si nastaví sám (v repu nic) |
| `lioilsources/storyteller-content` | založené (public, Pages z `docs/`, kostra `docs/manifest.json`); zatím nic nepublikováno |

**Kontinenty.** Asset glóbu (`app/assets/geo/countries.json`) kontinent nenese a zdrojový GeoJSON Natural Earth v repu není, proto tabulka ISO2 → kontinent v `rag/rag/continents.py`, vyplněná podle pole CONTINENT z Natural Earth (RU → Evropa, TR/CY/Kavkaz → Asie, EG → Afrika, GL a Karibik → Severní Amerika). Kódy EU, AF, AS, NA, SA, OC, AN; neznámá země build shodí. Klient tabulku nepotřebuje — manifest nese u kontinentu seznam zemí.

**Pipeline.** `pack_builder` staví:
- `continent.<K>.<lang>.free` — free pohádky (5 na zemi, přiřazení v `packs-state` dál trvalé) všech zemí kontinentu, zip `free-v1/continent-<k>-free-v<n>.zip`;
- Evropu (`continents.BUNDLED`) navíc jako surový SQLite soubor `dist/bundle/continent.EU.<lang>.free.db` pro binárku;
- `country.<CC>.<lang>.paid` — placené po zemích jako dřív (`pack-<cc>-v<n>/<cc>-lite.zip`);
- `manifest.json` **schema 3**: sekce `continents` (`name`, `bundled`, `countries`, `free`) a `countries` (`continent`, `free_tales`, `paid`); `sizes.json` s velikostmi každého balíčku.

**Počet pohádek na glóbu.** Nová tabulka `pack_tales(source_ref, country_code, motifs, shown)` v každém packu z `rag.build_pack` (z `tales.jsonl`; `motifs` nemá `tale_id`). Řádek na pohádku, ne součet na zemi: `RagStore.taleCounts()` počítá DISTINCT `source_ref` přes všechny otevřené packy, takže vestavěný i stažený balíček se stejnou pohádkou ji nezapočítá dvakrát. Glóbus u zemí z balíčku ukazuje „N motivů z M pohádek“ (N = motivy úkol/problém/konec s českým titulkem, M = jejich pohádky); pack bez tabulky dál „N motivů z balíčku“.

**Klient.** `PackManifest` schema 3 (`continents`, `continentOf(iso)`), `PackRepository.installContinent(code)` (vestavěný kontinent odmítne), `hasContinent`, `removeContinent`; `touch(iso)` drží při životě i kontinent země; „Uvolnit místo“ maže nepoužité kontinenty, zakoupené země nikdy. Glóbus u země na nestaženém, nevestavěném kontinentu nabídne „Stáhnout balíček Afrika: N pohádek zdarma (X MB)“. Placený balíček už nestahuje free balíček s sebou (viz odchylky).

**Binárka.** `app/rag_packs.sha256` → `rag-packs-cs-8` = `core.cs.db` (beze změny) + `continent.EU.cs.free.db`. Samostatný `country.CZ.cs.db` a WORLD z binárky odcházejí; Česko zůstává celé uvnitř Evropy.

**Světové karty (task/problem/ending).** `build_pack` bere kartu každého motivu packu z `rag/data/motif_images/<id>.jpg`, takže karty z `world_tpe_cards.json` (2 382) se do kontinentálních i placených balíčků zabalí samy; 2 328 z nich patří motivům, které v nějakém balíčku jsou (zbytek jsou pohádky nad 55 na zemi). Rozpracovaný soubor build neshodí (obrázek se vynechá). Rozpočet drží: nejvíc karet na pohádku je 19 (limit 24), 19 × ~25 KB je hluboko pod 1,2 MB; přebytek scén ořízne `trim_scene_art`.

#### Velikosti (běh 2026-10-04 11:38, `--lang cs`, Česko celé zdarma, světové karty 2 050 / 2 382)

| Balíček | Zemí | Pohádek | Obrázků | zip | SQLite |
|---------|------|---------|---------|-----|--------|
| **Evropa (binárka)** | 31 | 160 (CZ 28 + 5 na zemi) | 1 405 | 62,0 MB | **75,3 MB** |
| Afrika | 18 | 56 | 327 | 12,2 MB | 14,8 MB |
| Asie | 16 | 63 | 284 | 10,5 MB | 13,0 MB |
| Severní Amerika | 9 | 37 | 171 | 6,1 MB | 7,8 MB |
| Oceánie | 3 | 8 | 52 | 2,1 MB | 2,9 MB |
| Jižní Amerika | 2 | 3 | 36 | 1,4 MB | 2,1 MB |
| Placené (51 zemí, bez CZ) | | 623 | | 55,0 MB celkem; DE 19,8 MB, ostatní ≤ 1,1 MB | |

**Binárka (packy): core 13,9 MB + Evropa 75,3 MB ≈ 89 MB** (po zbylých ~330 kartách odhad ~92 MB), dnes ~125 MB (core + CZ 47,2 + WORLD 63,6). **Pod hranicí ~150 MB**, nic není potřeba ořezávat; rozpočet 1,2 MB na pohádku drží `trim_scene_art` (u Evropy oříznuto 3 157 scén nad rozpočet, text scén zůstává).

Česko „celé“ = všech 28 pohádek, které appka umí ukázat (aspoň jeden motiv s českým titulkem). Korpus má českých pohádek 127; zbylých 99 zatím nemá nic zobrazitelného (a nebylo zobrazitelné ani v dosavadním vestavěném `country.CZ.cs.db`). Jakmile je `rag.verbalize`/`rag.cards` otitulkuje, další běh je přidá do free (Evropa dostane novou verzi).

### Co zbývá k fázi 1 „publikováno“ (2026-10-04)
1. ~~Založit repo `storyteller-content`~~ — hotovo.
2. Po doběhnutí světových karet (`render-motifs`, okno do 12:50) plný běh `python -m rag.pack_builder --lang cs` načisto (bez `rag/packs-state.cs.json` — předběžný stav z 4. 10. leží jen v `dist/packs-state.preview.json`, přiřazení free/placené závisí i na tom, kolik motivů má kartu) a `rag/packs-state.cs.json` commitnout.
3. `rag/publish_packs.sh rag/data/dist <checkout storyteller-content>` (na Macu s `gh`).
4. Release `rag-packs-cs-8` v `lioilsources/storyteller` s `core.cs.db` + `dist/bundle/continent.EU.cs.free.db`, přepsat hash EU v `app/rag_packs.sha256` (teď předběžný).
5. Release appky: `MIN_APP_VERSION` v `pack_builder.py` (1.4.0) = ta verze.

### 2026-09-29, větev `feat/content-packs`

Hotovo: fáze 1 (bez publikace) a fáze 2; IAP jen jako rozhraní.

- Pipeline: `rag/rag/pack_builder.py` (+ `build_pack` rozšířený o `source_refs`, `built_at`, `compat`), stav vrstev a verzí `rag/packs-state.<lang>.json`, publikace `rag/publish_packs.sh`.
- Klient: `app/lib/packs/` — `PackManifest`, `PackRepository` (manifest sync s offline cache, download s Range resume, sha256 zipu i každého souboru z `pack.json`, atomická instalace `.tmp` → rename → `installed_packs`, aktualizace verzí, „Uvolnit místo“), `StoreGateway` (`NoStoreGateway`; `--dart-define=STORYTELLER_UNLOCK_ALL=true` odemkne vše pro vývoj), glóbus nabízí stažení free balíčku, list „Stažené pohádky“.
- Testy: `rag/tests/test_pack_builder.py`, `app/test/pack_repository_test.dart` (včetně skutečného zipu z pipeline → `RagStore`).

### Odchylky od plánu a proč

| Bod | Plán | Implementace | Proč |
|-----|------|--------------|------|
| Lexify loader (§1) | „zkopíruj přesně“ | napsáno znovu | Lexify žádný takový loader nemá: bez zipů, manifestu, sha256 i DB — stahuje `deck.json` a obrázky po jednom, instalaci pozná podle existence souboru. Převzato: konstantní URL obsahu, „novější verze vyhrává, remíza nechá co je“. |
| Formát packu (§6) | `stories/<id>/story.json` + webp/opus | `pack.json` + jeden SQLite soubor z `rag.build_pack` | Appka čte obsah přes `RagStore` (motivy, nápovědy s int8 vektory, obrázky jako BLOB). Balíček ve stejném formátu jako vestavěné packy = žádný druhý loader ani převod. Zip je deflate celý (SQLite se komprimuje, JPEG uvnitř ne). |
| Obsahová jednotka (§3) | pohádka = 3 postavy + prostředí + motiv | pohádka = její motivy s kartami (postava/úkol/problém/konec) + scény + nápovědy | Appka skládá příběh z motivů napříč pohádkami, ne z hotových pohádek. „5 pohádek“ = motivy z 5 zdrojových pohádek země. |
| Rozpočet (§3) | 6 obrázků, 1,2 MB | 1,2 MB vynuceno, obrázků ≤ 24 | Karta na každý zobrazený motiv (~34 KB JPEG 512 px) + scény; české pohádky mají 14–20 obrázků a stále < 1,1 MB. Přebytečná scénická grafika se ořízne (scéna zůstane textem), nad limit → build selže. |
| Hudba, zvuky (§3) | per pohádka / per země | globální v `core` packu (v binárce) | Katalog 13 prostředí × 2 nálady + 32 tvorů + 30 akcí sdílí celý svět; per-země soundboard zatím není. |
| Animace, WebP, full tier (R6) | lite + full | jen lite (JPEG) | Animace ani full assety neexistují; fáze 4. |
| Výběr free pohádek (§8.1) | LLM vybere top 5 | připravenost (zobrazitelné motivy, obrázky, nápovědy) | Director je obsazený nápovědami; LLM hodnocení je samostatná fáze. Přiřazení je ale už teď trvalé: pohádka z free nikdy nepřejde do placené. |
| Jazyk | manifest bez jazyka | `"lang": "cs"`, id packu `country.<CC>.<lang>.<free|paid>` | Veškerý obsah je zatím česky; další jazyk = další manifest. |
| Počet zemí | 195 | 79 s obsahem (vlna 1) | Tolik jich korpus má; manifest nese jen země s aspoň jednou zobrazitelnou pohádkou. |
| R2 binárka | 2–3 startovní země | od 2026-10-04 core + free Evropa | Rozhodnutí 2026-10-03: free obsah po kontinentech, v binárce Evropa (viz výš). RagStore duplicity (stejný motiv vestavěný i stažený) odfiltruje. |
| Prerekvizita placeného (§5) | placený vyžaduje free téže země | placený stojí sám | Free je teď celý kontinent; tahat ho s koupí jedné země by bylo nečekaně velké stažení, a sdílené assety země neexistují (hudba a zvuky jsou v core). |
| Nárok (§7) | SQLite `entitlements` | jen rozhraní | Fáze 3. |

### Co zbývalo k fázi 1 „publikováno“ (2026-09-29, nahrazeno výš)
1. Založit repo `lioilsources/storyteller-content` s GitHub Pages ze složky `docs/`.
2. `python -m rag.pack_builder --lang cs` (plný běh; vytvoří `rag/packs-state.cs.json` — commitnout).
3. `rag/publish_packs.sh rag/data/dist <checkout storyteller-content>` na stroji s `gh`.
4. Release appky: `app/rag_packs.sha256` jen core + CZ; `MIN_APP_VERSION` v `pack_builder.py` = ta verze.
