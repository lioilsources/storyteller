// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Modern Greek (`el`).
class AppLocalizationsEl extends AppLocalizations {
  AppLocalizationsEl([String locale = 'el']) : super(locale);

  @override
  String get castTitle => 'Ποιος θα είναι στο παραμύθι;';

  @override
  String get castHint =>
      'Άγγιξε μια κάρτα για να πάρεις άλλον ήρωα. Σβήσε την κάρτα με το σταυρό. Η μουσική και οι ήχοι είναι πάντα έτοιμοι από το πακέτο της χώρας· μόνο η εικόνα του ήρωα ζωγραφίζεται κάποιες φορές λίγο αργότερα.';

  @override
  String get castAdd => 'Πρόσθεσε ήρωα';

  @override
  String get castCount => 'Διανομή:';

  @override
  String get castShuffleAll => 'Ανάμειξε όλους';

  @override
  String get castContinue => 'Συνέχεια →';

  @override
  String get shuffle => 'Ανάμειξε';

  @override
  String get motifTaskTitle => 'Ποια αποστολή;';

  @override
  String get motifProblemTitle => 'Ποιο πρόβλημα;';

  @override
  String get motifEndingTitle => 'Ποιο τέλος;';

  @override
  String get motifTaskCaption =>
      'Άγγιξε μια κάρτα για να διαλέξεις την αποστολή του ήρωα.';

  @override
  String get motifProblemCaption =>
      'Άγγιξε μια κάρτα για να διαλέξεις ένα εμπόδιο ή έναν κακό.';

  @override
  String get motifEndingCaption =>
      'Άγγιξε μια κάρτα για να διαλέξεις ένα ευτυχισμένο τέλος.';

  @override
  String get beatCastTitle => 'Ποιοι είναι μέσα';

  @override
  String get beatTaskTitle => 'Τι έβαλε στόχο ο ήρωας';

  @override
  String get beatProblemTitle => 'Τι βρέθηκε στο δρόμο του';

  @override
  String get beatEndingTitle => 'Πώς τελείωσε';

  @override
  String get beatCastCaption =>
      'Σύστησε τους ήρωες: πού βρίσκονται, πώς φαίνονται, τι έχουν ιδιαίτερο.';

  @override
  String get beatTaskCaption => 'Πες τι θέλει ο ήρωας και γιατί ξεκίνησε.';

  @override
  String get beatProblemCaption =>
      'Βάλε κάτι στο δρόμο του. Άσε να φαίνεται για λίγο ότι δεν θα τα καταφέρει.';

  @override
  String get beatEndingCaption =>
      'Οδήγησέ το ως το τέλος. Μην βιάζεσαι: το τέλος είναι αυτό που θυμάται περισσότερο ένα παιδί.';

  @override
  String get hintHero => 'ο ήρωας';

  @override
  String hintCast1(String who) {
    return 'Πώς φαίνεται «$who» όταν εμφανίζεται για πρώτη φορά;';
  }

  @override
  String hintCast2(String who) {
    return 'Τι κάνει «$who» ακριβώς πριν αρχίσει όλη η ιστορία;';
  }

  @override
  String hintCast3(String who) {
    return 'Τι φοβάται «$who»;';
  }

  @override
  String hintCast4(String who) {
    return 'Από πού καταλαβαίνεις ότι έρχεται «$who»;';
  }

  @override
  String get hintCast5 => 'Ποιοι από αυτούς γνωρίζονται από παλιά και από πού;';

  @override
  String get hintCast6 => 'Τι καιρό κάνει όταν συναντιούνται;';

  @override
  String hintCast7(String who) {
    return 'Τι έχει «$who» στην τσέπη;';
  }

  @override
  String hintTask1(String who) {
    return 'Πότε καταλαβαίνει «$who» ότι πρέπει να ξεκινήσει;';
  }

  @override
  String hintTask2(String who) {
    return 'Ποιος έδωσε τη συμβουλή και γιατί ακούει «$who»;';
  }

  @override
  String hintTask3(String who) {
    return 'Τι πρέπει να αφήσει στο σπίτι «$who»;';
  }

