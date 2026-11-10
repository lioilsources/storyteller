// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String get castTitle => 'Qui sortirà al conte?';

  @override
  String get castHint =>
      'Toca una carta per canviar de personatge. Esborra la carta amb la creu. La música i els sons sempre venen ja fets del paquet del país; només la imatge del personatge de vegades es dibuixa un moment més tard.';

  @override
  String get castAdd => 'Afegeix un personatge';

  @override
  String get castCount => 'Repartiment:';

  @override
  String get castShuffleAll => 'Barreja-ho tot';

  @override
  String get castContinue => 'Continua →';

  @override
  String get shuffle => 'Barreja';

  @override
  String get motifTaskTitle => 'Quina missió?';

  @override
  String get motifProblemTitle => 'Quin problema?';

  @override
  String get motifEndingTitle => 'Quin final?';

  @override
  String get motifTaskCaption =>
      'Toca una carta per triar la missió de l’heroi.';

  @override
  String get motifProblemCaption =>
      'Toca una carta per triar un obstacle o un dolent.';

  @override
  String get motifEndingCaption => 'Toca una carta per triar un final feliç.';

  @override
  String get beatCastTitle => 'Qui hi surt';

  @override
  String get beatTaskTitle => 'Què es proposa l’heroi';

  @override
  String get beatProblemTitle => 'Què se li posa al davant';

  @override
  String get beatEndingTitle => 'Com acaba';

  @override
  String get beatCastCaption =>
      'Presenta els personatges: on són, com són, què tenen d’especial.';

  @override
  String get beatTaskCaption =>
      'Digues què vol l’heroi i per què s’hi ha posat.';

  @override
  String get beatProblemCaption =>
      'Posa-li alguna cosa al camí. Que durant una estona sembli que no se’n sortirà.';

  @override
  String get beatEndingCaption =>
      'Porta-ho fins al final. No et precipitis: el final és el que més recorda un infant.';

  @override
  String get hintHero => 'l’heroi';

  @override
  String hintCast1(String who) {
    return 'Com és «$who» quan apareix per primera vegada?';
  }

  @override
  String hintCast2(String who) {
    return 'Què fa «$who» just abans que comenci tot el conte?';
  }

  @override
  String hintCast3(String who) {
    return 'De què té por «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Com saps que arriba «$who»?';
  }

  @override
  String get hintCast5 => 'Quins d’ells es coneixen de fa temps, i d’on?';

  @override
  String get hintCast6 => 'Quin temps fa quan es troben?';

  @override
  String hintCast7(String who) {
    return 'Què porta «$who» a la butxaca?';
  }

  @override
  String hintTask1(String who) {
    return 'Quan entén «$who» que ha de posar-s’hi?';
  }

  @override
  String hintTask2(String who) {
    return 'Qui li ho va aconsellar i per què li fa cas «$who»?';
  }

  @override
  String hintTask3(String who) {
    return 'Què ha de deixar a casa «$who»?';
  }

  @override
  String get hintTask4 => 'Quant de llarg és el camí i per on passa?';

  @override
  String hintTask5(String who) {
    return 'Què es promet «$who» abans de marxar?';
  }

  @override
  String get hintTask6 => 'Per què no ho pot fer ningú més?';

  @override
  String get hintProblem1 => 'En aquell moment se sent un so: quin?';

  @override
  String get hintProblem2 => 'Què va malament primer?';

  @override
  String hintProblem3(String who) {
    return 'Què prova primer «$who» i per què no funciona?';
  }

  @override
  String get hintProblem4 => 'Qui es nega a ajudar tot i que podria?';

  @override
  String get hintProblem5 =>
      'Què passaria si tothom ho deixés córrer ara mateix?';

  @override
  String get hintProblem6 => 'Hi ha res de trist en aquest obstacle?';

  @override
  String hintProblem7(String who) {
    return 'Què diu «$who» en veu alta en aquell moment?';
  }

  @override
  String hintEnding1(String who) {
    return 'Com ho supera «$who» al final: amb força o amb enginy?';
  }

  @override
  String get hintEnding2 => 'Qui ajuda tot i que no hi estava obligat?';

  @override
  String hintEnding3(String who) {
    return 'Què fa «$who» primer de tot quan tot s’ha acabat?';
  }

  @override
  String get hintEnding4 =>
      'Què hi ha de diferent al final respecte al començament?';

  @override
  String hintEnding5(String who) {
    return 'On torna «$who» i qui l’hi espera?';
  }

  @override
  String get hintEnding6 =>
      'Quina és l’última frase abans que s’encengui la llum?';

  @override
  String get globeLoading => 'Preparo el planeta…';

  @override
  String get globeLoadFailed => 'No s’ha pogut carregar el planeta.';

  @override
  String get globeTitle => 'D’on serà el conte?';

  @override
  String get globeStored => 'Contes baixats';

  @override
  String get globeHintFar =>
      'Fes girar el planeta o toca un país. Els països verds ja tenen contes de la nostra col·lecció; els grisos, encara no.';

  @override
  String get globeHintNear =>
      'Toca un país o un edifici. Els països verds ja tenen contes de la nostra col·lecció; els grisos, encara no.';

  @override
  String get globeWhole => 'Planeta sencer';

  @override
  String get globeZoomIn => 'Apropa';

  @override
  String get globeZoomOut => 'Allunya';

  @override
  String globeZoomToRegion(String name) {
    return 'Apropa $name →';
  }

  @override
  String get globeTellHere => 'Explica un conte d’aquí';

  @override
  String globeTellFrom(String place) {
    return 'Explica un conte de $place →';
  }

  @override
  String get globeOpenSea => 'Mar obert';

  @override
  String globeRegionCountries(int n) {
    return '$n països junts. Apropa i tria’n un.';
  }

  @override
  String get globeTurnToCountry => 'Gira el planeta cap a algun país.';

  @override
  String get globeSpin => 'Fes-lo girar';

  @override
  String get globeNoTales => 'D’aquí encara no tenim cap conte.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motius',
      one: '$n motiu',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'de $n contes',
      one: 'de $n conte',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs del paquet';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motius del paquet',
      one: '$n motiu del paquet',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Preparem $_temp0 d’aquí per al paquet $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
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
      other: '$n a les parts $region $range',
      one: '$n a la part $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'en tens $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'en preparem $n més',
      one: 'en preparem $n més',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Esperant la botiga…';

  @override
  String offerDownloading(int percent) {
    return 'Baixant contes… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Compra $name: $_temp0 per $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Baixa $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Baixa $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Baixa $name';
  }

  @override
  String get errDownloadTales => 'No s’han pogut baixar els contes.';

  @override
  String get errDownloadScenes => 'No s’han pogut baixar les imatges.';

  @override
  String get errNoDownloads => 'Aquí no es pot baixar res.';

  @override
  String get errOffline =>
      'No hi ha connexió a internet; torna-ho a provar quan tinguis senyal.';

  @override
  String get errCannotBuy => 'Ara mateix no es pot comprar aquesta part.';

  @override
  String get buyPending =>
      'La compra espera aprovació. La part es baixarà quan s’aprovi.';

  @override
  String get buyFailed => 'La compra no s’ha completat.';

  @override
  String get restoreNone => 'Aquest compte no té cap compra.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'S’han restaurat $n parts. Les pots baixar des del planeta.',
      one: 'S’ha restaurat $n part. La pots baixar des del planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'No s’han pogut restaurar les compres; torna-ho a provar quan tinguis senyal.';

  @override
  String get narrationGone => 'Aquest conte ja no està muntat.';

  @override
  String get narrationNew => 'Munta’n un de nou';

  @override
  String narrationTitle(int index, int total) {
    return 'Expliques — $index de $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Com enllaçar: $bridge';
  }

  @override
  String get narrationSituation =>
      'Què passa ara mateix? (opcional, es pot dictar)';

  @override
  String get narrationHintNote =>
      'Pista — no la diguis en veu alta, només parteix-ne.';

  @override
  String get narrationSoundsNote =>
      'Sons — posa’ls quan vagin bé amb el relat.';

  @override
  String get moodTense => 'tensió';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'Cercant…';

  @override
  String get narrationHint => 'Dona’m una pista';

  @override
  String get narrationMoreHint => 'Una altra';

  @override
  String get narrationBack => 'Enrere';

  @override
  String get narrationEnd => 'Fi';

  @override
  String get narrationNext => 'Endavant →';

  @override
  String get narrationGoodnight => 'Bona nit.';

  @override
  String get narrationEndNote =>
      'Encara no sabem fer una imatge final ni desar a la Biblioteca: aquest conte no va enlloc, es queda entre vosaltres.';

  @override
  String get narrationClose => 'Tanca';

  @override
  String get ragFallback =>
      'Del paquet encara no hi ha res per a això; una pista general:';

  @override
  String get ragNoModel => 'El model de pistes no és en aquesta versió.';

  @override
  String get ragHintGeneral => 'general';

  @override
  String get ragHintMotif => 'del motiu';

  @override
  String get captionExact => 'il·lustració · per a aquest motiu';

  @override
  String get captionSimilar => 'il·lustració · escena semblant';

  @override
  String get captionCard =>
      'carta del motiu · encara no tenim cap escena per a aquest pas';

  @override
  String get storageTitle => 'Contes baixats';

  @override
  String get storageEmpty =>
      'Encara res: els contes nous es baixen des del planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paquets',
      one: '$n paquet',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Escenes de $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'comprat';

  @override
  String get storageDelete => 'Elimina';

  @override
  String get storageScenesSub => 'Una imatge per a cada pas del relat';

  @override
  String get storageDownload => 'Baixa';

  @override
  String get storageAllUsed => 'Tot s’ha fet servir en els últims 30 dies.';

  @override
  String storageFreed(String size) {
    return 'S’han alliberat $size.';
  }

  @override
  String get storageFreeUp => 'Allibera espai (sense usar fa 30 dies)';

  @override
  String get storageRestoring => 'Restaurant les compres…';

  @override
  String get storageRestore => 'Restaura les compres';

  @override
  String get osnovaTitle => 'Esquema';

  @override
  String get osnovaSummary => 'El conte en breu';

  @override
  String get osnovaCharacters => 'Personatges';

  @override
  String get osnovaTask => 'Missió';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'Torna a començar';

  @override
  String get osnovaTell => 'Ho explico →';

  @override
  String get outlineHero => 'L’heroi';

  @override
  String get castFox => 'La guineu llesta';

  @override
  String get castSmithSon => 'El fill del ferrer';

  @override
  String get castMill => 'El molí parlador';

  @override
  String get castGooseGirl => 'La pastora d’oques';

  @override
  String get castBrothers => 'Els tres germans';

  @override
  String get castClockworkPrincess => 'La princesa rellotgera';

  @override
  String get castOwl => 'El mussol savi';

  @override
  String get castBlacksmith => 'La vella ferrera';

  @override
  String get castDragon => 'El drac petit';

  @override
  String get castWaterSprite => 'L’esperit de l’aigua';

  @override
  String get castFourPrincesses => 'Les quatre princeses';

  @override
  String get castTravelingTailor => 'El sastre errant';

  @override
  String get castTalkingCat => 'El gat parlador';

  @override
  String get castForestHermit => 'L’ermità del bosc';

  @override
  String get castC0AndersenTheShadow => 'El senyor que havia estat ombra';

  @override
  String get castC1GrimmTheGooseGirl => 'La serventa traïdora';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'El rei del castell encantat';

  @override
  String get castC3AndersenTheShadow => 'L’ombra llesta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'La princesa bonica però poc espavilada';

  @override
  String get castC5AndersenTheRedShoes => 'L’àngel que al final perdona';

  @override
  String get castC6GrimmRumpelstiltskin => 'La filla llesta del moliner';

  @override
  String get castC7PerraultLittleRedRidingHood => 'L’àvia que obre la porta';

  @override
  String get castC8PerraultLittleThumb => 'Una mare entre la misèria i l’amor';

  @override
  String get castC9PerraultIntroduction => 'La dona pacient';

  @override
  String get castC10AndersenTheRealPrincess => 'El rei que dona suport al fill';

  @override
  String get castC11GrimmLilyAndTheLion => 'La filla que compleix la paraula';

  @override
  String get castC12AndersenTheRealPrincess =>
      'El príncep que busca la princesa de debò';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'La nena dels llumins';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'El cortesà que calla';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'El criat fidel que prepara un banquet';

  @override
  String get castC16PerraultTheFairy => 'La filla presumida';

  @override
  String get castC17GrimmFirstStory => 'La vídua que vol nou cues';

  @override
  String get motifTaskWine => 'Qui beurà una cava de vi';

  @override
  String get motifTaskDiamonds => 'Un vol a la recerca de diamants';

  @override
  String get motifTaskRingDuck => 'L’anell dins l’ànec';

  @override
  String get motifTaskGiants => 'Enganyar els gegants';

  @override
  String get motifTaskTomThumb => 'La fugida del Polzet';

  @override
  String get motifTaskSwineherd => 'Guanyar el cor de la princesa';

  @override
  String get motifTaskBell => 'La campana misteriosa del bosc';

  @override
  String get motifTaskGoldenObject => 'Un do que no es pot fer servir malament';

  @override
  String get motifTaskPebbles => 'Un caminet de pedretes';

  @override
  String get motifProblemFoxPride => 'L’orgull de la guineu';

  @override
  String get motifProblemLazySister => 'La germana mandrosa';

  @override
  String get motifProblemWitchBoots => 'La bruixa amb botes de set llegües';

  @override
  String get motifProblemTailorDoubt => 'Ningú no el creu';

  @override
  String get motifProblemLions => 'Lleons famolencs a la porta';

  @override
  String get motifProblemEagle => 'L’àguila i el nan';

  @override
  String get motifProblemTruth => 'L’animal màgic revela la veritat';

  @override
  String get motifProblemOldHouse => 'Ningú no vol la casa vella';

  @override
  String get motifProblemBreadcrumbs => 'Els ocells es van menjar les molles';

  @override
  String get motifEndingTrickWins => 'L’enginy guanya';

  @override
  String get motifEndingTruthChild => 'L’infant diu la veritat';

  @override
  String get motifEndingNewHome => 'Una nova llar, vells amics';

  @override
  String get motifEndingHappyTogether => 'Feliços junts per sempre';

  @override
  String get motifEndingKissWakes => 'Un petó desperta el regne';

  @override
  String get motifEndingLeapfrog => 'L’enginy salta més alt';

  @override
  String get motifEndingCurseBroken => 'La maledicció es trenca';

  @override
  String get motifEndingWelcomedHome => 'Rebut a casa amb alegria';

  @override
  String get motifEndingSlipper => 'La sabatilla perduda';
}
