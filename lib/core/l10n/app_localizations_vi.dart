// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appName => 'Sesan Travel';

  @override
  String get all => 'Tất cả';

  @override
  String get featured => 'Nổi bật';

  @override
  String get popularTours => 'Tour Phổ Biến';

  @override
  String get viewAll => 'Xem Tất cả';

  @override
  String tabUnderDevelopment(int index) {
    return 'Màn hình của tab $index đang phát triển';
  }

  @override
  String get home => 'Trang chủ';

  @override
  String get tours => 'Chuyến đi';

  @override
  String get profile => 'Cá nhân';

  @override
  String get discover => 'KHÁM PHÁ';

  @override
  String get amazingThings => 'ĐIỀU TUYỆT VỜI';

  @override
  String get heroSubtitle => 'Hành trình của bạn, ký ức của chúng tôi';

  @override
  String get whereToGo => 'Bạn muốn đi đâu?';

  @override
  String get dailyTours => 'Tour Hằng ngày';

  @override
  String get packageTours => 'Tour trọn gói';

  @override
  String get privateTours => 'Tour riêng tư';

  @override
  String get seeMore => 'Xem thêm';

  @override
  String get searchTours => 'Tìm kiếm tour du lịch...';

  @override
  String get explore => 'Khám phá';

  @override
  String get noToursFound => 'Không có dữ liệu tour.';

  @override
  String errorOccurred(String error) {
    return 'Đã có lỗi xảy ra: $error';
  }

  @override
  String get allTours => 'Tất cả Tour';
}
