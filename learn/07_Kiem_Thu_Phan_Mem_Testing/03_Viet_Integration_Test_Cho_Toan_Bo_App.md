# Bài 3: Viết Integration Test (Kiểm Thử Tích Hợp)

Integration Test là bài test mô phỏng y chang thao tác của người dùng thật: Mở app, Đăng nhập, Chọn hàng, Bấm nút Mua, Xem giỏ hàng. 
Khác với Widget Test (chỉ test 1 màn hình nhỏ trong môi trường ảo), **Integration Test sẽ chạy thực sự trên thiết bị vật lý hoặc Máy ảo (Simulator/Emulator)** và tương tác với Database/API thực hoặc môi trường Staging.

## 1. Cài đặt
Thư viện `integration_test` đã được tích hợp sẵn vào Flutter SDK mới.
Cập nhật `pubspec.yaml`:
```yaml
dev_dependencies:
  integration_test:
    sdk: flutter
  flutter_test:
    sdk: flutter
```

## 2. Khởi tạo thư mục Integration
Khác với thư mục `test`, bạn phải tạo riêng thư mục tên là `integration_test` ngang hàng với `lib`.
Tạo file: `integration_test/app_test.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:my_app/main.dart' as app;

void main() {
  // Lệnh bắt buộc để bật tính năng test tích hợp
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Kịch bản mua hàng từ đầu đến cuối', () {
    testWidgets('Kiểm tra flow đăng nhập và cuộn trang', (tester) async {
      // 1. Chạy app (Khởi động app thực tế)
      app.main();
      
      // Chờ cho đến khi app load xong tất cả frame
      await tester.pumpAndSettle();

      // 2. Kịch bản Đăng nhập
      // Tìm ô email (Bạn nhớ gắn Key('email_field') trong mã nguồn)
      final emailField = find.byKey(Key('email_field'));
      final passwordField = find.byKey(Key('password_field'));
      final loginButton = find.byKey(Key('login_button'));

      // Gõ chữ vào ô
      await tester.enterText(emailField, 'test@gmail.com');
      await tester.enterText(passwordField, '123456');
      await tester.pumpAndSettle(); // Chờ gõ chữ mượt mà xong

      // Bấm đăng nhập
      await tester.tap(loginButton);
      
      // Đợi nó quay loading call API và chuyển sang trang Home
      await tester.pumpAndSettle();

      // 3. Kiểm tra kết quả
      // Trang Home có chứa chữ "Sản phẩm nổi bật"
      expect(find.text('Sản phẩm nổi bật'), findsOneWidget);
    });
  });
}
```

## 3. Cách chạy Integration Test
Bắt buộc phải bật Emulator/Simulator lên, hoặc cắm dây cáp nối điện thoại thật vào máy tính.

Chạy lệnh trên terminal:
```bash
flutter test integration_test/app_test.dart
```

Lúc này, bạn không cần cầm điện thoại, hãy để tay lên đùi và nhìn màn hình. Máy tính sẽ tự động điều khiển điện thoại (như ma làm), tự gõ phím, tự bấm nút login, tự chuyển trang rồi kết luận Test PASS hay FAIL.

## 4. Ứng dụng tích hợp CI/CD
Kịch bản Integration Test hay được dùng nhiều nhất khi thiết lập CI/CD (Firebase Test Lab).
Bạn cài đặt tự động: Cứ mỗi đêm lúc 12h, máy chủ sẽ tự tải app mới nhất của bạn xuống, khởi động 20 loại điện thoại Android/iOS khác nhau (cả xịn cả dỏm), rồi chạy bộ Integration Test. Nếu không có máy nào bị Crash, sáng hôm sau team an tâm đẩy App lên Store (Release).
