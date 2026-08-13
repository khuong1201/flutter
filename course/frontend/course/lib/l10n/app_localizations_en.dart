// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Zenith Lingua';

  @override
  String get homeSlogan => '\"Learn a new language, open a new horizon\"';

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
  String get learningActivity => 'Learning Activity';

  @override
  String lessonsCount(int count) {
    return '$count lessons';
  }

  @override
  String get japaneseJLPT => 'Japanese (JLPT)';

  @override
  String get japaneseJLPTDesc => 'N5 Vocabulary & Kanji';

  @override
  String get chineseHSK => 'Chinese (HSK)';

  @override
  String get chineseHSKDesc => 'HSK 1 Fundamentals';

  @override
  String get less => 'Less';

  @override
  String get more => 'More';

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

  @override
  String get errorServer => 'Server error occurred';

  @override
  String get errorCache => 'Local cache error';

  @override
  String get errorNetwork => 'No network connection';

  @override
  String get errorUnknown => 'Unknown error';

  @override
  String get errorInvalidCredentials => 'Invalid email or password';

  @override
  String get errorUserExists => 'Email or username already exists';

  @override
  String get errorBadRequest => 'Invalid input data';

  @override
  String get errorUnauthorized =>
      'You are not authorized or session has expired';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get systemTheme => 'System';

  @override
  String get account => 'Account';

  @override
  String get logout => 'Logout';

  @override
  String get characterDetailTitle => 'Character Details';

  @override
  String get characterMeaningUpdating => 'Updating meaning...';

  @override
  String get audioFeatureComingSoon => 'Audio feature is coming soon';

  @override
  String get pronunciation => 'Pronunciation';

  @override
  String get radicals => 'Radicals';

  @override
  String get vocabularies => 'Example Vocabularies';

  @override
  String get animationPauseTooltip => 'Pause (Clear strokes)';

  @override
  String get animationPlayTooltip => 'Play from beginning';

  @override
  String characterLoadError(String error) {
    return 'An error occurred: $error';
  }
}
