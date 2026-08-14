import 'package:course/features/practice/domain/entities/evaluation_result_entity.dart';

class EvaluationResultModel extends EvaluationResultEntity {
  const EvaluationResultModel({
    required super.score,
    required super.feedback,
  });

  factory EvaluationResultModel.fromJson(Map<String, dynamic> json) {
    return EvaluationResultModel(
      score: json['score'] as int,
      feedback: json['feedback'] as String,
    );
  }
}
