import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/app_button.dart';
import 'package:course/core/widgets/lesson_card.dart';
import 'package:course/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Chào buổi sáng,',
              style: text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Zenith Learner!',
              style: text.headlineLarge?.copyWith(
                fontSize: 24,
                color: colors.onSurface,
              ),
            ),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'settings') {
                  context.push(AppRoutes.settings);
                }
              },
              offset: const Offset(0, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: colors.primary,
                ),
              ),
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'settings',
                  child: Row(
                    children: [
                      Icon(Icons.settings_outlined, color: colors.primary),
                      const SizedBox(width: 12),
                      Text(context.l10n.settingsTitle),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primary,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Mục tiêu hằng ngày',
                          style: text.bodyLarge?.copyWith(
                            color: colors.onPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Tiếp tục giữ chuỗi học tập nhé!',
                          style: text.bodyMedium?.copyWith(
                            color: colors.onPrimary.withValues(alpha: 0.8),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.local_fire_department_rounded,
                    size: 48,
                    color: colors.onPrimary,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            Text(
              'Lộ trình của bạn',
              style: text.headlineLarge?.copyWith(
                fontSize: 20,
              ),
            ),
            const SizedBox(height: 16),
            LessonCard(
              title: 'Basic Expressions',
              subtitle: 'Learn greetings and essentials',
              progress: 1,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            LessonCard(
              title: 'Japanese (JLPT)',
              subtitle: 'N5 Vocabulary & Kanji',
              progress: 0.45,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            LessonCard(
              title: 'Chinese (HSK)',
              subtitle: 'HSK 1 Fundamentals',
              progress: 0,
              onTap: () {},
            ),
            const SizedBox(height: 32),
            AppButton(
              label: 'Kiểm tra trình độ',
              type: AppButtonType.secondary,
              onPressed: () {},
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}