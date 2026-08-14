// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Zenith Lingua';

  @override
  String get homeSlogan => '\"Học ngôn ngữ mới, mở ra chân trời mới\"';

  @override
  String get splashTagline => 'Mở khóa thế giới của bạn';

  @override
  String get splashLoading => 'Đang chuẩn bị hành trang...';

  @override
  String get loginTitle => 'Đăng nhập';

  @override
  String get loginWelcome => 'Chào mừng bạn quay trở lại với Zenith Lingua';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Mật khẩu';

  @override
  String get loginButton => 'Đăng nhập';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get orContinueWith => 'Hoặc tiếp tục với';

  @override
  String get noAccountPrompt => 'Chưa có tài khoản?';

  @override
  String get registerNow => 'Đăng ký ngay';

  @override
  String get registerTitle => 'Tạo tài khoản mới';

  @override
  String get registerWelcome => 'Bắt đầu hành trình chinh phục ngôn ngữ';

  @override
  String get fullNameLabel => 'Họ và tên';

  @override
  String get targetLanguageLabel => 'Ngôn ngữ muốn học';

  @override
  String get registerButton => 'Đăng ký';

  @override
  String get haveAccountPrompt => 'Đã có tài khoản?';

  @override
  String get homeGreeting => 'Chào buổi sáng';

  @override
  String get dailyGoal => 'Mục tiêu hằng ngày';

  @override
  String get roadmapTitle => 'Lộ trình của bạn';

  @override
  String get learningActivity => 'Hoạt động học tập';

  @override
  String lessonsCount(int count) {
    return '$count bài';
  }

  @override
  String get japaneseJLPT => 'Tiếng Nhật (JLPT)';

  @override
  String get japaneseJLPTDesc => 'Từ vựng & Kanji N5';

  @override
  String get chineseHSK => 'Tiếng Trung (HSK)';

  @override
  String get chineseHSKDesc => 'Căn bản HSK 1';

  @override
  String get less => 'Ít';

  @override
  String get more => 'Nhiều';

  @override
  String get emptyEmailError => 'Vui lòng nhập email';

  @override
  String get invalidEmailError => 'Email không hợp lệ';

  @override
  String get emptyPasswordError => 'Vui lòng nhập mật khẩu';

  @override
  String get invalidPasswordError => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get emptyFullNameError => 'Vui lòng nhập họ và tên';

  @override
  String get invalidFullNameError => 'Họ và tên quá ngắn';

  @override
  String get emptyConfirmPasswordError => 'Vui lòng xác nhận mật khẩu';

  @override
  String get passwordMismatchError => 'Mật khẩu xác nhận không khớp';

  @override
  String get loginSuccess => 'Đăng nhập thành công!';

  @override
  String get loginFailed => 'Đăng nhập thất bại';

  @override
  String get registerSuccess => 'Đăng ký thành công! Vui lòng đăng nhập.';

  @override
  String get registerFailed => 'Đăng ký thất bại';

  @override
  String get japaneseLanguage => 'Tiếng Nhật 🇯🇵';

  @override
  String get chineseLanguage => 'Tiếng Trung 🇨🇳';

  @override
  String get errorServer => 'Có lỗi xảy ra từ máy chủ';

  @override
  String get errorCache => 'Lỗi truy xuất dữ liệu cục bộ';

  @override
  String get errorNetwork => 'Không có kết nối mạng';

  @override
  String get errorUnknown => 'Lỗi không xác định';

  @override
  String get errorInvalidCredentials => 'Sai email hoặc mật khẩu';

  @override
  String get errorUserExists => 'Email hoặc tên đăng nhập đã tồn tại';

  @override
  String get errorBadRequest => 'Dữ liệu đầu vào không hợp lệ';

  @override
  String get errorUnauthorized =>
      'Bạn không có quyền hoặc phiên đăng nhập đã hết hạn';

  @override
  String get settingsTitle => 'Cài đặt';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Giao diện';

  @override
  String get lightTheme => 'Sáng';

  @override
  String get darkTheme => 'Tối';

  @override
  String get systemTheme => 'Hệ thống';

  @override
  String get account => 'Tài khoản';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get characterDetailTitle => 'Chi tiết chữ Hán';

  @override
  String get characterMeaningUpdating => 'Đang cập nhật ý nghĩa...';

  @override
  String get audioFeatureComingSoon =>
      'Tính năng phát âm thanh đang được hoàn thiện';

  @override
  String get pronunciation => 'Phát âm';

  @override
  String get radicals => 'Bộ thủ';

  @override
  String get vocabularies => 'Từ vựng ví dụ';

  @override
  String get animationPauseTooltip => 'Tạm dừng (Mất nét)';

  @override
  String get animationPlayTooltip => 'Vẽ lại từ đầu';

  @override
  String characterLoadError(String error) {
    return 'Đã xảy ra lỗi: $error';
  }

  @override
  String get viewGuide => 'Xem hướng dẫn';

  @override
  String get practiceWriting => 'Luyện viết chữ';

  @override
  String get submitReview => 'Nộp bài';

  @override
  String get emptyStrokes => 'Vui lòng vẽ ít nhất một nét';

  @override
  String get evaluateTitle => 'Đánh giá nét vẽ';

  @override
  String get evaluatePrompt =>
      'Bạn tự đánh giá nét vẽ của mình được bao nhiêu điểm (0-5)?';

  @override
  String get cancel => 'Hủy';

  @override
  String get submitting => 'Đang nộp bài...';

  @override
  String get submitSuccess => 'Nộp bài thành công!';
}
