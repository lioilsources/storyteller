// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Dutch Flemish (`nl`).
class AppLocalizationsNl extends AppLocalizations {
  AppLocalizationsNl([String locale = 'nl']) : super(locale);

  @override
  String get castTitle => 'Wie zitten er in het sprookje?';

  @override
  String get castHint =>
      'Tik op een kaart voor een ander personage. Verwijder een kaart met het kruisje. Muziek en geluiden zijn altijd klaar uit het landenpakket – alleen het plaatje van het personage wordt soms iets later getekend.';

  @override
  String get castAdd => 'Personage toevoegen';

  @override
  String get castCount => 'Rolbezetting:';

  @override
  String get castShuffleAll => 'Alles schudden';

  @override
  String get castContinue => 'Verder →';

  @override
  String get shuffle => 'Schudden';

  @override
  String get motifTaskTitle => 'Welke opdracht?';

  @override
  String get motifProblemTitle => 'Welk probleem?';

  @override
  String get motifEndingTitle => 'Welk einde?';

  @override
  String get motifTaskCaption =>
      'Tik op een kaart om de opdracht van de held te kiezen.';

  @override
  String get motifProblemCaption =>
      'Tik op een kaart om een obstakel of een schurk te kiezen.';

  @override
  String get motifEndingCaption =>
      'Tik op een kaart om een gelukkig einde te kiezen.';

  @override
  String get beatCastTitle => 'Wie er in zitten';

  @override
  String get beatTaskTitle => 'Wat de held zich voorgenomen heeft';

  @override
  String get beatProblemTitle => 'Wat er in de weg kwam';

  @override
  String get beatEndingTitle => 'Hoe het afliep';

  @override
  String get beatCastCaption =>
      'Stel de personages voor. Waar ze zijn, hoe ze eruitzien, wat er bijzonder aan hen is.';

  @override
  String get beatTaskCaption =>
      'Vertel wat de held wil en waarom hij is vertrokken.';

  @override
  String get beatProblemCaption =>
      'Zet iets in de weg van de held. Laat het even lijken alsof het niet gaat lukken.';

  @override
  String get beatEndingCaption =>
      'Breng het tot een einde. Geen haast – het einde onthoudt een kind het best.';

  @override
  String get hintHero => 'de held';

  @override
  String hintCast1(String who) {
    return 'Hoe ziet «$who» eruit wanneer het voor het eerst opduikt?';
  }

  @override
  String hintCast2(String who) {
    return 'Wat is «$who» aan het doen vlak voordat het hele verhaal begint?';
  }

  @override
  String hintCast3(String who) {
    return 'Waar is «$who» bang voor?';
  }

  @override
  String hintCast4(String who) {
    return 'Waaraan herken je dat «$who» eraan komt?';
  }

  @override
  String get hintCast5 => 'Wie van hen kennen elkaar al lang, en van waar?';

  @override
  String get hintCast6 => 'Wat voor weer is het als ze elkaar ontmoeten?';

  @override
  String hintCast7(String who) {
    return 'Wat heeft «$who» in de zak?';
  }

  @override
  String hintTask1(String who) {
    return 'Wanneer begrijpt «$who» dat het nu moet beginnen?';
  }

  @override
  String hintTask2(String who) {
    return 'Wie gaf het advies, en waarom luistert «$who» ernaar?';
  }

  @override
  String hintTask3(String who) {
    return 'Wat moet «$who» thuis laten?';
  }

  @override
  String get hintTask4 => 'Hoe lang is de weg, en waarover loopt hij?';

  @override
  String hintTask5(String who) {
    return 'Wat belooft «$who» zichzelf voor het vertrek?';
  }

  @override
  String get hintTask6 => 'Waarom kan niemand anders het doen?';

  @override
  String get hintProblem1 => 'Op dat moment klinkt er een geluid – welk?';

  @override
  String get hintProblem2 => 'Wat gaat er als eerste mis?';

  @override
  String hintProblem3(String who) {
    return 'Wat probeert «$who» als eerste, en waarom lukt dat niet?';
  }

  @override
  String get hintProblem4 =>
      'Wie weigert te helpen, terwijl hij het zou kunnen?';

