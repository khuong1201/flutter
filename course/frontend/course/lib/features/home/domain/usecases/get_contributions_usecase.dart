import 'package:course/core/error/failures.dart';
import 'package:course/features/home/domain/entities/contribution_entity.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';

class GetContributionsUseCase {
  final HomeRepository repository;

  GetContributionsUseCase(this.repository);

  Future<Either<Failure, List<ContributionEntity>>> call(int year) {
    return repository.getContributions(year);
  }
}
