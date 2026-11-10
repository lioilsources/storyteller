// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Norwegian Bokmål (`nb`).
class AppLocalizationsNb extends AppLocalizations {
  AppLocalizationsNb([String locale = 'nb']) : super(locale);

  @override
  String get castTitle => 'Hvem skal være med i eventyret?';

  @override
  String get castHint =>
      'Trykk på et kort for å få en annen figur. Fjern kortet med krysset. Musikk og lyder er alltid ferdige fra landets pakke – bare bildet av figuren blir av og til tegnet litt senere.';

  @override
  String get castAdd => 'Legg til figur';

  @override
  String get castCount => 'Rolleliste:';

  @override
  String get castShuffleAll => 'Bland alle';

  @override
  String get castContinue => 'Fortsett →';

  @override
  String get shuffle => 'Bland';

  @override
  String get motifTaskTitle => 'Hvilken oppgave?';

  @override
  String get motifProblemTitle => 'Hvilket problem?';

  @override
  String get motifEndingTitle => 'Hvilken slutt?';

  @override
  String get motifTaskCaption =>
      'Trykk på et kort for å velge heltens oppgave.';

  @override
  String get motifProblemCaption =>
      'Trykk på et kort for å velge en hindring eller en skurk.';

  @override
  String get motifEndingCaption =>
      'Trykk på et kort for å velge en lykkelig slutt.';

  @override
  String get beatCastTitle => 'Hvem er med';

  @override
  String get beatTaskTitle => 'Hva helten har satt seg fore';

  @override
  String get beatProblemTitle => 'Hva som kom i veien';

  @override
  String get beatEndingTitle => 'Hvordan det gikk';

  @override
  String get beatCastCaption =>
      'Presenter figurene. Hvor de er, hvordan de ser ut, hva som er spesielt med dem.';

  @override
  String get beatTaskCaption =>
      'Fortell hva helten vil, og hvorfor helten la ut på reisen.';

  @override
  String get beatProblemCaption =>
      'Sett noe i veien for helten. La det en stund se ut som om det ikke kan gå.';

  @override
  String get beatEndingCaption =>
      'Før det til ende. Ikke hast – slutten husker et barn best.';

  @override
  String get hintHero => 'helten';

  @override
  String hintCast1(String who) {
    return 'Hvordan ser «$who» ut når den dukker opp for første gang?';
  }

  @override
  String hintCast2(String who) {
    return 'Hva gjør «$who» rett før hele historien begynner?';
  }

  @override
  String hintCast3(String who) {
    return 'Hva er «$who» redd for?';
  }

  @override
  String hintCast4(String who) {
    return 'Hvordan ser du at «$who» er på vei?';
  }

  @override
  String get hintCast5 => 'Hvem av dem har kjent hverandre lenge, og hvorfra?';

  @override
  String get hintCast6 => 'Hvordan er været når de møtes?';

  @override
  String hintCast7(String who) {
    return 'Hva har «$who» i lommen?';
  }

  @override
  String hintTask1(String who) {
    return 'Når forstår «$who» at det er nå det må begynne?';
  }

  @override
  String hintTask2(String who) {
    return 'Hvem ga rådet, og hvorfor hører «$who» på det?';
  }

  @override
  String hintTask3(String who) {
    return 'Hva må «$who» la bli igjen hjemme?';
  }

  @override
  String get hintTask4 => 'Hvor lang er veien, og hva går den over?';

  @override
  String hintTask5(String who) {
    return 'Hva lover «$who» seg selv før turen begynner?';
  }

  @override
  String get hintTask6 => 'Hvorfor kan ingen andre gjøre det?';

  @override
  String get hintProblem1 => 'I det øyeblikket høres en lyd – hvilken?';

  @override
  String get hintProblem2 => 'Hva går galt først?';

  @override
  String hintProblem3(String who) {
    return 'Hva prøver «$who» først, og hvorfor virker det ikke?';
  }

