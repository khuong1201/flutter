import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/lesson_card.dart';
import 'package:course/features/home/presentation/cubit/home_cubit.dart';
import 'package:course/features/home/presentation/widgets/contribution_graph.dart';
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
              '${context.l10n.homeGreeting},',
              style: text.bodyMedium?.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              context.l10n.homeUserNamePlaceholder,
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
            child: GestureDetector(
              onTap: () => context.push(AppRoutes.profile),
              child: CircleAvatar(
                radius: 24,
                backgroundColor: colors.primaryContainer,
                child: Icon(
                  Icons.person,
                  color: colors.primary,
                ),
              ),
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
                    return ContributionGraph(contributions: state.contributions);
                  }
                  
                  if (state is HomeError) {
                    return SizedBox(
                      height: 160,
                      child: Center(
                        child: Text(
                          context.l10n.homeStatsLoadError,
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
                gradientColors: const [
                  Color(0xFFFF758C),
                  Color(0xFFFF7EB3),
                ],
                onTap: () {
                  context.push(AppRoutes.levelsLoading.replaceAll(':lang', 'ja'));
                },
              ),
              const SizedBox(height: 16),
              LessonCard(
                title: context.l10n.chineseHSK,
                languageChar: '汉',
                gradientColors: const [
                  Color(0xFFFF512F),
                  Color(0xFFF09819),
                ],
                onTap: () {
                  context.push(AppRoutes.levelsLoading.replaceAll(':lang', 'zh'));
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
}