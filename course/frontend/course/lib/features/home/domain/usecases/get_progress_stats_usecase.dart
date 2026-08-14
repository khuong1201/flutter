import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/progress_stats_entity.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';

class GetProgressStatsUseCase {
  final HomeRepository repository;

  GetProgressStatsUseCase(this.repository);

  Future<Either<Failure, ProgressStatsEntity>> call() {
    return repository.getProgressStats();
  }
}
