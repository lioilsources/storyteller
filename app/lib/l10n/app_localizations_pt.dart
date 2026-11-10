// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get castTitle => 'Quem vai estar no conto?';

  @override
  String get castHint =>
      'Toque numa carta para trocar de personagem. Remova a carta com o X. A música e os sons vêm sempre prontos do pacote do país; só a imagem do personagem às vezes é desenhada um instante depois.';

  @override
  String get castAdd => 'Adicionar personagem';

  @override
  String get castCount => 'Elenco:';

  @override
  String get castShuffleAll => 'Embaralhar tudo';

  @override
  String get castContinue => 'Continuar →';

  @override
  String get shuffle => 'Embaralhar';

  @override
  String get motifTaskTitle => 'Qual missão?';

  @override
  String get motifProblemTitle => 'Qual problema?';

  @override
  String get motifEndingTitle => 'Qual final?';

  @override
  String get motifTaskCaption =>
      'Toque numa carta para escolher a missão do herói.';

  @override
  String get motifProblemCaption =>
      'Toque numa carta para escolher um obstáculo ou um vilão.';

  @override
  String get motifEndingCaption =>
      'Toque numa carta para escolher um final feliz.';

  @override
  String get beatCastTitle => 'Quem está na história';

  @override
  String get beatTaskTitle => 'O que o herói se propôs';

  @override
  String get beatProblemTitle => 'O que apareceu no caminho';

  @override
  String get beatEndingTitle => 'Como terminou';

  @override
  String get beatCastCaption =>
      'Apresente os personagens: onde estão, como são, o que têm de especial.';

  @override
  String get beatTaskCaption => 'Diga o que o herói quer e por que ele partiu.';

  @override
  String get beatProblemCaption =>
      'Coloque algo no caminho dele. Que por um tempo pareça que não vai dar certo.';

  @override
  String get beatEndingCaption =>
      'Leve a história até o fim. Sem pressa: o final é o que a criança mais lembra.';

  @override
  String get hintHero => 'o herói';

  @override
  String hintCast1(String who) {
    return 'Como é «$who» quando aparece pela primeira vez?';
  }

  @override
  String hintCast2(String who) {
    return 'O que «$who» está fazendo logo antes de toda a história começar?';
  }

  @override
  String hintCast3(String who) {
    return 'Do que «$who» tem medo?';
  }

  @override
  String hintCast4(String who) {
    return 'Como você percebe que «$who» está chegando?';
  }

  @override
  String get hintCast5 => 'Quais deles se conhecem há muito tempo, e de onde?';

  @override
  String get hintCast6 => 'Como está o tempo quando eles se encontram?';

  @override
  String hintCast7(String who) {
    return 'O que «$who» tem no bolso?';
  }

  @override
  String hintTask1(String who) {
    return 'Quando «$who» percebe que precisa pôr mãos à obra?';
  }

  @override
  String hintTask2(String who) {
    return 'Quem deu o conselho, e por que «$who» o escuta?';
  }

  @override
  String hintTask3(String who) {
    return 'O que «$who» precisa deixar em casa?';
  }

  @override
  String get hintTask4 => 'Quão longo é o caminho e por onde ele passa?';

  @override
  String hintTask5(String who) {
    return 'O que «$who» promete a si mesmo antes de partir?';
  }

  @override
  String get hintTask6 => 'Por que ninguém mais pode fazer isso?';

  @override
  String get hintProblem1 => 'Nesse momento se ouve um som: qual?';

  @override
  String get hintProblem2 => 'O que dá errado primeiro?';

  @override
  String hintProblem3(String who) {
    return 'O que «$who» tenta primeiro, e por que não funciona?';
  }

  @override
  String get hintProblem4 => 'Quem se recusa a ajudar, mesmo podendo?';

  @override
  String get hintProblem5 => 'O que aconteceria se todos desistissem agora?';

  @override
  String get hintProblem6 => 'Há algo de triste nesse obstáculo?';

  @override
  String hintProblem7(String who) {
    return 'O que «$who» diz em voz alta nesse momento?';
  }

  @override
  String hintEnding1(String who) {
    return 'Como «$who» vence isso no fim: com força ou com uma ideia?';
  }

  @override
  String get hintEnding2 => 'Quem ajuda, mesmo sem precisar?';

  @override
  String hintEnding3(String who) {
    return 'O que «$who» faz primeiro quando tudo acaba?';
  }

  @override
  String get hintEnding4 => 'O que é diferente no fim em relação ao começo?';

  @override
  String hintEnding5(String who) {
    return 'Para onde «$who» volta e quem está esperando lá?';
  }

  @override
  String get hintEnding6 => 'Qual é a última frase antes de a luz acender?';

  @override
  String get globeLoading => 'Preparando o planeta…';

  @override
  String get globeLoadFailed => 'Não foi possível carregar o planeta.';

  @override
  String get globeTitle => 'De onde será o conto?';

  @override
  String get globeStored => 'Contos baixados';

  @override
  String get globeHintFar =>
      'Gire o planeta ou toque num país. Os países verdes já têm contos da nossa coleção; os cinzas, ainda não.';

  @override
  String get globeHintNear =>
      'Toque num país ou num monumento. Os países verdes já têm contos da nossa coleção; os cinzas, ainda não.';

  @override
  String get globeWhole => 'Planeta inteiro';

  @override
  String get globeZoomIn => 'Aproximar';

  @override
  String get globeZoomOut => 'Afastar';

  @override
  String globeZoomToRegion(String name) {
    return 'Aproximar: $name →';
  }

  @override
  String get globeTellHere => 'Contar um conto daqui';

  @override
  String globeTellFrom(String place) {
    return 'Contar um conto de $place →';
  }

  @override
  String get globeOpenSea => 'Mar aberto';

  @override
  String globeRegionCountries(int n) {
    return '$n países juntos. Aproxime e escolha um.';
  }

  @override
  String get globeTurnToCountry => 'Gire o planeta para algum país.';

  @override
  String get globeSpin => 'Girar';

  @override
  String get globeNoTales => 'Daqui ainda não temos nenhum conto.';

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
      other: 'de $n contos',
      one: 'de $n conto',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs do pacote';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivos do pacote',
      one: '$n motivo do pacote',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Estamos preparando $_temp0 daqui para o pacote $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0 grátis';
  }

  @override
  String cardFree(int n) {
    return '$n grátis';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n nas partes $region $range',
      one: '$n na parte $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'você tem $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'mais $n a caminho',
      one: 'mais $n a caminho',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Aguardando a loja…';

  @override
  String offerDownloading(int percent) {
    return 'Baixando contos… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Comprar $name: $_temp0 por $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Baixar $name: $_temp0 grátis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Baixar $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Baixar $name';
  }

  @override
  String get errDownloadTales => 'Não foi possível baixar os contos.';

  @override
  String get errDownloadScenes => 'Não foi possível baixar as imagens.';

  @override
  String get errNoDownloads => 'O download não está disponível aqui.';

  @override
  String get errOffline =>
      'Sem conexão com a internet — tente de novo quando tiver sinal.';

  @override
  String get errCannotBuy => 'Esta parte não pode ser comprada agora.';

  @override
  String get buyPending =>
      'A compra aguarda aprovação. A parte será baixada assim que for aprovada.';

  @override
  String get buyFailed => 'A compra não foi concluída.';

  @override
  String get restoreNone => 'Esta conta não tem compras.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n partes restauradas. Você pode baixá-las pelo planeta.',
      one: '$n parte restaurada. Você pode baixá-la pelo planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Não foi possível restaurar as compras — tente de novo quando tiver sinal.';

  @override
  String get narrationGone => 'Este conto não está mais montado.';

  @override
  String get narrationNew => 'Montar um novo';

  @override
  String narrationTitle(int index, int total) {
    return 'Você conta — $index de $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Como emendar: $bridge';
  }

  @override
  String get narrationSituation =>
      'O que está acontecendo agora? (opcional, dá para ditar)';

  @override
  String get narrationHintNote =>
      'Dica — não leia em voz alta, só use como ponto de partida.';

  @override
  String get narrationSoundsNote =>
      'Sons — toque quando combinarem com a história.';

  @override
  String get moodTense => 'tensão';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'Procurando…';

  @override
  String get narrationHint => 'Dê uma dica';

  @override
  String get narrationMoreHint => 'Mais uma';

  @override
  String get narrationBack => 'Voltar';

  @override
  String get narrationEnd => 'Fim';

  @override
  String get narrationNext => 'Avançar →';

  @override
  String get narrationGoodnight => 'Boa noite.';

  @override
  String get narrationEndNote =>
      'Ainda não sabemos fazer uma imagem final nem salvar na Biblioteca — este conto não vai a lugar nenhum, fica entre vocês.';

  @override
  String get narrationClose => 'Fechar';

  @override
  String get ragFallback =>
      'O pacote ainda não tem nada para isso; uma dica geral:';

  @override
  String get ragNoModel => 'O modelo de dicas não está nesta versão.';

  @override
  String get ragHintGeneral => 'geral';

  @override
  String get ragHintMotif => 'do motivo';

  @override
  String get captionExact => 'ilustração · para este motivo';

  @override
  String get captionSimilar => 'ilustração · cena parecida';

  @override
  String get captionCard =>
      'carta do motivo · ainda não temos cena para este passo';

  @override
  String get storageTitle => 'Contos baixados';

  @override
  String get storageEmpty =>
      'Ainda nada — mais contos são baixados pelo planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pacotes',
      one: '$n pacote',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Cenas de $name';
  }

  @override
  String get storageFreeTier => 'grátis';

  @override
  String get storageBoughtTier => 'comprado';

  @override
  String get storageDelete => 'Excluir';

  @override
  String get storageScenesSub => 'Uma imagem para cada passo da narração';

  @override
  String get storageDownload => 'Baixar';

  @override
  String get storageAllUsed => 'Tudo foi usado nos últimos 30 dias.';

  @override
  String storageFreed(String size) {
    return '$size liberados.';
  }

  @override
  String get storageFreeUp => 'Liberar espaço (sem uso há 30 dias)';

  @override
  String get storageRestoring => 'Restaurando compras…';

  @override
  String get storageRestore => 'Restaurar compras';

  @override
  String get osnovaTitle => 'Roteiro';

  @override
  String get osnovaSummary => 'O conto em resumo';

  @override
  String get osnovaCharacters => 'Personagens';

  @override
  String get osnovaTask => 'Missão';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'Recomeçar';

  @override
  String get osnovaTell => 'Vou contar →';

  @override
  String get outlineHero => 'O herói';

  @override
  String get castFox => 'A raposa esperta';

  @override
  String get castSmithSon => 'O filho do ferreiro';

  @override
  String get castMill => 'O moinho falante';

  @override
  String get castGooseGirl => 'A guardadora de gansos';

  @override
  String get castBrothers => 'Os três irmãos';

  @override
  String get castClockworkPrincess => 'A princesa relojoeira';

  @override
  String get castOwl => 'A coruja sábia';

  @override
  String get castBlacksmith => 'A velha ferreira';

  @override
  String get castDragon => 'O pequeno dragão';

  @override
  String get castWaterSprite => 'O espírito da água';

  @override
  String get castFourPrincesses => 'As quatro princesas';

  @override
  String get castTravelingTailor => 'O alfaiate andarilho';

  @override
  String get castTalkingCat => 'O gato falante';

  @override
  String get castForestHermit => 'O eremita da floresta';

  @override
  String get castC0AndersenTheShadow => 'O senhor que já foi uma sombra';

  @override
  String get castC1GrimmTheGooseGirl => 'A criada traiçoeira';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'O rei do castelo assombrado';

  @override
  String get castC3AndersenTheShadow => 'A sombra esperta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'A princesa bela, mas pouco esperta';

  @override
  String get castC5AndersenTheRedShoes => 'O anjo que perdoa no fim';

  @override
  String get castC6GrimmRumpelstiltskin => 'A filha esperta do moleiro';

  @override
  String get castC7PerraultLittleRedRidingHood => 'A avó que abre a porta';

  @override
  String get castC8PerraultLittleThumb => 'Uma mãe entre a miséria e o amor';

  @override
  String get castC9PerraultIntroduction => 'A mulher paciente';

  @override
  String get castC10AndersenTheRealPrincess => 'O rei que apoia o filho';

  @override
  String get castC11GrimmLilyAndTheLion => 'A filha que cumpre a palavra';

  @override
  String get castC12AndersenTheRealPrincess =>
      'O príncipe que procura a princesa de verdade';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'A menina dos fósforos';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'O cortesão que se cala';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'O servo fiel prepara um banquete';

  @override
  String get castC16PerraultTheFairy => 'A filha presunçosa';

  @override
  String get castC17GrimmFirstStory => 'A viúva que quer nove caudas';

  @override
  String get motifTaskWine => 'Quem vai beber uma adega de vinho';

  @override
  String get motifTaskDiamonds => 'Um voo atrás de diamantes';

  @override
  String get motifTaskRingDuck => 'O anel dentro do pato';

  @override
  String get motifTaskGiants => 'Enganar os gigantes';

  @override
  String get motifTaskTomThumb => 'A fuga do Pequeno Polegar';

  @override
  String get motifTaskSwineherd => 'Conquistar o coração da princesa';

  @override
  String get motifTaskBell => 'O sino misterioso na floresta';

  @override
  String get motifTaskGoldenObject => 'Um presente que não pode ser mal usado';

  @override
  String get motifTaskPebbles => 'Um caminho de pedrinhas';

  @override
  String get motifProblemFoxPride => 'O orgulho da raposa';

  @override
  String get motifProblemLazySister => 'A irmã preguiçosa';

  @override
  String get motifProblemWitchBoots => 'A bruxa com botas de sete léguas';

  @override
  String get motifProblemTailorDoubt => 'Ninguém acredita nele';

  @override
  String get motifProblemLions => 'Leões famintos no portão';

  @override
  String get motifProblemEagle => 'A águia e o anão';

  @override
  String get motifProblemTruth => 'O animal mágico revela a verdade';

  @override
  String get motifProblemOldHouse => 'Ninguém quer a casa velha';

  @override
  String get motifProblemBreadcrumbs => 'Os pássaros comeram as migalhas';

  @override
  String get motifEndingTrickWins => 'A esperteza vence';

  @override
  String get motifEndingTruthChild => 'A criança diz a verdade';

  @override
  String get motifEndingNewHome => 'Um novo lar, velhos amigos';

  @override
  String get motifEndingHappyTogether => 'Felizes juntos para sempre';

  @override
  String get motifEndingKissWakes => 'Um beijo desperta o reino';

  @override
  String get motifEndingLeapfrog => 'A esperteza salta mais alto';

  @override
  String get motifEndingCurseBroken => 'A maldição foi quebrada';

  @override
  String get motifEndingWelcomedHome => 'Recebido em casa';

  @override
  String get motifEndingSlipper => 'O sapatinho perdido';
}

