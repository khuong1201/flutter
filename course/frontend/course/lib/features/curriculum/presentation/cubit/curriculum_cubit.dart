import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';
import 'package:course/features/curriculum/domain/usecases/get_levels_usecase.dart';
import 'package:course/features/curriculum/domain/usecases/get_lessons_by_level_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CurriculumCubit extends Cubit<CurriculumState> {
  final GetLevelsUseCase getLevelsUseCase;
  final GetLessonsByLevelUseCase getLessonsByLevelUseCase;

  CurriculumCubit({
    required this.getLevelsUseCase,
    required this.getLessonsByLevelUseCase,
  }) : super(CurriculumInitial());

  Future<void> loadLevels(String language) async {
    emit(CurriculumLoading());

    final result = await getLevelsUseCase();

    result.fold(
      (failure) => emit(CurriculumError(failure)),
      (levels) {
        final filtered = levels.where((e) => e.language == language).toList();
        emit(LevelsLoaded(filtered));
      },
    );
  }

  Future<void> loadLessons(int levelId) async {
    emit(CurriculumLoading());

    final result = await getLessonsByLevelUseCase(levelId);

    result.fold(
      (failure) => emit(CurriculumError(failure)),
      (lessons) {
        emit(LessonsLoaded(lessons));
      },
    );
  }
}

abstract class CurriculumState extends Equatable {
  const CurriculumState();

  @override
  List<Object> get props => [];
}

class CurriculumInitial extends CurriculumState {}

class CurriculumLoading extends CurriculumState {}

class LevelsLoaded extends CurriculumState {
  final List<LevelEntity> levels;

  const LevelsLoaded(this.levels);

  @override
  List<Object> get props => [levels];
}

class LessonsLoaded extends CurriculumState {
  final List<LessonEntity> lessons;

  const LessonsLoaded(this.lessons);

  @override
  List<Object> get props => [lessons];
}

class CurriculumError extends CurriculumState {
  final Failure failure;

  const CurriculumError(this.failure);

  @override
  List<Object> get props => [failure];
}
