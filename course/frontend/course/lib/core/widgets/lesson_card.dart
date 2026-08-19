import 'package:flutter/material.dart';

import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/presentation/widgets/stroke_animation_widget.dart';

class LessonCard extends StatelessWidget {
  final String title;
  final String? subtitle;
  final String languageChar;
  final VoidCallback onTap;
  final List<StrokeDataEntity>? strokeData;
  final List<Color>? gradientColors;

  const LessonCard({
    super.key,
    required this.title,
    this.subtitle,
    required this.languageChar,
    required this.onTap,
    this.strokeData,
    this.gradientColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: gradientColors == null ? colors.surface : null,
        gradient: gradientColors != null
            ? LinearGradient(
                colors: gradientColors!,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: (gradientColors?.first ?? Colors.black).withValues(alpha: 0.2),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
        border: isDark && gradientColors == null
            ? Border.all(
                color: colors.outline.withValues(alpha: 0.3),
                width: 1,
              )
            : null,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: onTap,
          highlightColor: colors.onSurface.withValues(alpha: 0.1),
          splashColor: colors.onSurface.withValues(alpha: 0.1),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
            // Background Animation
            if (strokeData != null && strokeData!.isNotEmpty)
              Positioned(
                right: -40,
                bottom: -40,
                child: IgnorePointer(
                  child: StrokeAnimationWidget(
                    strokeData: strokeData!,
                    size: 240,
                    strokeColor: (gradientColors == null ? colors.primary : Colors.white).withValues(alpha: 0.15),
                    outlineColor: Colors.transparent,
                    loop: false,
                    animate: false,
                    showGrid: false,
                    showControls: false,
                  ),
                ),
              )
            else
              Positioned(
                right: 8,
                bottom: -8,
                child: Text(
                  languageChar,
                  style: text.displayLarge?.copyWith(
                    fontSize: 60,
                    color: (gradientColors == null ? colors.primary : Colors.white).withValues(alpha: 0.2),
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
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: gradientColors == null ? colors.onSurface : Colors.white,
                            ),
                          ),
                          if (subtitle != null) ...[
                            const SizedBox(height: 4),
                            Text(
                              subtitle!,
                              style: text.titleMedium?.copyWith(
                                color: gradientColors == null ? colors.onSurfaceVariant : Colors.white.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
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
    ),
      ),
        ),
      );
  }
}