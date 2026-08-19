import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/level_entity.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';

class GetLevelsUseCase {
  final CurriculumRepository repository;

  GetLevelsUseCase(this.repository);

  Future<Either<Failure, List<LevelEntity>>> call() {
    return repository.getLevels();
  }
}