  @override
  String get hintProblem5 => 'Wat zou er gebeuren als iedereen nu opgaf?';

  @override
  String get hintProblem6 => 'Is er iets treurigs aan dat obstakel?';

  @override
  String hintProblem7(String who) {
    return 'Wat zegt «$who» op dat moment hardop?';
  }

  @override
  String hintEnding1(String who) {
    return 'Waarmee overwint «$who» het uiteindelijk – met kracht of met een idee?';
  }

  @override
  String get hintEnding2 => 'Wie helpt, terwijl dat niet hoefde?';

  @override
  String hintEnding3(String who) {
    return 'Wat doet «$who» als allereerste als alles voorbij is?';
  }

  @override
  String get hintEnding4 => 'Wat is er aan het einde anders dan aan het begin?';

  @override
  String hintEnding5(String who) {
    return 'Waar keert «$who» naar terug, en wie wacht daar?';
  }

  @override
  String get hintEnding6 => 'Wat is de laatste zin voordat het licht aangaat?';

  @override
  String get globeLoading => 'De planeet wordt klaargemaakt…';

  @override
  String get globeLoadFailed => 'De planeet kon niet worden geladen.';

  @override
  String get globeTitle => 'Waar komt het sprookje vandaan?';

  @override
  String get globeStored => 'Gedownloade sprookjes';

  @override
  String get globeHintFar =>
      'Draai de planeet of tik op een land. Groene landen hebben al sprookjes uit onze verzameling, grijze nog niet.';

  @override
  String get globeHintNear =>
      'Tik op een land of een gebouw. Groene landen hebben al sprookjes uit onze verzameling, grijze nog niet.';

  @override
  String get globeWhole => 'Hele planeet';

  @override
  String get globeZoomIn => 'Inzoomen';

  @override
  String get globeZoomOut => 'Uitzoomen';

  @override
  String globeZoomToRegion(String name) {
    return 'Inzoomen op $name →';
  }

  @override
  String get globeTellHere => 'Vertel een sprookje van hier';

  @override
  String globeTellFrom(String place) {
    return 'Vertel een sprookje uit $place →';
  }

  @override
  String get globeOpenSea => 'Open zee';

  @override
  String globeRegionCountries(int n) {
    return '$n landen samen. Zoom in en kies er één.';
  }

  @override
  String get globeTurnToCountry => 'Draai de planeet naar een land.';

  @override
  String get globeSpin => 'Draaien';

