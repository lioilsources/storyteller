// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get castTitle => 'Who will be in the tale?';

  @override
  String get castHint =>
      'Tap a card to get a different character. Remove a card with the cross. Music and sounds always come ready from the country pack — only the character picture is sometimes drawn a moment later.';

  @override
  String get castAdd => 'Add a character';

  @override
  String get castCount => 'Cast:';

  @override
  String get castShuffleAll => 'Shuffle all';

  @override
  String get castContinue => 'Continue →';

  @override
  String get shuffle => 'Shuffle';

  @override
  String get motifTaskTitle => 'Which task?';

  @override
  String get motifProblemTitle => 'Which problem?';

  @override
  String get motifEndingTitle => 'Which ending?';

  @override
  String get motifTaskCaption => 'Tap a card to pick the hero\'s task.';

  @override
  String get motifProblemCaption =>
      'Tap a card to pick an obstacle or a villain.';

  @override
  String get motifEndingCaption => 'Tap a card to pick a happy ending.';

  @override
  String get beatCastTitle => 'Who is in it';

  @override
  String get beatTaskTitle => 'What the hero set out to do';

  @override
  String get beatProblemTitle => 'What got in the way';

  @override
  String get beatEndingTitle => 'How it ended';

  @override
  String get beatCastCaption =>
      'Introduce the characters. Where they are, what they look like, what is special about them.';

  @override
  String get beatTaskCaption =>
      'Say what the hero wants and why they set out for it.';

  @override
  String get beatProblemCaption =>
      'Put something in the hero\'s way. Let it look for a while as if it will not work out.';

  @override
  String get beatEndingCaption =>
      'Bring it to an end. Do not rush — a child remembers the ending most.';

  @override
  String get hintHero => 'the hero';

  @override
  String hintCast1(String who) {
    return 'What does $who look like when first appearing?';
  }

  @override
  String hintCast2(String who) {
    return 'What is $who doing right before the whole story begins?';
  }

  @override
  String hintCast3(String who) {
    return 'What is $who afraid of?';
  }

  @override
  String hintCast4(String who) {
    return 'How can you tell that $who is coming?';
  }

  @override
  String get hintCast5 =>
      'Which of them have known each other for a long time, and from where?';

  @override
  String get hintCast6 => 'What is the weather like when they meet?';

  @override
  String hintCast7(String who) {
    return 'What does $who have in a pocket?';
  }

  @override
  String hintTask1(String who) {
    return 'When does $who realize they have to get started?';
  }

  @override
  String hintTask2(String who) {
    return 'Who gave the advice, and why does $who listen?';
  }

  @override
  String hintTask3(String who) {
    return 'What does $who have to leave at home?';
  }

  @override
  String get hintTask4 => 'How long is the road, and what does it cross?';

  @override
  String hintTask5(String who) {
    return 'What does $who promise before setting out?';
  }

  @override
  String get hintTask6 => 'Why can nobody else do it?';

  @override
  String get hintProblem1 => 'At that moment a sound is heard — what kind?';

  @override
  String get hintProblem2 => 'What goes wrong first?';

  @override
  String hintProblem3(String who) {
    return 'What does $who try first, and why does it fail?';
  }

  @override
  String get hintProblem4 => 'Who refuses to help even though they could?';

  @override
  String get hintProblem5 => 'What would happen if everyone gave up right now?';

  @override
  String get hintProblem6 => 'Is there something sad about that obstacle?';

  @override
  String hintProblem7(String who) {
    return 'What does $who say out loud at that moment?';
  }

  @override
  String hintEnding1(String who) {
    return 'How does $who finally break it — with strength or with an idea?';
  }

  @override
  String get hintEnding2 => 'Who helps even though they did not have to?';

  @override
  String hintEnding3(String who) {
    return 'What is the very first thing $who does when it is all over?';
  }

  @override
  String get hintEnding4 => 'What is different at the end than at the start?';

  @override
  String hintEnding5(String who) {
    return 'Where does $who return to, and who is waiting there?';
  }

  @override
  String get hintEnding6 =>
      'What is the last sentence before the light comes on?';

  @override
  String get globeLoading => 'Getting the planet ready…';

  @override
  String get globeLoadFailed => 'The planet could not be loaded.';

  @override
  String get globeTitle => 'Where will the tale come from?';

  @override
  String get globeStored => 'Downloaded tales';

  @override
  String get globeHintFar =>
      'Spin the planet or tap a country. Green countries already have tales from our collection, grey ones not yet.';

  @override
  String get globeHintNear =>
      'Tap a country or a building. Green countries already have tales from our collection, grey ones not yet.';

  @override
  String get globeWhole => 'Whole planet';

  @override
  String get globeZoomIn => 'Zoom in';

  @override
  String get globeZoomOut => 'Zoom out';

  @override
  String globeZoomToRegion(String name) {
    return 'Zoom in on $name →';
  }

  @override
  String get globeTellHere => 'Tell a tale from here';

  @override
  String globeTellFrom(String place) {
    return 'Tell a tale from $place →';
  }

  @override
  String get globeOpenSea => 'The open sea';

  @override
  String globeRegionCountries(int n) {
    return '$n countries together. Zoom in and pick one.';
  }

  @override
  String get globeTurnToCountry => 'Turn the planet to a country.';

  @override
  String get globeSpin => 'Spin';

  @override
  String get globeNoTales => 'We do not have any tales from here yet.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motifs',
      one: '$n motif',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'from $n tales',
      one: 'from $n tale',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs from the pack';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motifs from the pack',
      one: '$n motif from the pack',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return 'We are preparing $_temp0 from here for the $region pack.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return '$_temp0 free';
  }

  @override
  String cardFree(int n) {
    return '$n free';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n in parts $region $range',
      one: '$n in part $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'you have $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n more coming',
      one: '$n more coming',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Waiting for the store…';

  @override
  String offerDownloading(int percent) {
    return 'Downloading tales… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return 'Buy $name: $_temp0 for $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return 'Download $name: $_temp0 free ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tales',
      one: '$n tale',
    );
    return 'Download $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Download $name';
  }

  @override
  String get errDownloadTales => 'The tales could not be downloaded.';

  @override
  String get errDownloadScenes => 'The pictures could not be downloaded.';

  @override
  String get errNoDownloads => 'Downloading is not available here.';

  @override
  String get errOffline =>
      'There is no internet connection — try again when you have a signal.';

  @override
  String get errCannotBuy => 'This part cannot be bought right now.';

  @override
  String get buyPending =>
      'The purchase is awaiting approval. The part will download once it goes through.';

  @override
  String get buyFailed => 'The purchase did not go through.';

  @override
  String get restoreNone => 'There are no purchases on this account.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n parts restored. You can download them from the planet.',
      one: '$n part restored. You can download it from the planet.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'The purchases could not be restored — try again when you have a signal.';

  @override
  String get narrationGone => 'This tale is no longer assembled.';

  @override
  String get narrationNew => 'Build a new one';

  @override
  String narrationTitle(int index, int total) {
    return 'You tell — $index of $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'How to continue: $bridge';
  }

  @override
  String get narrationSituation =>
      'What is happening right now? (optional, you can dictate)';

  @override
  String get narrationHintNote =>
      'Hint — do not read it aloud, just use it as a starting point.';

  @override
  String get narrationSoundsNote =>
      'Sounds — play them when they fit the telling.';

  @override
  String get moodTense => 'tension';

  @override
  String get moodCalm => 'calm';

  @override
  String get narrationSearching => 'Searching…';

  @override
  String get narrationHint => 'Give me a hint';

  @override
  String get narrationMoreHint => 'One more';

  @override
  String get narrationBack => 'Back';

  @override
  String get narrationEnd => 'The end';

  @override
  String get narrationNext => 'Next →';

  @override
  String get narrationGoodnight => 'Good night.';

  @override
  String get narrationEndNote =>
      'We cannot yet make a closing picture or save to the Library — this tale goes nowhere, it stays between you.';

  @override
  String get narrationClose => 'Close';

  @override
  String get ragFallback =>
      'Nothing from the pack for this yet — a general hint:';

  @override
  String get ragNoModel => 'The hint model is not part of this build.';

  @override
  String get ragHintGeneral => 'general';

  @override
  String get ragHintMotif => 'for the motif';

  @override
  String get captionExact => 'illustration · for this motif';

  @override
  String get captionSimilar => 'illustration · a similar scene';

  @override
  String get captionCard =>
      'motif card · we do not have a scene for this step yet';

  @override
  String get storageTitle => 'Downloaded tales';

  @override
  String get storageEmpty =>
      'Nothing yet — more tales are downloaded from the planet.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n packs',
      one: '$n pack',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name scenes';
  }

  @override
  String get storageFreeTier => 'free';

  @override
  String get storageBoughtTier => 'purchased';

  @override
  String get storageDelete => 'Delete';

  @override
  String get storageScenesSub => 'A picture for every step of the telling';

  @override
  String get storageDownload => 'Download';

  @override
  String get storageAllUsed => 'Everything was used in the last 30 days.';

  @override
  String storageFreed(String size) {
    return '$size freed.';
  }

  @override
  String get storageFreeUp => 'Free up space (unused for 30 days)';

  @override
  String get storageRestoring => 'Restoring purchases…';

  @override
  String get storageRestore => 'Restore purchases';

  @override
  String get osnovaTitle => 'Outline';

  @override
  String get osnovaSummary => 'The tale in brief';

  @override
  String get osnovaCharacters => 'Characters';

  @override
  String get osnovaTask => 'Task';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Ending';

  @override
  String get osnovaAgain => 'Start over';

  @override
  String get osnovaTell => 'I\'ll tell it →';

  @override
  String get outlineHero => 'The hero';

  @override
  String get castFox => 'The clever fox';

  @override
  String get castSmithSon => 'The blacksmith\'s son';

  @override
  String get castMill => 'The talking mill';

  @override
  String get castGooseGirl => 'The goose girl';

  @override
  String get castBrothers => 'The three brothers';

  @override
  String get castClockworkPrincess => 'The clockmaker princess';

  @override
  String get castOwl => 'The wise owl';

  @override
  String get castBlacksmith => 'The old blacksmith woman';

  @override
  String get castDragon => 'The little dragon';

  @override
  String get castWaterSprite => 'The water sprite';

  @override
  String get castFourPrincesses => 'The four princesses';

  @override
  String get castTravelingTailor => 'The wandering tailor';

  @override
  String get castTalkingCat => 'The talking cat';

  @override
  String get castForestHermit => 'The forest hermit';

  @override
  String get castC0AndersenTheShadow => 'The master who used to be a shadow';

  @override
  String get castC1GrimmTheGooseGirl => 'The treacherous maid';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'The king with the haunted castle';

  @override
  String get castC3AndersenTheShadow => 'The clever shadow';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'The beautiful but not so clever princess';

  @override
  String get castC5AndersenTheRedShoes => 'The angel who forgives in the end';

  @override
  String get castC6GrimmRumpelstiltskin => 'The miller\'s clever daughter';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'The grandmother who opens the door';

  @override
  String get castC8PerraultLittleThumb => 'A mother between poverty and love';

  @override
  String get castC9PerraultIntroduction => 'The patient woman';

  @override
  String get castC10AndersenTheRealPrincess => 'The king who backs his son';

  @override
  String get castC11GrimmLilyAndTheLion => 'The daughter who keeps her word';

  @override
  String get castC12AndersenTheRealPrincess =>
      'The prince looking for the real one';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'The little match girl';

  @override
  String get castC14AndersenTheEmperorSNewClothes =>
      'The courtier who stays silent';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'The loyal servant preparing a feast';

  @override
  String get castC16PerraultTheFairy => 'The conceited daughter';

  @override
  String get castC17GrimmFirstStory => 'The widow who wants nine tails';

  @override
  String get motifTaskWine => 'Who will drink a cellar of wine';

  @override
  String get motifTaskDiamonds => 'A flight for diamonds';

  @override
  String get motifTaskRingDuck => 'The ring in the duck';

  @override
  String get motifTaskGiants => 'Outwit the giants';

  @override
  String get motifTaskTomThumb => 'Tom Thumb\'s escape';

  @override
  String get motifTaskSwineherd => 'Win the princess\'s heart';

  @override
  String get motifTaskBell => 'The mysterious bell in the forest';

  @override
  String get motifTaskGoldenObject => 'A gift that must not be misused';

  @override
  String get motifTaskPebbles => 'A trail of pebbles';

  @override
  String get motifProblemFoxPride => 'The fox\'s pride';

  @override
  String get motifProblemLazySister => 'The lazy sister';

  @override
  String get motifProblemWitchBoots => 'The witch in seven-league boots';

  @override
  String get motifProblemTailorDoubt => 'Nobody believes him';

  @override
  String get motifProblemLions => 'Hungry lions at the gate';

  @override
  String get motifProblemEagle => 'The eagle and the dwarf';

  @override
  String get motifProblemTruth => 'The magic animal reveals the truth';

  @override
  String get motifProblemOldHouse => 'Nobody wants the old house';

  @override
  String get motifProblemBreadcrumbs => 'The birds ate the crumbs';

  @override
  String get motifEndingTrickWins => 'Cleverness wins';

  @override
  String get motifEndingTruthChild => 'The child tells the truth';

  @override
  String get motifEndingNewHome => 'A new home, old friends';

  @override
  String get motifEndingHappyTogether => 'Happily together forever';

  @override
  String get motifEndingKissWakes => 'A kiss wakes the kingdom';

  @override
  String get motifEndingLeapfrog => 'Cleverness leaps highest';

  @override
  String get motifEndingCurseBroken => 'The curse is broken';

  @override
  String get motifEndingWelcomedHome => 'Welcomed home';

  @override
  String get motifEndingSlipper => 'The lost slipper';
}
