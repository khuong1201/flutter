import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/lesson_character_entity.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';

class GetLessonCharactersUseCase {
  final CurriculumRepository repository;

  GetLessonCharactersUseCase(this.repository);

  Future<Either<Failure, List<LessonCharacterEntity>>> call(int lessonId) {
    return repository.getLessonCharacters(lessonId);
  }
}
