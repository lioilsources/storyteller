// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Thai (`th`).
class AppLocalizationsTh extends AppLocalizations {
  AppLocalizationsTh([String locale = 'th']) : super(locale);

  @override
  String get castTitle => 'ใครจะอยู่ในนิทานบ้าง?';

  @override
  String get castHint =>
      'แตะการ์ดเพื่อเปลี่ยนตัวละคร ลบการ์ดด้วยเครื่องหมายกากบาท ดนตรีและเสียงพร้อมใช้จากแพ็กของประเทศเสมอ มีเพียงภาพตัวละครที่บางครั้งจะวาดเสร็จช้าไปเล็กน้อย';

  @override
  String get castAdd => 'เพิ่มตัวละคร';

  @override
  String get castCount => 'นักแสดง:';

  @override
  String get castShuffleAll => 'สลับทั้งหมด';

  @override
  String get castContinue => 'ต่อไป →';

  @override
  String get shuffle => 'สลับ';

  @override
  String get motifTaskTitle => 'ภารกิจอะไร';

  @override
  String get motifProblemTitle => 'ปัญหาอะไร';

  @override
  String get motifEndingTitle => 'ตอนจบแบบไหน';

  @override
  String get motifTaskCaption => 'แตะการ์ดเพื่อเลือกภารกิจของวีรบุรุษ';

  @override
  String get motifProblemCaption => 'แตะการ์ดเพื่อเลือกอุปสรรคหรือตัวร้าย';

  @override
  String get motifEndingCaption => 'แตะการ์ดเพื่อเลือกตอนจบที่มีความสุข';

  @override
  String get beatCastTitle => 'ใครอยู่ในเรื่อง';

  @override
  String get beatTaskTitle => 'วีรบุรุษตั้งใจจะทำอะไร';

  @override
  String get beatProblemTitle => 'อะไรมาขวางทาง';

  @override
  String get beatEndingTitle => 'จบลงอย่างไร';

  @override
  String get beatCastCaption =>
      'แนะนำตัวละคร พวกเขาอยู่ที่ไหน หน้าตาเป็นอย่างไร มีอะไรพิเศษ';

  @override
  String get beatTaskCaption =>
      'เล่าว่าวีรบุรุษต้องการอะไรและทำไมถึงออกเดินทาง';

  @override
  String get beatProblemCaption =>
      'วางอะไรบางอย่างขวางทางเขา ให้ดูเหมือนว่าจะไม่สำเร็จอยู่พักหนึ่ง';

  @override
  String get beatEndingCaption =>
      'พาเรื่องไปจนถึงตอนจบ ไม่ต้องรีบ เด็กจะจำตอนจบได้มากที่สุด';

  @override
  String get hintHero => 'วีรบุรุษ';

  @override
  String hintCast1(String who) {
    return 'ตอนปรากฏตัวครั้งแรก «$who» หน้าตาเป็นอย่างไร';
  }

  @override
  String hintCast2(String who) {
    return 'ก่อนเรื่องทั้งหมดจะเริ่ม «$who» กำลังทำอะไรอยู่';
  }

  @override
  String hintCast3(String who) {
    return '«$who» กลัวอะไร';
  }

  @override
  String hintCast4(String who) {
    return 'คุณรู้ได้อย่างไรว่า «$who» กำลังมา';
  }

  @override
  String get hintCast5 => 'ใครบ้างที่รู้จักกันมานานแล้ว และรู้จักกันจากที่ไหน';

  @override
  String get hintCast6 => 'ตอนที่พวกเขาพบกัน อากาศเป็นอย่างไร';

  @override
  String hintCast7(String who) {
    return '«$who» มีอะไรอยู่ในกระเป๋า';
  }

  @override
  String hintTask1(String who) {
    return '«$who» เข้าใจเมื่อไรว่าต้องลงมือทำ';
  }

  @override
  String hintTask2(String who) {
    return 'ใครให้คำแนะนำ และทำไม «$who» จึงเชื่อฟัง';
  }

  @override
  String hintTask3(String who) {
    return '«$who» ต้องทิ้งอะไรไว้ที่บ้าน';
  }

