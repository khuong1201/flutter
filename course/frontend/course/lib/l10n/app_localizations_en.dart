// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get splashTagline => 'Unlock your world';

  @override
  String get splashLoading => 'Preparing your journey...';

  @override
  String get loginTitle => 'Login';

  @override
  String get loginWelcome => 'Welcome back to Zenith Lingua';

  @override
  String get emailLabel => 'Email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get loginButton => 'Sign In';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get orContinueWith => 'Or continue with';

  @override
  String get noAccountPrompt => 'Don\'t have an account?';

  @override
  String get registerNow => 'Register now';

  @override
  String get registerTitle => 'Create a new account';

  @override
  String get registerWelcome => 'Start your language learning journey';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get targetLanguageLabel => 'Language you want to learn';

  @override
  String get registerButton => 'Register';

  @override
  String get haveAccountPrompt => 'Already have an account?';

  @override
  String get homeGreeting => 'Good morning';

  @override
  String get dailyGoal => 'Daily Goal';

  @override
  String get roadmapTitle => 'Your Roadmap';

  @override
  String get emptyEmailError => 'Please enter your email';

  @override
  String get invalidEmailError => 'Please enter a valid email address';

  @override
  String get emptyPasswordError => 'Please enter your password';

  @override
  String get invalidPasswordError => 'Password must be at least 6 characters';

  @override
  String get emptyFullNameError => 'Please enter your full name';

  @override
  String get invalidFullNameError => 'Full name is too short';

  @override
  String get emptyConfirmPasswordError => 'Please confirm your password';

  @override
  String get passwordMismatchError => 'Passwords do not match';

  @override
  String get loginSuccess => 'Login successful';

  @override
  String get loginFailed => 'Login failed';

  @override
  String get registerSuccess => 'Registration successful! Please sign in.';

  @override
  String get registerFailed => 'Registration failed';

  @override
  String get japaneseLanguage => 'Japanese 🇯🇵';

  @override
  String get chineseLanguage => 'Chinese 🇨🇳';
}
