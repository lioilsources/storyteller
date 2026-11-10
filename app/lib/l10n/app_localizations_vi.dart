// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get castTitle => 'Ai sẽ có trong truyện?';

  @override
  String get castHint =>
      'Chạm vào thẻ để đổi nhân vật khác. Xóa thẻ bằng dấu x. Nhạc và âm thanh luôn có sẵn từ gói của quốc gia, chỉ có hình nhân vật đôi khi được vẽ muộn một chút.';

  @override
  String get castAdd => 'Thêm nhân vật';

  @override
  String get castCount => 'Dàn nhân vật:';

  @override
  String get castShuffleAll => 'Xáo trộn tất cả';

  @override
  String get castContinue => 'Tiếp tục →';

  @override
  String get shuffle => 'Xáo trộn';

  @override
  String get motifTaskTitle => 'Nhiệm vụ nào?';

  @override
  String get motifProblemTitle => 'Vấn đề nào?';

  @override
  String get motifEndingTitle => 'Kết thúc thế nào?';

  @override
  String get motifTaskCaption =>
      'Chạm vào thẻ để chọn nhiệm vụ cho nhân vật chính.';

  @override
  String get motifProblemCaption =>
      'Chạm vào thẻ để chọn chướng ngại hoặc kẻ xấu.';

  @override
  String get motifEndingCaption => 'Chạm vào thẻ để chọn một cái kết có hậu.';

  @override
  String get beatCastTitle => 'Ai có mặt trong truyện';

  @override
  String get beatTaskTitle => 'Nhân vật chính đã quyết tâm làm gì';

  @override
  String get beatProblemTitle => 'Điều gì cản đường';

  @override
  String get beatEndingTitle => 'Kết thúc ra sao';

  @override
  String get beatCastCaption =>
      'Giới thiệu các nhân vật: họ ở đâu, trông thế nào, có gì đặc biệt.';

  @override
  String get beatTaskCaption =>
      'Kể xem nhân vật chính muốn gì và vì sao lên đường.';

  @override
  String get beatProblemCaption =>
      'Đặt một điều gì đó trên đường đi của nhân vật. Cho có vẻ như một lúc là không thể làm được.';

  @override
  String get beatEndingCaption =>
      'Dẫn câu chuyện đến hồi kết. Đừng vội, trẻ nhớ phần kết nhất.';

  @override
  String get hintHero => 'nhân vật chính';

  @override
  String hintCast1(String who) {
    return '«$who» trông thế nào khi xuất hiện lần đầu?';
  }

  @override
  String hintCast2(String who) {
    return '«$who» đang làm gì ngay trước khi câu chuyện bắt đầu?';
  }

  @override
  String hintCast3(String who) {
    return '«$who» sợ điều gì?';
  }

  @override
  String hintCast4(String who) {
    return 'Làm sao bạn biết «$who» đang tới?';
  }

  @override
  String get hintCast5 => 'Ai trong số họ đã quen nhau lâu, và quen từ đâu?';

  @override
  String get hintCast6 => 'Thời tiết thế nào khi họ gặp nhau?';

  @override
  String hintCast7(String who) {
    return '«$who» có gì trong túi?';
  }

  @override
  String hintTask1(String who) {
    return 'Khi nào «$who» hiểu rằng phải bắt tay vào việc?';
  }

  @override
  String hintTask2(String who) {
    return 'Ai đã khuyên, và vì sao «$who» nghe theo?';
  }

  @override
  String hintTask3(String who) {
    return '«$who» phải để lại gì ở nhà?';
  }

  @override
  String get hintTask4 => 'Đường dài bao nhiêu và đi qua những đâu?';

  @override
  String hintTask5(String who) {
    return '«$who» tự hứa điều gì trước khi lên đường?';
  }

  @override
  String get hintTask6 => 'Vì sao không ai khác làm được việc này?';

  @override
  String get hintProblem1 =>
      'Ngay lúc đó có một âm thanh vang lên, âm thanh gì?';

  @override
  String get hintProblem2 => 'Điều gì hỏng trước tiên?';

  @override
  String hintProblem3(String who) {
    return '«$who» thử điều gì trước, và vì sao không được?';
  }

  @override
  String get hintProblem4 => 'Ai từ chối giúp dù có thể giúp?';

  @override
  String get hintProblem5 =>
      'Chuyện gì sẽ xảy ra nếu bây giờ mọi người bỏ cuộc?';

  @override
  String get hintProblem6 => 'Chướng ngại này có điều gì đáng buồn không?';

  @override
  String hintProblem7(String who) {
    return 'Lúc đó «$who» nói to điều gì?';
  }

  @override
  String hintEnding1(String who) {
    return 'Cuối cùng «$who» vượt qua bằng gì: sức mạnh hay một ý tưởng?';
  }

  @override
  String get hintEnding2 => 'Ai giúp dù không bắt buộc?';

  @override
  String hintEnding3(String who) {
    return 'Khi mọi chuyện kết thúc, «$who» làm gì đầu tiên?';
  }

  @override
  String get hintEnding4 => 'Cuối truyện khác đầu truyện ở điểm nào?';

  @override
  String hintEnding5(String who) {
    return '«$who» trở về đâu và ai đang chờ ở đó?';
  }

  @override
  String get hintEnding6 => 'Câu cuối cùng trước khi đèn bật sáng là gì?';

  @override
  String get globeLoading => 'Đang chuẩn bị hành tinh…';

  @override
  String get globeLoadFailed => 'Không tải được hành tinh.';

  @override
  String get globeTitle => 'Truyện sẽ đến từ đâu?';

  @override
  String get globeStored => 'Truyện đã tải';

  @override
  String get globeHintFar =>
      'Xoay hành tinh hoặc chạm vào một quốc gia. Quốc gia màu xanh đã có truyện trong bộ sưu tập của chúng tôi, quốc gia màu xám thì chưa.';

  @override
  String get globeHintNear =>
      'Chạm vào một quốc gia hoặc công trình. Quốc gia màu xanh đã có truyện trong bộ sưu tập của chúng tôi, quốc gia màu xám thì chưa.';

  @override
  String get globeWhole => 'Toàn bộ hành tinh';

  @override
  String get globeZoomIn => 'Phóng to';

  @override
  String get globeZoomOut => 'Thu nhỏ';

  @override
  String globeZoomToRegion(String name) {
    return 'Phóng to $name →';
  }

  @override
  String get globeTellHere => 'Kể một truyện từ đây';

  @override
  String globeTellFrom(String place) {
    return 'Kể một truyện từ $place →';
  }

  @override
  String get globeOpenSea => 'Biển khơi';

  @override
  String globeRegionCountries(int n) {
    return '$n quốc gia cùng nhau. Phóng to và chọn một nước.';
  }

  @override
  String get globeTurnToCountry => 'Xoay hành tinh về phía một quốc gia.';

  @override
  String get globeSpin => 'Xoay';

  @override
  String get globeNoTales => 'Chúng tôi chưa có truyện nào từ đây.';

  @override
  String motifCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mô-típ',
    );
    return '$_temp0';
  }

  @override
  String fromTaleCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'từ $n truyện',
    );
    return '$_temp0';
  }

  @override
  String motifsFromTales(String motifs, String tales) {
    return '$motifs $tales';
  }

  @override
  String motifsPlusPack(String base, int packMotifs) {
    return '$base + $packMotifs từ gói';
  }

  @override
  String motifsFromPack(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n mô-típ từ gói',
    );
    return '$_temp0';
  }

  @override
  String talesComing(int n, String region) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return 'Chúng tôi đang chuẩn bị $_temp0 từ đây cho gói $region.';
  }

  @override
  String talesCount(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return '$_temp0';
  }

  @override
  String talesCountFree(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return '$_temp0 miễn phí';
  }

  @override
  String cardFree(int n) {
    return '$n miễn phí';
  }

  @override
  String cardInParts(int parts, int n, String region, String range) {
    String _temp0 = intl.Intl.pluralLogic(
      parts,
      locale: localeName,
      other: '$n trong phần $region $range',
    );
    return '$_temp0';
  }

  @override
  String cardHave(int n) {
    return 'bạn có $n';
  }

  @override
  String cardMoreComing(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'còn $n đang chuẩn bị',
    );
    return '$_temp0';
  }

  @override
  String get offerWaiting => 'Đang chờ cửa hàng…';

  @override
  String offerDownloading(int percent) {
    return 'Đang tải truyện… $percent%';
  }

  @override
  String offerBuy(String name, int n, String price) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return 'Mua $name: $_temp0 giá $price';
  }

  @override
  String offerDownloadFree(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return 'Tải $name: $_temp0 miễn phí ($size)';
  }

  @override
  String offerDownloadPart(String name, int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n truyện',
    );
    return 'Tải $name: $_temp0 ($size)';
  }

  @override
  String offerDownloadTip(String name) {
    return 'Tải $name';
  }

  @override
  String get errDownloadTales => 'Không tải được truyện.';

  @override
  String get errDownloadScenes => 'Không tải được hình ảnh.';

  @override
  String get errNoDownloads => 'Không thể tải xuống ở đây.';

  @override
  String get errOffline =>
      'Không có kết nối internet, hãy thử lại khi có sóng.';

  @override
  String get errCannotBuy => 'Phần này hiện chưa thể mua.';

  @override
  String get buyPending =>
      'Giao dịch mua đang chờ phê duyệt. Phần này sẽ được tải khi được duyệt.';

  @override
  String get buyFailed => 'Giao dịch mua không thành công.';

  @override
  String get restoreNone => 'Tài khoản này không có giao dịch mua nào.';

  @override
  String restoreSome(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: 'Đã khôi phục $n phần. Bạn có thể tải xuống từ hành tinh.',
    );
    return '$_temp0';
  }

  @override
  String get restoreFailed =>
      'Không khôi phục được giao dịch mua, hãy thử lại khi có sóng.';

  @override
  String get narrationGone => 'Truyện này không còn được ghép nữa.';

  @override
  String get narrationNew => 'Ghép truyện mới';

  @override
  String narrationTitle(int index, int total) {
    return 'Bạn đang kể — $index/$total';
  }

  @override
  String narrationBridge(String bridge) {
    return 'Cách nối tiếp: $bridge';
  }

  @override
  String get narrationSituation =>
      'Đang xảy ra chuyện gì? (không bắt buộc, có thể đọc cho máy chép)';

  @override
  String get narrationHintNote =>
      'Gợi ý, đừng đọc to, chỉ lấy đó làm điểm xuất phát.';

  @override
  String get narrationSoundsNote => 'Âm thanh, bật khi hợp với câu chuyện.';

  @override
  String get moodTense => 'căng thẳng';

  @override
  String get moodCalm => 'yên bình';

  @override
  String get narrationSearching => 'Đang tìm…';

  @override
  String get narrationHint => 'Gợi ý cho tôi';

  @override
  String get narrationMoreHint => 'Thêm một cái nữa';

  @override
  String get narrationBack => 'Quay lại';

  @override
  String get narrationEnd => 'Hết';

  @override
  String get narrationNext => 'Tiếp →';

  @override
  String get narrationGoodnight => 'Chúc ngủ ngon.';

  @override
  String get narrationEndNote =>
      'Chúng tôi chưa làm được hình ảnh kết thúc hay lưu vào Thư viện. Truyện này không đi đâu cả, nó ở lại giữa hai bạn.';

  @override
  String get narrationClose => 'Đóng';

  @override
  String get ragFallback =>
      'Gói chưa có gì cho phần này, đây là một gợi ý chung:';

  @override
  String get ragNoModel => 'Phiên bản này không có mô hình gợi ý.';

  @override
  String get ragHintGeneral => 'chung';

  @override
  String get ragHintMotif => 'cho mô-típ';

  @override
  String get captionExact => 'minh họa · cho mô-típ này';

  @override
  String get captionSimilar => 'minh họa · cảnh tương tự';

  @override
  String get captionCard => 'thẻ mô-típ · chúng tôi chưa có cảnh cho bước này';

  @override
  String get storageTitle => 'Truyện đã tải';

  @override
  String get storageEmpty =>
      'Chưa có gì, truyện khác sẽ được tải từ hành tinh.';

  @override
  String storageSummary(int n, String size) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n gói',
    );
    return '$_temp0, $size';
  }

  @override
  String storageScenes(String name) {
    return 'Cảnh của $name';
  }

  @override
  String get storageFreeTier => 'miễn phí';

  @override
  String get storageBoughtTier => 'đã mua';

  @override
  String get storageDelete => 'Xóa';

  @override
  String get storageScenesSub => 'Một hình cho mỗi bước của câu chuyện';

  @override
  String get storageDownload => 'Tải xuống';

  @override
  String get storageAllUsed => 'Mọi thứ đều được dùng trong 30 ngày qua.';

  @override
  String storageFreed(String size) {
    return 'Đã giải phóng $size.';
  }

  @override
  String get storageFreeUp => 'Giải phóng dung lượng (30 ngày không dùng)';

  @override
  String get storageRestoring => 'Đang khôi phục giao dịch mua…';

  @override
  String get storageRestore => 'Khôi phục giao dịch mua';

  @override
  String get osnovaTitle => 'Dàn ý';

  @override
  String get osnovaSummary => 'Truyện trong một nốt nhạc';

  @override
  String get osnovaCharacters => 'Nhân vật';

  @override
  String get osnovaTask => 'Nhiệm vụ';

  @override
  String get osnovaProblem => 'Vấn đề';

  @override
  String get osnovaEnding => 'Kết thúc';

  @override
  String get osnovaAgain => 'Làm lại';

  @override
  String get osnovaTell => 'Tôi kể →';

  @override
  String get outlineHero => 'Nhân vật chính';

  @override
  String get castFox => 'Cáo thông minh';

  @override
  String get castSmithSon => 'Con trai người thợ rèn';

  @override
  String get castMill => 'Cối xay biết nói';

  @override
  String get castGooseGirl => 'Cô bé chăn ngỗng';

  @override
  String get castBrothers => 'Ba anh em';

  @override
  String get castClockworkPrincess => 'Công chúa thợ đồng hồ';

  @override
  String get castOwl => 'Cú thông thái';

  @override
  String get castBlacksmith => 'Bà thợ rèn già';

  @override
  String get castDragon => 'Rồng nhỏ';

  @override
  String get castWaterSprite => 'Thủy quái';

  @override
  String get castFourPrincesses => 'Bốn nàng công chúa';

  @override
  String get castTravelingTailor => 'Anh thợ may lang thang';

  @override
  String get castTalkingCat => 'Mèo biết nói';

  @override
  String get castForestHermit => 'Ẩn sĩ trong rừng';

  @override
  String get castC0AndersenTheShadow => 'Ông chủ từng là cái bóng';

  @override
  String get castC1GrimmTheGooseGirl => 'Cô hầu gái phản bội';

  @override
  String get castC2GrimmTheStoryOfTheYouthWhoWen => 'Nhà vua có lâu đài ma ám';

  @override
  String get castC3AndersenTheShadow => 'Cái bóng tinh ranh';

  @override
  String get castC4PerraultRiquetWithTheTuft =>
      'Công chúa xinh đẹp nhưng không khôn ngoan lắm';

  @override
  String get castC5AndersenTheRedShoes => 'Thiên thần cuối cùng tha thứ';

  @override
  String get castC6GrimmRumpelstiltskin =>
      'Con gái thông minh của người chủ cối xay';

  @override
  String get castC7PerraultLittleRedRidingHood => 'Bà ngoại mở cửa';

  @override
  String get castC8PerraultLittleThumb => 'Người mẹ giữa cái nghèo và tình yêu';

  @override
  String get castC9PerraultIntroduction => 'Người phụ nữ kiên nhẫn';

  @override
  String get castC10AndersenTheRealPrincess => 'Nhà vua ủng hộ con trai';

  @override
  String get castC11GrimmLilyAndTheLion => 'Cô con gái giữ lời';

  @override
  String get castC12AndersenTheRealPrincess =>
      'Hoàng tử đi tìm nàng công chúa thật';

  @override
  String get castC13AndersenTheLittleMatchGirl => 'Cô bé bán diêm';

  @override
  String get castC14AndersenTheEmperorSNewClothes => 'Quan hầu lặng lẽ';

  @override
  String get castC15PerraultRiquetWithTheTuft =>
      'Người hầu trung thành chuẩn bị bữa tiệc';

  @override
  String get castC16PerraultTheFairy => 'Cô con gái kiêu căng';

  @override
  String get castC17GrimmFirstStory => 'Bà góa muốn có chín cái đuôi';

  @override
  String get motifTaskWine => 'Ai sẽ uống cạn một hầm rượu';

  @override
  String get motifTaskDiamonds => 'Chuyến bay đi tìm kim cương';

  @override
  String get motifTaskRingDuck => 'Chiếc nhẫn trong con vịt';

  @override
  String get motifTaskGiants => 'Đánh lừa những gã khổng lồ';

  @override
  String get motifTaskTomThumb => 'Cuộc trốn thoát của Cậu bé tí hon';

  @override
  String get motifTaskSwineherd => 'Giành được trái tim công chúa';

  @override
  String get motifTaskBell => 'Chiếc chuông bí ẩn trong rừng';

  @override
  String get motifTaskGoldenObject => 'Món quà không được lạm dụng';

  @override
  String get motifTaskPebbles => 'Con đường rải sỏi';

  @override
  String get motifProblemFoxPride => 'Sự kiêu ngạo của cáo';

  @override
  String get motifProblemLazySister => 'Cô em gái lười biếng';

  @override
  String get motifProblemWitchBoots => 'Mụ phù thủy đi ủng bảy dặm';

  @override
  String get motifProblemTailorDoubt => 'Không ai tin anh ta';

  @override
  String get motifProblemLions => 'Sư tử đói ở cổng';

  @override
  String get motifProblemEagle => 'Đại bàng và chú lùn';

  @override
  String get motifProblemTruth => 'Con vật thần kỳ tiết lộ sự thật';

  @override
  String get motifProblemOldHouse => 'Không ai muốn căn nhà cũ';

  @override
  String get motifProblemBreadcrumbs => 'Lũ chim ăn hết vụn bánh';

  @override
  String get motifEndingTrickWins => 'Trí khôn chiến thắng';

  @override
  String get motifEndingTruthChild => 'Đứa trẻ nói sự thật';

  @override
  String get motifEndingNewHome => 'Mái nhà mới, bạn cũ';

  @override
  String get motifEndingHappyTogether => 'Hạnh phúc bên nhau mãi mãi';

  @override
  String get motifEndingKissWakes => 'Một nụ hôn đánh thức vương quốc';

  @override
  String get motifEndingLeapfrog => 'Trí khôn nhảy cao nhất';

  @override
  String get motifEndingCurseBroken => 'Lời nguyền đã bị phá';

  @override
  String get motifEndingWelcomedHome => 'Được chào đón ở nhà';

  @override
  String get motifEndingSlipper => 'Chiếc giày bị mất';
}
