// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get castTitle => 'कहानी में कौन-कौन होगा?';

  @override
  String get castHint =>
      'दूसरा पात्र पाने के लिए कार्ड को छुएँ। कार्ड हटाने के लिए क्रॉस दबाएँ। संगीत और आवाज़ें हमेशा देश के पैक से तैयार मिलती हैं, बस पात्र की तस्वीर कभी-कभी थोड़ी देर बाद बनती है।';

  @override
  String get castAdd => 'पात्र जोड़ें';

  @override
  String get castCount => 'पात्र:';

  @override
  String get castShuffleAll => 'सबको फेंटें';

  @override
  String get castContinue => 'आगे बढ़ें →';

  @override
  String get shuffle => 'फेंटें';

  @override
  String get motifTaskTitle => 'कौन-सा काम?';

  @override
  String get motifProblemTitle => 'कौन-सी समस्या?';

  @override
  String get motifEndingTitle => 'कैसा अंत?';

  @override
  String get motifTaskCaption => 'नायक का काम चुनने के लिए कार्ड को छुएँ।';

  @override
  String get motifProblemCaption =>
      'कोई बाधा या खलनायक चुनने के लिए कार्ड को छुएँ।';

  @override
  String get motifEndingCaption => 'सुखद अंत चुनने के लिए कार्ड को छुएँ।';

  @override
  String get beatCastTitle => 'कहानी में कौन है';

  @override
  String get beatTaskTitle => 'नायक ने क्या ठाना';

  @override
  String get beatProblemTitle => 'रास्ते में क्या आड़े आया';

  @override
  String get beatEndingTitle => 'अंत कैसे हुआ';

  @override
  String get beatCastCaption =>
      'पात्रों का परिचय दें: वे कहाँ हैं, कैसे दिखते हैं, उनमें क्या खास है।';

  @override
  String get beatTaskCaption =>
      'बताएँ कि नायक क्या चाहता है और वह क्यों निकल पड़ा।';

  @override
  String get beatProblemCaption =>
      'उसके रास्ते में कुछ खड़ा कर दें। कुछ देर लगने दें कि यह नहीं हो पाएगा।';

  @override
  String get beatEndingCaption =>
      'कहानी को अंत तक पहुँचाएँ। जल्दबाज़ी न करें, बच्चा अंत को सबसे ज़्यादा याद रखता है।';

  @override
  String get hintHero => 'नायक';

  @override
  String hintCast1(String who) {
    return 'पहली बार सामने आने पर «$who» कैसा दिखता है?';
  }

  @override
  String hintCast2(String who) {
    return 'पूरी कहानी शुरू होने से ठीक पहले «$who» क्या कर रहा है?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» किससे डरता है?';
  }

  @override
  String hintCast4(String who) {
    return 'तुम कैसे पहचानते हो कि «$who» आ रहा है?';
  }

  @override
  String get hintCast5 =>
      'इनमें से कौन एक-दूसरे को बहुत समय से जानते हैं, और कहाँ से?';

  @override
  String get hintCast6 => 'जब वे मिलते हैं तो मौसम कैसा होता है?';

  @override
  String hintCast7(String who) {
    return '«$who» की जेब में क्या है?';
  }

  @override
  String hintTask1(String who) {
    return '«$who» कब समझता है कि अब काम में जुटना ही होगा?';
  }

  @override
  String hintTask2(String who) {
    return 'सलाह किसने दी, और «$who» उसकी बात क्यों मानता है?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» को घर पर क्या छोड़ना पड़ेगा?';
  }

  @override
  String get hintTask4 => 'रास्ता कितना लंबा है और किन जगहों से गुज़रता है?';

  @override
  String hintTask5(String who) {
    return 'निकलने से पहले «$who» खुद से क्या वादा करता है?';
  }

  @override
  String get hintTask6 => 'यह काम कोई और क्यों नहीं कर सकता?';

  @override
  String get hintProblem1 => 'उसी पल एक आवाज़ आती है, कैसी?';

  @override
  String get hintProblem2 => 'सबसे पहले क्या बिगड़ता है?';

  @override
  String hintProblem3(String who) {
    return '«$who» पहले क्या आज़माता है, और वह क्यों नहीं चलता?';
  }

  @override
  String get hintProblem4 => 'मदद कर सकने पर भी कौन मना कर देता है?';

  @override
  String get hintProblem5 => 'अगर अभी सब हार मान लें तो क्या होगा?';

  @override
  String get hintProblem6 => 'क्या इस बाधा में कुछ उदास करने वाली बात है?';

  @override
  String hintProblem7(String who) {
    return 'उस पल «$who» ज़ोर से क्या कहता है?';
  }

  @override
  String hintEnding1(String who) {
    return 'आखिर में «$who» उसे कैसे तोड़ता है, ताकत से या तरकीब से?';
  }

  @override
  String get hintEnding2 => 'ज़रूरी न होने पर भी कौन मदद करता है?';

  @override
  String hintEnding3(String who) {
    return 'सब खत्म होने पर «$who» सबसे पहले क्या करता है?';
  }

  @override
  String get hintEnding4 => 'अंत में शुरुआत से क्या अलग है?';

  @override
  String hintEnding5(String who) {
    return '«$who» कहाँ लौटता है और वहाँ कौन इंतज़ार करता है?';
  }

  @override
  String get hintEnding6 => 'बत्ती जलने से पहले आखिरी वाक्य क्या है?';

  @override
  String get globeLoading => 'ग्रह तैयार कर रहा हूँ…';

  @override
  String get globeLoadFailed => 'ग्रह लोड नहीं हो सका।';

  @override
  String get globeTitle => 'कहानी कहाँ की होगी?';

  @override
  String get globeStored => 'डाउनलोड की हुई कहानियाँ';

  @override
  String get globeHintFar =>
      'ग्रह को घुमाएँ या किसी देश को छुएँ। हरे देशों की कहानियाँ हमारे संग्रह में हैं, भूरे देशों की अभी नहीं।';

  @override
  String get globeHintNear =>
      'किसी देश या इमारत को छुएँ। हरे देशों की कहानियाँ हमारे संग्रह में हैं, भूरे देशों की अभी नहीं।';

  @override
  String get globeWhole => 'पूरा ग्रह';

  @override
  String get globeZoomIn => 'पास लाएँ';

  @override
  String get globeZoomOut => 'दूर करें';

  @override
  String globeZoomToRegion(String name) {
    return '$name पास लाएँ →';
  }

  @override
  String get globeTellHere => 'यहाँ की कहानी सुनाएँ';

  @override
  String globeTellFrom(String place) {
    return '$place की कहानी सुनाएँ →';
  }

  @override
  String get globeOpenSea => 'खुला समुद्र';

  @override
  String globeRegionCountries(int n) {
    return '$n देश साथ-साथ। पास लाकर एक चुनें।';
  }

  @override
  String get globeTurnToCountry => 'ग्रह को किसी देश की ओर घुमाएँ।';

  @override
  String get globeSpin => 'घुमाएँ';

  @override
  String get globeNoTales => 'यहाँ की कोई कहानी अभी हमारे पास नहीं है।';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n तत्व',
      one: '$n तत्व',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियों से',
      one: '$n कहानी से',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + पैक से $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'पैक से $n तत्व',
      one: 'पैक से $n तत्व',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return 'यहाँ की $_temp0 $region पैक के लिए तैयार कर रहे हैं।';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return '$_temp0 मुफ़्त';
  }

  @override
  String cardFree(int n) {
    return '$n मुफ़्त';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range भागों में $n',
      one: '$region $range भाग में $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'आपके पास $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n और आ रही हैं',
      one: '$n और आ रही है',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'स्टोर का इंतज़ार…';

  @override
  String offerDownloading(int percent) {
    return 'कहानियाँ डाउनलोड हो रही हैं… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return '$name खरीदें: $_temp0, $price में';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return '$name डाउनलोड करें: $_temp0 मुफ़्त ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n कहानियाँ',
      one: '$n कहानी',
    );
    return '$name डाउनलोड करें: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name डाउनलोड करें';
  }

  @override
  String get errDownloadTales => 'कहानियाँ डाउनलोड नहीं हो सकीं।';

  @override
  String get errDownloadScenes => 'चित्र डाउनलोड नहीं हो सके।';

  @override
  String get errNoDownloads => 'यहाँ डाउनलोड उपलब्ध नहीं है।';

  @override
  String get errOffline => 'इंटरनेट नहीं है, सिग्नल आने पर फिर कोशिश करें।';

  @override
  String get errCannotBuy => 'यह भाग अभी खरीदा नहीं जा सकता।';

  @override
  String get buyPending =>
      'खरीदारी मंज़ूरी का इंतज़ार कर रही है। मंज़ूर होते ही भाग डाउनलोड होगा।';

  @override
  String get buyFailed => 'खरीदारी पूरी नहीं हुई।';

  @override
  String get restoreNone => 'इस खाते में कोई खरीदारी नहीं है।';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n भाग वापस मिले। आप उन्हें ग्रह से डाउनलोड कर सकते हैं।',
      one: '$n भाग वापस मिला। आप उसे ग्रह से डाउनलोड कर सकते हैं।',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'खरीदारियाँ वापस नहीं मिल सकीं, सिग्नल आने पर फिर कोशिश करें।';

  @override
  String get narrationGone => 'यह कहानी अब जुड़ी हुई नहीं है।';

  @override
  String get narrationNew => 'नई बनाएँ';

  @override
  String narrationTitle(int index, int total) {
    return 'आप सुना रहे हैं — $total में से $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'कैसे जोड़ें: $bridge';
  }

  @override
  String get narrationSituation =>
      'अभी क्या हो रहा है? (वैकल्पिक, बोलकर लिखवा सकते हैं)';

  @override
  String get narrationHintNote =>
      'संकेत, इसे ज़ोर से न बोलें, बस यहाँ से आगे बढ़ें।';

  @override
  String get narrationSoundsNote => 'आवाज़ें, कहानी में जब जमें तब बजाएँ।';

  @override
  String get moodTense => 'तनाव';

  @override
  String get moodCalm => 'शांति';

  @override
  String get narrationSearching => 'खोज रहा हूँ…';

  @override
  String get narrationHint => 'संकेत दीजिए';

  @override
  String get narrationMoreHint => 'एक और';

  @override
  String get narrationBack => 'पीछे';

  @override
  String get narrationEnd => 'समाप्त';

  @override
  String get narrationNext => 'आगे →';

  @override
  String get narrationGoodnight => 'शुभ रात्रि।';

  @override
  String get narrationEndNote =>
      'अंतिम चित्र बनाना और लाइब्रेरी में सहेजना हम अभी नहीं कर सकते। यह कहानी कहीं नहीं जाती, आपके बीच ही रहती है।';

  @override
  String get narrationClose => 'बंद करें';

  @override
  String get ragFallback =>
      'इसके लिए पैक में अभी कुछ नहीं है, एक सामान्य संकेत:';

  @override
  String get ragNoModel => 'संकेत मॉडल इस संस्करण में नहीं है।';

  @override
  String get ragHintGeneral => 'सामान्य';

  @override
  String get ragHintMotif => 'तत्व के लिए';

  @override
  String get captionExact => 'चित्र · इस तत्व के लिए';

  @override
  String get captionSimilar => 'चित्र · मिलता-जुलता दृश्य';

  @override
  String get captionCard => 'तत्व कार्ड · इस चरण के लिए अभी दृश्य नहीं है';

  @override
  String get storageTitle => 'डाउनलोड की हुई कहानियाँ';

  @override
  String get storageEmpty => 'अभी कुछ नहीं, और कहानियाँ ग्रह से डाउनलोड होंगी।';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n पैक',
      one: '$n पैक',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name के दृश्य';
  }

  @override
  String get storageFreeTier => 'मुफ़्त';

  @override
  String get storageBoughtTier => 'खरीदा हुआ';

  @override
  String get storageDelete => 'हटाएँ';

  @override
  String get storageScenesSub => 'सुनाने के हर चरण के लिए एक चित्र';

  @override
  String get storageDownload => 'डाउनलोड करें';

  @override
  String get storageAllUsed => 'पिछले 30 दिनों में सब कुछ इस्तेमाल हुआ है।';

  @override
  String storageFreed(String size) {
    return '$size खाली हुआ।';
  }

  @override
  String get storageFreeUp => 'जगह खाली करें (30 दिन से अनुपयोगी)';

  @override
  String get storageRestoring => 'खरीदारियाँ वापस लाई जा रही हैं…';

  @override
  String get storageRestore => 'खरीदारियाँ वापस लाएँ';

  @override
  String get osnovaTitle => 'रूपरेखा';

  @override
  String get osnovaSummary => 'संक्षेप में कहानी';

  @override
  String get osnovaCharacters => 'पात्र';

  @override
  String get osnovaTask => 'काम';

  @override
  String get osnovaProblem => 'समस्या';

  @override
  String get osnovaEnding => 'अंत';

  @override
  String get osnovaAgain => 'फिर से';

  @override
  String get osnovaTell => 'मैं सुनाता हूँ →';

  @override
  String get outlineHero => 'नायक';

  @override
  String get castFox => 'चालाक लोमड़ी';

  @override
  String get castSmithSon => 'लोहार का बेटा';

  @override
  String get castMill => 'बोलने वाली चक्की';

  @override
  String get castGooseGirl => 'हंस चराने वाली लड़की';

  @override
  String get castBrothers => 'तीन भाई';

  @override
  String get castClockworkPrincess => 'घड़ीसाज़ राजकुमारी';

  @override
  String get castOwl => 'समझदार उल्लू';

  @override
  String get castBlacksmith => 'बूढ़ी लोहारिन';

  @override
  String get castDragon => 'नन्हा ड्रैगन';

  @override
  String get castWaterSprite => 'पानी का भूत';

  @override
  String get castFourPrincesses => 'चार राजकुमारियाँ';

  @override
  String get castTravelingTailor => 'घुमक्कड़ दर्ज़ी';

  @override
  String get castTalkingCat => 'बोलने वाला बिल्ला';

  @override
  String get castForestHermit => 'जंगल का साधु';

  @override
  String get castC0AndersenTheShadow => 'वह स्वामी जो कभी परछाईं था';

  @override
  String get castC1GrimmTheGooseGirl => 'धोखेबाज़ दासी';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'भुतहा किले वाला राजा';

  @override
  String get castC3AndersenTheShadow => 'चालाक परछाईं';

  @override
  String get castC4PerraultRiquetWithTheTuft => 'सुंदर पर कम समझदार राजकुमारी';

  @override
  String get castC5AndersenTheRedShoes => 'अंत में माफ़ करने वाला फ़रिश्ता';

  @override
  String get castC6GrimmRumpelstiltskin => 'चक्कीवाले की समझदार बेटी';

  @override
  String get castC7PerraultLittleRedRidingHood => 'दरवाज़ा खोलने वाली दादी';

  @override
  String get castC8PerraultLittleThumb => 'गरीबी और प्यार के बीच एक माँ';

  @override
  String get castC9PerraultIntroduction => 'धैर्यवान स्त्री';

  @override
  String get castC10AndersenTheRealPrincess => 'बेटे का साथ देने वाला राजा';

  @override
  String get castC11GrimmLilyAndTheLion => 'वचन निभाने वाली बेटी';

  @override
  String get castC12AndersenTheRealPrincess =>
      'सच्ची राजकुमारी को खोजता राजकुमार';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'माचिस वाली नन्ही लड़की';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'चुप रहने वाला दरबारी';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'दावत तैयार करता वफ़ादार सेवक';

  @override
  String get castC16PerraultTheFairy => 'घमंडी बेटी';

  @override
  String get castC17GrimmFirstStory => 'नौ पूँछें चाहने वाली विधवा';

  @override
  String get motifTaskWine => 'कौन पूरा तहखाना भर शराब पिएगा';

  @override
  String get motifTaskDiamonds => 'हीरों की खोज में उड़ान';

  @override
  String get motifTaskRingDuck => 'बत्तख के अंदर अँगूठी';

  @override
  String get motifTaskGiants => 'दैत्यों को चकमा देना';

  @override
  String get motifTaskTomThumb => 'अँगूठा-भर लड़के का भाग निकलना';

  @override
  String get motifTaskSwineherd => 'राजकुमारी का दिल जीतना';

  @override
  String get motifTaskBell => 'जंगल की रहस्यमय घंटी';

  @override
  String get motifTaskGoldenObject =>
      'ऐसा उपहार जिसका दुरुपयोग नहीं होना चाहिए';

  @override
  String get motifTaskPebbles => 'कंकड़ों की पगडंडी';

  @override
  String get motifProblemFoxPride => 'लोमड़ी का घमंड';

  @override
  String get motifProblemLazySister => 'आलसी बहन';

  @override
  String get motifProblemWitchBoots => 'सात कोस वाले जूतों में चुड़ैल';

  @override
  String get motifProblemTailorDoubt => 'कोई उसका यकीन नहीं करता';

  @override
  String get motifProblemLions => 'फाटक पर भूखे शेर';

  @override
  String get motifProblemEagle => 'बाज़ और बौना';

  @override
  String get motifProblemTruth => 'जादुई जानवर सच बता देता है';

  @override
  String get motifProblemOldHouse => 'पुराना घर कोई नहीं चाहता';

  @override
  String get motifProblemBreadcrumbs => 'चिड़ियों ने टुकड़े खा लिए';

  @override
  String get motifEndingTrickWins => 'चतुराई की जीत';

  @override
  String get motifEndingTruthChild => 'बच्चा सच बोलता है';

  @override
  String get motifEndingNewHome => 'नया घर, पुराने दोस्त';

  @override
  String get motifEndingHappyTogether => 'हमेशा के लिए खुशी से साथ';

  @override
  String get motifEndingKissWakes => 'एक चुंबन से राज्य जाग उठता है';

  @override
  String get motifEndingLeapfrog => 'चतुराई सबसे ऊँचा कूदती है';

  @override
  String get motifEndingCurseBroken => 'श्राप टूट गया';

  @override
  String get motifEndingWelcomedHome => 'घर पर स्वागत';

  @override
  String get motifEndingSlipper => 'खोई हुई जूती';
}
