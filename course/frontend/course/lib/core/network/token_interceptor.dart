import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/core/network/dio_exception_extension.dart';
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
      final code = err.apiCode;
      if (code == 'TOKEN_EXPIRED' || code == 'TOKEN_INVALID' || code == 'UNAUTHORIZED') {
        onUnauthorized();
      }
    }

    handler.next(err);
  }
}