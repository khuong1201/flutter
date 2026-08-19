import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/profile/domain/entities/profile_entity.dart';
import 'package:course/features/profile/domain/entities/progress_stats_entity.dart';

abstract class ProfileRepository {
  Future<Either<Failure, ProfileEntity>> getProfile();
  Future<Either<Failure, ProgressStatsEntity>> getProgressStats();
  Future<Either<Failure, void>> deleteProfile();
}
