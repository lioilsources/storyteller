// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Danish (`da`).
class AppLocalizationsDa extends AppLocalizations {
  AppLocalizationsDa([String locale = 'da']) : super(locale);

  @override
  String get castTitle => 'Hvem skal være med i eventyret?';

  @override
  String get castHint =>
      'Tryk på et kort for at få en anden figur. Fjern kortet med krydset. Musik og lyde er altid klar fra landets pakke – kun figurens billede bliver nogle gange tegnet lidt senere.';

  @override
  String get castAdd => 'Tilføj en figur';

  @override
  String get castCount => 'Rollebesætning:';

  @override
  String get castShuffleAll => 'Bland alle';

  @override
  String get castContinue => 'Fortsæt →';

  @override
  String get shuffle => 'Bland';

  @override
  String get motifTaskTitle => 'Hvilken opgave?';

  @override
  String get motifProblemTitle => 'Hvilket problem?';

  @override
  String get motifEndingTitle => 'Hvilken slutning?';

  @override
  String get motifTaskCaption => 'Tryk på et kort for at vælge heltens opgave.';

  @override
  String get motifProblemCaption =>
      'Tryk på et kort for at vælge en forhindring eller en skurk.';

  @override
  String get motifEndingCaption =>
      'Tryk på et kort for at vælge en lykkelig slutning.';

  @override
  String get beatCastTitle => 'Hvem er med';

  @override
  String get beatTaskTitle => 'Hvad helten har sat sig for';

  @override
  String get beatProblemTitle => 'Hvad der kom i vejen';

  @override
  String get beatEndingTitle => 'Hvordan det gik';

  @override
  String get beatCastCaption =>
      'Præsenter figurerne. Hvor de er, hvordan de ser ud, hvad der er særligt ved dem.';

  @override
  String get beatTaskCaption =>
      'Fortæl, hvad helten vil, og hvorfor helten tog af sted.';

  @override
  String get beatProblemCaption =>
      'Sæt noget i vejen for helten. Lad det et øjeblik se ud, som om det ikke kan lade sig gøre.';

  @override
  String get beatEndingCaption =>
      'Før det til ende. Skynd dig ikke – slutningen husker et barn bedst.';

  @override
  String get hintHero => 'helten';

  @override
  String hintCast1(String who) {
    return 'Hvordan ser »$who« ud, når den først dukker op?';
  }

  @override
  String hintCast2(String who) {
    return 'Hvad laver »$who« lige før hele historien begynder?';
  }

  @override
  String hintCast3(String who) {
    return 'Hvad er »$who« bange for?';
  }

  @override
  String hintCast4(String who) {
    return 'Hvordan kan man se, at »$who« er på vej?';
  }

  @override
  String get hintCast5 => 'Hvem af dem har kendt hinanden længe, og hvorfra?';

  @override
  String get hintCast6 => 'Hvordan er vejret, når de mødes?';

  @override
  String hintCast7(String who) {
    return 'Hvad har »$who« i lommen?';
  }

  @override
  String hintTask1(String who) {
    return 'Hvornår forstår »$who«, at det er nu, det skal begynde?';
  }

  @override
  String hintTask2(String who) {
    return 'Hvem gav rådet, og hvorfor lytter »$who«?';
  }

  @override
  String hintTask3(String who) {
    return 'Hvad må »$who« lade blive hjemme?';
  }

  @override
  String get hintTask4 => 'Hvor lang er vejen, og hvad går den over?';

  @override
  String hintTask5(String who) {
    return 'Hvad lover »$who« sig selv, før turen begynder?';
  }

  @override
  String get hintTask6 => 'Hvorfor kan ingen anden gøre det?';

  @override
  String get hintProblem1 => 'I det øjeblik lyder en lyd – hvilken?';

  @override
  String get hintProblem2 => 'Hvad går galt først?';

  @override
  String hintProblem3(String who) {
    return 'Hvad prøver »$who« først, og hvorfor virker det ikke?';
  }

