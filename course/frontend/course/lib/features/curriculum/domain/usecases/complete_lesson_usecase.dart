import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';

class CompleteLessonUseCase {
  final CurriculumRepository repository;

  CompleteLessonUseCase(this.repository);

  Future<Either<Failure, void>> call(int lessonId) {
    return repository.completeLesson(lessonId);
  }
}
