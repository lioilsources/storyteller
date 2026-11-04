# ASO handoffy – přehled (App Store, data k 29. 10. 2026)

Zdroj: App Store Connect Analytics, 12 měsíců (29. 10. 2025 – 29. 10. 2026), rozpad podle storefrontu.

| App | Zobrazení | Návštěvy stránky | Stažení | Konverze (stažení/zobrazení) | Konverze bez ČR | Výnosy (USD) | Handoff |
|---|---|---|---|---|---|---|---|
| Puff | 3 205 | 30 | 12 | 0,4 % | 0,3 % | 0 | `PUFF_ASO_PLAN.md` |
| Kirian | 1 127 | 136 | 19 | 1,7 % | 0,8 % | 1 (ČR) | `KIRIAN_ASO_PLAN.md` |
| Mirror Booth | 838 | 59 | 18 | 2,2 % | 2,2 % | 0 | `MIRRORBOOTH_ASO_PLAN.md` |
| Poesie Simona Clinae | 535 | 55 | 22 | 4,1 % | 2,7 % | 3 (ČR) | `POESIE_ASO_PLAN.md` |
| Lexify | 341 | 39 | 12 | 3,5 % | 3,8 % | 4 (Čína) | `LEXIFY_ASO_PLAN.md` |
| SwypeKids | 16 | 3 | 0 | – | – | 0 | `SWYPEKIDS_ASO_PLAN.md` |

## Priority
1. **Puff**: má nejvíc zobrazení a nejhorší proklik (0,9 %). Oprava ikony a prvních screenshotů má největší dopad.
2. **Kirian**: dobrý proklik (12 %), ale stránka nepřesvědčí ke stažení. Řešit první screenshoty a app preview video.
3. **Mirror Booth**: lokalizované screenshoty pro Brazílii (pt-BR) a Latinskou Ameriku (es-MX).
4. **Lexify, Poesie**: konverze je dobrá, chybí dosah. Řešit klíčová slova.
5. **SwypeKids**: lokalizované screenshoty pro 12 jazyků. Je čerstvě venku, proto chybí data.

## Společné pro všechny sessions
- **Screenshoty jen v primárním jazyce** mají SwypeKids, Mirror Booth, Lexify, Poesie a Puff. Ostatní jazyky dostanou fallback, takže cizinci vidí cizí text v obrázcích. Jedinou výjimkou je Kirian, ten má lokalizované všechno.
- **Doporučená pipeline:** sdílený generátor screenshotů. Flutter integration test nebo golden screenshot pak projde přes HTML/Skia šablonu s lokalizovaným titulkem, výsledek nahraje `fastlane deliver`. Udělat to jednou a použít pro všechny appky.
- **Velikosti:** iPhone 6,9″ (1320×2868) nebo 6,7″ (1290×2796), iPad 13″ (2064×2752). Menší velikosti App Store dopočítá.
- **Limity metadat:** název 30 znaků, podtitul 30, klíčová slova 100 (oddělená čárkou, bez mezer, neopakovat slova z názvu a podtitulu), promo text 170. Promo text jde měnit bez nové verze.
- Screenshoty a klíčová slova vyžadují **novou verzi** aplikace. Stačí stejný build, nová verze jen s metadaty.
- Měřit **Product Page Optimization (A/B test)** v App Store Connect: až 3 varianty ikony a screenshotů, bez nové verze aplikace (ikony musí být v buildu).
- Po změně počkat 14 dní a porovnat v analytice: Impressions → Product Page Views → Downloads po storefrontech, ČR vyřadit (známí).
