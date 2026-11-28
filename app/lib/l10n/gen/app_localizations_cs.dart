// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Czech (`cs`).
class AppLocalizationsCs extends AppLocalizations {
  AppLocalizationsCs([String locale = 'cs']) : super(locale);

  @override
  String get appTitle => 'Pohádkomat';

  @override
  String get globeLoadFailed => 'Planetu se nepodařilo načíst.';

  @override
  String get globeLoading => 'Chystám planetu…';

  @override
  String get globeTitle => 'Odkud bude pohádka?';

  @override
  String get globeDownloadedTooltip => 'Stažené pohádky';

  @override
  String get globeHintFar =>
      'Roztoč planetu nebo ťukni na zemi. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.';

  @override
  String get globeHintNear =>
      'Ťukni na zemi nebo na stavbu. Zelené země už mají pohádky z našeho korpusu, šedé zatím ne.';

  @override
  String get globeWhole => 'Celá planeta';

  @override
  String get globeZoomIn => 'Přiblížit';

  @override
  String get globeZoomOut => 'Oddálit';

  @override
  String globeZoomInto(String region) {
    return 'Přiblížit $region →';
  }

  @override
  String get globeTellHere => 'Vyprávět odsud';

  @override
  String globeTellFrom(String from) {
    return 'Vyprávět $from →';
  }

  @override
  String get globeOpenSea => 'Širé moře';

  @override
  String globeRegionCount(int n) {
    return '$n zemí pohromadě. Přibliž se a vyber si jednu.';
  }

  @override
  String get globeTurnToCountry => 'Otoč planetu na nějakou zemi.';

  @override
  String get globeNothingHere => 'Odsud zatím žádné pohádky nemáme.';

