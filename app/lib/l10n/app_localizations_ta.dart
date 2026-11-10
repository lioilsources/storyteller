// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Tamil (`ta`).
class AppLocalizationsTa extends AppLocalizations {
  AppLocalizationsTa([String locale = 'ta']) : super(locale);

  @override
  String get castTitle => 'கதையில் யார் யார் இருப்பார்கள்?';

  @override
  String get castHint =>
      'வேறு கதாபாத்திரத்தைப் பெற அட்டையைத் தொடவும். அட்டையை நீக்க அடுக்குக் குறியை அழுத்தவும். இசையும் ஒலிகளும் எப்போதும் நாட்டின் பேக்கிலிருந்து தயாராக இருக்கும், கதாபாத்திரத்தின் படம் மட்டும் சில நேரம் சற்று தாமதமாக வரையப்படும்.';

  @override
  String get castAdd => 'கதாபாத்திரத்தைச் சேர்';

  @override
  String get castCount => 'கதாபாத்திரங்கள்:';

  @override
  String get castShuffleAll => 'அனைத்தையும் கலக்கு';

  @override
  String get castContinue => 'தொடர் →';

  @override
  String get shuffle => 'கலக்கு';

  @override
  String get motifTaskTitle => 'எந்தப் பணி?';

  @override
  String get motifProblemTitle => 'எந்தப் பிரச்சினை?';

  @override
  String get motifEndingTitle => 'எப்படிப்பட்ட முடிவு?';

  @override
  String get motifTaskCaption =>
      'நாயகனின் பணியைத் தேர்ந்தெடுக்க அட்டையைத் தொடவும்.';

  @override
  String get motifProblemCaption =>
      'தடை அல்லது வில்லனைத் தேர்ந்தெடுக்க அட்டையைத் தொடவும்.';

  @override
  String get motifEndingCaption =>
      'மகிழ்ச்சியான முடிவைத் தேர்ந்தெடுக்க அட்டையைத் தொடவும்.';

  @override
  String get beatCastTitle => 'கதையில் யார் இருக்கிறார்கள்';

  @override
  String get beatTaskTitle => 'நாயகன் என்ன முடிவு செய்தான்';

  @override
  String get beatProblemTitle => 'வழியில் என்ன குறுக்கிட்டது';

  @override
  String get beatEndingTitle => 'கடைசியில் என்ன ஆனது';

  @override
  String get beatCastCaption =>
      'கதாபாத்திரங்களை அறிமுகப்படுத்துங்கள்: அவர்கள் எங்கே, எப்படி இருக்கிறார்கள், அவர்களிடம் என்ன சிறப்பு.';

  @override
  String get beatTaskCaption =>
      'நாயகன் எதை விரும்புகிறான், ஏன் புறப்பட்டான் என்று சொல்லுங்கள்.';

  @override
  String get beatProblemCaption =>
      'அவன் வழியில் ஏதாவது வையுங்கள். சிறிது நேரம் இது நடக்காது என்று தோன்றட்டும்.';

  @override
  String get beatEndingCaption =>
      'கதையை முடிவு வரை கொண்டு செல்லுங்கள். அவசரம் வேண்டாம், குழந்தை முடிவைத்தான் அதிகம் நினைவில் வைத்திருக்கும்.';

  @override
  String get hintHero => 'நாயகன்';

  @override
  String hintCast1(String who) {
    return 'முதல் முறை தோன்றும்போது «$who» எப்படி இருக்கிறார்?';
  }

  @override
  String hintCast2(String who) {
    return 'முழுக் கதையும் தொடங்குவதற்கு சற்று முன் «$who» என்ன செய்கிறார்?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» எதற்குப் பயப்படுகிறார்?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» வருகிறார் என்று நீங்கள் எப்படி அறிவீர்கள்?';
  }

  @override
  String get hintCast5 =>
      'இவர்களில் யார் நீண்ட நாளாக ஒருவரை ஒருவர் அறிவார்கள், எங்கிருந்து?';

  @override
  String get hintCast6 => 'அவர்கள் சந்திக்கும்போது வானிலை எப்படி இருக்கிறது?';

  @override
  String hintCast7(String who) {
    return '«$who» இன் பையில் என்ன இருக்கிறது?';
  }

  @override
  String hintTask1(String who) {
    return 'பணியில் இறங்கியே ஆக வேண்டும் என்று «$who» எப்போது புரிந்துகொள்கிறார்?';
  }

  @override
  String hintTask2(String who) {
    return 'ஆலோசனை சொன்னவர் யார், «$who» ஏன் அதைக் கேட்கிறார்?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» வீட்டில் எதை விட்டுச் செல்ல வேண்டும்?';
  }

