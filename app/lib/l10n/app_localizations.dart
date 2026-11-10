import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_ca.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fi.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hr.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_kn.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ml.dart';
import 'app_localizations_mr.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_or.dart';
import 'app_localizations_pa.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sl.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_ta.dart';
import 'app_localizations_te.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_ur.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('bn'),
    Locale('ca'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fi'),
    Locale('fr'),
    Locale('gu'),
    Locale('he'),
    Locale('hi'),
    Locale('hr'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('kn'),
    Locale('ko'),
    Locale('ml'),
    Locale('mr'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('or'),
    Locale('pa'),
    Locale('pl'),
    Locale('pt'),
    Locale('pt', 'BR'),
    Locale('pt', 'PT'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sl'),
    Locale('sv'),
    Locale('ta'),
    Locale('te'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('ur'),
    Locale('vi'),
    Locale('zh'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
    Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
  ];

  /// Title of the cast screen
  ///
  /// In cs, this message translates to:
  /// **'Kdo bude v pohádce?'**
  String get castTitle;

  /// No description provided for @castHint.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na kartu = jiná postava. Kartu smaž křížkem. Hudba a zvuky jsou vždy hotové z packu země — jen obrázek postavy se občas chvilku dokresluje.'**
  String get castHint;

  /// No description provided for @castAdd.
  ///
  /// In cs, this message translates to:
  /// **'Přidat postavu'**
  String get castAdd;

  /// Label before "2/6"; a space is added after it in code
  ///
  /// In cs, this message translates to:
  /// **'Obsazení:'**
  String get castCount;

  /// No description provided for @castShuffleAll.
  ///
  /// In cs, this message translates to:
  /// **'Zamíchat vše'**
  String get castShuffleAll;

  /// No description provided for @castContinue.
  ///
  /// In cs, this message translates to:
  /// **'Pokračovat →'**
  String get castContinue;

  /// No description provided for @shuffle.
  ///
  /// In cs, this message translates to:
  /// **'Zamíchat'**
  String get shuffle;

  /// No description provided for @motifTaskTitle.
  ///
  /// In cs, this message translates to:
  /// **'Jaký úkol?'**
  String get motifTaskTitle;

  /// No description provided for @motifProblemTitle.
  ///
  /// In cs, this message translates to:
  /// **'Jaký problém?'**
  String get motifProblemTitle;

  /// No description provided for @motifEndingTitle.
  ///
  /// In cs, this message translates to:
  /// **'Jaký konec?'**
  String get motifEndingTitle;

  /// No description provided for @motifTaskCaption.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na kartu = vyber úkol pro hrdinu.'**
  String get motifTaskCaption;

  /// No description provided for @motifProblemCaption.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na kartu = vyber překážku nebo záporáka.'**
  String get motifProblemCaption;

  /// No description provided for @motifEndingCaption.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na kartu = vyber šťastný konec.'**
  String get motifEndingCaption;

  /// No description provided for @beatCastTitle.
  ///
  /// In cs, this message translates to:
  /// **'Kdo v tom bude'**
  String get beatCastTitle;

  /// No description provided for @beatTaskTitle.
  ///
  /// In cs, this message translates to:
  /// **'Co si hrdina předsevzal'**
  String get beatTaskTitle;

  /// No description provided for @beatProblemTitle.
  ///
  /// In cs, this message translates to:
  /// **'Co se postavilo do cesty'**
  String get beatProblemTitle;

  /// No description provided for @beatEndingTitle.
  ///
  /// In cs, this message translates to:
  /// **'Jak to dopadlo'**
  String get beatEndingTitle;

  /// No description provided for @beatCastCaption.
  ///
  /// In cs, this message translates to:
  /// **'Představ postavy. Kde jsou, jak vypadají, co je na nich zvláštního.'**
  String get beatCastCaption;

  /// No description provided for @beatTaskCaption.
  ///
  /// In cs, this message translates to:
  /// **'Řekni, co hrdina chce a proč se pro to vydal.'**
  String get beatTaskCaption;

  /// No description provided for @beatProblemCaption.
  ///
  /// In cs, this message translates to:
  /// **'Postav mu něco do cesty. Ať to chvíli vypadá, že to nepůjde.'**
  String get beatProblemCaption;

  /// No description provided for @beatEndingCaption.
  ///
  /// In cs, this message translates to:
  /// **'Doveď to do konce. Nespěchej — konec si dítě pamatuje nejvíc.'**
  String get beatEndingCaption;

  /// Stands in for the character name in a prompt when no one is cast
  ///
  /// In cs, this message translates to:
  /// **'hrdina'**
  String get hintHero;

  /// Open prompt for the parent. {who} is a character label and is NOT declined: it must stand as the subject (nominative) or in a neutral position; avoid pronouns that assume gender.
  ///
  /// In cs, this message translates to:
  /// **'Jak {who} vypadá, když se poprvé objeví?'**
  String hintCast1(String who);

  /// No description provided for @hintCast2.
  ///
  /// In cs, this message translates to:
  /// **'Co {who} zrovna dělá, než celý příběh začne?'**
  String hintCast2(String who);

  /// No description provided for @hintCast3.
  ///
  /// In cs, this message translates to:
  /// **'Čeho se {who} bojí?'**
  String hintCast3(String who);

  /// No description provided for @hintCast4.
  ///
  /// In cs, this message translates to:
  /// **'Podle čeho poznáš, že přichází {who}?'**
  String hintCast4(String who);

  /// No description provided for @hintCast5.
  ///
  /// In cs, this message translates to:
  /// **'Kdo z nich se zná už dlouho a odkud?'**
  String get hintCast5;

  /// No description provided for @hintCast6.
  ///
  /// In cs, this message translates to:
  /// **'Jaké je počasí, když se potkají?'**
  String get hintCast6;

  /// No description provided for @hintCast7.
  ///
  /// In cs, this message translates to:
  /// **'Co má {who} v kapse?'**
  String hintCast7(String who);

  /// Open prompt for the parent. {who} is a character label and is NOT declined: it must stand as the subject (nominative) or in a neutral position; avoid pronouns that assume gender.
  ///
  /// In cs, this message translates to:
  /// **'Kdy {who} pochopí, že se do toho musí pustit?'**
  String hintTask1(String who);

  /// No description provided for @hintTask2.
  ///
  /// In cs, this message translates to:
  /// **'Kdo to poradil a proč {who} poslechne?'**
  String hintTask2(String who);

  /// No description provided for @hintTask3.
  ///
  /// In cs, this message translates to:
  /// **'Co musí {who} nechat doma?'**
  String hintTask3(String who);

  /// No description provided for @hintTask4.
  ///
  /// In cs, this message translates to:
  /// **'Jak dlouhá je ta cesta a přes co vede?'**
  String get hintTask4;

  /// No description provided for @hintTask5.
  ///
  /// In cs, this message translates to:
  /// **'Co si {who} slíbí, než vyrazí?'**
  String hintTask5(String who);

  /// No description provided for @hintTask6.
  ///
  /// In cs, this message translates to:
  /// **'Proč to nemůže udělat někdo jiný?'**
  String get hintTask6;

  /// Open prompt for the parent. {who} is a character label and is NOT declined: it must stand as the subject (nominative) or in a neutral position; avoid pronouns that assume gender.
  ///
  /// In cs, this message translates to:
  /// **'V tu chvíli se ozve zvuk — jaký?'**
  String get hintProblem1;

  /// No description provided for @hintProblem2.
  ///
  /// In cs, this message translates to:
  /// **'Co se pokazí jako první?'**
  String get hintProblem2;

  /// No description provided for @hintProblem3.
  ///
  /// In cs, this message translates to:
  /// **'Co {who} zkusí nejdřív a proč to nevyjde?'**
  String hintProblem3(String who);

  /// No description provided for @hintProblem4.
  ///
  /// In cs, this message translates to:
  /// **'Kdo odmítne pomoct, i když by mohl?'**
  String get hintProblem4;

  /// No description provided for @hintProblem5.
  ///
  /// In cs, this message translates to:
  /// **'Co by se stalo, kdyby to teď všichni vzdali?'**
  String get hintProblem5;

  /// No description provided for @hintProblem6.
  ///
  /// In cs, this message translates to:
  /// **'Je na té překážce něco smutného?'**
  String get hintProblem6;

  /// No description provided for @hintProblem7.
  ///
  /// In cs, this message translates to:
  /// **'Co {who} v tu chvíli řekne nahlas?'**
  String hintProblem7(String who);

  /// Open prompt for the parent. {who} is a character label and is NOT declined: it must stand as the subject (nominative) or in a neutral position; avoid pronouns that assume gender.
  ///
  /// In cs, this message translates to:
  /// **'Čím to {who} nakonec zlomí — silou, nebo nápadem?'**
  String hintEnding1(String who);

  /// No description provided for @hintEnding2.
  ///
  /// In cs, this message translates to:
  /// **'Kdo pomůže, i když by nemusel?'**
  String get hintEnding2;

  /// No description provided for @hintEnding3.
  ///
  /// In cs, this message translates to:
  /// **'Co {who} udělá jako úplně první, když je po všem?'**
  String hintEnding3(String who);

  /// No description provided for @hintEnding4.
  ///
  /// In cs, this message translates to:
  /// **'Co je na konci jinak než na začátku?'**
  String get hintEnding4;

  /// No description provided for @hintEnding5.
  ///
  /// In cs, this message translates to:
  /// **'Kam se {who} vrátí a kdo tam čeká?'**
  String hintEnding5(String who);

  /// No description provided for @hintEnding6.
  ///
  /// In cs, this message translates to:
  /// **'Jaká je poslední věta, než se rozsvítí?'**
  String get hintEnding6;

  /// No description provided for @globeLoading.
  ///
  /// In cs, this message translates to:
  /// **'Chystám planetu…'**
  String get globeLoading;

  /// No description provided for @globeLoadFailed.
  ///
  /// In cs, this message translates to:
  /// **'Planetu se nepodařilo načíst.'**
  String get globeLoadFailed;

  /// No description provided for @globeTitle.
  ///
  /// In cs, this message translates to:
  /// **'Odkud bude pohádka?'**
  String get globeTitle;

  /// No description provided for @globeStored.
  ///
  /// In cs, this message translates to:
  /// **'Stažené pohádky'**
  String get globeStored;

  /// No description provided for @globeHintFar.
  ///
  /// In cs, this message translates to:
  /// **'Roztoč planetu nebo ťukni na zemi. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.'**
  String get globeHintFar;

  /// No description provided for @globeHintNear.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na zemi nebo na stavbu. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.'**
  String get globeHintNear;

  /// No description provided for @globeWhole.
  ///
  /// In cs, this message translates to:
  /// **'Celá planeta'**
  String get globeWhole;

  /// No description provided for @globeZoomIn.
  ///
  /// In cs, this message translates to:
  /// **'Přiblížit'**
  String get globeZoomIn;

  /// No description provided for @globeZoomOut.
  ///
  /// In cs, this message translates to:
  /// **'Oddálit'**
  String get globeZoomOut;

  /// No description provided for @globeZoomToRegion.
  ///
  /// In cs, this message translates to:
  /// **'Přiblížit {name} →'**
  String globeZoomToRegion(String name);

  /// No description provided for @globeTellHere.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávět odsud'**
  String get globeTellHere;

  /// {place} is already the phrase "from X" in Czech (z Česka); in other languages it is just the country name
  ///
  /// In cs, this message translates to:
  /// **'Vyprávět {place} →'**
  String globeTellFrom(String place);

  /// No description provided for @globeOpenSea.
  ///
  /// In cs, this message translates to:
  /// **'Širé moře'**
  String get globeOpenSea;

  /// No description provided for @globeRegionCountries.
  ///
  /// In cs, this message translates to:
  /// **'{n} zemí pohromadě. Přibliž se a vyber si jednu.'**
  String globeRegionCountries(int n);

  /// No description provided for @globeTurnToCountry.
  ///
  /// In cs, this message translates to:
  /// **'Otoč planetu na nějakou zemi.'**
  String get globeTurnToCountry;

  /// No description provided for @globeSpin.
  ///
  /// In cs, this message translates to:
  /// **'Roztočit'**
  String get globeSpin;

  /// No description provided for @globeNoTales.
  ///
  /// In cs, this message translates to:
  /// **'Odsud zatím žádné pohádky nemáme.'**
  String get globeNoTales;

  /// No description provided for @motifCount.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{{n} motiv} few{{n} motivy} other{{n} motivů}}'**
  String motifCount(int n);

  /// No description provided for @fromTaleCount.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{z {n} pohádky} few{z {n} pohádek} other{z {n} pohádek}}'**
  String fromTaleCount(int n);

  /// {motifs} is e.g. "3 motivy", {tales} is e.g. "z 2 pohádek" (includes the preposition)
  ///
  /// In cs, this message translates to:
  /// **'{motifs} {tales}'**
  String motifsFromTales(String motifs, String tales);

  /// No description provided for @motifsPlusPack.
  ///
  /// In cs, this message translates to:
  /// **'{base} + {packMotifs} z balíčku'**
  String motifsPlusPack(String base, int packMotifs);

  /// No description provided for @motifsFromPack.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{{n} motiv z balíčku} few{{n} motivy z balíčku} other{{n} motivů z balíčku}}'**
  String motifsFromPack(int n);

  /// No description provided for @talesComing.
  ///
  /// In cs, this message translates to:
  /// **'Chystáme odsud {n, plural, one{{n} pohádku} few{{n} pohádky} other{{n} pohádek}} do balíčku {region}.'**
  String talesComing(int n, String region);

  /// No description provided for @talesCount.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{{n} pohádka} few{{n} pohádky} other{{n} pohádek}}'**
  String talesCount(int n);

  /// No description provided for @talesCountFree.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{{n} pohádka} few{{n} pohádky} other{{n} pohádek}} zdarma'**
  String talesCountFree(int n);

  /// No description provided for @cardFree.
  ///
  /// In cs, this message translates to:
  /// **'{n} zdarma'**
  String cardFree(int n);

  /// {parts}: how many parts they are spread over (1 = singular); {range} e.g. "1–3"
  ///
  /// In cs, this message translates to:
  /// **'{parts, plural, one{{n} v dílu {region} {range}} other{{n} v dílech {region} {range}}}'**
  String cardInParts(int parts, int n, String region, String range);

  /// No description provided for @cardHave.
  ///
  /// In cs, this message translates to:
  /// **'máš {n}'**
  String cardHave(int n);

  /// No description provided for @cardMoreComing.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{další {n} chystáme} other{dalších {n} chystáme}}'**
  String cardMoreComing(int n);

  /// No description provided for @offerWaiting.
  ///
  /// In cs, this message translates to:
  /// **'Čekám na obchod…'**
  String get offerWaiting;

  /// No description provided for @offerDownloading.
  ///
  /// In cs, this message translates to:
  /// **'Stahuji pohádky… {percent} %'**
  String offerDownloading(int percent);

  /// No description provided for @offerBuy.
  ///
  /// In cs, this message translates to:
  /// **'Koupit {name}: {n, plural, one{{n} pohádku} few{{n} pohádky} other{{n} pohádek}} za {price}'**
  String offerBuy(String name, int n, String price);

  /// No description provided for @offerDownloadFree.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}: {n, plural, one{{n} pohádku} few{{n} pohádky} other{{n} pohádek}} zdarma ({size})'**
  String offerDownloadFree(String name, int n, String size);

  /// No description provided for @offerDownloadPart.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}: {n, plural, one{{n} pohádku} few{{n} pohádky} other{{n} pohádek}} ({size})'**
  String offerDownloadPart(String name, int n, String size);

  /// No description provided for @offerDownloadTip.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}'**
  String offerDownloadTip(String name);

  /// No description provided for @errDownloadTales.
  ///
  /// In cs, this message translates to:
  /// **'Pohádky se nepodařilo stáhnout.'**
  String get errDownloadTales;

  /// No description provided for @errDownloadScenes.
  ///
  /// In cs, this message translates to:
  /// **'Obrázky se nepodařilo stáhnout.'**
  String get errDownloadScenes;

  /// No description provided for @errNoDownloads.
  ///
  /// In cs, this message translates to:
  /// **'Stahování tu není k dispozici.'**
  String get errNoDownloads;

  /// No description provided for @errOffline.
  ///
  /// In cs, this message translates to:
  /// **'Nejsme na internetu — zkus to, až bude signál.'**
  String get errOffline;

  /// No description provided for @errCannotBuy.
  ///
  /// In cs, this message translates to:
  /// **'Tenhle díl teď koupit nejde.'**
  String get errCannotBuy;

  /// No description provided for @buyPending.
  ///
  /// In cs, this message translates to:
  /// **'Nákup čeká na schválení. Díl se stáhne, až projde.'**
  String get buyPending;

  /// No description provided for @buyFailed.
  ///
  /// In cs, this message translates to:
  /// **'Nákup se nepovedl.'**
  String get buyFailed;

  /// No description provided for @restoreNone.
  ///
  /// In cs, this message translates to:
  /// **'Na tomhle účtu nejsou žádné nákupy.'**
  String get restoreNone;

  /// No description provided for @restoreSome.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{Obnoven {n} díl. Stáhneš ho z planety.} few{Obnoveno {n} díly. Stáhneš je z planety.} other{Obnoveno {n} dílů. Stáhneš je z planety.}}'**
  String restoreSome(int n);

  /// No description provided for @restoreFailed.
  ///
  /// In cs, this message translates to:
  /// **'Nákupy se nepodařilo obnovit — zkus to, až bude signál.'**
  String get restoreFailed;

  /// No description provided for @narrationGone.
  ///
  /// In cs, this message translates to:
  /// **'Tahle pohádka už není složená.'**
  String get narrationGone;

  /// No description provided for @narrationNew.
  ///
  /// In cs, this message translates to:
  /// **'Složit novou'**
  String get narrationNew;

  /// No description provided for @narrationTitle.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávíš — {index} ze {total}'**
  String narrationTitle(int index, int total);

  /// No description provided for @narrationBridge.
  ///
  /// In cs, this message translates to:
  /// **'Jak navázat: {bridge}'**
  String narrationBridge(String bridge);

  /// No description provided for @narrationSituation.
  ///
  /// In cs, this message translates to:
  /// **'Co se zrovna děje? (nepovinné, jde nadiktovat)'**
  String get narrationSituation;

  /// No description provided for @narrationHintNote.
  ///
  /// In cs, this message translates to:
  /// **'Nápověda — neříkej ji nahlas, jen se od ní odraz.'**
  String get narrationHintNote;

  /// No description provided for @narrationSoundsNote.
  ///
  /// In cs, this message translates to:
  /// **'Zvuky — pusť, až se to do vyprávění hodí.'**
  String get narrationSoundsNote;

  /// No description provided for @moodTense.
  ///
  /// In cs, this message translates to:
  /// **'napětí'**
  String get moodTense;

  /// No description provided for @moodCalm.
  ///
  /// In cs, this message translates to:
  /// **'klid'**
  String get moodCalm;

  /// No description provided for @narrationSearching.
  ///
  /// In cs, this message translates to:
  /// **'Hledám…'**
  String get narrationSearching;

  /// No description provided for @narrationHint.
  ///
  /// In cs, this message translates to:
  /// **'Napověz'**
  String get narrationHint;

  /// No description provided for @narrationMoreHint.
  ///
  /// In cs, this message translates to:
  /// **'Ještě jednu'**
  String get narrationMoreHint;

  /// No description provided for @narrationBack.
  ///
  /// In cs, this message translates to:
  /// **'Zpět'**
  String get narrationBack;

  /// No description provided for @narrationEnd.
  ///
  /// In cs, this message translates to:
  /// **'Konec'**
  String get narrationEnd;

  /// No description provided for @narrationNext.
  ///
  /// In cs, this message translates to:
  /// **'Dál →'**
  String get narrationNext;

  /// No description provided for @narrationGoodnight.
  ///
  /// In cs, this message translates to:
  /// **'Dobrou noc.'**
  String get narrationGoodnight;

  /// No description provided for @narrationEndNote.
  ///
  /// In cs, this message translates to:
  /// **'Závěrečný obrázek a ukládání do Knihovny zatím neumíme — tahle pohádka nikam neodchází, zůstala mezi vámi.'**
  String get narrationEndNote;

  /// No description provided for @narrationClose.
  ///
  /// In cs, this message translates to:
  /// **'Zavřít'**
  String get narrationClose;

  /// No description provided for @ragFallback.
  ///
  /// In cs, this message translates to:
  /// **'Z balíčku k tomuhle zatím nic — obecná nápověda:'**
  String get ragFallback;

  /// No description provided for @ragNoModel.
  ///
  /// In cs, this message translates to:
  /// **'Model pro nápovědy není v téhle sestavě.'**
  String get ragNoModel;

  /// Debug label only
  ///
  /// In cs, this message translates to:
  /// **'obecná'**
  String get ragHintGeneral;

  /// Debug label only
  ///
  /// In cs, this message translates to:
  /// **'k motivu'**
  String get ragHintMotif;

  /// No description provided for @captionExact.
  ///
  /// In cs, this message translates to:
  /// **'ilustrace · k tomuhle motivu'**
  String get captionExact;

  /// No description provided for @captionSimilar.
  ///
  /// In cs, this message translates to:
  /// **'ilustrace · podobná scéna'**
  String get captionSimilar;

  /// No description provided for @captionCard.
  ///
  /// In cs, this message translates to:
  /// **'karta motivu · scénu k tomuhle kroku zatím nemáme'**
  String get captionCard;

  /// No description provided for @storageTitle.
  ///
  /// In cs, this message translates to:
  /// **'Stažené pohádky'**
  String get storageTitle;

  /// No description provided for @storageEmpty.
  ///
  /// In cs, this message translates to:
  /// **'Zatím nic — další pohádky se stáhnou z planety.'**
  String get storageEmpty;

  /// No description provided for @storageSummary.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, one{{n} balíček} few{{n} balíčky} other{{n} balíčků}}, {size}'**
  String storageSummary(int n, String size);

  /// No description provided for @storageScenes.
  ///
  /// In cs, this message translates to:
  /// **'Scény {name}'**
  String storageScenes(String name);

  /// No description provided for @storageFreeTier.
  ///
  /// In cs, this message translates to:
  /// **'zdarma'**
  String get storageFreeTier;

  /// No description provided for @storageBoughtTier.
  ///
  /// In cs, this message translates to:
  /// **'zakoupeno'**
  String get storageBoughtTier;

  /// No description provided for @storageDelete.
  ///
  /// In cs, this message translates to:
  /// **'Smazat'**
  String get storageDelete;

  /// No description provided for @storageScenesSub.
  ///
  /// In cs, this message translates to:
  /// **'Obrázek ke každému kroku vyprávění'**
  String get storageScenesSub;

  /// No description provided for @storageDownload.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout'**
  String get storageDownload;

  /// No description provided for @storageAllUsed.
  ///
  /// In cs, this message translates to:
  /// **'Všechno se používalo v posledních 30 dnech.'**
  String get storageAllUsed;

  /// No description provided for @storageFreed.
  ///
  /// In cs, this message translates to:
  /// **'Uvolněno {size}.'**
  String storageFreed(String size);

  /// No description provided for @storageFreeUp.
  ///
  /// In cs, this message translates to:
  /// **'Uvolnit místo (nepoužité 30 dní)'**
  String get storageFreeUp;

  /// No description provided for @storageRestoring.
  ///
  /// In cs, this message translates to:
  /// **'Obnovuji nákupy…'**
  String get storageRestoring;

  /// No description provided for @storageRestore.
  ///
  /// In cs, this message translates to:
  /// **'Obnovit nákupy'**
  String get storageRestore;

  /// No description provided for @osnovaTitle.
  ///
  /// In cs, this message translates to:
  /// **'Osnova'**
  String get osnovaTitle;

  /// No description provided for @osnovaSummary.
  ///
  /// In cs, this message translates to:
  /// **'Pohádka v kostce'**
  String get osnovaSummary;

  /// No description provided for @osnovaCharacters.
  ///
  /// In cs, this message translates to:
  /// **'Postavy'**
  String get osnovaCharacters;

  /// No description provided for @osnovaTask.
  ///
  /// In cs, this message translates to:
  /// **'Úkol'**
  String get osnovaTask;

  /// No description provided for @osnovaProblem.
  ///
  /// In cs, this message translates to:
  /// **'Problém'**
  String get osnovaProblem;

  /// No description provided for @osnovaEnding.
  ///
  /// In cs, this message translates to:
  /// **'Konec'**
  String get osnovaEnding;

  /// No description provided for @osnovaAgain.
  ///
  /// In cs, this message translates to:
  /// **'Znovu'**
  String get osnovaAgain;

  /// No description provided for @osnovaTell.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávím →'**
  String get osnovaTell;

  /// No description provided for @outlineHero.
  ///
  /// In cs, this message translates to:
  /// **'Hrdina'**
  String get outlineHero;

  /// Curated character card label
  ///
  /// In cs, this message translates to:
  /// **'Chytrá liška'**
  String get castFox;

  /// No description provided for @castSmithSon.
  ///
  /// In cs, this message translates to:
  /// **'Kovářův syn'**
  String get castSmithSon;

  /// No description provided for @castMill.
  ///
  /// In cs, this message translates to:
  /// **'Mluvící mlýn'**
  String get castMill;

  /// No description provided for @castGooseGirl.
  ///
  /// In cs, this message translates to:
  /// **'Husopaska'**
  String get castGooseGirl;

  /// No description provided for @castBrothers.
  ///
  /// In cs, this message translates to:
  /// **'Tři bratři'**
  String get castBrothers;

  /// No description provided for @castClockworkPrincess.
  ///
  /// In cs, this message translates to:
  /// **'Princezna hodinářka'**
  String get castClockworkPrincess;

  /// No description provided for @castOwl.
  ///
  /// In cs, this message translates to:
  /// **'Moudrá sova'**
  String get castOwl;

  /// No description provided for @castBlacksmith.
  ///
  /// In cs, this message translates to:
  /// **'Stará kovářka'**
  String get castBlacksmith;

  /// No description provided for @castDragon.
  ///
  /// In cs, this message translates to:
  /// **'Malý drak'**
  String get castDragon;

  /// No description provided for @castWaterSprite.
  ///
  /// In cs, this message translates to:
  /// **'Vodník'**
  String get castWaterSprite;

  /// No description provided for @castFourPrincesses.
  ///
  /// In cs, this message translates to:
  /// **'Čtyři princezny'**
  String get castFourPrincesses;

  /// No description provided for @castTravelingTailor.
  ///
  /// In cs, this message translates to:
  /// **'Potulný krejčí'**
  String get castTravelingTailor;

  /// No description provided for @castTalkingCat.
  ///
  /// In cs, this message translates to:
  /// **'Mluvící kocour'**
  String get castTalkingCat;

  /// No description provided for @castForestHermit.
  ///
  /// In cs, this message translates to:
  /// **'Lesní poustevník'**
  String get castForestHermit;

  /// No description provided for @castC0AndersenTheShadow.
  ///
  /// In cs, this message translates to:
  /// **'Pán, co býval stínem'**
  String get castC0AndersenTheShadow;

  /// No description provided for @castC1GrimmTheGooseGirl.
  ///
  /// In cs, this message translates to:
  /// **'Zrádná komorná'**
  String get castC1GrimmTheGooseGirl;

  /// No description provided for @castC2GrimmTheStoryOfTheYouthWhoWen.
  ///
  /// In cs, this message translates to:
  /// **'Král se strašidelným hradem'**
  String get castC2GrimmTheStoryOfTheYouthWhoWen;

  /// No description provided for @castC3AndersenTheShadow.
  ///
  /// In cs, this message translates to:
  /// **'Chytrý stín'**
  String get castC3AndersenTheShadow;

  /// No description provided for @castC4PerraultRiquetWithTheTuft.
  ///
  /// In cs, this message translates to:
  /// **'Krásná, ale nechytrá princezna'**
  String get castC4PerraultRiquetWithTheTuft;

  /// No description provided for @castC5AndersenTheRedShoes.
  ///
  /// In cs, this message translates to:
  /// **'Anděl, co nakonec odpustí'**
  String get castC5AndersenTheRedShoes;

  /// No description provided for @castC6GrimmRumpelstiltskin.
  ///
  /// In cs, this message translates to:
  /// **'Mlynářova chytrá dcera'**
  String get castC6GrimmRumpelstiltskin;

  /// No description provided for @castC7PerraultLittleRedRidingHood.
  ///
  /// In cs, this message translates to:
  /// **'Babička, co otevře dveře'**
  String get castC7PerraultLittleRedRidingHood;

  /// No description provided for @castC8PerraultLittleThumb.
  ///
  /// In cs, this message translates to:
  /// **'Máma mezi bídou a láskou'**
  String get castC8PerraultLittleThumb;

  /// No description provided for @castC9PerraultIntroduction.
  ///
  /// In cs, this message translates to:
  /// **'Trpělivá žena'**
  String get castC9PerraultIntroduction;

  /// No description provided for @castC10AndersenTheRealPrincess.
  ///
  /// In cs, this message translates to:
  /// **'Král, co podpoří syna'**
  String get castC10AndersenTheRealPrincess;

  /// No description provided for @castC11GrimmLilyAndTheLion.
  ///
  /// In cs, this message translates to:
  /// **'Dcera, co drží slovo'**
  String get castC11GrimmLilyAndTheLion;

  /// No description provided for @castC12AndersenTheRealPrincess.
  ///
  /// In cs, this message translates to:
  /// **'Princ hledá tu pravou'**
  String get castC12AndersenTheRealPrincess;

  /// No description provided for @castC13AndersenTheLittleMatchGirl.
  ///
  /// In cs, this message translates to:
  /// **'Holčička se sirkami'**
  String get castC13AndersenTheLittleMatchGirl;

  /// No description provided for @castC14AndersenTheEmperorSNewClothes.
  ///
  /// In cs, this message translates to:
  /// **'Dvořan, co mlčí'**
  String get castC14AndersenTheEmperorSNewClothes;

  /// No description provided for @castC15PerraultRiquetWithTheTuft.
  ///
  /// In cs, this message translates to:
  /// **'Věrný sluha chystá hostinu'**
  String get castC15PerraultRiquetWithTheTuft;

  /// No description provided for @castC16PerraultTheFairy.
  ///
  /// In cs, this message translates to:
  /// **'Nafoukaná dcera'**
  String get castC16PerraultTheFairy;

  /// No description provided for @castC17GrimmFirstStory.
  ///
  /// In cs, this message translates to:
  /// **'Vdova, co chce devět ocasů'**
  String get castC17GrimmFirstStory;

  /// Curated motif card label
  ///
  /// In cs, this message translates to:
  /// **'Kdo vypije sklep vína'**
  String get motifTaskWine;

  /// No description provided for @motifTaskDiamonds.
  ///
  /// In cs, this message translates to:
  /// **'Let za diamanty'**
  String get motifTaskDiamonds;

  /// No description provided for @motifTaskRingDuck.
  ///
  /// In cs, this message translates to:
  /// **'Prsten v kachně'**
  String get motifTaskRingDuck;

  /// No description provided for @motifTaskGiants.
  ///
  /// In cs, this message translates to:
  /// **'Přelstít obry'**
  String get motifTaskGiants;

  /// No description provided for @motifTaskTomThumb.
  ///
  /// In cs, this message translates to:
  /// **'Útěk malého Palečka'**
  String get motifTaskTomThumb;

  /// No description provided for @motifTaskSwineherd.
  ///
  /// In cs, this message translates to:
  /// **'Získat princeznino srdce'**
  String get motifTaskSwineherd;

  /// No description provided for @motifTaskBell.
  ///
  /// In cs, this message translates to:
  /// **'Záhadný zvon v lese'**
  String get motifTaskBell;

  /// No description provided for @motifTaskGoldenObject.
  ///
  /// In cs, this message translates to:
  /// **'Dar, který nesmí zneužít'**
  String get motifTaskGoldenObject;

  /// No description provided for @motifTaskPebbles.
  ///
  /// In cs, this message translates to:
  /// **'Cestička z oblázků'**
  String get motifTaskPebbles;

  /// No description provided for @motifProblemFoxPride.
  ///
  /// In cs, this message translates to:
  /// **'Liščina pýcha'**
  String get motifProblemFoxPride;

  /// No description provided for @motifProblemLazySister.
  ///
  /// In cs, this message translates to:
  /// **'Líná sestra'**
  String get motifProblemLazySister;

  /// No description provided for @motifProblemWitchBoots.
  ///
  /// In cs, this message translates to:
  /// **'Čarodějnice v sedmimílových botách'**
  String get motifProblemWitchBoots;

  /// No description provided for @motifProblemTailorDoubt.
  ///
  /// In cs, this message translates to:
  /// **'Nikdo mu nevěří'**
  String get motifProblemTailorDoubt;

  /// No description provided for @motifProblemLions.
  ///
  /// In cs, this message translates to:
  /// **'Hladoví lvi u brány'**
  String get motifProblemLions;

  /// No description provided for @motifProblemEagle.
  ///
  /// In cs, this message translates to:
  /// **'Orel a trpaslík'**
  String get motifProblemEagle;

  /// No description provided for @motifProblemTruth.
  ///
  /// In cs, this message translates to:
  /// **'Kouzelné zvíře prozradí pravdu'**
  String get motifProblemTruth;

  /// No description provided for @motifProblemOldHouse.
  ///
  /// In cs, this message translates to:
  /// **'Nikdo nechce starý dům'**
  String get motifProblemOldHouse;

  /// No description provided for @motifProblemBreadcrumbs.
  ///
  /// In cs, this message translates to:
  /// **'Ptáci snědli drobečky'**
  String get motifProblemBreadcrumbs;

  /// No description provided for @motifEndingTrickWins.
  ///
  /// In cs, this message translates to:
  /// **'Chytrost zvítězí'**
  String get motifEndingTrickWins;

  /// No description provided for @motifEndingTruthChild.
  ///
  /// In cs, this message translates to:
  /// **'Dítě řekne pravdu'**
  String get motifEndingTruthChild;

  /// No description provided for @motifEndingNewHome.
  ///
  /// In cs, this message translates to:
  /// **'Nový domov, staří přátelé'**
  String get motifEndingNewHome;

  /// No description provided for @motifEndingHappyTogether.
  ///
  /// In cs, this message translates to:
  /// **'Šťastně spolu navždy'**
  String get motifEndingHappyTogether;

  /// No description provided for @motifEndingKissWakes.
  ///
  /// In cs, this message translates to:
  /// **'Polibek probudí království'**
  String get motifEndingKissWakes;

  /// No description provided for @motifEndingLeapfrog.
  ///
  /// In cs, this message translates to:
  /// **'Chytrost skáče nejvýš'**
  String get motifEndingLeapfrog;

  /// No description provided for @motifEndingCurseBroken.
  ///
  /// In cs, this message translates to:
  /// **'Kletba zlomena'**
  String get motifEndingCurseBroken;

  /// No description provided for @motifEndingWelcomedHome.
  ///
  /// In cs, this message translates to:
  /// **'Vítán doma'**
  String get motifEndingWelcomedHome;

  /// No description provided for @motifEndingSlipper.
  ///
  /// In cs, this message translates to:
  /// **'Ztracený střevíček'**
  String get motifEndingSlipper;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bn',
    'ca',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fi',
    'fr',
    'gu',
    'he',
    'hi',
    'hr',
    'hu',
    'id',
    'it',
    'ja',
    'kn',
    'ko',
    'ml',
    'mr',
    'ms',
    'nb',
    'nl',
    'or',
    'pa',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sl',
    'sv',
    'ta',
    'te',
    'th',
    'tr',
    'uk',
    'ur',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when language+script codes are specified.
  switch (locale.languageCode) {
    case 'zh':
      {
        switch (locale.scriptCode) {
          case 'Hans':
            return AppLocalizationsZhHans();
          case 'Hant':
            return AppLocalizationsZhHant();
        }
        break;
      }
  }

  // Lookup logic when language+country codes are specified.
  switch (locale.languageCode) {
    case 'pt':
      {
        switch (locale.countryCode) {
          case 'BR':
            return AppLocalizationsPtBr();
          case 'PT':
            return AppLocalizationsPtPt();
        }
        break;
      }
  }

  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bn':
      return AppLocalizationsBn();
    case 'ca':
      return AppLocalizationsCa();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fi':
      return AppLocalizationsFi();
    case 'fr':
      return AppLocalizationsFr();
    case 'gu':
      return AppLocalizationsGu();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hr':
      return AppLocalizationsHr();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'kn':
      return AppLocalizationsKn();
    case 'ko':
      return AppLocalizationsKo();
    case 'ml':
      return AppLocalizationsMl();
    case 'mr':
      return AppLocalizationsMr();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'or':
      return AppLocalizationsOr();
    case 'pa':
      return AppLocalizationsPa();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sl':
      return AppLocalizationsSl();
    case 'sv':
      return AppLocalizationsSv();
    case 'ta':
      return AppLocalizationsTa();
    case 'te':
      return AppLocalizationsTe();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'ur':
      return AppLocalizationsUr();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
