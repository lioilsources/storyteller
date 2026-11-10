// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Kannada (`kn`).
class AppLocalizationsKn extends AppLocalizations {
  AppLocalizationsKn([String locale = 'kn']) : super(locale);

  @override
  String get castTitle => 'ಕಥೆಯಲ್ಲಿ ಯಾರು ಯಾರು ಇರುತ್ತಾರೆ?';

  @override
  String get castHint =>
      'ಬೇರೆ ಪಾತ್ರ ಪಡೆಯಲು ಕಾರ್ಡ್ ಅನ್ನು ಒತ್ತಿ. ಕಾರ್ಡ್ ತೆಗೆಯಲು ಅಡ್ಡ ಗುರುತನ್ನು ಒತ್ತಿ. ಸಂಗೀತ ಮತ್ತು ಶಬ್ದಗಳು ಯಾವಾಗಲೂ ದೇಶದ ಪ್ಯಾಕ್‌ನಿಂದ ಸಿದ್ಧವಾಗಿರುತ್ತವೆ, ಪಾತ್ರದ ಚಿತ್ರ ಮಾತ್ರ ಕೆಲವೊಮ್ಮೆ ಸ್ವಲ್ಪ ತಡವಾಗಿ ಬರೆಯಲ್ಪಡುತ್ತದೆ.';

  @override
  String get castAdd => 'ಪಾತ್ರ ಸೇರಿಸಿ';

  @override
  String get castCount => 'ಪಾತ್ರವರ್ಗ:';

  @override
  String get castShuffleAll => 'ಎಲ್ಲವನ್ನೂ ಕಲಸಿ';

  @override
  String get castContinue => 'ಮುಂದುವರಿಸಿ →';

  @override
  String get shuffle => 'ಕಲಸಿ';

  @override
  String get motifTaskTitle => 'ಯಾವ ಕೆಲಸ?';

  @override
  String get motifProblemTitle => 'ಯಾವ ಸಮಸ್ಯೆ?';

  @override
  String get motifEndingTitle => 'ಯಾವ ಅಂತ್ಯ?';

  @override
  String get motifTaskCaption => 'ನಾಯಕನ ಕೆಲಸ ಆಯ್ಕೆ ಮಾಡಲು ಕಾರ್ಡ್ ಒತ್ತಿ.';

  @override
  String get motifProblemCaption =>
      'ಅಡೆತಡೆ ಅಥವಾ ಖಳನಾಯಕನನ್ನು ಆಯ್ಕೆ ಮಾಡಲು ಕಾರ್ಡ್ ಒತ್ತಿ.';

  @override
  String get motifEndingCaption => 'ಸುಖಾಂತ್ಯ ಆಯ್ಕೆ ಮಾಡಲು ಕಾರ್ಡ್ ಒತ್ತಿ.';

  @override
  String get beatCastTitle => 'ಕಥೆಯಲ್ಲಿ ಯಾರಿದ್ದಾರೆ';

  @override
  String get beatTaskTitle => 'ನಾಯಕ ಏನು ನಿರ್ಧರಿಸಿದ';

  @override
  String get beatProblemTitle => 'ದಾರಿಗೆ ಅಡ್ಡ ಬಂದದ್ದು ಏನು';

  @override
  String get beatEndingTitle => 'ಕೊನೆಗೆ ಏನಾಯಿತು';

  @override
  String get beatCastCaption =>
      'ಪಾತ್ರಗಳನ್ನು ಪರಿಚಯಿಸಿ: ಅವರು ಎಲ್ಲಿದ್ದಾರೆ, ಹೇಗೆ ಕಾಣುತ್ತಾರೆ, ಅವರಲ್ಲಿ ವಿಶೇಷ ಏನು.';

  @override
  String get beatTaskCaption =>
      'ನಾಯಕನಿಗೆ ಏನು ಬೇಕು ಮತ್ತು ಅವನು ಏಕೆ ಹೊರಟನು ಎಂದು ಹೇಳಿ.';