  @override
  String get hintTask4 => 'Πόσο μακρύς είναι ο δρόμος και από πού περνά;';

  @override
  String hintTask5(String who) {
    return 'Τι υπόσχεται «$who» πριν ξεκινήσει;';
  }

  @override
  String get hintTask6 => 'Γιατί δεν μπορεί να το κάνει κάποιος άλλος;';

  @override
  String get hintProblem1 => 'Εκείνη τη στιγμή ακούγεται ένας ήχος: ποιος;';

  @override
  String get hintProblem2 => 'Τι στραβώνει πρώτο;';

  @override
  String hintProblem3(String who) {
    return 'Τι δοκιμάζει πρώτο «$who» και γιατί δεν πετυχαίνει;';
  }

  @override
  String get hintProblem4 => 'Ποιος αρνείται να βοηθήσει, ενώ θα μπορούσε;';

  @override
  String get hintProblem5 => 'Τι θα γινόταν αν τα παρατούσαν όλοι τώρα;';

  @override
  String get hintProblem6 => 'Υπάρχει κάτι λυπητερό σε αυτό το εμπόδιο;';

  @override
  String hintProblem7(String who) {
    return 'Τι λέει δυνατά «$who» εκείνη τη στιγμή;';
  }

  @override
  String hintEnding1(String who) {
    return 'Με τι το ξεπερνά τελικά «$who»: με δύναμη ή με μια ιδέα;';
  }

  @override
  String get hintEnding2 => 'Ποιος βοηθά, ενώ δεν χρειαζόταν;';

  @override
  String hintEnding3(String who) {
    return 'Τι κάνει πρώτο-πρώτο «$who» όταν τελειώσουν όλα;';
  }

  @override
  String get hintEnding4 =>
      'Τι είναι διαφορετικό στο τέλος σε σχέση με την αρχή;';

  @override
  String hintEnding5(String who) {
    return 'Πού επιστρέφει «$who» και ποιος περιμένει εκεί;';
  }

  @override
  String get hintEnding6 => 'Ποια είναι η τελευταία φράση πριν ανάψει το φως;';

  @override
  String get globeLoading => 'Ετοιμάζω τον πλανήτη…';

  @override
  String get globeLoadFailed => 'Ο πλανήτης δεν φορτώθηκε.';

  @override
  String get globeTitle => 'Από πού θα είναι το παραμύθι;';

  @override
  String get globeStored => 'Παραμύθια που κατέβηκαν';

  @override
  String get globeHintFar =>
      'Γύρνα τον πλανήτη ή άγγιξε μια χώρα. Οι πράσινες χώρες έχουν ήδη παραμύθια από τη συλλογή μας, οι γκρι όχι ακόμη.';

  @override
  String get globeHintNear =>
      'Άγγιξε μια χώρα ή ένα κτίριο. Οι πράσινες χώρες έχουν ήδη παραμύθια από τη συλλογή μας, οι γκρι όχι ακόμη.';

  @override
  String get globeWhole => 'Ολόκληρος ο πλανήτης';

  @override
  String get globeZoomIn => 'Μεγέθυνση';

  @override
  String get globeZoomOut => 'Σμίκρυνση';

  @override
  String globeZoomToRegion(String name) {
    return 'Μεγέθυνση: $name →';
  }

  @override
  String get globeTellHere => 'Πες ένα παραμύθι από εδώ';

  @override
  String globeTellFrom(String place) {
    return 'Πες ένα παραμύθι από: $place →';
  }

  @override
  String get globeOpenSea => 'Ανοιχτή θάλασσα';

  @override
  String globeRegionCountries(int n) {
    return '$n χώρες μαζί. Μεγέθυνε και διάλεξε μία.';
  }

  @override
  String get globeTurnToCountry => 'Γύρνα τον πλανήτη προς μια χώρα.';

  @override
  String get globeSpin => 'Γύρνα';

