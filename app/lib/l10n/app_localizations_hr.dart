// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get castTitle => 'Tko će biti u bajci?';

  @override
  String get castHint =>
      'Dodirni kartu za drugi lik. Kartu ukloni križićem. Glazba i zvukovi uvijek su gotovi iz paketa zemlje; samo se slika lika ponekad dovrši trenutak kasnije.';

  @override
  String get castAdd => 'Dodaj lik';

  @override
  String get castCount => 'Postava:';

  @override
  String get castShuffleAll => 'Promiješaj sve';

  @override
  String get castContinue => 'Nastavi →';

  @override
  String get shuffle => 'Promiješaj';

  @override
  String get motifTaskTitle => 'Koji zadatak?';

  @override
  String get motifProblemTitle => 'Koji problem?';

  @override
  String get motifEndingTitle => 'Koji kraj?';

  @override
  String get motifTaskCaption => 'Dodirni kartu i odaberi zadatak za junaka.';

  @override
  String get motifProblemCaption =>
      'Dodirni kartu i odaberi prepreku ili zlikovca.';

  @override
  String get motifEndingCaption => 'Dodirni kartu i odaberi sretan kraj.';

  @override
  String get beatCastTitle => 'Tko je u priči';

  @override
  String get beatTaskTitle => 'Što je junak naumio';

  @override
  String get beatProblemTitle => 'Što mu je stalo na put';

  @override
  String get beatEndingTitle => 'Kako je završilo';

  @override
  String get beatCastCaption =>
      'Predstavi likove: gdje su, kako izgledaju, što je na njima posebno.';

  @override
  String get beatTaskCaption => 'Reci što junak želi i zašto je krenuo.';

  @override
  String get beatProblemCaption =>
      'Stavi mu nešto na put. Neka se neko vrijeme čini da neće uspjeti.';

  @override
  String get beatEndingCaption =>
      'Dovedi priču do kraja. Ne žuri, dijete najbolje pamti kraj.';

  @override
  String get hintHero => 'junak';

  @override
  String hintCast1(String who) {
    return 'Kako izgleda «$who» kad se prvi put pojavi?';
  }

  @override
  String hintCast2(String who) {
    return 'Što radi «$who» neposredno prije nego što cijela priča počne?';
  }

  @override
  String hintCast3(String who) {
    return 'Čega se boji «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Po čemu znaš da dolazi «$who»?';
  }

  @override
  String get hintCast5 => 'Tko se od njih odavno poznaje i otkuda?';

  @override
  String get hintCast6 => 'Kakvo je vrijeme kad se sretnu?';

  @override
  String hintCast7(String who) {
    return 'Što «$who» ima u džepu?';
  }

  @override
  String hintTask1(String who) {
    return 'Kada «$who» shvati da se mora latiti posla?';
  }

  @override
  String hintTask2(String who) {
    return 'Tko je dao savjet i zašto ga «$who» posluša?';
  }

  @override
  String hintTask3(String who) {
    return 'Što «$who» mora ostaviti kod kuće?';
  }

  @override
  String get hintTask4 => 'Koliko je dug put i preko čega vodi?';

  @override
  String hintTask5(String who) {
    return 'Što «$who» obeća prije polaska?';
  }

  @override
  String get hintTask6 => 'Zašto to ne može napraviti netko drugi?';

  @override
  String get hintProblem1 => 'U tom se trenutku čuje zvuk. Kakav?';

  @override
  String get hintProblem2 => 'Što pođe po zlu prvo?';

  @override
  String hintProblem3(String who) {
    return 'Što «$who» prvo pokuša i zašto to ne uspije?';
  }

  @override
  String get hintProblem4 => 'Tko odbija pomoći iako bi mogao?';

  @override
  String get hintProblem5 => 'Što bi se dogodilo da svi sad odustanu?';

  @override
  String get hintProblem6 => 'Ima li u toj prepreci nečeg tužnog?';

  @override
  String hintProblem7(String who) {
    return 'Što «$who» u tom trenutku kaže naglas?';
  }

  @override
  String hintEnding1(String who) {
    return 'Čime «$who» to naposljetku svlada: snagom ili idejom?';
  }

  @override
  String get hintEnding2 => 'Tko pomogne iako nije morao?';

  @override
  String hintEnding3(String who) {
    return 'Što «$who» napravi prvo kad je sve gotovo?';
  }

  @override
  String get hintEnding4 => 'Što je na kraju drukčije nego na početku?';

  @override
  String hintEnding5(String who) {
    return 'Kamo se «$who» vraća i tko ga tamo čeka?';
  }

  @override
  String get hintEnding6 =>
      'Koja je posljednja rečenica prije nego se upali svjetlo?';

  @override
  String get globeLoading => 'Pripremam planet…';

  @override
  String get globeLoadFailed => 'Planet se nije mogao učitati.';

  @override
  String get globeTitle => 'Odakle će biti bajka?';

  @override
  String get globeStored => 'Preuzete bajke';

  @override
  String get globeHintFar =>
      'Zavrti planet ili dodirni zemlju. Zelene zemlje već imaju bajke iz naše zbirke, sive još nemaju.';

  @override
  String get globeHintNear =>
      'Dodirni zemlju ili građevinu. Zelene zemlje već imaju bajke iz naše zbirke, sive još nemaju.';

  @override
  String get globeWhole => 'Cijeli planet';

  @override
  String get globeZoomIn => 'Približi';

  @override
  String get globeZoomOut => 'Udalji';

  @override
  String globeZoomToRegion(String name) {
    return 'Približi: $name →';
  }

  @override
  String get globeTellHere => 'Ispričaj bajku odavde';

  @override
  String globeTellFrom(String place) {
    return 'Ispričaj bajku: $place →';
  }

  @override
  String get globeOpenSea => 'Otvoreno more';

  @override
  String globeRegionCountries(int n) {
    return '$n zemalja zajedno. Približi i odaberi jednu.';
  }

  @override
  String get globeTurnToCountry => 'Okreni planet prema nekoj zemlji.';

  @override
  String get globeSpin => 'Zavrti';

  @override
  String get globeNoTales => 'Odavde još nemamo nijednu bajku.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiva',
      few: '$n motiva',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'iz $n bajki',
      few: 'iz $n bajke',
      one: 'iz $n bajke',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs iz paketa';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motiva iz paketa',
      few: '$n motiva iz paketa',
      one: '$n motiv iz paketa',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajku',
    );
    return 'Pripremamo $_temp0 odavde za paket $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajka',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajka',
    );
    return '$_temp0 besplatno';
  }

  @override
  String cardFree(int n) {
    return '$n besplatno';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n u dijelovima $region $range',
      one: '$n u dijelu $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'imaš $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'još $n stiže',
      few: 'još $n stižu',
      one: 'još $n stiže',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Čekam trgovinu…';

  @override
  String offerDownloading(int percent) {
    return 'Preuzimam bajke… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajka',
    );
    return 'Kupi $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajka',
    );
    return 'Preuzmi $name: $_temp0 besplatno ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      few: '$n bajke',
      one: '$n bajka',
    );
    return 'Preuzmi $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Preuzmi $name';
  }

  @override
  String get errDownloadTales => 'Bajke se nisu mogle preuzeti.';

  @override
  String get errDownloadScenes => 'Slike se nisu mogle preuzeti.';

  @override
  String get errNoDownloads => 'Preuzimanje ovdje nije dostupno.';

  @override
  String get errOffline =>
      'Nema internetske veze, pokušaj ponovno kad budeš imao signal.';

  @override
  String get errCannotBuy => 'Taj se dio trenutačno ne može kupiti.';

  @override
  String get buyPending =>
      'Kupnja čeka odobrenje. Dio će se preuzeti čim prođe.';

  @override
  String get buyFailed => 'Kupnja nije uspjela.';

  @override
  String get restoreNone => 'Na ovom računu nema kupnji.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Vraćeno je $n dijelova. Preuzmi ih s planeta.',
      few: 'Vraćena su $n dijela. Preuzmi ih s planeta.',
      one: 'Vraćen je $n dio. Preuzmi ga s planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Kupnje se nisu mogle vratiti, pokušaj ponovno kad budeš imao signal.';

  @override
  String get narrationGone => 'Ta bajka više nije sastavljena.';

  @override
  String get narrationNew => 'Sastavi novu';

  @override
  String narrationTitle(int index, int total) {
    return 'Pričaš — $index od $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Kako nastaviti: $bridge';
  }

  @override
  String get narrationSituation =>
      'Što se upravo događa? (neobavezno, možeš diktirati)';

  @override
  String get narrationHintNote =>
      'Savjet, ne govori ga naglas, samo se od njega odgurni.';

  @override
  String get narrationSoundsNote =>
      'Zvukovi, pusti ih kad se uklapaju u pripovijedanje.';

  @override
  String get moodTense => 'napetost';

  @override
  String get moodCalm => 'mir';

  @override
  String get narrationSearching => 'Tražim…';

  @override
  String get narrationHint => 'Daj savjet';

  @override
  String get narrationMoreHint => 'Još jedan';

  @override
  String get narrationBack => 'Natrag';

  @override
  String get narrationEnd => 'Kraj';

  @override
  String get narrationNext => 'Dalje →';

  @override
  String get narrationGoodnight => 'Laku noć.';

  @override
  String get narrationEndNote =>
      'Završnu sliku i spremanje u Knjižnicu još ne znamo napraviti. Ova bajka nikamo ne odlazi, ostaje među vama.';

  @override
  String get narrationClose => 'Zatvori';

  @override
  String get ragFallback =>
      'U paketu za ovo još nema ničega, evo općeg savjeta:';

  @override
  String get ragNoModel => 'Model za savjete nije dio ove inačice.';

  @override
  String get ragHintGeneral => 'opći';

  @override
  String get ragHintMotif => 'za motiv';

  @override
  String get captionExact => 'ilustracija · za ovaj motiv';

  @override
  String get captionSimilar => 'ilustracija · slična scena';

  @override
  String get captionCard => 'kartica motiva · za ovaj korak još nemamo scenu';

  @override
  String get storageTitle => 'Preuzete bajke';

  @override
  String get storageEmpty => 'Još ništa, nove bajke preuzimaju se s planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paketa',
      few: '$n paketa',
      one: '$n paket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scene: $name';
  }

  @override
  String get storageFreeTier => 'besplatno';

  @override
  String get storageBoughtTier => 'kupljeno';

  @override
  String get storageDelete => 'Izbriši';

  @override
  String get storageScenesSub => 'Slika za svaki korak pripovijedanja';

  @override
  String get storageDownload => 'Preuzmi';

  @override
  String get storageAllUsed => 'Sve je korišteno u posljednjih 30 dana.';

  @override
  String storageFreed(String size) {
    return 'Oslobođeno: $size.';
  }

  @override
  String get storageFreeUp => 'Oslobodi prostor (nekorišteno 30 dana)';

  @override
  String get storageRestoring => 'Vraćam kupnje…';

  @override
  String get storageRestore => 'Vrati kupnje';

  @override
  String get osnovaTitle => 'Nacrt';

  @override
  String get osnovaSummary => 'Bajka ukratko';

  @override
  String get osnovaCharacters => 'Likovi';

  @override
  String get osnovaTask => 'Zadatak';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Kraj';

  @override
  String get osnovaAgain => 'Ispočetka';

  @override
  String get osnovaTell => 'Pričam →';

  @override
  String get outlineHero => 'Junak';

  @override
  String get castFox => 'Lukava lija';

  @override
  String get castSmithSon => 'Kovačev sin';

  @override
  String get castMill => 'Mlin koji govori';

  @override
  String get castGooseGirl => 'Guščarica';

  @override
  String get castBrothers => 'Tri brata';

  @override
  String get castClockworkPrincess => 'Princeza urarica';

  @override
  String get castOwl => 'Mudra sova';

  @override
  String get castBlacksmith => 'Stara kovačica';

  @override
  String get castDragon => 'Mali zmaj';

  @override
  String get castWaterSprite => 'Vodenjak';

  @override
  String get castFourPrincesses => 'Četiri princeze';

  @override
  String get castTravelingTailor => 'Lutajući krojač';

  @override
  String get castTalkingCat => 'Mačak koji govori';

  @override
  String get castForestHermit => 'Šumski pustinjak';

  @override
  String get castC0AndersenTheShadow => 'Gospodin koji je nekoć bio sjena';

  @override
  String get castC1GrimmTheGooseGirl => 'Izdajnička sobarica';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'Kralj s ukletim dvorcem';

  @override
  String get castC3AndersenTheShadow => 'Lukava sjena';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Lijepa, ali ne baš pametna princeza';

  @override
  String get castC5AndersenTheRedShoes => 'Anđeo koji na kraju oprosti';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mlinareva pametna kći';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Baka koja otvara vrata';

  @override
  String get castC8PerraultLittleThumb => 'Majka između bijede i ljubavi';

  @override
  String get castC9PerraultIntroduction => 'Strpljiva žena';

  @override
  String get castC10AndersenTheRealPrincess => 'Kralj koji podupire sina';

  @override
  String get castC11GrimmLilyAndTheLion => 'Kći koja drži riječ';

  @override
  String get castC12AndersenTheRealPrincess => 'Princ traži pravu princezu';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Djevojčica sa žigicama';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Dvorjanin koji šuti';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Vjerni sluga priprema gozbu';

  @override
  String get castC16PerraultTheFairy => 'Umišljena kći';

  @override
  String get castC17GrimmFirstStory => 'Udovica koja želi devet repova';

  @override
  String get motifTaskWine => 'Tko će popiti podrum vina';

  @override
  String get motifTaskDiamonds => 'Let za dijamantima';

  @override
  String get motifTaskRingDuck => 'Prsten u patki';

  @override
  String get motifTaskGiants => 'Nadmudriti divove';

  @override
  String get motifTaskTomThumb => 'Bijeg Palčića';

  @override
  String get motifTaskSwineherd => 'Osvojiti srce princeze';

  @override
  String get motifTaskBell => 'Tajanstveno zvono u šumi';

  @override
  String get motifTaskGoldenObject => 'Dar kojim se ne smije zlorabiti';

  @override
  String get motifTaskPebbles => 'Staza od kamenčića';

  @override
  String get motifProblemFoxPride => 'Lisičja oholost';

  @override
  String get motifProblemLazySister => 'Lijena sestra';

  @override
  String get motifProblemWitchBoots => 'Vještica u čizmama od sedam milja';

  @override
  String get motifProblemTailorDoubt => 'Nitko mu ne vjeruje';

  @override
  String get motifProblemLions => 'Gladni lavovi na vratima';

  @override
  String get motifProblemEagle => 'Orao i patuljak';

  @override
  String get motifProblemTruth => 'Čarobna životinja otkriva istinu';

  @override
  String get motifProblemOldHouse => 'Nitko ne želi staru kuću';

  @override
  String get motifProblemBreadcrumbs => 'Ptice su pojele mrvice';

  @override
  String get motifEndingTrickWins => 'Lukavost pobjeđuje';

  @override
  String get motifEndingTruthChild => 'Dijete govori istinu';

  @override
  String get motifEndingNewHome => 'Novi dom, stari prijatelji';

  @override
  String get motifEndingHappyTogether => 'Sretni zajedno zauvijek';

  @override
  String get motifEndingKissWakes => 'Poljubac budi kraljevstvo';

  @override
  String get motifEndingLeapfrog => 'Lukavost skače najviše';

  @override
  String get motifEndingCurseBroken => 'Prokletstvo je slomljeno';

  @override
  String get motifEndingWelcomedHome => 'Dobrodošlica kod kuće';

  @override
  String get motifEndingSlipper => 'Izgubljena cipelica';
}