  @override
  String get beatProblemCaption =>
      'ಅವನ ದಾರಿಯಲ್ಲಿ ಏನಾದರೂ ಇಡಿ. ಸ್ವಲ್ಪ ಹೊತ್ತು ಇದು ಆಗುವುದಿಲ್ಲ ಎಂದು ಕಾಣಲಿ.';

  @override
  String get beatEndingCaption =>
      'ಕಥೆಯನ್ನು ಅಂತ್ಯಕ್ಕೆ ಕೊಂಡೊಯ್ಯಿರಿ. ಆತುರ ಬೇಡ, ಮಗು ಅಂತ್ಯವನ್ನೇ ಹೆಚ್ಚು ನೆನಪಿಡುತ್ತದೆ.';

  @override
  String get hintHero => 'ನಾಯಕ';

  @override
  String hintCast1(String who) {
    return 'ಮೊದಲ ಬಾರಿ ಕಾಣಿಸಿಕೊಂಡಾಗ «$who» ಹೇಗೆ ಕಾಣುತ್ತಾನೆ?';
  }

  @override
  String hintCast2(String who) {
    return 'ಇಡೀ ಕಥೆ ಶುರುವಾಗುವ ಮೊದಲು «$who» ಏನು ಮಾಡುತ್ತಿದ್ದಾನೆ?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» ಯಾವುದಕ್ಕೆ ಹೆದರುತ್ತಾನೆ?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» ಬರುತ್ತಿದ್ದಾನೆ ಎಂದು ನಿಮಗೆ ಹೇಗೆ ಗೊತ್ತಾಗುತ್ತದೆ?';
  }

  @override
  String get hintCast5 =>
      'ಇವರಲ್ಲಿ ಯಾರು ಬಹಳ ಕಾಲದಿಂದ ಒಬ್ಬರನ್ನೊಬ್ಬರು ಬಲ್ಲರು, ಮತ್ತು ಎಲ್ಲಿಂದ?';

  @override
  String get hintCast6 => 'ಅವರು ಭೇಟಿಯಾದಾಗ ಹವಾಮಾನ ಹೇಗಿರುತ್ತದೆ?';

  @override
  String hintCast7(String who) {
    return '«$who» ಜೇಬಿನಲ್ಲಿ ಏನಿದೆ?';
  }

  @override
  String hintTask1(String who) {
    return 'ಕೆಲಸಕ್ಕೆ ಇಳಿಯಲೇಬೇಕು ಎಂದು «$who» ಯಾವಾಗ ಅರಿಯುತ್ತಾನೆ?';
  }

  @override
  String hintTask2(String who) {
    return 'ಸಲಹೆ ಕೊಟ್ಟವರು ಯಾರು, ಮತ್ತು «$who» ಏಕೆ ಕೇಳುತ್ತಾನೆ?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» ಮನೆಯಲ್ಲಿ ಏನನ್ನು ಬಿಟ್ಟು ಹೋಗಬೇಕು?';
  }

  @override
  String get hintTask4 => 'ದಾರಿ ಎಷ್ಟು ಉದ್ದ, ಮತ್ತು ಅದು ಯಾವುದನ್ನು ದಾಟುತ್ತದೆ?';

  @override
  String hintTask5(String who) {
    return 'ಹೊರಡುವ ಮೊದಲು «$who» ತನಗೆ ತಾನೇ ಏನು ಮಾತು ಕೊಡುತ್ತಾನೆ?';
  }

  @override
  String get hintTask6 => 'ಬೇರೆ ಯಾರೂ ಇದನ್ನು ಏಕೆ ಮಾಡಲಾಗದು?';

  @override
  String get hintProblem1 => 'ಆ ಕ್ಷಣದಲ್ಲಿ ಒಂದು ಶಬ್ದ ಕೇಳುತ್ತದೆ, ಯಾವುದು?';

  @override
  String get hintProblem2 => 'ಮೊದಲು ಏನು ಕೆಡುತ್ತದೆ?';

  @override
  String hintProblem3(String who) {
    return '«$who» ಮೊದಲು ಏನು ಪ್ರಯತ್ನಿಸುತ್ತಾನೆ, ಮತ್ತು ಅದು ಏಕೆ ಕೆಲಸ ಮಾಡುವುದಿಲ್ಲ?';
  }

