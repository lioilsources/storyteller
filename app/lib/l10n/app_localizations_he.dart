// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hebrew (`he`).
class AppLocalizationsHe extends AppLocalizations {
  AppLocalizationsHe([String locale = 'he']) : super(locale);

  @override
  String get castTitle => 'מי יהיו באגדה?';

  @override
  String get castHint =>
      'הקש על קלף כדי לקבל דמות אחרת. מחק קלף באמצעות ה־X. המוזיקה והצלילים תמיד מוכנים מחבילת המדינה, ורק תמונת הדמות לפעמים מצטיירת רגע אחר כך.';

  @override
  String get castAdd => 'הוסף דמות';

  @override
  String get castCount => 'ההרכב:';

  @override
  String get castShuffleAll => 'ערבב הכול';

  @override
  String get castContinue => 'המשך ←';

  @override
  String get shuffle => 'ערבב';

  @override
  String get motifTaskTitle => 'איזו משימה?';

  @override
  String get motifProblemTitle => 'איזו בעיה?';

  @override
  String get motifEndingTitle => 'איזה סוף?';

  @override
  String get motifTaskCaption => 'הקש על קלף כדי לבחור את משימת הגיבור.';

  @override
  String get motifProblemCaption => 'הקש על קלף כדי לבחור מכשול או נבל.';

  @override
  String get motifEndingCaption => 'הקש על קלף כדי לבחור סוף טוב.';

  @override
  String get beatCastTitle => 'מי נמצא בסיפור';

  @override
  String get beatTaskTitle => 'מה הגיבור התכוון לעשות';

  @override
  String get beatProblemTitle => 'מה עמד בדרכו';

  @override
  String get beatEndingTitle => 'איך זה נגמר';

  @override
  String get beatCastCaption =>
      'הצג את הדמויות: איפה הן, איך הן נראות, מה מיוחד בהן.';

  @override
  String get beatTaskCaption => 'ספר מה הגיבור רוצה ולמה יצא לדרך.';

  @override
  String get beatProblemCaption => 'הצב משהו בדרכו. שייראה לרגע שזה לא יצליח.';

  @override
  String get beatEndingCaption =>
      'הבא את הסיפור אל סופו. אל תמהר, ילד זוכר את הסוף יותר מכול.';

  @override
  String get hintHero => 'הגיבור';

  @override
  String hintCast1(String who) {
    return 'איך נראה «$who» כשהוא מופיע בפעם הראשונה?';
  }

  @override
  String hintCast2(String who) {
    return 'מה עושה «$who» ממש לפני שכל הסיפור מתחיל?';
  }

  @override
  String hintCast3(String who) {
    return 'ממה מפחד «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'איך תדע ש«$who» מגיע?';
  }

  @override
  String get hintCast5 => 'מי מהם מכירים זה את זה זמן רב, ומאיפה?';

  @override
  String get hintCast6 => 'איזה מזג אוויר יש כשהם נפגשים?';

  @override
  String hintCast7(String who) {
    return 'מה יש ל«$who» בכיס?';
  }

  @override
  String hintTask1(String who) {
    return 'מתי «$who» מבין שצריך להתחיל לפעול?';
  }

  @override
  String hintTask2(String who) {
    return 'מי נתן את העצה, ולמה «$who» מקשיב?';
  }

  @override
  String hintTask3(String who) {
    return 'מה «$who» צריך להשאיר בבית?';
  }

  @override
  String get hintTask4 => 'כמה ארוכה הדרך ומה היא חוצה?';

  @override
  String hintTask5(String who) {
    return 'מה «$who» מבטיח לעצמו לפני שיוצא?';
  }

  @override
  String get hintTask6 => 'למה אף אחד אחר לא יכול לעשות את זה?';

  @override
  String get hintProblem1 => 'באותו רגע נשמע קול, איזה?';

  @override
  String get hintProblem2 => 'מה משתבש ראשון?';

  @override
  String hintProblem3(String who) {
    return 'מה «$who» מנסה קודם, ולמה זה לא מצליח?';
  }

  @override
  String get hintProblem4 => 'מי מסרב לעזור אף שהיה יכול?';

  @override
  String get hintProblem5 => 'מה היה קורה אילו כולם היו מוותרים עכשיו?';

  @override
  String get hintProblem6 => 'יש במכשול הזה משהו עצוב?';

