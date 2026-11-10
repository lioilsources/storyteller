// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovenian (`sl`).
class AppLocalizationsSl extends AppLocalizations {
  AppLocalizationsSl([String locale = 'sl']) : super(locale);

  @override
  String get castTitle => 'Kdo bo v pravljici?';

  @override
  String get castHint =>
      'Tapni kartico za drug lik. Kartico odstraniš s križcem. Glasba in zvoki so vedno pripravljeni iz paketa države, samo slika lika se včasih dorisuje nekoliko pozneje.';

  @override
  String get castAdd => 'Dodaj lik';

  @override
  String get castCount => 'Zasedba:';

  @override
  String get castShuffleAll => 'Premešaj vse';

  @override
  String get castContinue => 'Naprej →';

  @override
  String get shuffle => 'Premešaj';

  @override
  String get motifTaskTitle => 'Katera naloga?';

  @override
  String get motifProblemTitle => 'Kateri problem?';

  @override
  String get motifEndingTitle => 'Kakšen konec?';

  @override
  String get motifTaskCaption => 'Tapni kartico in izberi junakovo nalogo.';

  @override
  String get motifProblemCaption =>
      'Tapni kartico in izberi oviro ali zlobneža.';

  @override
  String get motifEndingCaption => 'Tapni kartico in izberi srečen konec.';

  @override
  String get beatCastTitle => 'Kdo je v zgodbi';

  @override
  String get beatTaskTitle => 'Kaj si je junak zadal';

  @override
  String get beatProblemTitle => 'Kaj mu je stopilo na pot';

  @override
  String get beatEndingTitle => 'Kako se je končalo';

  @override
  String get beatCastCaption =>
      'Predstavi like: kje so, kako izgledajo, kaj je na njih posebnega.';

  @override
  String get beatTaskCaption =>
      'Povej, kaj junak želi in zakaj se je odpravil.';

  @override
  String get beatProblemCaption =>
      'Postavi mu kaj na pot. Naj se nekaj časa zdi, da ne bo šlo.';

  @override
  String get beatEndingCaption =>
      'Pripelji zgodbo do konca. Ne hiti: konec si otrok najbolj zapomni.';

  @override
  String get hintHero => 'junak';

  @override
  String hintCast1(String who) {
    return 'Kako izgleda «$who», ko se prvič pojavi?';
  }

  @override
  String hintCast2(String who) {
    return 'Kaj počne «$who» tik preden se začne cela zgodba?';
  }

  @override
  String hintCast3(String who) {
    return 'Česa se boji «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Po čem prepoznaš, da prihaja «$who»?';
  }

  @override
  String get hintCast5 => 'Kdo od njih se pozna že dolgo in od kod?';

  @override
  String get hintCast6 => 'Kakšno je vreme, ko se srečajo?';

  @override
  String hintCast7(String who) {
    return 'Kaj ima «$who» v žepu?';
  }

  @override
  String hintTask1(String who) {
    return 'Kdaj «$who» spozna, da se mora lotiti dela?';
  }

  @override
  String hintTask2(String who) {
    return 'Kdo je svetoval in zakaj ga «$who» posluša?';
  }

  @override
  String hintTask3(String who) {
    return 'Kaj mora «$who» pustiti doma?';
  }

  @override
  String get hintTask4 => 'Kako dolga je pot in čez kaj vodi?';

  @override
  String hintTask5(String who) {
    return 'Kaj si obljubi «$who», preden odide?';
  }

  @override
  String get hintTask6 => 'Zakaj tega ne more storiti nihče drug?';

  @override
  String get hintProblem1 => 'V tistem trenutku se zasliši zvok, kakšen?';

  @override
  String get hintProblem2 => 'Kaj se najprej pokvari?';

  @override
  String hintProblem3(String who) {
    return 'Kaj najprej poskusi «$who» in zakaj ne uspe?';
  }

  @override
  String get hintProblem4 => 'Kdo noče pomagati, čeprav bi lahko?';

  @override
  String get hintProblem5 => 'Kaj bi se zgodilo, če bi zdaj vsi obupali?';

  @override
  String get hintProblem6 => 'Je na tej oviri kaj žalostnega?';

