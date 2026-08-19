import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/contribution_entity.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<ContributionEntity>>> getContributions(int year);
}
