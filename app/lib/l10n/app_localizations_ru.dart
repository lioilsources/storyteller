// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get castTitle => 'Кто будет в сказке?';

  @override
  String get castHint =>
      'Коснись карточки, чтобы получить другого героя. Убрать карточку можно крестиком. Музыка и звуки всегда готовы из пакета страны, только картинка героя иногда дорисовывается чуть позже.';

  @override
  String get castAdd => 'Добавить героя';

  @override
  String get castCount => 'Состав:';

  @override
  String get castShuffleAll => 'Перемешать всех';

  @override
  String get castContinue => 'Дальше →';

  @override
  String get shuffle => 'Перемешать';

  @override
  String get motifTaskTitle => 'Какое задание?';

  @override
  String get motifProblemTitle => 'Какая проблема?';

  @override
  String get motifEndingTitle => 'Какой конец?';

  @override
  String get motifTaskCaption =>
      'Коснись карточки, чтобы выбрать задание для героя.';

  @override
  String get motifProblemCaption =>
      'Коснись карточки, чтобы выбрать препятствие или злодея.';

  @override
  String get motifEndingCaption =>
      'Коснись карточки, чтобы выбрать счастливый конец.';

  @override
  String get beatCastTitle => 'Кто в ней участвует';

  @override
  String get beatTaskTitle => 'Что задумал герой';

  @override
  String get beatProblemTitle => 'Что встало на пути';

  @override
  String get beatEndingTitle => 'Чем всё закончилось';

  @override
  String get beatCastCaption =>
      'Представь героев: где они, как выглядят, что в них особенного.';

  @override
  String get beatTaskCaption =>
      'Скажи, чего хочет герой и почему он отправился в путь.';

  @override
  String get beatProblemCaption =>
      'Поставь что-нибудь у него на пути. Пусть на время покажется, что ничего не выйдет.';

  @override
  String get beatEndingCaption =>
      'Доведи сказку до конца. Не спеши: конец ребёнок запоминает лучше всего.';

  @override
  String get hintHero => 'герой';

  @override
  String hintCast1(String who) {
    return 'Как выглядит «$who», когда появляется впервые?';
  }

  @override
  String hintCast2(String who) {
    return 'Чем занят «$who» перед тем, как начнётся вся история?';
  }

  @override
  String hintCast3(String who) {
    return 'Чего боится «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'По чему ты узнаешь, что идёт «$who»?';
  }

  @override
  String get hintCast5 => 'Кто из них давно знаком и откуда?';

  @override
  String get hintCast6 => 'Какая погода, когда они встречаются?';

  @override
  String hintCast7(String who) {
    return 'Что у «$who» в кармане?';
  }

  @override
  String hintTask1(String who) {
    return 'Когда «$who» понимает, что пора браться за дело?';
  }

  @override
  String hintTask2(String who) {
    return 'Кто дал совет и почему «$who» его слушает?';
  }

  @override
  String hintTask3(String who) {
    return 'Что «$who» придётся оставить дома?';
  }

  @override
  String get hintTask4 => 'Как долог путь и через что он ведёт?';

  @override
  String hintTask5(String who) {
    return 'Что обещает себе «$who» перед выходом?';
  }

  @override
  String get hintTask6 => 'Почему никто другой не может этого сделать?';

  @override
  String get hintProblem1 => 'В этот миг раздаётся звук. Какой?';

  @override
  String get hintProblem2 => 'Что идёт не так в первую очередь?';

  @override
  String hintProblem3(String who) {
    return 'Что «$who» пробует сначала и почему не получается?';
  }

  @override
  String get hintProblem4 => 'Кто отказывается помочь, хотя мог бы?';

  @override
  String get hintProblem5 => 'Что случилось бы, если бы сейчас все сдались?';

  @override
  String get hintProblem6 => 'Есть ли в этом препятствии что-то грустное?';

  @override
  String hintProblem7(String who) {
    return 'Что «$who» говорит вслух в этот миг?';
  }

  @override
  String hintEnding1(String who) {
    return 'Чем «$who» в конце концов это преодолевает: силой или смекалкой?';
  }

  @override
  String get hintEnding2 => 'Кто помогает, хотя мог бы и не помогать?';

  @override
  String hintEnding3(String who) {
    return 'Что «$who» делает первым делом, когда всё позади?';
  }

  @override
  String get hintEnding4 => 'Что в конце по-другому, чем в начале?';

  @override
  String hintEnding5(String who) {
    return 'Куда возвращается «$who» и кто его там ждёт?';
  }

  @override
  String get hintEnding6 =>
      'Какая последняя фраза перед тем, как загорится свет?';

  @override
  String get globeLoading => 'Готовлю планету…';

  @override
  String get globeLoadFailed => 'Не удалось загрузить планету.';

  @override
  String get globeTitle => 'Откуда будет сказка?';

  @override
  String get globeStored => 'Загруженные сказки';

  @override
  String get globeHintFar =>
      'Покрути планету или коснись страны. У зелёных стран уже есть сказки из нашей коллекции, у серых пока нет.';

  @override
  String get globeHintNear =>
      'Коснись страны или здания. У зелёных стран уже есть сказки из нашей коллекции, у серых пока нет.';

  @override
  String get globeWhole => 'Вся планета';

  @override
  String get globeZoomIn => 'Приблизить';

  @override
  String get globeZoomOut => 'Отдалить';

  @override
  String globeZoomToRegion(String name) {
    return 'Приблизить: $name →';
  }

  @override
  String get globeTellHere => 'Рассказать сказку отсюда';

  @override
  String globeTellFrom(String place) {
    return 'Рассказать сказку: $place →';
  }

  @override
  String get globeOpenSea => 'Открытое море';

  @override
  String globeRegionCountries(int n) {
    return 'Стран вместе: $n. Приблизь и выбери одну.';
  }

  @override
  String get globeTurnToCountry => 'Поверни планету к какой-нибудь стране.';

  @override
  String get globeSpin => 'Крутить';

  @override
  String get globeNoTales => 'Отсюда у нас пока нет сказок.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n мотива',
      many: '$n мотивов',
      few: '$n мотива',
      one: '$n мотив',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'из $n сказки',
      many: 'из $n сказок',
      few: 'из $n сказок',
      one: 'из $n сказки',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs из пакета';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n мотива из пакета',
      many: '$n мотивов из пакета',
      few: '$n мотива из пакета',
      one: '$n мотив из пакета',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказку',
    );
    return 'Готовим $_temp0 отсюда для пакета $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказка',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказка',
    );
    return '$_temp0 бесплатно';
  }

  @override
  String cardFree(int n) {
    return 'бесплатно: $n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n в частях $region $range',
      one: '$n в части $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'у тебя $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ещё $n готовится',
      many: 'ещё $n готовятся',
      few: 'ещё $n готовятся',
      one: 'ещё $n готовится',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Жду магазин…';

  @override
  String offerDownloading(int percent) {
    return 'Загружаю сказки… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказка',
    );
    return 'Купить $name: $_temp0 за $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказка',
    );
    return 'Загрузить $name: $_temp0 бесплатно ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n сказки',
      many: '$n сказок',
      few: '$n сказки',
      one: '$n сказка',
    );
    return 'Загрузить $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Загрузить $name';
  }

  @override
  String get errDownloadTales => 'Не удалось загрузить сказки.';

  @override
  String get errDownloadScenes => 'Не удалось загрузить картинки.';

  @override
  String get errNoDownloads => 'Загрузка здесь недоступна.';

  @override
  String get errOffline =>
      'Нет подключения к интернету — попробуй ещё раз, когда появится сигнал.';

  @override
  String get errCannotBuy => 'Эту часть сейчас нельзя купить.';

  @override
  String get buyPending =>
      'Покупка ждёт подтверждения. Часть загрузится, когда оно придёт.';

  @override
  String get buyFailed => 'Покупка не удалась.';

  @override
  String get restoreNone => 'На этом аккаунте нет покупок.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Восстановлено $n части. Загрузи их с планеты.',
      many: 'Восстановлено $n частей. Загрузи их с планеты.',
      few: 'Восстановлено $n части. Загрузи их с планеты.',
      one: 'Восстановлена $n часть. Загрузи её с планеты.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Не удалось восстановить покупки — попробуй ещё раз, когда появится сигнал.';

  @override
  String get narrationGone => 'Эта сказка больше не собрана.';

  @override
  String get narrationNew => 'Собрать новую';

  @override
  String narrationTitle(int index, int total) {
    return 'Ты рассказываешь — $index из $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Как перейти: $bridge';
  }

  @override
  String get narrationSituation =>
      'Что происходит прямо сейчас? (необязательно, можно надиктовать)';

  @override
  String get narrationHintNote =>
      'Подсказка — не зачитывай её вслух, просто оттолкнись от неё.';

  @override
  String get narrationSoundsNote =>
      'Звуки — включай, когда они подходят к рассказу.';

  @override
  String get moodTense => 'напряжение';

  @override
  String get moodCalm => 'покой';

  @override
  String get narrationSearching => 'Ищу…';

  @override
  String get narrationHint => 'Подскажи';

  @override
  String get narrationMoreHint => 'Ещё одну';

  @override
  String get narrationBack => 'Назад';

  @override
  String get narrationEnd => 'Конец';

  @override
  String get narrationNext => 'Дальше →';

  @override
  String get narrationGoodnight => 'Спокойной ночи.';

  @override
  String get narrationEndNote =>
      'Заключительную картинку и сохранение в Библиотеку мы пока не умеем — эта сказка никуда не уходит, она остаётся между вами.';

  @override
  String get narrationClose => 'Закрыть';

  @override
  String get ragFallback =>
      'В пакете пока ничего нет на эту тему — общая подсказка:';

  @override
  String get ragNoModel => 'Модели подсказок нет в этой сборке.';

  @override
  String get ragHintGeneral => 'общая';

  @override
  String get ragHintMotif => 'к мотиву';

  @override
  String get captionExact => 'иллюстрация · к этому мотиву';

  @override
  String get captionSimilar => 'иллюстрация · похожая сцена';

  @override
  String get captionCard =>
      'карточка мотива · сцены для этого шага у нас пока нет';

  @override
  String get storageTitle => 'Загруженные сказки';

  @override
  String get storageEmpty =>
      'Пока ничего — новые сказки загружаются с планеты.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n пакета',
      many: '$n пакетов',
      few: '$n пакета',
      one: '$n пакет',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Сцены: $name';
  }

  @override
  String get storageFreeTier => 'бесплатно';

  @override
  String get storageBoughtTier => 'куплено';

  @override
  String get storageDelete => 'Удалить';

  @override
  String get storageScenesSub => 'Картинка к каждому шагу рассказа';

  @override
  String get storageDownload => 'Загрузить';

  @override
  String get storageAllUsed => 'Всё использовалось за последние 30 дней.';

  @override
  String storageFreed(String size) {
    return 'Освобождено: $size.';
  }

  @override
  String get storageFreeUp => 'Освободить место (не использовалось 30 дней)';

  @override
  String get storageRestoring => 'Восстанавливаю покупки…';

  @override
  String get storageRestore => 'Восстановить покупки';

  @override
  String get osnovaTitle => 'План';

  @override
  String get osnovaSummary => 'Сказка в двух словах';

  @override
  String get osnovaCharacters => 'Герои';

  @override
  String get osnovaTask => 'Задание';

  @override
  String get osnovaProblem => 'Проблема';

  @override
  String get osnovaEnding => 'Конец';

  @override
  String get osnovaAgain => 'Заново';

  @override
  String get osnovaTell => 'Рассказываю →';

  @override
  String get outlineHero => 'Герой';

  @override
  String get castFox => 'Хитрая лиса';

  @override
  String get castSmithSon => 'Сын кузнеца';

  @override
  String get castMill => 'Говорящая мельница';

  @override
  String get castGooseGirl => 'Гусятница';

  @override
  String get castBrothers => 'Три брата';

  @override
  String get castClockworkPrincess => 'Принцесса-часовщица';

  @override
  String get castOwl => 'Мудрая сова';

  @override
  String get castBlacksmith => 'Старая кузнечиха';

  @override
  String get castDragon => 'Маленький дракон';

  @override
  String get castWaterSprite => 'Водяной';

  @override
  String get castFourPrincesses => 'Четыре принцессы';

  @override
  String get castTravelingTailor => 'Странствующий портной';

  @override
  String get castTalkingCat => 'Говорящий кот';

  @override
  String get castForestHermit => 'Лесной отшельник';

  @override
  String get castC0AndersenTheShadow => 'Господин, который был тенью';

  @override
  String get castC1GrimmTheGooseGirl => 'Вероломная служанка';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Король с заколдованным замком';

  @override
  String get castC3AndersenTheShadow => 'Хитрая тень';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Красивая, но не слишком умная принцесса';

  @override
  String get castC5AndersenTheRedShoes => 'Ангел, который прощает в конце';

  @override
  String get castC6GrimmRumpelstiltskin => 'Умная дочь мельника';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Бабушка, открывающая дверь';

  @override
  String get castC8PerraultLittleThumb => 'Мать между нуждой и любовью';

  @override
  String get castC9PerraultIntroduction => 'Терпеливая женщина';

  @override
  String get castC10AndersenTheRealPrincess => 'Король, поддерживающий сына';

  @override
  String get castC11GrimmLilyAndTheLion => 'Дочь, держащая слово';

  @override
  String get castC12AndersenTheRealPrincess => 'Принц ищет настоящую принцессу';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Девочка со спичками';

  @override
  String get castC14AndersenTheEmperorSNewClothes =>
      'Придворный, который молчит';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Верный слуга готовит пир';

  @override
  String get castC16PerraultTheFairy => 'Заносчивая дочь';

  @override
  String get castC17GrimmFirstStory => 'Вдова, которая хочет девять хвостов';

  @override
  String get motifTaskWine => 'Кто выпьет целый погреб вина';

  @override
  String get motifTaskDiamonds => 'Полёт за алмазами';

  @override
  String get motifTaskRingDuck => 'Кольцо в утке';

  @override
  String get motifTaskGiants => 'Перехитрить великанов';

  @override
  String get motifTaskTomThumb => 'Побег Мальчика-с-пальчик';

  @override
  String get motifTaskSwineherd => 'Завоевать сердце принцессы';

  @override
  String get motifTaskBell => 'Таинственный колокол в лесу';

  @override
  String get motifTaskGoldenObject => 'Дар, которым нельзя злоупотреблять';

  @override
  String get motifTaskPebbles => 'Тропинка из камешков';

  @override
  String get motifProblemFoxPride => 'Гордыня лисы';

  @override
  String get motifProblemLazySister => 'Ленивая сестра';

  @override
  String get motifProblemWitchBoots => 'Ведьма в семимильных сапогах';

  @override
  String get motifProblemTailorDoubt => 'Ему никто не верит';

  @override
  String get motifProblemLions => 'Голодные львы у ворот';

  @override
  String get motifProblemEagle => 'Орёл и карлик';

  @override
  String get motifProblemTruth => 'Волшебный зверь открывает правду';

  @override
  String get motifProblemOldHouse => 'Никому не нужен старый дом';

  @override
  String get motifProblemBreadcrumbs => 'Птицы склевали крошки';

  @override
  String get motifEndingTrickWins => 'Побеждает хитрость';

  @override
  String get motifEndingTruthChild => 'Ребёнок говорит правду';

  @override
  String get motifEndingNewHome => 'Новый дом, старые друзья';

  @override
  String get motifEndingHappyTogether => 'Счастливы вместе навсегда';

  @override
  String get motifEndingKissWakes => 'Поцелуй пробуждает королевство';

  @override
  String get motifEndingLeapfrog => 'Хитрость прыгает выше всех';

  @override
  String get motifEndingCurseBroken => 'Проклятие снято';

  @override
  String get motifEndingWelcomedHome => 'Встречают дома';

  @override
  String get motifEndingSlipper => 'Потерянная туфелька';
}