/// The translations for Portuguese, as used in Brazil (`pt_BR`).
class AppLocalizationsPtBr extends AppLocalizationsPt {
  AppLocalizationsPtBr() : super('pt_BR');

  @override
  String get castTitle => 'Quem vai estar no conto?';

  @override
  String get castHint =>
      'Toque numa carta para trocar de personagem. Remova a carta com o X. A música e os sons vêm sempre prontos do pacote do país; só a imagem do personagem às vezes é desenhada um instante depois.';

  @override
  String get castAdd => 'Adicionar personagem';

  @override
  String get castCount => 'Elenco:';

  @override
  String get castShuffleAll => 'Embaralhar tudo';

  @override
  String get castContinue => 'Continuar →';

  @override
  String get shuffle => 'Embaralhar';

  @override
  String get motifTaskTitle => 'Qual missão?';

  @override
  String get motifProblemTitle => 'Qual problema?';

  @override
  String get motifEndingTitle => 'Qual final?';

  @override
  String get motifTaskCaption =>
      'Toque numa carta para escolher a missão do herói.';

  @override
  String get motifProblemCaption =>
      'Toque numa carta para escolher um obstáculo ou um vilão.';

  @override
  String get motifEndingCaption =>
      'Toque numa carta para escolher um final feliz.';

