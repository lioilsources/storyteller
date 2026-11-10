// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get castTitle => 'Qui sera dans le conte ?';

  @override
  String get castHint =>
      'Touche une carte pour changer de personnage. Supprime la carte avec la croix. La musique et les sons sont toujours prêts, issus du pack du pays ; seule l’image du personnage est parfois dessinée un instant plus tard.';

  @override
  String get castAdd => 'Ajouter un personnage';

  @override
  String get castCount => 'Distribution :';

  @override
  String get castShuffleAll => 'Tout mélanger';

  @override
  String get castContinue => 'Continuer →';

  @override
  String get shuffle => 'Mélanger';

  @override
  String get motifTaskTitle => 'Quelle mission ?';

  @override
  String get motifProblemTitle => 'Quel problème ?';

  @override
  String get motifEndingTitle => 'Quelle fin ?';

  @override
  String get motifTaskCaption =>
      'Touche une carte pour choisir la mission du héros.';

  @override
  String get motifProblemCaption =>
      'Touche une carte pour choisir un obstacle ou un méchant.';

  @override
  String get motifEndingCaption =>
      'Touche une carte pour choisir une fin heureuse.';

  @override
  String get beatCastTitle => 'Qui est dans l’histoire';

  @override
  String get beatTaskTitle => 'Ce que le héros s’est promis';

  @override
  String get beatProblemTitle => 'Ce qui s’est mis en travers';

  @override
  String get beatEndingTitle => 'Comment ça s’est fini';

  @override
  String get beatCastCaption =>
      'Présente les personnages : où ils sont, à quoi ils ressemblent, ce qu’ils ont de particulier.';

  @override
  String get beatTaskCaption =>
      'Dis ce que veut le héros et pourquoi il s’est mis en route.';

  @override
  String get beatProblemCaption =>
      'Mets quelque chose sur son chemin. Que l’on croie un moment que ça ne marchera pas.';

  @override
  String get beatEndingCaption =>
      'Mène l’histoire jusqu’au bout. Ne te presse pas : la fin est ce dont un enfant se souvient le mieux.';

  @override
  String get hintHero => 'le héros';

  @override
  String hintCast1(String who) {
    return 'À quoi ressemble « $who » quand il apparaît pour la première fois ?';
  }

  @override
  String hintCast2(String who) {
    return 'Que fait « $who » juste avant que toute l’histoire commence ?';
  }

  @override
  String hintCast3(String who) {
    return 'De quoi « $who » a-t-il peur ?';
  }

  @override
  String hintCast4(String who) {
    return 'À quoi reconnais-tu que « $who » arrive ?';
  }

  @override
  String get hintCast5 => 'Lesquels se connaissent depuis longtemps, et d’où ?';

  @override
  String get hintCast6 => 'Quel temps fait-il quand ils se rencontrent ?';

  @override
  String hintCast7(String who) {
    return 'Qu’a « $who » dans sa poche ?';
  }

  @override
  String hintTask1(String who) {
    return 'Quand « $who » comprend-il qu’il faut se lancer ?';
  }

  @override
  String hintTask2(String who) {
    return 'Qui a donné le conseil, et pourquoi « $who » l’écoute-t-il ?';
  }

  @override
  String hintTask3(String who) {
    return 'Que doit laisser à la maison « $who » ?';
  }

  @override
  String get hintTask4 =>
      'Quelle est la longueur du chemin, et qu’est-ce qu’il traverse ?';

  @override
  String hintTask5(String who) {
    return 'Que se promet « $who » avant de partir ?';
  }

  @override
  String get hintTask6 => 'Pourquoi personne d’autre ne peut-il le faire ?';

  @override
  String get hintProblem1 => 'À ce moment-là, on entend un bruit : lequel ?';

  @override
  String get hintProblem2 => 'Qu’est-ce qui tourne mal en premier ?';

  @override
  String hintProblem3(String who) {
    return 'Qu’essaie « $who » d’abord, et pourquoi ça échoue ?';
  }

  @override
  String get hintProblem4 => 'Qui refuse d’aider alors qu’il le pourrait ?';

  @override
  String get hintProblem5 =>
      'Que se passerait-il si tout le monde abandonnait maintenant ?';

  @override
  String get hintProblem6 =>
      'Y a-t-il quelque chose de triste dans cet obstacle ?';

  @override
  String hintProblem7(String who) {
    return 'Que dit « $who » à voix haute à ce moment-là ?';
  }

  @override
  String hintEnding1(String who) {
    return 'Comment « $who » en vient-il à bout à la fin : par la force ou par une idée ?';
  }

  @override
  String get hintEnding2 => 'Qui aide alors qu’il n’y était pas obligé ?';

  @override
  String hintEnding3(String who) {
    return 'Que fait « $who » tout de suite quand tout est fini ?';
  }

  @override
  String get hintEnding4 =>
      'Qu’est-ce qui est différent à la fin par rapport au début ?';

  @override
  String hintEnding5(String who) {
    return 'Où revient « $who » et qui l’attend là-bas ?';
  }

  @override
  String get hintEnding6 =>
      'Quelle est la dernière phrase avant que la lumière s’allume ?';

  @override
  String get globeLoading => 'Je prépare la planète…';

  @override
  String get globeLoadFailed => 'Impossible de charger la planète.';

  @override
  String get globeTitle => 'D’où viendra le conte ?';

  @override
  String get globeStored => 'Contes téléchargés';

  @override
  String get globeHintFar =>
      'Fais tourner la planète ou touche un pays. Les pays verts ont déjà des contes de notre collection, les gris pas encore.';

  @override
  String get globeHintNear =>
      'Touche un pays ou un monument. Les pays verts ont déjà des contes de notre collection, les gris pas encore.';

  @override
  String get globeWhole => 'Toute la planète';

  @override
  String get globeZoomIn => 'Zoom avant';

  @override
  String get globeZoomOut => 'Zoom arrière';

  @override
  String globeZoomToRegion(String name) {
    return 'Zoomer sur $name →';
  }

  @override
  String get globeTellHere => 'Raconter un conte d’ici';

  @override
  String globeTellFrom(String place) {
    return 'Raconter un conte de $place →';
  }

  @override
  String get globeOpenSea => 'Pleine mer';

  @override
  String globeRegionCountries(int n) {
    return '$n pays réunis. Zoome et choisis-en un.';
  }

  @override
  String get globeTurnToCountry => 'Tourne la planète vers un pays.';

  @override
  String get globeSpin => 'Faire tourner';

  @override
  String get globeNoTales => 'Nous n’avons pas encore de conte d’ici.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motifs',
      one: '$n motif',
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
    return '$base + $packMotifs du pack';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motifs du pack',
      one: '$n motif du pack',
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
    return 'Nous préparons $_temp0 d’ici pour le pack $region.';
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
      other: '$n contes gratuits',
      one: '$n conte gratuit',
    );
    return '$_temp0';
  }

  @override
  String cardFree(int n) {
    return 'gratuits : $n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n dans les parties $region $range',
      one: '$n dans la partie $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'tu en as $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n autres en préparation',
      one: '$n autre en préparation',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'En attente de la boutique…';

  @override
  String offerDownloading(int percent) {
    return 'Téléchargement des contes… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Acheter $name : $_temp0 pour $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes gratuits',
      one: '$n conte gratuit',
    );
    return 'Télécharger $name : $_temp0 ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contes',
      one: '$n conte',
    );
    return 'Télécharger $name : $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Télécharger $name';
  }

  @override
  String get errDownloadTales => 'Impossible de télécharger les contes.';

  @override
  String get errDownloadScenes => 'Impossible de télécharger les images.';

  @override
  String get errNoDownloads => 'Le téléchargement n’est pas disponible ici.';

  @override
  String get errOffline =>
      'Pas de connexion internet : réessaie quand tu auras du réseau.';

  @override
  String get errCannotBuy =>
      'Cette partie ne peut pas être achetée pour le moment.';

  @override
  String get buyPending =>
      'L’achat attend une validation. La partie sera téléchargée une fois validé.';

  @override
  String get buyFailed => 'L’achat n’a pas abouti.';

  @override
  String get restoreNone => 'Ce compte n’a aucun achat.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other:
          '$n parties restaurées. Tu peux les télécharger depuis la planète.',
      one: '$n partie restaurée. Tu peux la télécharger depuis la planète.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Impossible de restaurer les achats : réessaie quand tu auras du réseau.';

  @override
  String get narrationGone => 'Ce conte n’est plus composé.';

  @override
  String get narrationNew => 'En composer un nouveau';

  @override
  String narrationTitle(int index, int total) {
    return 'Tu racontes — $index sur $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Comment enchaîner : $bridge';
  }

  @override
  String get narrationSituation =>
      'Que se passe-t-il en ce moment ? (facultatif, tu peux dicter)';

  @override
  String get narrationHintNote =>
      'Indice : ne le dis pas à voix haute, pars simplement de là.';

  @override
  String get narrationSoundsNote =>
      'Sons : lance-les quand ils s’accordent au récit.';

  @override
  String get moodTense => 'tension';

  @override
  String get moodCalm => 'calme';

  @override
  String get narrationSearching => 'Recherche…';

  @override
  String get narrationHint => 'Donne-moi un indice';

  @override
  String get narrationMoreHint => 'Encore un';

  @override
  String get narrationBack => 'Retour';

  @override
  String get narrationEnd => 'Fin';

  @override
  String get narrationNext => 'Suivant →';

  @override
  String get narrationGoodnight => 'Bonne nuit.';

  @override
  String get narrationEndNote =>
      'Nous ne savons pas encore faire d’image finale ni enregistrer dans la Bibliothèque : ce conte ne va nulle part, il reste entre vous.';

  @override
  String get narrationClose => 'Fermer';

  @override
  String get ragFallback =>
      'Rien dans le pack pour ça pour l’instant ; un indice général :';

  @override
  String get ragNoModel =>
      'Le modèle d’indices n’est pas inclus dans cette version.';

  @override
  String get ragHintGeneral => 'général';

  @override
  String get ragHintMotif => 'pour le motif';

  @override
  String get captionExact => 'illustration · pour ce motif';

  @override
  String get captionSimilar => 'illustration · scène similaire';

  @override
  String get captionCard =>
      'carte du motif · pas encore de scène pour cette étape';

  @override
  String get storageTitle => 'Contes téléchargés';

  @override
  String get storageEmpty =>
      'Rien pour l’instant : d’autres contes se téléchargent depuis la planète.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n packs',
      one: '$n pack',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Scènes $name';
  }

  @override
  String get storageFreeTier => 'gratuit';

  @override
  String get storageBoughtTier => 'acheté';

  @override
  String get storageDelete => 'Supprimer';

  @override
  String get storageScenesSub => 'Une image pour chaque étape du récit';

  @override
  String get storageDownload => 'Télécharger';

  @override
  String get storageAllUsed => 'Tout a été utilisé ces 30 derniers jours.';

  @override
  String storageFreed(String size) {
    return '$size libérés.';
  }

  @override
  String get storageFreeUp => 'Libérer de l’espace (inutilisé depuis 30 jours)';

  @override
  String get storageRestoring => 'Restauration des achats…';

  @override
  String get storageRestore => 'Restaurer les achats';

  @override
  String get osnovaTitle => 'Plan';

  @override
  String get osnovaSummary => 'Le conte en bref';

  @override
  String get osnovaCharacters => 'Personnages';

  @override
  String get osnovaTask => 'Mission';

  @override
  String get osnovaProblem => 'Problème';

  @override
  String get osnovaEnding => 'Fin';

  @override
  String get osnovaAgain => 'Recommencer';

  @override
  String get osnovaTell => 'Je raconte →';

  @override
  String get outlineHero => 'Le héros';

  @override
  String get castFox => 'Le renard rusé';

  @override
  String get castSmithSon => 'Le fils du forgeron';

  @override
  String get castMill => 'Le moulin qui parle';

  @override
  String get castGooseGirl => 'La gardeuse d’oies';

  @override
  String get castBrothers => 'Les trois frères';

  @override
  String get castClockworkPrincess => 'La princesse horlogère';

  @override
  String get castOwl => 'La chouette sage';

  @override
  String get castBlacksmith => 'La vieille forgeronne';

  @override
  String get castDragon => 'Le petit dragon';

  @override
  String get castWaterSprite => 'L’esprit de l’eau';

  @override
  String get castFourPrincesses => 'Les quatre princesses';

  @override
  String get castTravelingTailor => 'Le tailleur itinérant';

  @override
  String get castTalkingCat => 'Le chat qui parle';

  @override
  String get castForestHermit => 'L’ermite de la forêt';

  @override
  String get castC0AndersenTheShadow => 'Le monsieur qui avait été une ombre';

  @override
  String get castC1GrimmTheGooseGirl => 'La servante traîtresse';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'Le roi au château hanté';

  @override
  String get castC3AndersenTheShadow => 'L’ombre maligne';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'La belle princesse pas très maligne';

  @override
  String get castC5AndersenTheRedShoes => 'L’ange qui pardonne à la fin';

  @override
  String get castC6GrimmRumpelstiltskin => 'La fille avisée du meunier';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'La grand-mère qui ouvre la porte';

  @override
  String get castC8PerraultLittleThumb => 'Une mère entre misère et amour';

  @override
  String get castC9PerraultIntroduction => 'La femme patiente';

  @override
  String get castC10AndersenTheRealPrincess => 'Le roi qui soutient son fils';

  @override
  String get castC11GrimmLilyAndTheLion => 'La fille qui tient parole';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Le prince qui cherche la vraie princesse';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'La petite fille aux allumettes';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Le courtisan qui se tait';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Le fidèle serviteur prépare un festin';

  @override
  String get castC16PerraultTheFairy => 'La fille prétentieuse';

  @override
  String get castC17GrimmFirstStory => 'La veuve qui veut neuf queues';

  @override
  String get motifTaskWine => 'Qui boira une cave pleine de vin';

  @override
  String get motifTaskDiamonds => 'Un vol pour des diamants';

  @override
  String get motifTaskRingDuck => 'La bague dans le canard';

  @override
  String get motifTaskGiants => 'Berner les géants';

  @override
  String get motifTaskTomThumb => 'La fuite du Petit Poucet';

  @override
  String get motifTaskSwineherd => 'Gagner le cœur de la princesse';

  @override
  String get motifTaskBell => 'La cloche mystérieuse dans la forêt';

  @override
  String get motifTaskGoldenObject => 'Un don dont il ne faut pas abuser';

  @override
  String get motifTaskPebbles => 'Un chemin de cailloux';

  @override
  String get motifProblemFoxPride => 'L’orgueil du renard';

  @override
  String get motifProblemLazySister => 'La sœur paresseuse';

  @override
  String get motifProblemWitchBoots => 'La sorcière aux bottes de sept lieues';

  @override
  String get motifProblemTailorDoubt => 'Personne ne le croit';

  @override
  String get motifProblemLions => 'Des lions affamés à la porte';

  @override
  String get motifProblemEagle => 'L’aigle et le nain';

  @override
  String get motifProblemTruth => 'L’animal magique révèle la vérité';

  @override
  String get motifProblemOldHouse => 'Personne ne veut de la vieille maison';

  @override
  String get motifProblemBreadcrumbs => 'Les oiseaux ont mangé les miettes';

  @override
  String get motifEndingTrickWins => 'La ruse l’emporte';

  @override
  String get motifEndingTruthChild => 'L’enfant dit la vérité';

  @override
  String get motifEndingNewHome => 'Un nouveau foyer, de vieux amis';

  @override
  String get motifEndingHappyTogether => 'Heureux ensemble pour toujours';

  @override
  String get motifEndingKissWakes => 'Un baiser réveille le royaume';

  @override
  String get motifEndingLeapfrog => 'La ruse saute le plus haut';

  @override
  String get motifEndingCurseBroken => 'La malédiction est brisée';

  @override
  String get motifEndingWelcomedHome => 'Bienvenue à la maison';

  @override
  String get motifEndingSlipper => 'La pantoufle perdue';
}
