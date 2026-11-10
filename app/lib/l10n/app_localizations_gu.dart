// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Gujarati (`gu`).
class AppLocalizationsGu extends AppLocalizations {
  AppLocalizationsGu([String locale = 'gu']) : super(locale);

  @override
  String get castTitle => 'વાર્તામાં કોણ કોણ હશે?';

  @override
  String get castHint =>
      'બીજું પાત્ર મેળવવા કાર્ડને સ્પર્શ કરો. કાર્ડ કાઢવા ક્રોસ દબાવો. સંગીત અને અવાજો હંમેશાં દેશના પેકમાંથી તૈયાર હોય છે, ફક્ત પાત્રનું ચિત્ર ક્યારેક થોડી વાર પછી દોરાય છે.';

  @override
  String get castAdd => 'પાત્ર ઉમેરો';

  @override
  String get castCount => 'પાત્રો:';

  @override
  String get castShuffleAll => 'બધાં ફેરવો';

  @override
  String get castContinue => 'આગળ વધો →';

  @override
  String get shuffle => 'ફેરવો';

  @override
  String get motifTaskTitle => 'કયું કામ?';

  @override
  String get motifProblemTitle => 'કઈ સમસ્યા?';

  @override
  String get motifEndingTitle => 'કેવો અંત?';

  @override
  String get motifTaskCaption => 'નાયકનું કામ પસંદ કરવા કાર્ડને સ્પર્શ કરો.';

  @override
  String get motifProblemCaption =>
      'અવરોધ અથવા ખલનાયક પસંદ કરવા કાર્ડને સ્પર્શ કરો.';

  @override
  String get motifEndingCaption => 'સુખદ અંત પસંદ કરવા કાર્ડને સ્પર્શ કરો.';

  @override
  String get beatCastTitle => 'વાર્તામાં કોણ છે';

  @override
  String get beatTaskTitle => 'નાયકે શું નક્કી કર્યું';

  @override
  String get beatProblemTitle => 'રસ્તામાં શું આડું આવ્યું';

  @override
  String get beatEndingTitle => 'અંતે શું થયું';

  @override
  String get beatCastCaption =>
      'પાત્રોનો પરિચય આપો: તેઓ ક્યાં છે, કેવાં દેખાય છે, તેમનામાં શું ખાસ છે.';

  @override
  String get beatTaskCaption => 'નાયક શું ઇચ્છે છે અને શા માટે નીકળ્યો તે કહો.';

  @override
  String get beatProblemCaption =>
      'તેના રસ્તામાં કંઈક મૂકો. થોડી વાર એવું લાગવા દો કે આ નહીં થાય.';

  @override
  String get beatEndingCaption =>
      'વાર્તાને અંત સુધી લઈ જાઓ. ઉતાવળ ન કરો, બાળકને અંત સૌથી વધુ યાદ રહે છે.';

  @override
  String get hintHero => 'નાયક';

  @override
  String hintCast1(String who) {
    return 'પહેલી વાર દેખાય ત્યારે «$who» કેવું દેખાય છે?';
  }

  @override
  String hintCast2(String who) {
    return 'આખી વાર્તા શરૂ થાય તે પહેલાં «$who» શું કરે છે?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» શાથી ડરે છે?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» આવી રહ્યું છે તે તમે શાથી ઓળખો છો?';
  }

  @override
  String get hintCast5 =>
      'એમાંથી કોણ એકબીજાને લાંબા સમયથી ઓળખે છે, અને ક્યાંથી?';

  @override
  String get hintCast6 => 'તેઓ મળે ત્યારે હવામાન કેવું હોય છે?';

  @override
  String hintCast7(String who) {
    return '«$who» ના ખિસ્સામાં શું છે?';
  }

  @override
  String hintTask1(String who) {
    return '«$who» ક્યારે સમજે છે કે હવે કામે લાગવું જ પડશે?';
  }

  @override
  String hintTask2(String who) {
    return 'સલાહ કોણે આપી, અને «$who» કેમ સાંભળે છે?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» એ ઘરે શું છોડીને જવું પડશે?';
  }

  @override
  String get hintTask4 => 'રસ્તો કેટલો લાંબો છે અને તે શેમાંથી પસાર થાય છે?';