  @override
  String get beatCastTitle => 'Quem está na história';

  @override
  String get beatTaskTitle => 'O que o herói se propôs';

  @override
  String get beatProblemTitle => 'O que apareceu no caminho';

  @override
  String get beatEndingTitle => 'Como terminou';

  @override
  String get beatCastCaption =>
      'Apresente os personagens: onde estão, como são, o que têm de especial.';

  @override
  String get beatTaskCaption => 'Diga o que o herói quer e por que ele partiu.';

  @override
  String get beatProblemCaption =>
      'Coloque algo no caminho dele. Que por um tempo pareça que não vai dar certo.';

  @override
  String get beatEndingCaption =>
      'Leve a história até o fim. Sem pressa: o final é o que a criança mais lembra.';

  @override
  String get hintHero => 'o herói';

  @override
  String hintCast1(String who) {
    return 'Como é «$who» quando aparece pela primeira vez?';
  }

  @override
  String hintCast2(String who) {
    return 'O que «$who» está fazendo logo antes de toda a história começar?';
  }

  @override
  String hintCast3(String who) {
    return 'Do que «$who» tem medo?';
  }

  @override
  String hintCast4(String who) {
    return 'Como você percebe que «$who» está chegando?';
  }

  @override
  String get hintCast5 => 'Quais deles se conhecem há muito tempo, e de onde?';

