// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

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
  String get homeGreeting => 'Chào buổi sáng';

  @override
  String get dailyGoal => 'Mục tiêu hằng ngày';

  @override
  String get roadmapTitle => 'Lộ trình của bạn';

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
}
