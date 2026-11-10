// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hungarian (`hu`).
class AppLocalizationsHu extends AppLocalizations {
  AppLocalizationsHu([String locale = 'hu']) : super(locale);

  @override
  String get castTitle => 'Kik szerepelnek a mesében?';

  @override
  String get castHint =>
      'Koppints egy kártyára, hogy másik szereplőt kapj. A kártyát az x-szel törölheted. A zene és a hangok mindig készen jönnek az ország csomagjából, csak a szereplő képe készül el olykor egy pillanattal később.';

  @override
  String get castAdd => 'Szereplő hozzáadása';

  @override
  String get castCount => 'Szereposztás:';

  @override
  String get castShuffleAll => 'Mind összekeverése';

  @override
  String get castContinue => 'Tovább →';

  @override
  String get shuffle => 'Keverés';

  @override
  String get motifTaskTitle => 'Milyen feladat?';

  @override
  String get motifProblemTitle => 'Milyen probléma?';

  @override
  String get motifEndingTitle => 'Milyen befejezés?';

  @override
  String get motifTaskCaption =>
      'Koppints egy kártyára, és válaszd ki a hős feladatát.';

  @override
  String get motifProblemCaption =>
      'Koppints egy kártyára, és válassz akadályt vagy gonosztevőt.';

  @override
  String get motifEndingCaption =>
      'Koppints egy kártyára, és válassz boldog véget.';

  @override
  String get beatCastTitle => 'Kik szerepelnek';

  @override
  String get beatTaskTitle => 'Mit tűzött ki célul a hős';

  @override
  String get beatProblemTitle => 'Mi állt az útjába';

  @override
  String get beatEndingTitle => 'Hogyan végződött';

  @override
  String get beatCastCaption =>
      'Mutasd be a szereplőket: hol vannak, hogyan néznek ki, mi különleges bennük.';

  @override
  String get beatTaskCaption => 'Mondd el, mit akar a hős, és miért indult el.';

  @override
  String get beatProblemCaption =>
      'Állíts valamit az útjába. Egy ideig úgy tűnjön, hogy nem fog sikerülni.';

  @override
  String get beatEndingCaption =>
      'Vidd végig a mesét. Ne siess, a gyerek a végére emlékszik a legjobban.';

  @override
  String get hintHero => 'a hős';

  @override
  String hintCast1(String who) {
    return 'Hogyan néz ki «$who», amikor először megjelenik?';
  }

  @override
  String hintCast2(String who) {
    return 'Mit csinál «$who» közvetlenül azelőtt, hogy az egész történet elkezdődik?';
  }

  @override
  String hintCast3(String who) {
    return 'Mitől fél «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Miről ismered fel, hogy «$who» közeledik?';
  }

  @override
  String get hintCast5 => 'Melyikük ismeri egymást régóta, és honnan?';

  @override
  String get hintCast6 => 'Milyen idő van, amikor találkoznak?';

  @override
  String hintCast7(String who) {
    return 'Mi van «$who» zsebében?';
  }

  @override
  String hintTask1(String who) {
    return 'Mikor jön rá «$who», hogy neki kell hozzáfognia?';
  }

  @override
  String hintTask2(String who) {
    return 'Ki adta a tanácsot, és miért hallgat rá «$who»?';
  }

  @override
  String hintTask3(String who) {
    return 'Mit kell «$who» otthon hagynia?';
  }

  @override
  String get hintTask4 => 'Milyen hosszú az út, és min vezet át?';

  @override
  String hintTask5(String who) {
    return 'Mit fogad meg «$who», mielőtt útnak indul?';
  }

  @override
  String get hintTask6 => 'Miért nem csinálhatja ezt más?';

  @override
  String get hintProblem1 => 'Ekkor hang hallatszik – milyen?';

  @override
  String get hintProblem2 => 'Mi romlik el először?';

  @override
  String hintProblem3(String who) {
    return 'Mit próbál ki «$who» először, és miért nem válik be?';
  }

  @override
  String get hintProblem4 =>
      'Ki tagadja meg a segítséget, pedig tudna segíteni?';

  @override
  String get hintProblem5 => 'Mi történne, ha most mindenki feladná?';