  @override
  String get hintTask4 => 'பாதை எவ்வளவு நீளம், அது எதைக் கடந்து செல்கிறது?';

  @override
  String hintTask5(String who) {
    return 'புறப்படும் முன் «$who» தனக்குத்தானே என்ன சத்தியம் செய்கிறார்?';
  }

  @override
  String get hintTask6 => 'வேறு யாரும் இதைச் செய்ய முடியாதது ஏன்?';

  @override
  String get hintProblem1 =>
      'அந்த நொடியில் ஒரு சத்தம் கேட்கிறது, எப்படிப்பட்டது?';

  @override
  String get hintProblem2 => 'முதலில் என்ன தவறாகிறது?';

  @override
  String hintProblem3(String who) {
    return '«$who» முதலில் என்ன முயல்கிறார், அது ஏன் பலிக்கவில்லை?';
  }

  @override
  String get hintProblem4 => 'உதவ முடிந்தும் யார் மறுக்கிறார்கள்?';

  @override
  String get hintProblem5 => 'இப்போது எல்லோரும் கைவிட்டால் என்ன நடக்கும்?';

  @override
  String get hintProblem6 => 'அந்தத் தடையில் ஏதாவது சோகம் இருக்கிறதா?';

  @override
  String hintProblem7(String who) {
    return 'அந்த நொடியில் «$who» சத்தமாக என்ன சொல்கிறார்?';
  }

  @override
  String hintEnding1(String who) {
    return 'கடைசியில் «$who» அதை எப்படி முறியடிக்கிறார், வலிமையாலா அல்லது யோசனையாலா?';
  }

  @override
  String get hintEnding2 => 'தேவையில்லாத போதும் யார் உதவுகிறார்கள்?';

  @override
  String hintEnding3(String who) {
    return 'எல்லாம் முடிந்ததும் «$who» முதலில் என்ன செய்கிறார்?';
  }

  @override
  String get hintEnding4 => 'தொடக்கத்தை விட முடிவில் என்ன வேறுபட்டிருக்கிறது?';

  @override
  String hintEnding5(String who) {
    return '«$who» எங்கே திரும்புகிறார், அங்கே யார் காத்திருக்கிறார்கள்?';
  }

  @override
  String get hintEnding6 => 'விளக்கு எரிவதற்கு முன் கடைசி வாக்கியம் எது?';

  @override
  String get globeLoading => 'கோளைத் தயார் செய்கிறேன்…';

  @override
  String get globeLoadFailed => 'கோளை ஏற்ற முடியவில்லை.';

  @override
  String get globeTitle => 'கதை எங்கிருந்து வரவேண்டும்?';

  @override
  String get globeStored => 'பதிவிறக்கிய கதைகள்';

  @override
  String get globeHintFar =>
      'கோளைச் சுழற்றுங்கள் அல்லது ஒரு நாட்டைத் தொடுங்கள். பச்சை நாடுகளுக்கு நம் தொகுப்பிலிருந்து கதைகள் உள்ளன, சாம்பல் நாடுகளுக்கு இன்னும் இல்லை.';

  @override
  String get globeHintNear =>
      'ஒரு நாடு அல்லது கட்டடத்தைத் தொடுங்கள். பச்சை நாடுகளுக்கு நம் தொகுப்பிலிருந்து கதைகள் உள்ளன, சாம்பல் நாடுகளுக்கு இன்னும் இல்லை.';

  @override
  String get globeWhole => 'முழு கோள்';

  @override
  String get globeZoomIn => 'அருகில் கொண்டுவா';

  @override
  String get globeZoomOut => 'தொலைவில் கொண்டுசெல்';

  @override
  String globeZoomToRegion(String name) {
    return '$name ஐ அருகில் கொண்டுவா →';
  }

  @override
  String get globeTellHere => 'இங்கிருந்து ஒரு கதை சொல்';

  @override
  String globeTellFrom(String place) {
    return '$place கதை சொல் →';
  }

  @override
  String get globeOpenSea => 'திறந்த கடல்';

  @override
  String globeRegionCountries(int n) {
    return '$n நாடுகள் சேர்ந்து. அருகில் கொண்டுவந்து ஒன்றைத் தேர்ந்தெடுக்கவும்.';
  }

  @override
  String get globeTurnToCountry =>
      'கோளை ஏதாவது ஒரு நாட்டின் பக்கம் திருப்புங்கள்.';

  @override
  String get globeSpin => 'சுழற்று';

