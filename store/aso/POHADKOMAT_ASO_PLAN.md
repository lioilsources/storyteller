# POHADKOMAT_ASO_PLAN.md – handoff pro session Pohádkomat (Tatínku, vyprávěj)

## Stav (App Store, 31. 10. 2026)
- Verze 1.8.0 je **In Review**, po schválení se vydá automaticky. Zatím není v prodeji, takže nemá žádnou analytiku.
- Primární jazyk cs. Texty ve 14 jazycích: cs, sk, pl, en-US, en-GB, de-DE, fr-FR, it, pt-BR, ru, uk, ja, ko, vi.
- **Screenshoty jen cs (14)**, ostatních 13 jazyků 0. Po vydání by všude viděli české screenshoty, stejná chyba jako u ostatních appek.

## Úkoly
1. **Teď do review nesahat.** Nechat 1.8.0 projít, je to první vydání.
2. Hned po vydání založit **1.8.1** (stejný build, jen metadata) s lokalizovanými screenshoty. Použít sdílený generátor screenshotů (viz README).
   - Pořadí: en-US, sk, pl, de-DE, pt-BR, fr-FR, pak ostatní.
   - Ověřit, že nápovědy a pohádky v appce jsou v daném jazyce opravdu lokalizované. Jinak screenshoty v daném jazyce nedávají smysl.
3. **První screenshot:** rodič vypráví a dítě poslouchá, s točícím se globusem. Titulek např. „Vyprávěj pohádky z celého světa“ nebo „Tell bedtime stories from around the world“.
4. **Klíčová slova** míří na rodiče: bedtime stories, fairy tales, story ideas, storytelling, kids stories, parents. V cs: pohádky, pohádka na dobrou noc, vyprávění, pro rodiče, usínání.
5. **Kids category nebo Education/Lifestyle:** pokud jde o appku pro rodiče, ne pro děti, nezařazovat do Kids (přísnější pravidla).
6. 14 dní po vydání zkontrolovat analytiku podle storefrontu, stejně jako u ostatních appek.

## Hotovo, když
- 1.8.0 je vydaná a 1.8.1 má screenshoty ve všech 14 jazycích.

## Plnění (31. 10. 2026)

- **Úkol 1:** 1.8.0 je pořád `IN_REVIEW`, nikdo na ni nesahal.
- **Úkol 2 (lokalizované screenshoty):** aplikace je jen česky, rozhraní ani pohádky lokalizované nejsou. Proto mají všechny jazyky stejné české obrazovky, jen s titulkem v daném jazyce. Na prvním snímku je pod titulkem řádek „aplikace je zatím česky“ (`note`).
  - `store/appstore_captions.json`: titulky ve 14 jazycích.
  - `app/tool/appstore_captions.py`: vyrenderuje z `build/store_screenshots` sady pro iPhone 6,9″ a iPad 13″. Výstup jde do `app/build/appstore_screenshots/<locale>/` (≈190 MB, necommituje se).
  - `app/tool/appstore_upload_shots.py 1.8.1 --apply --metadata ../store/metadata/1.8.1.json`: nahraje screenshoty a texty do všech jazyků.
    - Potřebuje klíč App Store Connect API s rolí **App Manager**. Klíč 5YH964A9M4 má roli Developer a na změny metadat dostane 403.
  - Surové snímky 1.8.1: obrazovky 01, 02, 06 a 07 jsou z kódu 1.8.1 (nová zvuková tlačítka, nabídka „+50“). Obrazovky 03–05 se proti 1.8.0 nezměnily.
- **1.8.1 nebude jen metadata:** build 1.8.1 (24) už je v TestFlightu a nese změnu Sufléru, kterou má Android. Verze 1.8.1 tedy dostane tenhle build, screenshoty i What's New (`store/metadata/1.8.1.json`).
- **Úkol 3:** fotku „rodič vypráví, dítě poslouchá“ nemáme. První snímek je proto glóbus s titulkem „Vyprávěj pohádky z celého světa“.
- **Úkol 4:** klíčová slova už ve všech 14 jazycích míří na rodiče. V en jsem jen vyměnil `prompter` za `ideas` (story ideas), změna je v `store/metadata/1.8.1.json`.
  - Čeština (96/100 znaků) už obsahuje pohádky, vyprávění, dobrou noc, uspávání a rodiče.
- **Úkol 5:** kategorie Knihy + Vzdělávání, ne Kids. Ověřeno v App Store Connect.
- **Zbývá:**
  - po schválení 1.8.0 založit verzi 1.8.1, nahrát screenshoty a texty, vybrat build 1.8.1 a odeslat;
  - 14 dní po vydání zkontrolovat analytiku.
