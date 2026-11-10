// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get castTitle => 'Wer kommt im Märchen vor?';

  @override
  String get castHint =>
      'Tippe auf eine Karte, um eine andere Figur zu bekommen. Entferne eine Karte mit dem Kreuz. Musik und Geräusche sind immer fertig aus dem Länderpaket – nur das Bild der Figur wird manchmal einen Moment später nachgezeichnet.';

  @override
  String get castAdd => 'Figur hinzufügen';

  @override
  String get castCount => 'Besetzung:';

  @override
  String get castShuffleAll => 'Alle mischen';

  @override
  String get castContinue => 'Weiter →';

  @override
  String get shuffle => 'Mischen';

  @override
  String get motifTaskTitle => 'Welche Aufgabe?';

  @override
  String get motifProblemTitle => 'Welches Problem?';

  @override
  String get motifEndingTitle => 'Welches Ende?';

  @override
  String get motifTaskCaption =>
      'Tippe auf eine Karte und wähle die Aufgabe des Helden.';

  @override
  String get motifProblemCaption =>
      'Tippe auf eine Karte und wähle ein Hindernis oder einen Bösewicht.';

  @override
  String get motifEndingCaption =>
      'Tippe auf eine Karte und wähle ein glückliches Ende.';

  @override
  String get beatCastTitle => 'Wer vorkommt';

  @override
  String get beatTaskTitle => 'Was sich der Held vorgenommen hat';

  @override
  String get beatProblemTitle => 'Was ihm in den Weg kam';

  @override
  String get beatEndingTitle => 'Wie es ausging';

  @override
  String get beatCastCaption =>
      'Stell die Figuren vor. Wo sie sind, wie sie aussehen, was an ihnen besonders ist.';

  @override
  String get beatTaskCaption =>
      'Erzähle, was der Held will und warum er aufgebrochen ist.';

  @override
  String get beatProblemCaption =>
      'Stell dem Helden etwas in den Weg. Eine Weile soll es aussehen, als würde es nicht gelingen.';

  @override
  String get beatEndingCaption =>
      'Führe es zu Ende. Nur keine Eile – das Ende merkt sich ein Kind am besten.';

  @override
  String get hintHero => 'der Held';

  @override
  String hintCast1(String who) {
    return 'Wie sieht „$who“ aus, wenn es zum ersten Mal auftaucht?';
  }

  @override
  String hintCast2(String who) {
    return 'Was macht „$who“ gerade, bevor die ganze Geschichte beginnt?';
  }

  @override
  String hintCast3(String who) {
    return 'Wovor fürchtet sich „$who“?';
  }

  @override
  String hintCast4(String who) {
    return 'Woran erkennst du, dass „$who“ kommt?';
  }

  @override
  String get hintCast5 => 'Wer von ihnen kennt sich schon lange, und woher?';

  @override
  String get hintCast6 => 'Wie ist das Wetter, wenn sie sich treffen?';

  @override
  String hintCast7(String who) {
    return 'Was hat „$who“ in der Tasche?';
  }

  @override
  String hintTask1(String who) {
    return 'Wann begreift „$who“, dass es jetzt losgehen muss?';
  }

  @override
  String hintTask2(String who) {
    return 'Wer hat den Rat gegeben, und warum hört „$who“ darauf?';
  }

  @override
  String hintTask3(String who) {
    return 'Was muss „$who“ zu Hause lassen?';
  }

  @override
  String get hintTask4 => 'Wie lang ist der Weg, und worüber führt er?';

  @override
  String hintTask5(String who) {
    return 'Was verspricht sich „$who“, bevor es losgeht?';
  }

  @override
  String get hintTask6 => 'Warum kann es kein anderer tun?';

  @override
  String get hintProblem1 => 'In diesem Moment ertönt ein Geräusch – welches?';

  @override
  String get hintProblem2 => 'Was geht als Erstes schief?';

  @override
  String hintProblem3(String who) {
    return 'Was versucht „$who“ zuerst, und warum klappt es nicht?';
  }

  @override
  String get hintProblem4 => 'Wer weigert sich zu helfen, obwohl er könnte?';

  @override
  String get hintProblem5 => 'Was würde passieren, wenn jetzt alle aufgäben?';

  @override
  String get hintProblem6 => 'Ist an diesem Hindernis etwas Trauriges?';

  @override
  String hintProblem7(String who) {
    return 'Was sagt „$who“ in diesem Moment laut?';
  }

  @override
  String hintEnding1(String who) {
    return 'Womit überwindet „$who“ es am Ende – mit Kraft oder mit einer Idee?';
  }

  @override
  String get hintEnding2 => 'Wer hilft, obwohl er es nicht müsste?';

  @override
  String hintEnding3(String who) {
    return 'Was tut „$who“ als Allererstes, wenn alles vorbei ist?';
  }

  @override
  String get hintEnding4 => 'Was ist am Ende anders als am Anfang?';

  @override
  String hintEnding5(String who) {
    return 'Wohin kehrt „$who“ zurück, und wer wartet dort?';
  }

  @override
  String get hintEnding6 => 'Was ist der letzte Satz, bevor das Licht angeht?';

  @override
  String get globeLoading => 'Der Planet wird vorbereitet…';

  @override
  String get globeLoadFailed => 'Der Planet konnte nicht geladen werden.';

  @override
  String get globeTitle => 'Woher soll das Märchen kommen?';

  @override
  String get globeStored => 'Geladene Märchen';

  @override
  String get globeHintFar =>
      'Dreh den Planeten oder tippe auf ein Land. Grüne Länder haben schon Märchen aus unserer Sammlung, graue noch nicht.';

  @override
  String get globeHintNear =>
      'Tippe auf ein Land oder ein Bauwerk. Grüne Länder haben schon Märchen aus unserer Sammlung, graue noch nicht.';

  @override
  String get globeWhole => 'Ganzer Planet';

  @override
  String get globeZoomIn => 'Heranzoomen';

  @override
  String get globeZoomOut => 'Herauszoomen';

  @override
  String globeZoomToRegion(String name) {
    return '$name heranzoomen →';
  }

  @override
  String get globeTellHere => 'Ein Märchen von hier erzählen';

  @override
  String globeTellFrom(String place) {
    return 'Ein Märchen aus $place erzählen →';
  }

  @override
  String get globeOpenSea => 'Offenes Meer';

  @override
  String globeRegionCountries(int n) {
    return '$n Länder zusammen. Zoom heran und wähle eines.';
  }

  @override
  String get globeTurnToCountry => 'Dreh den Planeten auf ein Land.';

  @override
  String get globeSpin => 'Drehen';

  @override
  String get globeNoTales => 'Von hier haben wir noch keine Märchen.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Motive',
      one: '$n Motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'aus $n Märchen',
      one: 'aus $n Märchen',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs aus dem Paket';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Motive aus dem Paket',
      one: '$n Motiv aus dem Paket',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
    );
    return 'Wir bereiten $_temp0 von hier für das Paket $region vor.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
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
      other: '$n in den Teilen $region $range',
      one: '$n im Teil $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'du hast $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n weitere in Arbeit',
      one: '$n weiteres in Arbeit',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Warte auf den Store…';

  @override
  String offerDownloading(int percent) {
    return 'Märchen werden geladen… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
    );
    return '$name kaufen: $_temp0 für $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
    );
    return '$name laden: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Märchen',
      one: '$n Märchen',
    );
    return '$name laden: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name laden';
  }

  @override
  String get errDownloadTales => 'Die Märchen konnten nicht geladen werden.';

  @override
  String get errDownloadScenes => 'Die Bilder konnten nicht geladen werden.';

  @override
  String get errNoDownloads => 'Hier ist Herunterladen nicht möglich.';

  @override
  String get errOffline =>
      'Keine Internetverbindung – versuche es noch einmal, wenn du Empfang hast.';

  @override
  String get errCannotBuy => 'Dieser Teil kann gerade nicht gekauft werden.';

  @override
  String get buyPending =>
      'Der Kauf wartet auf Genehmigung. Der Teil wird geladen, sobald er durch ist.';

  @override
  String get buyFailed => 'Der Kauf hat nicht geklappt.';

  @override
  String get restoreNone => 'Auf diesem Konto gibt es keine Käufe.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Teile wiederhergestellt. Du kannst sie vom Planeten laden.',
      one: '$n Teil wiederhergestellt. Du kannst ihn vom Planeten laden.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Die Käufe konnten nicht wiederhergestellt werden – versuche es noch einmal, wenn du Empfang hast.';

  @override
  String get narrationGone => 'Dieses Märchen ist nicht mehr zusammengestellt.';

  @override
  String get narrationNew => 'Neues zusammenstellen';

  @override
  String narrationTitle(int index, int total) {
    return 'Du erzählst – $index von $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'So geht es weiter: $bridge';
  }

  @override
  String get narrationSituation =>
      'Was passiert gerade? (optional, du kannst diktieren)';

  @override
  String get narrationHintNote =>
      'Hinweis – sag ihn nicht laut, nimm ihn nur als Anstoß.';

  @override
  String get narrationSoundsNote =>
      'Geräusche – spiel sie ab, wenn sie zur Erzählung passen.';

  @override
  String get moodTense => 'Spannung';

  @override
  String get moodCalm => 'Ruhe';

  @override
  String get narrationSearching => 'Suche…';

  @override
  String get narrationHint => 'Gib mir einen Hinweis';

  @override
  String get narrationMoreHint => 'Noch einen';

  @override
  String get narrationBack => 'Zurück';

  @override
  String get narrationEnd => 'Ende';

  @override
  String get narrationNext => 'Weiter →';

  @override
  String get narrationGoodnight => 'Gute Nacht.';

  @override
  String get narrationEndNote =>
      'Ein Abschlussbild und das Speichern in der Bibliothek können wir noch nicht – dieses Märchen geht nirgendwohin, es bleibt unter euch.';

  @override
  String get narrationClose => 'Schließen';

  @override
  String get ragFallback =>
      'Aus dem Paket gibt es dazu noch nichts – ein allgemeiner Hinweis:';

  @override
  String get ragNoModel =>
      'Das Hinweismodell ist in dieser Version nicht enthalten.';

  @override
  String get ragHintGeneral => 'allgemein';

  @override
  String get ragHintMotif => 'zum Motiv';

  @override
  String get captionExact => 'Illustration · zu diesem Motiv';

  @override
  String get captionSimilar => 'Illustration · ähnliche Szene';

  @override
  String get captionCard =>
      'Motivkarte · für diesen Schritt haben wir noch keine Szene';

  @override
  String get storageTitle => 'Geladene Märchen';

  @override
  String get storageEmpty =>
      'Noch nichts – weitere Märchen werden vom Planeten geladen.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Pakete',
      one: '$n Paket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Szenen $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'gekauft';

  @override
  String get storageDelete => 'Löschen';

  @override
  String get storageScenesSub => 'Ein Bild zu jedem Schritt des Erzählens';

  @override
  String get storageDownload => 'Laden';

  @override
  String get storageAllUsed => 'Alles wurde in den letzten 30 Tagen benutzt.';

  @override
  String storageFreed(String size) {
    return '$size freigegeben.';
  }

  @override
  String get storageFreeUp => 'Platz freigeben (30 Tage ungenutzt)';

  @override
  String get storageRestoring => 'Käufe werden wiederhergestellt…';

  @override
  String get storageRestore => 'Käufe wiederherstellen';

  @override
  String get osnovaTitle => 'Gliederung';

  @override
  String get osnovaSummary => 'Das Märchen in Kürze';

  @override
  String get osnovaCharacters => 'Figuren';

  @override
  String get osnovaTask => 'Aufgabe';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Ende';

  @override
  String get osnovaAgain => 'Von vorn';

  @override
  String get osnovaTell => 'Ich erzähle →';

  @override
  String get outlineHero => 'Der Held';

  @override
  String get castFox => 'Der kluge Fuchs';

  @override
  String get castSmithSon => 'Der Sohn des Schmieds';

  @override
  String get castMill => 'Die sprechende Mühle';

  @override
  String get castGooseGirl => 'Die Gänsemagd';

  @override
  String get castBrothers => 'Die drei Brüder';

  @override
  String get castClockworkPrincess => 'Die Uhrmacherprinzessin';

  @override
  String get castOwl => 'Die weise Eule';

  @override
  String get castBlacksmith => 'Die alte Schmiedin';

  @override
  String get castDragon => 'Der kleine Drache';

  @override
  String get castWaterSprite => 'Der Wassermann';

  @override
  String get castFourPrincesses => 'Die vier Prinzessinnen';

  @override
  String get castTravelingTailor => 'Der wandernde Schneider';

  @override
  String get castTalkingCat => 'Der sprechende Kater';

  @override
  String get castForestHermit => 'Der Einsiedler im Wald';

  @override
  String get castC0AndersenTheShadow => 'Der Herr, der einmal ein Schatten war';

  @override
  String get castC1GrimmTheGooseGirl => 'Die verräterische Kammerfrau';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Der König mit dem Spukschloss';

  @override
  String get castC3AndersenTheShadow => 'Der kluge Schatten';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Die schöne, aber nicht allzu kluge Prinzessin';

  @override
  String get castC5AndersenTheRedShoes => 'Der Engel, der am Ende verzeiht';

  @override
  String get castC6GrimmRumpelstiltskin => 'Die kluge Tochter des Müllers';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'Die Großmutter, die die Tür öffnet';

  @override
  String get castC8PerraultLittleThumb => 'Eine Mutter zwischen Not und Liebe';

  @override
  String get castC9PerraultIntroduction => 'Die geduldige Frau';

  @override
  String get castC10AndersenTheRealPrincess =>
      'Der König, der seinen Sohn unterstützt';

  @override
  String get castC11GrimmLilyAndTheLion => 'Die Tochter, die ihr Wort hält';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Der Prinz, der die echte Prinzessin sucht';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'Das kleine Mädchen mit den Schwefelhölzern';

  @override
  String get castC14AndersenTheEmperorSNewClothes =>
      'Der Höfling, der schweigt';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Der treue Diener richtet ein Festmahl aus';

  @override
  String get castC16PerraultTheFairy => 'Die eingebildete Tochter';

  @override
  String get castC17GrimmFirstStory => 'Die Witwe, die neun Schwänze will';

  @override
  String get motifTaskWine => 'Wer trinkt einen Keller voll Wein';

  @override
  String get motifTaskDiamonds => 'Ein Flug nach Diamanten';

  @override
  String get motifTaskRingDuck => 'Der Ring in der Ente';

  @override
  String get motifTaskGiants => 'Die Riesen überlisten';

  @override
  String get motifTaskTomThumb => 'Die Flucht des Däumlings';

  @override
  String get motifTaskSwineherd => 'Das Herz der Prinzessin gewinnen';

  @override
  String get motifTaskBell => 'Die geheimnisvolle Glocke im Wald';

  @override
  String get motifTaskGoldenObject =>
      'Ein Geschenk, das man nicht missbrauchen darf';

  @override
  String get motifTaskPebbles => 'Ein Pfad aus Kieselsteinen';

  @override
  String get motifProblemFoxPride => 'Der Stolz des Fuchses';

  @override
  String get motifProblemLazySister => 'Die faule Schwester';

  @override
  String get motifProblemWitchBoots => 'Die Hexe in Siebenmeilenstiefeln';

  @override
  String get motifProblemTailorDoubt => 'Niemand glaubt ihm';

  @override
  String get motifProblemLions => 'Hungrige Löwen am Tor';

  @override
  String get motifProblemEagle => 'Der Adler und der Zwerg';

  @override
  String get motifProblemTruth => 'Das Zaubertier verrät die Wahrheit';

  @override
  String get motifProblemOldHouse => 'Niemand will das alte Haus';

  @override
  String get motifProblemBreadcrumbs => 'Die Vögel fraßen die Krumen';

  @override
  String get motifEndingTrickWins => 'Die List siegt';

  @override
  String get motifEndingTruthChild => 'Das Kind sagt die Wahrheit';

  @override
  String get motifEndingNewHome => 'Ein neues Zuhause, alte Freunde';

  @override
  String get motifEndingHappyTogether => 'Glücklich zusammen für immer';

  @override
  String get motifEndingKissWakes => 'Ein Kuss weckt das Königreich';

  @override
  String get motifEndingLeapfrog => 'Die List springt am höchsten';

  @override
  String get motifEndingCurseBroken => 'Der Fluch ist gebrochen';

  @override
  String get motifEndingWelcomedHome => 'Zu Hause willkommen';

  @override
  String get motifEndingSlipper => 'Der verlorene Schuh';
}
