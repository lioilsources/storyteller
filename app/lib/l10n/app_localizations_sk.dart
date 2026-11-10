// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Slovak (`sk`).
class AppLocalizationsSk extends AppLocalizations {
  AppLocalizationsSk([String locale = 'sk']) : super(locale);

  @override
  String get castTitle => 'Kto bude v rozprávke?';

  @override
  String get castHint =>
      'Ťukni na kartu a dostaneš inú postavu. Kartu zmažeš krížikom. Hudba a zvuky sú vždy hotové z balíčka krajiny, len obrázok postavy sa niekedy dokreslí o chvíľu neskôr.';

  @override
  String get castAdd => 'Pridať postavu';

  @override
  String get castCount => 'Obsadenie:';

  @override
  String get castShuffleAll => 'Zamiešať všetko';

  @override
  String get castContinue => 'Pokračovať →';

  @override
  String get shuffle => 'Zamiešať';

  @override
  String get motifTaskTitle => 'Aká úloha?';

  @override
  String get motifProblemTitle => 'Aký problém?';

  @override
  String get motifEndingTitle => 'Aký koniec?';

  @override
  String get motifTaskCaption => 'Ťukni na kartu a vyber úlohu pre hrdinu.';

  @override
  String get motifProblemCaption =>
      'Ťukni na kartu a vyber prekážku alebo záporáka.';

  @override
  String get motifEndingCaption => 'Ťukni na kartu a vyber šťastný koniec.';

  @override
  String get beatCastTitle => 'Kto v tom bude';

  @override
  String get beatTaskTitle => 'Čo si hrdina predsavzal';

  @override
  String get beatProblemTitle => 'Čo sa postavilo do cesty';

  @override
  String get beatEndingTitle => 'Ako to dopadlo';

  @override
  String get beatCastCaption =>
      'Predstav postavy. Kde sú, ako vyzerajú, čo je na nich zvláštne.';

  @override
  String get beatTaskCaption =>
      'Povedz, čo hrdina chce a prečo sa vydal na cestu.';

  @override
  String get beatProblemCaption =>
      'Postav mu niečo do cesty. Nech sa chvíľu zdá, že to nepôjde.';

  @override
  String get beatEndingCaption =>
      'Doveď to do konca. Neponáhľaj sa, koniec si dieťa pamätá najviac.';

  @override
  String get hintHero => 'hrdina';

  @override
  String hintCast1(String who) {
    return 'Ako vyzerá «$who», keď sa prvýkrát objaví?';
  }

  @override
  String hintCast2(String who) {
    return 'Čo robí «$who» tesne predtým, než sa celý príbeh začne?';
  }

  @override
  String hintCast3(String who) {
    return 'Čoho sa bojí «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Podľa čoho spoznáš, že prichádza «$who»?';
  }

  @override
  String get hintCast5 => 'Kto z nich sa pozná už dávno a odkiaľ?';

  @override
  String get hintCast6 => 'Aké je počasie, keď sa stretnú?';

  @override
  String hintCast7(String who) {
    return 'Čo má «$who» vo vrecku?';
  }

  @override
  String hintTask1(String who) {
    return 'Kedy pochopí «$who», že sa do toho musí pustiť?';
  }

  @override
  String hintTask2(String who) {
    return 'Kto poradil a prečo ho «$who» poslúchne?';
  }

  @override
  String hintTask3(String who) {
    return 'Čo musí «$who» nechať doma?';
  }

  @override
  String get hintTask4 => 'Aká dlhá je cesta a cez čo vedie?';

  @override
  String hintTask5(String who) {
    return 'Čo si sľúbi «$who», než vyrazí?';
  }

  @override
  String get hintTask6 => 'Prečo to nemôže urobiť niekto iný?';

  @override
  String get hintProblem1 => 'V tej chvíli sa ozve zvuk, aký?';

  @override
  String get hintProblem2 => 'Čo sa pokazí ako prvé?';

  @override
  String hintProblem3(String who) {
    return 'Čo skúsi «$who» najprv a prečo to nevyjde?';
  }

  @override
  String get hintProblem4 => 'Kto odmietne pomôcť, hoci by mohol?';

  @override
  String get hintProblem5 => 'Čo by sa stalo, keby to teraz všetci vzdali?';

