// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Urdu (`ur`).
class AppLocalizationsUr extends AppLocalizations {
  AppLocalizationsUr([String locale = 'ur']) : super(locale);

  @override
  String get castTitle => 'کہانی میں کون کون ہوگا؟';

  @override
  String get castHint =>
      'دوسرے کردار کے لیے کارڈ کو چھوئیں۔ کارڈ ہٹانے کے لیے کراس دبائیں۔ موسیقی اور آوازیں ہمیشہ ملک کے پیک سے تیار ملتی ہیں، صرف کردار کی تصویر کبھی کبھی ذرا دیر سے بنتی ہے۔';

  @override
  String get castAdd => 'کردار شامل کریں';

  @override
  String get castCount => 'کردار:';

  @override
  String get castShuffleAll => 'سب کو پھینٹیں';

  @override
  String get castContinue => 'آگے بڑھیں ←';

  @override
  String get shuffle => 'پھینٹیں';

  @override
  String get motifTaskTitle => 'کون سا کام؟';

  @override
  String get motifProblemTitle => 'کون سا مسئلہ؟';

  @override
  String get motifEndingTitle => 'کیسا انجام؟';

  @override
  String get motifTaskCaption => 'ہیرو کا کام چننے کے لیے کارڈ کو چھوئیں۔';

  @override
  String get motifProblemCaption => 'رکاوٹ یا ولن چننے کے لیے کارڈ کو چھوئیں۔';

  @override
  String get motifEndingCaption => 'خوشگوار انجام چننے کے لیے کارڈ کو چھوئیں۔';

  @override
  String get beatCastTitle => 'کہانی میں کون ہے';

  @override
  String get beatTaskTitle => 'ہیرو نے کیا ٹھانا';

  @override
  String get beatProblemTitle => 'راستے میں کیا رکاوٹ آئی';

  @override
  String get beatEndingTitle => 'انجام کیا ہوا';

  @override
  String get beatCastCaption =>
      'کرداروں کا تعارف کروائیں: وہ کہاں ہیں، کیسے دکھتے ہیں، ان میں خاص بات کیا ہے۔';

  @override
  String get beatTaskCaption => 'بتائیں کہ ہیرو کیا چاہتا ہے اور کیوں نکل پڑا۔';

  @override
  String get beatProblemCaption =>
      'اس کے راستے میں کچھ رکھ دیں۔ کچھ دیر یوں لگے کہ یہ نہیں ہو پائے گا۔';

  @override
  String get beatEndingCaption =>
      'کہانی کو انجام تک پہنچائیں۔ جلدی نہ کریں، بچہ انجام کو سب سے زیادہ یاد رکھتا ہے۔';

  @override
  String get hintHero => 'ہیرو';

  @override
  String hintCast1(String who) {
    return 'پہلی بار سامنے آتے وقت «$who» کیسا دکھتا ہے؟';
  }

  @override
  String hintCast2(String who) {
    return 'پوری کہانی شروع ہونے سے ذرا پہلے «$who» کیا کر رہا ہے؟';
  }

  @override
  String hintCast3(String who) {
    return '«$who» کس سے ڈرتا ہے؟';
  }

  @override
  String hintCast4(String who) {
    return 'آپ کو کیسے پتا چلتا ہے کہ «$who» آ رہا ہے؟';
  }

  @override
  String get hintCast5 =>
      'ان میں سے کون ایک دوسرے کو مدت سے جانتے ہیں، اور کہاں سے؟';

  @override
  String get hintCast6 => 'جب وہ ملتے ہیں تو موسم کیسا ہوتا ہے؟';

  @override
  String hintCast7(String who) {
    return '«$who» کی جیب میں کیا ہے؟';
  }

  @override
  String hintTask1(String who) {
    return '«$who» کو کب سمجھ آتی ہے کہ کام شروع کرنا ہی پڑے گا؟';
  }

  @override
  String hintTask2(String who) {
    return 'مشورہ کس نے دیا، اور «$who» کیوں مانتا ہے؟';
  }

