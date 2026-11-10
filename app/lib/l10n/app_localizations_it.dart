// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Italian (`it`).
class AppLocalizationsIt extends AppLocalizations {
  AppLocalizationsIt([String locale = 'it']) : super(locale);

  @override
  String get castTitle => 'Chi ci sarà nella fiaba?';

  @override
  String get castHint =>
      'Tocca una carta per avere un altro personaggio. Elimina la carta con la croce. Musica e suoni sono sempre pronti dal pacchetto del paese; solo l’immagine del personaggio a volte viene disegnata un attimo dopo.';

  @override
  String get castAdd => 'Aggiungi personaggio';

  @override
  String get castCount => 'Cast:';

  @override
  String get castShuffleAll => 'Mescola tutto';

  @override
  String get castContinue => 'Continua →';

  @override
  String get shuffle => 'Mescola';

  @override
  String get motifTaskTitle => 'Quale compito?';

  @override
  String get motifProblemTitle => 'Quale problema?';

  @override
  String get motifEndingTitle => 'Quale finale?';

  @override
  String get motifTaskCaption =>
      'Tocca una carta per scegliere il compito dell’eroe.';

  @override
  String get motifProblemCaption =>
      'Tocca una carta per scegliere un ostacolo o un cattivo.';

  @override
  String get motifEndingCaption =>
      'Tocca una carta per scegliere un lieto fine.';

  @override
  String get beatCastTitle => 'Chi c’è';

  @override
  String get beatTaskTitle => 'Cosa si è proposto l’eroe';

  @override
  String get beatProblemTitle => 'Cosa gli si è parato davanti';

  @override
  String get beatEndingTitle => 'Com’è andata a finire';

  @override
  String get beatCastCaption =>
      'Presenta i personaggi: dove sono, che aspetto hanno, cosa hanno di particolare.';

  @override
  String get beatTaskCaption =>
      'Di’ cosa vuole l’eroe e perché si è messo in cammino.';

  @override
  String get beatProblemCaption =>
      'Mettigli qualcosa sulla strada. Per un po’ deve sembrare che non ce la farà.';

  @override
  String get beatEndingCaption =>
      'Portala fino in fondo. Senza fretta: il finale è ciò che un bambino ricorda di più.';

  @override
  String get hintHero => 'l’eroe';

  @override
  String hintCast1(String who) {
    return 'Com’è «$who» la prima volta che appare?';
  }

  @override
  String hintCast2(String who) {
    return 'Cosa sta facendo «$who» poco prima che tutta la storia cominci?';
  }

  @override
  String hintCast3(String who) {
    return 'Di cosa ha paura «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Da cosa capisci che sta arrivando «$who»?';
  }

  @override
  String get hintCast5 => 'Chi di loro si conosce da tempo, e da dove?';

  @override
  String get hintCast6 => 'Che tempo fa quando si incontrano?';

  @override
  String hintCast7(String who) {
    return 'Cosa ha in tasca «$who»?';
  }

  @override
  String hintTask1(String who) {
    return 'Quando capisce «$who» che deve mettersi all’opera?';
  }

  @override
  String hintTask2(String who) {
    return 'Chi ha dato il consiglio e perché «$who» lo ascolta?';
  }

  @override
  String hintTask3(String who) {
    return 'Cosa deve lasciare a casa «$who»?';
  }

  @override
  String get hintTask4 => 'Quanto è lunga la strada e cosa attraversa?';

  @override
  String hintTask5(String who) {
    return 'Cosa si promette «$who» prima di partire?';
  }

  @override
  String get hintTask6 => 'Perché non può farlo qualcun altro?';

  @override
  String get hintProblem1 => 'In quel momento si sente un suono: quale?';

  @override
  String get hintProblem2 => 'Cosa va storto per primo?';

  @override
  String hintProblem3(String who) {
    return 'Cosa prova per prima «$who» e perché non funziona?';
  }

  @override
  String get hintProblem4 => 'Chi si rifiuta di aiutare anche se potrebbe?';