  @override
  String hintProblem7(String who) {
    return 'מה «$who» אומר בקול באותו רגע?';
  }

  @override
  String hintEnding1(String who) {
    return 'במה «$who» מנצח את זה בסוף, בכוח או ברעיון?';
  }

  @override
  String get hintEnding2 => 'מי עוזר אף שלא היה חייב?';

  @override
  String hintEnding3(String who) {
    return 'מה «$who» עושה קודם כול כשהכול נגמר?';
  }

  @override
  String get hintEnding4 => 'מה שונה בסוף לעומת ההתחלה?';

  @override
  String hintEnding5(String who) {
    return 'לאן «$who» חוזר ומי מחכה שם?';
  }

  @override
  String get hintEnding6 => 'מהו המשפט האחרון לפני שהאור נדלק?';

  @override
  String get globeLoading => 'מכין את כדור הארץ…';

  @override
  String get globeLoadFailed => 'לא ניתן היה לטעון את הכוכב.';

  @override
  String get globeTitle => 'מאיפה תהיה האגדה?';

  @override
  String get globeStored => 'אגדות שהורדו';

  @override
  String get globeHintFar =>
      'סובב את הכוכב או הקש על מדינה. למדינות הירוקות כבר יש אגדות מהאוסף שלנו, לאפורות עוד לא.';

  @override
  String get globeHintNear =>
      'הקש על מדינה או על מבנה. למדינות הירוקות כבר יש אגדות מהאוסף שלנו, לאפורות עוד לא.';

  @override
  String get globeWhole => 'כל הכוכב';

  @override
  String get globeZoomIn => 'התקרב';

  @override
  String get globeZoomOut => 'התרחק';

  @override
  String globeZoomToRegion(String name) {
    return 'התקרב אל $name ←';
  }

  @override
  String get globeTellHere => 'ספר אגדה מכאן';

  @override
  String globeTellFrom(String place) {
    return 'ספר אגדה מ־$place ←';
  }

  @override
  String get globeOpenSea => 'ים פתוח';

  @override
  String globeRegionCountries(int n) {
    return '$n מדינות יחד. התקרב ובחר אחת.';
  }

  @override
  String get globeTurnToCountry => 'סובב את הכוכב אל איזו מדינה.';

  @override
  String get globeSpin => 'סובב';

