import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorageHelper secureStorage;
  final void Function() onUnauthorized;

  TokenInterceptor(
    this.secureStorage, {
    required this.onUnauthorized,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await secureStorage.getToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      final data = err.response?.data;
      if (data != null && data is Map<String, dynamic>) {
        final code = data['code'];
        if (code == 'TOKEN_EXPIRED' || code == 'TOKEN_INVALID') {
          onUnauthorized();
        }
      }
    }

    handler.next(err);
  }
}