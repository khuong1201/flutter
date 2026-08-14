import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/lesson_card.dart';
import 'package:course/features/home/presentation/cubit/home_cubit.dart';
import 'package:course/features/home/domain/entities/progress_stats_entity.dart';
import 'package:course/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
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
      body: BlocProvider(
        create: (context) => GetIt.I<HomeCubit>()..loadData(),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeLoading) {
                    return const SizedBox(
                      height: 160,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  if (state is HomeLoaded) {
                    return _buildStatsGrid(context, state.stats, colors, text);
                  }
                  
                  if (state is HomeError) {
                    return SizedBox(
                      height: 160,
                      child: Center(
                        child: Text(
                          'Không thể tải dữ liệu thống kê',
                          style: text.bodyMedium?.copyWith(color: colors.error),
                        ),
                      ),
                    );
                  }

                  // Initial or empty state
                  return const SizedBox();
                },
              ),
              const SizedBox(height: 24),
              LessonCard(
                title: context.l10n.japaneseJLPT,
                languageChar: '日',
                onTap: () {
                  // Navigate to a random character ID for demonstration (16278 to 32554)
                  final randomId = 16278 + (DateTime.now().millisecondsSinceEpoch % (32554 - 16278 + 1));
                  context.push(AppRoutes.character.replaceAll(':id', randomId.toString()));
                },
              ),
              const SizedBox(height: 16),
              LessonCard(
                title: context.l10n.chineseHSK,
                languageChar: '中',
                onTap: () {
                  final randomId = 16278 + (DateTime.now().millisecondsSinceEpoch % (32554 - 16278 + 1));
                  context.push(AppRoutes.character.replaceAll(':id', randomId.toString()));
                },
              ),
              const SizedBox(height: 32),
              Center(
                child: Text(
                  context.l10n.homeSlogan,
                  style: text.bodyLarge?.copyWith(
                    fontStyle: FontStyle.italic,
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsGrid(BuildContext context, ProgressStatsEntity stats, ColorScheme colors, TextTheme text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tiến độ của bạn',
          style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildStatCard('Đã học', '${stats.totalLearned}', Icons.menu_book, colors.primaryContainer, colors.onPrimaryContainer, text)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Thành thạo', '${stats.totalMastered}', Icons.workspace_premium, colors.secondaryContainer, colors.onSecondaryContainer, text)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(child: _buildStatCard('Độ chính xác', '${stats.accuracyRate}%', Icons.check_circle, colors.tertiaryContainer, colors.onTertiaryContainer, text)),
            const SizedBox(width: 12),
            Expanded(child: _buildStatCard('Chuỗi ngày', '${stats.currentStreak} 🔥', Icons.local_fire_department, colors.errorContainer, colors.onErrorContainer, text)),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatCard('Điểm XP', '${stats.xpPoints} XP', Icons.stars, colors.surfaceContainerHigh, colors.onSurface, text),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color bgColor, Color textColor, TextTheme text) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: textColor),
          const SizedBox(height: 12),
          Text(title, style: text.labelMedium?.copyWith(color: textColor)),
          const SizedBox(height: 4),
          Text(value, style: text.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: textColor)),
        ],
      ),
    );
  }
}