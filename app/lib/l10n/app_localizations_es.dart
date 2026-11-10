// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get castTitle => '¿Quién saldrá en el cuento?';

  @override
  String get castHint =>
      'Toca una carta para cambiar de personaje. Quita la carta con la cruz. La música y los sonidos siempre vienen listos del paquete del país; solo la imagen del personaje a veces se dibuja un momento después.';

  @override
  String get castAdd => 'Añadir personaje';

  @override
  String get castCount => 'Reparto:';

  @override
  String get castShuffleAll => 'Mezclar todo';

  @override
  String get castContinue => 'Continuar →';

  @override
  String get shuffle => 'Mezclar';

  @override
  String get motifTaskTitle => '¿Qué misión?';

  @override
  String get motifProblemTitle => '¿Qué problema?';

  @override
  String get motifEndingTitle => '¿Qué final?';

  @override
  String get motifTaskCaption =>
      'Toca una carta para elegir la misión del héroe.';

  @override
  String get motifProblemCaption =>
      'Toca una carta para elegir un obstáculo o un villano.';

  @override
  String get motifEndingCaption => 'Toca una carta para elegir un final feliz.';

  @override
  String get beatCastTitle => 'Quién sale';

  @override
  String get beatTaskTitle => 'Qué se propuso el héroe';

  @override
  String get beatProblemTitle => 'Qué se le puso por delante';

  @override
  String get beatEndingTitle => 'Cómo acabó';

  @override
  String get beatCastCaption =>
      'Presenta a los personajes: dónde están, cómo son, qué tienen de especial.';

  @override
  String get beatTaskCaption =>
      'Cuenta qué quiere el héroe y por qué se puso en camino.';

  @override
  String get beatProblemCaption =>
      'Ponle algo en el camino. Que durante un rato parezca que no va a salir bien.';

  @override
  String get beatEndingCaption =>
      'Llévalo hasta el final. No tengas prisa: el final es lo que más recuerda un niño.';

  @override
  String get hintHero => 'el héroe';

  @override
  String hintCast1(String who) {
    return '¿Cómo es «$who» la primera vez que aparece?';
  }

  @override
  String hintCast2(String who) {
    return '¿Qué hace «$who» justo antes de que empiece toda la historia?';
  }

  @override
  String hintCast3(String who) {
    return '¿De qué tiene miedo «$who»?';
  }

  @override
  String hintCast4(String who) {
    return '¿Cómo sabes que llega «$who»?';
  }

  @override
  String get hintCast5 =>
      '¿Cuáles de ellos se conocen desde hace tiempo, y de dónde?';

  @override
  String get hintCast6 => '¿Qué tiempo hace cuando se encuentran?';

  @override
  String hintCast7(String who) {
    return '¿Qué lleva «$who» en el bolsillo?';
  }

  @override
  String hintTask1(String who) {
    return '¿Cuándo comprende «$who» que tiene que ponerse manos a la obra?';
  }

  @override
  String hintTask2(String who) {
    return '¿Quién se lo aconsejó y por qué le hace caso «$who»?';
  }

  @override
  String hintTask3(String who) {
    return '¿Qué tiene que dejar en casa «$who»?';
  }

  @override
  String get hintTask4 => '¿Qué longitud tiene el camino y por dónde pasa?';

  @override
  String hintTask5(String who) {
    return '¿Qué se promete «$who» antes de salir?';
  }

  @override
  String get hintTask6 => '¿Por qué no lo puede hacer otra persona?';

  @override
  String get hintProblem1 => 'En ese momento se oye un ruido: ¿cuál?';

  @override
  String get hintProblem2 => '¿Qué sale mal primero?';

  @override
  String hintProblem3(String who) {
    return '¿Qué prueba primero «$who» y por qué no funciona?';
  }

  @override
  String get hintProblem4 => '¿Quién se niega a ayudar aunque podría?';

  @override
  String get hintProblem5 => '¿Qué pasaría si todos se rindieran ahora mismo?';

  @override
  String get hintProblem6 => '¿Hay algo triste en ese obstáculo?';

  @override
  String hintProblem7(String who) {
    return '¿Qué dice «$who» en voz alta en ese momento?';
  }

  @override
  String hintEnding1(String who) {
    return '¿Cómo lo vence «$who» al final: con fuerza o con una idea?';
  }

  @override
  String get hintEnding2 => '¿Quién ayuda aunque no tuviera por qué?';

  @override
  String hintEnding3(String who) {
    return '¿Qué es lo primero que hace «$who» cuando todo ha terminado?';
  }

  @override
  String get hintEnding4 => '¿Qué es distinto al final respecto al principio?';

  @override
  String hintEnding5(String who) {
    return '¿A dónde vuelve «$who» y quién lo espera allí?';
  }

  @override
  String get hintEnding6 =>
      '¿Cuál es la última frase antes de que se encienda la luz?';

  @override
  String get globeLoading => 'Preparando el planeta…';

  @override
  String get globeLoadFailed => 'No se pudo cargar el planeta.';

  @override
  String get globeTitle => '¿De dónde será el cuento?';

  @override
  String get globeStored => 'Cuentos descargados';

  @override
  String get globeHintFar =>
      'Gira el planeta o toca un país. Los países verdes ya tienen cuentos de nuestra colección; los grises, todavía no.';

  @override
  String get globeHintNear =>
      'Toca un país o un edificio. Los países verdes ya tienen cuentos de nuestra colección; los grises, todavía no.';

  @override
  String get globeWhole => 'Planeta entero';

  @override
  String get globeZoomIn => 'Acercar';

  @override
  String get globeZoomOut => 'Alejar';

  @override
  String globeZoomToRegion(String name) {
    return 'Acercar a $name →';
  }

  @override
  String get globeTellHere => 'Contar un cuento de aquí';

  @override
  String globeTellFrom(String place) {
    return 'Contar un cuento de $place →';
  }

  @override
  String get globeOpenSea => 'Mar abierto';

  @override
  String globeRegionCountries(int n) {
    return '$n países juntos. Acércate y elige uno.';
  }

  @override
  String get globeTurnToCountry => 'Gira el planeta hacia algún país.';

  @override
  String get globeSpin => 'Girar';

  @override
  String get globeNoTales => 'De aquí todavía no tenemos cuentos.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivos',
      one: '$n motivo',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'de $n cuentos',
      one: 'de $n cuento',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs del paquete';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivos del paquete',
      one: '$n motivo del paquete',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
    );
    return 'Preparamos $_temp0 de aquí para el paquete $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
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
      other: '$n en las partes $region $range',
      one: '$n en la parte $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'tienes $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'preparamos $n más',
      one: 'preparamos $n más',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Esperando a la tienda…';

  @override
  String offerDownloading(int percent) {
    return 'Descargando cuentos… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
    );
    return 'Comprar $name: $_temp0 por $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
    );
    return 'Descargar $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n cuentos',
      one: '$n cuento',
    );
    return 'Descargar $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Descargar $name';
  }

  @override
  String get errDownloadTales => 'No se pudieron descargar los cuentos.';

  @override
  String get errDownloadScenes => 'No se pudieron descargar las imágenes.';

  @override
  String get errNoDownloads => 'Aquí no se puede descargar.';

  @override
  String get errOffline =>
      'No hay conexión a internet; inténtalo de nuevo cuando tengas señal.';

  @override
  String get errCannotBuy => 'Esta parte no se puede comprar ahora.';

  @override
  String get buyPending =>
      'La compra espera aprobación. La parte se descargará cuando se apruebe.';

  @override
  String get buyFailed => 'La compra no se completó.';

  @override
  String get restoreNone => 'Esta cuenta no tiene compras.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Se restauraron $n partes. Puedes descargarlas desde el planeta.',
      one: 'Se restauró $n parte. Puedes descargarla desde el planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'No se pudieron restaurar las compras; inténtalo de nuevo cuando tengas señal.';

  @override
  String get narrationGone => 'Este cuento ya no está montado.';

  @override
  String get narrationNew => 'Montar uno nuevo';

  @override
  String narrationTitle(int index, int total) {
    return 'Cuentas — $index de $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Cómo enlazar: $bridge';
  }

  @override
  String get narrationSituation =>
      '¿Qué está pasando ahora? (opcional, puedes dictarlo)';

  @override
  String get narrationHintNote =>
      'Pista: no la digas en voz alta, solo úsala de punto de partida.';

  @override
  String get narrationSoundsNote =>
      'Sonidos: ponlos cuando encajen en el relato.';

  @override
  String get moodTense => 'tensión';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'Buscando…';

  @override
  String get narrationHint => 'Dame una pista';

  @override
  String get narrationMoreHint => 'Otra más';

  @override
  String get narrationBack => 'Atrás';

  @override
  String get narrationEnd => 'Fin';

  @override
  String get narrationNext => 'Siguiente →';

  @override
  String get narrationGoodnight => 'Buenas noches.';

  @override
  String get narrationEndNote =>
      'Todavía no sabemos hacer una imagen final ni guardar en la Biblioteca: este cuento no va a ninguna parte, se queda entre vosotros.';

  @override
  String get narrationClose => 'Cerrar';

  @override
  String get ragFallback =>
      'Del paquete aún no hay nada para esto; una pista general:';

  @override
  String get ragNoModel => 'El modelo de pistas no está en esta versión.';

  @override
  String get ragHintGeneral => 'general';

  @override
  String get ragHintMotif => 'del motivo';

  @override
  String get captionExact => 'ilustración · para este motivo';

  @override
  String get captionSimilar => 'ilustración · escena parecida';

  @override
  String get captionCard =>
      'carta del motivo · aún no tenemos escena para este paso';

  @override
  String get storageTitle => 'Cuentos descargados';

  @override
  String get storageEmpty =>
      'Todavía nada: los cuentos nuevos se descargan desde el planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paquetes',
      one: '$n paquete',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Escenas de $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'comprado';

  @override
  String get storageDelete => 'Eliminar';

  @override
  String get storageScenesSub => 'Una imagen para cada paso del relato';

  @override
  String get storageDownload => 'Descargar';

  @override
  String get storageAllUsed => 'Todo se ha usado en los últimos 30 días.';

  @override
  String storageFreed(String size) {
    return 'Se liberaron $size.';
  }

  @override
  String get storageFreeUp => 'Liberar espacio (sin usar en 30 días)';

  @override
  String get storageRestoring => 'Restaurando compras…';

  @override
  String get storageRestore => 'Restaurar compras';

  @override
  String get osnovaTitle => 'Esquema';

  @override
  String get osnovaSummary => 'El cuento en breve';

  @override
  String get osnovaCharacters => 'Personajes';

  @override
  String get osnovaTask => 'Misión';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'Otra vez';

  @override
  String get osnovaTell => 'Lo cuento →';

  @override
  String get outlineHero => 'El héroe';

  @override
  String get castFox => 'La zorra astuta';

  @override
  String get castSmithSon => 'El hijo del herrero';

  @override
  String get castMill => 'El molino parlante';

  @override
  String get castGooseGirl => 'La guardiana de ocas';

  @override
  String get castBrothers => 'Los tres hermanos';

  @override
  String get castClockworkPrincess => 'La princesa relojera';

  @override
  String get castOwl => 'El búho sabio';

  @override
  String get castBlacksmith => 'La vieja herrera';

  @override
  String get castDragon => 'El dragoncito';

  @override
  String get castWaterSprite => 'El espíritu del agua';

  @override
  String get castFourPrincesses => 'Las cuatro princesas';

  @override
  String get castTravelingTailor => 'El sastre ambulante';

  @override
  String get castTalkingCat => 'El gato parlante';

  @override
  String get castForestHermit => 'El ermitaño del bosque';

  @override
  String get castC0AndersenTheShadow => 'El señor que fue sombra';

  @override
  String get castC1GrimmTheGooseGirl => 'La criada traicionera';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'El rey del castillo encantado';

  @override
  String get castC3AndersenTheShadow => 'La sombra astuta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'La princesa hermosa pero poco lista';

  @override
  String get castC5AndersenTheRedShoes => 'El ángel que perdona al final';

  @override
  String get castC6GrimmRumpelstiltskin => 'La hija lista del molinero';

  @override
  String get castC7PerraultLittleRedRidingHood =>
      'La abuela que abre la puerta';

  @override
  String get castC8PerraultLittleThumb =>
      'Una madre entre la miseria y el amor';

  @override
  String get castC9PerraultIntroduction => 'La mujer paciente';

  @override
  String get castC10AndersenTheRealPrincess => 'El rey que apoya a su hijo';

  @override
  String get castC11GrimmLilyAndTheLion => 'La hija que cumple su palabra';

  @override
  String get castC12AndersenTheRealPrincess =>
      'El príncipe que busca a la princesa de verdad';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'La niña de las cerillas';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'El cortesano que calla';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'El criado fiel que prepara un banquete';

  @override
  String get castC16PerraultTheFairy => 'La hija presumida';

  @override
  String get castC17GrimmFirstStory => 'La viuda que quiere nueve colas';

  @override
  String get motifTaskWine => 'Quién se beberá una bodega de vino';

  @override
  String get motifTaskDiamonds => 'Un vuelo en busca de diamantes';

  @override
  String get motifTaskRingDuck => 'El anillo dentro del pato';

  @override
  String get motifTaskGiants => 'Burlar a los gigantes';

  @override
  String get motifTaskTomThumb => 'La huida del Pulgarcito';

  @override
  String get motifTaskSwineherd => 'Ganarse el corazón de la princesa';

  @override
  String get motifTaskBell => 'La campana misteriosa del bosque';

  @override
  String get motifTaskGoldenObject => 'Un don que no se debe usar mal';

  @override
  String get motifTaskPebbles => 'Un caminito de guijarros';

  @override
  String get motifProblemFoxPride => 'El orgullo de la zorra';

  @override
  String get motifProblemLazySister => 'La hermana perezosa';

  @override
  String get motifProblemWitchBoots => 'La bruja con botas de siete leguas';

  @override
  String get motifProblemTailorDoubt => 'Nadie le cree';

  @override
  String get motifProblemLions => 'Leones hambrientos en la puerta';

  @override
  String get motifProblemEagle => 'El águila y el enano';

  @override
  String get motifProblemTruth => 'El animal mágico revela la verdad';

  @override
  String get motifProblemOldHouse => 'Nadie quiere la casa vieja';

  @override
  String get motifProblemBreadcrumbs => 'Los pájaros se comieron las migas';

  @override
  String get motifEndingTrickWins => 'Gana el ingenio';

  @override
  String get motifEndingTruthChild => 'El niño dice la verdad';

  @override
  String get motifEndingNewHome => 'Un hogar nuevo, viejos amigos';

  @override
  String get motifEndingHappyTogether => 'Felices juntos para siempre';

  @override
  String get motifEndingKissWakes => 'Un beso despierta el reino';

  @override
  String get motifEndingLeapfrog => 'El ingenio salta más alto';

  @override
  String get motifEndingCurseBroken => 'La maldición se rompe';

  @override
  String get motifEndingWelcomedHome => 'Bienvenido a casa';

  @override
  String get motifEndingSlipper => 'El zapato perdido';
}
