import 'package:dartz/dartz.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/practice/domain/entities/evaluation_result_entity.dart';

abstract class PracticeRepository {
  Future<Either<Failure, void>> submitReview({
    required int characterId,
    required int grade,
    dynamic errorDetails,
  });

  Future<Either<Failure, EvaluationResultEntity>> evaluateHandwriting({
    required int characterId,
    required List<List<Map<String, int>>> userStrokes,
  });
}

