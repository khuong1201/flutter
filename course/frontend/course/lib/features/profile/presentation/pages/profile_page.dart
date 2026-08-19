import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/features/profile/domain/entities/profile_entity.dart';
import 'package:course/features/profile/domain/entities/progress_stats_entity.dart';
import 'package:course/features/profile/presentation/cubit/profile_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.profileTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocProvider(
        create: (context) => GetIt.I<ProfileCubit>()..loadProfileData(),
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, state) {
            if (state is ProfileLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is ProfileError) {
              return Center(
                child: Text(
                  context.getFailureMessage(state.failure),
                  style: text.bodyMedium?.copyWith(color: colors.error),
                ),
              );
            }

            if (state is ProfileLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildUserInfo(context, state.profile, colors, text),
                    const SizedBox(height: 32),
                    _buildStatsGrid(context, state.stats, colors, text),
                  ],
                ),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildUserInfo(BuildContext context, ProfileEntity profile, ColorScheme colors, TextTheme text) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundColor: colors.primaryContainer,
          backgroundImage: profile.avatarUrl != null ? NetworkImage(profile.avatarUrl!) : null,
          child: profile.avatarUrl == null
              ? Icon(Icons.person, size: 50, color: colors.primary)
              : null,
        ),
        const SizedBox(height: 16),
        Text(
          profile.fullName,
          style: text.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          profile.email,
          style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: colors.secondaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            'Target: ${profile.targetLanguage.toUpperCase()} ${profile.targetLevel}',
            style: text.labelLarge?.copyWith(color: colors.onSecondaryContainer),
          ),
        ),
      ],
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
