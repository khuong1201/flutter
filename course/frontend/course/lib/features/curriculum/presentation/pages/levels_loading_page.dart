import 'package:course/core/widgets/shared_loading_widget.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/presentation/cubit/curriculum_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

class LevelsLoadingPage extends StatefulWidget {
  final String language;

  const LevelsLoadingPage({
    super.key,
    required this.language,
  });

  @override
  State<LevelsLoadingPage> createState() => _LevelsLoadingPageState();
}

class _LevelsLoadingPageState extends State<LevelsLoadingPage> {
  bool _isDataLoaded = false;
  bool _isAnimationCompleted = false;
  List<LevelEntity> _levels = [];
  bool _hasError = false;

  void _checkAndNavigate() {
    if (_isDataLoaded && _isAnimationCompleted) {
      if (_hasError) {
        context.pushReplacement('/levels/${widget.language}');
      } else {
        context.pushReplacement('/levels/${widget.language}', extra: _levels);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GetIt.I<CurriculumCubit>()..loadLevels(widget.language),
      child: BlocListener<CurriculumCubit, CurriculumState>(
        listener: (context, state) {
          if (state is LevelsLoaded) {
            _isDataLoaded = true;
            _levels = state.levels;
            _checkAndNavigate();
          } else if (state is CurriculumError) {
            _isDataLoaded = true;
            _hasError = true;
            _checkAndNavigate();
          }
        },
        child: Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
                  Theme.of(context).colorScheme.surface,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: SharedLoadingWidget(
              language: widget.language,
              onAnimationCompleted: () {
                if (mounted) {
                  setState(() {
                    _isAnimationCompleted = true;
                  });
                  _checkAndNavigate();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
