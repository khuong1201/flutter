# Bài 1: Cấu Hình Flavors Cho Dev, Staging, Prod

Trong dự án thực tế, bạn không bao giờ dùng chung 1 cái App duy nhất cho cả lúc code (gọi API nội bộ - localhost) và lúc giao cho khách hàng (gọi API thật). 
Nếu lỡ tay xóa nhầm Database lúc đang test thì công ty sẽ phá sản!

Bạn phải chia app ra thành 3 môi trường (Environments) - hay trong Flutter gọi là **Flavors**:
1. **Development (Dev)**: Môi trường cho coder vọc vạch. Gọi API server test, hiện các nút ẩn để dễ debug. Biểu tượng app thường có chữ [DEV].
2. **Staging (Stg)**: Bản build nội bộ gửi cho Tester (QA) và Khách hàng test nghiệm thu trước khi tung ra thị trường. Database giống thật 90%.
3. **Production (Prod)**: Bản chạy thật (Live) tải từ App Store. Dữ liệu thật, tiền thật. Cấm tuyệt đối đụng vào.

## 1. Thiết lập Flavor trên Dart (Cách hiện đại với `--dart-define-from-file`)
Từ phiên bản Flutter 3.17 trở lên, thay vì phải gõ cấu hình file Gradle hay Xcode vô cùng phức tạp, và gõ từng cờ `--dart-define` rất dài dòng, bạn có thể truyền thẳng một file JSON cấu hình vào lúc build.

Ví dụ tạo file `env_dev.json`:
```json
{
  "ENV": "dev",
  "BASE_URL": "https://dev.api.com"
}
```

Chạy lệnh trên terminal:
```bash
# Khi đang code (Môi trường Dev)
flutter run --dart-define-from-file=env_dev.json

# Khi build thật ra App Store (Môi trường Prod)
flutter build apk --dart-define-from-file=env_prod.json
```

## 2. Lấy biến ra xài trong Code
Code của bạn sẽ tự động biết nó đang chạy ở môi trường nào.

```dart
// Lấy giá trị biến ENV, nếu không truyền vào thì mặc định là 'dev'
const String environment = String.fromEnvironment('ENV', defaultValue: 'dev');
const String baseUrl = String.fromEnvironment('BASE_URL', defaultValue: 'http://localhost');

void main() {
  if (environment == 'prod') {
    print('Chạy thật. Tắt các nút Debug đi.');
  } else {
    print('Chạy Test. Gọi API: $baseUrl');
  }
}
```

## 3. Cấu hình trên VS Code để khỏi phải gõ lệnh dài dòng
Tạo file `.vscode/launch.json` để mỗi lần bấm nút Play/Run là nó tự nhét cờ vào.

```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Flutter Dev",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": [
                "--dart-define-from-file",
                "env_dev.json"
            ]
        },
        {
            "name": "Flutter Prod",
            "request": "launch",
            "type": "dart",
            "program": "lib/main.dart",
            "args": [
                "--dart-define-from-file",
                "env_prod.json"
            ]
        }
    ]
}
```
Lúc này ở tab Run & Debug của VS Code, bạn có thể chọn thả xuống: Chạy bản Dev hay Chạy bản Prod rất tiện.

*(Nếu bạn muốn bản Dev và Prod phải cài được thành 2 App song song trên cùng 1 cái điện thoại, bạn bắt buộc phải dùng kỹ thuật thay đổi `applicationId` (Android) và `Bundle ID` (iOS) bằng thư viện `flutter_flavorizr`).*
