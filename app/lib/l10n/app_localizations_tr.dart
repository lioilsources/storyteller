// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Turkish (`tr`).
class AppLocalizationsTr extends AppLocalizations {
  AppLocalizationsTr([String locale = 'tr']) : super(locale);

  @override
  String get castTitle => 'Masalda kimler olacak?';

  @override
  String get castHint =>
      'Başka bir karakter için karta dokun. Kartı çarpıyla kaldır. Müzik ve sesler her zaman ülke paketinden hazır gelir, yalnızca karakterin resmi bazen biraz geç çizilir.';

  @override
  String get castAdd => 'Karakter ekle';

  @override
  String get castCount => 'Oyuncular:';

  @override
  String get castShuffleAll => 'Hepsini karıştır';

  @override
  String get castContinue => 'Devam →';

  @override
  String get shuffle => 'Karıştır';

  @override
  String get motifTaskTitle => 'Hangi görev?';

  @override
  String get motifProblemTitle => 'Hangi sorun?';

  @override
  String get motifEndingTitle => 'Nasıl bir son?';

  @override
  String get motifTaskCaption => 'Kahramanın görevini seçmek için karta dokun.';

  @override
  String get motifProblemCaption =>
      'Bir engel ya da kötü karakter seçmek için karta dokun.';

  @override
  String get motifEndingCaption => 'Mutlu bir son seçmek için karta dokun.';

  @override
  String get beatCastTitle => 'Kimler var';

  @override
  String get beatTaskTitle => 'Kahraman ne yapmaya karar verdi';

  @override
  String get beatProblemTitle => 'Önüne ne çıktı';

  @override
  String get beatEndingTitle => 'Nasıl bitti';

  @override
  String get beatCastCaption =>
      'Karakterleri tanıt: neredeler, neye benziyorlar, nelerinde özel bir şey var.';

  @override
  String get beatTaskCaption =>
      'Kahramanın ne istediğini ve neden yola çıktığını anlat.';

  @override
  String get beatProblemCaption =>
      'Önüne bir şey çıkar. Bir süre olmayacak gibi görünsün.';

  @override
  String get beatEndingCaption =>
      'Sonuna kadar getir. Acele etme, çocuk en çok sonu hatırlar.';

  @override
  String get hintHero => 'kahraman';

  @override
  String hintCast1(String who) {
    return 'İlk göründüğünde «$who» neye benziyor?';
  }

  @override
  String hintCast2(String who) {
    return 'Bütün hikâye başlamadan hemen önce «$who» ne yapıyor?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» neden korkuyor?';
  }

  @override
  String hintCast4(String who) {
    return '«$who» geliyor olduğunu neyden anlarsın?';
  }

  @override
  String get hintCast5 =>
      'Bunlardan hangileri birbirini uzun zamandır tanıyor, nereden?';

  @override
  String get hintCast6 => 'Karşılaştıklarında hava nasıl?';

  @override
  String hintCast7(String who) {
    return '«$who» cebinde ne taşıyor?';
  }

  @override
  String hintTask1(String who) {
    return '«$who» işe girişmesi gerektiğini ne zaman anlıyor?';
  }

  @override
  String hintTask2(String who) {
    return 'Öğüdü kim verdi ve «$who» neden dinliyor?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» evde neyi bırakmak zorunda?';
  }

  @override
  String get hintTask4 => 'Yol ne kadar uzun ve nerelerden geçiyor?';

  @override
  String hintTask5(String who) {
    return '«$who» yola çıkmadan önce kendine ne söz veriyor?';
  }

  @override
  String get hintTask6 => 'Bunu neden başkası yapamıyor?';

  @override
  String get hintProblem1 => 'O anda bir ses duyuluyor, nasıl bir ses?';

  @override
  String get hintProblem2 => 'İlk önce ne ters gidiyor?';

  @override
  String hintProblem3(String who) {
    return '«$who» önce neyi deniyor ve neden işe yaramıyor?';
  }

  @override
  String get hintProblem4 => 'Yardım edebilecekken kim reddediyor?';

  @override
  String get hintProblem5 => 'Şimdi herkes vazgeçse ne olurdu?';

  @override
  String get hintProblem6 => 'Bu engelde üzücü bir şey var mı?';

