import 'package:course/core/error/failures.dart';
import 'package:course/features/home/data/models/progress_stats_model.dart';
import 'package:course/features/home/domain/entities/progress_stats_entity.dart';
import 'package:course/features/home/domain/repositories/home_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class HomeRepositoryImpl implements HomeRepository {
  final Dio dio;

  HomeRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, ProgressStatsEntity>> getProgressStats() async {
    try {
      final response = await dio.get('/progress/stats');
      
      final stats = ProgressStatsModel.fromJson(response.data);
          
      return Right(stats);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }
}
