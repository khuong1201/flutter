import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In vi, this message translates to:
  /// **'Zenith Lingua'**
  String get appTitle;

  /// No description provided for @homeSlogan.
  ///
  /// In vi, this message translates to:
  /// **'\"Học ngôn ngữ mới, mở ra chân trời mới\"'**
  String get homeSlogan;

  /// No description provided for @splashTagline.
  ///
  /// In vi, this message translates to:
  /// **'Mở khóa thế giới của bạn'**
  String get splashTagline;

  /// No description provided for @splashLoading.
  ///
  /// In vi, this message translates to:
  /// **'Đang chuẩn bị hành trang...'**
  String get splashLoading;

  /// No description provided for @loginTitle.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginTitle;

  /// No description provided for @loginWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Chào mừng bạn quay trở lại với Zenith Lingua'**
  String get loginWelcome;

  /// No description provided for @emailLabel.
  ///
  /// In vi, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu'**
  String get passwordLabel;

  /// No description provided for @loginButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập'**
  String get loginButton;

  /// No description provided for @forgotPassword.
  ///
  /// In vi, this message translates to:
  /// **'Quên mật khẩu?'**
  String get forgotPassword;

  /// No description provided for @orContinueWith.
  ///
  /// In vi, this message translates to:
  /// **'Hoặc tiếp tục với'**
  String get orContinueWith;

  /// No description provided for @noAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Chưa có tài khoản?'**
  String get noAccountPrompt;

  /// No description provided for @registerNow.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký ngay'**
  String get registerNow;

  /// No description provided for @registerTitle.
  ///
  /// In vi, this message translates to:
  /// **'Tạo tài khoản mới'**
  String get registerTitle;

  /// No description provided for @registerWelcome.
  ///
  /// In vi, this message translates to:
  /// **'Bắt đầu hành trình chinh phục ngôn ngữ'**
  String get registerWelcome;

  /// No description provided for @fullNameLabel.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên'**
  String get fullNameLabel;

  /// No description provided for @targetLanguageLabel.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ muốn học'**
  String get targetLanguageLabel;

  /// No description provided for @registerButton.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký'**
  String get registerButton;

  /// No description provided for @haveAccountPrompt.
  ///
  /// In vi, this message translates to:
  /// **'Đã có tài khoản?'**
  String get haveAccountPrompt;

  /// No description provided for @homeGreeting.
  ///
  /// In vi, this message translates to:
  /// **'Chào buổi sáng'**
  String get homeGreeting;

  /// No description provided for @dailyGoal.
  ///
  /// In vi, this message translates to:
  /// **'Mục tiêu hằng ngày'**
  String get dailyGoal;

  /// No description provided for @roadmapTitle.
  ///
  /// In vi, this message translates to:
  /// **'Lộ trình của bạn'**
  String get roadmapTitle;

  /// No description provided for @learningActivity.
  ///
  /// In vi, this message translates to:
  /// **'Hoạt động học tập'**
  String get learningActivity;

  /// No description provided for @lessonsCount.
  ///
  /// In vi, this message translates to:
  /// **'{count} bài'**
  String lessonsCount(int count);

  /// No description provided for @japaneseJLPT.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật (JLPT)'**
  String get japaneseJLPT;

  /// No description provided for @japaneseJLPTDesc.
  ///
  /// In vi, this message translates to:
  /// **'Từ vựng & Kanji N5'**
  String get japaneseJLPTDesc;

  /// No description provided for @chineseHSK.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Trung (HSK)'**
  String get chineseHSK;

  /// No description provided for @chineseHSKDesc.
  ///
  /// In vi, this message translates to:
  /// **'Căn bản HSK 1'**
  String get chineseHSKDesc;

  /// No description provided for @less.
  ///
  /// In vi, this message translates to:
  /// **'Ít'**
  String get less;

  /// No description provided for @more.
  ///
  /// In vi, this message translates to:
  /// **'Nhiều'**
  String get more;

  /// No description provided for @emptyEmailError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập email'**
  String get emptyEmailError;

  /// No description provided for @invalidEmailError.
  ///
  /// In vi, this message translates to:
  /// **'Email không hợp lệ'**
  String get invalidEmailError;

  /// No description provided for @emptyPasswordError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập mật khẩu'**
  String get emptyPasswordError;

  /// No description provided for @invalidPasswordError.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu phải có ít nhất 6 ký tự'**
  String get invalidPasswordError;

  /// No description provided for @emptyFullNameError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng nhập họ và tên'**
  String get emptyFullNameError;

  /// No description provided for @invalidFullNameError.
  ///
  /// In vi, this message translates to:
  /// **'Họ và tên quá ngắn'**
  String get invalidFullNameError;

  /// No description provided for @emptyConfirmPasswordError.
  ///
  /// In vi, this message translates to:
  /// **'Vui lòng xác nhận mật khẩu'**
  String get emptyConfirmPasswordError;

  /// No description provided for @passwordMismatchError.
  ///
  /// In vi, this message translates to:
  /// **'Mật khẩu xác nhận không khớp'**
  String get passwordMismatchError;

  /// No description provided for @loginSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thành công!'**
  String get loginSuccess;

  /// No description provided for @loginFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng nhập thất bại'**
  String get loginFailed;

  /// No description provided for @registerSuccess.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thành công! Vui lòng đăng nhập.'**
  String get registerSuccess;

  /// No description provided for @registerFailed.
  ///
  /// In vi, this message translates to:
  /// **'Đăng ký thất bại'**
  String get registerFailed;

  /// No description provided for @japaneseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Nhật 🇯🇵'**
  String get japaneseLanguage;

  /// No description provided for @chineseLanguage.
  ///
  /// In vi, this message translates to:
  /// **'Tiếng Trung 🇨🇳'**
  String get chineseLanguage;

  /// No description provided for @errorServer.
  ///
  /// In vi, this message translates to:
  /// **'Có lỗi xảy ra từ máy chủ'**
  String get errorServer;

  /// No description provided for @errorCache.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi truy xuất dữ liệu cục bộ'**
  String get errorCache;

  /// No description provided for @errorNetwork.
  ///
  /// In vi, this message translates to:
  /// **'Không có kết nối mạng'**
  String get errorNetwork;

  /// No description provided for @errorUnknown.
  ///
  /// In vi, this message translates to:
  /// **'Lỗi không xác định'**
  String get errorUnknown;

  /// No description provided for @errorInvalidCredentials.
  ///
  /// In vi, this message translates to:
  /// **'Sai email hoặc mật khẩu'**
  String get errorInvalidCredentials;

  /// No description provided for @errorUserExists.
  ///
  /// In vi, this message translates to:
  /// **'Email hoặc tên đăng nhập đã tồn tại'**
  String get errorUserExists;

  /// No description provided for @errorBadRequest.
  ///
  /// In vi, this message translates to:
  /// **'Dữ liệu đầu vào không hợp lệ'**
  String get errorBadRequest;

  /// No description provided for @errorUnauthorized.
  ///
  /// In vi, this message translates to:
  /// **'Bạn không có quyền hoặc phiên đăng nhập đã hết hạn'**
  String get errorUnauthorized;

  /// No description provided for @settingsTitle.
  ///
  /// In vi, this message translates to:
  /// **'Cài đặt'**
  String get settingsTitle;

  /// No description provided for @language.
  ///
  /// In vi, this message translates to:
  /// **'Ngôn ngữ'**
  String get language;

  /// No description provided for @theme.
  ///
  /// In vi, this message translates to:
  /// **'Giao diện'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In vi, this message translates to:
  /// **'Sáng'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In vi, this message translates to:
  /// **'Tối'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In vi, this message translates to:
  /// **'Hệ thống'**
  String get systemTheme;

  /// No description provided for @account.
  ///
  /// In vi, this message translates to:
  /// **'Tài khoản'**
  String get account;

  /// No description provided for @logout.
  ///
  /// In vi, this message translates to:
  /// **'Đăng xuất'**
  String get logout;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