  @override
  String get hintTask4 => 'ทางยาวแค่ไหน และผ่านอะไรบ้าง';

  @override
  String hintTask5(String who) {
    return '«$who» สัญญากับตัวเองว่าอย่างไรก่อนออกเดินทาง';
  }

  @override
  String get hintTask6 => 'ทำไมคนอื่นถึงทำแทนไม่ได้';

  @override
  String get hintProblem1 => 'ในตอนนั้นมีเสียงดังขึ้น เสียงอะไร';

  @override
  String get hintProblem2 => 'อะไรผิดพลาดเป็นอย่างแรก';

  @override
  String hintProblem3(String who) {
    return '«$who» ลองทำอะไรก่อน และทำไมไม่สำเร็จ';
  }

  @override
  String get hintProblem4 => 'ใครปฏิเสธที่จะช่วยทั้งที่ช่วยได้';

  @override
  String get hintProblem5 => 'จะเกิดอะไรขึ้นถ้าตอนนี้ทุกคนยอมแพ้';

  @override
  String get hintProblem6 => 'อุปสรรคนี้มีอะไรที่น่าเศร้าไหม';

  @override
  String hintProblem7(String who) {
    return 'ในตอนนั้น «$who» พูดอะไรออกมาดัง ๆ';
  }

  @override
  String hintEnding1(String who) {
    return 'สุดท้าย «$who» เอาชนะมันด้วยอะไร ด้วยกำลังหรือด้วยความคิด';
  }

  @override
  String get hintEnding2 => 'ใครช่วยทั้งที่ไม่จำเป็นต้องช่วย';

  @override
  String hintEnding3(String who) {
    return 'พอทุกอย่างจบลง «$who» ทำอะไรเป็นอย่างแรก';
  }

  @override
  String get hintEnding4 => 'ตอนจบต่างจากตอนต้นอย่างไร';

  @override
  String hintEnding5(String who) {
    return '«$who» กลับไปที่ไหน และใครรออยู่ที่นั่น';
  }

  @override
  String get hintEnding6 => 'ประโยคสุดท้ายก่อนไฟจะเปิดคืออะไร';

  @override
  String get globeLoading => 'กำลังเตรียมดาวเคราะห์…';

  @override
  String get globeLoadFailed => 'โหลดดาวเคราะห์ไม่สำเร็จ';

  @override
  String get globeTitle => 'นิทานจะมาจากที่ไหน';

  @override
  String get globeStored => 'นิทานที่ดาวน์โหลดแล้ว';

  @override
  String get globeHintFar =>
      'หมุนดาวเคราะห์หรือแตะประเทศ ประเทศสีเขียวมีนิทานจากคลังของเราแล้ว ส่วนประเทศสีเทายังไม่มี';

  @override
  String get globeHintNear =>
      'แตะประเทศหรือสิ่งก่อสร้าง ประเทศสีเขียวมีนิทานจากคลังของเราแล้ว ส่วนประเทศสีเทายังไม่มี';

  @override
  String get globeWhole => 'ทั้งดาวเคราะห์';

  @override
  String get globeZoomIn => 'ซูมเข้า';

  @override
  String get globeZoomOut => 'ซูมออก';

  @override
  String globeZoomToRegion(String name) {
    return 'ซูมเข้า $name →';
  }

  @override
  String get globeTellHere => 'เล่านิทานจากที่นี่';

  @override
  String globeTellFrom(String place) {
    return 'เล่านิทานจาก $place →';
  }

  @override
  String get globeOpenSea => 'ทะเลหลวง';

  @override
  String globeRegionCountries(int n) {
    return '$n ประเทศรวมกัน ซูมเข้าไปแล้วเลือกหนึ่งประเทศ';
  }

  @override
  String get globeTurnToCountry => 'หมุนดาวเคราะห์ไปที่ประเทศใดประเทศหนึ่ง';

  @override
  String get globeSpin => 'หมุน';

