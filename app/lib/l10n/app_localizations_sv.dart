// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Swedish (`sv`).
class AppLocalizationsSv extends AppLocalizations {
  AppLocalizationsSv([String locale = 'sv']) : super(locale);

  @override
  String get castTitle => 'Vilka ska vara med i sagan?';

  @override
  String get castHint =>
      'Tryck på ett kort för att få en annan figur. Ta bort kortet med krysset. Musik och ljud är alltid färdiga från landets paket – bara figurens bild ritas ibland en liten stund senare.';

  @override
  String get castAdd => 'Lägg till figur';

  @override
  String get castCount => 'Rollista:';

  @override
  String get castShuffleAll => 'Blanda alla';

  @override
  String get castContinue => 'Fortsätt →';

  @override
  String get shuffle => 'Blanda';

  @override
  String get motifTaskTitle => 'Vilket uppdrag?';

  @override
  String get motifProblemTitle => 'Vilket problem?';

  @override
  String get motifEndingTitle => 'Vilket slut?';

  @override
  String get motifTaskCaption =>
      'Tryck på ett kort för att välja hjältens uppdrag.';

  @override
  String get motifProblemCaption =>
      'Tryck på ett kort för att välja ett hinder eller en skurk.';

  @override
  String get motifEndingCaption =>
      'Tryck på ett kort för att välja ett lyckligt slut.';

  @override
  String get beatCastTitle => 'Vilka som är med';

  @override
  String get beatTaskTitle => 'Vad hjälten har föresatt sig';

  @override
  String get beatProblemTitle => 'Vad som kom i vägen';

  @override
  String get beatEndingTitle => 'Hur det gick';

  @override
  String get beatCastCaption =>
      'Presentera figurerna. Var de är, hur de ser ut, vad som är speciellt med dem.';

  @override
  String get beatTaskCaption =>
      'Berätta vad hjälten vill och varför hjälten gav sig av.';

  @override
  String get beatProblemCaption =>
      'Ställ något i vägen för hjälten. Låt det en stund se ut som om det inte går.';

  @override
  String get beatEndingCaption =>
      'För det till slut. Ingen brådska – slutet minns ett barn bäst.';

  @override
  String get hintHero => 'hjälten';

  @override
  String hintCast1(String who) {
    return 'Hur ser «$who» ut när den dyker upp första gången?';
  }

  @override
  String hintCast2(String who) {
    return 'Vad gör «$who» precis innan hela historien börjar?';
  }

  @override
  String hintCast3(String who) {
    return 'Vad är «$who» rädd för?';
  }

  @override
  String hintCast4(String who) {
    return 'Hur märker du att «$who» är på väg?';
  }

  @override
  String get hintCast5 => 'Vilka av dem har känt varandra länge, och varifrån?';

  @override
  String get hintCast6 => 'Hur är vädret när de möts?';

  @override
  String hintCast7(String who) {
    return 'Vad har «$who» i fickan?';
  }

  @override
  String hintTask1(String who) {
    return 'När förstår «$who» att det är dags att sätta igång?';
  }

  @override
  String hintTask2(String who) {
    return 'Vem gav rådet, och varför lyssnar «$who»?';
  }

  @override
  String hintTask3(String who) {
    return 'Vad måste «$who» lämna kvar hemma?';
  }

  @override
  String get hintTask4 => 'Hur lång är vägen, och vad går den över?';

  @override
  String hintTask5(String who) {
    return 'Vad lovar «$who» sig själv innan avfärden?';
  }

  @override
  String get hintTask6 => 'Varför kan ingen annan göra det?';

  @override
  String get hintProblem1 => 'I det ögonblicket hörs ett ljud – vilket?';

  @override
  String get hintProblem2 => 'Vad går fel först?';

  @override
  String hintProblem3(String who) {
    return 'Vad försöker «$who» först, och varför funkar det inte?';
  }

