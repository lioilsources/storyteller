// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Finnish (`fi`).
class AppLocalizationsFi extends AppLocalizations {
  AppLocalizationsFi([String locale = 'fi']) : super(locale);

  @override
  String get castTitle => 'Ketkä ovat sadussa mukana?';

  @override
  String get castHint =>
      'Napauta korttia saadaksesi toisen hahmon. Poista kortti rastilla. Musiikki ja äänet ovat aina valmiina maan paketista – vain hahmon kuva piirtyy joskus hetkeä myöhemmin.';

  @override
  String get castAdd => 'Lisää hahmo';

  @override
  String get castCount => 'Kokoonpano:';

  @override
  String get castShuffleAll => 'Sekoita kaikki';

  @override
  String get castContinue => 'Jatka →';

  @override
  String get shuffle => 'Sekoita';

  @override
  String get motifTaskTitle => 'Mikä tehtävä?';

  @override
  String get motifProblemTitle => 'Mikä ongelma?';

  @override
  String get motifEndingTitle => 'Mikä loppu?';

  @override
  String get motifTaskCaption => 'Napauta korttia ja valitse sankarin tehtävä.';

  @override
  String get motifProblemCaption =>
      'Napauta korttia ja valitse este tai pahis.';

  @override
  String get motifEndingCaption =>
      'Napauta korttia ja valitse onnellinen loppu.';

  @override
  String get beatCastTitle => 'Ketkä ovat mukana';

  @override
  String get beatTaskTitle => 'Mitä sankari päätti tehdä';

  @override
  String get beatProblemTitle => 'Mikä tuli tielle';

  @override
  String get beatEndingTitle => 'Miten kävi';

  @override
  String get beatCastCaption =>
      'Esittele hahmot: missä he ovat, miltä he näyttävät ja mikä heissä on erikoista.';

  @override
  String get beatTaskCaption =>
      'Kerro, mitä sankari haluaa ja miksi hän lähti matkaan.';

  @override
  String get beatProblemCaption =>
      'Laita sankarin tielle jotain. Anna näyttää hetken siltä, ettei se onnistu.';

  @override
  String get beatEndingCaption =>
      'Vie tarina loppuun. Älä kiirehdi – lapsi muistaa lopun parhaiten.';

  @override
  String get hintHero => 'sankari';

  @override
  String hintCast1(String who) {
    return 'Miltä «$who» näyttää, kun se ilmestyy ensimmäisen kerran?';
  }

  @override
  String hintCast2(String who) {
    return 'Mitä «$who» tekee juuri ennen kuin koko tarina alkaa?';
  }

  @override
  String hintCast3(String who) {
    return 'Mitä «$who» pelkää?';
  }

  @override
  String hintCast4(String who) {
    return 'Mistä tiedät, että «$who» on tulossa?';
  }

  @override
  String get hintCast5 =>
      'Ketkä heistä tuntevat toisensa jo pitkältä ajalta, ja mistä?';

  @override
  String get hintCast6 => 'Millainen sää on, kun he tapaavat?';

  @override
  String hintCast7(String who) {
    return 'Mitä «$who» pitää taskussaan?';
  }

  @override
  String hintTask1(String who) {
    return 'Milloin «$who» ymmärtää, että on ryhdyttävä toimeen?';
  }

  @override
  String hintTask2(String who) {
    return 'Kuka neuvoi, ja miksi «$who» tottelee?';
  }

  @override
  String hintTask3(String who) {
    return 'Mitä «$who» joutuu jättämään kotiin?';
  }

  @override
  String get hintTask4 => 'Kuinka pitkä matka on, ja mistä se kulkee?';

  @override
  String hintTask5(String who) {
    return 'Mitä «$who» lupaa, ennen kuin lähtee?';
  }

  @override
  String get hintTask6 => 'Miksi kukaan muu ei voi tehdä sitä?';

  @override
  String get hintProblem1 => 'Sillä hetkellä kuuluu ääni – millainen?';

  @override
  String get hintProblem2 => 'Mikä menee ensimmäisenä pieleen?';

  @override
  String hintProblem3(String who) {
    return 'Mitä «$who» yrittää ensin, ja miksi se ei onnistu?';
  }

  @override
  String get hintProblem4 => 'Kuka kieltäytyy auttamasta, vaikka voisi?';

