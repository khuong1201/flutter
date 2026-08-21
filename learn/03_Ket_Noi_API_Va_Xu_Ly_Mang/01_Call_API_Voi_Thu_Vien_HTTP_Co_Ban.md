# Bài 1: Gọi API Với Thư Viện HTTP Cơ Bản

Để kết nối với Server (Backend), cách đơn giản nhất trong Flutter là sử dụng thư viện `http` do chính Google phát triển. Nó rất nhẹ và đủ dùng cho các tác vụ lấy dữ liệu (GET, POST, PUT, DELETE) cơ bản.

## 1. Cài đặt
Thêm vào file `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
```

## 2. Cách thực hiện một GET Request
Ví dụ: Lấy danh sách Users từ một API công khai (jsonplaceholder).

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> fetchUsers() async {
  // 1. Định nghĩa URL
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');

  try {
    // 2. Gọi API và chờ kết quả
    final response = await http.get(url);

    // 3. Kiểm tra mã trạng thái (StatusCode)
    if (response.statusCode == 200) {
      // 200 OK: Thành công
      // 4. Giải mã chuỗi JSON thành List/Map của Dart
      final List<dynamic> data = jsonDecode(response.body);
      
      print('Thành công! Số lượng user: ${data.length}');
      print('User đầu tiên: ${data[0]['name']}');
    } else {
      // Các mã lỗi 400 (Bad Request), 401 (Unauthorized), 404 (Not Found), 500 (Server Error)
      print('Lỗi từ Server: ${response.statusCode}');
    }
  } catch (e) {
    // Bắt lỗi mất mạng hoặc sai định dạng URL
    print('Lỗi kết nối mạng: $e');
  }
}
```

## 3. Cách thực hiện một POST Request (Gửi dữ liệu lên Server)
Khi Đăng ký, Đăng nhập hoặc Tạo bài viết mới, bạn sẽ dùng POST và gửi kèm Dữ liệu (Body).

```dart
Future<void> createUser() async {
  final url = Uri.parse('https://jsonplaceholder.typicode.com/users');
  
  try {
    final response = await http.post(
      url,
      // KHÔNG QUÊN HEADER này nếu server yêu cầu JSON
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer YOUR_TOKEN_HERE', // Nếu API cần token
      },
      // Phải biến Object/Map thành chuỗi JSON trước khi gửi đi
      body: jsonEncode({
        'name': 'Nguyễn Văn A',
        'email': 'a@gmail.com',
      }),
    );

    if (response.statusCode == 201) {
      print('Tạo thành công: ${response.body}');
    } else {
      print('Thất bại: ${response.body}');
    }
  } catch (e) {
    print('Lỗi: $e');
  }
}
```

## 4. Nhược điểm của thư viện HTTP
Mặc dù dễ dùng, nhưng khi dự án lớn, thư viện `http` bộc lộ điểm yếu:
- Không có cấu hình Base URL (phải gõ đi gõ lại đoạn đầu URL).
- Không tự động parse JSON (phải tự gọi `jsonDecode`).
- Không có Interceptor (để tự động chèn Token vào mọi request).
- Không có tính năng tự động Refresh Token tự động, tự động thử lại khi rớt mạng...

Đó là lý do chúng ta phải học `Dio` trong bài tiếp theo.