  @override
  String get hintProblem4 => 'Vem vägrar hjälpa fast det vore möjligt?';

  @override
  String get hintProblem5 => 'Vad skulle hända om alla gav upp just nu?';

  @override
  String get hintProblem6 => 'Finns det något sorgligt med hindret?';

  @override
  String hintProblem7(String who) {
    return 'Vad säger «$who» högt i det ögonblicket?';
  }

  @override
  String hintEnding1(String who) {
    return 'Hur övervinner «$who» det till slut – med kraft eller med en idé?';
  }

  @override
  String get hintEnding2 => 'Vem hjälper till fast det inte var nödvändigt?';

  @override
  String hintEnding3(String who) {
    return 'Vad gör «$who» allra först när allt är över?';
  }

  @override
  String get hintEnding4 => 'Vad är annorlunda i slutet jämfört med början?';

  @override
  String hintEnding5(String who) {
    return 'Vart återvänder «$who», och vem väntar där?';
  }

  @override
  String get hintEnding6 => 'Vilken är den sista meningen innan ljuset tänds?';

  @override
  String get globeLoading => 'Gör planeten klar…';

  @override
  String get globeLoadFailed => 'Planeten gick inte att ladda.';

  @override
  String get globeTitle => 'Varifrån ska sagan komma?';

  @override
  String get globeStored => 'Nedladdade sagor';

  @override
  String get globeHintFar =>
      'Snurra på planeten eller tryck på ett land. Gröna länder har redan sagor från vår samling, grå har inte det ännu.';

  @override
  String get globeHintNear =>
      'Tryck på ett land eller en byggnad. Gröna länder har redan sagor från vår samling, grå har inte det ännu.';

  @override
  String get globeWhole => 'Hela planeten';

  @override
  String get globeZoomIn => 'Zooma in';

  @override
  String get globeZoomOut => 'Zooma ut';

  @override
  String globeZoomToRegion(String name) {
    return 'Zooma in på $name →';
  }

  @override
  String get globeTellHere => 'Berätta en saga härifrån';

  @override
  String globeTellFrom(String place) {
    return 'Berätta en saga från $place →';
  }

  @override
  String get globeOpenSea => 'Öppet hav';

  @override
  String globeRegionCountries(int n) {
    return '$n länder tillsammans. Zooma in och välj ett.';
  }

  @override
  String get globeTurnToCountry => 'Vrid planeten mot något land.';

  @override
  String get globeSpin => 'Snurra';

