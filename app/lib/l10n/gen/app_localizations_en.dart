// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Pohádkomat';

  @override
  String get globeLoadFailed => 'Couldn\'t load the planet.';

  @override
  String get globeLoading => 'Getting the planet ready…';

  @override
  String get globeTitle => 'Where is the story from?';

  @override
  String get globeDownloadedTooltip => 'Downloaded stories';

  @override
  String get globeHintFar =>
      'Spin the planet or tap a country. Green countries already have tales from our collection, grey ones not yet.';

  @override
  String get globeHintNear =>
      'Tap a country or a landmark. Green countries already have tales from our collection, grey ones not yet.';

  @override
  String get globeWhole => 'Whole planet';

  @override
  String get globeZoomIn => 'Zoom in';

  @override
  String get globeZoomOut => 'Zoom out';

  @override
  String globeZoomInto(String region) {
    return 'Zoom into $region →';
  }

  @override
  String get globeTellHere => 'Tell a story from here';

  @override
  String globeTellFrom(String from) {
    return 'Tell a story $from →';
  }

  @override
  String get globeOpenSea => 'Open sea';

  @override
  String globeRegionCount(int n) {
    return '$n countries together. Zoom in and pick one.';
  }

  @override
  String get globeTurnToCountry => 'Turn the planet to a country.';

  @override
  String get globeNothingHere => 'We don\'t have any tales from here yet.';

  @override
  String get globeSpin => 'Spin';

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motifs',
      one: '1 motif',
    );
    return '$_temp0 from the pack';
  }

  @override
  String plusFromPack(String base, int n) {
    return '$base + $n from the pack';
  }

  @override
  String motifsFromTales(int motifs, int tales) {
    String _temp0 = intl.Intl.pluralLogic(
      motifs,
      locale: localeName,
      other: '$motifs motifs',
      one: '1 motif',
    );
    String _temp1 = intl.Intl.pluralLogic(
      tales,
      locale: localeName,
      other: '$tales tales',
      one: '1 tale',
    );
    return '$_temp0 from $_temp1';
  }

  @override
  String get offerWaitingStore => 'Waiting for the store…';

  @override
  String offerDownloading(int percent) {
    return 'Downloading tales… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return 'Buy $name: $_temp0 for $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return 'Download $name: $_temp0 free ($size)';
  }

  @override
  String offerDownloadOwned(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return 'Download $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTooltip(String name) {
    return 'Download $name';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return 'We\'re preparing $_temp0 from here for the $region pack.';
  }

  @override
  String talesFreeCount(int n) {
    return '$n free';
  }

  @override
  String talesInParts(int n, int parts, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: 'parts',
      one: 'part',
    );
    return '$n in $region $_temp0 $range';
  }

  @override
  String talesTotal(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return '$_temp0';
  }

  @override
  String talesTotalFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '1 tale',
    );
    return '$_temp0 free';
  }

  @override
  String talesYouHave(int n) {
    return 'you have $n';
  }

  @override
  String talesMoreComing(int n) {
    return '$n more coming';
  }

  @override
  String get castTitle => 'Who is in the story?';

  @override
  String get castCaption =>
      'Tap a card for a different character. Remove a card with the cross. Music and sounds always come ready with the country\'s pack — only a character\'s picture sometimes takes a moment to finish.';

  @override
  String get castAdd => 'Add a character';

  @override
  String get castCount => 'Cast: ';

  @override
  String get castShuffleAll => 'Shuffle all';

  @override
  String get next => 'Continue →';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get motifTaskTitle => 'What\'s the quest?';

  @override
  String get motifProblemTitle => 'What\'s the trouble?';

  @override
  String get motifEndingTitle => 'How does it end?';

  @override
  String get motifTaskCaption => 'Tap a card to pick the hero\'s quest.';

  @override
  String get motifProblemCaption =>
      'Tap a card to pick an obstacle or a villain.';

  @override
  String get motifEndingCaption => 'Tap a card to pick a happy ending.';

  @override
  String get outlineTitle => 'Outline';

  @override
  String get outlineSummary => 'The story in brief';

  @override
  String get outlineCharacters => 'Characters';

  @override
  String get outlineTask => 'Quest';

  @override
  String get outlineProblem => 'Trouble';

  @override
  String get outlineEnding => 'Ending';

  @override
  String get outlineAgain => 'Start over';

  @override
  String get outlineTell => 'I\'m telling it →';

  @override
  String get outlineHero => 'The hero';

  @override
  String get beatCastTitle => 'Who\'s in it';

  @override
  String get beatTaskTitle => 'What the hero set out to do';

  @override
  String get beatProblemTitle => 'What stood in the way';

  @override
  String get beatEndingTitle => 'How it turned out';

  @override
  String get beatCastCaption =>
      'Introduce the characters. Where are they, what do they look like, what\'s special about them?';

  @override
  String get beatTaskCaption => 'Say what the hero wants and why they set off.';

  @override
  String get beatProblemCaption =>
      'Put something in the way. Let it look for a while as if it can\'t be done.';

  @override
  String get beatEndingCaption =>
      'Bring it to an end. Don\'t rush — the ending is what a child remembers most.';

  @override
  String get narrNoEmbedder => 'the hint model isn\'t in this build';

  @override
  String get narrGenericFallback =>
      'Nothing from the pack for this yet — a general hint:';

  @override
  String get narrNotComposed => 'This story isn\'t put together any more.';

  @override
  String get narrComposeNew => 'Make a new one';

  @override
  String narrTitle(int i, int n) {
    return 'You\'re telling — $i of $n';
  }

  @override
  String narrBridge(String bridge) {
    return 'How to carry on: $bridge';
  }

  @override
  String get narrWhatsHappening =>
      'What\'s happening right now? (optional, you can dictate)';

  @override
  String get narrHintNote =>
      'A hint — don\'t read it out, just push off from it.';

  @override
  String get narrHintGeneric => 'general';

  @override
  String get narrHintMotif => 'for the motif';

  @override
  String get narrSoundsNote => 'Sounds — play one when it fits the story.';

  @override
  String get narrMoodTense => 'tension';

  @override
  String get narrMoodCalm => 'calm';

  @override
  String get narrSearching => 'Looking…';

  @override
  String get narrHint => 'Give me a hint';

  @override
  String get narrAnother => 'One more';

  @override
  String get back => 'Back';

  @override
  String get narrEnd => 'The end';

  @override
  String get narrNext => 'Next →';

  @override
  String get narrGoodNight => 'Good night.';

  @override
  String get narrGoodNightBody =>
      'We can\'t make a final picture or save to a Library yet — this story isn\'t going anywhere, it stayed between the two of you.';

  @override
  String get close => 'Close';

  @override
  String get artExact => 'illustration · for this motif';

  @override
  String get artSimilar => 'illustration · a similar scene';

  @override
  String get artCard => 'motif card · no scene for this step yet';

  @override
  String get packDownloadFailed => 'Couldn\'t download the tales.';

  @override
  String get packPartUnavailable => 'This part can\'t be bought right now.';

  @override
  String get packPurchasePending =>
      'The purchase is waiting for approval. The part will download once it goes through.';

  @override
  String get packPurchaseFailed => 'The purchase didn\'t go through.';

  @override
  String get packScenesFailed => 'Couldn\'t download the pictures.';

  @override
  String get packNoDownloads => 'Downloads aren\'t available here.';

  @override
  String get packOffline =>
      'We\'re offline — try again when there\'s a signal.';

  @override
  String get restoreNone => 'There are no purchases on this account.';

  @override
  String restoreDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Restored $n parts. Download them from the planet.',
      one: 'Restored 1 part. Download it from the planet.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Couldn\'t restore purchases — try again when there\'s a signal.';

  @override
  String get storageTitle => 'Downloaded stories';

  @override
  String get storageEmpty =>
      'Nothing yet — more tales download from the planet.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n packs',
      one: '1 pack',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String iso) {
    return 'Scenes $iso';
  }

  @override
  String get storageFree => 'free';

  @override
  String get storageBought => 'purchased';

  @override
  String get storageDelete => 'Delete';

  @override
  String storageScenesSubtitle(String size) {
    return 'A picture for every step of the telling · $size · free';
  }

  @override
  String get storageDownload => 'Download';

  @override
  String get storageNothingFreed => 'Everything was used in the last 30 days.';

  @override
  String storageFreed(String size) {
    return 'Freed $size.';
  }

  @override
  String get storageFreeUp => 'Free up space (unused for 30 days)';

  @override
  String get storageRestoring => 'Restoring purchases…';

  @override
  String get storageRestore => 'Restore purchases';

  @override
  String get decimalSeparator => '.';
}
