// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Marathi (`mr`).
class AppLocalizationsMr extends AppLocalizations {
  AppLocalizationsMr([String locale = 'mr']) : super(locale);

  @override
  String get castTitle => 'गोष्टीत कोण कोण असेल?';

  @override
  String get castHint =>
      'दुसरे पात्र मिळवण्यासाठी कार्डला स्पर्श करा. कार्ड काढण्यासाठी क्रॉस दाबा. संगीत आणि आवाज नेहमी देशाच्या पॅकमधून तयार असतात, फक्त पात्राचे चित्र कधीकधी थोड्या वेळाने काढले जाते.';

  @override
  String get castAdd => 'पात्र जोडा';

  @override
  String get castCount => 'पात्रे:';

  @override
  String get castShuffleAll => 'सगळे पिसा';

  @override
  String get castContinue => 'पुढे चला →';

  @override
  String get shuffle => 'पिसा';

  @override
  String get motifTaskTitle => 'कोणती कामगिरी?';

  @override
  String get motifProblemTitle => 'कोणती समस्या?';

  @override
  String get motifEndingTitle => 'कसा शेवट?';

  @override
  String get motifTaskCaption =>
      'नायकाची कामगिरी निवडण्यासाठी कार्डला स्पर्श करा.';

  @override
  String get motifProblemCaption =>
      'अडथळा किंवा खलनायक निवडण्यासाठी कार्डला स्पर्श करा.';

  @override
  String get motifEndingCaption =>
      'आनंदी शेवट निवडण्यासाठी कार्डला स्पर्श करा.';

  @override
  String get beatCastTitle => 'गोष्टीत कोण आहे';

  @override
  String get beatTaskTitle => 'नायकाने काय ठरवले';

  @override
  String get beatProblemTitle => 'वाटेत काय आडवे आले';

  @override
  String get beatEndingTitle => 'शेवटी काय झाले';

  @override
  String get beatCastCaption =>
      'पात्रांची ओळख करून द्या: ते कुठे आहेत, कसे दिसतात, त्यांच्यात काय खास आहे.';

  @override
  String get beatTaskCaption =>
      'नायकाला काय हवे आहे आणि तो का निघाला ते सांगा.';

  @override
  String get beatProblemCaption =>
      'त्याच्या वाटेत काहीतरी ठेवा. थोडा वेळ असे वाटू द्या की हे जमणार नाही.';

  @override
  String get beatEndingCaption =>
      'गोष्ट शेवटपर्यंत न्या. घाई करू नका, मूल शेवट सर्वात जास्त लक्षात ठेवते.';

  @override
  String get hintHero => 'नायक';

  @override
  String hintCast1(String who) {
    return 'पहिल्यांदा समोर येताना «$who» कसा दिसतो?';
  }

  @override
  String hintCast2(String who) {
    return 'संपूर्ण गोष्ट सुरू होण्याआधी «$who» काय करत असतो?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» कशाला घाबरतो?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» येत आहे हे तुम्ही कशावरून ओळखता?';
  }

  @override
  String get hintCast5 =>
      'यांपैकी कोण एकमेकांना खूप दिवसांपासून ओळखतात, आणि कुठून?';

  @override
  String get hintCast6 => 'ते भेटतात तेव्हा हवामान कसे असते?';

  @override
  String hintCast7(String who) {
    return '«$who» च्या खिशात काय आहे?';
  }

  @override
  String hintTask1(String who) {
    return 'कामाला लागलेच पाहिजे हे «$who» ला कधी कळते?';
  }

  @override
  String hintTask2(String who) {
    return 'सल्ला कोणी दिला, आणि «$who» तो का ऐकतो?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» ला घरी काय सोडून जावे लागते?';
  }

  @override
  String get hintTask4 => 'रस्ता किती लांब आहे आणि तो कशातून जातो?';

  @override
  String hintTask5(String who) {
    return 'निघण्यापूर्वी «$who» स्वतःला काय वचन देतो?';
  }

  @override
  String get hintTask6 => 'दुसरे कोणी हे का करू शकत नाही?';

  @override
  String get hintProblem1 => 'त्याच क्षणी एक आवाज ऐकू येतो, कसला?';

  @override
  String get hintProblem2 => 'सर्वात आधी काय बिघडते?';

  @override
  String hintProblem3(String who) {
    return '«$who» आधी काय करून पाहतो, आणि ते का चालत नाही?';
  }

  @override
  String get hintProblem4 => 'मदत करू शकत असूनही कोण नकार देते?';

  @override
  String get hintProblem5 => 'आत्ता सगळ्यांनी हार मानली तर काय होईल?';

  @override
  String get hintProblem6 => 'त्या अडथळ्यात काही दुःखद आहे का?';