  @override
  String get hintCast6 => 'Como está o tempo quando eles se encontram?';

  @override
  String hintCast7(String who) {
    return 'O que «$who» tem no bolso?';
  }

  @override
  String hintTask1(String who) {
    return 'Quando «$who» percebe que precisa pôr mãos à obra?';
  }

  @override
  String hintTask2(String who) {
    return 'Quem deu o conselho, e por que «$who» o escuta?';
  }

  @override
  String hintTask3(String who) {
    return 'O que «$who» precisa deixar em casa?';
  }

  @override
  String get hintTask4 => 'Quão longo é o caminho e por onde ele passa?';

  @override
  String hintTask5(String who) {
    return 'O que «$who» promete a si mesmo antes de partir?';
  }

  @override
  String get hintTask6 => 'Por que ninguém mais pode fazer isso?';

  @override
  String get hintProblem1 => 'Nesse momento se ouve um som: qual?';

  @override
  String get hintProblem2 => 'O que dá errado primeiro?';

  @override
  String hintProblem3(String who) {
    return 'O que «$who» tenta primeiro, e por que não funciona?';
  }

  @override
  String get hintProblem4 => 'Quem se recusa a ajudar, mesmo podendo?';

  @override
  String get hintProblem5 => 'O que aconteceria se todos desistissem agora?';

  @override
  String get hintProblem6 => 'Há algo de triste nesse obstáculo?';

  @override
  String hintProblem7(String who) {
    return 'O que «$who» diz em voz alta nesse momento?';
  }

  @override
  String hintEnding1(String who) {
    return 'Como «$who» vence isso no fim: com força ou com uma ideia?';
  }

  @override
  String get hintEnding2 => 'Quem ajuda, mesmo sem precisar?';

  @override
  String hintEnding3(String who) {
    return 'O que «$who» faz primeiro quando tudo acaba?';
  }

  @override
  String get hintEnding4 => 'O que é diferente no fim em relação ao começo?';

  @override
  String hintEnding5(String who) {
    return 'Para onde «$who» volta e quem está esperando lá?';
  }

  @override
  String get hintEnding6 => 'Qual é a última frase antes de a luz acender?';

  @override
  String get globeLoading => 'Preparando o planeta…';

  @override
  String get globeLoadFailed => 'Não foi possível carregar o planeta.';

  @override
  String get globeTitle => 'De onde será o conto?';

  @override
  String get globeStored => 'Contos baixados';

  @override
  String get globeHintFar =>
      'Gire o planeta ou toque num país. Os países verdes já têm contos da nossa coleção; os cinzas, ainda não.';

  @override
  String get globeHintNear =>
      'Toque num país ou num monumento. Os países verdes já têm contos da nossa coleção; os cinzas, ainda não.';

  @override
  String get globeWhole => 'Planeta inteiro';

  @override
  String get globeZoomIn => 'Aproximar';

  @override
  String get globeZoomOut => 'Afastar';

  @override
  String globeZoomToRegion(String name) {
    return 'Aproximar: $name →';
  }

  @override
  String get globeTellHere => 'Contar um conto daqui';

  @override
  String globeTellFrom(String place) {
    return 'Contar um conto de $place →';
  }

  @override
  String get globeOpenSea => 'Mar aberto';

  @override
  String globeRegionCountries(int n) {
    return '$n países juntos. Aproxime e escolha um.';
  }

  @override
  String get globeTurnToCountry => 'Gire o planeta para algum país.';

  @override
  String get globeSpin => 'Girar';

