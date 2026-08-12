import 'package:course/core/error/failures.dart';
import 'package:course/features/home/data/models/contribution_model.dart';
import 'package:course/features/home/domain/entities/contribution_entity.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, List<ContributionEntity>>> getContributions(int year) async {
    try {
      final response = await dio.get('/contributions', queryParameters: {
        'year': year,
      });
      
      final List<dynamic> dataList = response.data;
      final contributions = dataList
          .map((json) => ContributionModel.fromJson(json))
          .toList();
          
      return Right(contributions);
    } catch (e) {
      if (e is DioException) {
        // final code = e.apiCode; // Add specific error parsing if needed in the future
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }
}