  @override
  String get hintProblem4 => 'Hvem nekter å hjelpe selv om vedkommende kunne?';

  @override
  String get hintProblem5 => 'Hva ville skjedd hvis alle ga opp akkurat nå?';

  @override
  String get hintProblem6 => 'Er det noe trist ved hindringen?';

  @override
  String hintProblem7(String who) {
    return 'Hva sier «$who» høyt i det øyeblikket?';
  }

  @override
  String hintEnding1(String who) {
    return 'Hvordan overvinner «$who» det til slutt – med krefter eller med en idé?';
  }

  @override
  String get hintEnding2 =>
      'Hvem hjelper selv om vedkommende ikke trengte det?';

  @override
  String hintEnding3(String who) {
    return 'Hva gjør «$who» aller først når alt er over?';
  }

  @override
  String get hintEnding4 => 'Hva er annerledes på slutten enn i begynnelsen?';

  @override
  String hintEnding5(String who) {
    return 'Hvor vender «$who» tilbake til, og hvem venter der?';
  }

  @override
  String get hintEnding6 => 'Hva er den siste setningen før lyset slås på?';

  @override
  String get globeLoading => 'Gjør planeten klar…';

  @override
  String get globeLoadFailed => 'Planeten kunne ikke lastes.';

  @override
  String get globeTitle => 'Hvor skal eventyret komme fra?';

  @override
  String get globeStored => 'Nedlastede eventyr';

  @override
  String get globeHintFar =>
      'Drei planeten, eller trykk på et land. Grønne land har allerede eventyr fra samlingen vår, grå har ikke det ennå.';

  @override
  String get globeHintNear =>
      'Trykk på et land eller en bygning. Grønne land har allerede eventyr fra samlingen vår, grå har ikke det ennå.';

  @override
  String get globeWhole => 'Hele planeten';

  @override
  String get globeZoomIn => 'Zoom inn';

  @override
  String get globeZoomOut => 'Zoom ut';

  @override
  String globeZoomToRegion(String name) {
    return 'Zoom inn på $name →';
  }

  @override
  String get globeTellHere => 'Fortell et eventyr herfra';

  @override
  String globeTellFrom(String place) {
    return 'Fortell et eventyr fra $place →';
  }

  @override
  String get globeOpenSea => 'Åpent hav';

  @override
  String globeRegionCountries(int n) {
    return '$n land samlet. Zoom inn og velg ett.';
  }

  @override
  String get globeTurnToCountry => 'Drei planeten mot et land.';

  @override
  String get globeSpin => 'Drei';

  @override
  String get globeNoTales => 'Vi har ingen eventyr herfra ennå.';

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
    return 'Vi gjør $_temp0 herfra klart til pakken $region.';
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
      other: '$n flere på vei',
      one: '$n til på vei',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Venter på butikken…';

