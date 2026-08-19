abstract final class AppRoutes {
  AppRoutes._();

  static const splash = '/splash';
  static const login = '/login';
  static const register = '/register';
  static const home = '/home';
  static const settings = '/settings';
  static const String character = '/character/:id';
  static const String profile = '/profile';
  static const String levelsLoading = '/levels-loading/:lang';
  static const String levels = '/levels/:lang';
  static const String lessons = '/levels/:lang/lessons/:levelId';
  static const String lessonCharacters = '/lesson/:lang/:id/characters';
}