  @override
  String get hintProblem5 => 'Cosa succederebbe se ora tutti si arrendessero?';

  @override
  String get hintProblem6 => 'C’è qualcosa di triste in quell’ostacolo?';

  @override
  String hintProblem7(String who) {
    return 'Cosa dice ad alta voce «$who» in quel momento?';
  }

  @override
  String hintEnding1(String who) {
    return 'Con cosa lo supera alla fine «$who»: con la forza o con un’idea?';
  }

  @override
  String get hintEnding2 => 'Chi aiuta anche se non era obbligato?';

  @override
  String hintEnding3(String who) {
    return 'Cosa fa per prima cosa «$who» quando tutto è finito?';
  }

  @override
  String get hintEnding4 =>
      'Cosa c’è di diverso alla fine rispetto all’inizio?';

  @override
  String hintEnding5(String who) {
    return 'Dove torna «$who» e chi lo aspetta lì?';
  }

  @override
  String get hintEnding6 =>
      'Qual è l’ultima frase prima che si accenda la luce?';

  @override
  String get globeLoading => 'Preparo il pianeta…';

  @override
  String get globeLoadFailed => 'Impossibile caricare il pianeta.';

  @override
  String get globeTitle => 'Da dove sarà la fiaba?';

  @override
  String get globeStored => 'Fiabe scaricate';

  @override
  String get globeHintFar =>
      'Fai girare il pianeta o tocca un paese. I paesi verdi hanno già fiabe della nostra raccolta, quelli grigi ancora no.';

  @override
  String get globeHintNear =>
      'Tocca un paese o un edificio. I paesi verdi hanno già fiabe della nostra raccolta, quelli grigi ancora no.';

  @override
  String get globeWhole => 'Pianeta intero';

  @override
  String get globeZoomIn => 'Avvicina';

  @override
  String get globeZoomOut => 'Allontana';

  @override
  String globeZoomToRegion(String name) {
    return 'Avvicina $name →';
  }

  @override
  String get globeTellHere => 'Racconta una fiaba di qui';

  @override
  String globeTellFrom(String place) {
    return 'Racconta una fiaba da $place →';
  }

  @override
  String get globeOpenSea => 'Mare aperto';

  @override
  String globeRegionCountries(int n) {
    return '$n paesi insieme. Avvicinati e sceglierne uno.';
  }

  @override
  String get globeTurnToCountry => 'Gira il pianeta verso un paese.';

  @override
  String get globeSpin => 'Gira';

