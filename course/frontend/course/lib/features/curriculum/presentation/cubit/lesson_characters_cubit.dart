import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/lesson_character_entity.dart';
import 'package:course/features/curriculum/domain/usecases/get_lesson_characters_usecase.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LessonCharactersCubit extends Cubit<LessonCharactersState> {
  final GetLessonCharactersUseCase getLessonCharactersUseCase;

  LessonCharactersCubit({
    required this.getLessonCharactersUseCase,
  }) : super(LessonCharactersInitial());

  Future<void> loadCharacters(int lessonId) async {
    emit(LessonCharactersLoading());

    final result = await getLessonCharactersUseCase(lessonId);

    result.fold(
      (failure) => emit(LessonCharactersError(failure)),
      (characters) => emit(LessonCharactersLoaded(characters)),
    );
  }
}

abstract class LessonCharactersState extends Equatable {
  const LessonCharactersState();

  @override
  List<Object> get props => [];
}

class LessonCharactersInitial extends LessonCharactersState {}

class LessonCharactersLoading extends LessonCharactersState {}

class LessonCharactersLoaded extends LessonCharactersState {
  final List<LessonCharacterEntity> characters;

  const LessonCharactersLoaded(this.characters);

  @override
  List<Object> get props => [characters];
}

class LessonCharactersError extends LessonCharactersState {
  final Failure failure;

  const LessonCharactersError(this.failure);

  @override
  List<Object> get props => [failure];
}