  @override
  String hintProblem7(String who) {
    return 'O anda «$who» yüksek sesle ne söylüyor?';
  }

  @override
  String hintEnding1(String who) {
    return '«$who» sonunda bunu neyle aşıyor, güçle mi yoksa bir fikirle mi?';
  }

  @override
  String get hintEnding2 => 'Gerek yokken kim yardım ediyor?';

  @override
  String hintEnding3(String who) {
    return 'Her şey bitince «$who» ilk olarak ne yapıyor?';
  }

  @override
  String get hintEnding4 => 'Sonda baştakinden farklı olan ne?';

  @override
  String hintEnding5(String who) {
    return '«$who» nereye dönüyor ve orada kim bekliyor?';
  }

  @override
  String get hintEnding6 => 'Işık yanmadan önceki son cümle ne?';

  @override
  String get globeLoading => 'Gezegen hazırlanıyor…';

  @override
  String get globeLoadFailed => 'Gezegen yüklenemedi.';

  @override
  String get globeTitle => 'Masal nereden olsun?';

  @override
  String get globeStored => 'İndirilen masallar';

  @override
  String get globeHintFar =>
      'Gezegeni döndür ya da bir ülkeye dokun. Yeşil ülkelerin koleksiyonumuzdan masalları var, gri ülkelerin henüz yok.';

  @override
  String get globeHintNear =>
      'Bir ülkeye ya da yapıya dokun. Yeşil ülkelerin koleksiyonumuzdan masalları var, gri ülkelerin henüz yok.';

  @override
  String get globeWhole => 'Tüm gezegen';

  @override
  String get globeZoomIn => 'Yakınlaştır';

  @override
  String get globeZoomOut => 'Uzaklaştır';

  @override
  String globeZoomToRegion(String name) {
    return '$name bölgesine yakınlaştır →';
  }

  @override
  String get globeTellHere => 'Buradan bir masal anlat';

  @override
  String globeTellFrom(String place) {
    return '$place masalı anlat →';
  }

  @override
  String get globeOpenSea => 'Açık deniz';

  @override
  String globeRegionCountries(int n) {
    return '$n ülke bir arada. Yakınlaş ve birini seç.';
  }

  @override
  String get globeTurnToCountry => 'Gezegeni bir ülkeye doğru çevir.';

  @override
  String get globeSpin => 'Döndür';

