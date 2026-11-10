// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get castTitle => 'Хто буде в казці?';

  @override
  String get castHint =>
      'Торкнися картки, щоб отримати іншого героя. Прибрати картку можна хрестиком. Музика й звуки завжди готові з пакета країни, лише малюнок героя іноді домальовується трохи згодом.';

  @override
  String get castAdd => 'Додати героя';

  @override
  String get castCount => 'Склад:';

  @override
  String get castShuffleAll => 'Перемішати всіх';

  @override
  String get castContinue => 'Далі →';

  @override
  String get shuffle => 'Перемішати';

  @override
  String get motifTaskTitle => 'Яке завдання?';

  @override
  String get motifProblemTitle => 'Яка проблема?';

  @override
  String get motifEndingTitle => 'Який кінець?';

  @override
  String get motifTaskCaption =>
      'Торкнися картки, щоб вибрати завдання для героя.';

  @override
  String get motifProblemCaption =>
      'Торкнися картки, щоб вибрати перешкоду або лиходія.';

  @override
  String get motifEndingCaption =>
      'Торкнися картки, щоб вибрати щасливий кінець.';

  @override
  String get beatCastTitle => 'Хто в ній бере участь';

  @override
  String get beatTaskTitle => 'Що задумав герой';

  @override
  String get beatProblemTitle => 'Що стало на шляху';

  @override
  String get beatEndingTitle => 'Чим усе закінчилося';

  @override
  String get beatCastCaption =>
      'Представ героїв: де вони, як виглядають, що в них особливого.';

  @override
  String get beatTaskCaption =>
      'Скажи, чого хоче герой і чому він вирушив у дорогу.';

  @override
  String get beatProblemCaption =>
      'Постав щось у нього на шляху. Нехай на мить здасться, що нічого не вийде.';

  @override
  String get beatEndingCaption =>
      'Доведи казку до кінця. Не поспішай: кінець дитина запам’ятовує найкраще.';

  @override
  String get hintHero => 'герой';

  @override
  String hintCast1(String who) {
    return 'Як виглядає «$who», коли з’являється вперше?';
  }

  @override
  String hintCast2(String who) {
    return 'Що робить «$who» перед тим, як почнеться вся історія?';
  }

  @override
  String hintCast3(String who) {
    return 'Чого боїться «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Як ти дізнаєшся, що йде «$who»?';
  }

  @override
  String get hintCast5 => 'Хто з них давно знайомий і звідки?';

  @override
  String get hintCast6 => 'Яка погода, коли вони зустрічаються?';

  @override
  String hintCast7(String who) {
    return 'Що в «$who» у кишені?';
  }

  @override
  String hintTask1(String who) {
    return 'Коли «$who» розуміє, що час братися до діла?';
  }

  @override
  String hintTask2(String who) {
    return 'Хто дав пораду і чому «$who» її слухає?';
  }

  @override
  String hintTask3(String who) {
    return 'Що «$who» доведеться залишити вдома?';
  }

  @override
  String get hintTask4 => 'Яка довга дорога і через що вона веде?';

  @override
  String hintTask5(String who) {
    return 'Що обіцяє собі «$who» перед виходом?';
  }

  @override
  String get hintTask6 => 'Чому ніхто інший не може цього зробити?';

  @override
  String get hintProblem1 => 'У цю мить лунає звук. Який?';

  @override
  String get hintProblem2 => 'Що йде не так найперше?';

  @override
  String hintProblem3(String who) {
    return 'Що «$who» пробує спочатку і чому не виходить?';
  }

  @override
  String get hintProblem4 => 'Хто відмовляється допомогти, хоча міг би?';

  @override
  String get hintProblem5 => 'Що було б, якби зараз усі здалися?';

  @override
  String get hintProblem6 => 'Чи є в цій перешкоді щось сумне?';

  @override
  String hintProblem7(String who) {
    return 'Що «$who» каже вголос у цю мить?';
  }

  @override
  String hintEnding1(String who) {
    return 'Чим «$who» зрештою це долає: силою чи кмітливістю?';
  }

  @override
  String get hintEnding2 => 'Хто допомагає, хоча не мусив?';

  @override
  String hintEnding3(String who) {
    return 'Що «$who» робить насамперед, коли все позаду?';
  }

  @override
  String get hintEnding4 => 'Що в кінці інакше, ніж на початку?';

  @override
  String hintEnding5(String who) {
    return 'Куди повертається «$who» і хто там на нього чекає?';
  }

  @override
  String get hintEnding6 =>
      'Яка остання фраза перед тим, як засвітиться світло?';

  @override
  String get globeLoading => 'Готую планету…';

  @override
  String get globeLoadFailed => 'Не вдалося завантажити планету.';

  @override
  String get globeTitle => 'Звідки буде казка?';

  @override
  String get globeStored => 'Завантажені казки';

  @override
  String get globeHintFar =>
      'Покрути планету або торкнися країни. У зелених країн уже є казки з нашої колекції, у сірих поки немає.';

  @override
  String get globeHintNear =>
      'Торкнися країни або споруди. У зелених країн уже є казки з нашої колекції, у сірих поки немає.';

  @override
  String get globeWhole => 'Вся планета';

  @override
  String get globeZoomIn => 'Наблизити';

  @override
  String get globeZoomOut => 'Віддалити';

  @override
  String globeZoomToRegion(String name) {
    return 'Наблизити: $name →';
  }

  @override
  String get globeTellHere => 'Розповісти казку звідси';

  @override
  String globeTellFrom(String place) {
    return 'Розповісти казку: $place →';
  }

  @override
  String get globeOpenSea => 'Відкрите море';

  @override
  String globeRegionCountries(int n) {
    return 'Країн разом: $n. Наблизь і вибери одну.';
  }

  @override
  String get globeTurnToCountry => 'Поверни планету до якоїсь країни.';

  @override
  String get globeSpin => 'Крутити';

  @override
  String get globeNoTales => 'Звідси в нас поки немає казок.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n мотиву',
      many: '$n мотивів',
      few: '$n мотиви',
      one: '$n мотив',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'з $n казки',
      many: 'з $n казок',
      few: 'з $n казок',
      one: 'з $n казки',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs з пакета';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n мотиву з пакета',
      many: '$n мотивів із пакета',
      few: '$n мотиви з пакета',
      one: '$n мотив із пакета',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казку',
    );
    return 'Готуємо $_temp0 звідси для пакета $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казка',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казка',
    );
    return '$_temp0 безкоштовно';
  }

  @override
  String cardFree(int n) {
    return 'безкоштовно: $n';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n у частинах $region $range',
      one: '$n у частині $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'у тебе $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'ще $n готується',
      many: 'ще $n готуються',
      few: 'ще $n готуються',
      one: 'ще $n готується',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Чекаю на магазин…';

  @override
  String offerDownloading(int percent) {
    return 'Завантажую казки… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казка',
    );
    return 'Купити $name: $_temp0 за $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казка',
    );
    return 'Завантажити $name: $_temp0 безкоштовно ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n казки',
      many: '$n казок',
      few: '$n казки',
      one: '$n казка',
    );
    return 'Завантажити $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Завантажити $name';
  }

  @override
  String get errDownloadTales => 'Не вдалося завантажити казки.';

  @override
  String get errDownloadScenes => 'Не вдалося завантажити малюнки.';

  @override
  String get errNoDownloads => 'Завантаження тут недоступне.';

  @override
  String get errOffline =>
      'Немає підключення до інтернету — спробуй ще раз, коли з’явиться сигнал.';

  @override
  String get errCannotBuy => 'Цю частину зараз не можна купити.';

  @override
  String get buyPending =>
      'Покупка чекає на підтвердження. Частина завантажиться, коли воно надійде.';

  @override
  String get buyFailed => 'Покупка не вдалася.';

  @override
  String get restoreNone => 'На цьому акаунті немає покупок.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Відновлено $n частини. Завантаж їх з планети.',
      many: 'Відновлено $n частин. Завантаж їх з планети.',
      few: 'Відновлено $n частини. Завантаж їх з планети.',
      one: 'Відновлено $n частину. Завантаж її з планети.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Не вдалося відновити покупки — спробуй ще раз, коли з’явиться сигнал.';

  @override
  String get narrationGone => 'Ця казка вже не зібрана.';

  @override
  String get narrationNew => 'Зібрати нову';

  @override
  String narrationTitle(int index, int total) {
    return 'Ти розповідаєш — $index із $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Як перейти: $bridge';
  }

  @override
  String get narrationSituation =>
      'Що відбувається просто зараз? (необов’язково, можна надиктувати)';

  @override
  String get narrationHintNote =>
      'Підказка — не читай її вголос, просто відштовхнися від неї.';

  @override
  String get narrationSoundsNote =>
      'Звуки — вмикай, коли вони пасують до розповіді.';

  @override
  String get moodTense => 'напруга';

  @override
  String get moodCalm => 'спокій';

  @override
  String get narrationSearching => 'Шукаю…';

  @override
  String get narrationHint => 'Підкажи';

  @override
  String get narrationMoreHint => 'Ще одну';

  @override
  String get narrationBack => 'Назад';

  @override
  String get narrationEnd => 'Кінець';

  @override
  String get narrationNext => 'Далі →';

  @override
  String get narrationGoodnight => 'На добраніч.';

  @override
  String get narrationEndNote =>
      'Завершальну картинку й збереження в Бібліотеку ми поки не вміємо — ця казка нікуди не йде, вона залишається між вами.';

  @override
  String get narrationClose => 'Закрити';

  @override
  String get ragFallback =>
      'У пакеті поки нічого на цю тему — загальна підказка:';

  @override
  String get ragNoModel => 'Моделі підказок немає в цій збірці.';

  @override
  String get ragHintGeneral => 'загальна';

  @override
  String get ragHintMotif => 'до мотиву';

  @override
  String get captionExact => 'ілюстрація · до цього мотиву';

  @override
  String get captionSimilar => 'ілюстрація · схожа сцена';

  @override
  String get captionCard =>
      'картка мотиву · сцени для цього кроку в нас поки немає';

  @override
  String get storageTitle => 'Завантажені казки';

  @override
  String get storageEmpty =>
      'Поки нічого — нові казки завантажуються з планети.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n пакета',
      many: '$n пакетів',
      few: '$n пакети',
      one: '$n пакет',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Сцени: $name';
  }

  @override
  String get storageFreeTier => 'безкоштовно';

  @override
  String get storageBoughtTier => 'куплено';

  @override
  String get storageDelete => 'Видалити';

  @override
  String get storageScenesSub => 'Малюнок до кожного кроку розповіді';

  @override
  String get storageDownload => 'Завантажити';

  @override
  String get storageAllUsed => 'Усе використовувалося за останні 30 днів.';

  @override
  String storageFreed(String size) {
    return 'Звільнено: $size.';
  }

  @override
  String get storageFreeUp => 'Звільнити місце (не використовувалося 30 днів)';

  @override
  String get storageRestoring => 'Відновлюю покупки…';

  @override
  String get storageRestore => 'Відновити покупки';

  @override
  String get osnovaTitle => 'План';

  @override
  String get osnovaSummary => 'Казка в двох словах';

  @override
  String get osnovaCharacters => 'Герої';

  @override
  String get osnovaTask => 'Завдання';

  @override
  String get osnovaProblem => 'Проблема';

  @override
  String get osnovaEnding => 'Кінець';

  @override
  String get osnovaAgain => 'Наново';

  @override
  String get osnovaTell => 'Розповідаю →';

  @override
  String get outlineHero => 'Герой';

  @override
  String get castFox => 'Хитра лисиця';

  @override
  String get castSmithSon => 'Син коваля';

  @override
  String get castMill => 'Млин, що говорить';

  @override
  String get castGooseGirl => 'Гусопаска';

  @override
  String get castBrothers => 'Троє братів';

  @override
  String get castClockworkPrincess => 'Принцеса-годинникарка';

  @override
  String get castOwl => 'Мудра сова';

  @override
  String get castBlacksmith => 'Стара ковалиха';

  @override
  String get castDragon => 'Маленький дракон';

  @override
  String get castWaterSprite => 'Водяник';

  @override
  String get castFourPrincesses => 'Чотири принцеси';

  @override
  String get castTravelingTailor => 'Мандрівний кравець';

  @override
  String get castTalkingCat => 'Кіт, що говорить';

  @override
  String get castForestHermit => 'Лісовий відлюдник';

  @override
  String get castC0AndersenTheShadow => 'Пан, що колись був тінню';

  @override
  String get castC1GrimmTheGooseGirl => 'Підступна покоївка';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Король із привидним замком';

  @override
  String get castC3AndersenTheShadow => 'Хитра тінь';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Гарна, але не надто розумна принцеса';

  @override
  String get castC5AndersenTheRedShoes => 'Ангел, що наприкінці прощає';

  @override
  String get castC6GrimmRumpelstiltskin => 'Розумна донька мірошника';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Бабуся, що відчиняє двері';

  @override
  String get castC8PerraultLittleThumb => 'Мати між нестатками й любов’ю';

  @override
  String get castC9PerraultIntroduction => 'Терпляча жінка';

  @override
  String get castC10AndersenTheRealPrincess => 'Король, що підтримує сина';

  @override
  String get castC11GrimmLilyAndTheLion => 'Донька, що тримає слово';

  @override
  String get castC12AndersenTheRealPrincess => 'Принц шукає справжню принцесу';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Дівчинка з сірниками';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Придворний, що мовчить';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Вірний слуга готує учту';

  @override
  String get castC16PerraultTheFairy => 'Зарозуміла донька';

  @override
  String get castC17GrimmFirstStory => 'Вдова, що хоче дев’ять хвостів';

  @override
  String get motifTaskWine => 'Хто вип’є цілий льох вина';

  @override
  String get motifTaskDiamonds => 'Політ по діаманти';

  @override
  String get motifTaskRingDuck => 'Перстень у качці';

  @override
  String get motifTaskGiants => 'Перехитрити велетнів';

  @override
  String get motifTaskTomThumb => 'Втеча Мізинчика';

  @override
  String get motifTaskSwineherd => 'Завоювати серце принцеси';

  @override
  String get motifTaskBell => 'Таємничий дзвін у лісі';

  @override
  String get motifTaskGoldenObject => 'Дар, яким не можна зловживати';

  @override
  String get motifTaskPebbles => 'Стежка з камінців';

  @override
  String get motifProblemFoxPride => 'Лисяча пиха';

  @override
  String get motifProblemLazySister => 'Лінива сестра';

  @override
  String get motifProblemWitchBoots => 'Відьма в семимильних чоботях';

  @override
  String get motifProblemTailorDoubt => 'Йому ніхто не вірить';

  @override
  String get motifProblemLions => 'Голодні леви біля брами';

  @override
  String get motifProblemEagle => 'Орел і карлик';

  @override
  String get motifProblemTruth => 'Чарівний звір розкриває правду';

  @override
  String get motifProblemOldHouse => 'Нікому не потрібен старий дім';

  @override
  String get motifProblemBreadcrumbs => 'Птахи склювали крихти';

  @override
  String get motifEndingTrickWins => 'Перемагає хитрість';

  @override
  String get motifEndingTruthChild => 'Дитина каже правду';

  @override
  String get motifEndingNewHome => 'Новий дім, старі друзі';

  @override
  String get motifEndingHappyTogether => 'Щасливі разом назавжди';

  @override
  String get motifEndingKissWakes => 'Поцілунок пробуджує королівство';

  @override
  String get motifEndingLeapfrog => 'Хитрість стрибає найвище';

  @override
  String get motifEndingCurseBroken => 'Прокляття знято';

  @override
  String get motifEndingWelcomedHome => 'Зустрічають удома';

  @override
  String get motifEndingSlipper => 'Загублений черевичок';
}
