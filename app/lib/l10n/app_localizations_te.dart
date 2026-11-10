// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Telugu (`te`).
class AppLocalizationsTe extends AppLocalizations {
  AppLocalizationsTe([String locale = 'te']) : super(locale);

  @override
  String get castTitle => 'కథలో ఎవరెవరు ఉంటారు?';

  @override
  String get castHint =>
      'మరో పాత్ర కోసం కార్డును తాకండి. కార్డును తొలగించడానికి క్రాస్ నొక్కండి. సంగీతం, శబ్దాలు ఎల్లప్పుడూ దేశ ప్యాక్ నుండి సిద్ధంగా ఉంటాయి, పాత్ర చిత్రం మాత్రం కొన్నిసార్లు కొద్దిగా ఆలస్యంగా గీయబడుతుంది.';

  @override
  String get castAdd => 'పాత్రను జోడించండి';

  @override
  String get castCount => 'పాత్రలు:';

  @override
  String get castShuffleAll => 'అన్నింటినీ కలపండి';

  @override
  String get castContinue => 'కొనసాగించండి →';

  @override
  String get shuffle => 'కలపండి';

  @override
  String get motifTaskTitle => 'ఏ పని?';

  @override
  String get motifProblemTitle => 'ఏ సమస్య?';

  @override
  String get motifEndingTitle => 'ఎలాంటి ముగింపు?';

  @override
  String get motifTaskCaption => 'హీరో పనిని ఎంచుకోవడానికి కార్డును తాకండి.';

  @override
  String get motifProblemCaption =>
      'అడ్డంకి లేదా విలన్‌ను ఎంచుకోవడానికి కార్డును తాకండి.';

  @override
  String get motifEndingCaption => 'సుఖాంతాన్ని ఎంచుకోవడానికి కార్డును తాకండి.';

  @override
  String get beatCastTitle => 'కథలో ఎవరున్నారు';

  @override
  String get beatTaskTitle => 'హీరో ఏమి నిశ్చయించాడు';

  @override
  String get beatProblemTitle => 'దారిలో ఏమి అడ్డుపడింది';

  @override
  String get beatEndingTitle => 'చివరికి ఏమైంది';

  @override
  String get beatCastCaption =>
      'పాత్రలను పరిచయం చేయండి: వారు ఎక్కడ ఉన్నారు, ఎలా ఉంటారు, వారిలో ప్రత్యేకత ఏమిటి.';

  @override
  String get beatTaskCaption =>
      'హీరో ఏమి కోరుకుంటున్నాడో, ఎందుకు బయలుదేరాడో చెప్పండి.';

  @override
  String get beatProblemCaption =>
      'అతని దారిలో ఏదైనా పెట్టండి. కాసేపు ఇది జరగదేమో అనిపించనివ్వండి.';

  @override
  String get beatEndingCaption =>
      'కథను ముగింపు వరకు తీసుకెళ్లండి. తొందర వద్దు, పిల్లలు ముగింపునే ఎక్కువగా గుర్తుంచుకుంటారు.';

  @override
  String get hintHero => 'హీరో';

  @override
  String hintCast1(String who) {
    return 'మొదటిసారి కనిపించినప్పుడు «$who» ఎలా ఉంటాడు?';
  }

  @override
  String hintCast2(String who) {
    return 'కథ మొత్తం మొదలవక ముందు «$who» ఏమి చేస్తున్నాడు?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» దేనికి భయపడతాడు?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» వస్తున్నాడని మీరు ఎలా గుర్తిస్తారు?';
  }

  @override
  String get hintCast5 =>
      'వీరిలో ఎవరు చాలా కాలంగా ఒకరికొకరు తెలుసు, ఎక్కడి నుండి?';

  @override
  String get hintCast6 => 'వారు కలిసినప్పుడు వాతావరణం ఎలా ఉంది?';

  @override
  String hintCast7(String who) {
    return '«$who» జేబులో ఏముంది?';
  }

  @override
  String hintTask1(String who) {
    return 'పని మొదలుపెట్టాల్సిందే అని «$who» కి ఎప్పుడు అర్థమవుతుంది?';
  }

  @override
  String hintTask2(String who) {
    return 'సలహా ఎవరు ఇచ్చారు, «$who» ఎందుకు వింటాడు?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» ఇంట్లో ఏమి వదిలి వెళ్లాలి?';
  }

  @override
  String get hintTask4 => 'దారి ఎంత పొడవు, అది దేని మీదుగా వెళ్తుంది?';

