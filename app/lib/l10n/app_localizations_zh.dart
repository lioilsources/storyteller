// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get castTitle => '童话里会有谁？';

  @override
  String get castHint =>
      '点一下卡片可换一个角色，点叉号可删除卡片。音乐和音效始终由该国家的资源包准备好，只有角色的图片有时会稍晚一点才画好。';

  @override
  String get castAdd => '添加角色';

  @override
  String get castCount => '角色阵容：';

  @override
  String get castShuffleAll => '全部重新洗牌';

  @override
  String get castContinue => '继续 →';

  @override
  String get shuffle => '洗牌';

  @override
  String get motifTaskTitle => '什么任务？';

  @override
  String get motifProblemTitle => '什么问题？';

  @override
  String get motifEndingTitle => '什么结局？';

  @override
  String get motifTaskCaption => '点一下卡片，为主人公选择任务。';

  @override
  String get motifProblemCaption => '点一下卡片，选择一个障碍或反派。';

  @override
  String get motifEndingCaption => '点一下卡片，选择一个圆满的结局。';

  @override
  String get beatCastTitle => '故事里有谁';

  @override
  String get beatTaskTitle => '主人公下定了什么决心';

  @override
  String get beatProblemTitle => '什么挡住了去路';

  @override
  String get beatEndingTitle => '结局如何';

  @override
  String get beatCastCaption => '介绍一下角色：他们在哪里，长什么样，有什么特别之处。';

  @override
  String get beatTaskCaption => '说说主人公想要什么，以及为什么出发。';

  @override
  String get beatProblemCaption => '在主人公的路上放点什么。让它暂时看上去行不通。';

  @override
  String get beatEndingCaption => '把故事讲到结尾。别着急，孩子对结局记得最牢。';

  @override
  String get hintHero => '主人公';

  @override
  String hintCast1(String who) {
    return '「$who」第一次出场时是什么样子？';
  }

  @override
  String hintCast2(String who) {
    return '整个故事开始之前，「$who」正在做什么？';
  }

  @override
  String hintCast3(String who) {
    return '「$who」害怕什么？';
  }

  @override
  String hintCast4(String who) {
    return '你怎么知道「$who」来了？';
  }

  @override
  String get hintCast5 => '他们当中谁早就认识，是从哪里认识的？';

  @override
  String get hintCast6 => '他们相遇时天气怎么样？';

  @override
  String hintCast7(String who) {
    return '「$who」口袋里有什么？';
  }

  @override
  String hintTask1(String who) {
    return '「$who」什么时候明白必须动手了？';
  }

  @override
  String hintTask2(String who) {
    return '谁给了建议，「$who」为什么听？';
  }

  @override
  String hintTask3(String who) {
    return '「$who」必须把什么留在家里？';
  }

  @override
  String get hintTask4 => '这条路有多长，要经过哪里？';

  @override
  String hintTask5(String who) {
    return '出发前「$who」对自己许下了什么承诺？';
  }

  @override
  String get hintTask6 => '为什么别人不能做这件事？';

  @override
  String get hintProblem1 => '这时传来一个声音，是什么声音？';

  @override
  String get hintProblem2 => '最先出什么问题？';

  @override
  String hintProblem3(String who) {
    return '「$who」先试了什么，为什么没成功？';
  }

  @override
  String get hintProblem4 => '谁明明能帮忙却拒绝了？';

  @override
  String get hintProblem5 => '如果现在大家都放弃了，会怎样？';

  @override
  String get hintProblem6 => '这个障碍里有什么令人难过的地方吗？';

  @override
  String hintProblem7(String who) {
    return '这一刻「$who」大声说了什么？';
  }

  @override
  String hintEnding1(String who) {
    return '「$who」最终靠什么克服了它：力量还是主意？';
  }

  @override
  String get hintEnding2 => '谁本来不必帮忙却出手相助？';

  @override
  String hintEnding3(String who) {
    return '一切结束后，「$who」最先做什么？';
  }

  @override
  String get hintEnding4 => '结尾和开头相比有什么不同？';

  @override
  String hintEnding5(String who) {
    return '「$who」回到哪里，谁在那里等着？';
  }

  @override
  String get hintEnding6 => '灯亮之前的最后一句话是什么？';

  @override
  String get globeLoading => '正在准备星球…';

  @override
  String get globeLoadFailed => '星球加载失败。';

  @override
  String get globeTitle => '童话来自哪里？';

  @override
  String get globeStored => '已下载的童话';

  @override
  String get globeHintFar => '转动星球或点一下国家。绿色的国家已有我们收集的童话，灰色的还没有。';

  @override
  String get globeHintNear => '点一下国家或建筑。绿色的国家已有我们收集的童话，灰色的还没有。';

  @override
  String get globeWhole => '整个星球';

  @override
  String get globeZoomIn => '放大';

  @override
  String get globeZoomOut => '缩小';

  @override
  String globeZoomToRegion(String name) {
    return '放大查看$name →';
  }

  @override
  String get globeTellHere => '讲一个这里的童话';

  @override
  String globeTellFrom(String place) {
    return '讲一个来自$place的童话 →';
  }

  @override
  String get globeOpenSea => '茫茫大海';

  @override
  String globeRegionCountries(int n) {
    return '$n个国家在一起。放大后选一个。';
  }

  @override
  String get globeTurnToCountry => '把星球转向某个国家。';

  @override
  String get globeSpin => '转动';

  @override
  String get globeNoTales => '我们还没有来自这里的童话。';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n个母题',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '来自$n篇童话',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales的$motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base，另有资源包中的$packMotifs个';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '资源包中的$n个母题',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n篇');
    return '正在为$region资源包准备$_temp0来自这里的童话。';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '$_temp0（免费）';
  }

  @override
  String cardFree(int n) {
    return '免费$n篇';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range中有$n篇',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return '你已有$n篇';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '还有$n篇在准备中',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => '正在等待商店…';

  @override
  String offerDownloading(int percent) {
    return '正在下载童话… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '购买$name：$_temp0，$price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '下载$name：$_temp0（免费）（$size）';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '下载$name：$_temp0（$size）';
  }

  @override
  String offerDownloadTip(String name) {
    return '下载$name';
  }

  @override
  String get errDownloadTales => '童话下载失败。';

  @override
  String get errDownloadScenes => '图片下载失败。';

  @override
  String get errNoDownloads => '这里无法下载。';

  @override
  String get errOffline => '没有网络连接，信号恢复后再试。';

  @override
  String get errCannotBuy => '这一部分暂时无法购买。';

  @override
  String get buyPending => '购买正在等待批准，批准后会自动下载这一部分。';

  @override
  String get buyFailed => '购买未成功。';

  @override
  String get restoreNone => '此账户没有任何购买记录。';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '已恢复$n个部分，可以从星球上下载。',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => '无法恢复购买，信号恢复后再试。';

  @override
  String get narrationGone => '这篇童话已经不在拼好的状态了。';

  @override
  String get narrationNew => '重新拼一篇';

  @override
  String narrationTitle(int index, int total) {
    return '你在讲 — 第$index步，共$total步';
  }

  @override
  String narrationBridge(String bridge) {
    return '怎么衔接：$bridge';
  }

  @override
  String get narrationSituation => '现在发生了什么？（可不填，也可语音输入）';

  @override
  String get narrationHintNote => '提示：不要大声念出来，只当作开头的灵感。';

  @override
  String get narrationSoundsNote => '音效：合适的时候再播放。';

  @override
  String get moodTense => '紧张';

  @override
  String get moodCalm => '平静';

  @override
  String get narrationSearching => '正在查找…';

  @override
  String get narrationHint => '给我提示';

  @override
  String get narrationMoreHint => '再来一条';

  @override
  String get narrationBack => '返回';

  @override
  String get narrationEnd => '完';

  @override
  String get narrationNext => '下一步 →';

  @override
  String get narrationGoodnight => '晚安。';

  @override
  String get narrationEndNote => '我们暂时还做不了结尾插图，也不能保存到资料库。这篇童话哪儿也不去，就留在你们之间。';

  @override
  String get narrationClose => '关闭';

  @override
  String get ragFallback => '资源包里暂时没有相关内容，这里是一条通用提示：';

  @override
  String get ragNoModel => '此版本不包含提示模型。';

  @override
  String get ragHintGeneral => '通用';

  @override
  String get ragHintMotif => '针对母题';

  @override
  String get captionExact => '插图 · 对应这个母题';

  @override
  String get captionSimilar => '插图 · 相似场景';

  @override
  String get captionCard => '母题卡片 · 这一步暂时没有场景';

  @override
  String get storageTitle => '已下载的童话';

  @override
  String get storageEmpty => '暂时没有，更多童话可从星球上下载。';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n个资源包',
    );
    return '$_temp0，$size';
  }

  @override
  String storageScenes(String name) {
    return '$name的场景';
  }

  @override
  String get storageFreeTier => '免费';

  @override
  String get storageBoughtTier => '已购买';

  @override
  String get storageDelete => '删除';

  @override
  String get storageScenesSub => '讲述的每一步都配有一张图';

  @override
  String get storageDownload => '下载';

  @override
  String get storageAllUsed => '过去30天内的内容都用过。';

  @override
  String storageFreed(String size) {
    return '已释放$size。';
  }

  @override
  String get storageFreeUp => '释放空间（30天未使用）';

  @override
  String get storageRestoring => '正在恢复购买…';

  @override
  String get storageRestore => '恢复购买';

  @override
  String get osnovaTitle => '提纲';

  @override
  String get osnovaSummary => '童话概要';

  @override
  String get osnovaCharacters => '角色';

  @override
  String get osnovaTask => '任务';

  @override
  String get osnovaProblem => '问题';

  @override
  String get osnovaEnding => '结局';

  @override
  String get osnovaAgain => '重来';

  @override
  String get osnovaTell => '我来讲 →';

  @override
  String get outlineHero => '主人公';

  @override
  String get castFox => '聪明的狐狸';

  @override
  String get castSmithSon => '铁匠的儿子';

  @override
  String get castMill => '会说话的磨坊';

  @override
  String get castGooseGirl => '牧鹅姑娘';

  @override
  String get castBrothers => '三兄弟';

  @override
  String get castClockworkPrincess => '钟表匠的公主';

  @override
  String get castOwl => '智慧的猫头鹰';

  @override
  String get castBlacksmith => '年迈的女铁匠';

  @override
  String get castDragon => '小龙';

  @override
  String get castWaterSprite => '水妖';

  @override
  String get castFourPrincesses => '四位公主';

  @override
  String get castTravelingTailor => '流浪裁缝';

  @override
  String get castTalkingCat => '会说话的猫';

  @override
  String get castForestHermit => '森林隐士';

  @override
  String get castC0AndersenTheShadow => '曾经是影子的老爷';

  @override
  String get castC1GrimmTheGooseGirl => '背叛的侍女';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => '拥有闹鬼城堡的国王';

  @override
  String get castC3AndersenTheShadow => '机灵的影子';

  @override
  String get castC4PerraultRiquetWithTheTuft => '漂亮却不太聪明的公主';

  @override
  String get castC5AndersenTheRedShoes => '最终原谅人的天使';

  @override
  String get castC6GrimmRumpelstiltskin => '磨坊主聪明的女儿';

  @override
  String get castC7PerraultLittleRedRidingHood => '开门的外婆';

  @override
  String get castC8PerraultLittleThumb => '夹在贫困与爱之间的母亲';

  @override
  String get castC9PerraultIntroduction => '有耐心的女人';

  @override
  String get castC10AndersenTheRealPrincess => '支持儿子的国王';

  @override
  String get castC11GrimmLilyAndTheLion => '信守诺言的女儿';

  @override
  String get castC12AndersenTheRealPrincess => '寻找真公主的王子';

  @override
  String get castC13AndersenTheLittleMatchGirl => '卖火柴的小女孩';

  @override
  String get castC14AndersenTheEmperorSNewClothes => '沉默的朝臣';

  @override
  String get castC15PerraultRiquetWithTheTuft => '忠诚的仆人准备宴席';

  @override
  String get castC16PerraultTheFairy => '傲慢的女儿';

  @override
  String get castC17GrimmFirstStory => '想要九条尾巴的寡妇';

  @override
  String get motifTaskWine => '谁能喝光一整个酒窖的酒';

  @override
  String get motifTaskDiamonds => '为钻石而飞行';

  @override
  String get motifTaskRingDuck => '鸭子肚里的戒指';

  @override
  String get motifTaskGiants => '智胜巨人';

  @override
  String get motifTaskTomThumb => '拇指小子的逃跑';

  @override
  String get motifTaskSwineherd => '赢得公主的芳心';

  @override
  String get motifTaskBell => '森林里神秘的钟';

  @override
  String get motifTaskGoldenObject => '不能滥用的礼物';

  @override
  String get motifTaskPebbles => '鹅卵石小路';

  @override
  String get motifProblemFoxPride => '狐狸的傲慢';

  @override
  String get motifProblemLazySister => '懒惰的姐妹';

  @override
  String get motifProblemWitchBoots => '穿七里靴的女巫';

  @override
  String get motifProblemTailorDoubt => '没人相信他';

  @override
  String get motifProblemLions => '城门口的饥饿狮子';

  @override
  String get motifProblemEagle => '老鹰与矮人';

  @override
  String get motifProblemTruth => '神奇的动物说出真相';

  @override
  String get motifProblemOldHouse => '没人想要老房子';

  @override
  String get motifProblemBreadcrumbs => '鸟儿吃光了面包屑';

  @override
  String get motifEndingTrickWins => '机智获胜';

  @override
  String get motifEndingTruthChild => '孩子说出真相';

  @override
  String get motifEndingNewHome => '新家，老朋友';

  @override
  String get motifEndingHappyTogether => '从此幸福地生活在一起';

  @override
  String get motifEndingKissWakes => '一个吻唤醒王国';

  @override
  String get motifEndingLeapfrog => '机智跳得最高';

  @override
  String get motifEndingCurseBroken => '诅咒解除了';

  @override
  String get motifEndingWelcomedHome => '在家受到欢迎';

  @override
  String get motifEndingSlipper => '丢失的鞋子';
}

