import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_cs.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'gen/app_localizations.dart';
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
    Locale('cs'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In cs, this message translates to:
  /// **'Pohádkomat'**
  String get appTitle;

  /// No description provided for @globeLoadFailed.
  ///
  /// In cs, this message translates to:
  /// **'Planetu se nepodařilo načíst.'**
  String get globeLoadFailed;

  /// No description provided for @globeLoading.
  ///
  /// In cs, this message translates to:
  /// **'Chystám planetu…'**
  String get globeLoading;

  /// No description provided for @globeTitle.
  ///
  /// In cs, this message translates to:
  /// **'Odkud bude pohádka?'**
  String get globeTitle;

  /// No description provided for @globeDownloadedTooltip.
  ///
  /// In cs, this message translates to:
  /// **'Stažené pohádky'**
  String get globeDownloadedTooltip;

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

  /// No description provided for @globeZoomInto.
  ///
  /// In cs, this message translates to:
  /// **'Přiblížit {region} →'**
  String globeZoomInto(String region);

  /// No description provided for @globeTellHere.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávět odsud'**
  String get globeTellHere;

  /// No description provided for @globeTellFrom.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávět {from} →'**
  String globeTellFrom(String from);

  /// No description provided for @globeOpenSea.
  ///
  /// In cs, this message translates to:
  /// **'Širé moře'**
  String get globeOpenSea;

  /// No description provided for @globeRegionCount.
  ///
  /// In cs, this message translates to:
  /// **'{n} zemí pohromadě. Přibliž se a vyber si jednu.'**
  String globeRegionCount(int n);

  /// No description provided for @globeTurnToCountry.
  ///
  /// In cs, this message translates to:
  /// **'Otoč planetu na nějakou zemi.'**
  String get globeTurnToCountry;

  /// No description provided for @globeNothingHere.
  ///
  /// In cs, this message translates to:
  /// **'Odsud zatím žádné pohádky nemáme.'**
  String get globeNothingHere;

  /// No description provided for @globeSpin.
  ///
  /// In cs, this message translates to:
  /// **'Roztočit'**
  String get globeSpin;

  /// No description provided for @motifsFromPack.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, =1{1 motiv} few{{n} motivy} other{{n} motivů}} z balíčku'**
  String motifsFromPack(int n);

  /// No description provided for @plusFromPack.
  ///
  /// In cs, this message translates to:
  /// **'{base} + {n} z balíčku'**
  String plusFromPack(String base, int n);

  /// No description provided for @motifsFromTales.
  ///
  /// In cs, this message translates to:
  /// **'{motifs, plural, =1{1 motiv} few{{motifs} motivy} other{{motifs} motivů}} z {tales, plural, =1{1 pohádky} other{{tales} pohádek}}'**
  String motifsFromTales(int motifs, int tales);

  /// No description provided for @offerWaitingStore.
  ///
  /// In cs, this message translates to:
  /// **'Čekám na obchod…'**
  String get offerWaitingStore;

  /// No description provided for @offerDownloading.
  ///
  /// In cs, this message translates to:
  /// **'Stahuji pohádky… {percent} %'**
  String offerDownloading(int percent);

  /// No description provided for @offerBuy.
  ///
  /// In cs, this message translates to:
  /// **'Koupit {name}: {n, plural, =1{1 pohádku} few{{n} pohádky} other{{n} pohádek}} za {price}'**
  String offerBuy(String name, int n, String price);

  /// No description provided for @offerDownloadFree.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}: {n, plural, =1{1 pohádku} few{{n} pohádky} other{{n} pohádek}} zdarma ({size})'**
  String offerDownloadFree(String name, int n, String size);

  /// No description provided for @offerDownloadOwned.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}: {n, plural, =1{1 pohádku} few{{n} pohádky} other{{n} pohádek}} ({size})'**
  String offerDownloadOwned(String name, int n, String size);

  /// No description provided for @offerDownloadTooltip.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout {name}'**
  String offerDownloadTooltip(String name);

  /// No description provided for @talesComing.
  ///
  /// In cs, this message translates to:
  /// **'Chystáme odsud {n, plural, =1{1 pohádku} few{{n} pohádky} other{{n} pohádek}} do balíčku {region}.'**
  String talesComing(int n, String region);

  /// No description provided for @talesFreeCount.
  ///
  /// In cs, this message translates to:
  /// **'{n} zdarma'**
  String talesFreeCount(int n);

  /// No description provided for @talesInParts.
  ///
  /// In cs, this message translates to:
  /// **'{n} {parts, plural, =1{v dílu} other{v dílech}} {region} {range}'**
  String talesInParts(int n, int parts, String region, String range);

  /// No description provided for @talesTotal.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, =1{1 pohádka} few{{n} pohádky} other{{n} pohádek}}'**
  String talesTotal(int n);

  /// No description provided for @talesTotalFree.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, =1{1 pohádka} few{{n} pohádky} other{{n} pohádek}} zdarma'**
  String talesTotalFree(int n);

  /// No description provided for @talesYouHave.
  ///
  /// In cs, this message translates to:
  /// **'máš {n}'**
  String talesYouHave(int n);

  /// No description provided for @talesMoreComing.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, =1{další 1 chystáme} other{dalších {n} chystáme}}'**
  String talesMoreComing(int n);

  /// No description provided for @castTitle.
  ///
  /// In cs, this message translates to:
  /// **'Kdo bude v pohádce?'**
  String get castTitle;

  /// No description provided for @castCaption.
  ///
  /// In cs, this message translates to:
  /// **'Ťukni na kartu = jiná postava. Kartu smaž křížkem. Hudba a zvuky jsou vždy hotové z packu země — jen obrázek postavy se občas chvilku dokresluje.'**
  String get castCaption;

  /// No description provided for @castAdd.
  ///
  /// In cs, this message translates to:
  /// **'Přidat postavu'**
  String get castAdd;

  /// No description provided for @castCount.
  ///
  /// In cs, this message translates to:
  /// **'Obsazení: '**
  String get castCount;

  /// No description provided for @castShuffleAll.
  ///
  /// In cs, this message translates to:
  /// **'Zamíchat vše'**
  String get castShuffleAll;

  /// No description provided for @next.
  ///
  /// In cs, this message translates to:
  /// **'Pokračovat →'**
  String get next;

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

  /// No description provided for @outlineTitle.
  ///
  /// In cs, this message translates to:
  /// **'Osnova'**
  String get outlineTitle;

  /// No description provided for @outlineSummary.
  ///
  /// In cs, this message translates to:
  /// **'Pohádka v kostce'**
  String get outlineSummary;

  /// No description provided for @outlineCharacters.
  ///
  /// In cs, this message translates to:
  /// **'Postavy'**
  String get outlineCharacters;

  /// No description provided for @outlineTask.
  ///
  /// In cs, this message translates to:
  /// **'Úkol'**
  String get outlineTask;

  /// No description provided for @outlineProblem.
  ///
  /// In cs, this message translates to:
  /// **'Problém'**
  String get outlineProblem;

  /// No description provided for @outlineEnding.
  ///
  /// In cs, this message translates to:
  /// **'Konec'**
  String get outlineEnding;

  /// No description provided for @outlineAgain.
  ///
  /// In cs, this message translates to:
  /// **'Znovu'**
  String get outlineAgain;

  /// No description provided for @outlineTell.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávím →'**
  String get outlineTell;

  /// No description provided for @outlineHero.
  ///
  /// In cs, this message translates to:
  /// **'Hrdina'**
  String get outlineHero;

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

  /// No description provided for @narrNoEmbedder.
  ///
  /// In cs, this message translates to:
  /// **'model pro nápovědy není v téhle sestavě'**
  String get narrNoEmbedder;

  /// No description provided for @narrGenericFallback.
  ///
  /// In cs, this message translates to:
  /// **'Z balíčku k tomuhle zatím nic — obecná nápověda:'**
  String get narrGenericFallback;

  /// No description provided for @narrNotComposed.
  ///
  /// In cs, this message translates to:
  /// **'Tahle pohádka už není složená.'**
  String get narrNotComposed;

  /// No description provided for @narrComposeNew.
  ///
  /// In cs, this message translates to:
  /// **'Složit novou'**
  String get narrComposeNew;

  /// No description provided for @narrTitle.
  ///
  /// In cs, this message translates to:
  /// **'Vyprávíš — {i} ze {n}'**
  String narrTitle(int i, int n);

  /// No description provided for @narrBridge.
  ///
  /// In cs, this message translates to:
  /// **'Jak navázat: {bridge}'**
  String narrBridge(String bridge);

  /// No description provided for @narrWhatsHappening.
  ///
  /// In cs, this message translates to:
  /// **'Co se zrovna děje? (nepovinné, jde nadiktovat)'**
  String get narrWhatsHappening;

  /// No description provided for @narrHintNote.
  ///
  /// In cs, this message translates to:
  /// **'Nápověda — neříkej ji nahlas, jen se od ní odraz.'**
  String get narrHintNote;

  /// No description provided for @narrHintGeneric.
  ///
  /// In cs, this message translates to:
  /// **'obecná'**
  String get narrHintGeneric;

  /// No description provided for @narrHintMotif.
  ///
  /// In cs, this message translates to:
  /// **'k motivu'**
  String get narrHintMotif;

  /// No description provided for @narrSoundsNote.
  ///
  /// In cs, this message translates to:
  /// **'Zvuky — pusť, až se to do vyprávění hodí.'**
  String get narrSoundsNote;

  /// No description provided for @narrMoodTense.
  ///
  /// In cs, this message translates to:
  /// **'napětí'**
  String get narrMoodTense;

  /// No description provided for @narrMoodCalm.
  ///
  /// In cs, this message translates to:
  /// **'klid'**
  String get narrMoodCalm;

  /// No description provided for @narrSearching.
  ///
  /// In cs, this message translates to:
  /// **'Hledám…'**
  String get narrSearching;

  /// No description provided for @narrHint.
  ///
  /// In cs, this message translates to:
  /// **'Napověz'**
  String get narrHint;

  /// No description provided for @narrAnother.
  ///
  /// In cs, this message translates to:
  /// **'Ještě jednu'**
  String get narrAnother;

  /// No description provided for @back.
  ///
  /// In cs, this message translates to:
  /// **'Zpět'**
  String get back;

  /// No description provided for @narrEnd.
  ///
  /// In cs, this message translates to:
  /// **'Konec'**
  String get narrEnd;

  /// No description provided for @narrNext.
  ///
  /// In cs, this message translates to:
  /// **'Dál →'**
  String get narrNext;

  /// No description provided for @narrGoodNight.
  ///
  /// In cs, this message translates to:
  /// **'Dobrou noc.'**
  String get narrGoodNight;

  /// No description provided for @narrGoodNightBody.
  ///
  /// In cs, this message translates to:
  /// **'Závěrečný obrázek a ukládání do Knihovny zatím neumíme — tahle pohádka nikam neodchází, zůstala mezi vámi.'**
  String get narrGoodNightBody;

  /// No description provided for @close.
  ///
  /// In cs, this message translates to:
  /// **'Zavřít'**
  String get close;

  /// No description provided for @artExact.
  ///
  /// In cs, this message translates to:
  /// **'ilustrace · k tomuhle motivu'**
  String get artExact;

  /// No description provided for @artSimilar.
  ///
  /// In cs, this message translates to:
  /// **'ilustrace · podobná scéna'**
  String get artSimilar;

  /// No description provided for @artCard.
  ///
  /// In cs, this message translates to:
  /// **'karta motivu · scénu k tomuhle kroku zatím nemáme'**
  String get artCard;

  /// No description provided for @packDownloadFailed.
  ///
  /// In cs, this message translates to:
  /// **'Pohádky se nepodařilo stáhnout.'**
  String get packDownloadFailed;

  /// No description provided for @packPartUnavailable.
  ///
  /// In cs, this message translates to:
  /// **'Tenhle díl teď koupit nejde.'**
  String get packPartUnavailable;

  /// No description provided for @packPurchasePending.
  ///
  /// In cs, this message translates to:
  /// **'Nákup čeká na schválení. Díl se stáhne, až projde.'**
  String get packPurchasePending;

  /// No description provided for @packPurchaseFailed.
  ///
  /// In cs, this message translates to:
  /// **'Nákup se nepovedl.'**
  String get packPurchaseFailed;

  /// No description provided for @packScenesFailed.
  ///
  /// In cs, this message translates to:
  /// **'Obrázky se nepodařilo stáhnout.'**
  String get packScenesFailed;

  /// No description provided for @packNoDownloads.
  ///
  /// In cs, this message translates to:
  /// **'Stahování tu není k dispozici.'**
  String get packNoDownloads;

  /// No description provided for @packOffline.
  ///
  /// In cs, this message translates to:
  /// **'Nejsme na internetu — zkus to, až bude signál.'**
  String get packOffline;

  /// No description provided for @restoreNone.
  ///
  /// In cs, this message translates to:
  /// **'Na tomhle účtu nejsou žádné nákupy.'**
  String get restoreNone;

  /// No description provided for @restoreDone.
  ///
  /// In cs, this message translates to:
  /// **'{n, plural, =1{Obnoven 1 díl. Stáhneš ho z planety.} few{Obnoveno {n} díly. Stáhneš je z planety.} other{Obnoveno {n} dílů. Stáhneš je z planety.}}'**
  String restoreDone(int n);

  /// No description provided for @restoreFailed.
  ///
  /// In cs, this message translates to:
  /// **'Nákupy se nepodařilo obnovit — zkus to, až bude signál.'**
  String get restoreFailed;

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
  /// **'{n, plural, =1{1 balíček} few{{n} balíčky} other{{n} balíčků}}, {size}'**
  String storageSummary(int n, String size);

  /// No description provided for @storageScenes.
  ///
  /// In cs, this message translates to:
  /// **'Scény {iso}'**
  String storageScenes(String iso);

  /// No description provided for @storageFree.
  ///
  /// In cs, this message translates to:
  /// **'zdarma'**
  String get storageFree;

  /// No description provided for @storageBought.
  ///
  /// In cs, this message translates to:
  /// **'zakoupeno'**
  String get storageBought;

  /// No description provided for @storageDelete.
  ///
  /// In cs, this message translates to:
  /// **'Smazat'**
  String get storageDelete;

  /// No description provided for @storageScenesSubtitle.
  ///
  /// In cs, this message translates to:
  /// **'Obrázek ke každému kroku vyprávění · {size} · zdarma'**
  String storageScenesSubtitle(String size);

  /// No description provided for @storageDownload.
  ///
  /// In cs, this message translates to:
  /// **'Stáhnout'**
  String get storageDownload;

  /// No description provided for @storageNothingFreed.
  ///
  /// In cs, this message translates to:
  /// **'Všechno se používalo v posledních 30 dnech.'**
  String get storageNothingFreed;

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

  /// No description provided for @decimalSeparator.
  ///
  /// In cs, this message translates to:
  /// **','**
  String get decimalSeparator;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['cs', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'cs':
      return AppLocalizationsCs();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
