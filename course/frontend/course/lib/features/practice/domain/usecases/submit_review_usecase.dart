import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:course/core/error/failures.dart';
import 'package:course/features/practice/domain/repositories/practice_repository.dart';

class SubmitReviewUseCase {
  final PracticeRepository repository;

  SubmitReviewUseCase(this.repository);

  Future<Either<Failure, void>> call(SubmitReviewParams params) {
    return repository.submitReview(
      characterId: params.characterId,
      grade: params.grade,
      errorDetails: params.errorDetails,
    );
  }
}

class SubmitReviewParams extends Equatable {
  final int characterId;
  final int grade;
  final dynamic errorDetails;

  const SubmitReviewParams({
    required this.characterId,
    required this.grade,
    this.errorDetails,
  });

  @override
  List<Object?> get props => [characterId, grade, errorDetails];
}