  @override
  String get hintProblem6 => 'Je na tej prekážke niečo smutné?';

  @override
  String hintProblem7(String who) {
    return 'Čo povie «$who» v tej chvíli nahlas?';
  }

  @override
  String hintEnding1(String who) {
    return 'Čím to «$who» nakoniec zlomí, silou alebo nápadom?';
  }

  @override
  String get hintEnding2 => 'Kto pomôže, hoci nemusel?';

  @override
  String hintEnding3(String who) {
    return 'Čo urobí «$who» celkom prvé, keď je po všetkom?';
  }

  @override
  String get hintEnding4 => 'Čo je na konci inak než na začiatku?';

  @override
  String hintEnding5(String who) {
    return 'Kam sa «$who» vráti a kto tam čaká?';
  }

  @override
  String get hintEnding6 => 'Aká je posledná veta, než sa rozsvieti?';

  @override
  String get globeLoading => 'Pripravujem planétu…';

  @override
  String get globeLoadFailed => 'Planétu sa nepodarilo načítať.';

  @override
  String get globeTitle => 'Odkiaľ bude rozprávka?';

  @override
  String get globeStored => 'Stiahnuté rozprávky';

  @override
  String get globeHintFar =>
      'Roztoč planétu alebo ťukni na krajinu. Zelené krajiny už majú rozprávky z našej zbierky, sivé zatiaľ nie.';

  @override
  String get globeHintNear =>
      'Ťukni na krajinu alebo na stavbu. Zelené krajiny už majú rozprávky z našej zbierky, sivé zatiaľ nie.';

  @override
  String get globeWhole => 'Celá planéta';

  @override
  String get globeZoomIn => 'Priblížiť';

  @override
  String get globeZoomOut => 'Oddialiť';

  @override
  String globeZoomToRegion(String name) {
    return 'Priblížiť: $name →';
  }

  @override
  String get globeTellHere => 'Rozprávať odtiaľto';

  @override
  String globeTellFrom(String place) {
    return 'Rozprávať: $place →';
  }

  @override
  String get globeOpenSea => 'Šíre more';

  @override
  String globeRegionCountries(int n) {
    return '$n krajín pokope. Priblíž sa a vyber jednu.';
  }

  @override
  String get globeTurnToCountry => 'Otoč planétu na nejakú krajinu.';

  @override
  String get globeSpin => 'Roztočiť';