  @override
  String get hintProblem4 =>
      'Hvem nægter at hjælpe, selv om vedkommende kunne?';

  @override
  String get hintProblem5 => 'Hvad ville der ske, hvis alle gav op lige nu?';

  @override
  String get hintProblem6 => 'Er der noget trist ved forhindringen?';

  @override
  String hintProblem7(String who) {
    return 'Hvad siger »$who« højt i det øjeblik?';
  }

  @override
  String hintEnding1(String who) {
    return 'Hvordan overvinder »$who« det til sidst – med kræfter eller med en idé?';
  }

  @override
  String get hintEnding2 => 'Hvem hjælper, selv om vedkommende ikke behøvede?';

  @override
  String hintEnding3(String who) {
    return 'Hvad gør »$who« allerførst, når det hele er forbi?';
  }

  @override
  String get hintEnding4 => 'Hvad er anderledes til sidst end i begyndelsen?';

  @override
  String hintEnding5(String who) {
    return 'Hvor vender »$who« tilbage til, og hvem venter dér?';
  }

  @override
  String get hintEnding6 => 'Hvad er den sidste sætning, før lyset tændes?';

  @override
  String get globeLoading => 'Gør planeten klar…';

  @override
  String get globeLoadFailed => 'Planeten kunne ikke indlæses.';

  @override
  String get globeTitle => 'Hvor skal eventyret komme fra?';

  @override
  String get globeStored => 'Hentede eventyr';

  @override
  String get globeHintFar =>
      'Drej planeten, eller tryk på et land. Grønne lande har allerede eventyr fra vores samling, grå har ikke endnu.';

  @override
  String get globeHintNear =>
      'Tryk på et land eller en bygning. Grønne lande har allerede eventyr fra vores samling, grå har ikke endnu.';

  @override
  String get globeWhole => 'Hele planeten';

  @override
  String get globeZoomIn => 'Zoom ind';

  @override
  String get globeZoomOut => 'Zoom ud';

  @override
  String globeZoomToRegion(String name) {
    return 'Zoom ind på $name →';
  }

  @override
  String get globeTellHere => 'Fortæl et eventyr herfra';

  @override
  String globeTellFrom(String place) {
    return 'Fortæl et eventyr fra $place →';
  }

  @override
  String get globeOpenSea => 'Åbent hav';

  @override
  String globeRegionCountries(int n) {
    return '$n lande samlet. Zoom ind og vælg ét.';
  }

  @override
  String get globeTurnToCountry => 'Drej planeten hen på et land.';

  @override
  String get globeSpin => 'Drej';