  @override
  String get globeNoTales => 'Daqui ainda não temos nenhum conto.';

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
      other: 'de $n contos',
      one: 'de $n conto',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs do pacote';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivos do pacote',
      one: '$n motivo do pacote',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Estamos preparando $_temp0 daqui para o pacote $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0 grátis';
  }

  @override
  String cardFree(int n) {
    return '$n grátis';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n nas partes $region $range',
      one: '$n na parte $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'você tem $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'mais $n a caminho',
      one: 'mais $n a caminho',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Aguardando a loja…';

  @override
  String offerDownloading(int percent) {
    return 'Baixando contos… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Comprar $name: $_temp0 por $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Baixar $name: $_temp0 grátis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Baixar $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Baixar $name';
  }

  @override
  String get errDownloadTales => 'Não foi possível baixar os contos.';

  @override
  String get errDownloadScenes => 'Não foi possível baixar as imagens.';

  @override
  String get errNoDownloads => 'O download não está disponível aqui.';

  @override
  String get errOffline =>
      'Sem conexão com a internet — tente de novo quando tiver sinal.';

  @override
  String get errCannotBuy => 'Esta parte não pode ser comprada agora.';

  @override
  String get buyPending =>
      'A compra aguarda aprovação. A parte será baixada assim que for aprovada.';

  @override
  String get buyFailed => 'A compra não foi concluída.';

  @override
  String get restoreNone => 'Esta conta não tem compras.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n partes restauradas. Você pode baixá-las pelo planeta.',
      one: '$n parte restaurada. Você pode baixá-la pelo planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Não foi possível restaurar as compras — tente de novo quando tiver sinal.';

  @override
  String get narrationGone => 'Este conto não está mais montado.';

  @override
  String get narrationNew => 'Montar um novo';

  @override
  String narrationTitle(int index, int total) {
    return 'Você conta — $index de $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Como emendar: $bridge';
  }

  @override
  String get narrationSituation =>
      'O que está acontecendo agora? (opcional, dá para ditar)';

  @override
  String get narrationHintNote =>
      'Dica — não leia em voz alta, só use como ponto de partida.';

  @override
  String get narrationSoundsNote =>
      'Sons — toque quando combinarem com a história.';

  @override
  String get moodTense => 'tensão';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'Procurando…';

  @override
  String get narrationHint => 'Dê uma dica';

  @override
  String get narrationMoreHint => 'Mais uma';

  @override
  String get narrationBack => 'Voltar';

  @override
  String get narrationEnd => 'Fim';

  @override
  String get narrationNext => 'Avançar →';

  @override
  String get narrationGoodnight => 'Boa noite.';

  @override
  String get narrationEndNote =>
      'Ainda não sabemos fazer uma imagem final nem salvar na Biblioteca — este conto não vai a lugar nenhum, fica entre vocês.';

  @override
  String get narrationClose => 'Fechar';

  @override
  String get ragFallback =>
      'O pacote ainda não tem nada para isso; uma dica geral:';

  @override
  String get ragNoModel => 'O modelo de dicas não está nesta versão.';

  @override
  String get ragHintGeneral => 'geral';

  @override
  String get ragHintMotif => 'do motivo';

  @override
  String get captionExact => 'ilustração · para este motivo';

  @override
  String get captionSimilar => 'ilustração · cena parecida';

  @override
  String get captionCard =>
      'carta do motivo · ainda não temos cena para este passo';

  @override
  String get storageTitle => 'Contos baixados';

  @override
  String get storageEmpty =>
      'Ainda nada — mais contos são baixados pelo planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pacotes',
      one: '$n pacote',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Cenas de $name';
  }

  @override
  String get storageFreeTier => 'grátis';

  @override
  String get storageBoughtTier => 'comprado';

  @override
  String get storageDelete => 'Excluir';

  @override
  String get storageScenesSub => 'Uma imagem para cada passo da narração';

  @override
  String get storageDownload => 'Baixar';

  @override
  String get storageAllUsed => 'Tudo foi usado nos últimos 30 dias.';

  @override
  String storageFreed(String size) {
    return '$size liberados.';
  }

  @override
  String get storageFreeUp => 'Liberar espaço (sem uso há 30 dias)';

  @override
  String get storageRestoring => 'Restaurando compras…';

  @override
  String get storageRestore => 'Restaurar compras';

  @override
  String get osnovaTitle => 'Roteiro';

  @override
  String get osnovaSummary => 'O conto em resumo';

  @override
  String get osnovaCharacters => 'Personagens';

  @override
  String get osnovaTask => 'Missão';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'Recomeçar';

  @override
  String get osnovaTell => 'Vou contar →';

  @override
  String get outlineHero => 'O herói';

  @override
  String get castFox => 'A raposa esperta';

  @override
  String get castSmithSon => 'O filho do ferreiro';

  @override
  String get castMill => 'O moinho falante';

  @override
  String get castGooseGirl => 'A guardadora de gansos';

  @override
  String get castBrothers => 'Os três irmãos';

  @override
  String get castClockworkPrincess => 'A princesa relojoeira';

  @override
  String get castOwl => 'A coruja sábia';

  @override
  String get castBlacksmith => 'A velha ferreira';

  @override
  String get castDragon => 'O pequeno dragão';

  @override
  String get castWaterSprite => 'O espírito da água';

  @override
  String get castFourPrincesses => 'As quatro princesas';

  @override
  String get castTravelingTailor => 'O alfaiate andarilho';

  @override
  String get castTalkingCat => 'O gato falante';

  @override
  String get castForestHermit => 'O eremita da floresta';

  @override
  String get castC0AndersenTheShadow => 'O senhor que já foi uma sombra';

  @override
  String get castC1GrimmTheGooseGirl => 'A criada traiçoeira';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'O rei do castelo assombrado';

  @override
  String get castC3AndersenTheShadow => 'A sombra esperta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'A princesa bela, mas pouco esperta';

  @override
  String get castC5AndersenTheRedShoes => 'O anjo que perdoa no fim';

  @override
  String get castC6GrimmRumpelstiltskin => 'A filha esperta do moleiro';

  @override
  String get castC7PerraultLittleRedRidingHood => 'A avó que abre a porta';

  @override
  String get castC8PerraultLittleThumb => 'Uma mãe entre a miséria e o amor';

  @override
  String get castC9PerraultIntroduction => 'A mulher paciente';

  @override
  String get castC10AndersenTheRealPrincess => 'O rei que apoia o filho';

  @override
  String get castC11GrimmLilyAndTheLion => 'A filha que cumpre a palavra';

  @override
  String get castC12AndersenTheRealPrincess =>
      'O príncipe que procura a princesa de verdade';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'A menina dos fósforos';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'O cortesão que se cala';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'O servo fiel prepara um banquete';

  @override
  String get castC16PerraultTheFairy => 'A filha presunçosa';

  @override
  String get castC17GrimmFirstStory => 'A viúva que quer nove caudas';

  @override
  String get motifTaskWine => 'Quem vai beber uma adega de vinho';

  @override
  String get motifTaskDiamonds => 'Um voo atrás de diamantes';

  @override
  String get motifTaskRingDuck => 'O anel dentro do pato';

  @override
  String get motifTaskGiants => 'Enganar os gigantes';

  @override
  String get motifTaskTomThumb => 'A fuga do Pequeno Polegar';

  @override
  String get motifTaskSwineherd => 'Conquistar o coração da princesa';

  @override
  String get motifTaskBell => 'O sino misterioso na floresta';

  @override
  String get motifTaskGoldenObject => 'Um presente que não pode ser mal usado';

  @override
  String get motifTaskPebbles => 'Um caminho de pedrinhas';

  @override
  String get motifProblemFoxPride => 'O orgulho da raposa';

  @override
  String get motifProblemLazySister => 'A irmã preguiçosa';

  @override
  String get motifProblemWitchBoots => 'A bruxa com botas de sete léguas';

  @override
  String get motifProblemTailorDoubt => 'Ninguém acredita nele';

  @override
  String get motifProblemLions => 'Leões famintos no portão';

  @override
  String get motifProblemEagle => 'A águia e o anão';

  @override
  String get motifProblemTruth => 'O animal mágico revela a verdade';

  @override
  String get motifProblemOldHouse => 'Ninguém quer a casa velha';

  @override
  String get motifProblemBreadcrumbs => 'Os pássaros comeram as migalhas';

  @override
  String get motifEndingTrickWins => 'A esperteza vence';

  @override
  String get motifEndingTruthChild => 'A criança diz a verdade';

  @override
  String get motifEndingNewHome => 'Um novo lar, velhos amigos';

  @override
  String get motifEndingHappyTogether => 'Felizes juntos para sempre';

  @override
  String get motifEndingKissWakes => 'Um beijo desperta o reino';

  @override
  String get motifEndingLeapfrog => 'A esperteza salta mais alto';

  @override
  String get motifEndingCurseBroken => 'A maldição foi quebrada';

  @override
  String get motifEndingWelcomedHome => 'Recebido em casa';

  @override
  String get motifEndingSlipper => 'O sapatinho perdido';
}

