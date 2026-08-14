import 'package:equatable/equatable.dart';

class EvaluationResultEntity extends Equatable {
  final int score;
  final String feedback;

  const EvaluationResultEntity({
    required this.score,
    required this.feedback,
  });

  @override
  List<Object?> get props => [score, feedback];
}
