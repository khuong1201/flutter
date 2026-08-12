import 'package:flutter/material.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String languageChar;
  final VoidCallback onTap;

  const LessonCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.languageChar,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: isDark
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.04),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
          border: isDark
              ? Border.all(
                  color: colors.outline.withValues(alpha: 0.3),
                  width: 1,
                )
              : null,
        ),
        child: Stack(
          children: [
            Positioned(
              right: -10,
              bottom: 10,
              child: Text(
                languageChar,
                style: text.displayLarge?.copyWith(
                  fontSize: 80,
                  color: colors.primary.withValues(alpha: 0.1),
                  height: 1,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: text.headlineLarge?.copyWith(
                              fontSize: 20,
                              color: colors.onSurface,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: text.bodyMedium?.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}