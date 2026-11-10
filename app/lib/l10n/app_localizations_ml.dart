// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Malayalam (`ml`).
class AppLocalizationsMl extends AppLocalizations {
  AppLocalizationsMl([String locale = 'ml']) : super(locale);

  @override
  String get castTitle => 'കഥയിൽ ആരൊക്കെ ഉണ്ടാകും?';

  @override
  String get castHint =>
      'മറ്റൊരു കഥാപാത്രത്തിനായി കാർഡിൽ തൊടുക. കാർഡ് നീക്കാൻ ക്രോസ് അമർത്തുക. സംഗീതവും ശബ്ദങ്ങളും എപ്പോഴും രാജ്യത്തിന്റെ പാക്കിൽ നിന്ന് തയ്യാറായിരിക്കും, കഥാപാത്രത്തിന്റെ ചിത്രം മാത്രം ചിലപ്പോൾ അൽപ്പം വൈകി വരയ്ക്കപ്പെടും.';

  @override
  String get castAdd => 'കഥാപാത്രം ചേർക്കുക';

  @override
  String get castCount => 'അഭിനേതാക്കൾ:';

  @override
  String get castShuffleAll => 'എല്ലാം കലർത്തുക';

  @override
  String get castContinue => 'തുടരുക →';

  @override
  String get shuffle => 'കലർത്തുക';

  @override
  String get motifTaskTitle => 'ഏത് ദൗത്യം?';

  @override
  String get motifProblemTitle => 'ഏത് പ്രശ്നം?';

  @override
  String get motifEndingTitle => 'ഏത് അവസാനം?';

  @override
  String get motifTaskCaption => 'നായകന്റെ ദൗത്യം തിരഞ്ഞെടുക്കാൻ കാർഡിൽ തൊടുക.';

  @override
  String get motifProblemCaption =>
      'തടസ്സമോ വില്ലനെയോ തിരഞ്ഞെടുക്കാൻ കാർഡിൽ തൊടുക.';

  @override
  String get motifEndingCaption =>
      'സന്തോഷകരമായ അവസാനം തിരഞ്ഞെടുക്കാൻ കാർഡിൽ തൊടുക.';

  @override
  String get beatCastTitle => 'കഥയിൽ ആരൊക്കെ';

  @override
  String get beatTaskTitle => 'നായകൻ എന്ത് തീരുമാനിച്ചു';

  @override
  String get beatProblemTitle => 'വഴിയിൽ എന്ത് തടസ്സമായി';

  @override
  String get beatEndingTitle => 'അവസാനം എന്ത് സംഭവിച്ചു';

  @override
  String get beatCastCaption =>
      'കഥാപാത്രങ്ങളെ പരിചയപ്പെടുത്തുക: അവർ എവിടെയാണ്, എങ്ങനെയിരിക്കും, അവരിൽ പ്രത്യേകത എന്താണ്.';

  @override
  String get beatTaskCaption =>
      'നായകൻ എന്ത് ആഗ്രഹിക്കുന്നു, എന്തിന് പുറപ്പെട്ടു എന്ന് പറയുക.';

  @override
  String get beatProblemCaption =>
      'അവന്റെ വഴിയിൽ എന്തെങ്കിലും വയ്ക്കുക. കുറച്ചുനേരം ഇത് നടക്കില്ല എന്ന് തോന്നട്ടെ.';

  @override
  String get beatEndingCaption =>
      'കഥയെ അവസാനത്തിലേക്ക് എത്തിക്കുക. തിടുക്കം വേണ്ട, കുട്ടി അവസാനമാണ് ഏറ്റവും നന്നായി ഓർക്കുന്നത്.';

  @override
  String get hintHero => 'നായകൻ';

  @override
  String hintCast1(String who) {
    return 'ആദ്യമായി പ്രത്യക്ഷപ്പെടുമ്പോൾ «$who» എങ്ങനെയിരിക്കും?';
  }

  @override
  String hintCast2(String who) {
    return 'കഥ മുഴുവൻ തുടങ്ങുന്നതിന് തൊട്ടുമുമ്പ് «$who» എന്ത് ചെയ്യുകയാണ്?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» എന്തിനെയാണ് പേടിക്കുന്നത്?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» വരുന്നുണ്ടെന്ന് നിങ്ങൾ എങ്ങനെ തിരിച്ചറിയും?';
  }