  @override
  String get hintProblem4 => 'ಸಹಾಯ ಮಾಡಬಲ್ಲವರಾದರೂ ಯಾರು ನಿರಾಕರಿಸುತ್ತಾರೆ?';

  @override
  String get hintProblem5 => 'ಈಗ ಎಲ್ಲರೂ ಕೈಬಿಟ್ಟರೆ ಏನಾಗುತ್ತದೆ?';

  @override
  String get hintProblem6 => 'ಆ ಅಡೆತಡೆಯಲ್ಲಿ ದುಃಖದ ಸಂಗತಿ ಏನಾದರೂ ಇದೆಯೇ?';

  @override
  String hintProblem7(String who) {
    return 'ಆ ಕ್ಷಣದಲ್ಲಿ «$who» ಗಟ್ಟಿಯಾಗಿ ಏನು ಹೇಳುತ್ತಾನೆ?';
  }

  @override
  String hintEnding1(String who) {
    return 'ಕೊನೆಗೆ «$who» ಅದನ್ನು ಹೇಗೆ ಮುರಿಯುತ್ತಾನೆ, ಬಲದಿಂದಲೋ ಉಪಾಯದಿಂದಲೋ?';
  }

  @override
  String get hintEnding2 => 'ಅಗತ್ಯವಿಲ್ಲದಿದ್ದರೂ ಯಾರು ಸಹಾಯ ಮಾಡುತ್ತಾರೆ?';

  @override
  String hintEnding3(String who) {
    return 'ಎಲ್ಲವೂ ಮುಗಿದಾಗ «$who» ಮೊದಲು ಏನು ಮಾಡುತ್ತಾನೆ?';
  }

  @override
  String get hintEnding4 => 'ಆರಂಭಕ್ಕಿಂತ ಅಂತ್ಯದಲ್ಲಿ ಏನು ಭಿನ್ನವಾಗಿದೆ?';

  @override
  String hintEnding5(String who) {
    return '«$who» ಎಲ್ಲಿಗೆ ಮರಳುತ್ತಾನೆ, ಮತ್ತು ಅಲ್ಲಿ ಯಾರು ಕಾಯುತ್ತಿದ್ದಾರೆ?';
  }

  @override
  String get hintEnding6 => 'ದೀಪ ಹತ್ತುವ ಮೊದಲಿನ ಕೊನೆಯ ವಾಕ್ಯ ಯಾವುದು?';

  @override
  String get globeLoading => 'ಗ್ರಹವನ್ನು ಸಿದ್ಧಪಡಿಸುತ್ತಿದ್ದೇನೆ…';

  @override
  String get globeLoadFailed => 'ಗ್ರಹವನ್ನು ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ.';

  @override
  String get globeTitle => 'ಕಥೆ ಎಲ್ಲಿಂದ ಬರಬೇಕು?';

  @override
  String get globeStored => 'ಡೌನ್‌ಲೋಡ್ ಮಾಡಿದ ಕಥೆಗಳು';

  @override
  String get globeHintFar =>
      'ಗ್ರಹವನ್ನು ತಿರುಗಿಸಿ ಅಥವಾ ದೇಶವನ್ನು ಒತ್ತಿ. ಹಸಿರು ದೇಶಗಳಿಗೆ ನಮ್ಮ ಸಂಗ್ರಹದ ಕಥೆಗಳಿವೆ, ಬೂದು ದೇಶಗಳಿಗೆ ಇನ್ನೂ ಇಲ್ಲ.';

  @override
  String get globeHintNear =>
      'ದೇಶ ಅಥವಾ ಕಟ್ಟಡವನ್ನು ಒತ್ತಿ. ಹಸಿರು ದೇಶಗಳಿಗೆ ನಮ್ಮ ಸಂಗ್ರಹದ ಕಥೆಗಳಿವೆ, ಬೂದು ದೇಶಗಳಿಗೆ ಇನ್ನೂ ಇಲ್ಲ.';

  @override
  String get globeWhole => 'ಇಡೀ ಗ್ರಹ';

  @override
  String get globeZoomIn => 'ಹತ್ತಿರ ತನ್ನಿ';

