import 'package:dio/dio.dart';
import 'package:course/features/practice/data/models/evaluation_result_model.dart';

abstract class PracticeRemoteDataSource {
  Future<void> submitReview({
    required int characterId,
    required int grade,
    dynamic errorDetails,
  });

  Future<EvaluationResultModel> evaluateHandwriting({
    required int characterId,
    required List<List<Map<String, int>>> userStrokes,
  });
}

class PracticeRemoteDataSourceImpl implements PracticeRemoteDataSource {
  final Dio dio;

  PracticeRemoteDataSourceImpl({required this.dio});

  @override
  Future<void> submitReview({
    required int characterId,
    required int grade,
    dynamic errorDetails,
  }) async {
    final Map<String, dynamic> data = {
      'characterId': characterId,
      'grade': grade,
    };
    if (errorDetails != null) {
      data['errorDetails'] = errorDetails;
    }
    await dio.post(
      '/practice/review',
      data: data,
    );
  }

  @override
  Future<EvaluationResultModel> evaluateHandwriting({
    required int characterId,
    required List<List<Map<String, int>>> userStrokes,
  }) async {
    final response = await dio.post(
      '/practice/evaluate-handwriting',
      data: {
        'characterId': characterId,
        'userStrokes': userStrokes,
      },
    );
    return EvaluationResultModel.fromJson(response.data as Map<String, dynamic>);
  }
}

