import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/profile/domain/entities/progress_stats_entity.dart';
import 'package:course/features/profile/domain/repositories/profile_repository.dart';

class GetProgressStatsUseCase {
  final ProfileRepository repository;

  GetProgressStatsUseCase(this.repository);

  Future<Either<Failure, ProgressStatsEntity>> call() {
    return repository.getProgressStats();
  }
}
