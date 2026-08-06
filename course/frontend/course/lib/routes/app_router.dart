import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:course/features/auth/presentation/pages/login_page.dart';
import 'package:course/features/auth/presentation/pages/splash_page.dart';
import 'package:course/features/home/presentation/pages/home_page.dart';
import 'package:go_router/go_router.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter(this.authCubit);

  final AuthCubit authCubit;

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    refreshListenable: GoRouterRefreshStream(authCubit.stream),
    redirect: (_, state) {
      final auth = authCubit.state;

      final location = state.matchedLocation;

      final isSplash = location == AppRoutes.splash;
      final isLogin = location == AppRoutes.login;

      if (auth is AuthInitial || auth is AuthLoading) {
        return null;
      }

      if (auth is AuthUnauthenticated) {
        return isLogin ? null : AppRoutes.login;
      }

      if (auth is AuthAuthenticated) {
        if (isSplash || isLogin) {
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
        path: AppRoutes.home,
        builder: (_, _) => const HomePage(),
      ),
    ],
  );
}