  @override
  String get globeZoomOut => 'ದೂರ ಮಾಡಿ';

  @override
  String globeZoomToRegion(String name) {
    return '$name ಹತ್ತಿರ ತನ್ನಿ →';
  }

  @override
  String get globeTellHere => 'ಇಲ್ಲಿನ ಕಥೆ ಹೇಳಿ';

  @override
  String globeTellFrom(String place) {
    return '$place ಕಥೆ ಹೇಳಿ →';
  }

  @override
  String get globeOpenSea => 'ತೆರೆದ ಸಮುದ್ರ';

  @override
  String globeRegionCountries(int n) {
    return '$n ದೇಶಗಳು ಒಟ್ಟಿಗೆ. ಹತ್ತಿರ ತಂದು ಒಂದನ್ನು ಆರಿಸಿ.';
  }

  @override
  String get globeTurnToCountry => 'ಗ್ರಹವನ್ನು ಯಾವುದಾದರೂ ದೇಶದ ಕಡೆಗೆ ತಿರುಗಿಸಿ.';

  @override
  String get globeSpin => 'ತಿರುಗಿಸಿ';

  @override
  String get globeNoTales => 'ಇಲ್ಲಿನ ಯಾವ ಕಥೆಯೂ ಇನ್ನೂ ನಮ್ಮಲ್ಲಿ ಇಲ್ಲ.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಅಂಶಗಳು',
      one: '$n ಅಂಶ',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳಿಂದ',
      one: '$n ಕಥೆಯಿಂದ',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + ಪ್ಯಾಕ್‌ನಿಂದ $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ಪ್ಯಾಕ್‌ನಿಂದ $n ಅಂಶಗಳು',
      one: 'ಪ್ಯಾಕ್‌ನಿಂದ $n ಅಂಶ',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return 'ಇಲ್ಲಿನ $_temp0 $region ಪ್ಯಾಕ್‌ಗಾಗಿ ಸಿದ್ಧಪಡಿಸುತ್ತಿದ್ದೇವೆ.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return '$_temp0 ಉಚಿತ';
  }

  @override
  String cardFree(int n) {
    return '$n ಉಚಿತ';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range ಭಾಗಗಳಲ್ಲಿ $n',
      one: '$region $range ಭಾಗದಲ್ಲಿ $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'ನಿಮ್ಮಲ್ಲಿ $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ಇನ್ನೂ $n ಬರುತ್ತಿವೆ',
      one: 'ಇನ್ನೂ $n ಬರುತ್ತಿದೆ',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'ಸ್ಟೋರ್‌ಗಾಗಿ ಕಾಯುತ್ತಿದೆ…';

  @override
  String offerDownloading(int percent) {
    return 'ಕಥೆಗಳನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡುತ್ತಿದೆ… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return '$name ಖರೀದಿಸಿ: $_temp0, $priceಕ್ಕೆ';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return '$name ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ: $_temp0 ಉಚಿತ ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಕಥೆಗಳು',
      one: '$n ಕಥೆ',
    );
    return '$name ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ';
  }

  @override
  String get errDownloadTales => 'ಕಥೆಗಳನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ.';

  @override
  String get errDownloadScenes => 'ಚಿತ್ರಗಳನ್ನು ಡೌನ್‌ಲೋಡ್ ಮಾಡಲಾಗಲಿಲ್ಲ.';

  @override
  String get errNoDownloads => 'ಇಲ್ಲಿ ಡೌನ್‌ಲೋಡ್ ಲಭ್ಯವಿಲ್ಲ.';

  @override
  String get errOffline => 'ಇಂಟರ್ನೆಟ್ ಇಲ್ಲ, ಸಿಗ್ನಲ್ ಬಂದಾಗ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get errCannotBuy => 'ಈ ಭಾಗವನ್ನು ಈಗ ಖರೀದಿಸಲಾಗುವುದಿಲ್ಲ.';

  @override
  String get buyPending =>
      'ಖರೀದಿ ಅನುಮೋದನೆಗಾಗಿ ಕಾಯುತ್ತಿದೆ. ಅನುಮೋದನೆ ಸಿಕ್ಕ ತಕ್ಷಣ ಭಾಗ ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತದೆ.';

  @override
  String get buyFailed => 'ಖರೀದಿ ಯಶಸ್ವಿಯಾಗಲಿಲ್ಲ.';

  @override
  String get restoreNone => 'ಈ ಖಾತೆಯಲ್ಲಿ ಯಾವ ಖರೀದಿಯೂ ಇಲ್ಲ.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಭಾಗಗಳು ಮರಳಿ ಸಿಕ್ಕಿವೆ. ಗ್ರಹದಿಂದ ಡೌನ್‌ಲೋಡ್ ಮಾಡಬಹುದು.',
      one: '$n ಭಾಗ ಮರಳಿ ಸಿಕ್ಕಿದೆ. ಗ್ರಹದಿಂದ ಡೌನ್‌ಲೋಡ್ ಮಾಡಬಹುದು.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'ಖರೀದಿಗಳನ್ನು ಮರುಪಡೆಯಲಾಗಲಿಲ್ಲ, ಸಿಗ್ನಲ್ ಬಂದಾಗ ಮತ್ತೆ ಪ್ರಯತ್ನಿಸಿ.';

  @override
  String get narrationGone => 'ಈ ಕಥೆ ಈಗ ಜೋಡಿಸಲ್ಪಟ್ಟಿಲ್ಲ.';

  @override
  String get narrationNew => 'ಹೊಸದನ್ನು ಜೋಡಿಸಿ';

  @override
  String narrationTitle(int index, int total) {
    return 'ನೀವು ಹೇಳುತ್ತಿದ್ದೀರಿ — $totalರಲ್ಲಿ $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'ಹೇಗೆ ಮುಂದುವರಿಸುವುದು: $bridge';
  }

  @override
  String get narrationSituation =>
      'ಈಗ ಏನು ನಡೆಯುತ್ತಿದೆ? (ಐಚ್ಛಿಕ, ಹೇಳಿ ಬರೆಸಬಹುದು)';

  @override
  String get narrationHintNote =>
      'ಸುಳಿವು, ಇದನ್ನು ಗಟ್ಟಿಯಾಗಿ ಹೇಳಬೇಡಿ, ಇದರಿಂದ ಆರಂಭಿಸಿ ಅಷ್ಟೇ.';

  @override
  String get narrationSoundsNote => 'ಶಬ್ದಗಳು, ಕಥೆಗೆ ಹೊಂದುವಾಗ ಹಾಕಿ.';

  @override
  String get moodTense => 'ಉದ್ವೇಗ';

  @override
  String get moodCalm => 'ಶಾಂತಿ';

  @override
  String get narrationSearching => 'ಹುಡುಕುತ್ತಿದೆ…';

  @override
  String get narrationHint => 'ಸುಳಿವು ಕೊಡಿ';

  @override
  String get narrationMoreHint => 'ಇನ್ನೊಂದು';

  @override
  String get narrationBack => 'ಹಿಂದೆ';

  @override
  String get narrationEnd => 'ಮುಗಿಯಿತು';

  @override
  String get narrationNext => 'ಮುಂದೆ →';

  @override
  String get narrationGoodnight => 'ಶುಭ ರಾತ್ರಿ.';

  @override
  String get narrationEndNote =>
      'ಅಂತಿಮ ಚಿತ್ರ ಮತ್ತು ಲೈಬ್ರರಿಗೆ ಉಳಿಸುವುದು ನಮಗೆ ಇನ್ನೂ ಸಾಧ್ಯವಿಲ್ಲ. ಈ ಕಥೆ ಎಲ್ಲಿಗೂ ಹೋಗುವುದಿಲ್ಲ, ನಿಮ್ಮಿಬ್ಬರ ನಡುವೆಯೇ ಉಳಿಯುತ್ತದೆ.';

  @override
  String get narrationClose => 'ಮುಚ್ಚಿ';

  @override
  String get ragFallback =>
      'ಇದಕ್ಕೆ ಪ್ಯಾಕ್‌ನಲ್ಲಿ ಇನ್ನೂ ಏನೂ ಇಲ್ಲ, ಒಂದು ಸಾಮಾನ್ಯ ಸುಳಿವು:';

  @override
  String get ragNoModel => 'ಸುಳಿವಿನ ಮಾದರಿ ಈ ಆವೃತ್ತಿಯಲ್ಲಿ ಇಲ್ಲ.';

  @override
  String get ragHintGeneral => 'ಸಾಮಾನ್ಯ';

  @override
  String get ragHintMotif => 'ಅಂಶಕ್ಕಾಗಿ';

  @override
  String get captionExact => 'ಚಿತ್ರ · ಈ ಅಂಶಕ್ಕಾಗಿ';

  @override
  String get captionSimilar => 'ಚಿತ್ರ · ಹೋಲುವ ದೃಶ್ಯ';

  @override
  String get captionCard => 'ಅಂಶದ ಕಾರ್ಡ್ · ಈ ಹಂತಕ್ಕೆ ಇನ್ನೂ ದೃಶ್ಯವಿಲ್ಲ';

  @override
  String get storageTitle => 'ಡೌನ್‌ಲೋಡ್ ಮಾಡಿದ ಕಥೆಗಳು';

  @override
  String get storageEmpty =>
      'ಇನ್ನೂ ಏನೂ ಇಲ್ಲ, ಹೆಚ್ಚಿನ ಕಥೆಗಳು ಗ್ರಹದಿಂದ ಡೌನ್‌ಲೋಡ್ ಆಗುತ್ತವೆ.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ಪ್ಯಾಕ್‌ಗಳು',
      one: '$n ಪ್ಯಾಕ್',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name ದೃಶ್ಯಗಳು';
  }

  @override
  String get storageFreeTier => 'ಉಚಿತ';

  @override
  String get storageBoughtTier => 'ಖರೀದಿಸಿದ್ದು';

  @override
  String get storageDelete => 'ಅಳಿಸಿ';

  @override
  String get storageScenesSub => 'ಹೇಳುವ ಪ್ರತಿ ಹಂತಕ್ಕೂ ಒಂದು ಚಿತ್ರ';

  @override
  String get storageDownload => 'ಡೌನ್‌ಲೋಡ್ ಮಾಡಿ';

  @override
  String get storageAllUsed => 'ಕಳೆದ 30 ದಿನಗಳಲ್ಲಿ ಎಲ್ಲವೂ ಬಳಕೆಯಾಗಿದೆ.';

  @override
  String storageFreed(String size) {
    return '$size ಖಾಲಿಯಾಯಿತು.';
  }

  @override
  String get storageFreeUp => 'ಜಾಗ ಖಾಲಿ ಮಾಡಿ (30 ದಿನ ಬಳಸದ್ದು)';

  @override
  String get storageRestoring => 'ಖರೀದಿಗಳನ್ನು ಮರುಪಡೆಯುತ್ತಿದೆ…';

  @override
  String get storageRestore => 'ಖರೀದಿಗಳನ್ನು ಮರುಪಡೆಯಿರಿ';

  @override
  String get osnovaTitle => 'ರೂಪರೇಖೆ';

  @override
  String get osnovaSummary => 'ಕಥೆ ಸಂಕ್ಷಿಪ್ತವಾಗಿ';

  @override
  String get osnovaCharacters => 'ಪಾತ್ರಗಳು';

  @override
  String get osnovaTask => 'ಕೆಲಸ';

  @override
  String get osnovaProblem => 'ಸಮಸ್ಯೆ';

  @override
  String get osnovaEnding => 'ಅಂತ್ಯ';

  @override
  String get osnovaAgain => 'ಮತ್ತೆ';

  @override
  String get osnovaTell => 'ನಾನು ಹೇಳುತ್ತೇನೆ →';

  @override
  String get outlineHero => 'ನಾಯಕ';

  @override
  String get castFox => 'ಜಾಣ ನರಿ';

  @override
  String get castSmithSon => 'ಕಮ್ಮಾರನ ಮಗ';

  @override
  String get castMill => 'ಮಾತನಾಡುವ ಗಿರಣಿ';

  @override
  String get castGooseGirl => 'ಹಂಸ ಮೇಯಿಸುವ ಹುಡುಗಿ';

  @override
  String get castBrothers => 'ಮೂವರು ಸಹೋದರರು';

  @override
  String get castClockworkPrincess => 'ಗಡಿಯಾರ ತಯಾರಕನ ರಾಜಕುಮಾರಿ';

  @override
  String get castOwl => 'ಬುದ್ಧಿವಂತ ಗೂಬೆ';

  @override
  String get castBlacksmith => 'ಮುದಿ ಕಮ್ಮಾರ ಮಹಿಳೆ';

  @override
  String get castDragon => 'ಪುಟ್ಟ ಡ್ರ್ಯಾಗನ್';

  @override
  String get castWaterSprite => 'ನೀರಿನ ಭೂತ';

  @override
  String get castFourPrincesses => 'ನಾಲ್ವರು ರಾಜಕುಮಾರಿಯರು';

  @override
  String get castTravelingTailor => 'ಅಲೆಮಾರಿ ದರ್ಜಿ';

  @override
  String get castTalkingCat => 'ಮಾತನಾಡುವ ಬೆಕ್ಕು';

  @override
  String get castForestHermit => 'ಕಾಡಿನ ಸನ್ಯಾಸಿ';

  @override
  String get castC0AndersenTheShadow => 'ಒಮ್ಮೆ ನೆರಳಾಗಿದ್ದ ಒಡೆಯ';

  @override
  String get castC1GrimmTheGooseGirl => 'ದ್ರೋಹಿ ಸೇವಕಿ';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'ಭೂತದ ಕೋಟೆಯ ರಾಜ';

  @override
  String get castC3AndersenTheShadow => 'ಜಾಣ ನೆರಳು';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'ಸುಂದರ ಆದರೆ ಅಷ್ಟು ಜಾಣೆಯಲ್ಲದ ರಾಜಕುಮಾರಿ';

  @override
  String get castC5AndersenTheRedShoes => 'ಕೊನೆಗೆ ಕ್ಷಮಿಸುವ ದೇವದೂತ';

  @override
  String get castC6GrimmRumpelstiltskin => 'ಗಿರಣಿಗಾರನ ಜಾಣ ಮಗಳು';

  @override
  String get castC7PerraultLittleRedRidingHood => 'ಬಾಗಿಲು ತೆರೆಯುವ ಅಜ್ಜಿ';

  @override
  String get castC8PerraultLittleThumb => 'ಬಡತನ ಮತ್ತು ಪ್ರೀತಿಯ ನಡುವಿನ ತಾಯಿ';

  @override
  String get castC9PerraultIntroduction => 'ತಾಳ್ಮೆಯ ಮಹಿಳೆ';

  @override
  String get castC10AndersenTheRealPrincess => 'ಮಗನಿಗೆ ಬೆಂಬಲ ನೀಡುವ ರಾಜ';

  @override
  String get castC11GrimmLilyAndTheLion => 'ಮಾತು ಉಳಿಸಿಕೊಳ್ಳುವ ಮಗಳು';

  @override
  String get castC12AndersenTheRealPrincess =>
      'ನಿಜವಾದ ರಾಜಕುಮಾರಿಯನ್ನು ಹುಡುಕುವ ರಾಜಕುಮಾರ';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'ಬೆಂಕಿಕಡ್ಡಿ ಮಾರುವ ಪುಟ್ಟ ಹುಡುಗಿ';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'ಮೌನವಾಗಿರುವ ಆಸ್ಥಾನಿಕ';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'ಔತಣ ಸಿದ್ಧಪಡಿಸುವ ನಿಷ್ಠಾವಂತ ಸೇವಕ';

  @override
  String get castC16PerraultTheFairy => 'ಅಹಂಕಾರಿ ಮಗಳು';

  @override
  String get castC17GrimmFirstStory => 'ಒಂಬತ್ತು ಬಾಲ ಬೇಕೆನ್ನುವ ವಿಧವೆ';

  @override
  String get motifTaskWine =>
      'ಇಡೀ ನೆಲಮಾಳಿಗೆಯ ದ್ರಾಕ್ಷಾರಸವನ್ನು ಯಾರು ಕುಡಿಯುತ್ತಾರೆ';

  @override
  String get motifTaskDiamonds => 'ವಜ್ರಗಳಿಗಾಗಿ ಹಾರಾಟ';

  @override
  String get motifTaskRingDuck => 'ಬಾತುಕೋಳಿಯ ಒಳಗೆ ಉಂಗುರ';

  @override
  String get motifTaskGiants => 'ರಾಕ್ಷಸರನ್ನು ಮೋಸಗೊಳಿಸುವುದು';

  @override
  String get motifTaskTomThumb => 'ಹೆಬ್ಬೆರಳಿನಷ್ಟು ಹುಡುಗನ ಪಲಾಯನ';

  @override
  String get motifTaskSwineherd => 'ರಾಜಕುಮಾರಿಯ ಮನ ಗೆಲ್ಲುವುದು';

  @override
  String get motifTaskBell => 'ಕಾಡಿನಲ್ಲಿ ನಿಗೂಢ ಗಂಟೆ';

  @override
  String get motifTaskGoldenObject => 'ದುರುಪಯೋಗ ಮಾಡಬಾರದ ಉಡುಗೊರೆ';

  @override
  String get motifTaskPebbles => 'ಕಲ್ಲುಗಳ ಕಾಲುದಾರಿ';

  @override
  String get motifProblemFoxPride => 'ನರಿಯ ಅಹಂಕಾರ';

  @override
  String get motifProblemLazySister => 'ಸೋಮಾರಿ ಸಹೋದರಿ';

  @override
  String get motifProblemWitchBoots => 'ಏಳು ಮೈಲಿ ಬೂಟಿನ ಮಾಟಗಾತಿ';

  @override
  String get motifProblemTailorDoubt => 'ಯಾರೂ ಅವನನ್ನು ನಂಬುವುದಿಲ್ಲ';

  @override
  String get motifProblemLions => 'ಬಾಗಿಲಲ್ಲಿ ಹಸಿದ ಸಿಂಹಗಳು';

  @override
  String get motifProblemEagle => 'ಹದ್ದು ಮತ್ತು ಕುಬ್ಜ';

  @override
  String get motifProblemTruth => 'ಮಾಯಾ ಪ್ರಾಣಿ ಸತ್ಯವನ್ನು ಬಯಲು ಮಾಡುತ್ತದೆ';

  @override
  String get motifProblemOldHouse => 'ಹಳೆಯ ಮನೆ ಯಾರಿಗೂ ಬೇಡ';

  @override
  String get motifProblemBreadcrumbs => 'ಹಕ್ಕಿಗಳು ತುಂಡುಗಳನ್ನು ತಿಂದವು';

  @override
  String get motifEndingTrickWins => 'ಜಾಣತನ ಗೆಲ್ಲುತ್ತದೆ';

  @override
  String get motifEndingTruthChild => 'ಮಗು ಸತ್ಯ ಹೇಳುತ್ತದೆ';

  @override
  String get motifEndingNewHome => 'ಹೊಸ ಮನೆ, ಹಳೆಯ ಗೆಳೆಯರು';

  @override
  String get motifEndingHappyTogether => 'ಎಂದೆಂದಿಗೂ ಸುಖವಾಗಿ ಒಟ್ಟಿಗೆ';

  @override
  String get motifEndingKissWakes => 'ಮುತ್ತು ರಾಜ್ಯವನ್ನು ಎಬ್ಬಿಸುತ್ತದೆ';

  @override
  String get motifEndingLeapfrog => 'ಜಾಣತನ ಅತಿ ಎತ್ತರ ಜಿಗಿಯುತ್ತದೆ';

  @override
  String get motifEndingCurseBroken => 'ಶಾಪ ಮುರಿಯಿತು';

  @override
  String get motifEndingWelcomedHome => 'ಮನೆಯಲ್ಲಿ ಸ್ವಾಗತ';

  @override
  String get motifEndingSlipper => 'ಕಳೆದುಹೋದ ಚಪ್ಪಲಿ';
}