/// The translations for Chinese, using the Han script (`zh_Hans`).
class AppLocalizationsZhHans extends AppLocalizationsZh {
  AppLocalizationsZhHans() : super('zh_Hans');

  @override
  String get castTitle => '童话里会有谁？';

  @override
  String get castHint =>
      '点一下卡片可换一个角色，点叉号可删除卡片。音乐和音效始终由该国家的资源包准备好，只有角色的图片有时会稍晚一点才画好。';

  @override
  String get castAdd => '添加角色';

  @override
  String get castCount => '角色阵容：';

  @override
  String get castShuffleAll => '全部重新洗牌';

  @override
  String get castContinue => '继续 →';

  @override
  String get shuffle => '洗牌';

  @override
  String get motifTaskTitle => '什么任务？';

  @override
  String get motifProblemTitle => '什么问题？';

  @override
  String get motifEndingTitle => '什么结局？';

  @override
  String get motifTaskCaption => '点一下卡片，为主人公选择任务。';

  @override
  String get motifProblemCaption => '点一下卡片，选择一个障碍或反派。';

  @override
  String get motifEndingCaption => '点一下卡片，选择一个圆满的结局。';

  @override
  String get beatCastTitle => '故事里有谁';

  @override
  String get beatTaskTitle => '主人公下定了什么决心';