  @override
  String hintTask5(String who) {
    return 'బయలుదేరే ముందు «$who» తనకు తాను ఏమి ప్రమాణం చేసుకుంటాడు?';
  }

  @override
  String get hintTask6 => 'ఇతరులెవరూ దీన్ని ఎందుకు చేయలేరు?';

  @override
  String get hintProblem1 => 'ఆ క్షణంలో ఒక శబ్దం వినిపిస్తుంది, ఎలాంటిది?';

  @override
  String get hintProblem2 => 'మొదట ఏమి చెడిపోతుంది?';

  @override
  String hintProblem3(String who) {
    return '«$who» మొదట ఏమి ప్రయత్నిస్తాడు, అది ఎందుకు ఫలించదు?';
  }

  @override
  String get hintProblem4 => 'సహాయం చేయగలిగినా ఎవరు నిరాకరిస్తారు?';

  @override
  String get hintProblem5 => 'ఇప్పుడు అందరూ వదిలేస్తే ఏమవుతుంది?';

  @override
  String get hintProblem6 => 'ఆ అడ్డంకిలో ఏదైనా విషాదం ఉందా?';

  @override
  String hintProblem7(String who) {
    return 'ఆ క్షణంలో «$who» బిగ్గరగా ఏమి అంటాడు?';
  }

  @override
  String hintEnding1(String who) {
    return 'చివరికి «$who» దాన్ని ఎలా ఛేదిస్తాడు, బలంతోనా లేక ఉపాయంతోనా?';
  }

  @override
  String get hintEnding2 => 'అవసరం లేకపోయినా ఎవరు సహాయం చేస్తారు?';

  @override
  String hintEnding3(String who) {
    return 'అంతా అయిపోయాక «$who» ముందుగా ఏమి చేస్తాడు?';
  }

  @override
  String get hintEnding4 => 'ఆరంభంతో పోలిస్తే చివరలో ఏది భిన్నంగా ఉంది?';

  @override
  String hintEnding5(String who) {
    return '«$who» ఎక్కడికి తిరిగి వెళ్తాడు, అక్కడ ఎవరు ఎదురుచూస్తున్నారు?';
  }

  @override
  String get hintEnding6 => 'లైట్ వెలగడానికి ముందు చివరి వాక్యం ఏమిటి?';

  @override
  String get globeLoading => 'గ్రహాన్ని సిద్ధం చేస్తున్నాను…';

  @override
  String get globeLoadFailed => 'గ్రహాన్ని లోడ్ చేయలేకపోయాం.';

  @override
  String get globeTitle => 'కథ ఎక్కడి నుండి రావాలి?';

  @override
  String get globeStored => 'డౌన్‌లోడ్ చేసిన కథలు';

  @override
  String get globeHintFar =>
      'గ్రహాన్ని తిప్పండి లేదా ఒక దేశాన్ని తాకండి. ఆకుపచ్చ దేశాలకు మా సేకరణలోని కథలు ఉన్నాయి, బూడిద రంగు దేశాలకు ఇంకా లేవు.';

  @override
  String get globeHintNear =>
      'ఒక దేశాన్ని లేదా కట్టడాన్ని తాకండి. ఆకుపచ్చ దేశాలకు మా సేకరణలోని కథలు ఉన్నాయి, బూడిద రంగు దేశాలకు ఇంకా లేవు.';

  @override
  String get globeWhole => 'పూర్తి గ్రహం';

  @override
  String get globeZoomIn => 'దగ్గరకు తీసుకురండి';

  @override
  String get globeZoomOut => 'దూరం చేయండి';

  @override
  String globeZoomToRegion(String name) {
    return '$name ను దగ్గరకు తీసుకురండి →';
  }

  @override
  String get globeTellHere => 'ఇక్కడి కథ చెప్పండి';

  @override
  String globeTellFrom(String place) {
    return '$place కథ చెప్పండి →';
  }

  @override
  String get globeOpenSea => 'తెరిచిన సముద్రం';

  @override
  String globeRegionCountries(int n) {
    return '$n దేశాలు కలిపి. దగ్గరకు తెచ్చి ఒకదాన్ని ఎంచుకోండి.';
  }

  @override
  String get globeTurnToCountry => 'గ్రహాన్ని ఏదైనా దేశం వైపు తిప్పండి.';

  @override
  String get globeSpin => 'తిప్పండి';

