import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/curriculum/domain/entities/roadmap_entity.dart';
import 'package:course/features/curriculum/domain/repositories/curriculum_repository.dart';

class GetRoadmapUseCase {
  final CurriculumRepository repository;

  GetRoadmapUseCase(this.repository);

  Future<Either<Failure, List<RoadmapEntity>>> call([String? lang]) {
    return repository.getRoadmap(lang);
  }
}