/// The translations for Portuguese, as used in Portugal (`pt_PT`).
class AppLocalizationsPtPt extends AppLocalizationsPt {
  AppLocalizationsPtPt() : super('pt_PT');

  @override
  String get castTitle => 'Quem vai estar no conto?';

  @override
  String get castHint =>
      'Toca numa carta para mudar de personagem. Remove a carta com o X. A música e os sons vêm sempre prontos do pacote do país; só a imagem da personagem por vezes é desenhada um instante depois.';

  @override
  String get castAdd => 'Adicionar personagem';

  @override
  String get castCount => 'Elenco:';

  @override
  String get castShuffleAll => 'Baralhar tudo';

  @override
  String get castContinue => 'Continuar →';

  @override
  String get shuffle => 'Baralhar';

  @override
  String get motifTaskTitle => 'Que missão?';

  @override
  String get motifProblemTitle => 'Que problema?';

  @override
  String get motifEndingTitle => 'Que final?';

  @override
  String get motifTaskCaption =>
      'Toca numa carta para escolher a missão do herói.';

  @override
  String get motifProblemCaption =>
      'Toca numa carta para escolher um obstáculo ou um vilão.';

  @override
  String get motifEndingCaption =>
      'Toca numa carta para escolher um final feliz.';

  @override
  String get beatCastTitle => 'Quem está na história';

  @override
  String get beatTaskTitle => 'O que o herói se propôs';

  @override
  String get beatProblemTitle => 'O que se atravessou no caminho';

  @override
  String get beatEndingTitle => 'Como acabou';

  @override
  String get beatCastCaption =>
      'Apresenta as personagens: onde estão, como são, o que têm de especial.';

  @override
  String get beatTaskCaption => 'Diz o que o herói quer e porque partiu.';

  @override
  String get beatProblemCaption =>
      'Põe algo no caminho dele. Que durante algum tempo pareça que não vai correr bem.';

  @override
  String get beatEndingCaption =>
      'Leva a história até ao fim. Sem pressa: o final é o que a criança mais recorda.';

  @override
  String get hintHero => 'o herói';

  @override
  String hintCast1(String who) {
    return 'Como é «$who» quando aparece pela primeira vez?';
  }

  @override
  String hintCast2(String who) {
    return 'O que está «$who» a fazer mesmo antes de toda a história começar?';
  }

  @override
  String hintCast3(String who) {
    return 'De que tem medo «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Como percebes que «$who» vem a chegar?';
  }

  @override
  String get hintCast5 => 'Quais deles se conhecem há muito tempo, e de onde?';

  @override
  String get hintCast6 => 'Que tempo faz quando se encontram?';

  @override
  String hintCast7(String who) {
    return 'O que tem «$who» no bolso?';
  }

  @override
  String hintTask1(String who) {
    return 'Quando percebe «$who» que tem de arregaçar as mangas?';
  }

  @override
  String hintTask2(String who) {
    return 'Quem deu o conselho, e porque o ouve «$who»?';
  }

  @override
  String hintTask3(String who) {
    return 'O que tem de deixar em casa «$who»?';
  }

  @override
  String get hintTask4 => 'Quão comprido é o caminho e por onde passa?';

  @override
  String hintTask5(String who) {
    return 'O que promete «$who» antes de partir?';
  }

  @override
  String get hintTask6 => 'Porque não pode mais ninguém fazê-lo?';

  @override
  String get hintProblem1 => 'Nesse momento ouve-se um som: qual?';

  @override
  String get hintProblem2 => 'O que corre mal primeiro?';

  @override
  String hintProblem3(String who) {
    return 'O que tenta «$who» primeiro, e porque não resulta?';
  }

  @override
  String get hintProblem4 => 'Quem se recusa a ajudar, podendo fazê-lo?';

  @override
  String get hintProblem5 => 'O que aconteceria se todos desistissem agora?';

  @override
  String get hintProblem6 => 'Há algo de triste nesse obstáculo?';

  @override
  String hintProblem7(String who) {
    return 'O que diz «$who» em voz alta nesse momento?';
  }