  @override
  String get beatProblemTitle => '什么挡住了去路';

  @override
  String get beatEndingTitle => '结局如何';

  @override
  String get beatCastCaption => '介绍一下角色：他们在哪里，长什么样，有什么特别之处。';

  @override
  String get beatTaskCaption => '说说主人公想要什么，以及为什么出发。';

  @override
  String get beatProblemCaption => '在主人公的路上放点什么。让它暂时看上去行不通。';

  @override
  String get beatEndingCaption => '把故事讲到结尾。别着急，孩子对结局记得最牢。';

  @override
  String get hintHero => '主人公';

  @override
  String hintCast1(String who) {
    return '「$who」第一次出场时是什么样子？';
  }

  @override
  String hintCast2(String who) {
    return '整个故事开始之前，「$who」正在做什么？';
  }

  @override
  String hintCast3(String who) {
    return '「$who」害怕什么？';
  }

  @override
  String hintCast4(String who) {
    return '你怎么知道「$who」来了？';
  }

  @override
  String get hintCast5 => '他们当中谁早就认识，是从哪里认识的？';

  @override
  String get hintCast6 => '他们相遇时天气怎么样？';

  @override
  String hintCast7(String who) {
    return '「$who」口袋里有什么？';
  }

  @override
  String hintTask1(String who) {
    return '「$who」什么时候明白必须动手了？';
  }

