import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:course/features/auth/presentation/pages/login_page.dart';
import 'package:course/features/auth/presentation/pages/register_page.dart';
import 'package:course/features/auth/presentation/pages/splash_page.dart';
import 'package:course/features/characters/presentation/pages/character_page.dart';
import 'package:course/features/curriculum/presentation/pages/lesson_detail_page.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/presentation/pages/levels_loading_page.dart';
import 'package:course/features/curriculum/presentation/pages/levels_page.dart';
import 'package:course/features/curriculum/presentation/pages/lessons_page.dart';
import 'package:course/features/home/presentation/pages/home_page.dart';
import 'package:course/features/profile/presentation/pages/profile_page.dart';
import 'package:course/features/settings/presentation/pages/settings_page.dart';
import 'package:go_router/go_router.dart';

import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter(this.authCubit);

  final AuthCubit authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(
      authCubit.stream,
    ),
    redirect: (_, state) {
      final auth = authCubit.state;
      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;
      final isRegister = location == AppRoutes.register;

      final isAuthRoute = isLogin || isRegister;

      if (auth is AuthInitial || auth is AuthLoading) {
        return null;
      }
      if (auth is AuthUnauthenticated) {
        return isAuthRoute
            ? null
            : AppRoutes.login;
      }

      if (auth is AuthAuthenticated) {
        if (isSplash || isAuthRoute) {
          return AppRoutes.home;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        builder: (_, _) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, _) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, _) => const RegisterPage(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, _) => const HomePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, _) => const SettingsPage(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        builder: (_, _) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.levelsLoading,
        builder: (_, state) {
          final lang = state.pathParameters['lang'] ?? 'ja';
          return LevelsLoadingPage(language: lang);
        },
      ),
      GoRoute(
        path: AppRoutes.levels,
        builder: (_, state) {
          final lang = state.pathParameters['lang'] ?? 'ja';
          final levels = state.extra as List<LevelEntity>?;
          return LevelsPage(language: lang, levels: levels);
        },
      ),
      GoRoute(
        path: AppRoutes.lessons,
        builder: (_, state) {
          final lang = state.pathParameters['lang'] ?? 'ja';
          final levelId = int.tryParse(state.pathParameters['levelId'] ?? '') ?? 0;
          final level = state.extra as LevelEntity;
          return LessonsPage(
            language: lang,
            levelId: levelId,
            level: level,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.lessonCharacters,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final lang = state.pathParameters['lang'] ?? 'ja';
          return LessonDetailPage(lessonId: id, language: lang);
        },
      ),
      GoRoute(
        path: AppRoutes.character,
        builder: (_, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          final initialData = state.extra;
          return CharacterPage(
            characterId: id,
            initialData: initialData,
          );
        },
      ),
    ],
  );
}