  @override
  String get globeNoTales => 'ఇక్కడి నుండి మా వద్ద ఇంకా కథలు లేవు.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n అంశాలు',
      one: '$n అంశం',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథల నుండి',
      one: '$n కథ నుండి',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + ప్యాక్ నుండి $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ప్యాక్ నుండి $n అంశాలు',
      one: 'ప్యాక్ నుండి $n అంశం',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలను',
      one: '$n కథను',
    );
    return 'ఇక్కడి $_temp0 $region ప్యాక్ కోసం సిద్ధం చేస్తున్నాం.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలు',
      one: '$n కథ',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలు',
      one: '$n కథ',
    );
    return '$_temp0 ఉచితం';
  }

  @override
  String cardFree(int n) {
    return '$n ఉచితం';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range భాగాలలో $n',
      one: '$region $range భాగంలో $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'మీ వద్ద $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ఇంకా $n వస్తున్నాయి',
      one: 'ఇంకా $n వస్తోంది',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'స్టోర్ కోసం వేచి ఉంది…';

  @override
  String offerDownloading(int percent) {
    return 'కథలను డౌన్‌లోడ్ చేస్తోంది… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలు',
      one: '$n కథ',
    );
    return '$name కొనండి: $_temp0, $price కు';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలు',
      one: '$n కథ',
    );
    return '$name డౌన్‌లోడ్ చేయండి: $_temp0 ఉచితం ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n కథలు',
      one: '$n కథ',
    );
    return '$name డౌన్‌లోడ్ చేయండి: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name డౌన్‌లోడ్ చేయండి';
  }

  @override
  String get errDownloadTales => 'కథలను డౌన్‌లోడ్ చేయలేకపోయాం.';

  @override
  String get errDownloadScenes => 'చిత్రాలను డౌన్‌లోడ్ చేయలేకపోయాం.';

  @override
  String get errNoDownloads => 'ఇక్కడ డౌన్‌లోడ్ అందుబాటులో లేదు.';

  @override
  String get errOffline =>
      'ఇంటర్నెట్ లేదు, సిగ్నల్ వచ్చాక మళ్లీ ప్రయత్నించండి.';

  @override
  String get errCannotBuy => 'ఈ భాగాన్ని ఇప్పుడు కొనలేరు.';

  @override
  String get buyPending =>
      'కొనుగోలు ఆమోదం కోసం వేచి ఉంది. ఆమోదం రాగానే భాగం డౌన్‌లోడ్ అవుతుంది.';

  @override
  String get buyFailed => 'కొనుగోలు పూర్తి కాలేదు.';

  @override
  String get restoreNone => 'ఈ ఖాతాలో కొనుగోళ్లు ఏవీ లేవు.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n భాగాలు పునరుద్ధరించబడ్డాయి. గ్రహం నుండి డౌన్‌లోడ్ చేసుకోవచ్చు.',
      one: '$n భాగం పునరుద్ధరించబడింది. గ్రహం నుండి డౌన్‌లోడ్ చేసుకోవచ్చు.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'కొనుగోళ్లను పునరుద్ధరించలేకపోయాం, సిగ్నల్ వచ్చాక మళ్లీ ప్రయత్నించండి.';

  @override
  String get narrationGone => 'ఈ కథ ఇక అమర్చబడి లేదు.';

  @override
  String get narrationNew => 'కొత్తది అమర్చండి';

  @override
  String narrationTitle(int index, int total) {
    return 'మీరు చెబుతున్నారు — $total లో $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'ఎలా కలపాలి: $bridge';
  }

  @override
  String get narrationSituation =>
      'ఇప్పుడు ఏమి జరుగుతోంది? (ఐచ్ఛికం, చెప్పి రాయించవచ్చు)';

  @override
  String get narrationHintNote =>
      'సూచన, దీన్ని బిగ్గరగా చెప్పకండి, ఇక్కడినుండి మొదలుపెట్టండి చాలు.';

  @override
  String get narrationSoundsNote => 'శబ్దాలు, కథకు సరిపోయినప్పుడు ప్లే చేయండి.';

  @override
  String get moodTense => 'ఉత్కంఠ';

  @override
  String get moodCalm => 'ప్రశాంతత';

  @override
  String get narrationSearching => 'వెతుకుతోంది…';

  @override
  String get narrationHint => 'సూచన ఇవ్వండి';

  @override
  String get narrationMoreHint => 'ఇంకొకటి';

  @override
  String get narrationBack => 'వెనుకకు';

  @override
  String get narrationEnd => 'సమాప్తం';

  @override
  String get narrationNext => 'తరువాత →';

  @override
  String get narrationGoodnight => 'శుభరాత్రి.';

  @override
  String get narrationEndNote =>
      'చివరి చిత్రం, లైబ్రరీలో భద్రపరచడం మేము ఇంకా చేయలేము. ఈ కథ ఎక్కడికీ వెళ్లదు, మీ ఇద్దరి మధ్యే ఉండిపోతుంది.';

  @override
  String get narrationClose => 'మూసివేయండి';

  @override
  String get ragFallback => 'దీనికి ప్యాక్‌లో ఇంకా ఏమీ లేదు, ఒక సాధారణ సూచన:';

  @override
  String get ragNoModel => 'సూచన మోడల్ ఈ వెర్షన్‌లో లేదు.';

  @override
  String get ragHintGeneral => 'సాధారణ';

  @override
  String get ragHintMotif => 'అంశం కోసం';

  @override
  String get captionExact => 'చిత్రం · ఈ అంశం కోసం';

  @override
  String get captionSimilar => 'చిత్రం · సమానమైన దృశ్యం';

  @override
  String get captionCard => 'అంశం కార్డ్ · ఈ దశకు ఇంకా దృశ్యం లేదు';

  @override
  String get storageTitle => 'డౌన్‌లోడ్ చేసిన కథలు';

  @override
  String get storageEmpty =>
      'ఇంకా ఏమీ లేదు, మరిన్ని కథలు గ్రహం నుండి డౌన్‌లోడ్ అవుతాయి.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ప్యాక్‌లు',
      one: '$n ప్యాక్',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name దృశ్యాలు';
  }

  @override
  String get storageFreeTier => 'ఉచితం';

  @override
  String get storageBoughtTier => 'కొన్నది';

  @override
  String get storageDelete => 'తొలగించండి';

  @override
  String get storageScenesSub => 'చెప్పడంలోని ప్రతి దశకు ఒక చిత్రం';

  @override
  String get storageDownload => 'డౌన్‌లోడ్ చేయండి';

  @override
  String get storageAllUsed => 'గత 30 రోజుల్లో అన్నీ ఉపయోగించబడ్డాయి.';

  @override
  String storageFreed(String size) {
    return '$size ఖాళీ అయ్యింది.';
  }

  @override
  String get storageFreeUp => 'స్థలం ఖాళీ చేయండి (30 రోజులు వాడనివి)';

  @override
  String get storageRestoring => 'కొనుగోళ్లను పునరుద్ధరిస్తోంది…';

  @override
  String get storageRestore => 'కొనుగోళ్లను పునరుద్ధరించండి';

  @override
  String get osnovaTitle => 'రూపురేఖ';

  @override
  String get osnovaSummary => 'క్లుప్తంగా కథ';

  @override
  String get osnovaCharacters => 'పాత్రలు';

  @override
  String get osnovaTask => 'పని';

  @override
  String get osnovaProblem => 'సమస్య';

  @override
  String get osnovaEnding => 'ముగింపు';

  @override
  String get osnovaAgain => 'మళ్లీ';

  @override
  String get osnovaTell => 'నేను చెబుతాను →';

  @override
  String get outlineHero => 'హీరో';

  @override
  String get castFox => 'తెలివైన నక్క';

  @override
  String get castSmithSon => 'కమ్మరి కొడుకు';

  @override
  String get castMill => 'మాట్లాడే మిల్లు';

  @override
  String get castGooseGirl => 'బాతులు మేపే అమ్మాయి';

  @override
  String get castBrothers => 'ముగ్గురు సోదరులు';

  @override
  String get castClockworkPrincess => 'గడియారాల తయారీదారు యువరాణి';

  @override
  String get castOwl => 'జ్ఞాని గుడ్లగూబ';

  @override
  String get castBlacksmith => 'ముసలి కమ్మరి స్త్రీ';

  @override
  String get castDragon => 'చిన్న డ్రాగన్';

  @override
  String get castWaterSprite => 'నీటి భూతం';

  @override
  String get castFourPrincesses => 'నలుగురు యువరాణులు';

  @override
  String get castTravelingTailor => 'తిరుగుబోతు దర్జీ';

  @override
  String get castTalkingCat => 'మాట్లాడే పిల్లి';

  @override
  String get castForestHermit => 'అడవి సన్యాసి';

  @override
  String get castC0AndersenTheShadow => 'ఒకప్పుడు నీడగా ఉన్న ప్రభువు';

  @override
  String get castC1GrimmTheGooseGirl => 'ద్రోహం చేసే పరిచారిక';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'భూతాల కోట ఉన్న రాజు';

  @override
  String get castC3AndersenTheShadow => 'తెలివైన నీడ';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'అందమైన కానీ అంత తెలివి లేని యువరాణి';

  @override
  String get castC5AndersenTheRedShoes => 'చివరికి క్షమించే దేవదూత';

  @override
  String get castC6GrimmRumpelstiltskin => 'మిల్లు యజమాని తెలివైన కూతురు';

  @override
  String get castC7PerraultLittleRedRidingHood => 'తలుపు తెరిచే అమ్మమ్మ';

  @override
  String get castC8PerraultLittleThumb => 'పేదరికం, ప్రేమ మధ్య ఒక తల్లి';

  @override
  String get castC9PerraultIntroduction => 'సహనంగల స్త్రీ';

  @override
  String get castC10AndersenTheRealPrincess => 'కొడుక్కి అండగా నిలిచే రాజు';

  @override
  String get castC11GrimmLilyAndTheLion => 'మాట నిలబెట్టుకునే కూతురు';

  @override
  String get castC12AndersenTheRealPrincess =>
      'నిజమైన యువరాణిని వెతుకుతున్న యువరాజు';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'అగ్గిపెట్టెలు అమ్మే చిన్నారి';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'మౌనంగా ఉండే సభాసదుడు';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'విందు సిద్ధం చేసే నమ్మకమైన సేవకుడు';

  @override
  String get castC16PerraultTheFairy => 'గర్వంగల కూతురు';

  @override
  String get castC17GrimmFirstStory => 'తొమ్మిది తోకలు కావాలనే వితంతువు';

  @override
  String get motifTaskWine => 'ఒక సెల్లార్ నిండా వైన్‌ను ఎవరు తాగుతారు';

  @override
  String get motifTaskDiamonds => 'వజ్రాల కోసం ఒక ప్రయాణం';

  @override
  String get motifTaskRingDuck => 'బాతు లోపల ఉంగరం';

  @override
  String get motifTaskGiants => 'రాక్షసులను మోసగించడం';

  @override
  String get motifTaskTomThumb => 'బొటనవేలంత బాలుడి పలాయనం';

  @override
  String get motifTaskSwineherd => 'యువరాణి హృదయాన్ని గెలుచుకోవడం';

  @override
  String get motifTaskBell => 'అడవిలో రహస్యమైన గంట';

  @override
  String get motifTaskGoldenObject => 'దుర్వినియోగం చేయకూడని బహుమతి';

  @override
  String get motifTaskPebbles => 'గులకరాళ్ల దారి';

  @override
  String get motifProblemFoxPride => 'నక్క అహంకారం';

  @override
  String get motifProblemLazySister => 'సోమరి సోదరి';

  @override
  String get motifProblemWitchBoots => 'ఏడు యోజనాల బూట్లు తొడిగిన మంత్రగత్తె';

  @override
  String get motifProblemTailorDoubt => 'ఎవరూ అతన్ని నమ్మరు';

  @override
  String get motifProblemLions => 'ద్వారం వద్ద ఆకలి సింహాలు';

  @override
  String get motifProblemEagle => 'గద్ద, మరుగుజ్జు';

  @override
  String get motifProblemTruth => 'మాయా జంతువు నిజాన్ని బయటపెడుతుంది';

  @override
  String get motifProblemOldHouse => 'పాత ఇల్లు ఎవరికీ వద్దు';

  @override
  String get motifProblemBreadcrumbs => 'పక్షులు ముక్కలు తినేశాయి';

  @override
  String get motifEndingTrickWins => 'ఉపాయం గెలుస్తుంది';

  @override
  String get motifEndingTruthChild => 'పిల్లవాడు నిజం చెబుతాడు';

  @override
  String get motifEndingNewHome => 'కొత్త ఇల్లు, పాత స్నేహితులు';

  @override
  String get motifEndingHappyTogether => 'ఎప్పటికీ సంతోషంగా కలిసి';

  @override
  String get motifEndingKissWakes => 'ఒక ముద్దు రాజ్యాన్ని మేల్కొలుపుతుంది';

  @override
  String get motifEndingLeapfrog => 'ఉపాయం అందరికన్నా ఎత్తుకు దూకుతుంది';

  @override
  String get motifEndingCurseBroken => 'శాపం విరిగింది';

  @override
  String get motifEndingWelcomedHome => 'ఇంట్లో స్వాగతం';

  @override
  String get motifEndingSlipper => 'పోయిన చెప్పు';
}