  @override
  String hintTask2(String who) {
    return '谁给了建议，「$who」为什么听？';
  }

  @override
  String hintTask3(String who) {
    return '「$who」必须把什么留在家里？';
  }

  @override
  String get hintTask4 => '这条路有多长，要经过哪里？';

  @override
  String hintTask5(String who) {
    return '出发前「$who」对自己许下了什么承诺？';
  }

  @override
  String get hintTask6 => '为什么别人不能做这件事？';

  @override
  String get hintProblem1 => '这时传来一个声音，是什么声音？';

  @override
  String get hintProblem2 => '最先出什么问题？';

  @override
  String hintProblem3(String who) {
    return '「$who」先试了什么，为什么没成功？';
  }

  @override
  String get hintProblem4 => '谁明明能帮忙却拒绝了？';

  @override
  String get hintProblem5 => '如果现在大家都放弃了，会怎样？';

  @override
  String get hintProblem6 => '这个障碍里有什么令人难过的地方吗？';

  @override
  String hintProblem7(String who) {
    return '这一刻「$who」大声说了什么？';
  }

  @override
  String hintEnding1(String who) {
    return '「$who」最终靠什么克服了它：力量还是主意？';
  }

  @override
  String get hintEnding2 => '谁本来不必帮忙却出手相助？';

  @override
  String hintEnding3(String who) {
    return '一切结束后，「$who」最先做什么？';
  }

  @override
  String get hintEnding4 => '结尾和开头相比有什么不同？';

  @override
  String hintEnding5(String who) {
    return '「$who」回到哪里，谁在那里等着？';
  }

  @override
  String get hintEnding6 => '灯亮之前的最后一句话是什么？';

  @override
  String get globeLoading => '正在准备星球…';

  @override
  String get globeLoadFailed => '星球加载失败。';

  @override
  String get globeTitle => '童话来自哪里？';

  @override
  String get globeStored => '已下载的童话';

  @override
  String get globeHintFar => '转动星球或点一下国家。绿色的国家已有我们收集的童话，灰色的还没有。';

  @override
  String get globeHintNear => '点一下国家或建筑。绿色的国家已有我们收集的童话，灰色的还没有。';

  @override
  String get globeWhole => '整个星球';

  @override
  String get globeZoomIn => '放大';

  @override
  String get globeZoomOut => '缩小';

  @override
  String globeZoomToRegion(String name) {
    return '放大查看$name →';
  }

  @override
  String get globeTellHere => '讲一个这里的童话';

  @override
  String globeTellFrom(String place) {
    return '讲一个来自$place的童话 →';
  }

  @override
  String get globeOpenSea => '茫茫大海';

  @override
  String globeRegionCountries(int n) {
    return '$n个国家在一起。放大后选一个。';
  }

  @override
  String get globeTurnToCountry => '把星球转向某个国家。';

  @override
  String get globeSpin => '转动';