  @override
  String get globeNoTales => 'Vi har inga sagor härifrån ännu.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiv',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'från $n sagor',
      one: 'från $n saga',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs från paketet';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiv från paketet',
      one: '$n motiv från paketet',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
    );
    return 'Vi gör $_temp0 härifrån klara för paketet $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
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
      other: '$n i delarna $region $range',
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
      other: '$n till på väg',
      one: '$n till på väg',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Väntar på butiken…';

  @override
  String offerDownloading(int percent) {
    return 'Laddar ner sagor… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
    );
    return 'Köp $name: $_temp0 för $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
    );
    return 'Ladda ner $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sagor',
      one: '$n saga',
    );
    return 'Ladda ner $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Ladda ner $name';
  }

  @override
  String get errDownloadTales => 'Sagorna gick inte att ladda ner.';

  @override
  String get errDownloadScenes => 'Bilderna gick inte att ladda ner.';

  @override
  String get errNoDownloads => 'Nedladdning är inte tillgänglig här.';

  @override
  String get errOffline =>
      'Ingen internetanslutning – försök igen när du har täckning.';

  @override
  String get errCannotBuy => 'Den här delen går inte att köpa just nu.';

  @override
  String get buyPending =>
      'Köpet väntar på godkännande. Delen laddas ner när det har gått igenom.';

  @override
  String get buyFailed => 'Köpet gick inte igenom.';

  @override
  String get restoreNone => 'Det finns inga köp på det här kontot.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n delar återställda. Du kan ladda ner dem från planeten.',
      one: '$n del återställd. Du kan ladda ner den från planeten.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Köpen gick inte att återställa – försök igen när du har täckning.';

  @override
  String get narrationGone => 'Den här sagan är inte hopsatt längre.';

  @override
  String get narrationNew => 'Sätt ihop en ny';

  @override
  String narrationTitle(int index, int total) {
    return 'Du berättar – $index av $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Så fortsätter du: $bridge';
  }

  @override
  String get narrationSituation =>
      'Vad händer just nu? (valfritt, kan dikteras)';

  @override
  String get narrationHintNote =>
      'Tips – säg det inte högt, använd det bara som avstamp.';

  @override
  String get narrationSoundsNote =>
      'Ljud – spela upp dem när de passar berättelsen.';

  @override
  String get moodTense => 'spänning';

  @override
  String get moodCalm => 'lugn';

  @override
  String get narrationSearching => 'Söker…';

  @override
  String get narrationHint => 'Ge ett tips';

  @override
  String get narrationMoreHint => 'Ett till';

  @override
  String get narrationBack => 'Tillbaka';

  @override
  String get narrationEnd => 'Slut';

  @override
  String get narrationNext => 'Vidare →';

  @override
  String get narrationGoodnight => 'Godnatt.';

  @override
  String get narrationEndNote =>
      'Vi kan ännu inte göra en avslutande bild eller spara i Biblioteket – sagan går ingenstans, den stannar mellan er.';

  @override
  String get narrationClose => 'Stäng';

  @override
  String get ragFallback =>
      'Paketet har ännu inget om detta – ett allmänt tips:';

  @override
  String get ragNoModel => 'Tipsmodellen ingår inte i den här versionen.';

  @override
  String get ragHintGeneral => 'allmänt';

  @override
  String get ragHintMotif => 'till motivet';

  @override
  String get captionExact => 'illustration · till det här motivet';

  @override
  String get captionSimilar => 'illustration · liknande scen';

  @override
  String get captionCard =>
      'motivkort · vi har ännu ingen scen för det här steget';

  @override
  String get storageTitle => 'Nedladdade sagor';

  @override
  String get storageEmpty =>
      'Inget ännu – fler sagor laddas ner från planeten.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paket',
      one: '$n paket',
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
  String get storageBoughtTier => 'köpt';

  @override
  String get storageDelete => 'Radera';

  @override
  String get storageScenesSub => 'En bild till varje steg i berättandet';

  @override
  String get storageDownload => 'Ladda ner';

  @override
  String get storageAllUsed => 'Allt har använts de senaste 30 dagarna.';

  @override
  String storageFreed(String size) {
    return '$size frigjort.';
  }

  @override
  String get storageFreeUp => 'Frigör utrymme (oanvänt i 30 dagar)';

  @override
  String get storageRestoring => 'Återställer köp…';

  @override
  String get storageRestore => 'Återställ köp';

  @override
  String get osnovaTitle => 'Disposition';

  @override
  String get osnovaSummary => 'Sagan i korthet';

  @override
  String get osnovaCharacters => 'Figurer';

  @override
  String get osnovaTask => 'Uppdrag';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Slut';

  @override
  String get osnovaAgain => 'Från början';

  @override
  String get osnovaTell => 'Jag berättar →';

  @override
  String get outlineHero => 'Hjälten';

  @override
  String get castFox => 'Den listiga räven';

  @override
  String get castSmithSon => 'Smedens son';

  @override
  String get castMill => 'Den talande kvarnen';

  @override
  String get castGooseGirl => 'Gåspigan';

  @override
  String get castBrothers => 'De tre bröderna';

  @override
  String get castClockworkPrincess => 'Urmakarprinsessan';

  @override
  String get castOwl => 'Den kloka ugglan';

  @override
  String get castBlacksmith => 'Den gamla smedshustrun';

  @override
  String get castDragon => 'Den lilla draken';

  @override
  String get castWaterSprite => 'Näcken';

  @override
  String get castFourPrincesses => 'De fyra prinsessorna';

  @override
  String get castTravelingTailor => 'Den kringvandrande skräddaren';

  @override
  String get castTalkingCat => 'Den talande katten';

  @override
  String get castForestHermit => 'Eremiten i skogen';

  @override
  String get castC0AndersenTheShadow => 'Herren som en gång var en skugga';

  @override
  String get castC1GrimmTheGooseGirl => 'Den förrädiska kammarjungfrun';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kungen med det hemsökta slottet';

  @override
  String get castC3AndersenTheShadow => 'Den listiga skuggan';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Den vackra men inte så kloka prinsessan';

  @override
  String get castC5AndersenTheRedShoes => 'Ängeln som förlåter till sist';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mjölnarens kloka dotter';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Mormodern som öppnar dörren';

  @override
  String get castC8PerraultLittleThumb => 'En mor mellan nöd och kärlek';

  @override
  String get castC9PerraultIntroduction => 'Den tålmodiga kvinnan';

  @override
  String get castC10AndersenTheRealPrincess => 'Kungen som stöttar sin son';

  @override
  String get castC11GrimmLilyAndTheLion => 'Dottern som håller ord';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Prinsen som söker den riktiga prinsessan';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Flickan med svavelstickorna';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Hovmannen som tiger';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Den trogna tjänaren dukar upp en fest';

  @override
  String get castC16PerraultTheFairy => 'Den inbilska dottern';

  @override
  String get castC17GrimmFirstStory => 'Änkan som vill ha nio svansar';

  @override
  String get motifTaskWine => 'Vem dricker en hel vinkällare';

  @override
  String get motifTaskDiamonds => 'En flygtur efter diamanter';

  @override
  String get motifTaskRingDuck => 'Ringen i anden';

  @override
  String get motifTaskGiants => 'Att lura jättarna';

  @override
  String get motifTaskTomThumb => 'Tummeliscas flykt';

  @override
  String get motifTaskSwineherd => 'Att vinna prinsessans hjärta';

  @override
  String get motifTaskBell => 'Den mystiska klockan i skogen';

  @override
  String get motifTaskGoldenObject => 'En gåva man inte får missbruka';

  @override
  String get motifTaskPebbles => 'En stig av småsten';

  @override
  String get motifProblemFoxPride => 'Rävens stolthet';

  @override
  String get motifProblemLazySister => 'Den lata systern';

  @override
  String get motifProblemWitchBoots => 'Häxan i sjumilastövlar';

  @override
  String get motifProblemTailorDoubt => 'Ingen tror på honom';

  @override
  String get motifProblemLions => 'Hungriga lejon vid porten';

  @override
  String get motifProblemEagle => 'Örnen och dvärgen';

  @override
  String get motifProblemTruth => 'Det magiska djuret avslöjar sanningen';

  @override
  String get motifProblemOldHouse => 'Ingen vill ha det gamla huset';

  @override
  String get motifProblemBreadcrumbs => 'Fåglarna åt upp smulorna';

  @override
  String get motifEndingTrickWins => 'Slughet segrar';

  @override
  String get motifEndingTruthChild => 'Barnet säger sanningen';

  @override
  String get motifEndingNewHome => 'Ett nytt hem, gamla vänner';

  @override
  String get motifEndingHappyTogether => 'Lyckliga tillsammans för alltid';

  @override
  String get motifEndingKissWakes => 'En kyss väcker kungariket';

  @override
  String get motifEndingLeapfrog => 'Slughet hoppar högst';

  @override
  String get motifEndingCurseBroken => 'Förbannelsen är bruten';

  @override
  String get motifEndingWelcomedHome => 'Välkomnad hem';

  @override
  String get motifEndingSlipper => 'Den förlorade toffeln';
}
