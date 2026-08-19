import 'package:course/core/error/failures.dart';
import 'package:course/features/home/data/models/contribution_model.dart';
import 'package:course/features/home/domain/entities/contribution_entity.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  final Map<int, List<ContributionEntity>> _cachedContributions = {};
  final Map<int, DateTime> _cacheTime = {};

  HomeRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<ContributionEntity>>> getContributions(int year) async {
    final now = DateTime.now();
    if (_cachedContributions.containsKey(year) && _cacheTime.containsKey(year)) {
      if (now.difference(_cacheTime[year]!).inMinutes < 5) {
        return Right(_cachedContributions[year]!);
      }
    }

    try {
      final response = await dio.get(
        '/contributions',
        queryParameters: {'year': year},
      );
      
      final List<dynamic> data = response.data;
      final contributions = data.map((e) => ContributionModel.fromJson(e as Map<String, dynamic>)).toList();
          
      _cachedContributions[year] = contributions;
      _cacheTime[year] = now;

      return Right(contributions);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }
}
