// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bengali Bangla (`bn`).
class AppLocalizationsBn extends AppLocalizations {
  AppLocalizationsBn([String locale = 'bn']) : super(locale);

  @override
  String get castTitle => 'গল্পে কে কে থাকবে?';

  @override
  String get castHint =>
      'কার্ডে চাপ দিলে অন্য চরিত্র আসবে। কার্ড মুছতে ক্রস চাপো। সুর ও শব্দ সবসময় দেশের প্যাক থেকে তৈরি থাকে, শুধু চরিত্রের ছবি মাঝে মাঝে একটু পরে আঁকা হয়।';

  @override
  String get castAdd => 'চরিত্র যোগ করো';

  @override
  String get castCount => 'চরিত্র:';

  @override
  String get castShuffleAll => 'সব মেশাও';

  @override
  String get castContinue => 'এগিয়ে চলো →';

  @override
  String get shuffle => 'মেশাও';

  @override
  String get motifTaskTitle => 'কোন কাজ?';

  @override
  String get motifProblemTitle => 'কোন সমস্যা?';

  @override
  String get motifEndingTitle => 'কেমন সমাপ্তি?';

  @override
  String get motifTaskCaption => 'কার্ডে চাপ দিয়ে নায়কের কাজ বেছে নাও।';

  @override
  String get motifProblemCaption =>
      'কার্ডে চাপ দিয়ে একটি বাধা বা খলনায়ক বেছে নাও।';

  @override
  String get motifEndingCaption =>
      'কার্ডে চাপ দিয়ে একটি সুখের সমাপ্তি বেছে নাও।';

  @override
  String get beatCastTitle => 'গল্পে কারা আছে';

  @override
  String get beatTaskTitle => 'নায়ক কী করার সংকল্প করল';

  @override
  String get beatProblemTitle => 'পথে কী বাধা এল';

  @override
  String get beatEndingTitle => 'শেষে কী হল';

  @override
  String get beatCastCaption =>
      'চরিত্রদের পরিচয় দাও: তারা কোথায়, দেখতে কেমন, তাদের বিশেষত্ব কী।';

  @override
  String get beatTaskCaption => 'বলো নায়ক কী চায় এবং কেন সে বেরিয়ে পড়ল।';

  @override
  String get beatProblemCaption =>
      'তার পথে কিছু একটা দাঁড় করাও। কিছুক্ষণ মনে হোক যে কাজটা হবে না।';

  @override
  String get beatEndingCaption =>
      'গল্পটা শেষ পর্যন্ত নিয়ে যাও। তাড়াহুড়ো কোরো না, শিশুরা সমাপ্তিটাই সবচেয়ে বেশি মনে রাখে।';

  @override
  String get hintHero => 'নায়ক';

  @override
  String hintCast1(String who) {
    return 'প্রথমবার দেখা দেওয়ার সময় «$who» দেখতে কেমন?';
  }

  @override
  String hintCast2(String who) {
    return 'গোটা গল্প শুরুর আগে «$who» ঠিক কী করছে?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» কিসে ভয় পায়?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» আসছে, সেটা তুমি কীভাবে বুঝবে?';
  }

  @override
  String get hintCast5 =>
      'এদের মধ্যে কারা অনেক দিন ধরে একে অপরকে চেনে, আর কোথা থেকে?';

  @override
  String get hintCast6 => 'যখন তাদের দেখা হয়, আবহাওয়া কেমন থাকে?';

  @override
  String hintCast7(String who) {
    return '«$who»-এর পকেটে কী আছে?';
  }

  @override
  String hintTask1(String who) {
    return 'কখন «$who» বোঝে যে কাজটা শুরু করতেই হবে?';
  }

  @override
  String hintTask2(String who) {
    return 'কে পরামর্শ দিল, আর «$who» কেন তার কথা শোনে?';
  }

  @override
  String hintTask3(String who) {
    return '«$who»-কে বাড়িতে কী ফেলে যেতে হবে?';
  }