  @override
  String get globeNoTales => 'Odtiaľto zatiaľ nemáme žiadne rozprávky.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motívov',
      few: '$n motívy',
      one: '$n motív',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'z $n rozprávok',
      few: 'z $n rozprávok',
      one: 'z $n rozprávky',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs z balíčka';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motívov z balíčka',
      few: '$n motívy z balíčka',
      one: '$n motív z balíčka',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávku',
    );
    return 'Pripravujeme $_temp0 odtiaľto do balíčka $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávka',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávka',
    );
    return '$_temp0 zadarmo';
  }

  @override
  String cardFree(int n) {
    return '$n zadarmo';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n v dieloch $region $range',
      one: '$n v dieli $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'máš $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ďalších $n sa chystá',
      few: 'ďalšie $n sa chystajú',
      one: 'ďalšia $n sa chystá',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Čakám na obchod…';

  @override
  String offerDownloading(int percent) {
    return 'Sťahujem rozprávky… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávka',
    );
    return 'Kúpiť $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávka',
    );
    return 'Stiahnuť $name: $_temp0 zadarmo ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n rozprávok',
      few: '$n rozprávky',
      one: '$n rozprávka',
    );
    return 'Stiahnuť $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Stiahnuť $name';
  }

  @override
  String get errDownloadTales => 'Rozprávky sa nepodarilo stiahnuť.';

  @override
  String get errDownloadScenes => 'Obrázky sa nepodarilo stiahnuť.';

  @override
  String get errNoDownloads => 'Sťahovanie tu nie je k dispozícii.';

  @override
  String get errOffline => 'Nie sme na internete, skús to, keď bude signál.';

  @override
  String get errCannotBuy => 'Tento diel sa teraz nedá kúpiť.';

  @override
  String get buyPending =>
      'Nákup čaká na schválenie. Diel sa stiahne, keď prejde.';

  @override
  String get buyFailed => 'Nákup sa nepodaril.';

  @override
  String get restoreNone => 'Na tomto účte nie sú žiadne nákupy.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Obnovených $n dielov. Stiahneš ich z planéty.',
      few: 'Obnovené $n diely. Stiahneš ich z planéty.',
      one: 'Obnovený $n diel. Stiahneš ho z planéty.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Nákupy sa nepodarilo obnoviť, skús to, keď bude signál.';

  @override
  String get narrationGone => 'Táto rozprávka už nie je zložená.';

  @override
  String get narrationNew => 'Zložiť novú';

  @override
  String narrationTitle(int index, int total) {
    return 'Rozprávaš — $index z $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Ako nadviazať: $bridge';
  }

  @override
  String get narrationSituation =>
      'Čo sa práve deje? (nepovinné, dá sa nadiktovať)';

  @override
  String get narrationHintNote =>
      'Nápoveda — nehovor ju nahlas, len sa od nej odraz.';

  @override
  String get narrationSoundsNote =>
      'Zvuky — pusti ich, keď sa hodia do rozprávania.';

  @override
  String get moodTense => 'napätie';

  @override
  String get moodCalm => 'pokoj';

  @override
  String get narrationSearching => 'Hľadám…';

  @override
  String get narrationHint => 'Napovedz';

  @override
  String get narrationMoreHint => 'Ešte jednu';

  @override
  String get narrationBack => 'Späť';

  @override
  String get narrationEnd => 'Koniec';

  @override
  String get narrationNext => 'Ďalej →';

  @override
  String get narrationGoodnight => 'Dobrú noc.';

  @override
  String get narrationEndNote =>
      'Záverečný obrázok a ukladanie do Knižnice zatiaľ nevieme, táto rozprávka nikam neodchádza, zostala medzi vami.';

  @override
  String get narrationClose => 'Zavrieť';

  @override
  String get ragFallback =>
      'Z balíčka k tomuto zatiaľ nič, všeobecná nápoveda:';

  @override
  String get ragNoModel => 'Model nápovedí nie je v tejto zostave.';

  @override
  String get ragHintGeneral => 'všeobecná';

  @override
  String get ragHintMotif => 'k motívu';

  @override
  String get captionExact => 'ilustrácia · k tomuto motívu';

  @override
  String get captionSimilar => 'ilustrácia · podobná scéna';

  @override
  String get captionCard => 'karta motívu · scénu k tomuto kroku zatiaľ nemáme';

  @override
  String get storageTitle => 'Stiahnuté rozprávky';

  @override
  String get storageEmpty =>
      'Zatiaľ nič, ďalšie rozprávky sa stiahnu z planéty.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n balíčkov',
      few: '$n balíčky',
      one: '$n balíček',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scény $name';
  }

  @override
  String get storageFreeTier => 'zadarmo';

  @override
  String get storageBoughtTier => 'kúpené';

  @override
  String get storageDelete => 'Zmazať';

  @override
  String get storageScenesSub => 'Obrázok ku každému kroku rozprávania';

  @override
  String get storageDownload => 'Stiahnuť';

  @override
  String get storageAllUsed => 'Všetko sa používalo za posledných 30 dní.';

  @override
  String storageFreed(String size) {
    return 'Uvoľnené $size.';
  }

  @override
  String get storageFreeUp => 'Uvoľniť miesto (nepoužité 30 dní)';

  @override
  String get storageRestoring => 'Obnovujem nákupy…';

  @override
  String get storageRestore => 'Obnoviť nákupy';

  @override
  String get osnovaTitle => 'Osnova';

  @override
  String get osnovaSummary => 'Rozprávka v kocke';

  @override
  String get osnovaCharacters => 'Postavy';

  @override
  String get osnovaTask => 'Úloha';

  @override
  String get osnovaProblem => 'Problém';

  @override
  String get osnovaEnding => 'Koniec';

  @override
  String get osnovaAgain => 'Znova';

  @override
  String get osnovaTell => 'Rozprávam →';

  @override
  String get outlineHero => 'Hrdina';

  @override
  String get castFox => 'Prefíkaná líška';

  @override
  String get castSmithSon => 'Kováčov syn';

  @override
  String get castMill => 'Hovoriaci mlyn';

  @override
  String get castGooseGirl => 'Husiarka';

  @override
  String get castBrothers => 'Traja bratia';

  @override
  String get castClockworkPrincess => 'Princezná hodinárka';

  @override
  String get castOwl => 'Múdra sova';

  @override
  String get castBlacksmith => 'Stará kováčka';

  @override
  String get castDragon => 'Malý drak';

  @override
  String get castWaterSprite => 'Vodník';

  @override
  String get castFourPrincesses => 'Štyri princezné';

  @override
  String get castTravelingTailor => 'Túlavý krajčír';

  @override
  String get castTalkingCat => 'Hovoriaci kocúr';

  @override
  String get castForestHermit => 'Lesný pustovník';

  @override
  String get castC0AndersenTheShadow => 'Pán, čo bol kedysi tieňom';

  @override
  String get castC1GrimmTheGooseGirl => 'Zradná komorná';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kráľ so strašidelným zámkom';

  @override
  String get castC3AndersenTheShadow => 'Múdry tieň';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Krásna, ale nie príliš múdra princezná';

  @override
  String get castC5AndersenTheRedShoes => 'Anjel, čo na konci odpustí';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mlynárova múdra dcéra';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Babička, čo otvorí dvere';

  @override
  String get castC8PerraultLittleThumb => 'Mama medzi biedou a láskou';

  @override
  String get castC9PerraultIntroduction => 'Trpezlivá žena';

  @override
  String get castC10AndersenTheRealPrincess => 'Kráľ, čo podporí syna';

  @override
  String get castC11GrimmLilyAndTheLion => 'Dcéra, čo drží slovo';

  @override
  String get castC12AndersenTheRealPrincess => 'Princ hľadá tú pravú princeznú';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Dievčatko so zápalkami';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Dvorán, čo mlčí';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Verný sluha chystá hostinu';

  @override
  String get castC16PerraultTheFairy => 'Domýšľavá dcéra';

  @override
  String get castC17GrimmFirstStory => 'Vdova, čo chce deväť chvostov';

  @override
  String get motifTaskWine => 'Kto vypije pivnicu vína';

  @override
  String get motifTaskDiamonds => 'Let za diamantmi';

  @override
  String get motifTaskRingDuck => 'Prsteň v kačici';

  @override
  String get motifTaskGiants => 'Prechytriť obrov';

  @override
  String get motifTaskTomThumb => 'Útek Paliačika';

  @override
  String get motifTaskSwineherd => 'Získať srdce princeznej';

  @override
  String get motifTaskBell => 'Záhadný zvon v lese';

  @override
  String get motifTaskGoldenObject => 'Dar, ktorý sa nesmie zneužiť';

  @override
  String get motifTaskPebbles => 'Chodníček z kamienkov';

  @override
  String get motifProblemFoxPride => 'Líščia pýcha';

  @override
  String get motifProblemLazySister => 'Lenivá sestra';

  @override
  String get motifProblemWitchBoots => 'Čarodejnica v sedemmíľových čižmách';

  @override
  String get motifProblemTailorDoubt => 'Nikto mu neverí';

  @override
  String get motifProblemLions => 'Hladné levy pri bráne';

  @override
  String get motifProblemEagle => 'Orol a trpaslík';

  @override
  String get motifProblemTruth => 'Čarovné zviera prezradí pravdu';

  @override
  String get motifProblemOldHouse => 'Nikto nechce starý dom';

  @override
  String get motifProblemBreadcrumbs => 'Vtáky zjedli omrvinky';

  @override
  String get motifEndingTrickWins => 'Víťazí prefíkanosť';

  @override
  String get motifEndingTruthChild => 'Dieťa povie pravdu';

  @override
  String get motifEndingNewHome => 'Nový domov, starí priatelia';

  @override
  String get motifEndingHappyTogether => 'Šťastní spolu navždy';

  @override
  String get motifEndingKissWakes => 'Bozk prebudí kráľovstvo';

  @override
  String get motifEndingLeapfrog => 'Prefíkanosť skáče najvyššie';

  @override
  String get motifEndingCurseBroken => 'Kliatba je zlomená';

  @override
  String get motifEndingWelcomedHome => 'Vítaný doma';

  @override
  String get motifEndingSlipper => 'Stratený črievičok';
}