  @override
  String get hintProblem6 => 'Van valami szomorú ebben az akadályban?';

  @override
  String hintProblem7(String who) {
    return 'Mit mond «$who» hangosan abban a pillanatban?';
  }

  @override
  String hintEnding1(String who) {
    return 'Mivel győzi le végül «$who» az akadályt: erővel vagy ötlettel?';
  }

  @override
  String get hintEnding2 => 'Ki segít, pedig nem kellene neki?';

  @override
  String hintEnding3(String who) {
    return 'Mit tesz «$who» legelőször, amikor vége mindennek?';
  }

  @override
  String get hintEnding4 => 'Mi más a végén, mint az elején?';

  @override
  String hintEnding5(String who) {
    return 'Hová tér vissza «$who», és ki várja ott?';
  }

  @override
  String get hintEnding6 =>
      'Mi az utolsó mondat, mielőtt felkapcsolják a villanyt?';

  @override
  String get globeLoading => 'Előkészítem a bolygót…';

  @override
  String get globeLoadFailed => 'A bolygót nem sikerült betölteni.';

  @override
  String get globeTitle => 'Honnan legyen a mese?';

  @override
  String get globeStored => 'Letöltött mesék';

  @override
  String get globeHintFar =>
      'Forgasd a bolygót, vagy koppints egy országra. A zöld országoknak már van meséjük a gyűjteményünkből, a szürkéknek még nincs.';

  @override
  String get globeHintNear =>
      'Koppints egy országra vagy egy épületre. A zöld országoknak már van meséjük a gyűjteményünkből, a szürkéknek még nincs.';

  @override
  String get globeWhole => 'Az egész bolygó';

  @override
  String get globeZoomIn => 'Nagyítás';

  @override
  String get globeZoomOut => 'Kicsinyítés';

  @override
  String globeZoomToRegion(String name) {
    return 'Nagyítás: $name →';
  }

  @override
  String get globeTellHere => 'Meséljünk innen';

  @override
  String globeTellFrom(String place) {
    return 'Mesélj: $place →';
  }

  @override
  String get globeOpenSea => 'Nyílt tenger';

  @override
  String globeRegionCountries(int n) {
    return '$n ország együtt. Nagyíts rá, és válassz egyet.';
  }

  @override
  String get globeTurnToCountry => 'Fordítsd a bolygót egy ország felé.';

  @override
  String get globeSpin => 'Forgatás';