  @override
  String get hintCast5 =>
      'ഇവരിൽ ആരൊക്കെ വളരെ കാലമായി പരസ്പരം അറിയാം, എവിടെ നിന്ന്?';

  @override
  String get hintCast6 => 'അവർ കണ്ടുമുട്ടുമ്പോൾ കാലാവസ്ഥ എങ്ങനെയാണ്?';

  @override
  String hintCast7(String who) {
    return '«$who» ന്റെ പോക്കറ്റിൽ എന്താണുള്ളത്?';
  }

  @override
  String hintTask1(String who) {
    return 'ഇനി തുടങ്ങണം എന്ന് «$who» എപ്പോഴാണ് മനസ്സിലാക്കുന്നത്?';
  }

  @override
  String hintTask2(String who) {
    return 'ആരാണ് ഉപദേശം നൽകിയത്, «$who» എന്തിന് അത് കേൾക്കുന്നു?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» വീട്ടിൽ എന്ത് ഉപേക്ഷിച്ചു പോകണം?';
  }

  @override
  String get hintTask4 =>
      'വഴി എത്ര നീളമുള്ളതാണ്, അത് എന്തിലൂടെ കടന്നുപോകുന്നു?';

  @override
  String hintTask5(String who) {
    return 'പുറപ്പെടുന്നതിന് മുമ്പ് «$who» സ്വയം എന്ത് വാഗ്ദാനം ചെയ്യുന്നു?';
  }

  @override
  String get hintTask6 => 'മറ്റാർക്കും ഇത് ചെയ്യാൻ കഴിയാത്തത് എന്തുകൊണ്ട്?';

  @override
  String get hintProblem1 => 'ആ നിമിഷം ഒരു ശബ്ദം കേൾക്കുന്നു, എന്ത് ശബ്ദം?';

  @override
  String get hintProblem2 => 'ആദ്യം എന്താണ് തെറ്റുന്നത്?';

  @override
  String hintProblem3(String who) {
    return '«$who» ആദ്യം എന്ത് പരീക്ഷിക്കുന്നു, അത് എന്തുകൊണ്ട് ഫലിക്കുന്നില്ല?';
  }

  @override
  String get hintProblem4 => 'സഹായിക്കാൻ കഴിഞ്ഞിട്ടും ആരാണ് വിസമ്മതിക്കുന്നത്?';

  @override
  String get hintProblem5 =>
      'ഇപ്പോൾ എല്ലാവരും തോൽവി സമ്മതിച്ചാൽ എന്ത് സംഭവിക്കും?';

  @override
  String get hintProblem6 => 'ആ തടസ്സത്തിൽ സങ്കടകരമായ എന്തെങ്കിലും ഉണ്ടോ?';

  @override
  String hintProblem7(String who) {
    return 'ആ നിമിഷം «$who» ഉറക്കെ എന്ത് പറയുന്നു?';
  }

  @override
  String hintEnding1(String who) {
    return 'അവസാനം «$who» അതിനെ എങ്ങനെ തകർക്കുന്നു, ബലം കൊണ്ടോ ബുദ്ധി കൊണ്ടോ?';
  }

  @override
  String get hintEnding2 => 'ആവശ്യമില്ലാഞ്ഞിട്ടും ആരാണ് സഹായിക്കുന്നത്?';

  @override
  String hintEnding3(String who) {
    return 'എല്ലാം കഴിഞ്ഞപ്പോൾ «$who» ആദ്യം എന്ത് ചെയ്യുന്നു?';
  }

  @override
  String get hintEnding4 => 'തുടക്കത്തെക്കാൾ അവസാനത്തിൽ എന്താണ് വ്യത്യസ്തം?';

  @override
  String hintEnding5(String who) {
    return '«$who» എവിടേക്ക് മടങ്ങുന്നു, അവിടെ ആരാണ് കാത്തിരിക്കുന്നത്?';
  }

  @override
  String get hintEnding6 => 'വിളക്ക് തെളിയുന്നതിന് മുമ്പുള്ള അവസാന വാചകം ഏത്?';

  @override
  String get globeLoading => 'ഗ്രഹം ഒരുക്കുകയാണ്…';

  @override
  String get globeLoadFailed => 'ഗ്രഹം ലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get globeTitle => 'കഥ എവിടെ നിന്നായിരിക്കണം?';

  @override
  String get globeStored => 'ഡൗൺലോഡ് ചെയ്ത കഥകൾ';

