import 'package:course/features/characters/domain/entities/character_entity.dart';
import 'package:course/features/characters/presentation/cubit/character_cubit.dart';
import 'package:course/features/characters/presentation/widgets/stroke_animation_widget.dart';
import 'package:course/features/characters/presentation/widgets/drawing_board_widget.dart';
import 'package:course/features/practice/presentation/cubit/practice_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_drawing/path_drawing.dart';
import 'package:get_it/get_it.dart';
import 'package:course/core/utils/l10n_extension.dart';

class CharacterPage extends StatelessWidget {
  final int characterId;

  const CharacterPage({
    super.key,
    required this.characterId,
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<CharacterCubit>()..loadCharacter(characterId),
        ),
        BlocProvider(
          create: (context) => GetIt.I<PracticeCubit>(),
        ),
      ],
      child: const _CharacterPageView(),
    );
  }
}

class _CharacterPageView extends StatefulWidget {
  const _CharacterPageView();

  @override
  State<_CharacterPageView> createState() => _CharacterPageViewState();
}

class _CharacterPageViewState extends State<_CharacterPageView> {
  bool _isPracticeMode = false;
  List<List<Offset>> _currentStrokes = [];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final text = theme.textTheme;

    return BlocListener<PracticeCubit, PracticeState>(
      listener: (context, state) {
        if (state is PracticeSubmitting) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.submitting)),
          );
        } else if (state is PracticeEvaluationSuccess) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Kết quả chấm điểm'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${state.result.score} / 100',
                    style: text.displayMedium?.copyWith(
                      color: state.result.score > 80 ? colors.primary : colors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(state.result.feedback, textAlign: TextAlign.center),
                ],
              ),
              actions: [
                FilledButton(
                  onPressed: () {
                    Navigator.pop(ctx);
                    setState(() {
                      _isPracticeMode = false;
                    });
                  },
                  child: const Text('Đóng'),
                )
              ],
            )
          );
        } else if (state is PracticeSubmitFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(context.l10n.characterLoadError(state.failure.messageKey))),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
        title: Text(context.l10n.characterDetailTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<CharacterCubit, CharacterState>(
        builder: (context, state) {
          if (state is CharacterLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          
          if (state is CharacterError) {
            return Center(
              child: Text(
                context.l10n.characterLoadError(state.failure.messageKey),
                style: text.bodyLarge?.copyWith(color: colors.error),
              ),
            );
          }

          if (state is CharacterLoaded) {
            final char = state.character;
            
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Row: Ý nghĩa + Icon Âm thanh
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          char.meaning.isNotEmpty ? char.meaning : context.l10n.characterMeaningUpdating,
                          style: text.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: colors.onSurface,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, size: 32),
                        color: colors.primary,
                        onPressed: () {
                          // TODO: Xử lý phát âm thanh audioKey
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(context.l10n.audioFeatureComingSoon)),
                          );
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  
                  // Animation Widget hoặc Drawing Board
                  Center(
                    child: _isPracticeMode
                        ? DrawingBoardWidget(
                            outlinePaths: char.strokes.map((e) => parseSvgPathData(e.outlinePath)).toList(),
                            size: MediaQuery.sizeOf(context).width - 32,
                            onStrokesUpdated: (strokes) {
                              _currentStrokes = strokes;
                            },
                          )
                        : StrokeAnimationWidget(
                            strokeData: char.strokes,
                            size: MediaQuery.sizeOf(context).width - 32,
                            strokeColor: colors.primary,
                            outlineColor: colors.onSurfaceVariant,
                          ),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Nút chuyển chế độ & Nộp bài
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(_isPracticeMode ? Icons.auto_awesome : Icons.draw),
                        label: Text(_isPracticeMode ? context.l10n.viewGuide : context.l10n.practiceWriting),
                        onPressed: () {
                          setState(() {
                            _isPracticeMode = !_isPracticeMode;
                          });
                        },
                      ),
                      if (_isPracticeMode) ...[
                        const SizedBox(width: 16),
                        FilledButton.icon(
                          icon: const Icon(Icons.check),
                          label: Text(context.l10n.submitReview),
                          onPressed: () {
                            if (_currentStrokes.isEmpty) {
                               ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(context.l10n.emptyStrokes)),
                              );
                              return;
                            }
                            
                            final RenderBox? box = context.findRenderObject() as RenderBox?;
                            double size = box?.size.width ?? 300;
                            
                            final scaledStrokes = _currentStrokes.map((stroke) => 
                              stroke.map((p) => {
                                'x': (p.dx / size * 1024).round(),
                                'y': (p.dy / size * 1024).round()
                              }).toList()
                            ).toList();
              
                            context.read<PracticeCubit>().evaluateHandwriting(
                              char.id, 
                              scaledStrokes
                            );
                          },
                        ),
                      ],
                    ],
                  ),
                  
                  const SizedBox(height: 32),
                  
                  // Phát âm
                  if (char.readings.isNotEmpty) _buildReadings(context, char.readings),
                  
                  const SizedBox(height: 24),
                  
                  // Bộ thủ
                  if (char.radicals.isNotEmpty) _buildRadicals(context, char.radicals),
                  
                  const SizedBox(height: 24),
                  
                  // Từ vựng ví dụ
                  if (char.vocabularies.isNotEmpty) _buildVocabularies(context, char.vocabularies),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    ));
  }

  Widget _buildReadings(BuildContext context, List<ReadingEntity> readings) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            context.l10n.pronunciation,
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...readings.map((r) => Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: r.readingType == 'onyomi' ? colors.primaryContainer : colors.secondaryContainer,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    r.readingType, 
                    style: text.labelSmall?.copyWith(
                      color: r.readingType == 'onyomi' ? colors.onPrimaryContainer : colors.onSecondaryContainer
                    )
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(child: Text(r.reading)),
              ],
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildRadicals(BuildContext context, List<RadicalEntity> radicals) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.radicals,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: radicals.map((r) {
            return Chip(
              label: Text('${r.radicalText} - ${r.meaning}'),
              backgroundColor: colors.surfaceContainerHigh,
              side: BorderSide.none,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVocabularies(BuildContext context, List<VocabularyEntity> vocabularies) {
    final colors = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          context.l10n.vocabularies,
          style: text.titleMedium?.copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        ...vocabularies.map((v) => Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: colors.outlineVariant),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Text(
                  v.word,
                  style: text.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: colors.primary,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(v.pronunciation, style: text.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                      Text(v.meaning, style: text.bodyMedium),
                    ],
                  ),
                ),
              ],
            ),
          ),
        )),
      ],
    );
  }
}