  @override
  String get globeSpin => 'Roztočit';

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivů',
      few: '$n motivy',
      one: '1 motiv',
    );
    return '$_temp0 z balíčku';
  }

  @override
  String plusFromPack(String base, int n) {
    return '$base + $n z balíčku';
  }

  @override
  String motifsFromTales(int motifs, int tales) {
    String _temp0 = intl.Intl.pluralLogic(
      motifs,
      locale: localeName,
      other: '$motifs motivů',
      few: '$motifs motivy',
      one: '1 motiv',
    );
    String _temp1 = intl.Intl.pluralLogic(
      tales,
      locale: localeName,
      other: '$tales pohádek',
      one: '1 pohádky',
    );
    return '$_temp0 z $_temp1';
  }

  @override
  String get offerWaitingStore => 'Čekám na obchod…';

  @override
  String offerDownloading(int percent) {
    return 'Stahuji pohádky… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádku',
    );
    return 'Koupit $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádku',
    );
    return 'Stáhnout $name: $_temp0 zdarma ($size)';
  }

  @override
  String offerDownloadOwned(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádku',
    );
    return 'Stáhnout $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTooltip(String name) {
    return 'Stáhnout $name';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádku',
    );
    return 'Chystáme odsud $_temp0 do balíčku $region.';
  }

  @override
  String talesFreeCount(int n) {
    return '$n zdarma';
  }

  @override
  String talesInParts(int n, int parts, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: 'v dílech',
      one: 'v dílu',
    );
    return '$n $_temp0 $region $range';
  }

  @override
  String talesTotal(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádka',
    );
    return '$_temp0';
  }

  @override
  String talesTotalFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pohádek',
      few: '$n pohádky',
      one: '1 pohádka',
    );
    return '$_temp0 zdarma';
  }

  @override
  String talesYouHave(int n) {
    return 'máš $n';
  }

  @override
  String talesMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'dalších $n chystáme',
      one: 'další 1 chystáme',
    );
    return '$_temp0';
  }

  @override
  String get castTitle => 'Kdo bude v pohádce?';

  @override
  String get castCaption =>
      'Ťukni na kartu = jiná postava. Kartu smaž křížkem. Hudba a zvuky jsou vždy hotové z packu země — jen obrázek postavy se občas chvilku dokresluje.';

  @override
  String get castAdd => 'Přidat postavu';

  @override
  String get castCount => 'Obsazení: ';

  @override
  String get castShuffleAll => 'Zamíchat vše';

  @override
  String get next => 'Pokračovat →';

  @override
  String get shuffle => 'Zamíchat';

  @override
  String get motifTaskTitle => 'Jaký úkol?';

  @override
  String get motifProblemTitle => 'Jaký problém?';

  @override
  String get motifEndingTitle => 'Jaký konec?';

  @override
  String get motifTaskCaption => 'Ťukni na kartu = vyber úkol pro hrdinu.';

  @override
  String get motifProblemCaption =>
      'Ťukni na kartu = vyber překážku nebo záporáka.';

  @override
  String get motifEndingCaption => 'Ťukni na kartu = vyber šťastný konec.';

  @override
  String get outlineTitle => 'Osnova';

  @override
  String get outlineSummary => 'Pohádka v kostce';

  @override
  String get outlineCharacters => 'Postavy';

  @override
  String get outlineTask => 'Úkol';

  @override
  String get outlineProblem => 'Problém';

  @override
  String get outlineEnding => 'Konec';

  @override
  String get outlineAgain => 'Znovu';

  @override
  String get outlineTell => 'Vyprávím →';

  @override
  String get outlineHero => 'Hrdina';

  @override
  String get beatCastTitle => 'Kdo v tom bude';

  @override
  String get beatTaskTitle => 'Co si hrdina předsevzal';

  @override
  String get beatProblemTitle => 'Co se postavilo do cesty';

  @override
  String get beatEndingTitle => 'Jak to dopadlo';

  @override
  String get beatCastCaption =>
      'Představ postavy. Kde jsou, jak vypadají, co je na nich zvláštního.';

  @override
  String get beatTaskCaption => 'Řekni, co hrdina chce a proč se pro to vydal.';

  @override
  String get beatProblemCaption =>
      'Postav mu něco do cesty. Ať to chvíli vypadá, že to nepůjde.';

  @override
  String get beatEndingCaption =>
      'Doveď to do konce. Nespěchej — konec si dítě pamatuje nejvíc.';

  @override
  String get narrNoEmbedder => 'model pro nápovědy není v téhle sestavě';

  @override
  String get narrGenericFallback =>
      'Z balíčku k tomuhle zatím nic — obecná nápověda:';

  @override
  String get narrNotComposed => 'Tahle pohádka už není složená.';

  @override
  String get narrComposeNew => 'Složit novou';

  @override
  String narrTitle(int i, int n) {
    return 'Vyprávíš — $i ze $n';
  }

  @override
  String narrBridge(String bridge) {
    return 'Jak navázat: $bridge';
  }

  @override
  String get narrWhatsHappening =>
      'Co se zrovna děje? (nepovinné, jde nadiktovat)';

  @override
  String get narrHintNote =>
      'Nápověda — neříkej ji nahlas, jen se od ní odraz.';

  @override
  String get narrHintGeneric => 'obecná';

  @override
  String get narrHintMotif => 'k motivu';

  @override
  String get narrSoundsNote => 'Zvuky — pusť, až se to do vyprávění hodí.';

  @override
  String get narrMoodTense => 'napětí';

  @override
  String get narrMoodCalm => 'klid';

  @override
  String get narrSearching => 'Hledám…';

  @override
  String get narrHint => 'Napověz';

  @override
  String get narrAnother => 'Ještě jednu';

  @override
  String get back => 'Zpět';

  @override
  String get narrEnd => 'Konec';

  @override
  String get narrNext => 'Dál →';

  @override
  String get narrGoodNight => 'Dobrou noc.';

  @override
  String get narrGoodNightBody =>
      'Závěrečný obrázek a ukládání do Knihovny zatím neumíme — tahle pohádka nikam neodchází, zůstala mezi vámi.';

  @override
  String get close => 'Zavřít';

  @override
  String get artExact => 'ilustrace · k tomuhle motivu';

  @override
  String get artSimilar => 'ilustrace · podobná scéna';

  @override
  String get artCard => 'karta motivu · scénu k tomuhle kroku zatím nemáme';

  @override
  String get packDownloadFailed => 'Pohádky se nepodařilo stáhnout.';

  @override
  String get packPartUnavailable => 'Tenhle díl teď koupit nejde.';

  @override
  String get packPurchasePending =>
      'Nákup čeká na schválení. Díl se stáhne, až projde.';

  @override
  String get packPurchaseFailed => 'Nákup se nepovedl.';

  @override
  String get packScenesFailed => 'Obrázky se nepodařilo stáhnout.';

  @override
  String get packNoDownloads => 'Stahování tu není k dispozici.';

  @override
  String get packOffline => 'Nejsme na internetu — zkus to, až bude signál.';

  @override
  String get restoreNone => 'Na tomhle účtu nejsou žádné nákupy.';

  @override
  String restoreDone(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Obnoveno $n dílů. Stáhneš je z planety.',
      few: 'Obnoveno $n díly. Stáhneš je z planety.',
      one: 'Obnoven 1 díl. Stáhneš ho z planety.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Nákupy se nepodařilo obnovit — zkus to, až bude signál.';

  @override
  String get storageTitle => 'Stažené pohádky';

  @override
  String get storageEmpty => 'Zatím nic — další pohádky se stáhnou z planety.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n balíčků',
      few: '$n balíčky',
      one: '1 balíček',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String iso) {
    return 'Scény $iso';
  }

  @override
  String get storageFree => 'zdarma';

  @override
  String get storageBought => 'zakoupeno';

  @override
  String get storageDelete => 'Smazat';

  @override
  String storageScenesSubtitle(String size) {
    return 'Obrázek ke každému kroku vyprávění · $size · zdarma';
  }

  @override
  String get storageDownload => 'Stáhnout';

  @override
  String get storageNothingFreed =>
      'Všechno se používalo v posledních 30 dnech.';

  @override
  String storageFreed(String size) {
    return 'Uvolněno $size.';
  }

  @override
  String get storageFreeUp => 'Uvolnit místo (nepoužité 30 dní)';

  @override
  String get storageRestoring => 'Obnovuji nákupy…';

  @override
  String get storageRestore => 'Obnovit nákupy';

  @override
  String get decimalSeparator => ',';
}
