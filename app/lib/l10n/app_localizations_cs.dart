// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get castTitle => 'Kdo bude v pohádce?';

  @override
  String get castHint =>
      'Ťukni na kartu = jiná postava. Kartu smaž křížkem. Hudba a zvuky jsou vždy hotové z packu země — jen obrázek postavy se občas chvilku dokresluje.';

  @override
  String get castAdd => 'Přidat postavu';

  @override
  String get castCount => 'Obsazení:';

  @override
  String get castShuffleAll => 'Zamíchat vše';

  @override
  String get castContinue => 'Pokračovat →';

  @override
  String get shuffle => 'Zamíchat';

  @override
  String get motifTaskTitle => 'Jaký úkol?';

  @override
  String get motifProblemTitle => 'Jaký problém?';

  @override
  String get motifEndingTitle => 'Jaký konec?';

  @override
  String get motifTaskCaption => 'Ťukni na kartu = vyber úkol pro hrdinu.';

  @override
  String get motifProblemCaption =>
      'Ťukni na kartu = vyber překážku nebo záporáka.';

  @override
  String get motifEndingCaption => 'Ťukni na kartu = vyber šťastný konec.';

  @override
  String get beatCastTitle => 'Kdo v tom bude';

  @override
  String get beatTaskTitle => 'Co si hrdina předsevzal';

  @override
  String get beatProblemTitle => 'Co se postavilo do cesty';

  @override
  String get beatEndingTitle => 'Jak to dopadlo';

  @override
  String get beatCastCaption =>
      'Představ postavy. Kde jsou, jak vypadají, co je na nich zvláštního.';

  @override
  String get beatTaskCaption => 'Řekni, co hrdina chce a proč se pro to vydal.';

  @override
  String get beatProblemCaption =>
      'Postav mu něco do cesty. Ať to chvíli vypadá, že to nepůjde.';

  @override
  String get beatEndingCaption =>
      'Doveď to do konce. Nespěchej — konec si dítě pamatuje nejvíc.';

  @override
  String get hintHero => 'hrdina';

  @override
  String hintCast1(String who) {
    return 'Jak $who vypadá, když se poprvé objeví?';
  }

  @override
  String hintCast2(String who) {
    return 'Co $who zrovna dělá, než celý příběh začne?';
  }

  @override
  String hintCast3(String who) {
    return 'Čeho se $who bojí?';
  }

  @override
  String hintCast4(String who) {
    return 'Podle čeho poznáš, že přichází $who?';
  }

  @override
  String get hintCast5 => 'Kdo z nich se zná už dlouho a odkud?';

  @override
  String get hintCast6 => 'Jaké je počasí, když se potkají?';

  @override
  String hintCast7(String who) {
    return 'Co má $who v kapse?';
  }

  @override
  String hintTask1(String who) {
    return 'Kdy $who pochopí, že se do toho musí pustit?';
  }

  @override
  String hintTask2(String who) {
    return 'Kdo to poradil a proč $who poslechne?';
  }

  @override
  String hintTask3(String who) {
    return 'Co musí $who nechat doma?';
  }

  @override
  String get hintTask4 => 'Jak dlouhá je ta cesta a přes co vede?';

  @override
  String hintTask5(String who) {
    return 'Co si $who slíbí, než vyrazí?';
  }

  @override
  String get hintTask6 => 'Proč to nemůže udělat někdo jiný?';

  @override
  String get hintProblem1 => 'V tu chvíli se ozve zvuk — jaký?';

  @override
  String get hintProblem2 => 'Co se pokazí jako první?';

  @override
  String hintProblem3(String who) {
    return 'Co $who zkusí nejdřív a proč to nevyjde?';
  }

  @override
  String get hintProblem4 => 'Kdo odmítne pomoct, i když by mohl?';

  @override
  String get hintProblem5 => 'Co by se stalo, kdyby to teď všichni vzdali?';

  @override
  String get hintProblem6 => 'Je na té překážce něco smutného?';

  @override
  String hintProblem7(String who) {
    return 'Co $who v tu chvíli řekne nahlas?';
  }

  @override
  String hintEnding1(String who) {
    return 'Čím to $who nakonec zlomí — silou, nebo nápadem?';
  }

  @override
  String get hintEnding2 => 'Kdo pomůže, i když by nemusel?';

  @override
  String hintEnding3(String who) {
    return 'Co $who udělá jako úplně první, když je po všem?';
  }

  @override
  String get hintEnding4 => 'Co je na konci jinak než na začátku?';

  @override
  String hintEnding5(String who) {
    return 'Kam se $who vrátí a kdo tam čeká?';
  }

  @override
  String get hintEnding6 => 'Jaká je poslední věta, než se rozsvítí?';

  @override
  String get globeLoading => 'Chystám planetu…';

  @override
  String get globeLoadFailed => 'Planetu se nepodařilo načíst.';

  @override
  String get globeTitle => 'Odkud bude pohádka?';

  @override
  String get globeStored => 'Stažené pohádky';

  @override
  String get globeHintFar =>
      'Roztoč planetu nebo ťukni na zemi. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.';

  @override
  String get globeHintNear =>
      'Ťukni na zemi nebo na stavbu. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.';

  @override
  String get globeWhole => 'Celá planeta';

  @override
  String get globeZoomIn => 'Přiblížit';

  @override
  String get globeZoomOut => 'Oddálit';

  @override
  String globeZoomToRegion(String name) {
    return 'Přiblížit $name →';
  }

  @override
  String get globeTellHere => 'Vyprávět odsud';

  @override
  String globeTellFrom(String place) {
    return 'Vyprávět $place →';
  }

  @override
  String get globeOpenSea => 'Širé moře';

  @override
  String globeRegionCountries(int n) {
    return '$n zemí pohromadě. Přibliž se a vyber si jednu.';
  }

  @override
  String get globeTurnToCountry => 'Otoč planetu na nějakou zemi.';

  @override
  String get globeSpin => 'Roztočit';

  @override
  String get globeNoTales => 'Odsud zatím žádné pohádky nemáme.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivů',
      few: '$n motivy',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'z $n pohádek',
      few: 'z $n pohádek',
      one: 'z $n pohádky',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs z balíčku';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivů z balíčku',
      few: '$n motivy z balíčku',
      one: '$n motiv z balíčku',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádku',
    );
    return 'Chystáme odsud $_temp0 do balíčku $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádka',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádka',
    );
    return '$_temp0 zdarma';
  }

  @override
  String cardFree(int n) {
    return '$n zdarma';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n v dílech $region $range',
      one: '$n v dílu $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'máš $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'dalších $n chystáme',
      one: 'další $n chystáme',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Čekám na obchod…';

  @override
  String offerDownloading(int percent) {
    return 'Stahuji pohádky… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádku',
    );
    return 'Koupit $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádku',
    );
    return 'Stáhnout $name: $_temp0 zdarma ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '$n pohádku',
    );
    return 'Stáhnout $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Stáhnout $name';
  }

  @override
  String get errDownloadTales => 'Pohádky se nepodařilo stáhnout.';

  @override
  String get errDownloadScenes => 'Obrázky se nepodařilo stáhnout.';

  @override
  String get errNoDownloads => 'Stahování tu není k dispozici.';

  @override
  String get errOffline => 'Nejsme na internetu — zkus to, až bude signál.';

  @override
  String get errCannotBuy => 'Tenhle díl teď koupit nejde.';

  @override
  String get buyPending => 'Nákup čeká na schválení. Díl se stáhne, až projde.';

  @override
  String get buyFailed => 'Nákup se nepovedl.';

  @override
  String get restoreNone => 'Na tomhle účtu nejsou žádné nákupy.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Obnoveno $n dílů. Stáhneš je z planety.',
      few: 'Obnoveno $n díly. Stáhneš je z planety.',
      one: 'Obnoven $n díl. Stáhneš ho z planety.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Nákupy se nepodařilo obnovit — zkus to, až bude signál.';

  @override
  String get narrationGone => 'Tahle pohádka už není složená.';

  @override
  String get narrationNew => 'Složit novou';

  @override
  String narrationTitle(int index, int total) {
    return 'Vyprávíš — $index ze $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Jak navázat: $bridge';
  }

  @override
  String get narrationSituation =>
      'Co se zrovna děje? (nepovinné, jde nadiktovat)';

  @override
  String get narrationHintNote =>
      'Nápověda — neříkej ji nahlas, jen se od ní odraz.';

  @override
  String get narrationSoundsNote => 'Zvuky — pusť, až se to do vyprávění hodí.';

  @override
  String get moodTense => 'napětí';

  @override
  String get moodCalm => 'klid';

  @override
  String get narrationSearching => 'Hledám…';

  @override
  String get narrationHint => 'Napověz';

  @override
  String get narrationMoreHint => 'Ještě jednu';

  @override
  String get narrationBack => 'Zpět';

  @override
  String get narrationEnd => 'Konec';

  @override
  String get narrationNext => 'Dál →';

  @override
  String get narrationGoodnight => 'Dobrou noc.';

  @override
  String get narrationEndNote =>
      'Závěrečný obrázek a ukládání do Knihovny zatím neumíme — tahle pohádka nikam neodchází, zůstala mezi vámi.';

  @override
  String get narrationClose => 'Zavřít';

  @override
  String get ragFallback => 'Z balíčku k tomuhle zatím nic — obecná nápověda:';

  @override
  String get ragNoModel => 'Model pro nápovědy není v téhle sestavě.';

  @override
  String get ragHintGeneral => 'obecná';

  @override
  String get ragHintMotif => 'k motivu';

  @override
  String get captionExact => 'ilustrace · k tomuhle motivu';

  @override
  String get captionSimilar => 'ilustrace · podobná scéna';

  @override
  String get captionCard => 'karta motivu · scénu k tomuhle kroku zatím nemáme';

  @override
  String get storageTitle => 'Stažené pohádky';

  @override
  String get storageEmpty => 'Zatím nic — další pohádky se stáhnou z planety.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n balíčků',
      few: '$n balíčky',
      one: '$n balíček',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scény $name';
  }

  @override
  String get storageFreeTier => 'zdarma';

  @override
  String get storageBoughtTier => 'zakoupeno';

  @override
  String get storageDelete => 'Smazat';

  @override
  String get storageScenesSub => 'Obrázek ke každému kroku vyprávění';

  @override
  String get storageDownload => 'Stáhnout';

  @override
  String get storageAllUsed => 'Všechno se používalo v posledních 30 dnech.';

  @override
  String storageFreed(String size) {
    return 'Uvolněno $size.';
  }

  @override
  String get storageFreeUp => 'Uvolnit místo (nepoužité 30 dní)';

  @override
  String get storageRestoring => 'Obnovuji nákupy…';

  @override
  String get storageRestore => 'Obnovit nákupy';

  @override
  String get osnovaTitle => 'Osnova';

  @override
  String get osnovaSummary => 'Pohádka v kostce';

  @override
  String get osnovaCharacters => 'Postavy';

  @override
  String get osnovaTask => 'Úkol';

  @override
  String get osnovaProblem => 'Problém';

  @override
  String get osnovaEnding => 'Konec';

  @override
  String get osnovaAgain => 'Znovu';

  @override
  String get osnovaTell => 'Vyprávím →';

  @override
  String get outlineHero => 'Hrdina';

  @override
  String get castFox => 'Chytrá liška';

  @override
  String get castSmithSon => 'Kovářův syn';

  @override
  String get castMill => 'Mluvící mlýn';

  @override
  String get castGooseGirl => 'Husopaska';

  @override
  String get castBrothers => 'Tři bratři';

  @override
  String get castClockworkPrincess => 'Princezna hodinářka';

  @override
  String get castOwl => 'Moudrá sova';

  @override
  String get castBlacksmith => 'Stará kovářka';

  @override
  String get castDragon => 'Malý drak';

  @override
  String get castWaterSprite => 'Vodník';

  @override
  String get castFourPrincesses => 'Čtyři princezny';

  @override
  String get castTravelingTailor => 'Potulný krejčí';

  @override
  String get castTalkingCat => 'Mluvící kocour';

  @override
  String get castForestHermit => 'Lesní poustevník';

  @override
  String get castC0AndersenTheShadow => 'Pán, co býval stínem';

  @override
  String get castC1GrimmTheGooseGirl => 'Zrádná komorná';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Král se strašidelným hradem';

  @override
  String get castC3AndersenTheShadow => 'Chytrý stín';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Krásná, ale nechytrá princezna';

  @override
  String get castC5AndersenTheRedShoes => 'Anděl, co nakonec odpustí';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mlynářova chytrá dcera';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Babička, co otevře dveře';

  @override
  String get castC8PerraultLittleThumb => 'Máma mezi bídou a láskou';

  @override
  String get castC9PerraultIntroduction => 'Trpělivá žena';

  @override
  String get castC10AndersenTheRealPrincess => 'Král, co podpoří syna';

  @override
  String get castC11GrimmLilyAndTheLion => 'Dcera, co drží slovo';

  @override
  String get castC12AndersenTheRealPrincess => 'Princ hledá tu pravou';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Holčička se sirkami';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Dvořan, co mlčí';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Věrný sluha chystá hostinu';

  @override
  String get castC16PerraultTheFairy => 'Nafoukaná dcera';

  @override
  String get castC17GrimmFirstStory => 'Vdova, co chce devět ocasů';

  @override
  String get motifTaskWine => 'Kdo vypije sklep vína';

  @override
  String get motifTaskDiamonds => 'Let za diamanty';

  @override
  String get motifTaskRingDuck => 'Prsten v kachně';

  @override
  String get motifTaskGiants => 'Přelstít obry';

  @override
  String get motifTaskTomThumb => 'Útěk malého Palečka';

  @override
  String get motifTaskSwineherd => 'Získat princeznino srdce';

  @override
  String get motifTaskBell => 'Záhadný zvon v lese';

  @override
  String get motifTaskGoldenObject => 'Dar, který nesmí zneužít';

  @override
  String get motifTaskPebbles => 'Cestička z oblázků';

  @override
  String get motifProblemFoxPride => 'Liščina pýcha';

  @override
  String get motifProblemLazySister => 'Líná sestra';

  @override
  String get motifProblemWitchBoots => 'Čarodějnice v sedmimílových botách';

  @override
  String get motifProblemTailorDoubt => 'Nikdo mu nevěří';

  @override
  String get motifProblemLions => 'Hladoví lvi u brány';

  @override
  String get motifProblemEagle => 'Orel a trpaslík';

  @override
  String get motifProblemTruth => 'Kouzelné zvíře prozradí pravdu';

  @override
  String get motifProblemOldHouse => 'Nikdo nechce starý dům';

  @override
  String get motifProblemBreadcrumbs => 'Ptáci snědli drobečky';

  @override
  String get motifEndingTrickWins => 'Chytrost zvítězí';

  @override
  String get motifEndingTruthChild => 'Dítě řekne pravdu';

  @override
  String get motifEndingNewHome => 'Nový domov, staří přátelé';

  @override
  String get motifEndingHappyTogether => 'Šťastně spolu navždy';

  @override
  String get motifEndingKissWakes => 'Polibek probudí království';

  @override
  String get motifEndingLeapfrog => 'Chytrost skáče nejvýš';

  @override
  String get motifEndingCurseBroken => 'Kletba zlomena';

  @override
  String get motifEndingWelcomedHome => 'Vítán doma';

  @override
  String get motifEndingSlipper => 'Ztracený střevíček';
}