  @override
  String get globeHintFar =>
      'ഗ്രഹം തിരിക്കുക അല്ലെങ്കിൽ ഒരു രാജ്യത്തിൽ തൊടുക. പച്ച രാജ്യങ്ങൾക്ക് നമ്മുടെ ശേഖരത്തിലെ കഥകളുണ്ട്, ചാരനിറമുള്ളവയ്ക്ക് ഇതുവരെ ഇല്ല.';

  @override
  String get globeHintNear =>
      'ഒരു രാജ്യത്തിലോ കെട്ടിടത്തിലോ തൊടുക. പച്ച രാജ്യങ്ങൾക്ക് നമ്മുടെ ശേഖരത്തിലെ കഥകളുണ്ട്, ചാരനിറമുള്ളവയ്ക്ക് ഇതുവരെ ഇല്ല.';

  @override
  String get globeWhole => 'മുഴുവൻ ഗ്രഹം';

  @override
  String get globeZoomIn => 'അടുത്തേക്ക്';

  @override
  String get globeZoomOut => 'അകലേക്ക്';

  @override
  String globeZoomToRegion(String name) {
    return '$name അടുത്തേക്ക് →';
  }

  @override
  String get globeTellHere => 'ഇവിടത്തെ കഥ പറയുക';

  @override
  String globeTellFrom(String place) {
    return '$place കഥ പറയുക →';
  }

  @override
  String get globeOpenSea => 'തുറന്ന കടൽ';

  @override
  String globeRegionCountries(int n) {
    return '$n രാജ്യങ്ങൾ ഒരുമിച്ച്. അടുത്തേക്ക് ചെന്ന് ഒന്ന് തിരഞ്ഞെടുക്കുക.';
  }

  @override
  String get globeTurnToCountry =>
      'ഗ്രഹം ഏതെങ്കിലും രാജ്യത്തിന് നേരെ തിരിക്കുക.';

  @override
  String get globeSpin => 'തിരിക്കുക';