  @override
  String get hintTask4 => 'পথটা কত লম্বা, আর তা কোন কোন জায়গা পেরিয়ে গেছে?';

  @override
  String hintTask5(String who) {
    return 'রওনা হওয়ার আগে «$who» নিজের কাছে কী প্রতিজ্ঞা করে?';
  }

  @override
  String get hintTask6 => 'কেন অন্য কেউ কাজটা করতে পারে না?';

  @override
  String get hintProblem1 => 'ঠিক তখন একটা শব্দ শোনা যায়, কেমন শব্দ?';

  @override
  String get hintProblem2 => 'প্রথমে কী গোলমাল হয়?';

  @override
  String hintProblem3(String who) {
    return '«$who» আগে কী চেষ্টা করে, আর কেন তা কাজ করে না?';
  }

  @override
  String get hintProblem4 => 'সাহায্য করতে পারত, তবু কে সাহায্য করতে চায় না?';

  @override
  String get hintProblem5 => 'এখন সবাই হাল ছেড়ে দিলে কী হত?';

  @override
  String get hintProblem6 => 'এই বাধার মধ্যে কি কোনো দুঃখের ব্যাপার আছে?';

  @override
  String hintProblem7(String who) {
    return 'সেই মুহূর্তে «$who» জোরে কী বলে?';
  }

  @override
  String hintEnding1(String who) {
    return 'শেষ পর্যন্ত «$who» কীভাবে বাধা ভাঙে, গায়ের জোরে নাকি বুদ্ধিতে?';
  }

  @override
  String get hintEnding2 => 'না করলেও চলত, তবু কে সাহায্য করে?';

  @override
  String hintEnding3(String who) {
    return 'সব শেষ হয়ে গেলে «$who» সবার আগে কী করে?';
  }

  @override
  String get hintEnding4 => 'শুরুর চেয়ে শেষে কী আলাদা?';

  @override
  String hintEnding5(String who) {
    return '«$who» কোথায় ফিরে যায়, আর সেখানে কে অপেক্ষা করছে?';
  }

  @override
  String get hintEnding6 => 'আলো জ্বলে ওঠার আগে শেষ বাক্যটা কী?';

  @override
  String get globeLoading => 'গ্রহটা তৈরি করছি…';

  @override
  String get globeLoadFailed => 'গ্রহটা লোড করা গেল না।';

  @override
  String get globeTitle => 'গল্পটা কোথা থেকে আসবে?';

  @override
  String get globeStored => 'নামানো গল্প';

  @override
  String get globeHintFar =>
      'গ্রহটা ঘোরাও বা কোনো দেশে চাপ দাও। সবুজ দেশগুলোর গল্প আমাদের সংগ্রহে আছে, ধূসরগুলোর এখনো নেই।';

  @override
  String get globeHintNear =>
      'কোনো দেশ বা স্থাপনায় চাপ দাও। সবুজ দেশগুলোর গল্প আমাদের সংগ্রহে আছে, ধূসরগুলোর এখনো নেই।';

  @override
  String get globeWhole => 'পুরো গ্রহ';

  @override
  String get globeZoomIn => 'কাছে আনো';

  @override
  String get globeZoomOut => 'দূরে সরাও';

  @override
  String globeZoomToRegion(String name) {
    return '$name কাছে আনো →';
  }

  @override
  String get globeTellHere => 'এখান থেকে গল্প বলো';

  @override
  String globeTellFrom(String place) {
    return '$place থেকে গল্প বলো →';
  }

  @override
  String get globeOpenSea => 'খোলা সমুদ্র';

  @override
  String globeRegionCountries(int n) {
    return 'একসঙ্গে $nটি দেশ। কাছে এনে একটি বেছে নাও।';
  }

  @override
  String get globeTurnToCountry => 'গ্রহটা কোনো একটা দেশের দিকে ঘোরাও।';

  @override
  String get globeSpin => 'ঘোরাও';

