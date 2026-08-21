# Bài 2: Gọi API Với Dio và Interceptors Nâng Cao

Trong các dự án thực tế, **Dio** là thư viện phổ biến số 1 để gọi API. Nó khắc phục mọi nhược điểm của thư viện `http` bằng các tính năng cực kỳ mạnh mẽ như: Interceptors (đánh chặn gói tin), Global configuration (Cấu hình dùng chung), FormData (Upload file), Download file.

## 1. Cài đặt
```yaml
dependencies:
  dio: ^5.3.3
```

## 2. Cấu hình Dio cơ bản (BaseOptions)
Thay vì tạo request thủ công từng lần, ta khởi tạo một file `api_client.dart` dùng chung cho toàn bộ app.

```dart
import 'package:dio/dio.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    // Cấu hình chung cho mọi request
    dio = Dio(BaseOptions(
      baseUrl: 'https://api.yourdomain.com/v1/',
      connectTimeout: const Duration(seconds: 10), // Giới hạn thời gian kết nối
      receiveTimeout: const Duration(seconds: 10), // Giới hạn thời gian nhận dữ liệu
      headers: {
        'Content-Type': 'application/json',
      },
    ));
  }
}
```

## 3. Cách gọi API với Dio (Cực ngắn gọn)
Dio tự động decode JSON cho bạn. Bạn không cần phải gọi `jsonDecode()` nữa.

```dart
Future<void> login(String email, String password) async {
  try {
    // Chỉ cần truyền đường dẫn con (vì đã có baseUrl)
    Response response = await dio.post('auth/login', data: {
      'email': email,
      'password': password,
    });
    
    // response.data đã là một Map/List sẵn sàng sử dụng
    print(response.data['token']); 
    
  } on DioException catch (e) {
    // Dio phân loại lỗi rất rõ ràng
    if (e.response != null) {
      print('Lỗi từ Server (Sai mật khẩu, vv): ${e.response?.data}');
    } else {
      print('Lỗi Mạng (Mất kết nối, timeout): ${e.message}');
    }
  }
}
```

## 4. Sức mạnh thực sự: Interceptors (Người đánh chặn)
Interceptors cho phép bạn "bắt" các request **TRƯỚC KHI** nó bay lên server, hoặc bắt các response **TRƯỚC KHI** UI nhận được. 

**Tác dụng tuyệt vời nhất:** Tự động chèn Bearer Token vào mọi Request mà không cần viết đi viết lại.

```dart
ApiClient() {
  dio = Dio(BaseOptions(baseUrl: '...'));

  // Thêm Interceptor
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) async {
        // TRƯỚC KHI gửi Request:
        // Lấy Token từ Local Storage (sẽ học ở Chương 4)
        String? token = await LocalStorage.getToken(); 
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        print('Đang gọi API: ${options.uri}');
        return handler.next(options); // Bắt buộc gọi để request bay đi
      },
      onResponse: (response, handler) {
        // SAU KHI nhận kết quả thành công:
        print('Nhận kết quả: ${response.statusCode}');
        return handler.next(response); 
      },
      onError: (DioException e, handler) async {
        // SAU KHI gặp lỗi:
        // Ví dụ: Bắt lỗi 401 (Hết hạn Token) để cấp lại (Refresh Token)
        if (e.response?.statusCode == 401) {
           print('Token hết hạn! Tiến hành lấy lại token mới...');
           // Code tự động refresh token ở đây...
        }
        return handler.next(e);
      },
    ),
  );
}
```

Nhờ cấu hình này, bất cứ chỗ nào bạn gọi `dio.get(...)`, token sẽ tự động được thêm vào header. Code UI của bạn sạch sẽ 100%!