  @override
  String offerDownloading(int percent) {
    return 'Laster ned eventyr… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Kjøp $name: $_temp0 for $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Last ned $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n eventyr',
      one: '$n eventyr',
    );
    return 'Last ned $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Last ned $name';
  }

  @override
  String get errDownloadTales => 'Eventyrene kunne ikke lastes ned.';

  @override
  String get errDownloadScenes => 'Bildene kunne ikke lastes ned.';

  @override
  String get errNoDownloads => 'Nedlasting er ikke tilgjengelig her.';

  @override
  String get errOffline =>
      'Ingen internettforbindelse – prøv igjen når du har signal.';

  @override
  String get errCannotBuy => 'Denne delen kan ikke kjøpes akkurat nå.';

  @override
  String get buyPending =>
      'Kjøpet venter på godkjenning. Delen lastes ned når det er gått gjennom.';

  @override
  String get buyFailed => 'Kjøpet gikk ikke gjennom.';

  @override
  String get restoreNone => 'Det finnes ingen kjøp på denne kontoen.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n deler gjenopprettet. Du kan laste dem ned fra planeten.',
      one: '$n del gjenopprettet. Du kan laste den ned fra planeten.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Kjøpene kunne ikke gjenopprettes – prøv igjen når du har signal.';

  @override
  String get narrationGone => 'Dette eventyret er ikke satt sammen lenger.';

  @override
  String get narrationNew => 'Sett sammen et nytt';

  @override
  String narrationTitle(int index, int total) {
    return 'Du forteller – $index av $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Slik fortsetter du: $bridge';
  }

  @override
  String get narrationSituation =>
      'Hva skjer akkurat nå? (valgfritt, kan dikteres)';

  @override
  String get narrationHintNote =>
      'Hint – ikke si det høyt, bruk det bare som utgangspunkt.';

  @override
  String get narrationSoundsNote =>
      'Lyder – spill dem når de passer til fortellingen.';

  @override
  String get moodTense => 'spenning';

  @override
  String get moodCalm => 'ro';

  @override
  String get narrationSearching => 'Søker…';

  @override
  String get narrationHint => 'Gi et hint';

  @override
  String get narrationMoreHint => 'Ett til';

  @override
  String get narrationBack => 'Tilbake';

  @override
  String get narrationEnd => 'Slutt';

  @override
  String get narrationNext => 'Videre →';

  @override
  String get narrationGoodnight => 'God natt.';

  @override
  String get narrationEndNote =>
      'Vi kan ennå ikke lage et avsluttende bilde eller lagre i Biblioteket – eventyret går ingen steder, det blir mellom dere.';

  @override
  String get narrationClose => 'Lukk';

  @override
  String get ragFallback =>
      'Pakken har ennå ikke noe om dette – et generelt hint:';

  @override
  String get ragNoModel => 'Hintmodellen er ikke med i denne versjonen.';

  @override
  String get ragHintGeneral => 'generelt';

  @override
  String get ragHintMotif => 'til motivet';

  @override
  String get captionExact => 'illustrasjon · til dette motivet';

  @override
  String get captionSimilar => 'illustrasjon · lignende scene';

  @override
  String get captionCard =>
      'motivkort · vi har ennå ingen scene til dette trinnet';

  @override
  String get storageTitle => 'Nedlastede eventyr';

  @override
  String get storageEmpty =>
      'Ingenting ennå – flere eventyr lastes ned fra planeten.';

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
  String get storageBoughtTier => 'kjøpt';

  @override
  String get storageDelete => 'Slett';

  @override
  String get storageScenesSub => 'Ett bilde til hvert trinn i fortellingen';

  @override
  String get storageDownload => 'Last ned';

  @override
  String get storageAllUsed => 'Alt er brukt de siste 30 dagene.';

  @override
  String storageFreed(String size) {
    return '$size frigjort.';
  }

  @override
  String get storageFreeUp => 'Frigjør plass (ikke brukt på 30 dager)';

  @override
  String get storageRestoring => 'Gjenoppretter kjøp…';

  @override
  String get storageRestore => 'Gjenopprett kjøp';

  @override
  String get osnovaTitle => 'Disposisjon';

  @override
  String get osnovaSummary => 'Eventyret i korte trekk';

  @override
  String get osnovaCharacters => 'Figurer';

  @override
  String get osnovaTask => 'Oppgave';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Slutt';

  @override
  String get osnovaAgain => 'På nytt';

  @override
  String get osnovaTell => 'Jeg forteller →';

  @override
  String get outlineHero => 'Helten';

  @override
  String get castFox => 'Den kloke reven';

  @override
  String get castSmithSon => 'Smedens sønn';

  @override
  String get castMill => 'Den talende mølla';

  @override
  String get castGooseGirl => 'Gåsejenta';

  @override
  String get castBrothers => 'De tre brødrene';

  @override
  String get castClockworkPrincess => 'Urmakerprinsessen';

  @override
  String get castOwl => 'Den kloke uglen';

  @override
  String get castBlacksmith => 'Den gamle smedkona';

  @override
  String get castDragon => 'Den lille dragen';

  @override
  String get castWaterSprite => 'Vannånden';

  @override
  String get castFourPrincesses => 'De fire prinsessene';

  @override
  String get castTravelingTailor => 'Den vandrende skredderen';

  @override
  String get castTalkingCat => 'Den talende katten';

  @override
  String get castForestHermit => 'Eneboeren i skogen';

  @override
  String get castC0AndersenTheShadow => 'Herren som en gang var en skygge';

  @override
  String get castC1GrimmTheGooseGirl => 'Den forrædderske kammerjomfruen';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kongen med det hjemsøkte slottet';

  @override
  String get castC3AndersenTheShadow => 'Den kloke skyggen';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Den vakre, men ikke så kloke prinsessen';

  @override
  String get castC5AndersenTheRedShoes => 'Engelen som tilgir til slutt';

  @override
  String get castC6GrimmRumpelstiltskin => 'Møllerens kloke datter';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Bestemoren som åpner døren';

  @override
  String get castC8PerraultLittleThumb => 'En mor mellom nød og kjærlighet';

  @override
  String get castC9PerraultIntroduction => 'Den tålmodige kvinnen';

  @override
  String get castC10AndersenTheRealPrincess => 'Kongen som støtter sønnen sin';

  @override
  String get castC11GrimmLilyAndTheLion => 'Datteren som holder ord';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Prinsen som leter etter den virkelige prinsessen';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'Den lille jenta med fyrstikkene';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Hoffmannen som tier';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Den trofaste tjeneren lager gjestebud';

  @override
  String get castC16PerraultTheFairy => 'Den innbilske datteren';

  @override
  String get castC17GrimmFirstStory => 'Enken som vil ha ni haler';

  @override
  String get motifTaskWine => 'Hvem drikker en hel kjeller med vin';

  @override
  String get motifTaskDiamonds => 'En flytur etter diamanter';

  @override
  String get motifTaskRingDuck => 'Ringen i anda';

  @override
  String get motifTaskGiants => 'Å lure kjempene';

  @override
  String get motifTaskTomThumb => 'Tommelitens flukt';

  @override
  String get motifTaskSwineherd => 'Å vinne prinsessens hjerte';

  @override
  String get motifTaskBell => 'Den mystiske klokka i skogen';

  @override
  String get motifTaskGoldenObject => 'En gave som ikke må misbrukes';

  @override
  String get motifTaskPebbles => 'En sti av småstein';

  @override
  String get motifProblemFoxPride => 'Revens stolthet';

  @override
  String get motifProblemLazySister => 'Den late søsteren';

  @override
  String get motifProblemWitchBoots => 'Heksa i sjumilsstøvler';

  @override
  String get motifProblemTailorDoubt => 'Ingen tror på ham';

  @override
  String get motifProblemLions => 'Sultne løver ved porten';

  @override
  String get motifProblemEagle => 'Ørnen og dvergen';

  @override
  String get motifProblemTruth => 'Det magiske dyret avslører sannheten';

  @override
  String get motifProblemOldHouse => 'Ingen vil ha det gamle huset';

  @override
  String get motifProblemBreadcrumbs => 'Fuglene spiste smulene';

  @override
  String get motifEndingTrickWins => 'Klokskap seirer';

  @override
  String get motifEndingTruthChild => 'Barnet sier sannheten';

  @override
  String get motifEndingNewHome => 'Et nytt hjem, gamle venner';

  @override
  String get motifEndingHappyTogether => 'Lykkelige sammen for alltid';

  @override
  String get motifEndingKissWakes => 'Et kyss vekker kongeriket';

  @override
  String get motifEndingLeapfrog => 'Klokskap hopper høyest';

  @override
  String get motifEndingCurseBroken => 'Forbannelsen er brutt';

  @override
  String get motifEndingWelcomedHome => 'Ønsket velkommen hjem';

  @override
  String get motifEndingSlipper => 'Den tapte skoen';
}
