// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get castTitle => 'من سيكون في الحكاية؟';

  @override
  String get castHint =>
      'المس بطاقة لتحصل على شخصية أخرى، واحذف البطاقة بالعلامة ×. الموسيقى والأصوات جاهزة دائمًا من حزمة البلد، أما صورة الشخصية فقد تُرسم بعد لحظة.';

  @override
  String get castAdd => 'أضف شخصية';

  @override
  String get castCount => 'الشخصيات:';

  @override
  String get castShuffleAll => 'اخلط الكل';

  @override
  String get castContinue => 'متابعة ←';

  @override
  String get shuffle => 'اخلط';

  @override
  String get motifTaskTitle => 'أي مهمة؟';

  @override
  String get motifProblemTitle => 'أي مشكلة؟';

  @override
  String get motifEndingTitle => 'أي خاتمة؟';

  @override
  String get motifTaskCaption => 'المس بطاقة لتختار مهمة البطل.';

  @override
  String get motifProblemCaption => 'المس بطاقة لتختار عقبة أو شريرًا.';

  @override
  String get motifEndingCaption => 'المس بطاقة لتختار نهاية سعيدة.';

  @override
  String get beatCastTitle => 'من في الحكاية';

  @override
  String get beatTaskTitle => 'ما الذي عزم عليه البطل';

  @override
  String get beatProblemTitle => 'ما الذي وقف في طريقه';

  @override
  String get beatEndingTitle => 'كيف انتهت';

  @override
  String get beatCastCaption =>
      'عرّف بالشخصيات: أين هم، وكيف يبدون، وما الذي يميّزهم.';

  @override
  String get beatTaskCaption => 'قل ما يريده البطل ولماذا انطلق من أجله.';

  @override
  String get beatProblemCaption =>
      'ضع شيئًا في طريقه، وليبدُ لبعض الوقت أن الأمر لن ينجح.';

  @override
  String get beatEndingCaption =>
      'وصِل الحكاية إلى نهايتها ولا تستعجل، فالطفل يتذكّر النهاية أكثر من أي شيء.';

  @override
  String get hintHero => 'البطل';

  @override
  String hintCast1(String who) {
    return 'كيف تبدو الشخصية «$who» حين تظهر للمرة الأولى؟';
  }

  @override
  String hintCast2(String who) {
    return 'ماذا تفعل الشخصية «$who» قبل أن تبدأ الحكاية كلها؟';
  }

  @override
  String hintCast3(String who) {
    return 'مما تخاف الشخصية «$who»؟';
  }

  @override
  String hintCast4(String who) {
    return 'بماذا تعرف أن الشخصية «$who» قادمة؟';
  }

  @override
  String get hintCast5 => 'من منهم يعرف الآخر منذ زمن طويل، ومن أين؟';

  @override
  String get hintCast6 => 'كيف يكون الطقس حين يلتقون؟';

  @override
  String hintCast7(String who) {
    return 'ماذا تحمل الشخصية «$who» في جيبها؟';
  }

  @override
  String hintTask1(String who) {
    return 'متى تدرك الشخصية «$who» أنه لا بدّ أن تبدأ؟';
  }

  @override
  String hintTask2(String who) {
    return 'من نصح بذلك، ولماذا تسمع الشخصية «$who» له؟';
  }

  @override
  String hintTask3(String who) {
    return 'ماذا يجب أن تترك الشخصية «$who» في البيت؟';
  }

  @override
  String get hintTask4 => 'كم يطول الطريق، وماذا يعبر؟';

  @override
  String hintTask5(String who) {
    return 'ماذا تعد الشخصية «$who» نفسها قبل أن تنطلق؟';
  }

  @override
  String get hintTask6 => 'لماذا لا يستطيع شخص آخر أن يفعل ذلك؟';

  @override
  String get hintProblem1 => 'في تلك اللحظة يُسمع صوت، فما هو؟';

  @override
  String get hintProblem2 => 'ما أول شيء يسوء؟';

  @override
  String hintProblem3(String who) {
    return 'ما أول ما تجربه الشخصية «$who»، ولماذا يفشل؟';
  }

  @override
  String get hintProblem4 => 'من يرفض المساعدة مع أنه قادر عليها؟';

  @override
  String get hintProblem5 => 'ماذا سيحدث لو استسلم الجميع الآن؟';

  @override
  String get hintProblem6 => 'هل في هذه العقبة شيء حزين؟';

  @override
  String hintProblem7(String who) {
    return 'ماذا تقول الشخصية «$who» بصوت عالٍ في تلك اللحظة؟';
  }

  @override
  String hintEnding1(String who) {
    return 'بماذا تتغلب الشخصية «$who» على ذلك في النهاية: بالقوة أم بفكرة؟';
  }

  @override
  String get hintEnding2 => 'من يساعد مع أنه لم يكن مضطرًا؟';

  @override
  String hintEnding3(String who) {
    return 'ما أول ما تفعله الشخصية «$who» حين ينتهي كل شيء؟';
  }

  @override
  String get hintEnding4 => 'ما الذي تغيّر في النهاية عمّا كان في البداية؟';

  @override
  String hintEnding5(String who) {
    return 'إلى أين تعود الشخصية «$who» ومن ينتظرها هناك؟';
  }

  @override
  String get hintEnding6 => 'ما الجملة الأخيرة قبل أن يضيء النور؟';

  @override
  String get globeLoading => 'أجهّز الكوكب…';

  @override
  String get globeLoadFailed => 'تعذّر تحميل الكوكب.';

  @override
  String get globeTitle => 'من أين ستأتي الحكاية؟';

  @override
  String get globeStored => 'الحكايات المنزَّلة';

  @override
  String get globeHintFar =>
      'أدِر الكوكب أو المس بلدًا. البلدان الخضراء لديها حكايات من مجموعتنا، والرمادية ليس بعد.';

  @override
  String get globeHintNear =>
      'المس بلدًا أو معلمًا. البلدان الخضراء لديها حكايات من مجموعتنا، والرمادية ليس بعد.';

  @override
  String get globeWhole => 'الكوكب كله';

  @override
  String get globeZoomIn => 'تقريب';

  @override
  String get globeZoomOut => 'تبعيد';

  @override
  String globeZoomToRegion(String name) {
    return 'قرّب على $name ←';
  }

  @override
  String get globeTellHere => 'احكِ حكاية من هنا';

  @override
  String globeTellFrom(String place) {
    return 'احكِ حكاية من $place ←';
  }

  @override
  String get globeOpenSea => 'البحر المفتوح';

  @override
  String globeRegionCountries(int n) {
    return '$n بلدًا معًا. قرّب واختر واحدًا منها.';
  }

  @override
  String get globeTurnToCountry => 'أدِر الكوكب نحو بلد ما.';

  @override
  String get globeSpin => 'أدِر';

  @override
  String get globeNoTales => 'ليست لدينا حكايات من هنا بعد.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n فكرة',
      many: '$n فكرة',
      few: '$n أفكار',
      two: 'فكرتان',
      one: 'فكرة واحدة',
      zero: 'لا أفكار',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'من $n حكاية',
      many: 'من $n حكاية',
      few: 'من $n حكايات',
      two: 'من حكايتين',
      one: 'من حكاية واحدة',
      zero: 'من لا حكايات',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs من الحزمة';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n فكرة من الحزمة',
      many: '$n فكرة من الحزمة',
      few: '$n أفكار من الحزمة',
      two: 'فكرتان من الحزمة',
      one: 'فكرة واحدة من الحزمة',
      zero: 'لا أفكار من الحزمة',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتين',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return 'نجهّز من هنا $_temp0 لحزمة $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتان',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتان',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return '$_temp0 مجانًا';
  }

  @override
  String cardFree(int n) {
    return '$n مجانًا';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n في الأجزاء $region $range',
      one: '$n في الجزء $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'لديك $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'نجهّز $n حكاية أخرى',
      many: 'نجهّز $n حكاية أخرى',
      few: 'نجهّز $n حكايات أخرى',
      two: 'نجهّز حكايتين أخريين',
      one: 'نجهّز حكاية أخرى',
      zero: 'لا شيء آخر قادم',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'بانتظار المتجر…';

  @override
  String offerDownloading(int percent) {
    return 'جارٍ تنزيل الحكايات… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتان',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return 'اشترِ $name: $_temp0 بسعر $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتان',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return 'نزّل $name: $_temp0 مجانًا ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حكاية',
      many: '$n حكاية',
      few: '$n حكايات',
      two: 'حكايتان',
      one: 'حكاية واحدة',
      zero: 'لا حكايات',
    );
    return 'نزّل $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'نزّل $name';
  }

  @override
  String get errDownloadTales => 'تعذّر تنزيل الحكايات.';

  @override
  String get errDownloadScenes => 'تعذّر تنزيل الصور.';

  @override
  String get errNoDownloads => 'التنزيل غير متاح هنا.';

  @override
  String get errOffline =>
      'لا يوجد اتصال بالإنترنت، جرّب مرة أخرى عندما تكون الإشارة متاحة.';

  @override
  String get errCannotBuy => 'لا يمكن شراء هذا الجزء الآن.';

  @override
  String get buyPending =>
      'عملية الشراء بانتظار الموافقة. سيُنزَّل الجزء بعد اكتمالها.';

  @override
  String get buyFailed => 'لم تتم عملية الشراء.';

  @override
  String get restoreNone => 'لا توجد مشتريات في هذا الحساب.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'استُعيد $n جزء. يمكنك تنزيلها من الكوكب.',
      many: 'استُعيد $n جزءًا. يمكنك تنزيلها من الكوكب.',
      few: 'استُعيدت $n أجزاء. يمكنك تنزيلها من الكوكب.',
      two: 'استُعيد جزءان. يمكنك تنزيلهما من الكوكب.',
      one: 'استُعيد جزء واحد. يمكنك تنزيله من الكوكب.',
      zero: 'لم تُستعد أجزاء.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'تعذّرت استعادة المشتريات، جرّب مرة أخرى عندما تكون الإشارة متاحة.';

  @override
  String get narrationGone => 'لم تعد هذه الحكاية مركّبة.';

  @override
  String get narrationNew => 'ركّب حكاية جديدة';

  @override
  String narrationTitle(int index, int total) {
    return 'أنت تحكي — $index من $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'كيف تتابع: $bridge';
  }

  @override
  String get narrationSituation => 'ماذا يحدث الآن؟ (اختياري، ويمكنك الإملاء)';

  @override
  String get narrationHintNote => 'تلميح، لا تقله بصوت عالٍ، بل انطلق منه.';

  @override
  String get narrationSoundsNote => 'الأصوات، شغّلها عندما تناسب الحكاية.';

  @override
  String get moodTense => 'توتر';

  @override
  String get moodCalm => 'هدوء';

  @override
  String get narrationSearching => 'أبحث…';

  @override
  String get narrationHint => 'ساعدني';

  @override
  String get narrationMoreHint => 'واحد آخر';

  @override
  String get narrationBack => 'رجوع';

  @override
  String get narrationEnd => 'النهاية';

  @override
  String get narrationNext => 'التالي ←';

  @override
  String get narrationGoodnight => 'تصبح على خير.';

  @override
  String get narrationEndNote =>
      'لا نستطيع بعد رسم صورة ختامية أو الحفظ في المكتبة، فهذه الحكاية لا تذهب إلى أي مكان، بل تبقى بينكما.';

  @override
  String get narrationClose => 'إغلاق';

  @override
  String get ragFallback => 'لا شيء من الحزمة لهذا بعد، إليك تلميحًا عامًا:';

  @override
  String get ragNoModel => 'نموذج التلميحات غير موجود في هذا الإصدار.';

  @override
  String get ragHintGeneral => 'عام';

  @override
  String get ragHintMotif => 'للفكرة';

  @override
  String get captionExact => 'رسم توضيحي · لهذه الفكرة';

  @override
  String get captionSimilar => 'رسم توضيحي · مشهد مشابه';

  @override
  String get captionCard => 'بطاقة الفكرة · لا يوجد لدينا مشهد لهذه الخطوة بعد';

  @override
  String get storageTitle => 'الحكايات المنزَّلة';

  @override
  String get storageEmpty => 'لا شيء بعد، ستُنزَّل مزيد من الحكايات من الكوكب.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n حزمة',
      many: '$n حزمة',
      few: '$n حزم',
      two: 'حزمتان',
      one: 'حزمة واحدة',
      zero: 'لا حزم',
    );
    return '$_temp0، $size';
  }

  @override
  String storageScenes(String name) {
    return 'مشاهد $name';
  }

  @override
  String get storageFreeTier => 'مجانًا';

  @override
  String get storageBoughtTier => 'مشتراة';

  @override
  String get storageDelete => 'حذف';

  @override
  String get storageScenesSub => 'صورة لكل خطوة من خطوات الحكاية';

  @override
  String get storageDownload => 'تنزيل';

  @override
  String get storageAllUsed => 'استُخدم كل شيء خلال آخر 30 يومًا.';

  @override
  String storageFreed(String size) {
    return 'تم تحرير $size.';
  }

  @override
  String get storageFreeUp => 'تحرير مساحة (غير مستخدم منذ 30 يومًا)';

  @override
  String get storageRestoring => 'جارٍ استعادة المشتريات…';

  @override
  String get storageRestore => 'استعادة المشتريات';

  @override
  String get osnovaTitle => 'المخطط';

  @override
  String get osnovaSummary => 'الحكاية باختصار';

  @override
  String get osnovaCharacters => 'الشخصيات';

  @override
  String get osnovaTask => 'المهمة';

  @override
  String get osnovaProblem => 'المشكلة';

  @override
  String get osnovaEnding => 'النهاية';

  @override
  String get osnovaAgain => 'من جديد';

  @override
  String get osnovaTell => 'سأحكي ←';

  @override
  String get outlineHero => 'البطل';

  @override
  String get castFox => 'الثعلب الذكي';

  @override
  String get castSmithSon => 'ابن الحداد';

  @override
  String get castMill => 'الطاحونة المتكلمة';

  @override
  String get castGooseGirl => 'راعية الإوز';

  @override
  String get castBrothers => 'الإخوة الثلاثة';

  @override
  String get castClockworkPrincess => 'أميرة صانع الساعات';

  @override
  String get castOwl => 'البومة الحكيمة';

  @override
  String get castBlacksmith => 'الحدادة العجوز';

  @override
  String get castDragon => 'التنين الصغير';

  @override
  String get castWaterSprite => 'جنّي الماء';

  @override
  String get castFourPrincesses => 'الأميرات الأربع';

  @override
  String get castTravelingTailor => 'الخيّاط الجوّال';

  @override
  String get castTalkingCat => 'القط المتكلم';

  @override
  String get castForestHermit => 'ناسك الغابة';

  @override
  String get castC0AndersenTheShadow => 'السيد الذي كان ظلًّا';

  @override
  String get castC1GrimmTheGooseGirl => 'الوصيفة الخائنة';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'الملك صاحب القلعة المسكونة';

  @override
  String get castC3AndersenTheShadow => 'الظل الذكي';

  @override
  String get castC4PerraultRiquetWithTheTuft => 'الأميرة الجميلة قليلة الفطنة';

  @override
  String get castC5AndersenTheRedShoes => 'الملاك الذي يسامح في النهاية';

  @override
  String get castC6GrimmRumpelstiltskin => 'ابنة الطحان الذكية';

  @override
  String get castC7PerraultLittleRedRidingHood => 'الجدة التي تفتح الباب';

  @override
  String get castC8PerraultLittleThumb => 'أم بين الفقر والمحبة';

  @override
  String get castC9PerraultIntroduction => 'المرأة الصبورة';

  @override
  String get castC10AndersenTheRealPrincess => 'الملك الذي يسند ابنه';

  @override
  String get castC11GrimmLilyAndTheLion => 'الابنة التي تفي بكلمتها';

  @override
  String get castC12AndersenTheRealPrincess =>
      'الأمير يبحث عن الأميرة الحقيقية';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'بائعة الكبريت الصغيرة';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'رجل الحاشية الصامت';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'الخادم الوفيّ يعدّ مأدبة';

  @override
  String get castC16PerraultTheFairy => 'الابنة المغرورة';

  @override
  String get castC17GrimmFirstStory => 'الأرملة التي تريد تسعة ذيول';

  @override
  String get motifTaskWine => 'من سيشرب قبو النبيذ';

  @override
  String get motifTaskDiamonds => 'رحلة بحثًا عن الألماس';

  @override
  String get motifTaskRingDuck => 'الخاتم داخل البطة';

  @override
  String get motifTaskGiants => 'خداع العمالقة';

  @override
  String get motifTaskTomThumb => 'هروب إبهام الصغير';

  @override
  String get motifTaskSwineherd => 'كسب قلب الأميرة';

  @override
  String get motifTaskBell => 'الجرس الغامض في الغابة';

  @override
  String get motifTaskGoldenObject => 'هدية لا يجوز إساءة استخدامها';

  @override
  String get motifTaskPebbles => 'درب من الحصى';

  @override
  String get motifProblemFoxPride => 'غرور الثعلب';

  @override
  String get motifProblemLazySister => 'الأخت الكسولة';

  @override
  String get motifProblemWitchBoots => 'الساحرة بحذاء الفراسخ السبعة';

  @override
  String get motifProblemTailorDoubt => 'لا أحد يصدّقه';

  @override
  String get motifProblemLions => 'أسود جائعة عند البوابة';

  @override
  String get motifProblemEagle => 'النسر والقزم';

  @override
  String get motifProblemTruth => 'الحيوان السحري يكشف الحقيقة';

  @override
  String get motifProblemOldHouse => 'لا أحد يريد البيت القديم';

  @override
  String get motifProblemBreadcrumbs => 'الطيور أكلت الفتات';

  @override
  String get motifEndingTrickWins => 'الذكاء ينتصر';

  @override
  String get motifEndingTruthChild => 'الطفل يقول الحقيقة';

  @override
  String get motifEndingNewHome => 'بيت جديد وأصدقاء قدامى';

  @override
  String get motifEndingHappyTogether => 'سعداء معًا إلى الأبد';

  @override
  String get motifEndingKissWakes => 'قبلة توقظ المملكة';

  @override
  String get motifEndingLeapfrog => 'الذكاء يقفز أعلى';

  @override
  String get motifEndingCurseBroken => 'انكسار اللعنة';

  @override
  String get motifEndingWelcomedHome => 'استقبال حار في البيت';

  @override
  String get motifEndingSlipper => 'النعل الضائع';
}