  @override
  String hintProblem7(String who) {
    return 'Kaj «$who» v tistem trenutku reče na glas?';
  }

  @override
  String hintEnding1(String who) {
    return 'S čim «$who» na koncu premaga oviro: s silo ali z idejo?';
  }

  @override
  String get hintEnding2 => 'Kdo pomaga, čeprav ne bi bilo treba?';

  @override
  String hintEnding3(String who) {
    return 'Kaj stori «$who» čisto prvo, ko je vsega konec?';
  }

  @override
  String get hintEnding4 => 'Kaj je na koncu drugače kot na začetku?';

  @override
  String hintEnding5(String who) {
    return 'Kam se vrne «$who» in kdo ga tam čaka?';
  }

  @override
  String get hintEnding6 => 'Kateri je zadnji stavek, preden se prižge luč?';

  @override
  String get globeLoading => 'Pripravljam planet…';

  @override
  String get globeLoadFailed => 'Planeta ni bilo mogoče naložiti.';

  @override
  String get globeTitle => 'Od kod naj bo pravljica?';

  @override
  String get globeStored => 'Prenesene pravljice';

  @override
  String get globeHintFar =>
      'Zavrti planet ali tapni državo. Zelene države že imajo pravljice iz naše zbirke, sive še ne.';

  @override
  String get globeHintNear =>
      'Tapni državo ali zgradbo. Zelene države že imajo pravljice iz naše zbirke, sive še ne.';

  @override
  String get globeWhole => 'Celoten planet';

  @override
  String get globeZoomIn => 'Povečaj';

  @override
  String get globeZoomOut => 'Pomanjšaj';

  @override
  String globeZoomToRegion(String name) {
    return 'Približaj: $name →';
  }

  @override
  String get globeTellHere => 'Povej pravljico od tod';

  @override
  String globeTellFrom(String place) {
    return 'Povej pravljico: $place →';
  }

  @override
  String get globeOpenSea => 'Odprto morje';

  @override
  String globeRegionCountries(int n) {
    return '$n držav skupaj. Približaj in izberi eno.';
  }

  @override
  String get globeTurnToCountry => 'Obrni planet proti kateri državi.';

  @override
  String get globeSpin => 'Zavrti';