  @override
  String get globeNoTales => 'இங்கிருந்து இன்னும் எங்களிடம் கதைகள் இல்லை.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கூறுகள்',
      one: '$n கூறு',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகளிலிருந்து',
      one: '$n கதையிலிருந்து',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + பேக்கிலிருந்து $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'பேக்கிலிருந்து $n கூறுகள்',
      one: 'பேக்கிலிருந்து $n கூறு',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகளை',
      one: '$n கதையை',
    );
    return 'இங்கிருந்து $_temp0 $region பேக்கிற்காகத் தயார் செய்கிறோம்.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகள்',
      one: '$n கதை',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகள்',
      one: '$n கதை',
    );
    return '$_temp0 இலவசம்';
  }

  @override
  String cardFree(int n) {
    return '$n இலவசம்';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range பகுதிகளில் $n',
      one: '$region $range பகுதியில் $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'உங்களிடம் $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'இன்னும் $n வருகின்றன',
      one: 'இன்னும் $n வருகிறது',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'ஸ்டோருக்காகக் காத்திருக்கிறது…';

  @override
  String offerDownloading(int percent) {
    return 'கதைகளைப் பதிவிறக்குகிறது… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகள்',
      one: '$n கதை',
    );
    return '$name வாங்கு: $_temp0, $price க்கு';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகள்',
      one: '$n கதை',
    );
    return '$name பதிவிறக்கு: $_temp0 இலவசம் ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n கதைகள்',
      one: '$n கதை',
    );
    return '$name பதிவிறக்கு: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name பதிவிறக்கு';
  }

  @override
  String get errDownloadTales => 'கதைகளைப் பதிவிறக்க முடியவில்லை.';

  @override
  String get errDownloadScenes => 'படங்களைப் பதிவிறக்க முடியவில்லை.';

  @override
  String get errNoDownloads => 'இங்கே பதிவிறக்கம் கிடைக்காது.';

  @override
  String get errOffline =>
      'இணைய இணைப்பு இல்லை, சிக்னல் கிடைத்ததும் மீண்டும் முயலுங்கள்.';

  @override
  String get errCannotBuy => 'இந்தப் பகுதியை இப்போது வாங்க முடியாது.';

  @override
  String get buyPending =>
      'வாங்குதல் அனுமதிக்காகக் காத்திருக்கிறது. அனுமதி கிடைத்ததும் பகுதி பதிவிறக்கப்படும்.';

  @override
  String get buyFailed => 'வாங்குதல் நடக்கவில்லை.';

  @override
  String get restoreNone => 'இந்தக் கணக்கில் வாங்குதல்கள் எதுவும் இல்லை.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n பகுதிகள் மீட்கப்பட்டன. கோளிலிருந்து பதிவிறக்கலாம்.',
      one: '$n பகுதி மீட்கப்பட்டது. கோளிலிருந்து பதிவிறக்கலாம்.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'வாங்குதல்களை மீட்க முடியவில்லை, சிக்னல் கிடைத்ததும் மீண்டும் முயலுங்கள்.';

  @override
  String get narrationGone => 'இந்தக் கதை இனி அமைக்கப்படவில்லை.';

  @override
  String get narrationNew => 'புதியதை அமையுங்கள்';

  @override
  String narrationTitle(int index, int total) {
    return 'நீங்கள் சொல்கிறீர்கள் — $total இல் $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'எப்படி இணைப்பது: $bridge';
  }

  @override
  String get narrationSituation =>
      'இப்போது என்ன நடக்கிறது? (விருப்பம், சொல்லி எழுதவைக்கலாம்)';

  @override
  String get narrationHintNote =>
      'குறிப்பு, இதை உரக்கச் சொல்லாதீர்கள், இதிலிருந்து தொடங்குங்கள் போதும்.';

  @override
  String get narrationSoundsNote =>
      'ஒலிகள், கதைக்குப் பொருந்தும்போது இயக்குங்கள்.';

  @override
  String get moodTense => 'பதற்றம்';

  @override
  String get moodCalm => 'அமைதி';

  @override
  String get narrationSearching => 'தேடுகிறேன்…';

  @override
  String get narrationHint => 'குறிப்பு கொடு';

  @override
  String get narrationMoreHint => 'இன்னொன்று';

  @override
  String get narrationBack => 'பின்';

  @override
  String get narrationEnd => 'முற்றும்';

  @override
  String get narrationNext => 'அடுத்து →';

  @override
  String get narrationGoodnight => 'இனிய இரவு.';

  @override
  String get narrationEndNote =>
      'இறுதிப் படமும் நூலகத்தில் சேமிப்பதும் எங்களுக்கு இன்னும் முடியவில்லை. இந்தக் கதை எங்கும் போவதில்லை, உங்களிடையே தங்கிவிடுகிறது.';

  @override
  String get narrationClose => 'மூடு';

  @override
  String get ragFallback =>
      'இதற்கு பேக்கில் இன்னும் எதுவும் இல்லை, ஒரு பொதுவான குறிப்பு:';

  @override
  String get ragNoModel => 'குறிப்பு மாதிரி இந்தப் பதிப்பில் இல்லை.';

  @override
  String get ragHintGeneral => 'பொது';

  @override
  String get ragHintMotif => 'கூறுக்கு';

  @override
  String get captionExact => 'விளக்கப்படம் · இந்தக் கூறுக்கு';

  @override
  String get captionSimilar => 'விளக்கப்படம் · ஒத்த காட்சி';

  @override
  String get captionCard => 'கூறு அட்டை · இந்தப் படிக்கு இன்னும் காட்சி இல்லை';

  @override
  String get storageTitle => 'பதிவிறக்கிய கதைகள்';

  @override
  String get storageEmpty =>
      'இன்னும் எதுவும் இல்லை, மேலும் கதைகள் கோளிலிருந்து பதிவிறக்கப்படும்.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n பேக்குகள்',
      one: '$n பேக்',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name காட்சிகள்';
  }

  @override
  String get storageFreeTier => 'இலவசம்';

  @override
  String get storageBoughtTier => 'வாங்கியது';

  @override
  String get storageDelete => 'நீக்கு';

  @override
  String get storageScenesSub => 'சொல்லலின் ஒவ்வொரு படிக்கும் ஒரு படம்';

  @override
  String get storageDownload => 'பதிவிறக்கு';

  @override
  String get storageAllUsed =>
      'கடந்த 30 நாட்களில் அனைத்தும் பயன்படுத்தப்பட்டன.';

  @override
  String storageFreed(String size) {
    return '$size விடுவிக்கப்பட்டது.';
  }

  @override
  String get storageFreeUp => 'இடத்தை விடுவி (30 நாட்கள் பயன்படுத்தாதது)';

  @override
  String get storageRestoring => 'வாங்குதல்களை மீட்கிறது…';

  @override
  String get storageRestore => 'வாங்குதல்களை மீட்டெடு';

  @override
  String get osnovaTitle => 'வடிவம்';

  @override
  String get osnovaSummary => 'கதை சுருக்கமாக';

  @override
  String get osnovaCharacters => 'கதாபாத்திரங்கள்';

  @override
  String get osnovaTask => 'பணி';

  @override
  String get osnovaProblem => 'பிரச்சினை';

  @override
  String get osnovaEnding => 'முடிவு';

  @override
  String get osnovaAgain => 'மீண்டும்';

  @override
  String get osnovaTell => 'நான் சொல்கிறேன் →';

  @override
  String get outlineHero => 'நாயகன்';

  @override
  String get castFox => 'புத்திசாலி நரி';

  @override
  String get castSmithSon => 'கொல்லனின் மகன்';

  @override
  String get castMill => 'பேசும் ஆலை';

  @override
  String get castGooseGirl => 'வாத்து மேய்க்கும் சிறுமி';

  @override
  String get castBrothers => 'மூன்று சகோதரர்கள்';

  @override
  String get castClockworkPrincess => 'கடிகாரம் செய்பவரின் இளவரசி';

  @override
  String get castOwl => 'ஞானமுள்ள ஆந்தை';

  @override
  String get castBlacksmith => 'வயதான கொல்லத்தி';

  @override
  String get castDragon => 'குட்டி டிராகன்';

  @override
  String get castWaterSprite => 'நீர்ப்பேய்';

  @override
  String get castFourPrincesses => 'நான்கு இளவரசிகள்';

  @override
  String get castTravelingTailor => 'அலைந்து திரியும் தையல்காரர்';

  @override
  String get castTalkingCat => 'பேசும் பூனை';

  @override
  String get castForestHermit => 'காட்டுத் துறவி';

  @override
  String get castC0AndersenTheShadow => 'ஒருகாலத்தில் நிழலாக இருந்த பிரபு';

  @override
  String get castC1GrimmTheGooseGirl => 'துரோகம் செய்யும் பணிப்பெண்';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'பேய் கோட்டை உள்ள அரசர்';

  @override
  String get castC3AndersenTheShadow => 'தந்திரமான நிழல்';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'அழகான ஆனால் அவ்வளவு புத்திசாலி அல்லாத இளவரசி';

  @override
  String get castC5AndersenTheRedShoes => 'இறுதியில் மன்னிக்கும் தேவதூதன்';

  @override
  String get castC6GrimmRumpelstiltskin => 'ஆலை உரிமையாளரின் புத்திசாலி மகள்';

  @override
  String get castC7PerraultLittleRedRidingHood => 'கதவைத் திறக்கும் பாட்டி';

  @override
  String get castC8PerraultLittleThumb =>
      'வறுமைக்கும் அன்புக்கும் இடையிலான தாய்';

  @override
  String get castC9PerraultIntroduction => 'பொறுமையான பெண்';

  @override
  String get castC10AndersenTheRealPrincess => 'மகனுக்கு ஆதரவளிக்கும் அரசர்';

  @override
  String get castC11GrimmLilyAndTheLion => 'வாக்கைக் காப்பாற்றும் மகள்';

  @override
  String get castC12AndersenTheRealPrincess =>
      'உண்மையான இளவரசியைத் தேடும் இளவரசன்';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'தீப்பெட்டி விற்கும் சிறுமி';

  @override
  String get castC14AndersenTheEmperorSNewClothes =>
      'மௌனம் காக்கும் அரசவையினர்';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'விருந்து தயாரிக்கும் நம்பிக்கையான வேலைக்காரர்';

  @override
  String get castC16PerraultTheFairy => 'அகங்காரமுள்ள மகள்';

  @override
  String get castC17GrimmFirstStory => 'ஒன்பது வால் வேண்டும் என்ற விதவை';

  @override
  String get motifTaskWine => 'ஒரு பாதாள அறை நிறைய மதுவை யார் குடிப்பார்';

  @override
  String get motifTaskDiamonds => 'வைரங்களைத் தேடி ஒரு பறத்தல்';

  @override
  String get motifTaskRingDuck => 'வாத்துக்குள் மோதிரம்';

  @override
  String get motifTaskGiants => 'ராட்சதர்களை ஏமாற்றுவது';

  @override
  String get motifTaskTomThumb => 'கட்டை விரல் சிறுவனின் தப்பித்தல்';

  @override
  String get motifTaskSwineherd => 'இளவரசியின் மனதை வெல்வது';

  @override
  String get motifTaskBell => 'காட்டில் மர்மமான மணி';

  @override
  String get motifTaskGoldenObject => 'தவறாகப் பயன்படுத்தக் கூடாத பரிசு';

  @override
  String get motifTaskPebbles => 'கூழாங்கற்களின் ஒற்றையடிப் பாதை';

  @override
  String get motifProblemFoxPride => 'நரியின் கர்வம்';

  @override
  String get motifProblemLazySister => 'சோம்பேறி சகோதரி';

  @override
  String get motifProblemWitchBoots => 'ஏழு காதம் செருப்பணிந்த மாயக்காரி';

  @override
  String get motifProblemTailorDoubt => 'யாரும் அவனை நம்புவதில்லை';

  @override
  String get motifProblemLions => 'வாசலில் பசியுள்ள சிங்கங்கள்';

  @override
  String get motifProblemEagle => 'கழுகும் குள்ளனும்';

  @override
  String get motifProblemTruth => 'மாயவிலங்கு உண்மையை வெளிப்படுத்துகிறது';

  @override
  String get motifProblemOldHouse => 'பழைய வீட்டை யாரும் விரும்பவில்லை';

  @override
  String get motifProblemBreadcrumbs => 'பறவைகள் துணுக்குகளைத் தின்றுவிட்டன';

  @override
  String get motifEndingTrickWins => 'தந்திரம் வெல்கிறது';

  @override
  String get motifEndingTruthChild => 'குழந்தை உண்மையைச் சொல்கிறது';

  @override
  String get motifEndingNewHome => 'புதிய வீடு, பழைய நண்பர்கள்';

  @override
  String get motifEndingHappyTogether => 'என்றென்றும் மகிழ்ச்சியாக ஒன்றாக';

  @override
  String get motifEndingKissWakes => 'ஒரு முத்தம் அரசை எழுப்புகிறது';

  @override
  String get motifEndingLeapfrog => 'தந்திரம் மிக உயரத்தில் தாவுகிறது';

  @override
  String get motifEndingCurseBroken => 'சாபம் முறிந்தது';

  @override
  String get motifEndingWelcomedHome => 'வீட்டில் வரவேற்பு';

  @override
  String get motifEndingSlipper => 'தொலைந்த செருப்பு';
}
