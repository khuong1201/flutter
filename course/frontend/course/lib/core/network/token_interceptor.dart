import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:course/core/network/dio_exception_extension.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorageHelper secureStorage;
  final void Function() onUnauthorized;
  final String baseUrl;
  final Dio _refreshDio;

  bool _isRefreshing = false;
  final List<Map<String, dynamic>> _failedRequestsQueue = [];

  TokenInterceptor(
    this.secureStorage, {
    required this.onUnauthorized,
    required this.baseUrl,
  }) : _refreshDio = Dio(BaseOptions(
          baseUrl: baseUrl,
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
          headers: const {'Content-Type': 'application/json'},
        ));

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
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final code = err.apiCode;
      // Nếu API trả về TOKEN_EXPIRED hoặc 401 thông thường, ta thử refresh
      if (code == 'TOKEN_EXPIRED' || code == 'UNAUTHORIZED' || code == null) {
        
        final refreshToken = await secureStorage.getRefreshToken();
        if (refreshToken == null || refreshToken.isEmpty) {
          onUnauthorized();
          return handler.next(err);
        }

        if (_isRefreshing) {
          // Thêm vào queue chờ refresh xong
          _failedRequestsQueue.add({'err': err, 'handler': handler});
          return;
        }

        _isRefreshing = true;

        try {
          // Gọi API refresh token (dùng _refreshDio để không bị lặp qua interceptor này)
          final response = await _refreshDio.post(
            '/auth/refresh-token',
            data: {'refreshToken': refreshToken},
          );

          if (response.statusCode == 200 || response.statusCode == 201) {
            final newAccessToken = response.data['accessToken'];
            final newRefreshToken = response.data['refreshToken'];

            if (newAccessToken != null && newRefreshToken != null) {
              await secureStorage.saveToken(newAccessToken);
              await secureStorage.saveRefreshToken(newRefreshToken);

              // Retry request hiện tại
              err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
              final retryCurrent = await _refreshDio.fetch(err.requestOptions);
              handler.resolve(retryCurrent);

              // Retry các request trong queue
              for (var req in _failedRequestsQueue) {
                final reqErr = req['err'] as DioException;
                final reqHandler = req['handler'] as ErrorInterceptorHandler;
                reqErr.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
                final retryReq = await _refreshDio.fetch(reqErr.requestOptions);
                reqHandler.resolve(retryReq);
              }
              _failedRequestsQueue.clear();
              _isRefreshing = false;
              return;
            }
          }
        } catch (e) {
          // Refresh thất bại (Refresh token cũng hết hạn)
          _failedRequestsQueue.clear();
          _isRefreshing = false;
          onUnauthorized();
          return handler.next(err);
        }

        _isRefreshing = false;
        onUnauthorized();
        return handler.next(err);

      } else if (code == 'TOKEN_INVALID') {
        onUnauthorized();
        return handler.next(err);
      }
    }

    handler.next(err);
  }
}