  @override
  String get globeNoTales => 'Buradan henüz masalımız yok.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motif',
      one: '$n motif',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masaldan',
      one: '$n masaldan',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$tales $motifs';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + paketten $packMotifs';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'paketten $n motif',
      one: 'paketten $n motif',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masalı',
      one: '$n masalı',
    );
    return 'Buradan $_temp0 $region paketi için hazırlıyoruz.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masal',
      one: '$n masal',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masal',
      one: '$n masal',
    );
    return '$_temp0 ücretsiz';
  }

  @override
  String cardFree(int n) {
    return '$n ücretsiz';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$region $range bölümlerinde $n',
      one: '$region $range bölümünde $n',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'sende $n var';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n tane daha hazırlanıyor',
      one: '$n tane daha hazırlanıyor',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Mağaza bekleniyor…';

  @override
  String offerDownloading(int percent) {
    return 'Masallar indiriliyor… %$percent';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masal',
      one: '$n masal',
    );
    return '$name satın al: $_temp0, $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masal',
      one: '$n masal',
    );
    return '$name indir: $_temp0 ücretsiz ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n masal',
      one: '$n masal',
    );
    return '$name indir: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return '$name indir';
  }

  @override
  String get errDownloadTales => 'Masallar indirilemedi.';

  @override
  String get errDownloadScenes => 'Resimler indirilemedi.';

  @override
  String get errNoDownloads => 'Burada indirme kullanılamıyor.';

  @override
  String get errOffline => 'İnternet yok, sinyal gelince tekrar dene.';

  @override
  String get errCannotBuy => 'Bu bölüm şu anda satın alınamıyor.';

  @override
  String get buyPending =>
      'Satın alma onay bekliyor. Onaylanınca bölüm indirilecek.';

  @override
  String get buyFailed => 'Satın alma gerçekleşmedi.';

  @override
  String get restoreNone => 'Bu hesapta hiç satın alma yok.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bölüm geri yüklendi. Gezegenden indirebilirsin.',
      one: '$n bölüm geri yüklendi. Gezegenden indirebilirsin.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Satın almalar geri yüklenemedi, sinyal gelince tekrar dene.';

  @override
  String get narrationGone => 'Bu masal artık derlenmiş değil.';

  @override
  String get narrationNew => 'Yenisini derle';

  @override
  String narrationTitle(int index, int total) {
    return 'Anlatıyorsun — $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Nasıl bağlanır: $bridge';
  }

  @override
  String get narrationSituation =>
      'Şu anda ne oluyor? (isteğe bağlı, dikte edilebilir)';

  @override
  String get narrationHintNote =>
      'İpucu — yüksek sesle okuma, sadece başlangıç noktası yap.';

  @override
  String get narrationSoundsNote => 'Sesler — anlatıya uyduğunda çal.';

  @override
  String get moodTense => 'gerilim';

  @override
  String get moodCalm => 'sakinlik';

  @override
  String get narrationSearching => 'Aranıyor…';

  @override
  String get narrationHint => 'İpucu ver';

  @override
  String get narrationMoreHint => 'Bir tane daha';

  @override
  String get narrationBack => 'Geri';

  @override
  String get narrationEnd => 'Son';

  @override
  String get narrationNext => 'İleri →';

  @override
  String get narrationGoodnight => 'İyi geceler.';

  @override
  String get narrationEndNote =>
      'Kapanış resmi ve Kitaplığa kaydetme henüz yok. Bu masal hiçbir yere gitmiyor, aranızda kalıyor.';

  @override
  String get narrationClose => 'Kapat';

  @override
  String get ragFallback =>
      'Pakette bunun için henüz bir şey yok, genel bir ipucu:';

  @override
  String get ragNoModel => 'İpucu modeli bu sürümde yok.';

  @override
  String get ragHintGeneral => 'genel';

  @override
  String get ragHintMotif => 'motife özel';

  @override
  String get captionExact => 'illüstrasyon · bu motif için';

  @override
  String get captionSimilar => 'illüstrasyon · benzer sahne';

  @override
  String get captionCard => 'motif kartı · bu adım için henüz sahnemiz yok';

  @override
  String get storageTitle => 'İndirilen masallar';

  @override
  String get storageEmpty =>
      'Henüz hiçbir şey yok, daha fazla masal gezegenden indirilir.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paket',
      one: '$n paket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return '$name sahneleri';
  }

  @override
  String get storageFreeTier => 'ücretsiz';

  @override
  String get storageBoughtTier => 'satın alındı';

  @override
  String get storageDelete => 'Sil';

  @override
  String get storageScenesSub => 'Anlatımın her adımı için bir resim';

  @override
  String get storageDownload => 'İndir';

  @override
  String get storageAllUsed => 'Son 30 günde her şey kullanıldı.';

  @override
  String storageFreed(String size) {
    return '$size boşaltıldı.';
  }

  @override
  String get storageFreeUp => 'Yer aç (30 gündür kullanılmayanlar)';

  @override
  String get storageRestoring => 'Satın almalar geri yükleniyor…';

  @override
  String get storageRestore => 'Satın almaları geri yükle';

  @override
  String get osnovaTitle => 'Taslak';

  @override
  String get osnovaSummary => 'Kısaca masal';

  @override
  String get osnovaCharacters => 'Karakterler';

  @override
  String get osnovaTask => 'Görev';

  @override
  String get osnovaProblem => 'Sorun';

  @override
  String get osnovaEnding => 'Son';

  @override
  String get osnovaAgain => 'Yeniden';

  @override
  String get osnovaTell => 'Anlatıyorum →';

  @override
  String get outlineHero => 'Kahraman';

  @override
  String get castFox => 'Kurnaz tilki';

  @override
  String get castSmithSon => 'Demircinin oğlu';

  @override
  String get castMill => 'Konuşan değirmen';

  @override
  String get castGooseGirl => 'Kaz çobanı kız';

  @override
  String get castBrothers => 'Üç kardeş';

  @override
  String get castClockworkPrincess => 'Saatçi prenses';

  @override
  String get castOwl => 'Bilge baykuş';

  @override
  String get castBlacksmith => 'Yaşlı demirci kadın';

  @override
  String get castDragon => 'Küçük ejderha';

  @override
  String get castWaterSprite => 'Su cini';

  @override
  String get castFourPrincesses => 'Dört prenses';

  @override
  String get castTravelingTailor => 'Gezgin terzi';

  @override
  String get castTalkingCat => 'Konuşan kedi';

  @override
  String get castForestHermit => 'Ormanın ermişi';

  @override
  String get castC0AndersenTheShadow => 'Bir zamanlar gölge olan bey';

  @override
  String get castC1GrimmTheGooseGirl => 'Hain oda hizmetçisi';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'Perili şatolu kral';

  @override
  String get castC3AndersenTheShadow => 'Kurnaz gölge';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Güzel ama pek akıllı olmayan prenses';

  @override
  String get castC5AndersenTheRedShoes => 'Sonunda affeden melek';

  @override
  String get castC6GrimmRumpelstiltskin => 'Değirmencinin akıllı kızı';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Kapıyı açan nine';

  @override
  String get castC8PerraultLittleThumb => 'Yoksullukla sevgi arasında bir anne';

  @override
  String get castC9PerraultIntroduction => 'Sabırlı kadın';

  @override
  String get castC10AndersenTheRealPrincess => 'Oğluna destek olan kral';

  @override
  String get castC11GrimmLilyAndTheLion => 'Sözünü tutan kız';

  @override
  String get castC12AndersenTheRealPrincess => 'Gerçek prensesi arayan prens';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Kibritçi kız';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Susan saray adamı';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Ziyafet hazırlayan sadık hizmetçi';

  @override
  String get castC16PerraultTheFairy => 'Kibirli kız';

  @override
  String get castC17GrimmFirstStory => 'Dokuz kuyruk isteyen dul';

  @override
  String get motifTaskWine => 'Bir mahzen dolusu şarabı kim içecek';

  @override
  String get motifTaskDiamonds => 'Elmaslar için bir uçuş';

  @override
  String get motifTaskRingDuck => 'Ördeğin içindeki yüzük';

  @override
  String get motifTaskGiants => 'Devleri atlatmak';

  @override
  String get motifTaskTomThumb => 'Parmak Çocuk\'un kaçışı';

  @override
  String get motifTaskSwineherd => 'Prensesin kalbini kazanmak';

  @override
  String get motifTaskBell => 'Ormandaki gizemli çan';

  @override
  String get motifTaskGoldenObject =>
      'Kötüye kullanılmaması gereken bir armağan';

  @override
  String get motifTaskPebbles => 'Çakıl taşlarından bir patika';

  @override
  String get motifProblemFoxPride => 'Tilkinin kibri';

  @override
  String get motifProblemLazySister => 'Tembel kız kardeş';

  @override
  String get motifProblemWitchBoots => 'Yedi fersahlık çizmeli cadı';

  @override
  String get motifProblemTailorDoubt => 'Kimse ona inanmıyor';

  @override
  String get motifProblemLions => 'Kapıda aç aslanlar';

  @override
  String get motifProblemEagle => 'Kartal ile cüce';

  @override
  String get motifProblemTruth => 'Büyülü hayvan gerçeği ortaya çıkarır';

  @override
  String get motifProblemOldHouse => 'Kimse eski evi istemiyor';

  @override
  String get motifProblemBreadcrumbs => 'Kuşlar kırıntıları yedi';

  @override
  String get motifEndingTrickWins => 'Kurnazlık kazanır';

  @override
  String get motifEndingTruthChild => 'Çocuk doğruyu söyler';

  @override
  String get motifEndingNewHome => 'Yeni bir yuva, eski dostlar';

  @override
  String get motifEndingHappyTogether => 'Sonsuza dek mutlu birlikte';

  @override
  String get motifEndingKissWakes => 'Bir öpücük krallığı uyandırır';

  @override
  String get motifEndingLeapfrog => 'Kurnazlık en yükseğe sıçrar';

  @override
  String get motifEndingCurseBroken => 'Lanet bozuldu';

  @override
  String get motifEndingWelcomedHome => 'Evde karşılanmak';

  @override
  String get motifEndingSlipper => 'Kaybolan ayakkabı';
}
