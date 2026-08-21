# Bài 2: Ẩn Giấu API Key và Thông Tin Nhạy Cảm

Nguyên tắc tối thượng trong lập trình bảo mật: **Tuyệt đối không gõ cứng (Hardcode) các đoạn API Key, Mật khẩu Database, Client Secret vào mã nguồn Dart.**

Ví dụ: 
```dart
// Code chết người
final String stripeApiKey = "sk_live_1234567890abcdef";
```
Bởi vì khi compile, những chuỗi String kiểu này nằm trơ trọi trong file `.so`. Tin tặc bung APK ra và dễ dàng search thấy chúng trong tích tắc. Tiền của bạn trong tài khoản Stripe/Firebase sẽ bốc hơi.

## 1. Giải pháp cơ bản: Sử dụng file `.env` (flutter_dotenv)
Lưu ý: Môi trường (Environment variables) không thực sự an toàn 100%, nhưng nó là lớp bảo mật đầu tiên tốt nhất. Nó giúp giấu Key khỏi GitHub (public repo), tránh để lộ cho cả team xem.

**Cài đặt:**
```yaml
dependencies:
  flutter_dotenv: ^5.1.0
```

**Tạo file `.env` ở thư mục gốc (ngang hàng `pubspec.yaml`):**
```text
BASE_URL=https://api.mycompany.com
STRIPE_API_KEY=sk_test_123456...
```
*(Bắt buộc: Mở file `.gitignore` và thêm dòng `.env` vào để tránh đẩy nó lên Github).*

**Khai báo assets trong pubspec:**
```yaml
flutter:
  assets:
    - .env
```

**Đọc dữ liệu trong Code:**
Ở hàm `main.dart`:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  // Lấy ra xài
  final apiKey = dotenv.env['STRIPE_API_KEY'];
  runApp(MyApp());
}
```

## 2. Giải pháp nâng cao (Dùng cho API Key cực quan trọng)
Nếu tin tặc vẫn quyết tâm bung apk, họ vẫn có thể đọc được cái file `.env` nhúng ngầm bên trong assets.

Để chặn đứng việc này:
1. **Dùng backend làm trạm trung chuyển (BFF - Backend For Frontend):**
   App Flutter của bạn KHÔNG ĐƯỢC trực tiếp gọi đến Stripe/OpenAI/Third-party. 
   App gọi lên Server của bạn -> Server của bạn giữ API Key xịn -> Server gọi sang Stripe -> Stripe trả kết quả cho Server -> Server trả về cho App.
   (Đây là cách bảo mật tuyệt đối 100%, chìa khoá nhà nằm ở server, app không giữ chìa).
   
2. **Obfuscate chuỗi String bằng C/C++ (JNI):**
   Nếu buộc phải lưu key trên app, người ta thường viết API Key vào một file ngôn ngữ C/C++, rồi gọi nó từ Dart qua FFI. Dịch ngược file nhị phân C++ tốn rất nhiều công sức và kỹ thuật cao, tin tặc sẽ nản chí. Thư viện hay dùng là `envied` kết hợp mã hoá.