  @override
  String hintTask5(String who) {
    return 'નીકળતાં પહેલાં «$who» પોતાને શું વચન આપે છે?';
  }

  @override
  String get hintTask6 => 'બીજું કોઈ આ કેમ ન કરી શકે?';

  @override
  String get hintProblem1 => 'એ જ ક્ષણે એક અવાજ સંભળાય છે, કેવો?';

  @override
  String get hintProblem2 => 'સૌથી પહેલાં શું બગડે છે?';

  @override
  String hintProblem3(String who) {
    return '«$who» પહેલાં શું અજમાવે છે, અને તે કેમ ચાલતું નથી?';
  }

  @override
  String get hintProblem4 => 'મદદ કરી શકે તેમ હોવા છતાં કોણ ના પાડે છે?';

  @override
  String get hintProblem5 => 'જો અત્યારે બધાં હાર માની લે તો શું થાય?';

  @override
  String get hintProblem6 => 'આ અવરોધમાં કંઈ દુઃખદ છે?';

  @override
  String hintProblem7(String who) {
    return 'એ ક્ષણે «$who» મોટેથી શું બોલે છે?';
  }

  @override
  String hintEnding1(String who) {
    return 'છેવટે «$who» તેને કેવી રીતે તોડે છે, બળથી કે યુક્તિથી?';
  }

  @override
  String get hintEnding2 => 'જરૂરી ન હોવા છતાં કોણ મદદ કરે છે?';

  @override
  String hintEnding3(String who) {
    return 'બધું પૂરું થાય ત્યારે «$who» સૌથી પહેલું શું કરે છે?';
  }

  @override
  String get hintEnding4 => 'શરૂઆત કરતાં અંતમાં શું જુદું છે?';

  @override
  String hintEnding5(String who) {
    return '«$who» ક્યાં પાછું ફરે છે અને ત્યાં કોણ રાહ જુએ છે?';
  }

  @override
  String get hintEnding6 => 'લાઇટ થાય તે પહેલાંનું છેલ્લું વાક્ય કયું છે?';

  @override
  String get globeLoading => 'ગ્રહ તૈયાર કરું છું…';

  @override
  String get globeLoadFailed => 'ગ્રહ લોડ થઈ શક્યો નહીં.';

  @override
  String get globeTitle => 'વાર્તા ક્યાંની હશે?';

  @override
  String get globeStored => 'ડાઉનલોડ કરેલી વાર્તાઓ';

  @override
  String get globeHintFar =>
      'ગ્રહને ફેરવો અથવા કોઈ દેશને સ્પર્શ કરો. લીલા દેશોની વાર્તાઓ આપણા સંગ્રહમાં છે, રાખોડી દેશોની હજી નથી.';

  @override
  String get globeHintNear =>
      'કોઈ દેશ અથવા ઇમારતને સ્પર્શ કરો. લીલા દેશોની વાર્તાઓ આપણા સંગ્રહમાં છે, રાખોડી દેશોની હજી નથી.';

  @override
  String get globeWhole => 'આખો ગ્રહ';

  @override
  String get globeZoomIn => 'નજીક લો';

  @override
  String get globeZoomOut => 'દૂર લો';

  @override
  String globeZoomToRegion(String name) {
    return '$name નજીક લો →';
  }

  @override
  String get globeTellHere => 'અહીંની વાર્તા કહો';

  @override
  String globeTellFrom(String place) {
    return '$place ની વાર્તા કહો →';
  }

  @override
  String get globeOpenSea => 'ખુલ્લો સમુદ્ર';

  @override
  String globeRegionCountries(int n) {
    return '$n દેશો સાથે. નજીક લઈને એક પસંદ કરો.';
  }

  @override
  String get globeTurnToCountry => 'ગ્રહને કોઈ દેશ તરફ ફેરવો.';

  @override
  String get globeSpin => 'ફેરવો';

