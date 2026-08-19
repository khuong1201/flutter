import 'package:course/core/utils/l10n_extension.dart';
import 'package:course/core/widgets/shared_loading_widget.dart';
import 'package:course/features/curriculum/presentation/cubit/lesson_characters_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LessonDetailPage extends StatelessWidget {
  final int lessonId;
  final String language;

  const LessonDetailPage({
    super.key,
    required this.lessonId,
    required this.language,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Từ vựng bài học'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocProvider(
        create: (context) => GetIt.I<LessonCharactersCubit>()..loadCharacters(lessonId),
        child: BlocBuilder<LessonCharactersCubit, LessonCharactersState>(
          builder: (context, state) {
            if (state is LessonCharactersLoading || state is LessonCharactersInitial) {
              return SharedLoadingWidget(language: language);
            }

            if (state is LessonCharactersError) {
              return Center(
                child: Text(
                  context.getFailureMessage(state.failure),
                  style: text.bodyMedium?.copyWith(color: colors.error),
                ),
              );
            }

            if (state is LessonCharactersLoaded) {
              final characters = state.characters;

              if (characters.isEmpty) {
                return const Center(child: Text('Chưa có từ vựng nào trong bài học này.'));
              }

              return GridView.builder(
                padding: const EdgeInsets.all(20),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.85,
                ),
                itemCount: characters.length,
                itemBuilder: (context, index) {
                  final char = characters[index];
                  return InkWell(
                    onTap: () => context.push('/character/${char.id}', extra: char),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colors.surfaceContainerHighest.withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            char.charText,
                            style: text.displaySmall?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          if (char.pronunciation != null)
                            Text(
                              char.pronunciation!,
                              style: text.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                            ),
                          const SizedBox(height: 4),
                          Text(
                            char.meaning,
                            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w500),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
