import 'package:course/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'routes/app_router.dart';
import 'core/theme/app_theme.dart';
import 'core/utils/locale_cubit.dart';
import 'core/utils/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';

class ZenithLinguaApp extends StatelessWidget {
  const ZenithLinguaApp({super.key});

  @override
  Widget build(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    final router = AppRouter(authCubit).router;

    return BlocBuilder<LocaleCubit, Locale>(
      builder: (context, locale) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp.router(
              title: 'Zenith Lingua',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              locale: locale,
              supportedLocales: AppLocalizations.supportedLocales,
              localizationsDelegates:
                  AppLocalizations.localizationsDelegates,
              routerConfig: router,
            );
          },
        );
      },
    );
  }
}