  @override
  String hintProblem7(String who) {
    return 'त्या क्षणी «$who» मोठ्याने काय म्हणतो?';
  }

  @override
  String hintEnding1(String who) {
    return 'शेवटी «$who» ते कसे मोडतो, ताकदीने की युक्तीने?';
  }

  @override
  String get hintEnding2 => 'गरज नसतानाही कोण मदत करते?';

  @override
  String hintEnding3(String who) {
    return 'सर्व संपल्यावर «$who» सर्वप्रथम काय करतो?';
  }

  @override
  String get hintEnding4 => 'सुरुवातीपेक्षा शेवटी काय वेगळे आहे?';

  @override
  String hintEnding5(String who) {
    return '«$who» कुठे परततो आणि तिथे कोण वाट पाहत आहे?';
  }

  @override
  String get hintEnding6 => 'दिवा लागण्यापूर्वीचे शेवटचे वाक्य कोणते?';

  @override
  String get globeLoading => 'ग्रह तयार करत आहे…';

  @override
  String get globeLoadFailed => 'ग्रह लोड होऊ शकला नाही.';

  @override
  String get globeTitle => 'गोष्ट कुठली असेल?';

  @override
  String get globeStored => 'डाउनलोड केलेल्या गोष्टी';

  @override
  String get globeHintFar =>
      'ग्रह फिरवा किंवा एखाद्या देशाला स्पर्श करा. हिरव्या देशांच्या गोष्टी आमच्या संग्रहात आहेत, राखाडी देशांच्या अजून नाहीत.';

  @override
  String get globeHintNear =>
      'एखादा देश किंवा इमारतीला स्पर्श करा. हिरव्या देशांच्या गोष्टी आमच्या संग्रहात आहेत, राखाडी देशांच्या अजून नाहीत.';

  @override
  String get globeWhole => 'संपूर्ण ग्रह';

  @override
  String get globeZoomIn => 'जवळ आणा';

  @override
  String get globeZoomOut => 'दूर न्या';

  @override
  String globeZoomToRegion(String name) {
    return '$name जवळ आणा →';
  }

  @override
  String get globeTellHere => 'इथली गोष्ट सांगा';

  @override
  String globeTellFrom(String place) {
    return '$place ची गोष्ट सांगा →';
  }

  @override
  String get globeOpenSea => 'खुला समुद्र';

  @override
  String globeRegionCountries(int n) {
    return '$n देश एकत्र. जवळ आणून एक निवडा.';
  }

  @override
  String get globeTurnToCountry => 'ग्रह एखाद्या देशाकडे फिरवा.';

  @override
  String get globeSpin => 'फिरवा';

