import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/lesson_entity.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';

class GetLessonsByLevelUseCase {
  final CurriculumRepository repository;

  GetLessonsByLevelUseCase(this.repository);

  Future<Either<Failure, List<LessonEntity>>> call(int levelId) {
    return repository.getLessonsByLevel(levelId);
  }
}
