import 'package:course/core/error/failures.dart';
import 'package:course/features/practice/domain/usecases/submit_review_usecase.dart';
import 'package:course/features/practice/domain/usecases/evaluate_handwriting_usecase.dart';
import 'package:course/features/practice/domain/entities/evaluation_result_entity.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PracticeState extends Equatable {
  const PracticeState();

  @override
  List<Object?> get props => [];
}

class PracticeInitial extends PracticeState {}

class PracticeSubmitting extends PracticeState {}

class PracticeSubmitSuccess extends PracticeState {}

class PracticeEvaluationSuccess extends PracticeState {
  final EvaluationResultEntity result;

  const PracticeEvaluationSuccess(this.result);

  @override
  List<Object?> get props => [result];
}

class PracticeSubmitFailure extends PracticeState {
  final Failure failure;

  const PracticeSubmitFailure(this.failure);

  @override
  List<Object?> get props => [failure];
}

class PracticeCubit extends Cubit<PracticeState> {
  final SubmitReviewUseCase submitReviewUseCase;
  final EvaluateHandwritingUseCase evaluateHandwritingUseCase;

  PracticeCubit({
    required this.submitReviewUseCase,
    required this.evaluateHandwritingUseCase,
  }) : super(PracticeInitial());

  Future<void> submitPracticeReview(int characterId, int grade, dynamic errorDetails) async {
    emit(PracticeSubmitting());
    final result = await submitReviewUseCase(
      SubmitReviewParams(
        characterId: characterId,
        grade: grade,
        errorDetails: errorDetails,
      ),
    );
    result.fold(
      (failure) => emit(PracticeSubmitFailure(failure)),
      (_) => emit(PracticeSubmitSuccess()),
    );
  }

  Future<void> evaluateHandwriting(int characterId, List<List<Map<String, int>>> userStrokes) async {
    emit(PracticeSubmitting());
    final result = await evaluateHandwritingUseCase(
      EvaluateHandwritingParams(
        characterId: characterId,
        userStrokes: userStrokes,
      ),
    );
    result.fold(
      (failure) => emit(PracticeSubmitFailure(failure)),
      (evaluation) => emit(PracticeEvaluationSuccess(evaluation)),
    );
  }
}