  @override
  String get globeNoTales => 'ഇവിടത്തെ കഥകളൊന്നും ഇതുവരെ ഞങ്ങളുടെ പക്കലില്ല.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ഘടകങ്ങൾ',
      one: '$n ഘടകം',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകളിൽ നിന്ന്',
      one: '$n കഥയിൽ നിന്ന്',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + പാക്കിൽ നിന്ന് $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'പാക്കിൽ നിന്ന് $n ഘടകങ്ങൾ',
      one: 'പാക്കിൽ നിന്ന് $n ഘടകം',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return 'ഇവിടത്തെ $_temp0 $region പാക്കിനായി ഒരുക്കുകയാണ്.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return '$_temp0 സൗജന്യം';
  }

  @override
  String cardFree(int n) {
    return '$n സൗജന്യം';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range ഭാഗങ്ങളിൽ $n',
      one: '$region $range ഭാഗത്തിൽ $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'നിങ്ങളുടെ പക്കൽ $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ഇനിയും $n വരുന്നു',
      one: 'ഇനിയും $n വരുന്നു',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'സ്റ്റോറിനായി കാത്തിരിക്കുന്നു…';

  @override
  String offerDownloading(int percent) {
    return 'കഥകൾ ഡൗൺലോഡ് ചെയ്യുന്നു… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return '$name വാങ്ങുക: $_temp0, $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return '$name ഡൗൺലോഡ് ചെയ്യുക: $_temp0 സൗജന്യം ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n കഥകൾ',
      one: '$n കഥ',
    );
    return '$name ഡൗൺലോഡ് ചെയ്യുക: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name ഡൗൺലോഡ് ചെയ്യുക';
  }

  @override
  String get errDownloadTales => 'കഥകൾ ഡൗൺലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get errDownloadScenes => 'ചിത്രങ്ങൾ ഡൗൺലോഡ് ചെയ്യാനായില്ല.';

  @override
  String get errNoDownloads => 'ഇവിടെ ഡൗൺലോഡ് ലഭ്യമല്ല.';

  @override
  String get errOffline =>
      'ഇന്റർനെറ്റ് ഇല്ല, സിഗ്നൽ കിട്ടുമ്പോൾ വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get errCannotBuy => 'ഈ ഭാഗം ഇപ്പോൾ വാങ്ങാൻ കഴിയില്ല.';

  @override
  String get buyPending =>
      'വാങ്ങൽ അംഗീകാരത്തിനായി കാത്തിരിക്കുന്നു. അംഗീകരിച്ചാലുടൻ ഭാഗം ഡൗൺലോഡ് ആകും.';

  @override
  String get buyFailed => 'വാങ്ങൽ പൂർത്തിയായില്ല.';

  @override
  String get restoreNone => 'ഈ അക്കൗണ്ടിൽ വാങ്ങലുകളൊന്നുമില്ല.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n ഭാഗങ്ങൾ പുനഃസ്ഥാപിച്ചു. ഗ്രഹത്തിൽ നിന്ന് ഡൗൺലോഡ് ചെയ്യാം.',
      one: '$n ഭാഗം പുനഃസ്ഥാപിച്ചു. ഗ്രഹത്തിൽ നിന്ന് ഡൗൺലോഡ് ചെയ്യാം.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കാനായില്ല, സിഗ്നൽ കിട്ടുമ്പോൾ വീണ്ടും ശ്രമിക്കുക.';

  @override
  String get narrationGone => 'ഈ കഥ ഇപ്പോൾ ഒരുക്കിയിട്ടില്ല.';

  @override
  String get narrationNew => 'പുതിയത് ഒരുക്കുക';

  @override
  String narrationTitle(int index, int total) {
    return 'നിങ്ങൾ പറയുന്നു — $totalൽ $index';
  }

  @override
  String narrationBridge(String bridge) {
    return 'എങ്ങനെ തുടരാം: $bridge';
  }

  @override
  String get narrationSituation =>
      'ഇപ്പോൾ എന്താണ് നടക്കുന്നത്? (ഐച്ഛികം, പറഞ്ഞ് എഴുതിക്കാം)';

  @override
  String get narrationHintNote =>
      'സൂചന, ഇത് ഉറക്കെ പറയരുത്, ഇവിടെ നിന്ന് തുടങ്ങിയാൽ മതി.';

  @override
  String get narrationSoundsNote =>
      'ശബ്ദങ്ങൾ, കഥയ്ക്ക് ചേരുമ്പോൾ പ്ലേ ചെയ്യുക.';

  @override
  String get moodTense => 'ഉദ്വേഗം';

  @override
  String get moodCalm => 'ശാന്തത';

  @override
  String get narrationSearching => 'തിരയുന്നു…';

  @override
  String get narrationHint => 'സൂചന തരൂ';

  @override
  String get narrationMoreHint => 'ഒന്നുകൂടി';

  @override
  String get narrationBack => 'പിന്നോട്ട്';

  @override
  String get narrationEnd => 'അവസാനം';

  @override
  String get narrationNext => 'അടുത്തത് →';

  @override
  String get narrationGoodnight => 'ശുഭരാത്രി.';

  @override
  String get narrationEndNote =>
      'അവസാന ചിത്രവും ലൈബ്രറിയിൽ സൂക്ഷിക്കലും ഞങ്ങൾക്ക് ഇതുവരെ സാധ്യമല്ല. ഈ കഥ എങ്ങും പോകുന്നില്ല, നിങ്ങൾക്കിടയിൽ തന്നെ നിൽക്കുന്നു.';

  @override
  String get narrationClose => 'അടയ്ക്കുക';

  @override
  String get ragFallback => 'ഇതിന് പാക്കിൽ ഇതുവരെ ഒന്നുമില്ല, ഒരു പൊതു സൂചന:';

  @override
  String get ragNoModel => 'സൂചന മോഡൽ ഈ പതിപ്പിൽ ഇല്ല.';

  @override
  String get ragHintGeneral => 'പൊതുവായ';

  @override
  String get ragHintMotif => 'ഘടകത്തിനായി';

  @override
  String get captionExact => 'ചിത്രീകരണം · ഈ ഘടകത്തിനായി';

  @override
  String get captionSimilar => 'ചിത്രീകരണം · സമാനമായ രംഗം';

  @override
  String get captionCard => 'ഘടക കാർഡ് · ഈ ഘട്ടത്തിന് ഇതുവരെ രംഗമില്ല';

  @override
  String get storageTitle => 'ഡൗൺലോഡ് ചെയ്ത കഥകൾ';

  @override
  String get storageEmpty =>
      'ഇതുവരെ ഒന്നുമില്ല, കൂടുതൽ കഥകൾ ഗ്രഹത്തിൽ നിന്ന് ഡൗൺലോഡ് ചെയ്യപ്പെടും.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n പാക്കുകൾ',
      one: '$n പാക്ക്',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name രംഗങ്ങൾ';
  }

  @override
  String get storageFreeTier => 'സൗജന്യം';

  @override
  String get storageBoughtTier => 'വാങ്ങിയത്';

  @override
  String get storageDelete => 'ഇല്ലാതാക്കുക';

  @override
  String get storageScenesSub => 'പറച്ചിലിന്റെ ഓരോ ഘട്ടത്തിനും ഒരു ചിത്രം';

  @override
  String get storageDownload => 'ഡൗൺലോഡ് ചെയ്യുക';

  @override
  String get storageAllUsed => 'കഴിഞ്ഞ 30 ദിവസത്തിനുള്ളിൽ എല്ലാം ഉപയോഗിച്ചു.';

  @override
  String storageFreed(String size) {
    return '$size ഒഴിവാക്കി.';
  }

  @override
  String get storageFreeUp => 'സ്ഥലം ഒഴിവാക്കുക (30 ദിവസം ഉപയോഗിക്കാത്തത്)';

  @override
  String get storageRestoring => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കുന്നു…';

  @override
  String get storageRestore => 'വാങ്ങലുകൾ പുനഃസ്ഥാപിക്കുക';

  @override
  String get osnovaTitle => 'രൂപരേഖ';

  @override
  String get osnovaSummary => 'കഥ ചുരുക്കത്തിൽ';

  @override
  String get osnovaCharacters => 'കഥാപാത്രങ്ങൾ';

  @override
  String get osnovaTask => 'ദൗത്യം';

  @override
  String get osnovaProblem => 'പ്രശ്നം';

  @override
  String get osnovaEnding => 'അവസാനം';

  @override
  String get osnovaAgain => 'വീണ്ടും';

  @override
  String get osnovaTell => 'ഞാൻ പറയാം →';

  @override
  String get outlineHero => 'നായകൻ';

  @override
  String get castFox => 'ബുദ്ധിമാനായ കുറുക്കൻ';

  @override
  String get castSmithSon => 'കൊല്ലന്റെ മകൻ';

  @override
  String get castMill => 'സംസാരിക്കുന്ന മില്ല്';

  @override
  String get castGooseGirl => 'താറാവിനെ മേയ്ക്കുന്ന പെൺകുട്ടി';

  @override
  String get castBrothers => 'മൂന്ന് സഹോദരങ്ങൾ';

  @override
  String get castClockworkPrincess => 'ഘടികാരനിർമ്മാതാവിന്റെ രാജകുമാരി';

  @override
  String get castOwl => 'ബുദ്ധിമാനായ മൂങ്ങ';

  @override
  String get castBlacksmith => 'വൃദ്ധയായ കൊല്ലത്തി';

  @override
  String get castDragon => 'ചെറിയ ഡ്രാഗൺ';

  @override
  String get castWaterSprite => 'ജലഭൂതം';

  @override
  String get castFourPrincesses => 'നാല് രാജകുമാരിമാർ';

  @override
  String get castTravelingTailor => 'അലഞ്ഞുതിരിയുന്ന തയ്യൽക്കാരൻ';

  @override
  String get castTalkingCat => 'സംസാരിക്കുന്ന പൂച്ച';

  @override
  String get castForestHermit => 'കാട്ടിലെ സന്ന്യാസി';

  @override
  String get castC0AndersenTheShadow => 'ഒരിക്കൽ നിഴലായിരുന്ന പ്രഭു';

  @override
  String get castC1GrimmTheGooseGirl => 'ചതിയനായ പരിചാരിക';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'പ്രേതബാധയുള്ള കോട്ടയുള്ള രാജാവ്';

  @override
  String get castC3AndersenTheShadow => 'ബുദ്ധിമാനായ നിഴൽ';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'സുന്ദരിയെങ്കിലും അത്ര ബുദ്ധിയില്ലാത്ത രാജകുമാരി';

  @override
  String get castC5AndersenTheRedShoes => 'ഒടുവിൽ ക്ഷമിക്കുന്ന മാലാഖ';

  @override
  String get castC6GrimmRumpelstiltskin => 'മില്ലുടമയുടെ ബുദ്ധിമതിയായ മകൾ';

  @override
  String get castC7PerraultLittleRedRidingHood => 'വാതിൽ തുറക്കുന്ന മുത്തശ്ശി';

  @override
  String get castC8PerraultLittleThumb =>
      'ദാരിദ്ര്യത്തിനും സ്നേഹത്തിനും ഇടയിലെ അമ്മ';

  @override
  String get castC9PerraultIntroduction => 'ക്ഷമയുള്ള സ്ത്രീ';

  @override
  String get castC10AndersenTheRealPrincess => 'മകനെ പിന്തുണയ്ക്കുന്ന രാജാവ്';

  @override
  String get castC11GrimmLilyAndTheLion => 'വാക്ക് പാലിക്കുന്ന മകൾ';

  @override
  String get castC12AndersenTheRealPrincess =>
      'യഥാർത്ഥ രാജകുമാരിയെ തേടുന്ന രാജകുമാരൻ';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'തീപ്പെട്ടി വിൽക്കുന്ന പെൺകുട്ടി';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'മിണ്ടാതിരിക്കുന്ന സദസ്യൻ';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'വിരുന്നൊരുക്കുന്ന വിശ്വസ്ത സേവകൻ';

  @override
  String get castC16PerraultTheFairy => 'അഹങ്കാരിയായ മകൾ';

  @override
  String get castC17GrimmFirstStory => 'ഒമ്പത് വാലുകൾ ആഗ്രഹിക്കുന്ന വിധവ';

  @override
  String get motifTaskWine => 'ഒരു നിലവറ നിറയെ വീഞ്ഞ് ആര് കുടിക്കും';

  @override
  String get motifTaskDiamonds => 'വജ്രങ്ങൾ തേടിയുള്ള പറക്കൽ';

  @override
  String get motifTaskRingDuck => 'താറാവിനുള്ളിലെ മോതിരം';

  @override
  String get motifTaskGiants => 'ഭീമന്മാരെ കബളിപ്പിക്കൽ';

  @override
  String get motifTaskTomThumb => 'പെരുവിരൻ പയ്യന്റെ രക്ഷപ്പെടൽ';

  @override
  String get motifTaskSwineherd => 'രാജകുമാരിയുടെ ഹൃദയം നേടൽ';

  @override
  String get motifTaskBell => 'കാട്ടിലെ നിഗൂഢമായ മണി';

  @override
  String get motifTaskGoldenObject => 'ദുരുപയോഗം ചെയ്യരുതാത്ത സമ്മാനം';

  @override
  String get motifTaskPebbles => 'ചരൽക്കല്ലുകളുടെ പാത';

  @override
  String get motifProblemFoxPride => 'കുറുക്കന്റെ അഹങ്കാരം';

  @override
  String get motifProblemLazySister => 'മടിയത്തി സഹോദരി';

  @override
  String get motifProblemWitchBoots => 'ഏഴ് ഫർലോങ് ബൂട്ടിട്ട മന്ത്രവാദിനി';

  @override
  String get motifProblemTailorDoubt => 'ആരും അവനെ വിശ്വസിക്കുന്നില്ല';

  @override
  String get motifProblemLions => 'കവാടത്തിൽ വിശന്ന സിംഹങ്ങൾ';

  @override
  String get motifProblemEagle => 'കഴുകനും കുള്ളനും';

  @override
  String get motifProblemTruth => 'മാന്ത്രിക മൃഗം സത്യം വെളിപ്പെടുത്തുന്നു';

  @override
  String get motifProblemOldHouse => 'പഴയ വീട് ആർക്കും വേണ്ട';

  @override
  String get motifProblemBreadcrumbs => 'പക്ഷികൾ നുറുക്കുകൾ തിന്നു';

  @override
  String get motifEndingTrickWins => 'ബുദ്ധി ജയിക്കുന്നു';

  @override
  String get motifEndingTruthChild => 'കുട്ടി സത്യം പറയുന്നു';

  @override
  String get motifEndingNewHome => 'പുതിയ വീട്, പഴയ കൂട്ടുകാർ';

  @override
  String get motifEndingHappyTogether => 'എന്നെന്നും സന്തോഷത്തോടെ ഒരുമിച്ച്';

  @override
  String get motifEndingKissWakes => 'ചുംബനം രാജ്യത്തെ ഉണർത്തുന്നു';

  @override
  String get motifEndingLeapfrog => 'ബുദ്ധി ഏറ്റവും ഉയരത്തിൽ ചാടുന്നു';

  @override
  String get motifEndingCurseBroken => 'ശാപം തകർന്നു';

  @override
  String get motifEndingWelcomedHome => 'വീട്ടിൽ സ്വീകരണം';

  @override
  String get motifEndingSlipper => 'നഷ്ടപ്പെട്ട ചെരിപ്പ്';
}