  @override
  String get hintProblem5 => 'Mitä tapahtuisi, jos kaikki luovuttaisivat nyt?';

  @override
  String get hintProblem6 => 'Onko esteessä jotain surullista?';

  @override
  String hintProblem7(String who) {
    return 'Mitä «$who» sanoo sillä hetkellä ääneen?';
  }

  @override
  String hintEnding1(String who) {
    return 'Miten «$who» lopulta voittaa sen – voimalla vai oivalluksella?';
  }

  @override
  String get hintEnding2 => 'Kuka auttaa, vaikka ei olisi pakko?';

  @override
  String hintEnding3(String who) {
    return 'Mitä «$who» tekee aivan ensimmäiseksi, kun kaikki on ohi?';
  }

  @override
  String get hintEnding4 => 'Mikä on lopussa toisin kuin alussa?';

  @override
  String hintEnding5(String who) {
    return 'Minne «$who» palaa, ja kuka siellä odottaa?';
  }

  @override
  String get hintEnding6 => 'Mikä on viimeinen lause, ennen kuin valo syttyy?';

  @override
  String get globeLoading => 'Valmistelen planeettaa…';

  @override
  String get globeLoadFailed => 'Planeettaa ei voitu ladata.';

  @override
  String get globeTitle => 'Mistä sadun pitäisi olla?';

  @override
  String get globeStored => 'Ladatut sadut';

  @override
  String get globeHintFar =>
      'Pyöritä planeettaa tai napauta maata. Vihreillä mailla on jo satuja kokoelmastamme, harmailla ei vielä.';

  @override
  String get globeHintNear =>
      'Napauta maata tai rakennusta. Vihreillä mailla on jo satuja kokoelmastamme, harmailla ei vielä.';

  @override
  String get globeWhole => 'Koko planeetta';

  @override
  String get globeZoomIn => 'Lähennä';

  @override
  String get globeZoomOut => 'Loitonna';

  @override
  String globeZoomToRegion(String name) {
    return 'Lähennä: $name →';
  }

  @override
  String get globeTellHere => 'Kerro satu täältä';

  @override
  String globeTellFrom(String place) {
    return 'Kerro satu: $place →';
  }

  @override
  String get globeOpenSea => 'Aava meri';

  @override
  String globeRegionCountries(int n) {
    return '$n maata yhdessä. Lähennä ja valitse yksi.';
  }

  @override
  String get globeTurnToCountry => 'Käännä planeetta jonkin maan kohdalle.';

  @override
  String get globeSpin => 'Pyöritä';

