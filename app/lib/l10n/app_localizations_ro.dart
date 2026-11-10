// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Romanian Moldavian Moldovan (`ro`).
class AppLocalizationsRo extends AppLocalizations {
  AppLocalizationsRo([String locale = 'ro']) : super(locale);

  @override
  String get castTitle => 'Cine va fi în poveste?';

  @override
  String get castHint =>
      'Atinge o carte pentru alt personaj. Șterge cartea cu crucea. Muzica și sunetele sunt mereu gata din pachetul țării; doar imaginea personajului este uneori desenată puțin mai târziu.';

  @override
  String get castAdd => 'Adaugă un personaj';

  @override
  String get castCount => 'Distribuția:';

  @override
  String get castShuffleAll => 'Amestecă tot';

  @override
  String get castContinue => 'Continuă →';

  @override
  String get shuffle => 'Amestecă';

  @override
  String get motifTaskTitle => 'Ce misiune?';

  @override
  String get motifProblemTitle => 'Ce problemă?';

  @override
  String get motifEndingTitle => 'Ce final?';

  @override
  String get motifTaskCaption => 'Atinge o carte ca să alegi misiunea eroului.';

  @override
  String get motifProblemCaption =>
      'Atinge o carte ca să alegi un obstacol sau un răufăcător.';

  @override
  String get motifEndingCaption =>
      'Atinge o carte ca să alegi un final fericit.';

  @override
  String get beatCastTitle => 'Cine este în poveste';

  @override
  String get beatTaskTitle => 'Ce și-a propus eroul';

  @override
  String get beatProblemTitle => 'Ce i s-a pus în cale';

  @override
  String get beatEndingTitle => 'Cum s-a terminat';

  @override
  String get beatCastCaption =>
      'Prezintă personajele: unde sunt, cum arată, ce au deosebit.';

  @override
  String get beatTaskCaption =>
      'Spune ce vrea eroul și de ce a pornit la drum.';

  @override
  String get beatProblemCaption =>
      'Pune ceva în calea lui. Să pară o vreme că nu va reuși.';

  @override
  String get beatEndingCaption =>
      'Du povestea până la capăt. Fără grabă: finalul este ce își amintește cel mai bine un copil.';

  @override
  String get hintHero => 'eroul';

  @override
  String hintCast1(String who) {
    return 'Cum arată «$who» când apare prima dată?';
  }

  @override
  String hintCast2(String who) {
    return 'Ce face «$who» chiar înainte să înceapă toată povestea?';
  }

  @override
  String hintCast3(String who) {
    return 'De ce se teme «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Cum îți dai seama că vine «$who»?';
  }

  @override
  String get hintCast5 => 'Care dintre ei se cunosc de multă vreme și de unde?';

  @override
  String get hintCast6 => 'Cum e vremea când se întâlnesc?';

  @override
  String hintCast7(String who) {
    return 'Ce are «$who» în buzunar?';
  }

  @override
  String hintTask1(String who) {
    return 'Când înțelege «$who» că trebuie să se apuce de treabă?';
  }

  @override
  String hintTask2(String who) {
    return 'Cine a dat sfatul și de ce îl ascultă «$who»?';
  }

  @override
  String hintTask3(String who) {
    return 'Ce trebuie să lase acasă «$who»?';
  }

  @override
  String get hintTask4 => 'Cât de lung e drumul și peste ce duce?';

  @override
  String hintTask5(String who) {
    return 'Ce își promite «$who» înainte să plece?';
  }

  @override
  String get hintTask6 => 'De ce nu poate face altcineva asta?';

  @override
  String get hintProblem1 =>
      'În clipa aceea se aude un sunet. Ce fel de sunet?';

  @override
  String get hintProblem2 => 'Ce merge prost mai întâi?';

  @override
  String hintProblem3(String who) {
    return 'Ce încearcă «$who» mai întâi și de ce nu merge?';
  }

  @override
  String get hintProblem4 => 'Cine refuză să ajute, deși ar putea?';

  @override
  String get hintProblem5 =>
      'Ce s-ar întâmpla dacă toți ar renunța chiar acum?';