  @override
  String get globeNoTales => 'Από εδώ δεν έχουμε ακόμη παραμύθια.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n μοτίβα',
      one: '$n μοτίβο',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'από $n παραμύθια',
      one: 'από $n παραμύθι',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs από το πακέτο';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n μοτίβα από το πακέτο',
      one: '$n μοτίβο από το πακέτο',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return 'Ετοιμάζουμε $_temp0 από εδώ για το πακέτο $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return '$_temp0 δωρεάν';
  }

  @override
  String cardFree(int n) {
    return '$n δωρεάν';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n στα μέρη $region $range',
      one: '$n στο μέρος $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'έχεις $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ετοιμάζουμε ακόμη $n',
      one: 'ετοιμάζουμε ακόμη $n',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Αναμονή για το κατάστημα…';

  @override
  String offerDownloading(int percent) {
    return 'Λήψη παραμυθιών… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return 'Αγορά $name: $_temp0 με $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return 'Λήψη $name: $_temp0 δωρεάν ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n παραμύθια',
      one: '$n παραμύθι',
    );
    return 'Λήψη $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Λήψη $name';
  }

  @override
  String get errDownloadTales => 'Τα παραμύθια δεν κατέβηκαν.';

  @override
  String get errDownloadScenes => 'Οι εικόνες δεν κατέβηκαν.';

  @override
  String get errNoDownloads => 'Η λήψη δεν είναι διαθέσιμη εδώ.';

  @override
  String get errOffline =>
      'Δεν υπάρχει σύνδεση στο διαδίκτυο, δοκίμασε ξανά όταν έχεις σήμα.';

  @override
  String get errCannotBuy => 'Αυτό το μέρος δεν μπορεί να αγοραστεί τώρα.';

  @override
  String get buyPending =>
      'Η αγορά περιμένει έγκριση. Το μέρος θα κατέβει μόλις εγκριθεί.';

  @override
  String get buyFailed => 'Η αγορά δεν ολοκληρώθηκε.';

  @override
  String get restoreNone => 'Σε αυτόν τον λογαριασμό δεν υπάρχουν αγορές.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Επαναφέρθηκαν $n μέρη. Μπορείς να τα κατεβάσεις από τον πλανήτη.',
      one: 'Επαναφέρθηκε $n μέρος. Μπορείς να το κατεβάσεις από τον πλανήτη.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Η επαναφορά των αγορών δεν πέτυχε, δοκίμασε ξανά όταν έχεις σήμα.';

  @override
  String get narrationGone => 'Αυτό το παραμύθι δεν είναι πια συναρμολογημένο.';

  @override
  String get narrationNew => 'Φτιάξε καινούργιο';

  @override
  String narrationTitle(int index, int total) {
    return 'Αφηγείσαι — $index από $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Πώς να συνεχίσεις: $bridge';
  }

  @override
  String get narrationSituation =>
      'Τι συμβαίνει τώρα; (προαιρετικό, μπορείς να υπαγορεύσεις)';

  @override
  String get narrationHintNote =>
      'Υπόδειξη — μην την πεις φωναχτά, απλώς ξεκίνα από αυτήν.';

  @override
  String get narrationSoundsNote =>
      'Ήχοι — παίξε τους όταν ταιριάζουν στην αφήγηση.';

  @override
  String get moodTense => 'ένταση';

  @override
  String get moodCalm => 'ηρεμία';

  @override
  String get narrationSearching => 'Ψάχνω…';

  @override
  String get narrationHint => 'Δώσε μου υπόδειξη';

  @override
  String get narrationMoreHint => 'Άλλη μία';

  @override
  String get narrationBack => 'Πίσω';

  @override
  String get narrationEnd => 'Τέλος';

  @override
  String get narrationNext => 'Επόμενο →';

  @override
  String get narrationGoodnight => 'Καληνύχτα.';

  @override
  String get narrationEndNote =>
      'Δεν μπορούμε ακόμη να φτιάξουμε τελική εικόνα ούτε να αποθηκεύσουμε στη Βιβλιοθήκη. Αυτό το παραμύθι δεν πάει πουθενά, μένει ανάμεσά σας.';

  @override
  String get narrationClose => 'Κλείσιμο';

  @override
  String get ragFallback =>
      'Από το πακέτο δεν υπάρχει ακόμη τίποτα για αυτό. Μια γενική υπόδειξη:';

  @override
  String get ragNoModel =>
      'Το μοντέλο υποδείξεων δεν περιλαμβάνεται σε αυτή την έκδοση.';

  @override
  String get ragHintGeneral => 'γενική';

  @override
  String get ragHintMotif => 'για το μοτίβο';

  @override
  String get captionExact => 'εικονογράφηση · για αυτό το μοτίβο';

  @override
  String get captionSimilar => 'εικονογράφηση · παρόμοια σκηνή';

  @override
  String get captionCard =>
      'κάρτα μοτίβου · δεν έχουμε ακόμη σκηνή για αυτό το βήμα';

  @override
  String get storageTitle => 'Παραμύθια που κατέβηκαν';

  @override
  String get storageEmpty =>
      'Τίποτα ακόμη. Περισσότερα παραμύθια κατεβαίνουν από τον πλανήτη.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n πακέτα',
      one: '$n πακέτο',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Σκηνές: $name';
  }

  @override
  String get storageFreeTier => 'δωρεάν';

  @override
  String get storageBoughtTier => 'αγορασμένο';

  @override
  String get storageDelete => 'Διαγραφή';

  @override
  String get storageScenesSub => 'Μια εικόνα για κάθε βήμα της αφήγησης';

  @override
  String get storageDownload => 'Λήψη';

  @override
  String get storageAllUsed => 'Όλα χρησιμοποιήθηκαν τις τελευταίες 30 ημέρες.';

  @override
  String storageFreed(String size) {
    return 'Αποδεσμεύτηκαν $size.';
  }

  @override
  String get storageFreeUp => 'Ελευθέρωση χώρου (αχρησιμοποίητα 30 ημέρες)';

  @override
  String get storageRestoring => 'Επαναφορά αγορών…';

  @override
  String get storageRestore => 'Επαναφορά αγορών';

  @override
  String get osnovaTitle => 'Περίγραμμα';

  @override
  String get osnovaSummary => 'Το παραμύθι με δυο λόγια';

  @override
  String get osnovaCharacters => 'Ήρωες';

  @override
  String get osnovaTask => 'Αποστολή';

  @override
  String get osnovaProblem => 'Πρόβλημα';

  @override
  String get osnovaEnding => 'Τέλος';

  @override
  String get osnovaAgain => 'Ξανά';

  @override
  String get osnovaTell => 'Αφηγούμαι →';

  @override
  String get outlineHero => 'Ο ήρωας';

  @override
  String get castFox => 'Η πονηρή αλεπού';

  @override
  String get castSmithSon => 'Ο γιος του σιδερά';

  @override
  String get castMill => 'Ο μύλος που μιλάει';

  @override
  String get castGooseGirl => 'Η χηνοβοσκός';

  @override
  String get castBrothers => 'Οι τρεις αδελφοί';

  @override
  String get castClockworkPrincess => 'Η πριγκίπισσα ωρολογοποιός';

  @override
  String get castOwl => 'Η σοφή κουκουβάγια';

  @override
  String get castBlacksmith => 'Η γριά σιδερού';

  @override
  String get castDragon => 'Ο μικρός δράκος';

  @override
  String get castWaterSprite => 'Το πνεύμα του νερού';

  @override
  String get castFourPrincesses => 'Οι τέσσερις πριγκίπισσες';

  @override
  String get castTravelingTailor => 'Ο περιπλανώμενος ράφτης';

  @override
  String get castTalkingCat => 'Ο γάτος που μιλάει';

  @override
  String get castForestHermit => 'Ο ερημίτης του δάσους';

  @override
  String get castC0AndersenTheShadow => 'Ο άρχοντας που ήταν κάποτε σκιά';

  @override
  String get castC1GrimmTheGooseGirl => 'Η άπιστη καμαριέρα';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Ο βασιλιάς με το στοιχειωμένο κάστρο';

  @override
  String get castC3AndersenTheShadow => 'Η έξυπνη σκιά';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Η όμορφη αλλά όχι και τόσο έξυπνη πριγκίπισσα';

  @override
  String get castC5AndersenTheRedShoes => 'Ο άγγελος που συγχωρεί στο τέλος';

  @override
  String get castC6GrimmRumpelstiltskin => 'Η έξυπνη κόρη του μυλωνά';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'Η γιαγιά που ανοίγει την πόρτα';

  @override
  String get castC8PerraultLittleThumb =>
      'Μια μάνα ανάμεσα στη φτώχεια και την αγάπη';

  @override
  String get castC9PerraultIntroduction => 'Η υπομονετική γυναίκα';

  @override
  String get castC10AndersenTheRealPrincess =>
      'Ο βασιλιάς που στηρίζει το γιο του';

  @override
  String get castC11GrimmLilyAndTheLion => 'Η κόρη που κρατά το λόγο της';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Ο πρίγκιπας που ψάχνει την αληθινή πριγκίπισσα';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Το κορίτσι με τα σπίρτα';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Ο αυλικός που σωπαίνει';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Ο πιστός υπηρέτης ετοιμάζει γεύμα';

  @override
  String get castC16PerraultTheFairy => 'Η ματαιόδοξη κόρη';

  @override
  String get castC17GrimmFirstStory => 'Η χήρα που θέλει εννιά ουρές';

  @override
  String get motifTaskWine => 'Ποιος θα πιει μια κάβα κρασί';

  @override
  String get motifTaskDiamonds => 'Πτήση για διαμάντια';

  @override
  String get motifTaskRingDuck => 'Το δαχτυλίδι μέσα στην πάπια';

  @override
  String get motifTaskGiants => 'Να ξεγελάσεις τους γίγαντες';

  @override
  String get motifTaskTomThumb => 'Η απόδραση του Δαχτυλάκη';

  @override
  String get motifTaskSwineherd => 'Να κερδίσεις την καρδιά της πριγκίπισσας';

  @override
  String get motifTaskBell => 'Η μυστηριώδης καμπάνα στο δάσος';

  @override
  String get motifTaskGoldenObject => 'Ένα δώρο που δεν πρέπει να καταχραστείς';

  @override
  String get motifTaskPebbles => 'Ένα μονοπάτι από βότσαλα';

  @override
  String get motifProblemFoxPride => 'Η περηφάνια της αλεπούς';

  @override
  String get motifProblemLazySister => 'Η τεμπέλα αδελφή';

  @override
  String get motifProblemWitchBoots =>
      'Η μάγισσα με τις μπότες των εφτά λευγών';

  @override
  String get motifProblemTailorDoubt => 'Κανείς δεν τον πιστεύει';

  @override
  String get motifProblemLions => 'Πεινασμένα λιοντάρια στην πύλη';

  @override
  String get motifProblemEagle => 'Ο αετός και ο νάνος';

  @override
  String get motifProblemTruth => 'Το μαγικό ζώο αποκαλύπτει την αλήθεια';

  @override
  String get motifProblemOldHouse => 'Κανείς δεν θέλει το παλιό σπίτι';

  @override
  String get motifProblemBreadcrumbs => 'Τα πουλιά έφαγαν τα ψίχουλα';

  @override
  String get motifEndingTrickWins => 'Η εξυπνάδα νικά';

  @override
  String get motifEndingTruthChild => 'Το παιδί λέει την αλήθεια';

  @override
  String get motifEndingNewHome => 'Ένα νέο σπίτι, παλιοί φίλοι';

  @override
  String get motifEndingHappyTogether => 'Ευτυχισμένοι μαζί για πάντα';

  @override
  String get motifEndingKissWakes => 'Ένα φιλί ξυπνά το βασίλειο';

  @override
  String get motifEndingLeapfrog => 'Η εξυπνάδα πηδά πιο ψηλά';

  @override
  String get motifEndingCurseBroken => 'Η κατάρα λύθηκε';

  @override
  String get motifEndingWelcomedHome => 'Καλωσορίζεται στο σπίτι';

  @override
  String get motifEndingSlipper => 'Το χαμένο παπούτσι';
}