  @override
  String get globeNoTales => 'અહીંની કોઈ વાર્તા હજી આપણી પાસે નથી.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n મુદ્દા',
      one: '$n મુદ્દો',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓમાંથી',
      one: '$n વાર્તામાંથી',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + પેકમાંથી $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'પેકમાંથી $n મુદ્દા',
      one: 'પેકમાંથી $n મુદ્દો',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return 'અહીંની $_temp0 $region પેક માટે તૈયાર કરી રહ્યા છીએ.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return '$_temp0 મફત';
  }

  @override
  String cardFree(int n) {
    return '$n મફત';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range ભાગોમાં $n',
      one: '$region $range ભાગમાં $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'તમારી પાસે $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'વધુ $n આવી રહી છે',
      one: 'વધુ $n આવી રહી છે',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'સ્ટોરની રાહ જોઈ રહ્યા છીએ…';

  @override
  String offerDownloading(int percent) {
    return 'વાર્તાઓ ડાઉનલોડ થઈ રહી છે… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return '$name ખરીદો: $_temp0, $price માં';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return '$name ડાઉનલોડ કરો: $_temp0 મફત ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n વાર્તાઓ',
      one: '$n વાર્તા',
    );
    return '$name ડાઉનલોડ કરો: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name ડાઉનલોડ કરો';
  }

  @override
  String get errDownloadTales => 'વાર્તાઓ ડાઉનલોડ થઈ શકી નહીં.';

  @override
  String get errDownloadScenes => 'ચિત્રો ડાઉનલોડ થઈ શક્યાં નહીં.';

  @override
  String get errNoDownloads => 'અહીં ડાઉનલોડ શક્ય નથી.';

  @override
  String get errOffline => 'ઇન્ટરનેટ નથી, સિગ્નલ મળે ત્યારે ફરી પ્રયત્ન કરો.';

  @override
  String get errCannotBuy => 'આ ભાગ હમણાં ખરીદી શકાતો નથી.';

  @override
  String get buyPending =>
      'ખરીદી મંજૂરીની રાહ જોઈ રહી છે. મંજૂર થતાં ભાગ ડાઉનલોડ થશે.';

  @override
  String get buyFailed => 'ખરીદી થઈ નહીં.';

  @override
  String get restoreNone => 'આ ખાતામાં કોઈ ખરીદી નથી.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ભાગ પાછા મળ્યા. તમે તેમને ગ્રહ પરથી ડાઉનલોડ કરી શકો છો.',
      one: '$n ભાગ પાછો મળ્યો. તમે તેને ગ્રહ પરથી ડાઉનલોડ કરી શકો છો.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'ખરીદીઓ પાછી મેળવી શકાઈ નહીં, સિગ્નલ મળે ત્યારે ફરી પ્રયત્ન કરો.';

  @override
  String get narrationGone => 'આ વાર્તા હવે ગોઠવેલી નથી.';

  @override
  String get narrationNew => 'નવી ગોઠવો';

  @override
  String narrationTitle(int index, int total) {
    return 'તમે કહો છો — $total માંથી $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'કેવી રીતે જોડવું: $bridge';
  }

  @override
  String get narrationSituation =>
      'હમણાં શું થઈ રહ્યું છે? (વૈકલ્પિક, બોલીને લખાવી શકાય)';

  @override
  String get narrationHintNote =>
      'સંકેત, તેને મોટેથી ન બોલો, ફક્ત શરૂઆત તરીકે લો.';

  @override
  String get narrationSoundsNote =>
      'અવાજો, વાર્તામાં બંધબેસતા હોય ત્યારે વગાડો.';

  @override
  String get moodTense => 'તણાવ';

  @override
  String get moodCalm => 'શાંતિ';

  @override
  String get narrationSearching => 'શોધું છું…';

  @override
  String get narrationHint => 'સંકેત આપો';

  @override
  String get narrationMoreHint => 'બીજો એક';

  @override
  String get narrationBack => 'પાછળ';

  @override
  String get narrationEnd => 'સમાપ્ત';

  @override
  String get narrationNext => 'આગળ →';

  @override
  String get narrationGoodnight => 'શુભ રાત્રિ.';

  @override
  String get narrationEndNote =>
      'અંતિમ ચિત્ર બનાવવું અને લાઇબ્રેરીમાં સાચવવું અમે હજી શીખ્યા નથી. આ વાર્તા ક્યાંય જતી નથી, તમારી વચ્ચે જ રહે છે.';

  @override
  String get narrationClose => 'બંધ કરો';

  @override
  String get ragFallback => 'આ માટે પેકમાં હજી કંઈ નથી, એક સામાન્ય સંકેત:';

  @override
  String get ragNoModel => 'સંકેત મોડેલ આ આવૃત્તિમાં નથી.';

  @override
  String get ragHintGeneral => 'સામાન્ય';

  @override
  String get ragHintMotif => 'મુદ્દા માટે';

  @override
  String get captionExact => 'ચિત્ર · આ મુદ્દા માટે';

  @override
  String get captionSimilar => 'ચિત્ર · સમાન દૃશ્ય';

  @override
  String get captionCard => 'મુદ્દાનું કાર્ડ · આ પગલા માટે હજી દૃશ્ય નથી';

  @override
  String get storageTitle => 'ડાઉનલોડ કરેલી વાર્તાઓ';

  @override
  String get storageEmpty => 'હજી કંઈ નથી, વધુ વાર્તાઓ ગ્રહ પરથી ડાઉનલોડ થશે.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n પેક',
      one: '$n પેક',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name દૃશ્યો';
  }

  @override
  String get storageFreeTier => 'મફત';

  @override
  String get storageBoughtTier => 'ખરીદેલ';

  @override
  String get storageDelete => 'કાઢી નાખો';

  @override
  String get storageScenesSub => 'કહેવાના દરેક પગલા માટે એક ચિત્ર';

  @override
  String get storageDownload => 'ડાઉનલોડ કરો';

  @override
  String get storageAllUsed => 'છેલ્લા ૩૦ દિવસમાં બધું વપરાયું છે.';

  @override
  String storageFreed(String size) {
    return '$size ખાલી થયું.';
  }

  @override
  String get storageFreeUp => 'જગ્યા ખાલી કરો (૩૦ દિવસથી ન વપરાયેલું)';

  @override
  String get storageRestoring => 'ખરીદીઓ પાછી મેળવી રહ્યા છીએ…';

  @override
  String get storageRestore => 'ખરીદીઓ પાછી મેળવો';

  @override
  String get osnovaTitle => 'રૂપરેખા';

  @override
  String get osnovaSummary => 'ટૂંકમાં વાર્તા';

  @override
  String get osnovaCharacters => 'પાત્રો';

  @override
  String get osnovaTask => 'કામ';

  @override
  String get osnovaProblem => 'સમસ્યા';

  @override
  String get osnovaEnding => 'અંત';

  @override
  String get osnovaAgain => 'ફરીથી';

  @override
  String get osnovaTell => 'હું કહું છું →';

  @override
  String get outlineHero => 'નાયક';

  @override
  String get castFox => 'ચતુર શિયાળ';

  @override
  String get castSmithSon => 'લુહારનો દીકરો';

  @override
  String get castMill => 'બોલતી ઘંટી';

  @override
  String get castGooseGirl => 'હંસ ચરાવતી છોકરી';

  @override
  String get castBrothers => 'ત્રણ ભાઈઓ';

  @override
  String get castClockworkPrincess => 'ઘડિયાળી રાજકુમારી';

  @override
  String get castOwl => 'સમજદાર ઘુવડ';

  @override
  String get castBlacksmith => 'ઘરડી લુહારણ';

  @override
  String get castDragon => 'નાનો ડ્રેગન';

  @override
  String get castWaterSprite => 'પાણીનો ભૂત';

  @override
  String get castFourPrincesses => 'ચાર રાજકુમારીઓ';

  @override
  String get castTravelingTailor => 'ફરતો દરજી';

  @override
  String get castTalkingCat => 'બોલતી બિલાડી';

  @override
  String get castForestHermit => 'જંગલનો સંન્યાસી';

  @override
  String get castC0AndersenTheShadow => 'જે સ્વામી એક વાર પડછાયો હતો';

  @override
  String get castC1GrimmTheGooseGirl => 'દગાબાજ દાસી';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'ભૂતિયા કિલ્લાવાળો રાજા';

  @override
  String get castC3AndersenTheShadow => 'ચતુર પડછાયો';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'સુંદર પણ ઓછી હોશિયાર રાજકુમારી';

  @override
  String get castC5AndersenTheRedShoes => 'અંતે માફ કરતો દેવદૂત';

  @override
  String get castC6GrimmRumpelstiltskin => 'ચક્કીવાળાની હોશિયાર દીકરી';

  @override
  String get castC7PerraultLittleRedRidingHood => 'બારણું ખોલતી દાદી';

  @override
  String get castC8PerraultLittleThumb => 'ગરીબી અને પ્રેમ વચ્ચેની માતા';

  @override
  String get castC9PerraultIntroduction => 'ધીરજવાળી સ્ત્રી';

  @override
  String get castC10AndersenTheRealPrincess => 'દીકરાને ટેકો આપતો રાજા';

  @override
  String get castC11GrimmLilyAndTheLion => 'વચન પાળતી દીકરી';

  @override
  String get castC12AndersenTheRealPrincess =>
      'સાચી રાજકુમારીને શોધતો રાજકુમાર';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'દિવાસળીવાળી નાની છોકરી';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'ચૂપ રહેતો દરબારી';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'મિજબાની તૈયાર કરતો વફાદાર નોકર';

  @override
  String get castC16PerraultTheFairy => 'ઘમંડી દીકરી';

  @override
  String get castC17GrimmFirstStory => 'નવ પૂંછડી ઇચ્છતી વિધવા';

  @override
  String get motifTaskWine => 'કોણ આખો ભંડાર ભરીને દારૂ પીશે';

  @override
  String get motifTaskDiamonds => 'હીરાની શોધમાં ઉડાન';

  @override
  String get motifTaskRingDuck => 'બતકમાં વીંટી';

  @override
  String get motifTaskGiants => 'રાક્ષસોને છેતરવા';

  @override
  String get motifTaskTomThumb => 'અંગૂઠાભાઈનું ભાગી જવું';

  @override
  String get motifTaskSwineherd => 'રાજકુમારીનું દિલ જીતવું';

  @override
  String get motifTaskBell => 'જંગલનો રહસ્યમય ઘંટ';

  @override
  String get motifTaskGoldenObject => 'એવી ભેટ જેનો દુરુપયોગ ન થવો જોઈએ';

  @override
  String get motifTaskPebbles => 'કાંકરાની કેડી';

  @override
  String get motifProblemFoxPride => 'શિયાળનું અભિમાન';

  @override
  String get motifProblemLazySister => 'આળસુ બહેન';

  @override
  String get motifProblemWitchBoots => 'સાત-યોજનાના બૂટવાળી ડાકણ';

  @override
  String get motifProblemTailorDoubt => 'કોઈ તેનો વિશ્વાસ કરતું નથી';

  @override
  String get motifProblemLions => 'દરવાજે ભૂખ્યા સિંહો';

  @override
  String get motifProblemEagle => 'ગરુડ અને વામન';

  @override
  String get motifProblemTruth => 'જાદુઈ પ્રાણી સત્ય જણાવે છે';

  @override
  String get motifProblemOldHouse => 'જૂનું ઘર કોઈને જોઈતું નથી';

  @override
  String get motifProblemBreadcrumbs => 'પક્ષીઓ ટુકડા ખાઈ ગયાં';

  @override
  String get motifEndingTrickWins => 'ચતુરાઈ જીતે છે';

  @override
  String get motifEndingTruthChild => 'બાળક સાચું કહે છે';

  @override
  String get motifEndingNewHome => 'નવું ઘર, જૂના મિત્રો';

  @override
  String get motifEndingHappyTogether => 'હંમેશાં સુખેથી સાથે';

  @override
  String get motifEndingKissWakes => 'ચુંબનથી આખું રાજ્ય જાગે છે';

  @override
  String get motifEndingLeapfrog => 'ચતુરાઈ સૌથી ઊંચું કૂદે છે';

  @override
  String get motifEndingCurseBroken => 'શ્રાપ તૂટ્યો';

  @override
  String get motifEndingWelcomedHome => 'ઘરે આવકાર';

  @override
  String get motifEndingSlipper => 'ખોવાયેલી મોજડી';
}
