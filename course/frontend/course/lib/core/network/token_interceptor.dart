import 'package:course/core/local_storage/secure_storage_helper.dart';
import 'package:dio/dio.dart';

class TokenInterceptor extends Interceptor {
  final SecureStorageHelper secureStorage;

  TokenInterceptor(this.secureStorage);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final token = await secureStorage.getToken();
    
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    
    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // [Nâng cao] Xử lý lỗi 401 Unauthorized
    // Nếu server trả về 401 (Token hết hạn), ta có thể bắt sự kiện ở đây 
    // để đá người dùng văng ra màn hình Đăng nhập.
    if (err.response?.statusCode == 401) {
      // TODO: Kích hoạt luồng Đăng xuất (Logout Event)
    }
    
    super.onError(err, handler);
  }
}