  @override
  String get globeNoTales => 'Od tod še nimamo nobene pravljice.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivov',
      few: '$n motivi',
      two: '$n motiva',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'iz $n pravljic',
      few: 'iz $n pravljic',
      two: 'iz $n pravljic',
      one: 'iz $n pravljice',
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
      other: '$n motivov iz paketa',
      few: '$n motivi iz paketa',
      two: '$n motiva iz paketa',
      one: '$n motiv iz paketa',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljico',
    );
    return 'Pripravljamo $_temp0 od tod za paket $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljica',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljica',
    );
    return '$_temp0 brezplačno';
  }

  @override
  String cardFree(int n) {
    return '$n brezplačno';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n v delih $region $range',
      one: '$n v delu $region $range',
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
      other: 'še $n pripravljamo',
      few: 'še $n pripravljamo',
      two: 'še $n pripravljamo',
      one: 'še $n pripravljamo',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Čakam na trgovino…';

  @override
  String offerDownloading(int percent) {
    return 'Prenašam pravljice… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljica',
    );
    return 'Kupi $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljica',
    );
    return 'Prenesi $name: $_temp0 brezplačno ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pravljic',
      few: '$n pravljice',
      two: '$n pravljici',
      one: '$n pravljica',
    );
    return 'Prenesi $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Prenesi $name';
  }

  @override
  String get errDownloadTales => 'Pravljic ni bilo mogoče prenesti.';

  @override
  String get errDownloadScenes => 'Slik ni bilo mogoče prenesti.';

  @override
  String get errNoDownloads => 'Prenos tu ni na voljo.';

  @override
  String get errOffline =>
      'Ni internetne povezave – poskusi znova, ko boš imel signal.';

  @override
  String get errCannotBuy => 'Tega dela trenutno ni mogoče kupiti.';

  @override
  String get buyPending =>
      'Nakup čaka na odobritev. Del se bo prenesel, ko bo odobren.';

  @override
  String get buyFailed => 'Nakup ni uspel.';

  @override
  String get restoreNone => 'Na tem računu ni nobenih nakupov.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Obnovljenih $n delov. Prenesi jih s planeta.',
      few: 'Obnovljeni $n deli. Prenesi jih s planeta.',
      two: 'Obnovljena $n dela. Prenesi ju s planeta.',
      one: 'Obnovljen $n del. Prenesi ga s planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Nakupov ni bilo mogoče obnoviti – poskusi znova, ko boš imel signal.';

  @override
  String get narrationGone => 'Ta pravljica ni več sestavljena.';

  @override
  String get narrationNew => 'Sestavi novo';

  @override
  String narrationTitle(int index, int total) {
    return 'Pripoveduješ — $index od $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Kako navezati: $bridge';
  }

  @override
  String get narrationSituation =>
      'Kaj se zdaj dogaja? (neobvezno, lahko narekuješ)';

  @override
  String get narrationHintNote =>
      'Namig — ne izgovori ga na glas, samo odbij se od njega.';

  @override
  String get narrationSoundsNote =>
      'Zvoki — predvajaj jih, ko se prilegajo pripovedi.';

  @override
  String get moodTense => 'napetost';

  @override
  String get moodCalm => 'mir';

  @override
  String get narrationSearching => 'Iščem…';

  @override
  String get narrationHint => 'Daj namig';

  @override
  String get narrationMoreHint => 'Še enega';

  @override
  String get narrationBack => 'Nazaj';

  @override
  String get narrationEnd => 'Konec';

  @override
  String get narrationNext => 'Naprej →';

  @override
  String get narrationGoodnight => 'Lahko noč.';

  @override
  String get narrationEndNote =>
      'Sklepne slike in shranjevanja v Knjižnico še ne znamo – ta pravljica nikamor ne odide, ostane med vama.';

  @override
  String get narrationClose => 'Zapri';

  @override
  String get ragFallback => 'V paketu za to še ni ničesar – splošen namig:';

  @override
  String get ragNoModel => 'Modela namigov v tej različici ni.';

  @override
  String get ragHintGeneral => 'splošen';

  @override
  String get ragHintMotif => 'k motivu';

  @override
  String get captionExact => 'ilustracija · k temu motivu';

  @override
  String get captionSimilar => 'ilustracija · podobna scena';

  @override
  String get captionCard => 'kartica motiva · za ta korak še nimamo scene';

  @override
  String get storageTitle => 'Prenesene pravljice';

  @override
  String get storageEmpty => 'Še nič – več pravljic se prenese s planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paketov',
      few: '$n paketi',
      two: '$n paketa',
      one: '$n paket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Prizori: $name';
  }

  @override
  String get storageFreeTier => 'brezplačno';

  @override
  String get storageBoughtTier => 'kupljeno';

  @override
  String get storageDelete => 'Izbriši';

  @override
  String get storageScenesSub => 'Slika ob vsakem koraku pripovedi';

  @override
  String get storageDownload => 'Prenesi';

  @override
  String get storageAllUsed => 'Vse je bilo uporabljeno v zadnjih 30 dneh.';

  @override
  String storageFreed(String size) {
    return 'Sproščeno: $size.';
  }

  @override
  String get storageFreeUp => 'Sprosti prostor (neuporabljeno 30 dni)';

  @override
  String get storageRestoring => 'Obnavljam nakupe…';

  @override
  String get storageRestore => 'Obnovi nakupe';

  @override
  String get osnovaTitle => 'Zasnova';

  @override
  String get osnovaSummary => 'Pravljica na kratko';

  @override
  String get osnovaCharacters => 'Liki';

  @override
  String get osnovaTask => 'Naloga';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Konec';

  @override
  String get osnovaAgain => 'Znova';

  @override
  String get osnovaTell => 'Pripovedujem →';

  @override
  String get outlineHero => 'Junak';

  @override
  String get castFox => 'Zvita lisica';

  @override
  String get castSmithSon => 'Kovačev sin';

  @override
  String get castMill => 'Govoreči mlin';

  @override
  String get castGooseGirl => 'Gosja pastirica';

  @override
  String get castBrothers => 'Trije bratje';

  @override
  String get castClockworkPrincess => 'Urarjeva princesa';

  @override
  String get castOwl => 'Modra sova';

  @override
  String get castBlacksmith => 'Stara kovačica';

  @override
  String get castDragon => 'Mali zmaj';

  @override
  String get castWaterSprite => 'Povodni mož';

  @override
  String get castFourPrincesses => 'Štiri princese';

  @override
  String get castTravelingTailor => 'Potujoči krojač';

  @override
  String get castTalkingCat => 'Govoreči maček';

  @override
  String get castForestHermit => 'Gozdni puščavnik';

  @override
  String get castC0AndersenTheShadow => 'Gospod, ki je bil nekoč senca';

  @override
  String get castC1GrimmTheGooseGirl => 'Izdajalska dvorna dama';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kralj s strašljivim gradom';

  @override
  String get castC3AndersenTheShadow => 'Zvita senca';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Lepa, a ne preveč pametna princesa';

  @override
  String get castC5AndersenTheRedShoes => 'Angel, ki na koncu odpusti';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mlinarjeva pametna hči';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Babica, ki odpre vrata';

  @override
  String get castC8PerraultLittleThumb => 'Mati med revščino in ljubeznijo';

  @override
  String get castC9PerraultIntroduction => 'Potrpežljiva ženska';

  @override
  String get castC10AndersenTheRealPrincess => 'Kralj, ki podpre sina';

  @override
  String get castC11GrimmLilyAndTheLion => 'Hči, ki drži besedo';

  @override
  String get castC12AndersenTheRealPrincess => 'Princ išče pravo princeso';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Deklica z vžigalicami';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Dvorjan, ki molči';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Zvesti služabnik pripravlja pojedino';

  @override
  String get castC16PerraultTheFairy => 'Domišljava hči';

  @override
  String get castC17GrimmFirstStory => 'Vdova, ki hoče devet repov';

  @override
  String get motifTaskWine => 'Kdo bo izpil klet vina';

  @override
  String get motifTaskDiamonds => 'Let po diamante';

  @override
  String get motifTaskRingDuck => 'Prstan v raci';

  @override
  String get motifTaskGiants => 'Prelisičiti velikane';

  @override
  String get motifTaskTomThumb => 'Palčkov beg';

  @override
  String get motifTaskSwineherd => 'Osvojiti srce princese';

  @override
  String get motifTaskBell => 'Skrivnostni zvon v gozdu';

  @override
  String get motifTaskGoldenObject => 'Dar, ki ga ne smeš zlorabiti';

  @override
  String get motifTaskPebbles => 'Pot iz kamenčkov';

  @override
  String get motifProblemFoxPride => 'Lisičji napuh';

  @override
  String get motifProblemLazySister => 'Lena sestra';

  @override
  String get motifProblemWitchBoots => 'Čarovnica v sedemmiljskih čevljih';

  @override
  String get motifProblemTailorDoubt => 'Nihče mu ne verjame';

  @override
  String get motifProblemLions => 'Lačni levi pri vratih';

  @override
  String get motifProblemEagle => 'Orel in škrat';

  @override
  String get motifProblemTruth => 'Čarobna žival razkrije resnico';

  @override
  String get motifProblemOldHouse => 'Nihče noče stare hiše';

  @override
  String get motifProblemBreadcrumbs => 'Ptice so pojedle drobtinice';

  @override
  String get motifEndingTrickWins => 'Zmaga zvitost';

  @override
  String get motifEndingTruthChild => 'Otrok pove resnico';

  @override
  String get motifEndingNewHome => 'Nov dom, stari prijatelji';

  @override
  String get motifEndingHappyTogether => 'Srečni skupaj za vedno';

  @override
  String get motifEndingKissWakes => 'Poljub prebudi kraljestvo';

  @override
  String get motifEndingLeapfrog => 'Zvitost skoči najvišje';

  @override
  String get motifEndingCurseBroken => 'Prekletstvo je razbito';

  @override
  String get motifEndingWelcomedHome => 'Dobrodošlica doma';

  @override
  String get motifEndingSlipper => 'Izgubljeni čeveljc';
}