  @override
  String get hintProblem6 => 'E ceva trist în obstacolul acesta?';

  @override
  String hintProblem7(String who) {
    return 'Ce spune «$who» cu voce tare în clipa aceea?';
  }

  @override
  String hintEnding1(String who) {
    return 'Cu ce învinge «$who» până la urmă: cu forța sau cu o idee?';
  }

  @override
  String get hintEnding2 => 'Cine ajută, deși nu era obligat?';

  @override
  String hintEnding3(String who) {
    return 'Ce face «$who» mai întâi, când totul s-a terminat?';
  }

  @override
  String get hintEnding4 => 'Ce e diferit la sfârșit față de început?';

  @override
  String hintEnding5(String who) {
    return 'Unde se întoarce «$who» și cine îl așteaptă acolo?';
  }

  @override
  String get hintEnding6 => 'Care e ultima frază înainte să se aprindă lumina?';

  @override
  String get globeLoading => 'Pregătesc planeta…';

  @override
  String get globeLoadFailed => 'Planeta nu a putut fi încărcată.';

  @override
  String get globeTitle => 'De unde să fie povestea?';

  @override
  String get globeStored => 'Povești descărcate';

  @override
  String get globeHintFar =>
      'Rotește planeta sau atinge o țară. Țările verzi au deja povești din colecția noastră, cele gri încă nu.';

  @override
  String get globeHintNear =>
      'Atinge o țară sau o clădire. Țările verzi au deja povești din colecția noastră, cele gri încă nu.';

  @override
  String get globeWhole => 'Toată planeta';

  @override
  String get globeZoomIn => 'Apropie';

  @override
  String get globeZoomOut => 'Depărtează';

  @override
  String globeZoomToRegion(String name) {
    return 'Apropie: $name →';
  }

  @override
  String get globeTellHere => 'Spune o poveste de aici';

  @override
  String globeTellFrom(String place) {
    return 'Spune o poveste din $place →';
  }

  @override
  String get globeOpenSea => 'Mare deschisă';

  @override
  String globeRegionCountries(int n) {
    return '$n țări împreună. Apropie și alege una.';
  }

  @override
  String get globeTurnToCountry => 'Întoarce planeta spre o țară.';

  @override
  String get globeSpin => 'Rotește';