  @override
  String get globeNoTales => 'Da qui non abbiamo ancora nessuna fiaba.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivi',
      one: '$n motivo',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'da $n fiabe',
      one: 'da $n fiaba',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs dal pacchetto';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivi dal pacchetto',
      one: '$n motivo dal pacchetto',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
    );
    return 'Stiamo preparando $_temp0 di qui per il pacchetto $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
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
      other: '$n nelle parti $region $range',
      one: '$n nella parte $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'ne hai $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ne arrivano ancora $n',
      one: 'ne arriva ancora $n',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'In attesa dello store…';

  @override
  String offerDownloading(int percent) {
    return 'Scaricamento delle fiabe… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
    );
    return 'Acquista $name: $_temp0 a $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
    );
    return 'Scarica $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n fiabe',
      one: '$n fiaba',
    );
    return 'Scarica $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Scarica $name';
  }

  @override
  String get errDownloadTales => 'Impossibile scaricare le fiabe.';

  @override
  String get errDownloadScenes => 'Impossibile scaricare le immagini.';

  @override
  String get errNoDownloads => 'Qui il download non è disponibile.';

  @override
  String get errOffline =>
      'Nessuna connessione a internet: riprova quando avrai segnale.';

  @override
  String get errCannotBuy => 'Questa parte al momento non si può acquistare.';

  @override
  String get buyPending =>
      'L’acquisto attende l’approvazione. La parte verrà scaricata appena approvato.';

  @override
  String get buyFailed => 'L’acquisto non è andato a buon fine.';

  @override
  String get restoreNone => 'Su questo account non ci sono acquisti.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n parti ripristinate. Puoi scaricarle dal pianeta.',
      one: '$n parte ripristinata. Puoi scaricarla dal pianeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Impossibile ripristinare gli acquisti: riprova quando avrai segnale.';

  @override
  String get narrationGone => 'Questa fiaba non è più composta.';

  @override
  String get narrationNew => 'Componine una nuova';

  @override
  String narrationTitle(int index, int total) {
    return 'Racconti — $index di $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Come collegare: $bridge';
  }

  @override
  String get narrationSituation =>
      'Cosa sta succedendo ora? (facoltativo, puoi dettare)';

  @override
  String get narrationHintNote =>
      'Suggerimento: non dirlo ad alta voce, usalo solo come spunto.';

  @override
  String get narrationSoundsNote =>
      'Suoni: riproducili quando si adattano al racconto.';

  @override
  String get moodTense => 'tensione';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'Cerco…';

  @override
  String get narrationHint => 'Dammi un suggerimento';

  @override
  String get narrationMoreHint => 'Ancora uno';

  @override
  String get narrationBack => 'Indietro';

  @override
  String get narrationEnd => 'Fine';

  @override
  String get narrationNext => 'Avanti →';

  @override
  String get narrationGoodnight => 'Buonanotte.';

  @override
  String get narrationEndNote =>
      'Non sappiamo ancora fare un’immagine finale né salvare nella Biblioteca: questa fiaba non va da nessuna parte, resta tra voi.';

  @override
  String get narrationClose => 'Chiudi';

  @override
  String get ragFallback =>
      'Dal pacchetto per ora non c’è nulla su questo; un suggerimento generale:';

  @override
  String get ragNoModel =>
      'Il modello dei suggerimenti non è incluso in questa versione.';

  @override
  String get ragHintGeneral => 'generale';

  @override
  String get ragHintMotif => 'per il motivo';

  @override
  String get captionExact => 'illustrazione · per questo motivo';

  @override
  String get captionSimilar => 'illustrazione · scena simile';

  @override
  String get captionCard =>
      'carta del motivo · per questo passaggio non abbiamo ancora una scena';

  @override
  String get storageTitle => 'Fiabe scaricate';

  @override
  String get storageEmpty =>
      'Ancora niente: altre fiabe si scaricano dal pianeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pacchetti',
      one: '$n pacchetto',
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
  String get storageBoughtTier => 'acquistato';

  @override
  String get storageDelete => 'Elimina';

  @override
  String get storageScenesSub => 'Un’immagine per ogni passaggio del racconto';

  @override
  String get storageDownload => 'Scarica';

  @override
  String get storageAllUsed => 'Tutto è stato usato negli ultimi 30 giorni.';

  @override
  String storageFreed(String size) {
    return 'Liberati $size.';
  }

  @override
  String get storageFreeUp => 'Libera spazio (non usato da 30 giorni)';

  @override
  String get storageRestoring => 'Ripristino degli acquisti…';

  @override
  String get storageRestore => 'Ripristina acquisti';

  @override
  String get osnovaTitle => 'Traccia';

  @override
  String get osnovaSummary => 'La fiaba in breve';

  @override
  String get osnovaCharacters => 'Personaggi';

  @override
  String get osnovaTask => 'Compito';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Finale';

  @override
  String get osnovaAgain => 'Ricomincia';

  @override
  String get osnovaTell => 'Racconto →';

  @override
  String get outlineHero => 'L’eroe';

  @override
  String get castFox => 'La volpe astuta';

  @override
  String get castSmithSon => 'Il figlio del fabbro';

  @override
  String get castMill => 'Il mulino parlante';

  @override
  String get castGooseGirl => 'La guardiana delle oche';

  @override
  String get castBrothers => 'I tre fratelli';

  @override
  String get castClockworkPrincess => 'La principessa orologiaia';

  @override
  String get castOwl => 'Il saggio gufo';

  @override
  String get castBlacksmith => 'La vecchia fabbra';

  @override
  String get castDragon => 'Il piccolo drago';

  @override
  String get castWaterSprite => 'Lo spirito dell’acqua';

  @override
  String get castFourPrincesses => 'Le quattro principesse';

  @override
  String get castTravelingTailor => 'Il sarto vagabondo';

  @override
  String get castTalkingCat => 'Il gatto parlante';

  @override
  String get castForestHermit => 'L’eremita del bosco';

  @override
  String get castC0AndersenTheShadow => 'Il signore che era stato un’ombra';

  @override
  String get castC1GrimmTheGooseGirl => 'La cameriera traditrice';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Il re dal castello infestato';

  @override
  String get castC3AndersenTheShadow => 'L’ombra astuta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'La principessa bella ma poco furba';

  @override
  String get castC5AndersenTheRedShoes => 'L’angelo che alla fine perdona';

  @override
  String get castC6GrimmRumpelstiltskin => 'La figlia astuta del mugnaio';

  @override
  String get castC7PerraultLittleRedRidingHood => 'La nonna che apre la porta';

  @override
  String get castC8PerraultLittleThumb => 'Una madre tra miseria e amore';

  @override
  String get castC9PerraultIntroduction => 'La donna paziente';

  @override
  String get castC10AndersenTheRealPrincess => 'Il re che sostiene il figlio';

  @override
  String get castC11GrimmLilyAndTheLion => 'La figlia che mantiene la parola';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Il principe che cerca la vera principessa';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'La piccola fiammiferaia';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Il cortigiano che tace';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Il servo fedele prepara un banchetto';

  @override
  String get castC16PerraultTheFairy => 'La figlia presuntuosa';

  @override
  String get castC17GrimmFirstStory => 'La vedova che vuole nove code';

  @override
  String get motifTaskWine => 'Chi berrà una cantina di vino';

  @override
  String get motifTaskDiamonds => 'Un volo per i diamanti';

  @override
  String get motifTaskRingDuck => 'L’anello nell’anatra';

  @override
  String get motifTaskGiants => 'Ingannare i giganti';

  @override
  String get motifTaskTomThumb => 'La fuga di Pollicino';

  @override
  String get motifTaskSwineherd => 'Conquistare il cuore della principessa';

  @override
  String get motifTaskBell => 'La misteriosa campana nel bosco';

  @override
  String get motifTaskGoldenObject => 'Un dono da non usare male';

  @override
  String get motifTaskPebbles => 'Un sentiero di sassolini';

  @override
  String get motifProblemFoxPride => 'L’orgoglio della volpe';

  @override
  String get motifProblemLazySister => 'La sorella pigra';

  @override
  String get motifProblemWitchBoots =>
      'La strega con gli stivali delle sette leghe';

  @override
  String get motifProblemTailorDoubt => 'Nessuno gli crede';

  @override
  String get motifProblemLions => 'Leoni affamati al cancello';

  @override
  String get motifProblemEagle => 'L’aquila e il nano';

  @override
  String get motifProblemTruth => 'L’animale magico rivela la verità';

  @override
  String get motifProblemOldHouse => 'Nessuno vuole la vecchia casa';

  @override
  String get motifProblemBreadcrumbs =>
      'Gli uccelli hanno mangiato le briciole';

  @override
  String get motifEndingTrickWins => 'Vince l’astuzia';

  @override
  String get motifEndingTruthChild => 'Il bambino dice la verità';

  @override
  String get motifEndingNewHome => 'Una nuova casa, vecchi amici';

  @override
  String get motifEndingHappyTogether => 'Felici insieme per sempre';

  @override
  String get motifEndingKissWakes => 'Un bacio risveglia il regno';

  @override
  String get motifEndingLeapfrog => 'L’astuzia salta più in alto';

  @override
  String get motifEndingCurseBroken => 'La maledizione è spezzata';

  @override
  String get motifEndingWelcomedHome => 'Accolto a casa';

  @override
  String get motifEndingSlipper => 'La scarpetta perduta';
}