  @override
  String get globeNoTales => '我们还没有来自这里的童话。';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n个母题',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '来自$n篇童话',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales的$motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base，另有资源包中的$packMotifs个';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '资源包中的$n个母题',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n篇');
    return '正在为$region资源包准备$_temp0来自这里的童话。';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '$_temp0（免费）';
  }

  @override
  String cardFree(int n) {
    return '免费$n篇';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range中有$n篇',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return '你已有$n篇';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '还有$n篇在准备中',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => '正在等待商店…';

  @override
  String offerDownloading(int percent) {
    return '正在下载童话… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '购买$name：$_temp0，$price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '下载$name：$_temp0（免费）（$size）';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童话',
    );
    return '下载$name：$_temp0（$size）';
  }

  @override
  String offerDownloadTip(String name) {
    return '下载$name';
  }

  @override
  String get errDownloadTales => '童话下载失败。';

  @override
  String get errDownloadScenes => '图片下载失败。';

  @override
  String get errNoDownloads => '这里无法下载。';

  @override
  String get errOffline => '没有网络连接，信号恢复后再试。';

  @override
  String get errCannotBuy => '这一部分暂时无法购买。';

  @override
  String get buyPending => '购买正在等待批准，批准后会自动下载这一部分。';

  @override
  String get buyFailed => '购买未成功。';

  @override
  String get restoreNone => '此账户没有任何购买记录。';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '已恢复$n个部分，可以从星球上下载。',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => '无法恢复购买，信号恢复后再试。';

  @override
  String get narrationGone => '这篇童话已经不在拼好的状态了。';

  @override
  String get narrationNew => '重新拼一篇';

  @override
  String narrationTitle(int index, int total) {
    return '你在讲 — 第$index步，共$total步';
  }

  @override
  String narrationBridge(String bridge) {
    return '怎么衔接：$bridge';
  }

  @override
  String get narrationSituation => '现在发生了什么？（可不填，也可语音输入）';

  @override
  String get narrationHintNote => '提示：不要大声念出来，只当作开头的灵感。';

  @override
  String get narrationSoundsNote => '音效：合适的时候再播放。';

  @override
  String get moodTense => '紧张';

  @override
  String get moodCalm => '平静';

  @override
  String get narrationSearching => '正在查找…';

  @override
  String get narrationHint => '给我提示';

  @override
  String get narrationMoreHint => '再来一条';

  @override
  String get narrationBack => '返回';

  @override
  String get narrationEnd => '完';

  @override
  String get narrationNext => '下一步 →';

  @override
  String get narrationGoodnight => '晚安。';

  @override
  String get narrationEndNote => '我们暂时还做不了结尾插图，也不能保存到资料库。这篇童话哪儿也不去，就留在你们之间。';

  @override
  String get narrationClose => '关闭';

  @override
  String get ragFallback => '资源包里暂时没有相关内容，这里是一条通用提示：';

  @override
  String get ragNoModel => '此版本不包含提示模型。';

  @override
  String get ragHintGeneral => '通用';

  @override
  String get ragHintMotif => '针对母题';

  @override
  String get captionExact => '插图 · 对应这个母题';

  @override
  String get captionSimilar => '插图 · 相似场景';

  @override
  String get captionCard => '母题卡片 · 这一步暂时没有场景';

  @override
  String get storageTitle => '已下载的童话';

  @override
  String get storageEmpty => '暂时没有，更多童话可从星球上下载。';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n个资源包',
    );
    return '$_temp0，$size';
  }

  @override
  String storageScenes(String name) {
    return '$name的场景';
  }

  @override
  String get storageFreeTier => '免费';

  @override
  String get storageBoughtTier => '已购买';

  @override
  String get storageDelete => '删除';

  @override
  String get storageScenesSub => '讲述的每一步都配有一张图';

  @override
  String get storageDownload => '下载';

  @override
  String get storageAllUsed => '过去30天内的内容都用过。';

  @override
  String storageFreed(String size) {
    return '已释放$size。';
  }

  @override
  String get storageFreeUp => '释放空间（30天未使用）';

  @override
  String get storageRestoring => '正在恢复购买…';

  @override
  String get storageRestore => '恢复购买';

  @override
  String get osnovaTitle => '提纲';

  @override
  String get osnovaSummary => '童话概要';

  @override
  String get osnovaCharacters => '角色';

  @override
  String get osnovaTask => '任务';

  @override
  String get osnovaProblem => '问题';

  @override
  String get osnovaEnding => '结局';

  @override
  String get osnovaAgain => '重来';

  @override
  String get osnovaTell => '我来讲 →';

  @override
  String get outlineHero => '主人公';

  @override
  String get castFox => '聪明的狐狸';

  @override
  String get castSmithSon => '铁匠的儿子';

  @override
  String get castMill => '会说话的磨坊';

  @override
  String get castGooseGirl => '牧鹅姑娘';

  @override
  String get castBrothers => '三兄弟';

  @override
  String get castClockworkPrincess => '钟表匠的公主';

  @override
  String get castOwl => '智慧的猫头鹰';

  @override
  String get castBlacksmith => '年迈的女铁匠';

  @override
  String get castDragon => '小龙';

  @override
  String get castWaterSprite => '水妖';

  @override
  String get castFourPrincesses => '四位公主';

  @override
  String get castTravelingTailor => '流浪裁缝';

  @override
  String get castTalkingCat => '会说话的猫';

  @override
  String get castForestHermit => '森林隐士';

  @override
  String get castC0AndersenTheShadow => '曾经是影子的老爷';

  @override
  String get castC1GrimmTheGooseGirl => '背叛的侍女';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => '拥有闹鬼城堡的国王';

  @override
  String get castC3AndersenTheShadow => '机灵的影子';

  @override
  String get castC4PerraultRiquetWithTheTuft => '漂亮却不太聪明的公主';

  @override
  String get castC5AndersenTheRedShoes => '最终原谅人的天使';

  @override
  String get castC6GrimmRumpelstiltskin => '磨坊主聪明的女儿';

  @override
  String get castC7PerraultLittleRedRidingHood => '开门的外婆';

  @override
  String get castC8PerraultLittleThumb => '夹在贫困与爱之间的母亲';

  @override
  String get castC9PerraultIntroduction => '有耐心的女人';

  @override
  String get castC10AndersenTheRealPrincess => '支持儿子的国王';

  @override
  String get castC11GrimmLilyAndTheLion => '信守诺言的女儿';

  @override
  String get castC12AndersenTheRealPrincess => '寻找真公主的王子';

  @override
  String get castC13AndersenTheLittleMatchGirl => '卖火柴的小女孩';

  @override
  String get castC14AndersenTheEmperorSNewClothes => '沉默的朝臣';

  @override
  String get castC15PerraultRiquetWithTheTuft => '忠诚的仆人准备宴席';

  @override
  String get castC16PerraultTheFairy => '傲慢的女儿';

  @override
  String get castC17GrimmFirstStory => '想要九条尾巴的寡妇';

  @override
  String get motifTaskWine => '谁能喝光一整个酒窖的酒';

  @override
  String get motifTaskDiamonds => '为钻石而飞行';

  @override
  String get motifTaskRingDuck => '鸭子肚里的戒指';

  @override
  String get motifTaskGiants => '智胜巨人';

  @override
  String get motifTaskTomThumb => '拇指小子的逃跑';

  @override
  String get motifTaskSwineherd => '赢得公主的芳心';

  @override
  String get motifTaskBell => '森林里神秘的钟';

  @override
  String get motifTaskGoldenObject => '不能滥用的礼物';

  @override
  String get motifTaskPebbles => '鹅卵石小路';

  @override
  String get motifProblemFoxPride => '狐狸的傲慢';

  @override
  String get motifProblemLazySister => '懒惰的姐妹';

  @override
  String get motifProblemWitchBoots => '穿七里靴的女巫';

  @override
  String get motifProblemTailorDoubt => '没人相信他';

  @override
  String get motifProblemLions => '城门口的饥饿狮子';

  @override
  String get motifProblemEagle => '老鹰与矮人';

  @override
  String get motifProblemTruth => '神奇的动物说出真相';

  @override
  String get motifProblemOldHouse => '没人想要老房子';

  @override
  String get motifProblemBreadcrumbs => '鸟儿吃光了面包屑';

  @override
  String get motifEndingTrickWins => '机智获胜';

  @override
  String get motifEndingTruthChild => '孩子说出真相';

  @override
  String get motifEndingNewHome => '新家，老朋友';

  @override
  String get motifEndingHappyTogether => '从此幸福地生活在一起';

  @override
  String get motifEndingKissWakes => '一个吻唤醒王国';

  @override
  String get motifEndingLeapfrog => '机智跳得最高';

  @override
  String get motifEndingCurseBroken => '诅咒解除了';

  @override
  String get motifEndingWelcomedHome => '在家受到欢迎';

  @override
  String get motifEndingSlipper => '丢失的鞋子';
}