  @override
  String get globeNoTales => 'Innen még nincs mesénk.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motívum',
      one: '$n motívum',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n meséből',
      one: '$n meséből',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs a csomagból';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motívum a csomagból',
      one: '$n motívum a csomagból',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mesét',
      one: '$n mesét',
    );
    return '$_temp0 készítünk elő innen a(z) $region csomagba.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mese',
      one: '$n mese',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mese',
      one: '$n mese',
    );
    return '$_temp0 ingyen';
  }

  @override
  String cardFree(int n) {
    return '$n ingyen';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n a(z) $region $range részekben',
      one: '$n a(z) $region $range részben',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'nálad $n van';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'még $n készül',
      one: 'még $n készül',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Várakozás az áruházra…';

  @override
  String offerDownloading(int percent) {
    return 'Mesék letöltése… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mese',
      one: '$n mese',
    );
    return '$name megvásárlása: $_temp0, $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mese',
      one: '$n mese',
    );
    return '$name letöltése: $_temp0 ingyen ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mese',
      one: '$n mese',
    );
    return '$name letöltése: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name letöltése';
  }

  @override
  String get errDownloadTales => 'A meséket nem sikerült letölteni.';

  @override
  String get errDownloadScenes => 'A képeket nem sikerült letölteni.';

  @override
  String get errNoDownloads => 'Itt nem érhető el a letöltés.';

  @override
  String get errOffline =>
      'Nincs internetkapcsolat – próbáld újra, ha lesz térerő.';

  @override
  String get errCannotBuy => 'Ezt a részt most nem lehet megvásárolni.';

  @override
  String get buyPending =>
      'A vásárlás jóváhagyásra vár. A rész letöltődik, amint átmegy.';

  @override
  String get buyFailed => 'A vásárlás nem sikerült.';

  @override
  String get restoreNone => 'Ezen a fiókon nincs vásárlás.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rész visszaállítva. A bolygóról letöltheted őket.',
      one: '$n rész visszaállítva. A bolygóról letöltheted.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'A vásárlásokat nem sikerült visszaállítani – próbáld újra, ha lesz térerő.';

  @override
  String get narrationGone => 'Ez a mese már nincs összeállítva.';

  @override
  String get narrationNew => 'Új összeállítása';

  @override
  String narrationTitle(int index, int total) {
    return 'Mesélsz – $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Hogyan folytasd: $bridge';
  }

  @override
  String get narrationSituation =>
      'Mi történik éppen? (nem kötelező, diktálhatod)';

  @override
  String get narrationHintNote =>
      'Súgás – ne mondd ki hangosan, csak indulj ki belőle.';

  @override
  String get narrationSoundsNote =>
      'Hangok – akkor indítsd el őket, amikor illenek a meséhez.';

  @override
  String get moodTense => 'feszültség';

  @override
  String get moodCalm => 'nyugalom';

  @override
  String get narrationSearching => 'Keresés…';

  @override
  String get narrationHint => 'Adj súgást';

  @override
  String get narrationMoreHint => 'Még egyet';

  @override
  String get narrationBack => 'Vissza';

  @override
  String get narrationEnd => 'Vége';

  @override
  String get narrationNext => 'Tovább →';

  @override
  String get narrationGoodnight => 'Jó éjszakát.';

  @override
  String get narrationEndNote =>
      'Záróképet és a Könyvtárba mentést még nem tudunk – ez a mese sehová sem megy, köztetek marad.';

  @override
  String get narrationClose => 'Bezárás';

  @override
  String get ragFallback =>
      'A csomagban ehhez még nincs semmi – egy általános súgás:';

  @override
  String get ragNoModel => 'A súgásmodell nincs benne ebben a verzióban.';

  @override
  String get ragHintGeneral => 'általános';

  @override
  String get ragHintMotif => 'a motívumhoz';

  @override
  String get captionExact => 'illusztráció · ehhez a motívumhoz';

  @override
  String get captionSimilar => 'illusztráció · hasonló jelenet';

  @override
  String get captionCard =>
      'motívumkártya · ehhez a lépéshez még nincs jelenetünk';

  @override
  String get storageTitle => 'Letöltött mesék';

  @override
  String get storageEmpty =>
      'Még semmi – további mesék a bolygóról tölthetők le.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n csomag',
      one: '$n csomag',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name jelenetei';
  }

  @override
  String get storageFreeTier => 'ingyenes';

  @override
  String get storageBoughtTier => 'megvásárolva';

  @override
  String get storageDelete => 'Törlés';

  @override
  String get storageScenesSub => 'Egy kép a mesélés minden lépéséhez';

  @override
  String get storageDownload => 'Letöltés';

  @override
  String get storageAllUsed => 'Mindent használtak az elmúlt 30 napban.';

  @override
  String storageFreed(String size) {
    return '$size felszabadítva.';
  }

  @override
  String get storageFreeUp => 'Hely felszabadítása (30 napja nem használt)';

  @override
  String get storageRestoring => 'Vásárlások visszaállítása…';

  @override
  String get storageRestore => 'Vásárlások visszaállítása';

  @override
  String get osnovaTitle => 'Vázlat';

  @override
  String get osnovaSummary => 'A mese dióhéjban';

  @override
  String get osnovaCharacters => 'Szereplők';

  @override
  String get osnovaTask => 'Feladat';

  @override
  String get osnovaProblem => 'Probléma';

  @override
  String get osnovaEnding => 'Befejezés';

  @override
  String get osnovaAgain => 'Elölről';

  @override
  String get osnovaTell => 'Mesélek →';

  @override
  String get outlineHero => 'A hős';

  @override
  String get castFox => 'A ravasz róka';

  @override
  String get castSmithSon => 'A kovács fia';

  @override
  String get castMill => 'A beszélő malom';

  @override
  String get castGooseGirl => 'A libapásztorlány';

  @override
  String get castBrothers => 'A három testvér';

  @override
  String get castClockworkPrincess => 'Az órásmester hercegnője';

  @override
  String get castOwl => 'A bölcs bagoly';

  @override
  String get castBlacksmith => 'Az öreg kovácsasszony';

  @override
  String get castDragon => 'A kis sárkány';

  @override
  String get castWaterSprite => 'A vízi manó';

  @override
  String get castFourPrincesses => 'A négy hercegnő';

  @override
  String get castTravelingTailor => 'A vándor szabó';

  @override
  String get castTalkingCat => 'A beszélő macska';

  @override
  String get castForestHermit => 'Az erdei remete';

  @override
  String get castC0AndersenTheShadow => 'Az úr, aki egykor árnyék volt';

  @override
  String get castC1GrimmTheGooseGirl => 'Az árulkodó komorna';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'A király a kísértetkastéllyal';

  @override
  String get castC3AndersenTheShadow => 'A ravasz árnyék';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'A szép, de nem túl eszes hercegnő';

  @override
  String get castC5AndersenTheRedShoes => 'Az angyal, aki a végén megbocsát';

  @override
  String get castC6GrimmRumpelstiltskin => 'A molnár okos lánya';

  @override
  String get castC7PerraultLittleRedRidingHood => 'A nagymama, aki ajtót nyit';

  @override
  String get castC8PerraultLittleThumb =>
      'Egy anya a nyomor és a szeretet között';

  @override
  String get castC9PerraultIntroduction => 'A türelmes asszony';

  @override
  String get castC10AndersenTheRealPrincess => 'A király, aki támogatja a fiát';

  @override
  String get castC11GrimmLilyAndTheLion => 'A lány, aki állja a szavát';

  @override
  String get castC12AndersenTheRealPrincess =>
      'A herceg, aki az igazi hercegnőt keresi';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'A kis gyufaárus lány';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Az udvaronc, aki hallgat';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'A hű szolga lakomát készít';

  @override
  String get castC16PerraultTheFairy => 'A hiú lány';

  @override
  String get castC17GrimmFirstStory => 'Az özvegy, aki kilenc farkat akar';

  @override
  String get motifTaskWine => 'Ki issza meg egy pince borát';

  @override
  String get motifTaskDiamonds => 'Repülés gyémántokért';

  @override
  String get motifTaskRingDuck => 'A gyűrű a kacsában';

  @override
  String get motifTaskGiants => 'Az óriások túljárása';

  @override
  String get motifTaskTomThumb => 'Hüvelyk Matyi szökése';

  @override
  String get motifTaskSwineherd => 'A hercegnő szívének elnyerése';

  @override
  String get motifTaskBell => 'A titokzatos harang az erdőben';

  @override
  String get motifTaskGoldenObject => 'Ajándék, amellyel nem szabad visszaélni';

  @override
  String get motifTaskPebbles => 'Kavicsokból álló ösvény';

  @override
  String get motifProblemFoxPride => 'A róka büszkesége';

  @override
  String get motifProblemLazySister => 'A lusta testvér';

  @override
  String get motifProblemWitchBoots => 'A boszorkány a hétmérföldes csizmában';

  @override
  String get motifProblemTailorDoubt => 'Senki sem hisz neki';

  @override
  String get motifProblemLions => 'Éhes oroszlánok a kapunál';

  @override
  String get motifProblemEagle => 'A sas és a törpe';

  @override
  String get motifProblemTruth => 'A varázsállat elárulja az igazat';

  @override
  String get motifProblemOldHouse => 'Senki sem akarja a régi házat';

  @override
  String get motifProblemBreadcrumbs => 'A madarak megették a morzsákat';

  @override
  String get motifEndingTrickWins => 'Az ész győz';

  @override
  String get motifEndingTruthChild => 'A gyerek igazat mond';

  @override
  String get motifEndingNewHome => 'Új otthon, régi barátok';

  @override
  String get motifEndingHappyTogether => 'Boldogan együtt örökre';

  @override
  String get motifEndingKissWakes => 'Egy csók felébreszti a királyságot';

  @override
  String get motifEndingLeapfrog => 'Az ész ugrik a legmagasabbra';

  @override
  String get motifEndingCurseBroken => 'Megtört az átok';

  @override
  String get motifEndingWelcomedHome => 'Otthon üdvözlik';

  @override
  String get motifEndingSlipper => 'Az elveszett cipellő';
}