  @override
  String get globeNoTales => 'เรายังไม่มีนิทานจากที่นี่';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n องค์ประกอบ',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'จากนิทาน $n เรื่อง',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + จากแพ็ก $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n องค์ประกอบจากแพ็ก',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n เรื่อง',
    );
    return 'เรากำลังเตรียมนิทาน $_temp0 จากที่นี่สำหรับแพ็ก $region';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'นิทาน $n เรื่อง',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'นิทาน $n เรื่อง',
    );
    return '$_temp0 ฟรี';
  }

  @override
  String cardFree(int n) {
    return 'ฟรี $n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n ใน$region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'คุณมี $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'อีก $n กำลังจะมา',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'กำลังรอร้านค้า…';

  @override
  String offerDownloading(int percent) {
    return 'กำลังดาวน์โหลดนิทาน… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'นิทาน $n เรื่อง',
    );
    return 'ซื้อ $name: $_temp0 ราคา $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'นิทาน $n เรื่อง',
    );
    return 'ดาวน์โหลด $name: $_temp0 ฟรี ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'นิทาน $n เรื่อง',
    );
    return 'ดาวน์โหลด $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'ดาวน์โหลด $name';
  }

  @override
  String get errDownloadTales => 'ดาวน์โหลดนิทานไม่สำเร็จ';

  @override
  String get errDownloadScenes => 'ดาวน์โหลดภาพไม่สำเร็จ';

  @override
  String get errNoDownloads => 'ที่นี่ไม่สามารถดาวน์โหลดได้';

  @override
  String get errOffline => 'ไม่มีอินเทอร์เน็ต ลองใหม่เมื่อมีสัญญาณ';

  @override
  String get errCannotBuy => 'ตอนนี้ยังซื้อส่วนนี้ไม่ได้';

  @override
  String get buyPending =>
      'การซื้อรออนุมัติ ส่วนนี้จะดาวน์โหลดเมื่อผ่านการอนุมัติ';

  @override
  String get buyFailed => 'การซื้อไม่สำเร็จ';

  @override
  String get restoreNone => 'บัญชีนี้ไม่มีรายการซื้อ';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'กู้คืน $n ส่วนแล้ว ดาวน์โหลดได้จากดาวเคราะห์',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => 'กู้คืนรายการซื้อไม่สำเร็จ ลองใหม่เมื่อมีสัญญาณ';

  @override
  String get narrationGone => 'นิทานเรื่องนี้ไม่ได้ประกอบไว้แล้ว';

  @override
  String get narrationNew => 'ประกอบเรื่องใหม่';

  @override
  String narrationTitle(int index, int total) {
    return 'คุณกำลังเล่า — $index จาก $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'ต่อเรื่องอย่างไร: $bridge';
  }

  @override
  String get narrationSituation =>
      'ตอนนี้เกิดอะไรขึ้น (ไม่บังคับ พูดแล้วให้พิมพ์ให้ได้)';

  @override
  String get narrationHintNote =>
      'คำใบ้ อย่าอ่านออกเสียง ใช้เป็นจุดเริ่มต้นเท่านั้น';

  @override
  String get narrationSoundsNote => 'เสียง เปิดเมื่อเข้ากับเรื่องที่เล่า';

  @override
  String get moodTense => 'ตึงเครียด';

  @override
  String get moodCalm => 'สงบ';

  @override
  String get narrationSearching => 'กำลังค้นหา…';

  @override
  String get narrationHint => 'ขอคำใบ้';

  @override
  String get narrationMoreHint => 'อีกอัน';

  @override
  String get narrationBack => 'ย้อนกลับ';

  @override
  String get narrationEnd => 'จบ';

  @override
  String get narrationNext => 'ถัดไป →';

  @override
  String get narrationGoodnight => 'ราตรีสวัสดิ์';

  @override
  String get narrationEndNote =>
      'เรายังทำภาพปิดท้ายและบันทึกลงคลังไม่ได้ นิทานเรื่องนี้ไม่ไปไหน อยู่ระหว่างพวกคุณสองคน';

  @override
  String get narrationClose => 'ปิด';

  @override
  String get ragFallback =>
      'ในแพ็กยังไม่มีอะไรสำหรับเรื่องนี้ นี่คือคำใบ้ทั่วไป:';

  @override
  String get ragNoModel => 'เวอร์ชันนี้ไม่มีโมเดลคำใบ้';

  @override
  String get ragHintGeneral => 'ทั่วไป';

  @override
  String get ragHintMotif => 'สำหรับองค์ประกอบ';

  @override
  String get captionExact => 'ภาพประกอบ · สำหรับองค์ประกอบนี้';

  @override
  String get captionSimilar => 'ภาพประกอบ · ฉากที่คล้ายกัน';

  @override
  String get captionCard => 'การ์ดองค์ประกอบ · ยังไม่มีฉากสำหรับขั้นตอนนี้';

  @override
  String get storageTitle => 'นิทานที่ดาวน์โหลดแล้ว';

  @override
  String get storageEmpty => 'ยังไม่มี นิทานเพิ่มเติมจะดาวน์โหลดจากดาวเคราะห์';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n แพ็ก',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'ฉากของ $name';
  }

  @override
  String get storageFreeTier => 'ฟรี';

  @override
  String get storageBoughtTier => 'ซื้อแล้ว';

  @override
  String get storageDelete => 'ลบ';

  @override
  String get storageScenesSub => 'ภาพหนึ่งภาพสำหรับทุกขั้นตอนการเล่า';

  @override
  String get storageDownload => 'ดาวน์โหลด';

  @override
  String get storageAllUsed => 'ทุกอย่างถูกใช้ใน 30 วันที่ผ่านมา';

  @override
  String storageFreed(String size) {
    return 'เพิ่มพื้นที่ว่าง $size';
  }

  @override
  String get storageFreeUp => 'เพิ่มพื้นที่ว่าง (ไม่ได้ใช้ 30 วัน)';

  @override
  String get storageRestoring => 'กำลังกู้คืนรายการซื้อ…';

  @override
  String get storageRestore => 'กู้คืนรายการซื้อ';

  @override
  String get osnovaTitle => 'โครงเรื่อง';

  @override
  String get osnovaSummary => 'นิทานโดยสังเขป';

  @override
  String get osnovaCharacters => 'ตัวละคร';

  @override
  String get osnovaTask => 'ภารกิจ';

  @override
  String get osnovaProblem => 'ปัญหา';

  @override
  String get osnovaEnding => 'ตอนจบ';

  @override
  String get osnovaAgain => 'เริ่มใหม่';

  @override
  String get osnovaTell => 'ฉันจะเล่า →';

  @override
  String get outlineHero => 'วีรบุรุษ';

  @override
  String get castFox => 'จิ้งจอกแสนฉลาด';

  @override
  String get castSmithSon => 'ลูกชายช่างตีเหล็ก';

  @override
  String get castMill => 'โรงสีพูดได้';

  @override
  String get castGooseGirl => 'เด็กสาวเลี้ยงห่าน';

  @override
  String get castBrothers => 'สามพี่น้อง';

  @override
  String get castClockworkPrincess => 'เจ้าหญิงช่างนาฬิกา';

  @override
  String get castOwl => 'นกฮูกผู้ชาญฉลาด';

  @override
  String get castBlacksmith => 'ช่างตีเหล็กหญิงชรา';

  @override
  String get castDragon => 'มังกรน้อย';

  @override
  String get castWaterSprite => 'ผีน้ำ';

  @override
  String get castFourPrincesses => 'เจ้าหญิงทั้งสี่';

  @override
  String get castTravelingTailor => 'ช่างตัดเสื้อเร่ร่อน';

  @override
  String get castTalkingCat => 'แมวพูดได้';

  @override
  String get castForestHermit => 'ฤๅษีแห่งป่า';

  @override
  String get castC0AndersenTheShadow => 'นายท่านที่เคยเป็นเงา';

  @override
  String get castC1GrimmTheGooseGirl => 'สาวใช้จอมทรยศ';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'กษัตริย์ผู้มีปราสาทผีสิง';

  @override
  String get castC3AndersenTheShadow => 'เงาจอมฉลาด';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'เจ้าหญิงที่งดงามแต่ไม่ค่อยฉลาด';

  @override
  String get castC5AndersenTheRedShoes => 'เทวดาที่ให้อภัยในตอนท้าย';

  @override
  String get castC6GrimmRumpelstiltskin => 'ลูกสาวเจ้าของโรงสีผู้ฉลาด';

  @override
  String get castC7PerraultLittleRedRidingHood => 'คุณยายที่เปิดประตู';

  @override
  String get castC8PerraultLittleThumb =>
      'แม่ผู้อยู่ระหว่างความยากจนกับความรัก';

  @override
  String get castC9PerraultIntroduction => 'หญิงผู้อดทน';

  @override
  String get castC10AndersenTheRealPrincess => 'กษัตริย์ที่สนับสนุนลูกชาย';

  @override
  String get castC11GrimmLilyAndTheLion => 'ลูกสาวผู้รักษาคำพูด';

  @override
  String get castC12AndersenTheRealPrincess => 'เจ้าชายผู้ตามหาเจ้าหญิงตัวจริง';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'เด็กหญิงขายไม้ขีดไฟ';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'ข้าราชสำนักผู้เงียบงัน';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'คนรับใช้ผู้ซื่อสัตย์กำลังจัดงานเลี้ยง';

  @override
  String get castC16PerraultTheFairy => 'ลูกสาวจอมหยิ่ง';

  @override
  String get castC17GrimmFirstStory => 'แม่ม่ายที่อยากได้เก้าหาง';

  @override
  String get motifTaskWine => 'ใครจะดื่มไวน์หมดห้องใต้ดิน';

  @override
  String get motifTaskDiamonds => 'บินตามหาเพชร';

  @override
  String get motifTaskRingDuck => 'แหวนในตัวเป็ด';

  @override
  String get motifTaskGiants => 'หลอกยักษ์';

  @override
  String get motifTaskTomThumb => 'การหนีของเด็กชายนิ้วหัวแม่มือ';

  @override
  String get motifTaskSwineherd => 'ชนะใจเจ้าหญิง';

  @override
  String get motifTaskBell => 'ระฆังลึกลับในป่า';

  @override
  String get motifTaskGoldenObject => 'ของขวัญที่ห้ามใช้ในทางที่ผิด';

  @override
  String get motifTaskPebbles => 'ทางเดินก้อนกรวด';

  @override
  String get motifProblemFoxPride => 'ความเย่อหยิ่งของจิ้งจอก';

  @override
  String get motifProblemLazySister => 'พี่สาวขี้เกียจ';

  @override
  String get motifProblemWitchBoots => 'แม่มดสวมรองเท้าบู๊ตเจ็ดลีก';

  @override
  String get motifProblemTailorDoubt => 'ไม่มีใครเชื่อเขา';

  @override
  String get motifProblemLions => 'สิงโตหิวที่ประตู';

  @override
  String get motifProblemEagle => 'นกอินทรีกับคนแคระ';

  @override
  String get motifProblemTruth => 'สัตว์วิเศษเปิดเผยความจริง';

  @override
  String get motifProblemOldHouse => 'ไม่มีใครอยากได้บ้านเก่า';

  @override
  String get motifProblemBreadcrumbs => 'นกกินเศษขนมปังหมด';

  @override
  String get motifEndingTrickWins => 'ปัญญาชนะ';

  @override
  String get motifEndingTruthChild => 'เด็กพูดความจริง';

  @override
  String get motifEndingNewHome => 'บ้านใหม่ เพื่อนเก่า';

  @override
  String get motifEndingHappyTogether => 'อยู่ด้วยกันอย่างมีความสุขตลอดไป';

  @override
  String get motifEndingKissWakes => 'จูบปลุกอาณาจักร';

  @override
  String get motifEndingLeapfrog => 'ปัญญากระโดดสูงที่สุด';

  @override
  String get motifEndingCurseBroken => 'คำสาปถูกทำลาย';

  @override
  String get motifEndingWelcomedHome => 'ได้รับการต้อนรับที่บ้าน';

  @override
  String get motifEndingSlipper => 'รองเท้าที่หายไป';
}