/// The translations for Chinese, using the Han script (`zh_Hant`).
class AppLocalizationsZhHant extends AppLocalizationsZh {
  AppLocalizationsZhHant() : super('zh_Hant');

  @override
  String get castTitle => '童話裡會有誰？';

  @override
  String get castHint =>
      '點一下卡片可換一個角色，點叉號可刪除卡片。音樂和音效一律由該國家的資源包準備好，只有角色的圖片有時會晚一點才畫好。';

  @override
  String get castAdd => '新增角色';

  @override
  String get castCount => '角色陣容：';

  @override
  String get castShuffleAll => '全部重新洗牌';

  @override
  String get castContinue => '繼續 →';

  @override
  String get shuffle => '洗牌';

  @override
  String get motifTaskTitle => '什麼任務？';

  @override
  String get motifProblemTitle => '什麼問題？';

  @override
  String get motifEndingTitle => '什麼結局？';

  @override
  String get motifTaskCaption => '點一下卡片，為主角選擇任務。';

  @override
  String get motifProblemCaption => '點一下卡片，選擇一個障礙或反派。';

  @override
  String get motifEndingCaption => '點一下卡片，選擇一個圓滿的結局。';

  @override
  String get beatCastTitle => '故事裡有誰';

  @override
  String get beatTaskTitle => '主角下定了什麼決心';

  @override
  String get beatProblemTitle => '什麼擋住了去路';

  @override
  String get beatEndingTitle => '結局如何';

  @override
  String get beatCastCaption => '介紹一下角色：他們在哪裡，長什麼樣子，有什麼特別之處。';

  @override
  String get beatTaskCaption => '說說主角想要什麼，以及為什麼出發。';

  @override
  String get beatProblemCaption => '在主角的路上放點什麼。讓它暫時看起來行不通。';

  @override
  String get beatEndingCaption => '把故事講到結尾。別急，孩子對結局記得最牢。';

  @override
  String get hintHero => '主角';

  @override
  String hintCast1(String who) {
    return '「$who」第一次出場時是什麼樣子？';
  }

  @override
  String hintCast2(String who) {
    return '整個故事開始之前，「$who」正在做什麼？';
  }

  @override
  String hintCast3(String who) {
    return '「$who」害怕什麼？';
  }

  @override
  String hintCast4(String who) {
    return '你怎麼知道「$who」來了？';
  }

  @override
  String get hintCast5 => '他們當中誰早就認識，是從哪裡認識的？';

  @override
  String get hintCast6 => '他們相遇時天氣如何？';

  @override
  String hintCast7(String who) {
    return '「$who」口袋裡有什麼？';
  }

  @override
  String hintTask1(String who) {
    return '「$who」什麼時候明白必須動手了？';
  }

  @override
  String hintTask2(String who) {
    return '誰給了建議，「$who」為什麼聽？';
  }

  @override
  String hintTask3(String who) {
    return '「$who」必須把什麼留在家裡？';
  }

  @override
  String get hintTask4 => '這條路有多長，要經過哪裡？';

  @override
  String hintTask5(String who) {
    return '出發前「$who」對自己許下了什麼承諾？';
  }

  @override
  String get hintTask6 => '為什麼別人不能做這件事？';

  @override
  String get hintProblem1 => '這時傳來一個聲音，是什麼聲音？';

  @override
  String get hintProblem2 => '最先出什麼問題？';

  @override
  String hintProblem3(String who) {
    return '「$who」先試了什麼，為什麼沒成功？';
  }

  @override
  String get hintProblem4 => '誰明明能幫忙卻拒絕了？';

  @override
  String get hintProblem5 => '如果現在大家都放棄了，會怎樣？';

  @override
  String get hintProblem6 => '這個障礙裡有什麼令人難過的地方嗎？';

  @override
  String hintProblem7(String who) {
    return '這一刻「$who」大聲說了什麼？';
  }

  @override
  String hintEnding1(String who) {
    return '「$who」最終靠什麼克服了它：力量還是點子？';
  }

