import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/practice/domain/repositories/practice_repository.dart';
import 'package:course/features/practice/domain/entities/evaluation_result_entity.dart';

class EvaluateHandwritingUseCase {
  final PracticeRepository repository;

  EvaluateHandwritingUseCase(this.repository);

  Future<Either<Failure, EvaluationResultEntity>> call(EvaluateHandwritingParams params) {
    return repository.evaluateHandwriting(
      characterId: params.characterId,
      userStrokes: params.userStrokes,
    );
  }
}

class EvaluateHandwritingParams extends Equatable {
  final int characterId;
  final List<List<Map<String, int>>> userStrokes;

  const EvaluateHandwritingParams({
    required this.characterId,
    required this.userStrokes,
  });

  @override
  List<Object?> get props => [characterId, userStrokes];
}