  @override
  String get globeNoTales => 'Van hier hebben we nog geen sprookjes.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motieven',
      one: '$n motief',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'uit $n sprookjes',
      one: 'uit $n sprookje',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs uit het pakket';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motieven uit het pakket',
      one: '$n motief uit het pakket',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
    );
    return 'We maken $_temp0 van hier klaar voor het pakket $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
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
      other: '$n in delen $region $range',
      one: '$n in deel $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'je hebt er $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'nog $n onderweg',
      one: 'nog $n onderweg',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Wachten op de winkel…';

  @override
  String offerDownloading(int percent) {
    return 'Sprookjes downloaden… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
    );
    return '$name kopen: $_temp0 voor $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
    );
    return '$name downloaden: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sprookjes',
      one: '$n sprookje',
    );
    return '$name downloaden: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name downloaden';
  }

  @override
  String get errDownloadTales => 'De sprookjes konden niet worden gedownload.';

  @override
  String get errDownloadScenes =>
      'De afbeeldingen konden niet worden gedownload.';

  @override
  String get errNoDownloads => 'Downloaden is hier niet beschikbaar.';

  @override
  String get errOffline =>
      'Geen internetverbinding – probeer het opnieuw als je bereik hebt.';

  @override
  String get errCannotBuy => 'Dit deel kan nu niet worden gekocht.';

  @override
  String get buyPending =>
      'De aankoop wacht op goedkeuring. Het deel wordt gedownload zodra die er is.';

  @override
  String get buyFailed => 'De aankoop is niet gelukt.';

  @override
  String get restoreNone => 'Er zijn geen aankopen op dit account.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n delen hersteld. Je kunt ze downloaden vanaf de planeet.',
      one: '$n deel hersteld. Je kunt het downloaden vanaf de planeet.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'De aankopen konden niet worden hersteld – probeer het opnieuw als je bereik hebt.';

  @override
  String get narrationGone => 'Dit sprookje is niet meer samengesteld.';

  @override
  String get narrationNew => 'Stel een nieuw samen';

  @override
  String narrationTitle(int index, int total) {
    return 'Jij vertelt – $index van $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Zo ga je verder: $bridge';
  }

  @override
  String get narrationSituation =>
      'Wat gebeurt er nu? (optioneel, je kunt dicteren)';

  @override
  String get narrationHintNote =>
      'Hint – zeg het niet hardop, gebruik het alleen als uitgangspunt.';

  @override
  String get narrationSoundsNote =>
      'Geluiden – speel ze af wanneer ze bij het verhaal passen.';

  @override
  String get moodTense => 'spanning';

  @override
  String get moodCalm => 'rust';

  @override
  String get narrationSearching => 'Zoeken…';

  @override
  String get narrationHint => 'Geef een hint';

  @override
  String get narrationMoreHint => 'Nog een';

  @override
  String get narrationBack => 'Terug';

  @override
  String get narrationEnd => 'Einde';

  @override
  String get narrationNext => 'Verder →';

  @override
  String get narrationGoodnight => 'Welterusten.';

  @override
  String get narrationEndNote =>
      'Een afsluitend plaatje en opslaan in de Bibliotheek kunnen we nog niet – dit sprookje gaat nergens heen, het blijft tussen jullie.';

  @override
  String get narrationClose => 'Sluiten';

  @override
  String get ragFallback =>
      'Uit het pakket is er hier nog niets voor – een algemene hint:';

  @override
  String get ragNoModel => 'Het hintmodel zit niet in deze versie.';

  @override
  String get ragHintGeneral => 'algemeen';

  @override
  String get ragHintMotif => 'bij het motief';

  @override
  String get captionExact => 'illustratie · bij dit motief';

  @override
  String get captionSimilar => 'illustratie · vergelijkbare scène';

  @override
  String get captionCard =>
      'motiefkaart · voor deze stap hebben we nog geen scène';

  @override
  String get storageTitle => 'Gedownloade sprookjes';

  @override
  String get storageEmpty =>
      'Nog niets – meer sprookjes worden van de planeet gedownload.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pakketten',
      one: '$n pakket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scènes $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'gekocht';

  @override
  String get storageDelete => 'Verwijderen';

  @override
  String get storageScenesSub => 'Een plaatje bij elke stap van het vertellen';

  @override
  String get storageDownload => 'Downloaden';

  @override
  String get storageAllUsed => 'Alles is de afgelopen 30 dagen gebruikt.';

  @override
  String storageFreed(String size) {
    return '$size vrijgemaakt.';
  }

  @override
  String get storageFreeUp => 'Ruimte vrijmaken (30 dagen ongebruikt)';

  @override
  String get storageRestoring => 'Aankopen herstellen…';

  @override
  String get storageRestore => 'Aankopen herstellen';

  @override
  String get osnovaTitle => 'Opzet';

  @override
  String get osnovaSummary => 'Het sprookje in het kort';

  @override
  String get osnovaCharacters => 'Personages';

  @override
  String get osnovaTask => 'Opdracht';

  @override
  String get osnovaProblem => 'Probleem';

  @override
  String get osnovaEnding => 'Einde';

  @override
  String get osnovaAgain => 'Opnieuw';

  @override
  String get osnovaTell => 'Ik vertel →';

  @override
  String get outlineHero => 'De held';

  @override
  String get castFox => 'De slimme vos';

  @override
  String get castSmithSon => 'De zoon van de smid';

  @override
  String get castMill => 'De pratende molen';

  @override
  String get castGooseGirl => 'Het ganzenmeisje';

  @override
  String get castBrothers => 'De drie broers';

  @override
  String get castClockworkPrincess => 'De uurwerkmakersprinses';

  @override
  String get castOwl => 'De wijze uil';

  @override
  String get castBlacksmith => 'De oude smidsvrouw';

  @override
  String get castDragon => 'De kleine draak';

  @override
  String get castWaterSprite => 'De waterman';

  @override
  String get castFourPrincesses => 'De vier prinsessen';

  @override
  String get castTravelingTailor => 'De rondtrekkende kleermaker';

  @override
  String get castTalkingCat => 'De pratende kat';

  @override
  String get castForestHermit => 'De kluizenaar in het bos';

  @override
  String get castC0AndersenTheShadow => 'De heer die ooit een schaduw was';

  @override
  String get castC1GrimmTheGooseGirl => 'De verraderlijke kamermeid';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'De koning met het spookkasteel';

  @override
  String get castC3AndersenTheShadow => 'De slimme schaduw';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'De mooie, maar niet zo slimme prinses';

  @override
  String get castC5AndersenTheRedShoes => 'De engel die uiteindelijk vergeeft';

  @override
  String get castC6GrimmRumpelstiltskin => 'De slimme dochter van de molenaar';

  @override
  String get castC7PerraultLittleRedRidingHood => 'De oma die de deur opendoet';

  @override
  String get castC8PerraultLittleThumb => 'Een moeder tussen ellende en liefde';

  @override
  String get castC9PerraultIntroduction => 'De geduldige vrouw';

  @override
  String get castC10AndersenTheRealPrincess => 'De koning die zijn zoon steunt';

  @override
  String get castC11GrimmLilyAndTheLion => 'De dochter die woord houdt';

  @override
  String get castC12AndersenTheRealPrincess =>
      'De prins die de echte prinses zoekt';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'Het meisje met de zwavelstokjes';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'De hoveling die zwijgt';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'De trouwe knecht maakt een feestmaal klaar';

  @override
  String get castC16PerraultTheFairy => 'De verwaande dochter';

  @override
  String get castC17GrimmFirstStory => 'De weduwe die negen staarten wil';

  @override
  String get motifTaskWine => 'Wie drinkt een kelder vol wijn';

  @override
  String get motifTaskDiamonds => 'Een vlucht naar diamanten';

  @override
  String get motifTaskRingDuck => 'De ring in de eend';

  @override
  String get motifTaskGiants => 'De reuzen te slim af zijn';

  @override
  String get motifTaskTomThumb => 'De vlucht van Duimpje';

  @override
  String get motifTaskSwineherd => 'Het hart van de prinses winnen';

  @override
  String get motifTaskBell => 'De mysterieuze klok in het bos';

  @override
  String get motifTaskGoldenObject =>
      'Een geschenk waarvan je geen misbruik mag maken';

  @override
  String get motifTaskPebbles => 'Een pad van kiezels';

  @override
  String get motifProblemFoxPride => 'De hoogmoed van de vos';

  @override
  String get motifProblemLazySister => 'De luie zus';

  @override
  String get motifProblemWitchBoots => 'De heks met zevenmijlslaarzen';

  @override
  String get motifProblemTailorDoubt => 'Niemand gelooft hem';

  @override
  String get motifProblemLions => 'Hongerige leeuwen bij de poort';

  @override
  String get motifProblemEagle => 'De adelaar en de dwerg';

  @override
  String get motifProblemTruth => 'Het toverdier onthult de waarheid';

  @override
  String get motifProblemOldHouse => 'Niemand wil het oude huis';

  @override
  String get motifProblemBreadcrumbs => 'De vogels aten de kruimels op';

  @override
  String get motifEndingTrickWins => 'Slimheid wint';

  @override
  String get motifEndingTruthChild => 'Het kind vertelt de waarheid';

  @override
  String get motifEndingNewHome => 'Een nieuw thuis, oude vrienden';

  @override
  String get motifEndingHappyTogether => 'Samen gelukkig voor altijd';

  @override
  String get motifEndingKissWakes => 'Een kus wekt het koninkrijk';

  @override
  String get motifEndingLeapfrog => 'Slimheid springt het hoogst';

  @override
  String get motifEndingCurseBroken => 'De vloek is verbroken';

  @override
  String get motifEndingWelcomedHome => 'Welkom thuis';

  @override
  String get motifEndingSlipper => 'Het verloren muiltje';
}