  @override
  String hintEnding1(String who) {
    return 'Como vence «$who» isso no fim: com força ou com uma ideia?';
  }

  @override
  String get hintEnding2 => 'Quem ajuda, mesmo sem ser obrigado?';

  @override
  String hintEnding3(String who) {
    return 'O que faz «$who» primeiro quando tudo acaba?';
  }

  @override
  String get hintEnding4 => 'O que é diferente no fim em relação ao princípio?';

  @override
  String hintEnding5(String who) {
    return 'Para onde regressa «$who» e quem o espera lá?';
  }

  @override
  String get hintEnding6 => 'Qual é a última frase antes de a luz acender?';

  @override
  String get globeLoading => 'A preparar o planeta…';

  @override
  String get globeLoadFailed => 'Não foi possível carregar o planeta.';

  @override
  String get globeTitle => 'De onde será o conto?';

  @override
  String get globeStored => 'Contos descarregados';

  @override
  String get globeHintFar =>
      'Roda o planeta ou toca num país. Os países verdes já têm contos da nossa coleção; os cinzentos ainda não.';

  @override
  String get globeHintNear =>
      'Toca num país ou num monumento. Os países verdes já têm contos da nossa coleção; os cinzentos ainda não.';

  @override
  String get globeWhole => 'Planeta inteiro';

  @override
  String get globeZoomIn => 'Aproximar';

  @override
  String get globeZoomOut => 'Afastar';

  @override
  String globeZoomToRegion(String name) {
    return 'Aproximar: $name →';
  }

  @override
  String get globeTellHere => 'Contar um conto daqui';

  @override
  String globeTellFrom(String place) {
    return 'Contar um conto de $place →';
  }

  @override
  String get globeOpenSea => 'Mar alto';

  @override
  String globeRegionCountries(int n) {
    return '$n países juntos. Aproxima e escolhe um.';
  }

  @override
  String get globeTurnToCountry => 'Roda o planeta para algum país.';

  @override
  String get globeSpin => 'Rodar';