  @override
  String hintTask3(String who) {
    return '«$who» کو گھر میں کیا چھوڑ کر جانا ہوگا؟';
  }

  @override
  String get hintTask4 => 'راستہ کتنا لمبا ہے اور کن جگہوں سے گزرتا ہے؟';

  @override
  String hintTask5(String who) {
    return 'روانگی سے پہلے «$who» خود سے کیا وعدہ کرتا ہے؟';
  }

  @override
  String get hintTask6 => 'یہ کام کوئی اور کیوں نہیں کر سکتا؟';

  @override
  String get hintProblem1 => 'اسی لمحے ایک آواز آتی ہے، کیسی؟';

  @override
  String get hintProblem2 => 'سب سے پہلے کیا بگڑتا ہے؟';

  @override
  String hintProblem3(String who) {
    return '«$who» پہلے کیا آزماتا ہے، اور وہ کیوں نہیں چلتا؟';
  }

  @override
  String get hintProblem4 => 'مدد کر سکنے کے باوجود کون انکار کرتا ہے؟';

  @override
  String get hintProblem5 => 'اگر ابھی سب ہار مان لیں تو کیا ہوگا؟';

  @override
  String get hintProblem6 => 'کیا اس رکاوٹ میں کوئی اداس بات ہے؟';

  @override
  String hintProblem7(String who) {
    return 'اس لمحے «$who» بلند آواز سے کیا کہتا ہے؟';
  }

  @override
  String hintEnding1(String who) {
    return 'آخر میں «$who» اسے کیسے توڑتا ہے، طاقت سے یا ترکیب سے؟';
  }

  @override
  String get hintEnding2 => 'ضرورت نہ ہونے پر بھی کون مدد کرتا ہے؟';

  @override
  String hintEnding3(String who) {
    return 'سب ختم ہونے پر «$who» سب سے پہلے کیا کرتا ہے؟';
  }

  @override
  String get hintEnding4 => 'شروع کے مقابلے میں انجام میں کیا مختلف ہے؟';

  @override
  String hintEnding5(String who) {
    return '«$who» کہاں لوٹتا ہے اور وہاں کون انتظار کر رہا ہے؟';
  }

  @override
  String get hintEnding6 => 'روشنی جلنے سے پہلے آخری جملہ کیا ہے؟';

  @override
  String get globeLoading => 'سیارہ تیار کر رہا ہوں…';

  @override
  String get globeLoadFailed => 'سیارہ لوڈ نہیں ہو سکا۔';

  @override
  String get globeTitle => 'کہانی کہاں کی ہوگی؟';

  @override
  String get globeStored => 'ڈاؤن لوڈ کی ہوئی کہانیاں';

  @override
  String get globeHintFar =>
      'سیارے کو گھمائیں یا کسی ملک کو چھوئیں۔ سبز ملکوں کی کہانیاں ہمارے ذخیرے میں ہیں، سرمئی ملکوں کی ابھی نہیں۔';

  @override
  String get globeHintNear =>
      'کسی ملک یا عمارت کو چھوئیں۔ سبز ملکوں کی کہانیاں ہمارے ذخیرے میں ہیں، سرمئی ملکوں کی ابھی نہیں۔';

  @override
  String get globeWhole => 'پورا سیارہ';

  @override
  String get globeZoomIn => 'قریب لائیں';

  @override
  String get globeZoomOut => 'دور کریں';

  @override
  String globeZoomToRegion(String name) {
    return '$name کو قریب لائیں ←';
  }

  @override
  String get globeTellHere => 'یہاں کی کہانی سنائیں';

  @override
  String globeTellFrom(String place) {
    return '$place کی کہانی سنائیں ←';
  }

  @override
  String get globeOpenSea => 'کھلا سمندر';

  @override
  String globeRegionCountries(int n) {
    return '$n ملک اکٹھے۔ قریب لا کر ایک چنیں۔';
  }

  @override
  String get globeTurnToCountry => 'سیارے کو کسی ملک کی طرف گھمائیں۔';

  @override
  String get globeSpin => 'گھمائیں';

