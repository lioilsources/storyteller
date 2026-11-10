// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get castTitle => 'Kto wystąpi w bajce?';

  @override
  String get castHint =>
      'Dotknij karty, aby dostać inną postać. Kartę usuniesz krzyżykiem. Muzyka i dźwięki są zawsze gotowe z paczki kraju – tylko obrazek postaci bywa dorysowywany chwilę później.';

  @override
  String get castAdd => 'Dodaj postać';

  @override
  String get castCount => 'Obsada:';

  @override
  String get castShuffleAll => 'Przetasuj wszystko';

  @override
  String get castContinue => 'Dalej →';

  @override
  String get shuffle => 'Przetasuj';

  @override
  String get motifTaskTitle => 'Jakie zadanie?';

  @override
  String get motifProblemTitle => 'Jaki problem?';

  @override
  String get motifEndingTitle => 'Jakie zakończenie?';

  @override
  String get motifTaskCaption => 'Dotknij karty, aby wybrać zadanie bohatera.';

  @override
  String get motifProblemCaption =>
      'Dotknij karty, aby wybrać przeszkodę albo złoczyńcę.';

  @override
  String get motifEndingCaption =>
      'Dotknij karty, aby wybrać szczęśliwe zakończenie.';

  @override
  String get beatCastTitle => 'Kto w tym jest';

  @override
  String get beatTaskTitle => 'Co sobie bohater postanowił';

  @override
  String get beatProblemTitle => 'Co stanęło mu na drodze';

  @override
  String get beatEndingTitle => 'Jak się skończyło';

  @override
  String get beatCastCaption =>
      'Przedstaw postaci. Gdzie są, jak wyglądają, co jest w nich niezwykłego.';

  @override
  String get beatTaskCaption =>
      'Powiedz, czego bohater chce i dlaczego wyruszył.';

  @override
  String get beatProblemCaption =>
      'Postaw coś na jego drodze. Niech przez chwilę wygląda na to, że się nie uda.';

  @override
  String get beatEndingCaption =>
      'Doprowadź to do końca. Nie spiesz się – zakończenie dziecko pamięta najlepiej.';

  @override
  String get hintHero => 'bohater';

  @override
  String hintCast1(String who) {
    return 'Jak wygląda «$who», kiedy pojawia się po raz pierwszy?';
  }

  @override
  String hintCast2(String who) {
    return 'Co robi «$who» tuż przed początkiem całej historii?';
  }

  @override
  String hintCast3(String who) {
    return 'Czego boi się «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Po czym poznasz, że nadchodzi «$who»?';
  }

  @override
  String get hintCast5 => 'Którzy z nich znają się od dawna i skąd?';

  @override
  String get hintCast6 => 'Jaka jest pogoda, gdy się spotykają?';

  @override
  String hintCast7(String who) {
    return 'Co ma w kieszeni «$who»?';
  }

  @override
  String hintTask1(String who) {
    return 'Kiedy «$who» pojmuje, że musi się do tego zabrać?';
  }

  @override
  String hintTask2(String who) {
    return 'Kto dał radę i dlaczego «$who» jej słucha?';
  }

  @override
  String hintTask3(String who) {
    return 'Co musi zostawić w domu «$who»?';
  }

  @override
  String get hintTask4 => 'Jak długa jest droga i przez co prowadzi?';

  @override
  String hintTask5(String who) {
    return 'Co obiecuje sobie «$who», zanim wyruszy?';
  }

  @override
  String get hintTask6 => 'Dlaczego nie może tego zrobić nikt inny?';

  @override
  String get hintProblem1 => 'W tej chwili rozlega się dźwięk – jaki?';

  @override
  String get hintProblem2 => 'Co psuje się najpierw?';

  @override
  String hintProblem3(String who) {
    return 'Co «$who» próbuje najpierw i dlaczego to nie działa?';
  }

  @override
  String get hintProblem4 => 'Kto odmawia pomocy, choć mógłby pomóc?';

  @override
  String get hintProblem5 =>
      'Co by się stało, gdyby teraz wszyscy się poddali?';

  @override
  String get hintProblem6 => 'Czy jest w tej przeszkodzie coś smutnego?';

  @override
  String hintProblem7(String who) {
    return 'Co «$who» mówi na głos w tym momencie?';
  }

  @override
  String hintEnding1(String who) {
    return 'Czym «$who» ostatecznie to pokonuje – siłą czy pomysłem?';
  }

  @override
  String get hintEnding2 => 'Kto pomaga, choć nie musiał?';

  @override
  String hintEnding3(String who) {
    return 'Co robi «$who» zaraz po tym, jak jest po wszystkim?';
  }

  @override
  String get hintEnding4 => 'Co jest na końcu inaczej niż na początku?';

  @override
  String hintEnding5(String who) {
    return 'Dokąd wraca «$who» i kto tam czeka?';
  }

  @override
  String get hintEnding6 =>
      'Jakie jest ostatnie zdanie, zanim zapali się światło?';

  @override
  String get globeLoading => 'Przygotowuję planetę…';

  @override
  String get globeLoadFailed => 'Nie udało się wczytać planety.';

  @override
  String get globeTitle => 'Skąd ma być bajka?';

  @override
  String get globeStored => 'Pobrane bajki';

  @override
  String get globeHintFar =>
      'Obracaj planetę albo dotknij kraju. Zielone kraje mają już bajki z naszej kolekcji, szare jeszcze nie.';

  @override
  String get globeHintNear =>
      'Dotknij kraju albo budowli. Zielone kraje mają już bajki z naszej kolekcji, szare jeszcze nie.';

  @override
  String get globeWhole => 'Cała planeta';

  @override
  String get globeZoomIn => 'Przybliż';

  @override
  String get globeZoomOut => 'Oddal';

  @override
  String globeZoomToRegion(String name) {
    return 'Przybliż: $name →';
  }

  @override
  String get globeTellHere => 'Opowiedz bajkę stąd';

  @override
  String globeTellFrom(String place) {
    return 'Opowiedz bajkę: $place →';
  }

  @override
  String get globeOpenSea => 'Pełne morze';

  @override
  String globeRegionCountries(int n) {
    return '$n krajów razem. Przybliż i wybierz jeden.';
  }

  @override
  String get globeTurnToCountry => 'Obróć planetę w stronę jakiegoś kraju.';

  @override
  String get globeSpin => 'Zakręć';

  @override
  String get globeNoTales => 'Stąd nie mamy jeszcze żadnych bajek.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motywu',
      many: '$n motywów',
      few: '$n motywy',
      one: '$n motyw',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'z $n bajki',
      many: 'z $n bajek',
      few: 'z $n bajek',
      one: 'z $n bajki',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs z paczki';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motywu z paczki',
      many: '$n motywów z paczki',
      few: '$n motywy z paczki',
      one: '$n motyw z paczki',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajkę',
    );
    return 'Przygotowujemy $_temp0 stąd do paczki $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajka',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajka',
    );
    return '$_temp0 za darmo';
  }

  @override
  String cardFree(int n) {
    return '$n za darmo';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n w częściach $region $range',
      one: '$n w części $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'masz $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'jeszcze $n w przygotowaniu',
      many: 'jeszcze $n w przygotowaniu',
      few: 'jeszcze $n w przygotowaniu',
      one: 'jeszcze $n w przygotowaniu',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Czekam na sklep…';

  @override
  String offerDownloading(int percent) {
    return 'Pobieranie bajek… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajka',
    );
    return 'Kup $name: $_temp0 za $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajka',
    );
    return 'Pobierz $name: $_temp0 za darmo ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bajki',
      many: '$n bajek',
      few: '$n bajki',
      one: '$n bajka',
    );
    return 'Pobierz $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Pobierz $name';
  }

  @override
  String get errDownloadTales => 'Nie udało się pobrać bajek.';

  @override
  String get errDownloadScenes => 'Nie udało się pobrać obrazków.';

  @override
  String get errNoDownloads => 'Pobieranie nie jest tu dostępne.';

  @override
  String get errOffline =>
      'Brak połączenia z internetem – spróbuj ponownie, gdy złapiesz zasięg.';

  @override
  String get errCannotBuy => 'Tej części nie można teraz kupić.';

  @override
  String get buyPending =>
      'Zakup czeka na zatwierdzenie. Część zostanie pobrana, gdy przejdzie.';

  @override
  String get buyFailed => 'Zakup się nie udał.';

  @override
  String get restoreNone => 'Na tym koncie nie ma żadnych zakupów.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Przywrócono $n części. Pobierzesz je z planety.',
      many: 'Przywrócono $n części. Pobierzesz je z planety.',
      few: 'Przywrócono $n części. Pobierzesz je z planety.',
      one: 'Przywrócono $n część. Pobierzesz ją z planety.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Nie udało się przywrócić zakupów – spróbuj ponownie, gdy złapiesz zasięg.';

  @override
  String get narrationGone => 'Ta bajka nie jest już poskładana.';

  @override
  String get narrationNew => 'Poskładaj nową';

  @override
  String narrationTitle(int index, int total) {
    return 'Opowiadasz — $index z $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Jak nawiązać: $bridge';
  }

  @override
  String get narrationSituation =>
      'Co się teraz dzieje? (opcjonalnie, można podyktować)';

  @override
  String get narrationHintNote =>
      'Podpowiedź – nie czytaj jej na głos, tylko od niej odbij.';

  @override
  String get narrationSoundsNote =>
      'Dźwięki – puść je, gdy pasują do opowieści.';

  @override
  String get moodTense => 'napięcie';

  @override
  String get moodCalm => 'spokój';

  @override
  String get narrationSearching => 'Szukam…';

  @override
  String get narrationHint => 'Podpowiedz';

  @override
  String get narrationMoreHint => 'Jeszcze jedną';

  @override
  String get narrationBack => 'Wstecz';

  @override
  String get narrationEnd => 'Koniec';

  @override
  String get narrationNext => 'Dalej →';

  @override
  String get narrationGoodnight => 'Dobranoc.';

  @override
  String get narrationEndNote =>
      'Obrazka na zakończenie i zapisu w Bibliotece jeszcze nie umiemy – ta bajka nigdzie nie odchodzi, zostaje między wami.';

  @override
  String get narrationClose => 'Zamknij';

  @override
  String get ragFallback =>
      'W paczce nie ma jeszcze nic do tego – ogólna podpowiedź:';

  @override
  String get ragNoModel => 'Modelu podpowiedzi nie ma w tej wersji.';

  @override
  String get ragHintGeneral => 'ogólna';

  @override
  String get ragHintMotif => 'do motywu';

  @override
  String get captionExact => 'ilustracja · do tego motywu';

  @override
  String get captionSimilar => 'ilustracja · podobna scena';

  @override
  String get captionCard =>
      'karta motywu · do tego kroku nie mamy jeszcze sceny';

  @override
  String get storageTitle => 'Pobrane bajki';

  @override
  String get storageEmpty =>
      'Jeszcze nic – kolejne bajki pobierzesz z planety.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paczki',
      many: '$n paczek',
      few: '$n paczki',
      one: '$n paczka',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Sceny: $name';
  }

  @override
  String get storageFreeTier => 'za darmo';

  @override
  String get storageBoughtTier => 'kupione';

  @override
  String get storageDelete => 'Usuń';

  @override
  String get storageScenesSub => 'Obrazek do każdego kroku opowiadania';

  @override
  String get storageDownload => 'Pobierz';

  @override
  String get storageAllUsed =>
      'Wszystko było używane w ciągu ostatnich 30 dni.';

  @override
  String storageFreed(String size) {
    return 'Zwolniono $size.';
  }

  @override
  String get storageFreeUp => 'Zwolnij miejsce (nieużywane od 30 dni)';

  @override
  String get storageRestoring => 'Przywracam zakupy…';

  @override
  String get storageRestore => 'Przywróć zakupy';

  @override
  String get osnovaTitle => 'Plan';

  @override
  String get osnovaSummary => 'Bajka w skrócie';

  @override
  String get osnovaCharacters => 'Postaci';

  @override
  String get osnovaTask => 'Zadanie';

  @override
  String get osnovaProblem => 'Problem';

  @override
  String get osnovaEnding => 'Zakończenie';

  @override
  String get osnovaAgain => 'Od nowa';

  @override
  String get osnovaTell => 'Opowiadam →';

  @override
  String get outlineHero => 'Bohater';

  @override
  String get castFox => 'Sprytna lisica';

  @override
  String get castSmithSon => 'Syn kowala';

  @override
  String get castMill => 'Mówiący młyn';

  @override
  String get castGooseGirl => 'Pasterka gęsi';

  @override
  String get castBrothers => 'Trzej bracia';

  @override
  String get castClockworkPrincess => 'Księżniczka zegarmistrzyni';

  @override
  String get castOwl => 'Mądra sowa';

  @override
  String get castBlacksmith => 'Stara kowalka';

  @override
  String get castDragon => 'Mały smok';

  @override
  String get castWaterSprite => 'Wodnik';

  @override
  String get castFourPrincesses => 'Cztery księżniczki';

  @override
  String get castTravelingTailor => 'Wędrowny krawiec';

  @override
  String get castTalkingCat => 'Mówiący kot';

  @override
  String get castForestHermit => 'Pustelnik z lasu';

  @override
  String get castC0AndersenTheShadow => 'Pan, który był kiedyś cieniem';

  @override
  String get castC1GrimmTheGooseGirl => 'Zdradziecka pokojówka';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Król z nawiedzonym zamkiem';

  @override
  String get castC3AndersenTheShadow => 'Sprytny cień';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Piękna, lecz niezbyt mądra księżniczka';

  @override
  String get castC5AndersenTheRedShoes => 'Anioł, który w końcu przebacza';

  @override
  String get castC6GrimmRumpelstiltskin => 'Mądra córka młynarza';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Babcia, która otwiera drzwi';

  @override
  String get castC8PerraultLittleThumb => 'Matka między nędzą a miłością';

  @override
  String get castC9PerraultIntroduction => 'Cierpliwa kobieta';

  @override
  String get castC10AndersenTheRealPrincess => 'Król, który wspiera syna';

  @override
  String get castC11GrimmLilyAndTheLion => 'Córka, która dotrzymuje słowa';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Książę szuka prawdziwej księżniczki';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Dziewczynka z zapałkami';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Dworzanin, który milczy';

  @override
  String get castC15PerraultRiquetWithTheTuft => 'Wierny sługa szykuje ucztę';

  @override
  String get castC16PerraultTheFairy => 'Zarozumiała córka';

  @override
  String get castC17GrimmFirstStory => 'Wdowa, która chce dziewięciu ogonów';

  @override
  String get motifTaskWine => 'Kto wypije piwnicę wina';

  @override
  String get motifTaskDiamonds => 'Lot po diamenty';

  @override
  String get motifTaskRingDuck => 'Pierścień w kaczce';

  @override
  String get motifTaskGiants => 'Przechytrzyć olbrzymów';

  @override
  String get motifTaskTomThumb => 'Ucieczka Tomcia Paluszka';

  @override
  String get motifTaskSwineherd => 'Zdobyć serce księżniczki';

  @override
  String get motifTaskBell => 'Tajemniczy dzwon w lesie';

  @override
  String get motifTaskGoldenObject => 'Dar, którego nie wolno nadużyć';

  @override
  String get motifTaskPebbles => 'Ścieżka z kamyków';

  @override
  String get motifProblemFoxPride => 'Duma lisa';

  @override
  String get motifProblemLazySister => 'Leniwa siostra';

  @override
  String get motifProblemWitchBoots => 'Czarownica w siedmiomilowych butach';

  @override
  String get motifProblemTailorDoubt => 'Nikt mu nie wierzy';

  @override
  String get motifProblemLions => 'Głodne lwy przy bramie';

  @override
  String get motifProblemEagle => 'Orzeł i krasnolud';

  @override
  String get motifProblemTruth => 'Magiczne zwierzę zdradza prawdę';

  @override
  String get motifProblemOldHouse => 'Nikt nie chce starego domu';

  @override
  String get motifProblemBreadcrumbs => 'Ptaki zjadły okruszki';

  @override
  String get motifEndingTrickWins => 'Spryt zwycięża';

  @override
  String get motifEndingTruthChild => 'Dziecko mówi prawdę';

  @override
  String get motifEndingNewHome => 'Nowy dom, starzy przyjaciele';

  @override
  String get motifEndingHappyTogether => 'Szczęśliwi razem na zawsze';

  @override
  String get motifEndingKissWakes => 'Pocałunek budzi królestwo';

  @override
  String get motifEndingLeapfrog => 'Spryt skacze najwyżej';

  @override
  String get motifEndingCurseBroken => 'Klątwa zdjęta';

  @override
  String get motifEndingWelcomedHome => 'Witany w domu';

  @override
  String get motifEndingSlipper => 'Zgubiony pantofelek';
}
