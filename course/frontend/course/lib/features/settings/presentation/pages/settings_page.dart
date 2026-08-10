import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/utils/locale_cubit.dart';
import 'package:course/core/utils/theme_cubit.dart';
import 'package:course/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final textTheme = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          // App Preferences
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              'App Preferences',
              style: textTheme.labelLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Language Setting
          BlocBuilder<LocaleCubit, Locale>(
            builder: (context, locale) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.language),
                title: Text(l10n.language),
                trailing: DropdownButton<String>(
                  value: locale.languageCode,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: const [
                    DropdownMenuItem(value: 'vi', child: Text('Tiếng Việt')),
                    DropdownMenuItem(value: 'en', child: Text('English')),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<LocaleCubit>().changeLanguage(value);
                    }
                  },
                ),
              );
            },
          ),
          const Divider(indent: 24, endIndent: 24),
          
          // Theme Setting
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, themeMode) {
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24),
                leading: const Icon(Icons.palette_outlined),
                title: Text(l10n.theme),
                trailing: DropdownButton<ThemeMode>(
                  value: themeMode,
                  underline: const SizedBox(),
                  icon: const Icon(Icons.arrow_drop_down),
                  items: [
                    DropdownMenuItem(value: ThemeMode.system, child: Text(l10n.systemTheme)),
                    DropdownMenuItem(value: ThemeMode.light, child: Text(l10n.lightTheme)),
                    DropdownMenuItem(value: ThemeMode.dark, child: Text(l10n.darkTheme)),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      context.read<ThemeCubit>().changeTheme(value);
                    }
                  },
                ),
              );
            },
          ),

          const SizedBox(height: 32),
          
          // Account
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            child: Text(
              l10n.account,
              style: textTheme.labelLarge?.copyWith(
                color: colors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          
          // Logout
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 24),
            leading: Icon(Icons.logout, color: colors.error),
            title: Text(
              l10n.logout,
              style: textTheme.bodyLarge?.copyWith(color: colors.error),
            ),
            onTap: () {
              context.read<AuthCubit>().logout();
            },
          ),
        ],
      ),
    );
  }
}