  @override
  String get globeNoTales => 'یہاں کی کوئی کہانی ابھی ہمارے پاس نہیں ہے۔';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n عناصر',
      one: '$n عنصر',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیوں سے',
      one: '$n کہانی سے',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + پیک سے $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'پیک سے $n عناصر',
      one: 'پیک سے $n عنصر',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return 'یہاں کی $_temp0 $region پیک کے لیے تیار کر رہے ہیں۔';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return '$_temp0 مفت';
  }

  @override
  String cardFree(int n) {
    return '$n مفت';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range حصوں میں $n',
      one: '$region $range حصے میں $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'آپ کے پاس $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'مزید $n آ رہی ہیں',
      one: 'مزید $n آ رہی ہے',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'اسٹور کا انتظار…';

  @override
  String offerDownloading(int percent) {
    return 'کہانیاں ڈاؤن لوڈ ہو رہی ہیں… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return '$name خریدیں: $_temp0، $price میں';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return '$name ڈاؤن لوڈ کریں: $_temp0 مفت ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n کہانیاں',
      one: '$n کہانی',
    );
    return '$name ڈاؤن لوڈ کریں: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name ڈاؤن لوڈ کریں';
  }

  @override
  String get errDownloadTales => 'کہانیاں ڈاؤن لوڈ نہیں ہو سکیں۔';

  @override
  String get errDownloadScenes => 'تصاویر ڈاؤن لوڈ نہیں ہو سکیں۔';

  @override
  String get errNoDownloads => 'یہاں ڈاؤن لوڈ دستیاب نہیں ہے۔';

  @override
  String get errOffline => 'انٹرنیٹ نہیں ہے، سگنل آنے پر دوبارہ کوشش کریں۔';

  @override
  String get errCannotBuy => 'یہ حصہ ابھی خریدا نہیں جا سکتا۔';

  @override
  String get buyPending =>
      'خریداری منظوری کے انتظار میں ہے۔ منظور ہوتے ہی حصہ ڈاؤن لوڈ ہو جائے گا۔';

  @override
  String get buyFailed => 'خریداری مکمل نہیں ہوئی۔';

  @override
  String get restoreNone => 'اس اکاؤنٹ میں کوئی خریداری نہیں ہے۔';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حصے بحال ہو گئے۔ آپ انہیں سیارے سے ڈاؤن لوڈ کر سکتے ہیں۔',
      one: '$n حصہ بحال ہو گیا۔ آپ اسے سیارے سے ڈاؤن لوڈ کر سکتے ہیں۔',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'خریداریاں بحال نہیں ہو سکیں، سگنل آنے پر دوبارہ کوشش کریں۔';

  @override
  String get narrationGone => 'یہ کہانی اب ترتیب میں نہیں ہے۔';

  @override
  String get narrationNew => 'نئی ترتیب دیں';

  @override
  String narrationTitle(int index, int total) {
    return 'آپ سنا رہے ہیں — $total میں سے $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'کیسے جوڑیں: $bridge';
  }

  @override
  String get narrationSituation =>
      'ابھی کیا ہو رہا ہے؟ (اختیاری، بول کر لکھوا سکتے ہیں)';

  @override
  String get narrationHintNote =>
      'اشارہ، اسے بلند آواز سے نہ پڑھیں، بس یہیں سے آغاز کریں۔';

  @override
  String get narrationSoundsNote => 'آوازیں، کہانی سے میل کھائیں تو چلائیں۔';

  @override
  String get moodTense => 'تناؤ';

  @override
  String get moodCalm => 'سکون';

  @override
  String get narrationSearching => 'تلاش ہو رہی ہے…';

  @override
  String get narrationHint => 'اشارہ دیں';

  @override
  String get narrationMoreHint => 'ایک اور';

  @override
  String get narrationBack => 'پیچھے';

  @override
  String get narrationEnd => 'ختم';

  @override
  String get narrationNext => 'اگلا ←';

  @override
  String get narrationGoodnight => 'شب بخیر۔';

  @override
  String get narrationEndNote =>
      'آخری تصویر بنانا اور لائبریری میں محفوظ کرنا ہم ابھی نہیں کر سکتے۔ یہ کہانی کہیں نہیں جاتی، آپ دونوں کے درمیان ہی رہتی ہے۔';

  @override
  String get narrationClose => 'بند کریں';

  @override
  String get ragFallback =>
      'اس کے لیے پیک میں ابھی کچھ نہیں ہے، ایک عمومی اشارہ:';

  @override
  String get ragNoModel => 'اشارہ ماڈل اس ورژن میں شامل نہیں ہے۔';

  @override
  String get ragHintGeneral => 'عمومی';

  @override
  String get ragHintMotif => 'عنصر کے لیے';

  @override
  String get captionExact => 'تصویر · اس عنصر کے لیے';

  @override
  String get captionSimilar => 'تصویر · ملتا جلتا منظر';

  @override
  String get captionCard => 'عنصر کارڈ · اس مرحلے کے لیے ابھی منظر نہیں ہے';

  @override
  String get storageTitle => 'ڈاؤن لوڈ کی ہوئی کہانیاں';

  @override
  String get storageEmpty =>
      'ابھی کچھ نہیں، مزید کہانیاں سیارے سے ڈاؤن لوڈ ہوں گی۔';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n پیک',
      one: '$n پیک',
    );
    return '$_temp0، $size';
  }

  @override
  String storageScenes(String name) {
    return '$name کے مناظر';
  }

  @override
  String get storageFreeTier => 'مفت';

  @override
  String get storageBoughtTier => 'خریدی ہوئی';

  @override
  String get storageDelete => 'حذف کریں';

  @override
  String get storageScenesSub => 'سنانے کے ہر مرحلے کے لیے ایک تصویر';

  @override
  String get storageDownload => 'ڈاؤن لوڈ کریں';

  @override
  String get storageAllUsed => 'پچھلے 30 دنوں میں سب کچھ استعمال ہوا ہے۔';

  @override
  String storageFreed(String size) {
    return '$size خالی ہوئی۔';
  }

  @override
  String get storageFreeUp => 'جگہ خالی کریں (30 دن سے غیر استعمال شدہ)';

  @override
  String get storageRestoring => 'خریداریاں بحال ہو رہی ہیں…';

  @override
  String get storageRestore => 'خریداریاں بحال کریں';

  @override
  String get osnovaTitle => 'خاکہ';

  @override
  String get osnovaSummary => 'مختصراً کہانی';

  @override
  String get osnovaCharacters => 'کردار';

  @override
  String get osnovaTask => 'کام';

  @override
  String get osnovaProblem => 'مسئلہ';

  @override
  String get osnovaEnding => 'انجام';

  @override
  String get osnovaAgain => 'دوبارہ';

  @override
  String get osnovaTell => 'میں سناتا ہوں ←';

  @override
  String get outlineHero => 'ہیرو';

  @override
  String get castFox => 'چالاک لومڑی';

  @override
  String get castSmithSon => 'لوہار کا بیٹا';

  @override
  String get castMill => 'بولتی چکی';

  @override
  String get castGooseGirl => 'بطخ چرانے والی لڑکی';

  @override
  String get castBrothers => 'تین بھائی';

  @override
  String get castClockworkPrincess => 'گھڑی ساز کی شہزادی';

  @override
  String get castOwl => 'دانا الو';

  @override
  String get castBlacksmith => 'بوڑھی لوہارن';

  @override
  String get castDragon => 'ننھا ڈریگن';

  @override
  String get castWaterSprite => 'پانی کا جن';

  @override
  String get castFourPrincesses => 'چار شہزادیاں';

  @override
  String get castTravelingTailor => 'آوارہ درزی';

  @override
  String get castTalkingCat => 'بولتی بلی';

  @override
  String get castForestHermit => 'جنگل کا سادھو';

  @override
  String get castC0AndersenTheShadow => 'وہ صاحب جو کبھی سایہ تھے';

  @override
  String get castC1GrimmTheGooseGirl => 'دغاباز خادمہ';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'آسیب زدہ قلعے والا بادشاہ';

  @override
  String get castC3AndersenTheShadow => 'چالاک سایہ';

  @override
  String get castC4PerraultRiquetWithTheTuft => 'خوبصورت مگر کم عقل شہزادی';

  @override
  String get castC5AndersenTheRedShoes => 'آخر میں معاف کرنے والا فرشتہ';

  @override
  String get castC6GrimmRumpelstiltskin => 'چکی والے کی ہوشیار بیٹی';

  @override
  String get castC7PerraultLittleRedRidingHood => 'دروازہ کھولنے والی دادی';

  @override
  String get castC8PerraultLittleThumb => 'غربت اور محبت کے بیچ ایک ماں';

  @override
  String get castC9PerraultIntroduction => 'صابر عورت';

  @override
  String get castC10AndersenTheRealPrincess => 'بیٹے کا ساتھ دینے والا بادشاہ';

  @override
  String get castC11GrimmLilyAndTheLion => 'وعدہ نبھانے والی بیٹی';

  @override
  String get castC12AndersenTheRealPrincess => 'سچی شہزادی کو ڈھونڈتا شہزادہ';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'ماچس بیچنے والی ننھی بچی';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'خاموش رہنے والا درباری';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'دعوت تیار کرتا وفادار نوکر';

  @override
  String get castC16PerraultTheFairy => 'مغرور بیٹی';

  @override
  String get castC17GrimmFirstStory => 'نو دُمیں چاہنے والی بیوہ';

  @override
  String get motifTaskWine => 'پورا تہہ خانہ شراب کون پیئے گا';

  @override
  String get motifTaskDiamonds => 'ہیروں کی تلاش میں پرواز';

  @override
  String get motifTaskRingDuck => 'بطخ کے اندر انگوٹھی';

  @override
  String get motifTaskGiants => 'دیووں کو چکمہ دینا';

  @override
  String get motifTaskTomThumb => 'انگوٹھے جتنے لڑکے کا فرار';

  @override
  String get motifTaskSwineherd => 'شہزادی کا دل جیتنا';

  @override
  String get motifTaskBell => 'جنگل میں پراسرار گھنٹی';

  @override
  String get motifTaskGoldenObject => 'ایسا تحفہ جس کا غلط استعمال نہ ہو';

  @override
  String get motifTaskPebbles => 'کنکریوں کی پگڈنڈی';

  @override
  String get motifProblemFoxPride => 'لومڑی کا غرور';

  @override
  String get motifProblemLazySister => 'سست بہن';

  @override
  String get motifProblemWitchBoots => 'سات کوس کے جوتوں والی چڑیل';

  @override
  String get motifProblemTailorDoubt => 'کوئی اس پر یقین نہیں کرتا';

  @override
  String get motifProblemLions => 'پھاٹک پر بھوکے شیر';

  @override
  String get motifProblemEagle => 'عقاب اور بونا';

  @override
  String get motifProblemTruth => 'جادوئی جانور سچ بتا دیتا ہے';

  @override
  String get motifProblemOldHouse => 'پرانا گھر کسی کو نہیں چاہیے';

  @override
  String get motifProblemBreadcrumbs => 'پرندوں نے ٹکڑے کھا لیے';

  @override
  String get motifEndingTrickWins => 'چالاکی جیت جاتی ہے';

  @override
  String get motifEndingTruthChild => 'بچہ سچ بولتا ہے';

  @override
  String get motifEndingNewHome => 'نیا گھر، پرانے دوست';

  @override
  String get motifEndingHappyTogether => 'ہمیشہ خوشی سے ساتھ';

  @override
  String get motifEndingKissWakes => 'ایک بوسہ سلطنت کو جگاتا ہے';

  @override
  String get motifEndingLeapfrog => 'چالاکی سب سے اونچی چھلانگ لگاتی ہے';

  @override
  String get motifEndingCurseBroken => 'لعنت ٹوٹ گئی';

  @override
  String get motifEndingWelcomedHome => 'گھر پر استقبال';

  @override
  String get motifEndingSlipper => 'کھویا ہوا جوتا';
}
