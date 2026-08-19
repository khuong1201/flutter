import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/shared_loading_widget.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/presentation/cubit/curriculum_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonsPage extends StatelessWidget {
  final String language;
  final int levelId;
  final LevelEntity level;

  const LessonsPage({
    super.key,
    required this.language,
    required this.levelId,
    required this.level,
  });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return BlocProvider(
      create: (context) => GetIt.I<CurriculumCubit>()..loadLessons(levelId),
      child: BlocBuilder<CurriculumCubit, CurriculumState>(
        builder: (context, state) {
          if (state is CurriculumLoading || state is CurriculumInitial) {
            return Scaffold(
              backgroundColor: colors.surface,
              body: SharedLoadingWidget(
                language: language,
              ),
            );
          }

          if (state is CurriculumError) {
            return Scaffold(
              appBar: AppBar(
                title: Text(level.name),
              ),
              body: Center(
                child: Text(
                  context.getFailureMessage(state.failure),
                  style: text.bodyMedium?.copyWith(color: colors.error),
                ),
              ),
            );
          }

          if (state is LessonsLoaded) {
            final lessons = state.lessons;

            return Scaffold(
              appBar: AppBar(
                title: Text(level.name),
                backgroundColor: Colors.transparent,
                elevation: 0,
              ),
              body: lessons.isEmpty
                  ? const Center(child: Text('Chưa có bài học nào.'))
                  : ListView.builder(
                      padding: const EdgeInsets.all(20),
                      physics: const BouncingScrollPhysics(),
                      itemCount: lessons.length,
                      itemBuilder: (context, index) {
                        final lesson = lessons[index];
                        final isCompleted = lesson.status == 'completed';

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          height: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            gradient: isCompleted
                                ? LinearGradient(
                                    colors: [colors.primaryContainer, colors.primaryContainer.withValues(alpha: 0.5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  )
                                : LinearGradient(
                                    colors: [colors.surfaceContainerHighest, colors.surfaceContainerHighest.withValues(alpha: 0.5)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow.withValues(alpha: 0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius: BorderRadius.circular(20),
                              onTap: () {
                                context.push('/lesson/$language/${lesson.id}/characters');
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 56,
                                      height: 56,
                                      decoration: BoxDecoration(
                                        color: isCompleted ? colors.primary : colors.surface,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: colors.shadow.withValues(alpha: 0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          )
                                        ],
                                      ),
                                      child: Icon(
                                        isCompleted ? Icons.check_rounded : Icons.menu_book_rounded,
                                        color: isCompleted ? colors.onPrimary : colors.onSurfaceVariant,
                                        size: 28,
                                      ),
                                    ),
                                    const SizedBox(width: 20),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            'Bài ${index + 1}',
                                            style: text.labelMedium?.copyWith(
                                              color: isCompleted ? colors.primary : colors.onSurfaceVariant,
                                              letterSpacing: 1.2,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            lesson.title,
                                            style: text.titleLarge?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: colors.onSurface,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: colors.onSurfaceVariant,
                                      size: 32,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
