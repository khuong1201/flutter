import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/progress_stats_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, ProgressStatsEntity>> getProgressStats();
}