  @override
  String get globeNoTales => 'De aici nu avem încă nicio poveste.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de motive',
      few: '$n motive',
      one: '$n motiv',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'din $n de povești',
      few: 'din $n povești',
      one: 'din $n poveste',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs din pachet';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de motive din pachet',
      few: '$n motive din pachet',
      one: '$n motiv din pachet',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return 'Pregătim $_temp0 de aici pentru pachetul $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return '$_temp0 gratis';
  }

  @override
  String cardFree(int n) {
    return '$n gratis';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n în părțile $region $range',
      one: '$n în partea $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'ai $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'încă $n pe drum',
      few: 'încă $n pe drum',
      one: 'încă $n pe drum',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Aștept magazinul…';

  @override
  String offerDownloading(int percent) {
    return 'Se descarcă poveștile… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return 'Cumpără $name: $_temp0 cu $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return 'Descarcă $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de povești',
      few: '$n povești',
      one: '$n poveste',
    );
    return 'Descarcă $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Descarcă $name';
  }

  @override
  String get errDownloadTales => 'Poveștile nu au putut fi descărcate.';

  @override
  String get errDownloadScenes => 'Imaginile nu au putut fi descărcate.';

  @override
  String get errNoDownloads => 'Descărcarea nu este disponibilă aici.';

  @override
  String get errOffline =>
      'Nu există conexiune la internet — încearcă din nou când ai semnal.';

  @override
  String get errCannotBuy => 'Această parte nu poate fi cumpărată acum.';

  @override
  String get buyPending =>
      'Achiziția așteaptă aprobare. Partea va fi descărcată după ce e aprobată.';

  @override
  String get buyFailed => 'Achiziția nu s-a încheiat.';

  @override
  String get restoreNone => 'Acest cont nu are nicio achiziție.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de părți restaurate. Le poți descărca de pe planetă.',
      few: '$n părți restaurate. Le poți descărca de pe planetă.',
      one: '$n parte restaurată. O poți descărca de pe planetă.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Achizițiile nu au putut fi restaurate — încearcă din nou când ai semnal.';

  @override
  String get narrationGone => 'Povestea aceasta nu mai este alcătuită.';

  @override
  String get narrationNew => 'Alcătuiește una nouă';

  @override
  String narrationTitle(int index, int total) {
    return 'Povestești — $index din $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Cum legi: $bridge';
  }

  @override
  String get narrationSituation =>
      'Ce se întâmplă acum? (opțional, poți dicta)';

  @override
  String get narrationHintNote =>
      'Indiciu — nu-l citi cu voce tare, folosește-l doar ca punct de plecare.';

  @override
  String get narrationSoundsNote =>
      'Sunete — pune-le când se potrivesc cu povestea.';

  @override
  String get moodTense => 'tensiune';

  @override
  String get moodCalm => 'liniște';

  @override
  String get narrationSearching => 'Caut…';

  @override
  String get narrationHint => 'Dă-mi un indiciu';

  @override
  String get narrationMoreHint => 'Încă unul';

  @override
  String get narrationBack => 'Înapoi';

  @override
  String get narrationEnd => 'Sfârșit';

  @override
  String get narrationNext => 'Mai departe →';

  @override
  String get narrationGoodnight => 'Noapte bună.';

  @override
  String get narrationEndNote =>
      'Încă nu știm să facem o imagine de final și nici să salvăm în Bibliotecă — povestea aceasta nu pleacă nicăieri, rămâne între voi.';

  @override
  String get narrationClose => 'Închide';

  @override
  String get ragFallback =>
      'Din pachet nu e încă nimic pentru asta; un indiciu general:';

  @override
  String get ragNoModel => 'Modelul de indicii nu este în această versiune.';

  @override
  String get ragHintGeneral => 'general';

  @override
  String get ragHintMotif => 'pentru motiv';

  @override
  String get captionExact => 'ilustrație · pentru acest motiv';

  @override
  String get captionSimilar => 'ilustrație · scenă asemănătoare';

  @override
  String get captionCard =>
      'cartea motivului · pentru acest pas nu avem încă o scenă';

  @override
  String get storageTitle => 'Povești descărcate';

  @override
  String get storageEmpty =>
      'Încă nimic — mai multe povești se descarcă de pe planetă.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n de pachete',
      few: '$n pachete',
      one: '$n pachet',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scene $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'cumpărat';

  @override
  String get storageDelete => 'Șterge';

  @override
  String get storageScenesSub => 'O imagine pentru fiecare pas al povestirii';

  @override
  String get storageDownload => 'Descarcă';

  @override
  String get storageAllUsed => 'Totul a fost folosit în ultimele 30 de zile.';

  @override
  String storageFreed(String size) {
    return '$size eliberați.';
  }

  @override
  String get storageFreeUp => 'Eliberează spațiu (nefolosit 30 de zile)';

  @override
  String get storageRestoring => 'Se restaurează achizițiile…';

  @override
  String get storageRestore => 'Restaurează achizițiile';

  @override
  String get osnovaTitle => 'Schiță';

  @override
  String get osnovaSummary => 'Povestea pe scurt';

  @override
  String get osnovaCharacters => 'Personaje';

  @override
  String get osnovaTask => 'Misiune';

  @override
  String get osnovaProblem => 'Problemă';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'De la capăt';

  @override
  String get osnovaTell => 'Povestesc →';

  @override
  String get outlineHero => 'Eroul';

  @override
  String get castFox => 'Vulpea isteață';

  @override
  String get castSmithSon => 'Fiul fierarului';

  @override
  String get castMill => 'Moara care vorbește';

  @override
  String get castGooseGirl => 'Păstorița de gâște';

  @override
  String get castBrothers => 'Cei trei frați';

  @override
  String get castClockworkPrincess => 'Prințesa ceasornicarului';

  @override
  String get castOwl => 'Bufnița înțeleaptă';

  @override
  String get castBlacksmith => 'Fierăreasa bătrână';

  @override
  String get castDragon => 'Micul dragon';

  @override
  String get castWaterSprite => 'Spiridușul apei';

  @override
  String get castFourPrincesses => 'Cele patru prințese';

  @override
  String get castTravelingTailor => 'Croitorul rătăcitor';

  @override
  String get castTalkingCat => 'Pisoiul care vorbește';

  @override
  String get castForestHermit => 'Pustnicul din pădure';

  @override
  String get castC0AndersenTheShadow => 'Domnul care a fost cândva o umbră';

  @override
  String get castC1GrimmTheGooseGirl => 'Cameristă trădătoare';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Regele cu castelul bântuit';

  @override
  String get castC3AndersenTheShadow => 'Umbra isteață';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Prințesa frumoasă, dar nu prea isteață';

  @override
  String get castC5AndersenTheRedShoes => 'Îngerul care iartă la sfârșit';

  @override
  String get castC6GrimmRumpelstiltskin => 'Fiica isteață a morarului';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Bunica ce deschide ușa';

  @override
  String get castC8PerraultLittleThumb => 'O mamă între sărăcie și iubire';

  @override
  String get castC9PerraultIntroduction => 'Femeia răbdătoare';

  @override
  String get castC10AndersenTheRealPrincess => 'Regele care își sprijină fiul';

  @override
  String get castC11GrimmLilyAndTheLion => 'Fiica ce-și ține cuvântul';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Prințul care caută adevărata prințesă';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Fetița cu chibrituri';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Curteanul care tace';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Servitorul credincios pregătește un ospăț';

  @override
  String get castC16PerraultTheFairy => 'Fiica îngâmfată';

  @override
  String get castC17GrimmFirstStory => 'Văduva care vrea nouă cozi';

  @override
  String get motifTaskWine => 'Cine va bea o pivniță de vin';

  @override
  String get motifTaskDiamonds => 'Un zbor după diamante';

  @override
  String get motifTaskRingDuck => 'Inelul din rață';

  @override
  String get motifTaskGiants => 'Păcălirea uriașilor';

  @override
  String get motifTaskTomThumb => 'Fuga lui Degețel';

  @override
  String get motifTaskSwineherd => 'Cucerirea inimii prințesei';

  @override
  String get motifTaskBell => 'Clopotul misterios din pădure';

  @override
  String get motifTaskGoldenObject => 'Un dar de care nu e voie să abuzezi';

  @override
  String get motifTaskPebbles => 'O cărare de pietricele';

  @override
  String get motifProblemFoxPride => 'Mândria vulpii';

  @override
  String get motifProblemLazySister => 'Sora leneșă';

  @override
  String get motifProblemWitchBoots => 'Vrăjitoarea cu cizme de șapte poște';

  @override
  String get motifProblemTailorDoubt => 'Nimeni nu-l crede';

  @override
  String get motifProblemLions => 'Lei flămânzi la poartă';

  @override
  String get motifProblemEagle => 'Vulturul și piticul';

  @override
  String get motifProblemTruth => 'Animalul fermecat dezvăluie adevărul';

  @override
  String get motifProblemOldHouse => 'Nimeni nu vrea casa veche';

  @override
  String get motifProblemBreadcrumbs => 'Păsările au mâncat firimiturile';

  @override
  String get motifEndingTrickWins => 'Șiretenia învinge';

  @override
  String get motifEndingTruthChild => 'Copilul spune adevărul';

  @override
  String get motifEndingNewHome => 'O casă nouă, prieteni vechi';

  @override
  String get motifEndingHappyTogether => 'Fericiți împreună pentru totdeauna';

  @override
  String get motifEndingKissWakes => 'Un sărut trezește regatul';

  @override
  String get motifEndingLeapfrog => 'Șiretenia sare cel mai sus';

  @override
  String get motifEndingCurseBroken => 'Blestemul s-a rupt';

  @override
  String get motifEndingWelcomedHome => 'Primit cu bine acasă';

  @override
  String get motifEndingSlipper => 'Pantofiorul pierdut';
}
