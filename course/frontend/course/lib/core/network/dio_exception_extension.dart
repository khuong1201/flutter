import 'package:dio/dio.dart';

extension DioExceptionExtension on DioException {
  String? get apiCode {
    final data = response?.data;
    if (data != null && data is Map<String, dynamic>) {
      return data['code'];
    }
    return null;
  }
  
  List<String>? get apiMessage {
    final data = response?.data;
    if (data != null && data is Map<String, dynamic>) {
      final msg = data['message'];
      if (msg is List) {
        return msg.map((e) => e.toString()).toList();
      } else if (msg != null) {
        return [msg.toString()];
      }
    }
    return null;
  }
}