  @override
  String get hintEnding2 => '誰本來不必幫忙卻出手相助？';

  @override
  String hintEnding3(String who) {
    return '一切結束後，「$who」最先做什麼？';
  }

  @override
  String get hintEnding4 => '結尾和開頭相比有什麼不同？';

  @override
  String hintEnding5(String who) {
    return '「$who」回到哪裡，誰在那裡等著？';
  }

  @override
  String get hintEnding6 => '燈亮之前的最後一句話是什麼？';

  @override
  String get globeLoading => '正在準備星球…';

  @override
  String get globeLoadFailed => '星球載入失敗。';

  @override
  String get globeTitle => '童話來自哪裡？';

  @override
  String get globeStored => '已下載的童話';

  @override
  String get globeHintFar => '轉動星球或點一下國家。綠色的國家已有我們蒐集的童話，灰色的還沒有。';

  @override
  String get globeHintNear => '點一下國家或建築。綠色的國家已有我們蒐集的童話，灰色的還沒有。';

  @override
  String get globeWhole => '整個星球';

  @override
  String get globeZoomIn => '放大';

  @override
  String get globeZoomOut => '縮小';

  @override
  String globeZoomToRegion(String name) {
    return '放大查看$name →';
  }

  @override
  String get globeTellHere => '講一個這裡的童話';

  @override
  String globeTellFrom(String place) {
    return '講一個來自$place的童話 →';
  }

  @override
  String get globeOpenSea => '茫茫大海';

  @override
  String globeRegionCountries(int n) {
    return '$n個國家在一起。放大後選一個。';
  }

  @override
  String get globeTurnToCountry => '把星球轉向某個國家。';

  @override
  String get globeSpin => '轉動';

