// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get castTitle => 'Siapa saja yang ada dalam dongeng?';

  @override
  String get castHint =>
      'Ketuk kartu untuk mendapat tokoh lain. Hapus kartu dengan tanda silang. Musik dan suara selalu sudah siap dari paket negara; hanya gambar tokoh yang kadang digambar sedikit lebih lambat.';

  @override
  String get castAdd => 'Tambah tokoh';

  @override
  String get castCount => 'Pemeran:';

  @override
  String get castShuffleAll => 'Acak semua';

  @override
  String get castContinue => 'Lanjut →';

  @override
  String get shuffle => 'Acak';

  @override
  String get motifTaskTitle => 'Tugas apa?';

  @override
  String get motifProblemTitle => 'Masalah apa?';

  @override
  String get motifEndingTitle => 'Akhir seperti apa?';

  @override
  String get motifTaskCaption =>
      'Ketuk kartu untuk memilih tugas sang pahlawan.';

  @override
  String get motifProblemCaption =>
      'Ketuk kartu untuk memilih rintangan atau tokoh jahat.';

  @override
  String get motifEndingCaption =>
      'Ketuk kartu untuk memilih akhir yang bahagia.';

  @override
  String get beatCastTitle => 'Siapa yang ada';

  @override
  String get beatTaskTitle => 'Apa yang dicita-citakan sang pahlawan';

  @override
  String get beatProblemTitle => 'Apa yang menghalangi jalannya';

  @override
  String get beatEndingTitle => 'Bagaimana akhirnya';

  @override
  String get beatCastCaption =>
      'Perkenalkan para tokoh: di mana mereka, seperti apa rupanya, apa yang istimewa dari mereka.';

  @override
  String get beatTaskCaption =>
      'Ceritakan apa yang diinginkan sang pahlawan dan mengapa ia berangkat.';

  @override
  String get beatProblemCaption =>
      'Letakkan sesuatu di jalannya. Biarkan sesaat tampak seolah tak akan berhasil.';

  @override
  String get beatEndingCaption =>
      'Antarkan cerita sampai akhir. Jangan terburu-buru, akhir cerita paling diingat anak.';

  @override
  String get hintHero => 'sang pahlawan';

  @override
  String hintCast1(String who) {
    return 'Seperti apa rupa «$who» saat pertama kali muncul?';
  }

  @override
  String hintCast2(String who) {
    return 'Apa yang sedang dilakukan «$who» sebelum seluruh cerita dimulai?';
  }

  @override
  String hintCast3(String who) {
    return 'Apa yang ditakuti «$who»?';
  }

  @override
  String hintCast4(String who) {
    return 'Bagaimana kamu tahu bahwa «$who» datang?';
  }

  @override
  String get hintCast5 =>
      'Siapa di antara mereka yang sudah lama saling kenal, dan dari mana?';

  @override
  String get hintCast6 => 'Bagaimana cuacanya saat mereka bertemu?';

  @override
  String hintCast7(String who) {
    return 'Apa yang ada di saku «$who»?';
  }

  @override
  String hintTask1(String who) {
    return 'Kapan «$who» sadar bahwa ia harus mulai bertindak?';
  }

  @override
  String hintTask2(String who) {
    return 'Siapa yang memberi saran, dan mengapa «$who» mendengarkannya?';
  }

  @override
  String hintTask3(String who) {
    return 'Apa yang harus ditinggalkan «$who» di rumah?';
  }

  @override
  String get hintTask4 => 'Seberapa jauh jalannya dan melewati apa saja?';

  @override
  String hintTask5(String who) {
    return 'Apa yang dijanjikan «$who» sebelum berangkat?';
  }

  @override
  String get hintTask6 => 'Mengapa orang lain tidak bisa melakukannya?';

  @override
  String get hintProblem1 => 'Saat itu terdengar suara. Suara apa?';

  @override
  String get hintProblem2 => 'Apa yang salah lebih dulu?';

  @override
  String hintProblem3(String who) {
    return 'Apa yang pertama kali dicoba «$who», dan mengapa tidak berhasil?';
  }

  @override
  String get hintProblem4 => 'Siapa yang menolak membantu padahal bisa?';

  @override
  String get hintProblem5 =>
      'Apa yang akan terjadi kalau semua menyerah sekarang?';

  @override
  String get hintProblem6 =>
      'Adakah sesuatu yang menyedihkan pada rintangan itu?';

  @override
  String hintProblem7(String who) {
    return 'Apa yang diucapkan «$who» dengan lantang saat itu?';
  }

  @override
  String hintEnding1(String who) {
    return 'Dengan apa «$who» akhirnya mengalahkannya: kekuatan atau akal?';
  }

  @override
  String get hintEnding2 => 'Siapa yang membantu padahal tidak harus?';

  @override
  String hintEnding3(String who) {
    return 'Apa hal pertama yang dilakukan «$who» setelah semuanya selesai?';
  }

  @override
  String get hintEnding4 => 'Apa yang berbeda di akhir dibandingkan di awal?';

  @override
  String hintEnding5(String who) {
    return 'Ke mana «$who» kembali dan siapa yang menunggu di sana?';
  }

  @override
  String get hintEnding6 => 'Apa kalimat terakhir sebelum lampu menyala?';

  @override
  String get globeLoading => 'Menyiapkan planet…';

  @override
  String get globeLoadFailed => 'Planet tidak dapat dimuat.';

  @override
  String get globeTitle => 'Dongengnya dari mana?';

  @override
  String get globeStored => 'Dongeng yang diunduh';

  @override
  String get globeHintFar =>
      'Putar planet atau ketuk sebuah negara. Negara hijau sudah punya dongeng dari koleksi kami, yang abu-abu belum.';

  @override
  String get globeHintNear =>
      'Ketuk sebuah negara atau bangunan. Negara hijau sudah punya dongeng dari koleksi kami, yang abu-abu belum.';

  @override
  String get globeWhole => 'Seluruh planet';

  @override
  String get globeZoomIn => 'Perbesar';

  @override
  String get globeZoomOut => 'Perkecil';

  @override
  String globeZoomToRegion(String name) {
    return 'Perbesar $name →';
  }

  @override
  String get globeTellHere => 'Ceritakan dongeng dari sini';

  @override
  String globeTellFrom(String place) {
    return 'Ceritakan dongeng dari $place →';
  }

  @override
  String get globeOpenSea => 'Laut lepas';

  @override
  String globeRegionCountries(int n) {
    return '$n negara bersama. Perbesar dan pilih salah satu.';
  }

  @override
  String get globeTurnToCountry => 'Putar planet ke suatu negara.';

  @override
  String get globeSpin => 'Putar';

  @override
  String get globeNoTales => 'Dari sini kami belum punya dongeng.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motif',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'dari $n dongeng',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs dari paket';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n motif dari paket',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
    );
    return 'Kami menyiapkan $_temp0 dari sini untuk paket $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
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
      other: '$n di bagian $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'kamu punya $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n lagi sedang disiapkan',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Menunggu toko…';

  @override
  String offerDownloading(int percent) {
    return 'Mengunduh dongeng… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
    );
    return 'Beli $name: $_temp0 seharga $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
    );
    return 'Unduh $name: $_temp0 gratis ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dongeng',
    );
    return 'Unduh $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Unduh $name';
  }

  @override
  String get errDownloadTales => 'Dongeng tidak dapat diunduh.';

  @override
  String get errDownloadScenes => 'Gambar tidak dapat diunduh.';

  @override
  String get errNoDownloads => 'Unduhan tidak tersedia di sini.';

  @override
  String get errOffline =>
      'Tidak ada koneksi internet, coba lagi saat sinyal tersedia.';

  @override
  String get errCannotBuy => 'Bagian ini tidak dapat dibeli sekarang.';

  @override
  String get buyPending =>
      'Pembelian menunggu persetujuan. Bagian akan diunduh setelah disetujui.';

  @override
  String get buyFailed => 'Pembelian tidak berhasil.';

  @override
  String get restoreNone => 'Tidak ada pembelian di akun ini.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n bagian dipulihkan. Kamu bisa mengunduhnya dari planet.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Pembelian tidak dapat dipulihkan, coba lagi saat sinyal tersedia.';

  @override
  String get narrationGone => 'Dongeng ini sudah tidak tersusun lagi.';

  @override
  String get narrationNew => 'Susun yang baru';

  @override
  String narrationTitle(int index, int total) {
    return 'Kamu bercerita — $index dari $total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Cara menyambung: $bridge';
  }

  @override
  String get narrationSituation =>
      'Apa yang sedang terjadi? (opsional, bisa didiktekan)';

  @override
  String get narrationHintNote =>
      'Petunjuk, jangan diucapkan keras-keras, jadikan saja pijakan.';

  @override
  String get narrationSoundsNote => 'Suara, putar saat cocok dengan ceritanya.';

  @override
  String get moodTense => 'tegang';

  @override
  String get moodCalm => 'tenang';

  @override
  String get narrationSearching => 'Mencari…';

  @override
  String get narrationHint => 'Beri petunjuk';

  @override
  String get narrationMoreHint => 'Satu lagi';

  @override
  String get narrationBack => 'Kembali';

  @override
  String get narrationEnd => 'Tamat';

  @override
  String get narrationNext => 'Lanjut →';

  @override
  String get narrationGoodnight => 'Selamat malam.';

  @override
  String get narrationEndNote =>
      'Gambar penutup dan penyimpanan ke Perpustakaan belum bisa kami buat. Dongeng ini tidak ke mana-mana, tetap di antara kalian.';

  @override
  String get narrationClose => 'Tutup';

  @override
  String get ragFallback =>
      'Paket belum punya apa pun untuk ini, ini petunjuk umum:';

  @override
  String get ragNoModel => 'Model petunjuk tidak termasuk dalam versi ini.';

  @override
  String get ragHintGeneral => 'umum';

  @override
  String get ragHintMotif => 'untuk motif';

  @override
  String get captionExact => 'ilustrasi · untuk motif ini';

  @override
  String get captionSimilar => 'ilustrasi · adegan serupa';

  @override
  String get captionCard =>
      'kartu motif · kami belum punya adegan untuk langkah ini';

  @override
  String get storageTitle => 'Dongeng yang diunduh';

  @override
  String get storageEmpty => 'Belum ada, dongeng lain diunduh dari planet.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n paket',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Adegan $name';
  }

  @override
  String get storageFreeTier => 'gratis';

  @override
  String get storageBoughtTier => 'dibeli';

  @override
  String get storageDelete => 'Hapus';

  @override
  String get storageScenesSub => 'Satu gambar untuk setiap langkah bercerita';

  @override
  String get storageDownload => 'Unduh';

  @override
  String get storageAllUsed => 'Semuanya dipakai dalam 30 hari terakhir.';

  @override
  String storageFreed(String size) {
    return '$size dibebaskan.';
  }

  @override
  String get storageFreeUp => 'Bebaskan ruang (tidak dipakai 30 hari)';

  @override
  String get storageRestoring => 'Memulihkan pembelian…';

  @override
  String get storageRestore => 'Pulihkan pembelian';

  @override
  String get osnovaTitle => 'Kerangka';

  @override
  String get osnovaSummary => 'Dongeng secara singkat';

  @override
  String get osnovaCharacters => 'Tokoh';

  @override
  String get osnovaTask => 'Tugas';

  @override
  String get osnovaProblem => 'Masalah';

  @override
  String get osnovaEnding => 'Akhir';

  @override
  String get osnovaAgain => 'Ulangi';

  @override
  String get osnovaTell => 'Aku bercerita →';

  @override
  String get outlineHero => 'Sang pahlawan';

  @override
  String get castFox => 'Rubah yang cerdik';

  @override
  String get castSmithSon => 'Anak pandai besi';

  @override
  String get castMill => 'Kincir yang bisa bicara';

  @override
  String get castGooseGirl => 'Gadis penggembala angsa';

  @override
  String get castBrothers => 'Tiga bersaudara';

  @override
  String get castClockworkPrincess => 'Putri pembuat jam';

  @override
  String get castOwl => 'Burung hantu yang bijak';

  @override
  String get castBlacksmith => 'Perempuan pandai besi tua';

  @override
  String get castDragon => 'Naga kecil';

  @override
  String get castWaterSprite => 'Roh air';

  @override
  String get castFourPrincesses => 'Empat putri';

  @override
  String get castTravelingTailor => 'Penjahit pengembara';

  @override
  String get castTalkingCat => 'Kucing yang bisa bicara';

  @override
  String get castForestHermit => 'Pertapa hutan';

  @override
  String get castC0AndersenTheShadow => 'Tuan yang dahulu bayangan';

  @override
  String get castC1GrimmTheGooseGirl => 'Pelayan yang berkhianat';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen =>
      'Raja dengan kastil berhantu';

  @override
  String get castC3AndersenTheShadow => 'Bayangan yang cerdik';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Putri yang cantik tapi kurang cerdik';

  @override
  String get castC5AndersenTheRedShoes => 'Malaikat yang akhirnya memaafkan';

  @override
  String get castC6GrimmRumpelstiltskin =>
      'Putri pemilik penggilingan yang cerdas';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Nenek yang membukakan pintu';

  @override
  String get castC8PerraultLittleThumb =>
      'Seorang ibu di antara kemiskinan dan cinta';

  @override
  String get castC9PerraultIntroduction => 'Perempuan yang sabar';

  @override
  String get castC10AndersenTheRealPrincess => 'Raja yang mendukung putranya';

  @override
  String get castC11GrimmLilyAndTheLion => 'Putri yang menepati janji';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Pangeran yang mencari putri sejati';

  @override
  String get castC13AndersenTheLittleMatchGirl =>
      'Gadis kecil penjual korek api';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Abdi istana yang diam';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Pelayan setia menyiapkan jamuan';

  @override
  String get castC16PerraultTheFairy => 'Putri yang sombong';

  @override
  String get castC17GrimmFirstStory => 'Janda yang menginginkan sembilan ekor';

  @override
  String get motifTaskWine => 'Siapa yang akan meminum satu gudang anggur';

  @override
  String get motifTaskDiamonds => 'Terbang demi berlian';

  @override
  String get motifTaskRingDuck => 'Cincin di dalam bebek';

  @override
  String get motifTaskGiants => 'Mengakali para raksasa';

  @override
  String get motifTaskTomThumb => 'Pelarian si Jempol Kecil';

  @override
  String get motifTaskSwineherd => 'Memenangkan hati sang putri';

  @override
  String get motifTaskBell => 'Lonceng misterius di hutan';

  @override
  String get motifTaskGoldenObject => 'Hadiah yang tidak boleh disalahgunakan';

  @override
  String get motifTaskPebbles => 'Jalan setapak dari kerikil';

  @override
  String get motifProblemFoxPride => 'Kesombongan sang rubah';

  @override
  String get motifProblemLazySister => 'Saudari yang malas';

  @override
  String get motifProblemWitchBoots => 'Penyihir bersepatu tujuh mil';

  @override
  String get motifProblemTailorDoubt => 'Tak ada yang percaya padanya';

  @override
  String get motifProblemLions => 'Singa-singa lapar di gerbang';

  @override
  String get motifProblemEagle => 'Elang dan kurcaci';

  @override
  String get motifProblemTruth => 'Hewan ajaib membongkar kebenaran';

  @override
  String get motifProblemOldHouse => 'Tak ada yang mau rumah tua itu';

  @override
  String get motifProblemBreadcrumbs => 'Burung-burung memakan remah-remah';

  @override
  String get motifEndingTrickWins => 'Kecerdikan menang';

  @override
  String get motifEndingTruthChild => 'Anak itu mengatakan yang sebenarnya';

  @override
  String get motifEndingNewHome => 'Rumah baru, sahabat lama';

  @override
  String get motifEndingHappyTogether => 'Bahagia bersama selamanya';

  @override
  String get motifEndingKissWakes => 'Sebuah ciuman membangunkan kerajaan';

  @override
  String get motifEndingLeapfrog => 'Kecerdikan melompat paling tinggi';

  @override
  String get motifEndingCurseBroken => 'Kutukan terpatahkan';

  @override
  String get motifEndingWelcomedHome => 'Disambut di rumah';

  @override
  String get motifEndingSlipper => 'Sepatu yang hilang';
}