  @override
  String get globeNoTales => 'Daqui ainda não temos nenhum conto.';

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
      other: 'de $n contos',
      one: 'de $n conto',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs do pacote';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motivos do pacote',
      one: '$n motivo do pacote',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Estamos a preparar $_temp0 daqui para o pacote $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return '$_temp0 grátis';
  }

  @override
  String cardFree(int n) {
    return '$n grátis';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n nas partes $region $range',
      one: '$n na parte $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'tens $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'mais $n a caminho',
      one: 'mais $n a caminho',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'À espera da loja…';

  @override
  String offerDownloading(int percent) {
    return 'A descarregar contos… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Comprar $name: $_temp0 por $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Descarregar $name: $_temp0 grátis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n contos',
      one: '$n conto',
    );
    return 'Descarregar $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Descarregar $name';
  }

  @override
  String get errDownloadTales => 'Não foi possível descarregar os contos.';

  @override
  String get errDownloadScenes => 'Não foi possível descarregar as imagens.';

  @override
  String get errNoDownloads => 'A transferência não está disponível aqui.';

  @override
  String get errOffline =>
      'Sem ligação à internet — tenta de novo quando tiveres rede.';

  @override
  String get errCannotBuy => 'Esta parte não pode ser comprada neste momento.';

  @override
  String get buyPending =>
      'A compra aguarda aprovação. A parte será descarregada assim que for aprovada.';

  @override
  String get buyFailed => 'A compra não foi concluída.';

  @override
  String get restoreNone => 'Esta conta não tem compras.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n partes restauradas. Podes descarregá-las a partir do planeta.',
      one: '$n parte restaurada. Podes descarregá-la a partir do planeta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Não foi possível restaurar as compras — tenta de novo quando tiveres rede.';

  @override
  String get narrationGone => 'Este conto já não está montado.';

  @override
  String get narrationNew => 'Montar um novo';

  @override
  String narrationTitle(int index, int total) {
    return 'Estás a contar — $index de $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Como ligar: $bridge';
  }

  @override
  String get narrationSituation =>
      'O que se passa agora? (opcional, podes ditar)';

  @override
  String get narrationHintNote =>
      'Pista — não a leias em voz alta, usa-a só como ponto de partida.';

  @override
  String get narrationSoundsNote =>
      'Sons — toca-os quando combinarem com a história.';

  @override
  String get moodTense => 'tensão';

  @override
  String get moodCalm => 'calma';

  @override
  String get narrationSearching => 'A procurar…';

  @override
  String get narrationHint => 'Dá-me uma pista';

  @override
  String get narrationMoreHint => 'Mais uma';

  @override
  String get narrationBack => 'Voltar';

  @override
  String get narrationEnd => 'Fim';

  @override
  String get narrationNext => 'Seguinte →';

  @override
  String get narrationGoodnight => 'Boa noite.';

  @override
  String get narrationEndNote =>
      'Ainda não sabemos fazer uma imagem final nem guardar na Biblioteca — este conto não vai a lado nenhum, fica entre vós.';

  @override
  String get narrationClose => 'Fechar';

  @override
  String get ragFallback =>
      'O pacote ainda não tem nada para isto; uma pista geral:';

  @override
  String get ragNoModel => 'O modelo de pistas não está nesta versão.';

  @override
  String get ragHintGeneral => 'geral';

  @override
  String get ragHintMotif => 'do motivo';

  @override
  String get captionExact => 'ilustração · para este motivo';

  @override
  String get captionSimilar => 'ilustração · cena semelhante';

  @override
  String get captionCard =>
      'carta do motivo · ainda não temos cena para este passo';

  @override
  String get storageTitle => 'Contos descarregados';

  @override
  String get storageEmpty =>
      'Ainda nada — mais contos são descarregados a partir do planeta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pacotes',
      one: '$n pacote',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Cenas de $name';
  }

  @override
  String get storageFreeTier => 'grátis';

  @override
  String get storageBoughtTier => 'comprado';

  @override
  String get storageDelete => 'Eliminar';

  @override
  String get storageScenesSub => 'Uma imagem para cada passo da narração';

  @override
  String get storageDownload => 'Descarregar';

  @override
  String get storageAllUsed => 'Tudo foi usado nos últimos 30 dias.';

  @override
  String storageFreed(String size) {
    return '$size libertados.';
  }

  @override
  String get storageFreeUp => 'Libertar espaço (sem uso há 30 dias)';

  @override
  String get storageRestoring => 'A restaurar compras…';

  @override
  String get storageRestore => 'Restaurar compras';

  @override
  String get osnovaTitle => 'Guião';

  @override
  String get osnovaSummary => 'O conto em resumo';

  @override
  String get osnovaCharacters => 'Personagens';

  @override
  String get osnovaTask => 'Missão';

  @override
  String get osnovaProblem => 'Problema';

  @override
  String get osnovaEnding => 'Final';

  @override
  String get osnovaAgain => 'Recomeçar';

  @override
  String get osnovaTell => 'Vou contar →';

  @override
  String get outlineHero => 'O herói';

  @override
  String get castFox => 'A raposa astuta';

  @override
  String get castSmithSon => 'O filho do ferreiro';

  @override
  String get castMill => 'O moinho falante';

  @override
  String get castGooseGirl => 'A guardadora de gansos';

  @override
  String get castBrothers => 'Os três irmãos';

  @override
  String get castClockworkPrincess => 'A princesa relojoeira';

  @override
  String get castOwl => 'A coruja sábia';

  @override
  String get castBlacksmith => 'A velha ferreira';

  @override
  String get castDragon => 'O pequeno dragão';

  @override
  String get castWaterSprite => 'O espírito da água';

  @override
  String get castFourPrincesses => 'As quatro princesas';

  @override
  String get castTravelingTailor => 'O alfaiate ambulante';

  @override
  String get castTalkingCat => 'O gato falante';

  @override
  String get castForestHermit => 'O eremita da floresta';

  @override
  String get castC0AndersenTheShadow => 'O senhor que já foi uma sombra';

  @override
  String get castC1GrimmTheGooseGirl => 'A criada traiçoeira';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'O rei do castelo assombrado';

  @override
  String get castC3AndersenTheShadow => 'A sombra astuta';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'A princesa bela, mas pouco esperta';

  @override
  String get castC5AndersenTheRedShoes => 'O anjo que perdoa no fim';

  @override
  String get castC6GrimmRumpelstiltskin => 'A filha esperta do moleiro';

  @override
  String get castC7PerraultLittleRedRidingHood => 'A avó que abre a porta';

  @override
  String get castC8PerraultLittleThumb => 'Uma mãe entre a miséria e o amor';

  @override
  String get castC9PerraultIntroduction => 'A mulher paciente';

  @override
  String get castC10AndersenTheRealPrincess => 'O rei que apoia o filho';

  @override
  String get castC11GrimmLilyAndTheLion => 'A filha que cumpre a palavra';

  @override
  String get castC12AndersenTheRealPrincess =>
      'O príncipe que procura a verdadeira princesa';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'A menina dos fósforos';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'O cortesão que se cala';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'O servo fiel prepara um banquete';

  @override
  String get castC16PerraultTheFairy => 'A filha presunçosa';

  @override
  String get castC17GrimmFirstStory => 'A viúva que quer nove caudas';

  @override
  String get motifTaskWine => 'Quem vai beber uma adega de vinho';

  @override
  String get motifTaskDiamonds => 'Um voo atrás de diamantes';

  @override
  String get motifTaskRingDuck => 'O anel dentro do pato';

  @override
  String get motifTaskGiants => 'Enganar os gigantes';

  @override
  String get motifTaskTomThumb => 'A fuga do Polegarzinho';

  @override
  String get motifTaskSwineherd => 'Conquistar o coração da princesa';

  @override
  String get motifTaskBell => 'O sino misterioso na floresta';

  @override
  String get motifTaskGoldenObject => 'Uma dádiva que não pode ser mal usada';

  @override
  String get motifTaskPebbles => 'Um caminho de pedrinhas';

  @override
  String get motifProblemFoxPride => 'O orgulho da raposa';

  @override
  String get motifProblemLazySister => 'A irmã preguiçosa';

  @override
  String get motifProblemWitchBoots => 'A bruxa com botas de sete léguas';

  @override
  String get motifProblemTailorDoubt => 'Ninguém acredita nele';

  @override
  String get motifProblemLions => 'Leões esfomeados ao portão';

  @override
  String get motifProblemEagle => 'A águia e o anão';

  @override
  String get motifProblemTruth => 'O animal mágico revela a verdade';

  @override
  String get motifProblemOldHouse => 'Ninguém quer a casa velha';

  @override
  String get motifProblemBreadcrumbs => 'Os pássaros comeram as migalhas';

  @override
  String get motifEndingTrickWins => 'A astúcia vence';

  @override
  String get motifEndingTruthChild => 'A criança diz a verdade';

  @override
  String get motifEndingNewHome => 'Um novo lar, velhos amigos';

  @override
  String get motifEndingHappyTogether => 'Felizes juntos para sempre';

  @override
  String get motifEndingKissWakes => 'Um beijo desperta o reino';

  @override
  String get motifEndingLeapfrog => 'A astúcia salta mais alto';

  @override
  String get motifEndingCurseBroken => 'A maldição foi quebrada';

  @override
  String get motifEndingWelcomedHome => 'Recebido em casa';

  @override
  String get motifEndingSlipper => 'O sapatinho perdido';
}