  @override
  String get globeNoTales => 'Täältä meillä ei vielä ole satuja.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n aihetta',
      one: '$n aihe',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n sadusta',
      one: '$n sadusta',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs paketista';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n aihetta paketista',
      one: '$n aihe paketista',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n sadun',
    );
    return 'Valmistelemme täältä $_temp0 pakettiin $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n satu',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n satu',
    );
    return '$_temp0 ilmaiseksi';
  }

  @override
  String cardFree(int n) {
    return '$n ilmaiseksi';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n osissa $region $range',
      one: '$n osassa $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'sinulla on $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n lisää tulossa',
      one: '$n lisää tulossa',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Odotetaan kauppaa…';

  @override
  String offerDownloading(int percent) {
    return 'Ladataan satuja… $percent %';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n satu',
    );
    return 'Osta $name: $_temp0 hintaan $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n satu',
    );
    return 'Lataa $name: $_temp0 ilmaiseksi ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n satua',
      one: '$n satu',
    );
    return 'Lataa $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Lataa $name';
  }

  @override
  String get errDownloadTales => 'Satujen lataus epäonnistui.';

  @override
  String get errDownloadScenes => 'Kuvien lataus epäonnistui.';

  @override
  String get errNoDownloads => 'Lataus ei ole täällä käytettävissä.';

  @override
  String get errOffline =>
      'Ei verkkoyhteyttä – yritä uudelleen, kun saat signaalin.';

  @override
  String get errCannotBuy => 'Tätä osaa ei voi nyt ostaa.';

  @override
  String get buyPending =>
      'Osto odottaa hyväksyntää. Osa ladataan, kun se on mennyt läpi.';

  @override
  String get buyFailed => 'Osto ei onnistunut.';

  @override
  String get restoreNone => 'Tällä tilillä ei ole ostoja.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n osaa palautettu. Voit ladata ne planeetalta.',
      one: '$n osa palautettu. Voit ladata sen planeetalta.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Ostojen palautus epäonnistui – yritä uudelleen, kun saat signaalin.';

  @override
  String get narrationGone => 'Tätä satua ei ole enää koottuna.';

  @override
  String get narrationNew => 'Kokoa uusi';

  @override
  String narrationTitle(int index, int total) {
    return 'Kerrot – $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Näin jatkat: $bridge';
  }

  @override
  String get narrationSituation =>
      'Mitä tapahtuu juuri nyt? (valinnainen, voit sanella)';

  @override
  String get narrationHintNote =>
      'Vihje – älä sano sitä ääneen, ota siitä vain lähtökohta.';

  @override
  String get narrationSoundsNote =>
      'Äänet – soita ne, kun ne sopivat kerrontaan.';

  @override
  String get moodTense => 'jännitys';

  @override
  String get moodCalm => 'rauha';

  @override
  String get narrationSearching => 'Haetaan…';

  @override
  String get narrationHint => 'Anna vihje';

  @override
  String get narrationMoreHint => 'Vielä yksi';

  @override
  String get narrationBack => 'Takaisin';

  @override
  String get narrationEnd => 'Loppu';

  @override
  String get narrationNext => 'Eteenpäin →';

  @override
  String get narrationGoodnight => 'Hyvää yötä.';

  @override
  String get narrationEndNote =>
      'Päätöskuvaa ja tallennusta kirjastoon emme vielä osaa – tämä satu ei lähde minnekään, se jää teidän kahden väliin.';

  @override
  String get narrationClose => 'Sulje';

  @override
  String get ragFallback =>
      'Paketissa ei vielä ole tähän mitään – yleinen vihje:';

  @override
  String get ragNoModel => 'Vihjemalli ei kuulu tähän versioon.';

  @override
  String get ragHintGeneral => 'yleinen';

  @override
  String get ragHintMotif => 'aiheesta';

  @override
  String get captionExact => 'kuvitus · tälle aiheelle';

  @override
  String get captionSimilar => 'kuvitus · samankaltainen kohtaus';

  @override
  String get captionCard =>
      'aihekortti · tälle vaiheelle ei vielä ole kohtausta';

  @override
  String get storageTitle => 'Ladatut sadut';

  @override
  String get storageEmpty =>
      'Ei vielä mitään – lisää satuja ladataan planeetalta.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n pakettia',
      one: '$n paketti',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Kohtaukset: $name';
  }

  @override
  String get storageFreeTier => 'ilmainen';

  @override
  String get storageBoughtTier => 'ostettu';

  @override
  String get storageDelete => 'Poista';

  @override
  String get storageScenesSub => 'Kuva jokaiseen kerronnan vaiheeseen';

  @override
  String get storageDownload => 'Lataa';

  @override
  String get storageAllUsed =>
      'Kaikkea on käytetty viimeisten 30 päivän aikana.';

  @override
  String storageFreed(String size) {
    return '$size vapautettu.';
  }

  @override
  String get storageFreeUp => 'Vapauta tilaa (käyttämättä 30 päivää)';

  @override
  String get storageRestoring => 'Palautetaan ostoja…';

  @override
  String get storageRestore => 'Palauta ostot';

  @override
  String get osnovaTitle => 'Runko';

  @override
  String get osnovaSummary => 'Satu lyhyesti';

  @override
  String get osnovaCharacters => 'Hahmot';

  @override
  String get osnovaTask => 'Tehtävä';

  @override
  String get osnovaProblem => 'Ongelma';

  @override
  String get osnovaEnding => 'Loppu';

  @override
  String get osnovaAgain => 'Alusta';

  @override
  String get osnovaTell => 'Kerron →';

  @override
  String get outlineHero => 'Sankari';

  @override
  String get castFox => 'Viekas kettu';

  @override
  String get castSmithSon => 'Sepän poika';

  @override
  String get castMill => 'Puhuva mylly';

  @override
  String get castGooseGirl => 'Hanhipaimen';

  @override
  String get castBrothers => 'Kolme veljestä';

  @override
  String get castClockworkPrincess => 'Kelloseppä-prinsessa';

  @override
  String get castOwl => 'Viisas pöllö';

  @override
  String get castBlacksmith => 'Vanha seppä-akka';

  @override
  String get castDragon => 'Pieni lohikäärme';

  @override
  String get castWaterSprite => 'Vesihiisi';

  @override
  String get castFourPrincesses => 'Neljä prinsessaa';

  @override
  String get castTravelingTailor => 'Kiertelevä räätäli';

  @override
  String get castTalkingCat => 'Puhuva kissa';

  @override
  String get castForestHermit => 'Metsän erakko';

  @override
  String get castC0AndersenTheShadow => 'Herra, joka oli ennen varjo';

  @override
  String get castC1GrimmTheGooseGirl => 'Petollinen kamarineiti';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Kuningas, jolla on kummituslinna';

  @override
  String get castC3AndersenTheShadow => 'Viisas varjo';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Kaunis mutta ei kovin fiksu prinsessa';

  @override
  String get castC5AndersenTheRedShoes => 'Enkeli, joka lopulta antaa anteeksi';

  @override
  String get castC6GrimmRumpelstiltskin => 'Myllärin viisas tytär';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Isoäiti, joka avaa oven';

  @override
  String get castC8PerraultLittleThumb => 'Äiti kurjuuden ja rakkauden välissä';

  @override
  String get castC9PerraultIntroduction => 'Kärsivällinen nainen';

  @override
  String get castC10AndersenTheRealPrincess => 'Kuningas, joka tukee poikaansa';

  @override
  String get castC11GrimmLilyAndTheLion => 'Tytär, joka pitää sanansa';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Prinssi etsii oikeaa prinsessaa';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Pieni tulitikkutyttö';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Hovimies, joka vaikenee';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Uskollinen palvelija valmistaa juhla-aterian';

  @override
  String get castC16PerraultTheFairy => 'Ylpeä tytär';

  @override
  String get castC17GrimmFirstStory => 'Leski, joka haluaa yhdeksän häntää';

  @override
  String get motifTaskWine => 'Kuka juo kellarillisen viiniä';

  @override
  String get motifTaskDiamonds => 'Lento timanttien perässä';

  @override
  String get motifTaskRingDuck => 'Sormus ankan sisällä';

  @override
  String get motifTaskGiants => 'Jättiläisten höynäyttäminen';

  @override
  String get motifTaskTomThumb => 'Peukaloisen pako';

  @override
  String get motifTaskSwineherd => 'Prinsessan sydämen voittaminen';

  @override
  String get motifTaskBell => 'Salaperäinen kello metsässä';

  @override
  String get motifTaskGoldenObject => 'Lahja, jota ei saa käyttää väärin';

  @override
  String get motifTaskPebbles => 'Kivipolku';

  @override
  String get motifProblemFoxPride => 'Ketun ylpeys';

  @override
  String get motifProblemLazySister => 'Laiska sisar';

  @override
  String get motifProblemWitchBoots => 'Noita seitsemän peninkulman saappaissa';

  @override
  String get motifProblemTailorDoubt => 'Kukaan ei usko häntä';

  @override
  String get motifProblemLions => 'Nälkäiset leijonat portilla';

  @override
  String get motifProblemEagle => 'Kotka ja kääpiö';

  @override
  String get motifProblemTruth => 'Taikaeläin paljastaa totuuden';

  @override
  String get motifProblemOldHouse => 'Kukaan ei halua vanhaa taloa';

  @override
  String get motifProblemBreadcrumbs => 'Linnut söivät muruset';

  @override
  String get motifEndingTrickWins => 'Viekkaus voittaa';

  @override
  String get motifEndingTruthChild => 'Lapsi kertoo totuuden';

  @override
  String get motifEndingNewHome => 'Uusi koti, vanhat ystävät';

  @override
  String get motifEndingHappyTogether => 'Onnellisina yhdessä aina';

  @override
  String get motifEndingKissWakes => 'Suudelma herättää kuningaskunnan';

  @override
  String get motifEndingLeapfrog => 'Viekkaus hyppää korkeimmalle';

  @override
  String get motifEndingCurseBroken => 'Kirous murtuu';

  @override
  String get motifEndingWelcomedHome => 'Tervetuloa kotiin';

  @override
  String get motifEndingSlipper => 'Kadonnut tossu';
}
