import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/practice/domain/repositories/practice_repository.dart';
import 'package:course/features/practice/data/datasources/practice_remote_datasource.dart';
import 'package:course/features/practice/domain/entities/evaluation_result_entity.dart';

class PracticeRepositoryImpl implements PracticeRepository {
  final PracticeRemoteDataSource remoteDataSource;

  PracticeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> submitReview({
    required int characterId,
    required int grade,
    dynamic errorDetails,
  }) async {
    try {
      await remoteDataSource.submitReview(
        characterId: characterId,
        grade: grade,
        errorDetails: errorDetails,
      );
      return const Right(null);
    } on DioException {
      // TODO: Map to proper Failure based on e.response
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }

  @override
  Future<Either<Failure, EvaluationResultEntity>> evaluateHandwriting({
    required int characterId,
    required List<List<Map<String, int>>> userStrokes,
  }) async {
    try {
      final result = await remoteDataSource.evaluateHandwriting(
        characterId: characterId,
        userStrokes: userStrokes,
      );
      return Right(result);
    } on DioException {
      return Left(ServerFailure());
    } catch (_) {
      return Left(UnknownFailure());
    }
  }
}