  @override
  String get globeNoTales => 'এখান থেকে আমাদের এখনো কোনো গল্প নেই।';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি উপাদান',
      one: '$nটি উপাদান',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প থেকে',
      one: '$nটি গল্প থেকে',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + প্যাক থেকে $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'প্যাক থেকে $nটি উপাদান',
      one: 'প্যাক থেকে $nটি উপাদান',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return 'এখান থেকে $region প্যাকের জন্য $_temp0 তৈরি করছি।';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return '$_temp0 বিনামূল্যে';
  }

  @override
  String cardFree(int n) {
    return '$nটি বিনামূল্যে';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range অংশগুলোতে $nটি',
      one: '$region $range অংশে $nটি',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'তোমার কাছে $nটি';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'আরও $nটি আসছে',
      one: 'আরও $nটি আসছে',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'স্টোরের অপেক্ষায়…';

  @override
  String offerDownloading(int percent) {
    return 'গল্প নামানো হচ্ছে… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return '$name কেনো: $_temp0, দাম $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return '$name নামাও: $_temp0 বিনামূল্যে ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি গল্প',
      one: '$nটি গল্প',
    );
    return '$name নামাও: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name নামাও';
  }

  @override
  String get errDownloadTales => 'গল্পগুলো নামানো গেল না।';

  @override
  String get errDownloadScenes => 'ছবিগুলো নামানো গেল না।';

  @override
  String get errNoDownloads => 'এখানে নামানো সম্ভব নয়।';

  @override
  String get errOffline => 'ইন্টারনেট নেই, সিগন্যাল এলে আবার চেষ্টা করো।';

  @override
  String get errCannotBuy => 'এই অংশটি এখন কেনা যাচ্ছে না।';

  @override
  String get buyPending =>
      'কেনাকাটা অনুমোদনের অপেক্ষায় আছে। অনুমোদন হলে অংশটি নামবে।';

  @override
  String get buyFailed => 'কেনাকাটা হয়নি।';

  @override
  String get restoreNone => 'এই অ্যাকাউন্টে কোনো কেনাকাটা নেই।';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি অংশ ফিরে পাওয়া গেছে। গ্রহ থেকে নামিয়ে নাও।',
      one: '$nটি অংশ ফিরে পাওয়া গেছে। গ্রহ থেকে নামিয়ে নাও।',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'কেনাকাটা ফিরে পাওয়া গেল না, সিগন্যাল এলে আবার চেষ্টা করো।';

  @override
  String get narrationGone => 'এই গল্পটা আর সাজানো নেই।';

  @override
  String get narrationNew => 'নতুন সাজাও';

  @override
  String narrationTitle(int index, int total) {
    return 'তুমি বলছ — $total-এর মধ্যে $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'কীভাবে এগোবে: $bridge';
  }

  @override
  String get narrationSituation => 'এখন কী ঘটছে? (ঐচ্ছিক, বলে লেখানো যায়)';

  @override
  String get narrationHintNote =>
      'ইঙ্গিত, এটা জোরে বোলো না, শুধু এখান থেকে শুরু করো।';

  @override
  String get narrationSoundsNote => 'শব্দ, গল্পে মানালে চালাও।';

  @override
  String get moodTense => 'উত্তেজনা';

  @override
  String get moodCalm => 'শান্ত';

  @override
  String get narrationSearching => 'খুঁজছি…';

  @override
  String get narrationHint => 'ইঙ্গিত দাও';

  @override
  String get narrationMoreHint => 'আরেকটা';

  @override
  String get narrationBack => 'পিছনে';

  @override
  String get narrationEnd => 'শেষ';

  @override
  String get narrationNext => 'পরের →';

  @override
  String get narrationGoodnight => 'শুভরাত্রি।';

  @override
  String get narrationEndNote =>
      'শেষের ছবি আঁকা বা লাইব্রেরিতে রাখা আমরা এখনো পারি না, এই গল্প কোথাও যায় না, শুধু তোমাদের মধ্যেই থাকে।';

  @override
  String get narrationClose => 'বন্ধ করো';

  @override
  String get ragFallback => 'এর জন্য প্যাকে এখনো কিছু নেই, একটি সাধারণ ইঙ্গিত:';

  @override
  String get ragNoModel => 'এই সংস্করণে ইঙ্গিতের মডেল নেই।';

  @override
  String get ragHintGeneral => 'সাধারণ';

  @override
  String get ragHintMotif => 'উপাদানের জন্য';

  @override
  String get captionExact => 'চিত্র · এই উপাদানের জন্য';

  @override
  String get captionSimilar => 'চিত্র · অনুরূপ দৃশ্য';

  @override
  String get captionCard => 'উপাদানের কার্ড · এই ধাপের জন্য এখনো দৃশ্য নেই';

  @override
  String get storageTitle => 'নামানো গল্প';

  @override
  String get storageEmpty => 'এখনো কিছু নেই, আরও গল্প গ্রহ থেকে নামানো হবে।';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nটি প্যাক',
      one: '$nটি প্যাক',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name দৃশ্য';
  }

  @override
  String get storageFreeTier => 'বিনামূল্যে';

  @override
  String get storageBoughtTier => 'কেনা';

  @override
  String get storageDelete => 'মুছো';

  @override
  String get storageScenesSub => 'বলার প্রতিটি ধাপের জন্য একটি ছবি';

  @override
  String get storageDownload => 'নামাও';

  @override
  String get storageAllUsed => 'শেষ ৩০ দিনে সবকিছুই ব্যবহার হয়েছে।';

  @override
  String storageFreed(String size) {
    return '$size খালি হয়েছে।';
  }

  @override
  String get storageFreeUp => 'জায়গা খালি করো (৩০ দিন ব্যবহার হয়নি)';

  @override
  String get storageRestoring => 'কেনাকাটা ফিরিয়ে আনা হচ্ছে…';

  @override
  String get storageRestore => 'কেনাকাটা ফিরিয়ে আনো';

  @override
  String get osnovaTitle => 'রূপরেখা';

  @override
  String get osnovaSummary => 'সংক্ষেপে গল্প';

  @override
  String get osnovaCharacters => 'চরিত্র';

  @override
  String get osnovaTask => 'কাজ';

  @override
  String get osnovaProblem => 'সমস্যা';

  @override
  String get osnovaEnding => 'সমাপ্তি';

  @override
  String get osnovaAgain => 'আবার';

  @override
  String get osnovaTell => 'আমি বলছি →';

  @override
  String get outlineHero => 'নায়ক';

  @override
  String get castFox => 'চতুর শিয়াল';

  @override
  String get castSmithSon => 'কামারের ছেলে';

  @override
  String get castMill => 'কথা-বলা কল';

  @override
  String get castGooseGirl => 'হাঁস-চরানো মেয়ে';

  @override
  String get castBrothers => 'তিন ভাই';

  @override
  String get castClockworkPrincess => 'ঘড়ি-নির্মাতার রাজকন্যা';

  @override
  String get castOwl => 'জ্ঞানী পেঁচা';

  @override
  String get castBlacksmith => 'বুড়ি কামারনি';

  @override
  String get castDragon => 'ছোট্ট ড্রাগন';

  @override
  String get castWaterSprite => 'জলের ভূত';

  @override
  String get castFourPrincesses => 'চার রাজকন্যা';

  @override
  String get castTravelingTailor => 'ভ্রাম্যমাণ দর্জি';

  @override
  String get castTalkingCat => 'কথা-বলা বিড়াল';

  @override
  String get castForestHermit => 'বনের সন্ন্যাসী';

  @override
  String get castC0AndersenTheShadow => 'যে প্রভু একসময় ছায়া ছিল';

  @override
  String get castC1GrimmTheGooseGirl => 'বিশ্বাসঘাতক পরিচারিকা';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'ভূতুড়ে দুর্গের রাজা';

  @override
  String get castC3AndersenTheShadow => 'চতুর ছায়া';

  @override
  String get castC4PerraultRiquetWithTheTuft => 'সুন্দরী কিন্তু অবুঝ রাজকন্যা';

  @override
  String get castC5AndersenTheRedShoes => 'যে দেবদূত শেষে ক্ষমা করে';

  @override
  String get castC6GrimmRumpelstiltskin => 'কলওয়ালার বুদ্ধিমতী মেয়ে';

  @override
  String get castC7PerraultLittleRedRidingHood => 'দরজা খুলে দেওয়া দিদিমা';

  @override
  String get castC8PerraultLittleThumb => 'অভাব আর ভালোবাসার মাঝখানে এক মা';

  @override
  String get castC9PerraultIntroduction => 'ধৈর্যশীলা নারী';

  @override
  String get castC10AndersenTheRealPrincess => 'ছেলের পাশে দাঁড়ানো রাজা';

  @override
  String get castC11GrimmLilyAndTheLion => 'কথা রাখা মেয়ে';

  @override
  String get castC12AndersenTheRealPrincess =>
      'সত্যিকারের রাজকন্যাকে খোঁজা রাজকুমার';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'দেশলাই-বিক্রেতা ছোট্ট মেয়ে';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'চুপ করে থাকা সভাসদ';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'ভোজের আয়োজন করা বিশ্বস্ত ভৃত্য';

  @override
  String get castC16PerraultTheFairy => 'অহংকারী মেয়ে';

  @override
  String get castC17GrimmFirstStory => 'নয়টি লেজ চাওয়া বিধবা';

  @override
  String get motifTaskWine => 'কে এক ভাঁড়ার মদ পান করবে';

  @override
  String get motifTaskDiamonds => 'হীরার খোঁজে উড়ান';

  @override
  String get motifTaskRingDuck => 'হাঁসের পেটে আংটি';

  @override
  String get motifTaskGiants => 'দৈত্যদের বোকা বানানো';

  @override
  String get motifTaskTomThumb => 'বুড়ো আঙুল-এর পালানো';

  @override
  String get motifTaskSwineherd => 'রাজকন্যার মন জয়';

  @override
  String get motifTaskBell => 'বনের রহস্যময় ঘণ্টা';

  @override
  String get motifTaskGoldenObject => 'যে উপহার অপব্যবহার করা চলবে না';

  @override
  String get motifTaskPebbles => 'নুড়ির পথ';

  @override
  String get motifProblemFoxPride => 'শিয়ালের অহংকার';

  @override
  String get motifProblemLazySister => 'অলস বোন';

  @override
  String get motifProblemWitchBoots => 'সাত-ক্রোশী জুতো পরা ডাইনি';

  @override
  String get motifProblemTailorDoubt => 'কেউ তাকে বিশ্বাস করে না';

  @override
  String get motifProblemLions => 'ফটকে ক্ষুধার্ত সিংহ';

  @override
  String get motifProblemEagle => 'ঈগল আর বামন';

  @override
  String get motifProblemTruth => 'জাদুর প্রাণী সত্যি ফাঁস করে';

  @override
  String get motifProblemOldHouse => 'পুরোনো বাড়ি কেউ চায় না';

  @override
  String get motifProblemBreadcrumbs => 'পাখিরা রুটির গুঁড়ো খেয়ে ফেলল';

  @override
  String get motifEndingTrickWins => 'বুদ্ধির জয়';

  @override
  String get motifEndingTruthChild => 'শিশু সত্যি কথা বলে';

  @override
  String get motifEndingNewHome => 'নতুন বাড়ি, পুরোনো বন্ধু';

  @override
  String get motifEndingHappyTogether => 'চিরকাল সুখে একসঙ্গে';

  @override
  String get motifEndingKissWakes => 'এক চুম্বনে জেগে ওঠে রাজ্য';

  @override
  String get motifEndingLeapfrog => 'বুদ্ধি সবচেয়ে উঁচুতে লাফায়';

  @override
  String get motifEndingCurseBroken => 'অভিশাপ ভাঙল';

  @override
  String get motifEndingWelcomedHome => 'বাড়িতে স্বাগত';

  @override
  String get motifEndingSlipper => 'হারানো জুতো';
}