  @override
  String get globeNoTales => '我們還沒有來自這裡的童話。';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n個母題',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '來自$n篇童話',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales的$motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base，另有資源包中的$packMotifs個';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '資源包中的$n個母題',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(n, locale: localeName, other: '$n篇');
    return '正在為$region資源包準備$_temp0來自這裡的童話。';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童話',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童話',
    );
    return '$_temp0（免費）';
  }

  @override
  String cardFree(int n) {
    return '免費$n篇';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range中有$n篇',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return '你已有$n篇';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '還有$n篇準備中',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => '正在等待商店…';

  @override
  String offerDownloading(int percent) {
    return '正在下載童話… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童話',
    );
    return '購買$name：$_temp0，$price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童話',
    );
    return '下載$name：$_temp0（免費）（$size）';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n篇童話',
    );
    return '下載$name：$_temp0（$size）';
  }

  @override
  String offerDownloadTip(String name) {
    return '下載$name';
  }

  @override
  String get errDownloadTales => '童話下載失敗。';

  @override
  String get errDownloadScenes => '圖片下載失敗。';

  @override
  String get errNoDownloads => '這裡無法下載。';

  @override
  String get errOffline => '沒有網路連線，訊號恢復後再試。';

  @override
  String get errCannotBuy => '這一部分暫時無法購買。';

  @override
  String get buyPending => '購買正在等待核准，核准後會自動下載這一部分。';

  @override
  String get buyFailed => '購買未成功。';

  @override
  String get restoreNone => '此帳號沒有任何購買紀錄。';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '已還原$n個部分，可以從星球上下載。',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed => '無法還原購買，訊號恢復後再試。';

  @override
  String get narrationGone => '這篇童話已經不在拼好的狀態了。';

  @override
  String get narrationNew => '重新拼一篇';

  @override
  String narrationTitle(int index, int total) {
    return '你在講 — 第$index步，共$total步';
  }

  @override
  String narrationBridge(String bridge) {
    return '怎麼銜接：$bridge';
  }

  @override
  String get narrationSituation => '現在發生了什麼？（可不填，也可語音輸入）';

  @override
  String get narrationHintNote => '提示：不要大聲唸出來，只當作開頭的靈感。';

  @override
  String get narrationSoundsNote => '音效：合適的時候再播放。';

  @override
  String get moodTense => '緊張';

  @override
  String get moodCalm => '平靜';

  @override
  String get narrationSearching => '正在尋找…';

  @override
  String get narrationHint => '給我提示';

  @override
  String get narrationMoreHint => '再來一則';

  @override
  String get narrationBack => '返回';

  @override
  String get narrationEnd => '完';

  @override
  String get narrationNext => '下一步 →';

  @override
  String get narrationGoodnight => '晚安。';

  @override
  String get narrationEndNote => '我們暫時還做不了結尾插圖，也不能儲存到資料庫。這篇童話哪裡也不去，就留在你們之間。';

  @override
  String get narrationClose => '關閉';

  @override
  String get ragFallback => '資源包裡暫時沒有相關內容，這裡是一則通用提示：';

  @override
  String get ragNoModel => '此版本不包含提示模型。';

  @override
  String get ragHintGeneral => '通用';

  @override
  String get ragHintMotif => '針對母題';

  @override
  String get captionExact => '插圖 · 對應這個母題';

  @override
  String get captionSimilar => '插圖 · 相似場景';

  @override
  String get captionCard => '母題卡片 · 這一步暫時沒有場景';

  @override
  String get storageTitle => '已下載的童話';

  @override
  String get storageEmpty => '暫時沒有，更多童話可從星球上下載。';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n個資源包',
    );
    return '$_temp0，$size';
  }

  @override
  String storageScenes(String name) {
    return '$name的場景';
  }

  @override
  String get storageFreeTier => '免費';

  @override
  String get storageBoughtTier => '已購買';

  @override
  String get storageDelete => '刪除';

  @override
  String get storageScenesSub => '講述的每一步都配有一張圖';

  @override
  String get storageDownload => '下載';

  @override
  String get storageAllUsed => '過去30天內的內容都用過。';

  @override
  String storageFreed(String size) {
    return '已釋放$size。';
  }

  @override
  String get storageFreeUp => '釋放空間（30天未使用）';

  @override
  String get storageRestoring => '正在還原購買…';

  @override
  String get storageRestore => '還原購買';

  @override
  String get osnovaTitle => '大綱';

  @override
  String get osnovaSummary => '童話概要';

  @override
  String get osnovaCharacters => '角色';

  @override
  String get osnovaTask => '任務';

  @override
  String get osnovaProblem => '問題';

  @override
  String get osnovaEnding => '結局';

  @override
  String get osnovaAgain => '重來';

  @override
  String get osnovaTell => '我來講 →';

  @override
  String get outlineHero => '主角';

  @override
  String get castFox => '聰明的狐狸';

  @override
  String get castSmithSon => '鐵匠的兒子';

  @override
  String get castMill => '會說話的磨坊';

  @override
  String get castGooseGirl => '牧鵝姑娘';

  @override
  String get castBrothers => '三兄弟';

  @override
  String get castClockworkPrincess => '鐘錶匠的公主';

  @override
  String get castOwl => '智慧的貓頭鷹';

  @override
  String get castBlacksmith => '年邁的女鐵匠';

  @override
  String get castDragon => '小龍';

  @override
  String get castWaterSprite => '水妖';

  @override
  String get castFourPrincesses => '四位公主';

  @override
  String get castTravelingTailor => '流浪裁縫';

  @override
  String get castTalkingCat => '會說話的貓';

  @override
  String get castForestHermit => '森林隱士';

  @override
  String get castC0AndersenTheShadow => '曾經是影子的老爺';

  @override
  String get castC1GrimmTheGooseGirl => '背叛的侍女';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => '擁有鬧鬼城堡的國王';

  @override
  String get castC3AndersenTheShadow => '機靈的影子';

  @override
  String get castC4PerraultRiquetWithTheTuft => '漂亮卻不太聰明的公主';

  @override
  String get castC5AndersenTheRedShoes => '最終原諒人的天使';

  @override
  String get castC6GrimmRumpelstiltskin => '磨坊主聰明的女兒';

  @override
  String get castC7PerraultLittleRedRidingHood => '開門的外婆';

  @override
  String get castC8PerraultLittleThumb => '夾在貧困與愛之間的母親';

  @override
  String get castC9PerraultIntroduction => '有耐心的女人';

  @override
  String get castC10AndersenTheRealPrincess => '支持兒子的國王';

  @override
  String get castC11GrimmLilyAndTheLion => '信守承諾的女兒';

  @override
  String get castC12AndersenTheRealPrincess => '尋找真公主的王子';

  @override
  String get castC13AndersenTheLittleMatchGirl => '賣火柴的小女孩';

  @override
  String get castC14AndersenTheEmperorSNewClothes => '沉默的朝臣';

  @override
  String get castC15PerraultRiquetWithTheTuft => '忠誠的僕人準備宴席';

  @override
  String get castC16PerraultTheFairy => '傲慢的女兒';

  @override
  String get castC17GrimmFirstStory => '想要九條尾巴的寡婦';

  @override
  String get motifTaskWine => '誰能喝光一整個酒窖的酒';

  @override
  String get motifTaskDiamonds => '為鑽石而飛行';

  @override
  String get motifTaskRingDuck => '鴨子肚裡的戒指';

  @override
  String get motifTaskGiants => '智勝巨人';

  @override
  String get motifTaskTomThumb => '拇指小子的逃跑';

  @override
  String get motifTaskSwineherd => '贏得公主的芳心';

  @override
  String get motifTaskBell => '森林裡神祕的鐘';

  @override
  String get motifTaskGoldenObject => '不能濫用的禮物';

  @override
  String get motifTaskPebbles => '鵝卵石小路';

  @override
  String get motifProblemFoxPride => '狐狸的傲慢';

  @override
  String get motifProblemLazySister => '懶惰的姊妹';

  @override
  String get motifProblemWitchBoots => '穿七里靴的女巫';

  @override
  String get motifProblemTailorDoubt => '沒人相信他';

  @override
  String get motifProblemLions => '城門口的飢餓獅子';

  @override
  String get motifProblemEagle => '老鷹與矮人';

  @override
  String get motifProblemTruth => '神奇的動物說出真相';

  @override
  String get motifProblemOldHouse => '沒人想要老房子';

  @override
  String get motifProblemBreadcrumbs => '鳥兒吃光了麵包屑';

  @override
  String get motifEndingTrickWins => '機智獲勝';

  @override
  String get motifEndingTruthChild => '孩子說出真相';

  @override
  String get motifEndingNewHome => '新家，老朋友';

  @override
  String get motifEndingHappyTogether => '從此幸福地生活在一起';

  @override
  String get motifEndingKissWakes => '一個吻喚醒王國';

  @override
  String get motifEndingLeapfrog => '機智跳得最高';

  @override
  String get motifEndingCurseBroken => '詛咒解除了';

  @override
  String get motifEndingWelcomedHome => '在家受到歡迎';

  @override
  String get motifEndingSlipper => '遺失的鞋子';
}