  @override
  String get globeNoTales => 'इथली कोणतीही गोष्ट अजून आमच्याकडे नाही.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n घटक',
      one: '$n घटक',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टींतून',
      one: '$n गोष्टीतून',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + पॅकमधून $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'पॅकमधून $n घटक',
      one: 'पॅकमधून $n घटक',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return 'इथल्या $_temp0 $region पॅकसाठी तयार करत आहोत.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return '$_temp0 मोफत';
  }

  @override
  String cardFree(int n) {
    return '$n मोफत';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range भागांत $n',
      one: '$region $range भागात $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'तुमच्याकडे $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'आणखी $n येत आहेत',
      one: 'आणखी $n येत आहे',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'स्टोअरची वाट पाहत आहे…';

  @override
  String offerDownloading(int percent) {
    return 'गोष्टी डाउनलोड होत आहेत… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return '$name खरेदी करा: $_temp0, $price मध्ये';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return '$name डाउनलोड करा: $_temp0 मोफत ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n गोष्टी',
      one: '$n गोष्ट',
    );
    return '$name डाउनलोड करा: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name डाउनलोड करा';
  }

  @override
  String get errDownloadTales => 'गोष्टी डाउनलोड होऊ शकल्या नाहीत.';

  @override
  String get errDownloadScenes => 'चित्रे डाउनलोड होऊ शकली नाहीत.';

  @override
  String get errNoDownloads => 'इथे डाउनलोड उपलब्ध नाही.';

  @override
  String get errOffline => 'इंटरनेट नाही, सिग्नल आल्यावर पुन्हा प्रयत्न करा.';

  @override
  String get errCannotBuy => 'हा भाग आत्ता खरेदी करता येत नाही.';

  @override
  String get buyPending =>
      'खरेदी मंजुरीची वाट पाहत आहे. मंजूर होताच भाग डाउनलोड होईल.';

  @override
  String get buyFailed => 'खरेदी झाली नाही.';

  @override
  String get restoreNone => 'या खात्यावर कोणतीही खरेदी नाही.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n भाग परत मिळाले. तुम्ही ते ग्रहावरून डाउनलोड करू शकता.',
      one: '$n भाग परत मिळाला. तुम्ही तो ग्रहावरून डाउनलोड करू शकता.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'खरेदी परत मिळवता आली नाही, सिग्नल आल्यावर पुन्हा प्रयत्न करा.';

  @override
  String get narrationGone => 'ही गोष्ट आता जुळवलेली नाही.';

  @override
  String get narrationNew => 'नवी जुळवा';

  @override
  String narrationTitle(int index, int total) {
    return 'तुम्ही सांगत आहात — $total पैकी $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'कसे जोडावे: $bridge';
  }

  @override
  String get narrationSituation =>
      'आत्ता काय चालले आहे? (ऐच्छिक, बोलून लिहिता येते)';

  @override
  String get narrationHintNote =>
      'सूचना, ती मोठ्याने वाचू नका, फक्त तिथून सुरुवात करा.';

  @override
  String get narrationSoundsNote => 'आवाज, गोष्टीला शोभतील तेव्हा वाजवा.';

  @override
  String get moodTense => 'तणाव';

  @override
  String get moodCalm => 'शांतता';

  @override
  String get narrationSearching => 'शोधत आहे…';

  @override
  String get narrationHint => 'सूचना द्या';

  @override
  String get narrationMoreHint => 'आणखी एक';

  @override
  String get narrationBack => 'मागे';

  @override
  String get narrationEnd => 'समाप्त';

  @override
  String get narrationNext => 'पुढे →';

  @override
  String get narrationGoodnight => 'शुभ रात्री.';

  @override
  String get narrationEndNote =>
      'शेवटचे चित्र आणि लायब्ररीत साठवणे आम्हाला अजून जमत नाही. ही गोष्ट कुठेही जात नाही, तुमच्यातच राहते.';

  @override
  String get narrationClose => 'बंद करा';

  @override
  String get ragFallback => 'यासाठी पॅकमध्ये अजून काही नाही, एक सामान्य सूचना:';

  @override
  String get ragNoModel => 'सूचना मॉडेल या आवृत्तीत नाही.';

  @override
  String get ragHintGeneral => 'सामान्य';

  @override
  String get ragHintMotif => 'घटकासाठी';

  @override
  String get captionExact => 'चित्र · या घटकासाठी';

  @override
  String get captionSimilar => 'चित्र · तसाच प्रसंग';

  @override
  String get captionCard => 'घटक कार्ड · या टप्प्यासाठी अजून प्रसंग नाही';

  @override
  String get storageTitle => 'डाउनलोड केलेल्या गोष्टी';

  @override
  String get storageEmpty =>
      'अजून काही नाही, आणखी गोष्टी ग्रहावरून डाउनलोड होतील.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n पॅक',
      one: '$n पॅक',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name प्रसंग';
  }

  @override
  String get storageFreeTier => 'मोफत';

  @override
  String get storageBoughtTier => 'खरेदी केलेले';

  @override
  String get storageDelete => 'हटवा';

  @override
  String get storageScenesSub => 'सांगण्याच्या प्रत्येक टप्प्यासाठी एक चित्र';

  @override
  String get storageDownload => 'डाउनलोड करा';

  @override
  String get storageAllUsed => 'गेल्या 30 दिवसांत सर्व काही वापरले गेले.';

  @override
  String storageFreed(String size) {
    return '$size मोकळे झाले.';
  }

  @override
  String get storageFreeUp => 'जागा मोकळी करा (30 दिवस न वापरलेले)';

  @override
  String get storageRestoring => 'खरेदी परत मिळवत आहे…';

  @override
  String get storageRestore => 'खरेदी परत मिळवा';

  @override
  String get osnovaTitle => 'रूपरेषा';

  @override
  String get osnovaSummary => 'गोष्ट थोडक्यात';

  @override
  String get osnovaCharacters => 'पात्रे';

  @override
  String get osnovaTask => 'कामगिरी';

  @override
  String get osnovaProblem => 'समस्या';

  @override
  String get osnovaEnding => 'शेवट';

  @override
  String get osnovaAgain => 'पुन्हा';

  @override
  String get osnovaTell => 'मी सांगतो →';

  @override
  String get outlineHero => 'नायक';

  @override
  String get castFox => 'चतुर कोल्हा';

  @override
  String get castSmithSon => 'लोहाराचा मुलगा';

  @override
  String get castMill => 'बोलणारी गिरणी';

  @override
  String get castGooseGirl => 'हंस चारणारी मुलगी';

  @override
  String get castBrothers => 'तीन भाऊ';

  @override
  String get castClockworkPrincess => 'घड्याळजीची राजकन्या';

  @override
  String get castOwl => 'शहाणे घुबड';

  @override
  String get castBlacksmith => 'म्हातारी लोहारीण';

  @override
  String get castDragon => 'छोटा ड्रॅगन';

  @override
  String get castWaterSprite => 'पाण्याचा भूत';

  @override
  String get castFourPrincesses => 'चार राजकन्या';

  @override
  String get castTravelingTailor => 'फिरता शिंपी';

  @override
  String get castTalkingCat => 'बोलणारे मांजर';

  @override
  String get castForestHermit => 'जंगलातील संन्यासी';

  @override
  String get castC0AndersenTheShadow => 'एकेकाळी सावली असलेले धनी';

  @override
  String get castC1GrimmTheGooseGirl => 'दगाबाज दासी';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'झपाटलेल्या किल्ल्याचा राजा';

  @override
  String get castC3AndersenTheShadow => 'हुशार सावली';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'सुंदर पण फारशी हुशार नसलेली राजकन्या';

  @override
  String get castC5AndersenTheRedShoes => 'शेवटी क्षमा करणारा देवदूत';

  @override
  String get castC6GrimmRumpelstiltskin => 'गिरणीवाल्याची हुशार मुलगी';

  @override
  String get castC7PerraultLittleRedRidingHood => 'दार उघडणारी आजी';

  @override
  String get castC8PerraultLittleThumb => 'गरिबी आणि प्रेम यांच्यातील आई';

  @override
  String get castC9PerraultIntroduction => 'संयमी स्त्री';

  @override
  String get castC10AndersenTheRealPrincess => 'मुलाला साथ देणारा राजा';

  @override
  String get castC11GrimmLilyAndTheLion => 'दिलेला शब्द पाळणारी मुलगी';

  @override
  String get castC12AndersenTheRealPrincess =>
      'खऱ्या राजकन्येचा शोध घेणारा राजकुमार';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'काडेपेटी विकणारी छोटी मुलगी';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'गप्प बसणारा दरबारी';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'मेजवानी तयार करणारा निष्ठावान सेवक';

  @override
  String get castC16PerraultTheFairy => 'गर्विष्ठ मुलगी';

  @override
  String get castC17GrimmFirstStory => 'नऊ शेपट्या हव्या असणारी विधवा';

  @override
  String get motifTaskWine => 'तळघरभर वाइन कोण पिणार';

  @override
  String get motifTaskDiamonds => 'हिऱ्यांसाठी उड्डाण';

  @override
  String get motifTaskRingDuck => 'बदकातली अंगठी';

  @override
  String get motifTaskGiants => 'राक्षसांना चकवणे';

  @override
  String get motifTaskTomThumb => 'अंगठ्याएवढ्या मुलाचे पलायन';

  @override
  String get motifTaskSwineherd => 'राजकन्येचे मन जिंकणे';

  @override
  String get motifTaskBell => 'जंगलातील रहस्यमय घंटा';

  @override
  String get motifTaskGoldenObject => 'गैरवापर करू नये अशी भेट';

  @override
  String get motifTaskPebbles => 'खड्यांची पायवाट';

  @override
  String get motifProblemFoxPride => 'कोल्ह्याचा अहंकार';

  @override
  String get motifProblemLazySister => 'आळशी बहीण';

  @override
  String get motifProblemWitchBoots => 'सात योजनांच्या बुटांतील चेटकीण';

  @override
  String get motifProblemTailorDoubt => 'कोणीही त्याच्यावर विश्वास ठेवत नाही';

  @override
  String get motifProblemLions => 'दारात भुकेले सिंह';

  @override
  String get motifProblemEagle => 'गरुड आणि बटू';

  @override
  String get motifProblemTruth => 'जादूचा प्राणी सत्य सांगतो';

  @override
  String get motifProblemOldHouse => 'जुने घर कोणालाच नको';

  @override
  String get motifProblemBreadcrumbs => 'पक्ष्यांनी तुकडे खाऊन टाकले';

  @override
  String get motifEndingTrickWins => 'चतुराई जिंकते';

  @override
  String get motifEndingTruthChild => 'मूल खरे सांगते';

  @override
  String get motifEndingNewHome => 'नवे घर, जुने मित्र';

  @override
  String get motifEndingHappyTogether => 'कायम आनंदाने एकत्र';

  @override
  String get motifEndingKissWakes => 'चुंबनाने राज्य जागे होते';

  @override
  String get motifEndingLeapfrog => 'चतुराई सर्वात उंच उडी मारते';

  @override
  String get motifEndingCurseBroken => 'शाप तुटला';

  @override
  String get motifEndingWelcomedHome => 'घरी स्वागत';

  @override
  String get motifEndingSlipper => 'हरवलेली चप्पल';
}
