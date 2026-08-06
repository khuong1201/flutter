import 'package:course/core/utils/locale_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  static const _languages = [
    ('vi', '🇻🇳 Tiếng Việt'),
    ('en', '🇬🇧 English'),
  ];

  @override
  Widget build(BuildContext context) {
    final currentLanguage = context.watch<LocaleCubit>().state.languageCode;

    return PopupMenuButton<String>(
      icon: const Icon(Icons.language_rounded),
      onSelected: (languageCode) {
        context.read<LocaleCubit>().changeLanguage(languageCode);
      },
      itemBuilder: (_) {
        return _languages.map((language) {
          final languageCode = language.$1;
          final languageName = language.$2;

          return PopupMenuItem<String>(
            value: languageCode,
            child: Row(
              children: [
                Text(languageName),
                const Spacer(),
                if (currentLanguage == languageCode)
                  const Icon(
                    Icons.check,
                    color: Colors.green,
                    size: 18,
                  ),
              ],
            ),
          );
        }).toList();
      },
    );
  }
}