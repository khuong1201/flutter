import 'package:course/core/error/failures.dart';
import 'package:course/features/profile/data/models/profile_model.dart';
import 'package:course/features/profile/data/models/progress_stats_model.dart';
import 'package:course/features/profile/domain/entities/profile_entity.dart';
import 'package:course/features/profile/domain/entities/progress_stats_entity.dart';
import 'package:course/features/profile/domain/repositories/profile_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final Dio dio;

  ProfileRepositoryImpl(this.dio);

  @override
  Future<Either<Failure, ProfileEntity>> getProfile() async {
    try {
      final response = await dio.get('/users/profile');
      final profile = ProfileModel.fromJson(response.data);
      return Right(profile);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }

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

  @override
  Future<Either<Failure, void>> deleteProfile() async {
    try {
      await dio.delete('/users/profile');
      return const Right(null);
    } catch (e) {
      if (e is DioException) {
        return Left(ServerFailure());
      }
      return Left(UnknownFailure());
    }
  }
}
