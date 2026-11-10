// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get castTitle => 'おはなしに出てくるのはだれ？';

  @override
  String get castHint =>
      'カードをタップすると別のキャラクターに変わります。×でカードを外せます。音楽と効果音はいつも国のパックから用意済みで、キャラクターの絵だけ少し遅れて描かれることがあります。';

  @override
  String get castAdd => 'キャラクターを追加';

  @override
  String get castCount => 'キャスト：';

  @override
  String get castShuffleAll => 'すべてシャッフル';

  @override
  String get castContinue => '次へ →';

  @override
  String get shuffle => 'シャッフル';

  @override
  String get motifTaskTitle => 'どんな使命？';

  @override
  String get motifProblemTitle => 'どんな問題？';

  @override
  String get motifEndingTitle => 'どんな結末？';

  @override
  String get motifTaskCaption => 'カードをタップして、主人公の使命を選びましょう。';

  @override
  String get motifProblemCaption => 'カードをタップして、障害や悪者を選びましょう。';

  @override
  String get motifEndingCaption => 'カードをタップして、ハッピーエンドを選びましょう。';

  @override
  String get beatCastTitle => '登場するのはだれ';

  @override
  String get beatTaskTitle => '主人公が決意したこと';

  @override
  String get beatProblemTitle => '行く手をはばんだもの';

  @override
  String get beatEndingTitle => 'どうなったか';

  @override
  String get beatCastCaption => '登場人物を紹介しましょう。どこにいて、どんな姿で、何が特別なのか。';

  @override
  String get beatTaskCaption => '主人公が何を望み、なぜ旅に出たのかを話しましょう。';

  @override
  String get beatProblemCaption => '主人公の行く手に何かを置きましょう。しばらくは無理そうに見えるように。';

  @override
  String get beatEndingCaption => '最後まで導きましょう。急がないで。子どもは結末をいちばんよく覚えています。';

  @override
  String get hintHero => '主人公';

  @override
  String hintCast1(String who) {
    return '初めて現れたとき、「$who」はどんな姿をしていますか？';
  }

  @override
  String hintCast2(String who) {
    return '物語が始まる直前、「$who」は何をしていますか？';
  }

  @override
  String hintCast3(String who) {
    return '「$who」は何をこわがっていますか？';
  }

  @override
  String hintCast4(String who) {
    return '「$who」が来るのは、何でわかりますか？';
  }

  @override
  String get hintCast5 => 'この中で、昔からの知り合いなのはだれとだれ？どこで知り合ったのでしょう。';

  @override
  String get hintCast6 => 'みんなが出会うとき、天気はどうですか？';

  @override
  String hintCast7(String who) {
    return '「$who」はポケットに何を持っていますか？';
  }

  @override
  String hintTask1(String who) {
    return '「$who」はいつ、やるしかないと気づきますか？';
  }

  @override
  String hintTask2(String who) {
    return 'だれが助言をして、「$who」はなぜそれに従うのですか？';
  }

  @override
  String hintTask3(String who) {
    return '「$who」は家に何を置いていかなければなりませんか？';
  }

  @override
  String get hintTask4 => '道のりはどのくらい長くて、何を越えていきますか？';

  @override
  String hintTask5(String who) {
    return '出発する前に、「$who」は何を誓いますか？';
  }

  @override
  String get hintTask6 => 'なぜほかの人にはできないのでしょう。';

  @override
  String get hintProblem1 => 'そのとき、音が聞こえます。どんな音でしょう？';

  @override
  String get hintProblem2 => '最初にうまくいかなくなるのは何ですか？';

  @override
  String hintProblem3(String who) {
    return '「$who」が最初に試すことは何で、なぜうまくいきませんか？';
  }

  @override
  String get hintProblem4 => '助けられるのに、助けようとしないのはだれですか？';

  @override
  String get hintProblem5 => 'もし今、みんながあきらめたらどうなるでしょう？';

  @override
  String get hintProblem6 => 'その障害には、何か悲しいところがありますか？';

  @override
  String hintProblem7(String who) {
    return 'そのとき「$who」は声に出して何と言いますか？';
  }

  @override
  String hintEnding1(String who) {
    return '「$who」は最後に何でそれを打ち破りますか？力ですか、それとも知恵ですか？';
  }

  @override
  String get hintEnding2 => 'その必要はないのに助けてくれるのはだれですか？';

  @override
  String hintEnding3(String who) {
    return 'すべてが終わって、「$who」が真っ先にすることは何ですか？';
  }

  @override
  String get hintEnding4 => 'はじめと比べて、終わりには何が変わっていますか？';

  @override
  String hintEnding5(String who) {
    return '「$who」はどこへ帰り、そこでだれが待っていますか？';
  }

  @override
  String get hintEnding6 => '明かりがつく前の、最後のひとことは何でしょう？';

  @override
  String get globeLoading => '惑星を準備しています…';

  @override
  String get globeLoadFailed => '惑星を読み込めませんでした。';

  @override
  String get globeTitle => 'おはなしはどこの国から？';

  @override
  String get globeStored => 'ダウンロード済みのおはなし';

  @override
  String get globeHintFar =>
      '惑星を回すか、国をタップしてください。緑の国にはコレクションのおはなしがあり、灰色の国はまだです。';

  @override
  String get globeHintNear => '国か建物をタップしてください。緑の国にはコレクションのおはなしがあり、灰色の国はまだです。';

  @override
  String get globeWhole => '惑星全体';

  @override
  String get globeZoomIn => '拡大';

  @override
  String get globeZoomOut => '縮小';

  @override
  String globeZoomToRegion(String name) {
    return '$nameを拡大 →';
  }

  @override
  String get globeTellHere => 'ここのおはなしを語る';

  @override
  String globeTellFrom(String place) {
    return '$placeのおはなしを語る →';
  }

  @override
  String get globeOpenSea => '大海原';

  @override
  String globeRegionCountries(int n) {
    return '$nか国まとめて表示中。拡大して1つ選んでください。';
  }

  @override
  String get globeTurnToCountry => '惑星をどこかの国に向けて回してください。';

  @override
  String get globeSpin => '回す';

  @override
  String get globeNoTales => 'ここのおはなしはまだありません。';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'モチーフ$n件',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n話から',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales$motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + パックから$packMotifs件';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'パックからモチーフ$n件',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return 'ここのおはなし$_temp0を、$regionパック用に準備中です。';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return '$_temp0（無料）';
  }

  @override
  String cardFree(int n) {
    return '無料$n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $rangeの中に$n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return '所有：$n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'さらに$n話を準備中',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'ストアの応答待ち…';

  @override
  String offerDownloading(int percent) {
    return 'おはなしをダウンロード中… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return '$nameを購入：$_temp0、$price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return '$nameをダウンロード：$_temp0（無料）（$size）';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n話');
    return '$nameをダウンロード：$_temp0（$size）';
  }

  @override
  String offerDownloadTip(String name) {
    return '$nameをダウンロード';
  }

  @override
  String get errDownloadTales => 'おはなしをダウンロードできませんでした。';

  @override
  String get errDownloadScenes => '画像をダウンロードできませんでした。';

  @override
  String get errNoDownloads => 'ここではダウンロードできません。';

  @override
  String get errOffline => 'インターネットに接続されていません。電波のあるところでもう一度お試しください。';

  @override
  String get errCannotBuy => 'この巻は現在購入できません。';

  @override
  String get buyPending => '購入は承認待ちです。承認されるとダウンロードされます。';

  @override
  String get buyFailed => '購入できませんでした。';

  @override
  String get restoreNone => 'このアカウントには購入履歴がありません。';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n巻を復元しました。惑星からダウンロードできます。',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => '購入を復元できませんでした。電波のあるところでもう一度お試しください。';

  @override
  String get narrationGone => 'このおはなしはもう組み立てられていません。';

  @override
  String get narrationNew => '新しく組み立てる';

  @override
  String narrationTitle(int index, int total) {
    return '語り中 — $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'つなぎ方：$bridge';
  }

  @override
  String get narrationSituation => 'いま何が起きていますか？（任意・音声入力もできます）';

  @override
  String get narrationHintNote => 'ヒント — 声に出して読まず、きっかけにしてください。';

  @override
  String get narrationSoundsNote => '効果音 — 語りに合うときに鳴らしましょう。';

  @override
  String get moodTense => '緊張';

  @override
  String get moodCalm => '静けさ';

  @override
  String get narrationSearching => '探しています…';

  @override
  String get narrationHint => 'ヒントをください';

  @override
  String get narrationMoreHint => 'もう1つ';

  @override
  String get narrationBack => '戻る';

  @override
  String get narrationEnd => 'おわり';

  @override
  String get narrationNext => '次へ →';

  @override
  String get narrationGoodnight => 'おやすみなさい。';

  @override
  String get narrationEndNote =>
      '最後の絵やライブラリへの保存はまだできません。このおはなしはどこへも行かず、ふたりのあいだに残ります。';

  @override
  String get narrationClose => '閉じる';

  @override
  String get ragFallback => 'パックにはこれに合うものがまだありません。一般的なヒントです：';

  @override
  String get ragNoModel => 'このバージョンにはヒントのモデルが含まれていません。';

  @override
  String get ragHintGeneral => '一般';

  @override
  String get ragHintMotif => 'モチーフ用';

  @override
  String get captionExact => 'イラスト · このモチーフ用';

  @override
  String get captionSimilar => 'イラスト · 似た場面';

  @override
  String get captionCard => 'モチーフカード · このステップの場面はまだありません';

  @override
  String get storageTitle => 'ダウンロード済みのおはなし';

  @override
  String get storageEmpty => 'まだありません。ほかのおはなしは惑星からダウンロードします。';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$nパック',
    );
    return '$_temp0、$size';
  }

  @override
  String storageScenes(String name) {
    return '$nameの場面';
  }

  @override
  String get storageFreeTier => '無料';

  @override
  String get storageBoughtTier => '購入済み';

  @override
  String get storageDelete => '削除';

  @override
  String get storageScenesSub => '語りの各ステップに1枚の絵';

  @override
  String get storageDownload => 'ダウンロード';

  @override
  String get storageAllUsed => '過去30日間にすべて使われました。';

  @override
  String storageFreed(String size) {
    return '$sizeを解放しました。';
  }

  @override
  String get storageFreeUp => '空き容量を増やす（30日間未使用）';

  @override
  String get storageRestoring => '購入を復元しています…';

  @override
  String get storageRestore => '購入を復元';

  @override
  String get osnovaTitle => 'あらすじ';

  @override
  String get osnovaSummary => 'おはなしのあらすじ';

  @override
  String get osnovaCharacters => '登場人物';

  @override
  String get osnovaTask => '使命';

  @override
  String get osnovaProblem => '問題';

  @override
  String get osnovaEnding => '結末';

  @override
  String get osnovaAgain => 'やり直す';

  @override
  String get osnovaTell => '語る →';

  @override
  String get outlineHero => '主人公';

  @override
  String get castFox => 'かしこいキツネ';

  @override
  String get castSmithSon => '鍛冶屋の息子';

  @override
  String get castMill => 'しゃべる水車小屋';

  @override
  String get castGooseGirl => 'ガチョウ番の娘';

  @override
  String get castBrothers => '三人兄弟';

  @override
  String get castClockworkPrincess => '時計職人のお姫さま';

  @override
  String get castOwl => '賢いフクロウ';

  @override
  String get castBlacksmith => '年老いた女鍛冶屋';

  @override
  String get castDragon => '小さなドラゴン';

  @override
  String get castWaterSprite => '水の精';

  @override
  String get castFourPrincesses => '四人のお姫さま';

  @override
  String get castTravelingTailor => '旅の仕立て屋';

  @override
  String get castTalkingCat => 'しゃべるネコ';

  @override
  String get castForestHermit => '森の隠者';

  @override
  String get castC0AndersenTheShadow => 'かつて影だった旦那さま';

  @override
  String get castC1GrimmTheGooseGirl => '裏切り者の侍女';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => '幽霊城をもつ王さま';

  @override
  String get castC3AndersenTheShadow => 'ずる賢い影';

  @override
  String get castC4PerraultRiquetWithTheTuft => '美しいけれどあまり賢くないお姫さま';

  @override
  String get castC5AndersenTheRedShoes => '最後にゆるしてくれる天使';

  @override
  String get castC6GrimmRumpelstiltskin => '粉屋のかしこい娘';

  @override
  String get castC7PerraultLittleRedRidingHood => 'ドアを開けるおばあさん';

  @override
  String get castC8PerraultLittleThumb => '貧しさと愛のはざまの母';

  @override
  String get castC9PerraultIntroduction => '辛抱強い女の人';

  @override
  String get castC10AndersenTheRealPrincess => '息子を支える王さま';

  @override
  String get castC11GrimmLilyAndTheLion => '約束を守る娘';

  @override
  String get castC12AndersenTheRealPrincess => '本物のお姫さまを探す王子';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'マッチ売りの少女';

  @override
  String get castC14AndersenTheEmperorSNewClothes => '黙っている廷臣';

  @override
  String get castC15PerraultRiquetWithTheTuft => '宴を用意する忠実な召使い';

  @override
  String get castC16PerraultTheFairy => 'うぬぼれた娘';

  @override
  String get castC17GrimmFirstStory => 'しっぽを九本ほしがる未亡人';

  @override
  String get motifTaskWine => 'ワインの貯蔵庫を飲み干すのはだれ';

  @override
  String get motifTaskDiamonds => 'ダイヤモンドを求める空の旅';

  @override
  String get motifTaskRingDuck => 'アヒルの中の指輪';

  @override
  String get motifTaskGiants => '巨人たちをだます';

  @override
  String get motifTaskTomThumb => '親指小僧の脱出';

  @override
  String get motifTaskSwineherd => 'お姫さまの心をつかむ';

  @override
  String get motifTaskBell => '森の不思議な鐘';

  @override
  String get motifTaskGoldenObject => '悪用してはならない贈り物';

  @override
  String get motifTaskPebbles => '小石の道しるべ';

  @override
  String get motifProblemFoxPride => 'キツネの高慢';

  @override
  String get motifProblemLazySister => 'なまけ者の姉妹';

  @override
  String get motifProblemWitchBoots => '七里靴をはいた魔女';

  @override
  String get motifProblemTailorDoubt => 'だれも信じてくれない';

  @override
  String get motifProblemLions => '門前の飢えたライオン';

  @override
  String get motifProblemEagle => 'ワシと小人';

  @override
  String get motifProblemTruth => '魔法の動物が真実を明かす';

  @override
  String get motifProblemOldHouse => '古い家をだれも欲しがらない';

  @override
  String get motifProblemBreadcrumbs => '鳥がパンくずを食べてしまった';

  @override
  String get motifEndingTrickWins => '知恵が勝つ';

  @override
  String get motifEndingTruthChild => '子どもが本当のことを言う';

  @override
  String get motifEndingNewHome => '新しい家、昔なじみの友';

  @override
  String get motifEndingHappyTogether => 'いつまでも幸せに暮らす';

  @override
  String get motifEndingKissWakes => '口づけが王国を目覚めさせる';

  @override
  String get motifEndingLeapfrog => '知恵がいちばん高く跳ぶ';

  @override
  String get motifEndingCurseBroken => '呪いが解けた';

  @override
  String get motifEndingWelcomedHome => '家で迎えられる';

  @override
  String get motifEndingSlipper => 'なくした靴';
}
