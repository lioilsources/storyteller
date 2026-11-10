// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get castTitle => '동화에 누가 나올까요?';

  @override
  String get castHint =>
      '카드를 누르면 다른 캐릭터로 바뀝니다. 카드는 X로 지울 수 있습니다. 음악과 소리는 항상 나라 팩에서 준비되어 있고, 캐릭터 그림만 가끔 조금 늦게 그려집니다.';

  @override
  String get castAdd => '캐릭터 추가';

  @override
  String get castCount => '등장인물:';

  @override
  String get castShuffleAll => '모두 섞기';

  @override
  String get castContinue => '계속 →';

  @override
  String get shuffle => '섞기';

  @override
  String get motifTaskTitle => '어떤 임무?';

  @override
  String get motifProblemTitle => '어떤 문제?';

  @override
  String get motifEndingTitle => '어떤 결말?';

  @override
  String get motifTaskCaption => '카드를 눌러 주인공의 임무를 고르세요.';

  @override
  String get motifProblemCaption => '카드를 눌러 장애물이나 악당을 고르세요.';

  @override
  String get motifEndingCaption => '카드를 눌러 행복한 결말을 고르세요.';

  @override
  String get beatCastTitle => '누가 나오는지';

  @override
  String get beatTaskTitle => '주인공이 마음먹은 것';

  @override
  String get beatProblemTitle => '앞을 가로막은 것';

  @override
  String get beatEndingTitle => '어떻게 끝났는지';

  @override
  String get beatCastCaption => '등장인물을 소개해 주세요. 어디에 있고, 어떻게 생겼고, 무엇이 특별한지.';

  @override
  String get beatTaskCaption => '주인공이 무엇을 원하고 왜 길을 떠났는지 말해 주세요.';

  @override
  String get beatProblemCaption => '주인공의 길에 무언가를 놓아 주세요. 한동안은 안 될 것처럼 보이게요.';

  @override
  String get beatEndingCaption => '끝까지 이끌어 주세요. 서두르지 마세요. 아이는 결말을 가장 오래 기억합니다.';

  @override
  String get hintHero => '주인공';

  @override
  String hintCast1(String who) {
    return '처음 나타났을 때 「$who」는 어떤 모습인가요?';
  }

  @override
  String hintCast2(String who) {
    return '이야기가 시작되기 직전에 「$who」는 무엇을 하고 있나요?';
  }

  @override
  String hintCast3(String who) {
    return '「$who」는 무엇을 무서워하나요?';
  }

  @override
  String hintCast4(String who) {
    return '「$who」가 오고 있다는 것을 어떻게 알 수 있나요?';
  }

  @override
  String get hintCast5 => '이 중 누가 오래전부터 서로 알고 지냈고, 어디에서 알게 되었나요?';

  @override
  String get hintCast6 => '이들이 만날 때 날씨는 어떤가요?';

  @override
  String hintCast7(String who) {
    return '「$who」의 주머니에는 무엇이 들어 있나요?';
  }

  @override
  String hintTask1(String who) {
    return '「$who」는 언제 나서야 한다는 것을 깨닫나요?';
  }

  @override
  String hintTask2(String who) {
    return '누가 조언해 주었고, 「$who」는 왜 그 말을 듣나요?';
  }

  @override
  String hintTask3(String who) {
    return '「$who」는 집에 무엇을 두고 가야 하나요?';
  }

  @override
  String get hintTask4 => '길은 얼마나 멀고 무엇을 지나가나요?';

  @override
  String hintTask5(String who) {
    return '떠나기 전에 「$who」는 무엇을 다짐하나요?';
  }

  @override
  String get hintTask6 => '왜 다른 사람은 이 일을 할 수 없나요?';

  @override
  String get hintProblem1 => '그 순간 어떤 소리가 들립니다. 어떤 소리일까요?';

  @override
  String get hintProblem2 => '가장 먼저 무엇이 잘못되나요?';

  @override
  String hintProblem3(String who) {
    return '「$who」는 먼저 무엇을 시도하고, 왜 잘 안 되나요?';
  }

  @override
  String get hintProblem4 => '도울 수 있는데도 돕기를 거절하는 사람은 누구인가요?';

  @override
  String get hintProblem5 => '지금 모두가 포기하면 어떻게 될까요?';

  @override
  String get hintProblem6 => '그 장애물에는 슬픈 구석이 있나요?';

  @override
  String hintProblem7(String who) {
    return '그 순간 「$who」는 소리 내어 뭐라고 말하나요?';
  }

  @override
  String hintEnding1(String who) {
    return '「$who」는 마침내 무엇으로 그것을 이겨내나요? 힘인가요, 아이디어인가요?';
  }

  @override
  String get hintEnding2 => '그럴 필요가 없는데도 도와주는 사람은 누구인가요?';

  @override
  String hintEnding3(String who) {
    return '모든 것이 끝나고 「$who」가 가장 먼저 하는 일은 무엇인가요?';
  }

  @override
  String get hintEnding4 => '처음과 달라진 점은 무엇인가요?';

  @override
  String hintEnding5(String who) {
    return '「$who」는 어디로 돌아가고, 거기서 누가 기다리나요?';
  }

  @override
  String get hintEnding6 => '불이 켜지기 전 마지막 한마디는 무엇일까요?';

  @override
  String get globeLoading => '행성을 준비하는 중…';

  @override
  String get globeLoadFailed => '행성을 불러오지 못했습니다.';

  @override
  String get globeTitle => '동화는 어느 나라 이야기일까요?';

  @override
  String get globeStored => '내려받은 동화';

  @override
  String get globeHintFar =>
      '행성을 돌리거나 나라를 눌러 보세요. 초록색 나라는 우리 컬렉션의 동화가 있고, 회색 나라는 아직 없습니다.';

  @override
  String get globeHintNear =>
      '나라나 건물을 눌러 보세요. 초록색 나라는 우리 컬렉션의 동화가 있고, 회색 나라는 아직 없습니다.';

  @override
  String get globeWhole => '행성 전체';

  @override
  String get globeZoomIn => '확대';

  @override
  String get globeZoomOut => '축소';

  @override
  String globeZoomToRegion(String name) {
    return '$name 확대 →';
  }

  @override
  String get globeTellHere => '여기 이야기 들려주기';

  @override
  String globeTellFrom(String place) {
    return '$place 이야기 들려주기 →';
  }

  @override
  String get globeOpenSea => '넓은 바다';

  @override
  String globeRegionCountries(int n) {
    return '$n개 나라가 함께 있습니다. 확대해서 하나를 고르세요.';
  }

  @override
  String get globeTurnToCountry => '행성을 어느 나라 쪽으로 돌려 보세요.';

  @override
  String get globeSpin => '돌리기';

  @override
  String get globeNoTales => '아직 이곳의 동화가 없습니다.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '모티프 $n개',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편에서',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + 팩에서 $packMotifs개';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '팩에서 모티프 $n개',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n편');
    return '이곳의 동화 $_temp0을 $region 팩에 담기 위해 준비 중입니다.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편',
    );
    return '$_temp0 무료';
  }

  @override
  String cardFree(int n) {
    return '무료 $n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range에 $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return '보유 $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n편 더 준비 중',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => '스토어를 기다리는 중…';

  @override
  String offerDownloading(int percent) {
    return '동화 내려받는 중… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편',
    );
    return '$name 구매: $_temp0, $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편',
    );
    return '$name 내려받기: $_temp0 무료 ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '동화 $n편',
    );
    return '$name 내려받기: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name 내려받기';
  }

  @override
  String get errDownloadTales => '동화를 내려받지 못했습니다.';

  @override
  String get errDownloadScenes => '그림을 내려받지 못했습니다.';

  @override
  String get errNoDownloads => '여기서는 내려받을 수 없습니다.';

  @override
  String get errOffline => '인터넷에 연결되어 있지 않습니다. 신호가 잡히면 다시 시도하세요.';

  @override
  String get errCannotBuy => '이 파트는 지금 구매할 수 없습니다.';

  @override
  String get buyPending => '구매 승인을 기다리는 중입니다. 승인되면 파트가 내려받아집니다.';

  @override
  String get buyFailed => '구매가 완료되지 않았습니다.';

  @override
  String get restoreNone => '이 계정에는 구매 내역이 없습니다.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n개 파트를 복원했습니다. 행성에서 내려받을 수 있습니다.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => '구매를 복원하지 못했습니다. 신호가 잡히면 다시 시도하세요.';

  @override
  String get narrationGone => '이 동화는 더 이상 구성되어 있지 않습니다.';

  @override
  String get narrationNew => '새로 구성하기';

  @override
  String narrationTitle(int index, int total) {
    return '들려주는 중 — $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return '이어 가는 법: $bridge';
  }

  @override
  String get narrationSituation => '지금 무슨 일이 일어나고 있나요? (선택 사항, 말로 입력 가능)';

  @override
  String get narrationHintNote => '힌트 — 소리 내어 읽지 말고 실마리로만 쓰세요.';

  @override
  String get narrationSoundsNote => '소리 — 이야기에 어울릴 때 재생하세요.';

  @override
  String get moodTense => '긴장';

  @override
  String get moodCalm => '평온';

  @override
  String get narrationSearching => '찾는 중…';

  @override
  String get narrationHint => '힌트 주세요';

  @override
  String get narrationMoreHint => '하나 더';

  @override
  String get narrationBack => '이전';

  @override
  String get narrationEnd => '끝';

  @override
  String get narrationNext => '다음 →';

  @override
  String get narrationGoodnight => '잘 자요.';

  @override
  String get narrationEndNote =>
      '마지막 그림과 라이브러리 저장은 아직 지원하지 않습니다. 이 동화는 어디로도 가지 않고 두 사람 사이에 남습니다.';

  @override
  String get narrationClose => '닫기';

  @override
  String get ragFallback => '팩에는 아직 이에 맞는 것이 없습니다. 일반적인 힌트입니다:';

  @override
  String get ragNoModel => '이 빌드에는 힌트 모델이 포함되어 있지 않습니다.';

  @override
  String get ragHintGeneral => '일반';

  @override
  String get ragHintMotif => '모티프용';

  @override
  String get captionExact => '일러스트 · 이 모티프용';

  @override
  String get captionSimilar => '일러스트 · 비슷한 장면';

  @override
  String get captionCard => '모티프 카드 · 이 단계의 장면은 아직 없습니다';

  @override
  String get storageTitle => '내려받은 동화';

  @override
  String get storageEmpty => '아직 없습니다. 더 많은 동화는 행성에서 내려받습니다.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '팩 $n개',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name 장면';
  }

  @override
  String get storageFreeTier => '무료';

  @override
  String get storageBoughtTier => '구매함';

  @override
  String get storageDelete => '삭제';

  @override
  String get storageScenesSub => '이야기의 각 단계마다 그림 한 장';

  @override
  String get storageDownload => '내려받기';

  @override
  String get storageAllUsed => '최근 30일 안에 모두 사용했습니다.';

  @override
  String storageFreed(String size) {
    return '$size를 확보했습니다.';
  }

  @override
  String get storageFreeUp => '공간 확보 (30일간 미사용)';

  @override
  String get storageRestoring => '구매 복원 중…';

  @override
  String get storageRestore => '구매 복원';

  @override
  String get osnovaTitle => '줄거리';

  @override
  String get osnovaSummary => '동화 한눈에 보기';

  @override
  String get osnovaCharacters => '등장인물';

  @override
  String get osnovaTask => '임무';

  @override
  String get osnovaProblem => '문제';

  @override
  String get osnovaEnding => '결말';

  @override
  String get osnovaAgain => '다시';

  @override
  String get osnovaTell => '들려줄게요 →';

  @override
  String get outlineHero => '주인공';

  @override
  String get castFox => '영리한 여우';

  @override
  String get castSmithSon => '대장장이의 아들';

  @override
  String get castMill => '말하는 물레방아';

  @override
  String get castGooseGirl => '거위 치는 소녀';

  @override
  String get castBrothers => '삼 형제';

  @override
  String get castClockworkPrincess => '시계공 공주';

  @override
  String get castOwl => '현명한 부엉이';

  @override
  String get castBlacksmith => '늙은 여자 대장장이';

  @override
  String get castDragon => '꼬마 용';

  @override
  String get castWaterSprite => '물의 정령';

  @override
  String get castFourPrincesses => '네 명의 공주';

  @override
  String get castTravelingTailor => '떠돌이 재단사';

  @override
  String get castTalkingCat => '말하는 고양이';

  @override
  String get castForestHermit => '숲속 은둔자';

  @override
  String get castC0AndersenTheShadow => '한때 그림자였던 나리';

  @override
  String get castC1GrimmTheGooseGirl => '배신하는 시녀';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => '유령 성을 가진 왕';

  @override
  String get castC3AndersenTheShadow => '꾀 많은 그림자';

  @override
  String get castC4PerraultRiquetWithTheTuft => '아름답지만 그리 영리하지 않은 공주';

  @override
  String get castC5AndersenTheRedShoes => '마지막에 용서하는 천사';

  @override
  String get castC6GrimmRumpelstiltskin => '방앗간 주인의 영리한 딸';

  @override
  String get castC7PerraultLittleRedRidingHood => '문을 열어 주는 할머니';

  @override
  String get castC8PerraultLittleThumb => '가난과 사랑 사이의 어머니';

  @override
  String get castC9PerraultIntroduction => '참을성 있는 여인';

  @override
  String get castC10AndersenTheRealPrincess => '아들을 지지하는 왕';

  @override
  String get castC11GrimmLilyAndTheLion => '약속을 지키는 딸';

  @override
  String get castC12AndersenTheRealPrincess => '진짜 공주를 찾는 왕자';

  @override
  String get castC13AndersenTheLittleMatchGirl => '성냥팔이 소녀';

  @override
  String get castC14AndersenTheEmperorSNewClothes => '입을 다무는 신하';

  @override
  String get castC15PerraultRiquetWithTheTuft => '잔치를 준비하는 충직한 하인';

  @override
  String get castC16PerraultTheFairy => '잘난 척하는 딸';

  @override
  String get castC17GrimmFirstStory => '꼬리 아홉 개를 원하는 과부';

  @override
  String get motifTaskWine => '누가 포도주 저장고를 다 마실까';

  @override
  String get motifTaskDiamonds => '다이아몬드를 찾아 떠나는 비행';

  @override
  String get motifTaskRingDuck => '오리 속의 반지';

  @override
  String get motifTaskGiants => '거인들을 속이기';

  @override
  String get motifTaskTomThumb => '엄지 동자의 탈출';

  @override
  String get motifTaskSwineherd => '공주의 마음을 얻기';

  @override
  String get motifTaskBell => '숲속의 수수께끼 종';

  @override
  String get motifTaskGoldenObject => '함부로 써서는 안 되는 선물';

  @override
  String get motifTaskPebbles => '조약돌 길';

  @override
  String get motifProblemFoxPride => '여우의 교만';

  @override
  String get motifProblemLazySister => '게으른 자매';

  @override
  String get motifProblemWitchBoots => '칠 리 장화를 신은 마녀';

  @override
  String get motifProblemTailorDoubt => '아무도 그를 믿지 않는다';

  @override
  String get motifProblemLions => '성문 앞의 굶주린 사자들';

  @override
  String get motifProblemEagle => '독수리와 난쟁이';

  @override
  String get motifProblemTruth => '마법의 동물이 진실을 밝힌다';

  @override
  String get motifProblemOldHouse => '아무도 낡은 집을 원하지 않는다';

  @override
  String get motifProblemBreadcrumbs => '새들이 빵 부스러기를 먹어 버렸다';

  @override
  String get motifEndingTrickWins => '꾀가 이긴다';

  @override
  String get motifEndingTruthChild => '아이가 진실을 말한다';

  @override
  String get motifEndingNewHome => '새 보금자리, 오랜 친구들';

  @override
  String get motifEndingHappyTogether => '영원히 행복하게 함께';

  @override
  String get motifEndingKissWakes => '입맞춤이 왕국을 깨운다';

  @override
  String get motifEndingLeapfrog => '꾀가 가장 높이 뛴다';

  @override
  String get motifEndingCurseBroken => '저주가 풀렸다';

  @override
  String get motifEndingWelcomedHome => '집에서 환영받다';

  @override
  String get motifEndingSlipper => '잃어버린 신발';
}