  @override
  String get globeNoTales => 'Vi har endnu ingen eventyr herfra.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiver',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'fra $n eventyr',
      one: 'fra $n eventyr',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs fra pakken';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiver fra pakken',
      one: '$n motiv fra pakken',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Vi gør $_temp0 herfra klar til pakken $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return '$_temp0 gratis';
  }

  @override
  String cardFree(int n) {
    return '$n gratis';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n i delene $region $range',
      one: '$n i delen $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'du har $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n flere på vej',
      one: '$n mere på vej',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Venter på butikken…';

  @override
  String offerDownloading(int percent) {
    return 'Henter eventyr… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Køb $name: $_temp0 for $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Hent $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Hent $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Hent $name';
  }

  @override
  String get errDownloadTales => 'Eventyrene kunne ikke hentes.';

  @override
  String get errDownloadScenes => 'Billederne kunne ikke hentes.';

  @override
  String get errNoDownloads => 'Her kan der ikke hentes noget.';

  @override
  String get errOffline =>
      'Ingen internetforbindelse – prøv igen, når du har signal.';

  @override
  String get errCannotBuy => 'Den del kan ikke købes lige nu.';

  @override
  String get buyPending =>
      'Købet afventer godkendelse. Delen hentes, når det er gået igennem.';

  @override
  String get buyFailed => 'Købet gik ikke igennem.';

  @override
  String get restoreNone => 'Der er ingen køb på denne konto.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dele gendannet. Du kan hente dem fra planeten.',
      one: '$n del gendannet. Du kan hente den fra planeten.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Køb kunne ikke gendannes – prøv igen, når du har signal.';

  @override
  String get narrationGone => 'Dette eventyr er ikke sat sammen længere.';

  @override
  String get narrationNew => 'Sæt et nyt sammen';

  @override
  String narrationTitle(int index, int total) {
    return 'Du fortæller – $index af $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Sådan fortsætter du: $bridge';
  }

  @override
  String get narrationSituation =>
      'Hvad sker der lige nu? (valgfrit, kan dikteres)';

  @override
  String get narrationHintNote =>
      'Hint – sig det ikke højt, brug det bare som afsæt.';

  @override
  String get narrationSoundsNote =>
      'Lyde – afspil dem, når de passer til fortællingen.';

  @override
  String get moodTense => 'spænding';

  @override
  String get moodCalm => 'ro';

  @override
  String get narrationSearching => 'Søger…';

  @override
  String get narrationHint => 'Giv et hint';

  @override
  String get narrationMoreHint => 'Et mere';

  @override
  String get narrationBack => 'Tilbage';

  @override
  String get narrationEnd => 'Slut';

  @override
  String get narrationNext => 'Videre →';

  @override
  String get narrationGoodnight => 'Godnat.';

  @override
  String get narrationEndNote =>
      'Vi kan endnu ikke lave et afsluttende billede eller gemme i Biblioteket – eventyret går ingen steder, det bliver mellem jer.';

  @override
  String get narrationClose => 'Luk';

  @override
  String get ragFallback =>
      'Pakken har endnu ikke noget til dette – et generelt hint:';

  @override
  String get ragNoModel => 'Hintmodellen er ikke med i denne version.';

  @override
  String get ragHintGeneral => 'generelt';

  @override
  String get ragHintMotif => 'til motivet';

  @override
  String get captionExact => 'illustration · til dette motiv';

  @override
  String get captionSimilar => 'illustration · lignende scene';

  @override
  String get captionCard =>
      'motivkort · vi har endnu ingen scene til dette trin';

  @override
  String get storageTitle => 'Hentede eventyr';

  @override
  String get storageEmpty => 'Intet endnu – flere eventyr hentes fra planeten.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pakker',
      one: '$n pakke',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scener: $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'købt';

  @override
  String get storageDelete => 'Slet';

  @override
  String get storageScenesSub => 'Et billede til hvert trin i fortællingen';

  @override
  String get storageDownload => 'Hent';

  @override
  String get storageAllUsed =>
      'Alt er blevet brugt inden for de sidste 30 dage.';

  @override
  String storageFreed(String size) {
    return '$size frigjort.';
  }

  @override
  String get storageFreeUp => 'Frigør plads (ikke brugt i 30 dage)';

  @override
  String get storageRestoring => 'Gendanner køb…';

  @override
  String get storageRestore => 'Gendan køb';

  @override
  String get osnovaTitle => 'Disposition';

  @override
  String get osnovaSummary => 'Eventyret i kort form';

  @override
  String get osnovaCharacters => 'Figurer';

  @override
  String get osnovaTask => 'Opgave';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Slutning';

  @override
  String get osnovaAgain => 'Forfra';

  @override
  String get osnovaTell => 'Jeg fortæller →';

  @override
  String get outlineHero => 'Helten';

  @override
  String get castFox => 'Den kloge ræv';

  @override
  String get castSmithSon => 'Smedens søn';

  @override
  String get castMill => 'Den talende mølle';

  @override
  String get castGooseGirl => 'Gåsepigen';

  @override
  String get castBrothers => 'De tre brødre';

  @override
  String get castClockworkPrincess => 'Urmagerprinsessen';

  @override
  String get castOwl => 'Den kloge ugle';

  @override
  String get castBlacksmith => 'Den gamle smedekone';

  @override
  String get castDragon => 'Den lille drage';

  @override
  String get castWaterSprite => 'Vandånden';

  @override
  String get castFourPrincesses => 'De fire prinsesser';

  @override
  String get castTravelingTailor => 'Den vandrende skrædder';

  @override
  String get castTalkingCat => 'Den talende kat';

  @override
  String get castForestHermit => 'Skovens eneboer';

  @override
  String get castC0AndersenTheShadow => 'Herren, der engang var en skygge';

  @override
  String get castC1GrimmTheGooseGirl => 'Den forrædderiske kammerpige';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kongen med det hjemsøgte slot';

  @override
  String get castC3AndersenTheShadow => 'Den kloge skygge';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Den smukke, men ikke så kloge prinsesse';

  @override
  String get castC5AndersenTheRedShoes => 'Englen, der tilgiver til sidst';

  @override
  String get castC6GrimmRumpelstiltskin => 'Møllerens kloge datter';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'Bedstemoderen, der åbner døren';

  @override
  String get castC8PerraultLittleThumb => 'En mor mellem nød og kærlighed';

  @override
  String get castC9PerraultIntroduction => 'Den tålmodige kvinde';

  @override
  String get castC10AndersenTheRealPrincess => 'Kongen, der bakker sin søn op';

  @override
  String get castC11GrimmLilyAndTheLion => 'Datteren, der holder sit ord';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Prinsen, der leder efter den rigtige prinsesse';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'Den lille pige med svovlstikkerne';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Hofmanden, der tier';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Den trofaste tjener, der laver gæstebud';

  @override
  String get castC16PerraultTheFairy => 'Den indbildske datter';

  @override
  String get castC17GrimmFirstStory => 'Enken, der vil have ni haler';

  @override
  String get motifTaskWine => 'Hvem drikker en hel kælder vin';

  @override
  String get motifTaskDiamonds => 'En flyvetur efter diamanter';

  @override
  String get motifTaskRingDuck => 'Ringen i anden';

  @override
  String get motifTaskGiants => 'At narre kæmperne';

  @override
  String get motifTaskTomThumb => 'Tommelidts flugt';

  @override
  String get motifTaskSwineherd => 'At vinde prinsessens hjerte';

  @override
  String get motifTaskBell => 'Den mystiske klokke i skoven';

  @override
  String get motifTaskGoldenObject => 'En gave, der ikke må misbruges';

  @override
  String get motifTaskPebbles => 'En sti af småsten';

  @override
  String get motifProblemFoxPride => 'Rævens stolthed';

  @override
  String get motifProblemLazySister => 'Den dovne søster';

  @override
  String get motifProblemWitchBoots => 'Heksen i syvmilestøvler';

  @override
  String get motifProblemTailorDoubt => 'Ingen tror på ham';

  @override
  String get motifProblemLions => 'Sultne løver ved porten';

  @override
  String get motifProblemEagle => 'Ørnen og dværgen';

  @override
  String get motifProblemTruth => 'Det magiske dyr afslører sandheden';

  @override
  String get motifProblemOldHouse => 'Ingen vil have det gamle hus';

  @override
  String get motifProblemBreadcrumbs => 'Fuglene spiste krummerne';

  @override
  String get motifEndingTrickWins => 'Snilde sejrer';

  @override
  String get motifEndingTruthChild => 'Barnet siger sandheden';

  @override
  String get motifEndingNewHome => 'Et nyt hjem, gamle venner';

  @override
  String get motifEndingHappyTogether => 'Lykkelige sammen for evigt';

  @override
  String get motifEndingKissWakes => 'Et kys vækker kongeriget';

  @override
  String get motifEndingLeapfrog => 'Snilde springer højest';

  @override
  String get motifEndingCurseBroken => 'Forbandelsen er brudt';

  @override
  String get motifEndingWelcomedHome => 'Budt velkommen hjem';

  @override
  String get motifEndingSlipper => 'Den tabte sko';
}