  @override
  String get globeNoTales => 'עדיין אין לנו אגדות מכאן.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n מוטיבים',
      two: 'שני מוטיבים',
      one: 'מוטיב אחד',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'מ־$n אגדות',
      two: 'משתי אגדות',
      one: 'מאגדה אחת',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs מהחבילה';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n מוטיבים מהחבילה',
      two: 'שני מוטיבים מהחבילה',
      one: 'מוטיב אחד מהחבילה',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return 'מכינים $_temp0 מכאן לחבילת $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return '$_temp0 בחינם';
  }

  @override
  String cardFree(int n) {
    return '$n בחינם';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n בחלקים $region $range',
      one: '$n בחלק $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'יש לך $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'עוד $n בדרך',
      two: 'עוד שתיים בדרך',
      one: 'עוד אחת בדרך',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'ממתין לחנות…';

  @override
  String offerDownloading(int percent) {
    return 'מוריד אגדות… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return 'קנה את $name: $_temp0 ב־$price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return 'הורד את $name: $_temp0 בחינם ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n אגדות',
      two: 'שתי אגדות',
      one: 'אגדה אחת',
    );
    return 'הורד את $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'הורד את $name';
  }

  @override
  String get errDownloadTales => 'לא ניתן היה להוריד את האגדות.';

  @override
  String get errDownloadScenes => 'לא ניתן היה להוריד את התמונות.';

  @override
  String get errNoDownloads => 'הורדה אינה זמינה כאן.';

  @override
  String get errOffline => 'אין חיבור לאינטרנט, נסה שוב כשיהיה קליטה.';

  @override
  String get errCannotBuy => 'אי אפשר לקנות את החלק הזה כרגע.';

  @override
  String get buyPending => 'הרכישה ממתינה לאישור. החלק יורד ברגע שתאושר.';

  @override
  String get buyFailed => 'הרכישה לא הושלמה.';

  @override
  String get restoreNone => 'בחשבון הזה אין רכישות.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n חלקים שוחזרו. אפשר להוריד אותם מהכוכב.',
      two: 'שני חלקים שוחזרו. אפשר להוריד אותם מהכוכב.',
      one: 'חלק אחד שוחזר. אפשר להוריד אותו מהכוכב.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'לא ניתן היה לשחזר את הרכישות, נסה שוב כשיהיה קליטה.';

  @override
  String get narrationGone => 'האגדה הזו כבר לא מורכבת.';

  @override
  String get narrationNew => 'הרכב חדשה';

  @override
  String narrationTitle(int index, int total) {
    return 'אתה מספר — $index מתוך $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'איך להמשיך: $bridge';
  }

  @override
  String get narrationSituation => 'מה קורה עכשיו? (לא חובה, אפשר להכתיב)';

  @override
  String get narrationHintNote => 'רמז, אל תגיד אותו בקול, רק צא ממנו.';

  @override
  String get narrationSoundsNote => 'צלילים, הפעל אותם כשהם מתאימים לסיפור.';

  @override
  String get moodTense => 'מתח';

  @override
  String get moodCalm => 'שלווה';

  @override
  String get narrationSearching => 'מחפש…';

  @override
  String get narrationHint => 'תן רמז';

  @override
  String get narrationMoreHint => 'עוד אחד';

  @override
  String get narrationBack => 'חזרה';

  @override
  String get narrationEnd => 'סוף';

  @override
  String get narrationNext => 'הבא ←';

  @override
  String get narrationGoodnight => 'לילה טוב.';

  @override
  String get narrationEndNote =>
      'עדיין אין לנו תמונת סיום ושמירה בספרייה. האגדה הזו לא הולכת לשום מקום, היא נשארת ביניכם.';

  @override
  String get narrationClose => 'סגור';

  @override
  String get ragFallback => 'בחבילה עוד אין כלום לזה, רמז כללי:';

  @override
  String get ragNoModel => 'מודל הרמזים אינו כלול בגרסה הזו.';

  @override
  String get ragHintGeneral => 'כללי';

  @override
  String get ragHintMotif => 'למוטיב';

  @override
  String get captionExact => 'איור · למוטיב הזה';

  @override
  String get captionSimilar => 'איור · סצנה דומה';

  @override
  String get captionCard => 'קלף מוטיב · עוד אין לנו סצנה לשלב הזה';

  @override
  String get storageTitle => 'אגדות שהורדו';

  @override
  String get storageEmpty => 'עדיין כלום, אגדות נוספות יורדות מהכוכב.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n חבילות',
      two: 'שתי חבילות',
      one: 'חבילה אחת',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'סצנות $name';
  }

  @override
  String get storageFreeTier => 'בחינם';

  @override
  String get storageBoughtTier => 'נרכש';

  @override
  String get storageDelete => 'מחק';

  @override
  String get storageScenesSub => 'תמונה לכל שלב בסיפור';

  @override
  String get storageDownload => 'הורד';

  @override
  String get storageAllUsed => 'הכול היה בשימוש ב־30 הימים האחרונים.';

  @override
  String storageFreed(String size) {
    return '$size פונו.';
  }

  @override
  String get storageFreeUp => 'פנה מקום (לא בשימוש 30 יום)';

  @override
  String get storageRestoring => 'משחזר רכישות…';

  @override
  String get storageRestore => 'שחזר רכישות';

  @override
  String get osnovaTitle => 'מתווה';

  @override
  String get osnovaSummary => 'האגדה בקצרה';

  @override
  String get osnovaCharacters => 'דמויות';

  @override
  String get osnovaTask => 'משימה';

  @override
  String get osnovaProblem => 'בעיה';

  @override
  String get osnovaEnding => 'סוף';

  @override
  String get osnovaAgain => 'מההתחלה';

  @override
  String get osnovaTell => 'אני מספר ←';

  @override
  String get outlineHero => 'הגיבור';

  @override
  String get castFox => 'השועלה החכמה';

  @override
  String get castSmithSon => 'בנו של הנפח';

  @override
  String get castMill => 'הטחנה המדברת';

  @override
  String get castGooseGirl => 'רועת האווזים';

  @override
  String get castBrothers => 'שלושת האחים';

  @override
  String get castClockworkPrincess => 'נסיכת השען';

  @override
  String get castOwl => 'ינשוף חכם';

  @override
  String get castBlacksmith => 'הנפחית הזקנה';

  @override
  String get castDragon => 'דרקון קטן';

  @override
  String get castWaterSprite => 'שד המים';

  @override
  String get castFourPrincesses => 'ארבע הנסיכות';

  @override
  String get castTravelingTailor => 'החייט הנודד';

  @override
  String get castTalkingCat => 'החתול המדבר';

  @override
  String get castForestHermit => 'הנזיר שביער';

  @override
  String get castC0AndersenTheShadow => 'האדון שהיה פעם צל';

  @override
  String get castC1GrimmTheGooseGirl => 'המשרתת הבוגדנית';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'המלך עם הטירה הרדופה';

  @override
  String get castC3AndersenTheShadow => 'הצל החכם';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'הנסיכה היפה אך לא כל כך פיקחית';

  @override
  String get castC5AndersenTheRedShoes => 'המלאך שסולח בסוף';

  @override
  String get castC6GrimmRumpelstiltskin => 'בתו החכמה של הטוחן';

  @override
  String get castC7PerraultLittleRedRidingHood => 'הסבתא שפותחת את הדלת';

  @override
  String get castC8PerraultLittleThumb => 'אם בין עוני לאהבה';

  @override
  String get castC9PerraultIntroduction => 'האישה הסבלנית';

  @override
  String get castC10AndersenTheRealPrincess => 'המלך שתומך בבנו';

  @override
  String get castC11GrimmLilyAndTheLion => 'הבת שעומדת במילתה';

  @override
  String get castC12AndersenTheRealPrincess => 'הנסיך שמחפש את הנסיכה האמיתית';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'ילדת הגפרורים';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'החצרן ששותק';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'המשרת הנאמן מכין סעודה';

  @override
  String get castC16PerraultTheFairy => 'הבת היהירה';

  @override
  String get castC17GrimmFirstStory => 'האלמנה שרוצה תשעה זנבות';

  @override
  String get motifTaskWine => 'מי ישתה מרתף יין';

  @override
  String get motifTaskDiamonds => 'טיסה אחר יהלומים';

  @override
  String get motifTaskRingDuck => 'הטבעת בתוך הברווזה';

  @override
  String get motifTaskGiants => 'להערים על הענקים';

  @override
  String get motifTaskTomThumb => 'בריחתו של אגודל';

  @override
  String get motifTaskSwineherd => 'לזכות בלב הנסיכה';

  @override
  String get motifTaskBell => 'הפעמון המסתורי ביער';

  @override
  String get motifTaskGoldenObject => 'מתנה שאסור לנצל לרעה';

  @override
  String get motifTaskPebbles => 'שביל של חלוקי אבן';

  @override
  String get motifProblemFoxPride => 'גאוות השועל';

  @override
  String get motifProblemLazySister => 'האחות העצלנית';

  @override
  String get motifProblemWitchBoots => 'המכשפה במגפי שבעת הפרסאות';

  @override
  String get motifProblemTailorDoubt => 'אף אחד לא מאמין לו';

  @override
  String get motifProblemLions => 'אריות רעבים בשער';

  @override
  String get motifProblemEagle => 'הנשר והגמד';

  @override
  String get motifProblemTruth => 'החיה הקסומה מגלה את האמת';

  @override
  String get motifProblemOldHouse => 'אף אחד לא רוצה את הבית הישן';

  @override
  String get motifProblemBreadcrumbs => 'הציפורים אכלו את הפירורים';

  @override
  String get motifEndingTrickWins => 'התחכום מנצח';

  @override
  String get motifEndingTruthChild => 'הילד אומר את האמת';

  @override
  String get motifEndingNewHome => 'בית חדש, חברים ותיקים';

  @override
  String get motifEndingHappyTogether => 'מאושרים יחד לתמיד';

  @override
  String get motifEndingKissWakes => 'נשיקה מעוררת את הממלכה';

  @override
  String get motifEndingLeapfrog => 'התחכום קופץ הכי גבוה';

  @override
  String get motifEndingCurseBroken => 'הקללה הוסרה';

  @override
  String get motifEndingWelcomedHome => 'מקבלים אותו בבית בברכה';

  @override
  String get motifEndingSlipper => 'הנעל האבודה';
}
