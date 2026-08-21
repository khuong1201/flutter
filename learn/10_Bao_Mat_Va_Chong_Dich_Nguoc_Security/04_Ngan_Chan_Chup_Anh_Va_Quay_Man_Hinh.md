# Bài 4: Ngăn Chặn Chụp Ảnh Và Quay Màn Hình

Có những ứng dụng chứa nội dung bản quyền (phim ảnh như Netflix) hoặc chứa thông tin cực kỳ nhạy cảm (Mã OTP, Thẻ tín dụng, Mã QR thanh toán). 
Bạn không muốn người dùng bấm nút chụp ảnh màn hình (Screenshot) hoặc bật tính năng Quay màn hình (Screen Record), nếu không sẽ bị rò rỉ dữ liệu (hoặc bị virus đánh cắp).

## 1. Cách chặn trên Android (Dễ dàng và chặn được cả Quay màn hình)
Trên Android, hệ điều hành cấp sẵn một cờ (Flag) gọi là `FLAG_SECURE`. Khi cờ này được bật, toàn bộ app của bạn sẽ bị hiển thị thành một màn hình đen thui nếu ai đó cố gắng chụp hoặc quay phim nó.

Thư viện: `flutter_windowmanager`

**Cài đặt:**
```yaml
dependencies:
  flutter_windowmanager: ^0.2.0
```

**Sử dụng (Thường gọi ở `main.dart`):**
```dart
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Bật cờ bảo vệ màn hình (Chỉ hoạt động trên Android)
  await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  
  runApp(MyApp());
}
```
*Bạn có thể test bằng cách chạy trên điện thoại thật, bấm phím Nguồn + Giảm âm lượng để chụp ảnh, máy sẽ báo "Không thể chụp màn hình do chính sách bảo mật".*

## 2. Cách chặn trên iOS (Chỉ là "chữa cháy")
Tin buồn: Apple **KHÔNG CHO PHÉP** lập trình viên chặn việc chụp ảnh màn hình. (Ngoại trừ hệ thống phát phim FairPlay DRM của chính Apple).
Bạn không thể ngăn người dùng iPhone bấm nút chụp. Tuy nhiên, iOS cho phép bạn **lắng nghe sự kiện** "Người dùng vừa chụp ảnh xong" (Notification `userDidTakeScreenshotNotification`).

Với việc quay màn hình (Screen Record), iOS cung cấp thuộc tính `UIScreen.main.isCaptured`.

Thư viện hỗ trợ: `screen_protector` (Dùng chung cho cả iOS và Android).

**Cài đặt:**
```yaml
dependencies:
  screen_protector: ^1.1.2
```

**Sử dụng trên iOS:**
Vì ta không cản được người dùng chụp ảnh, ta chỉ có thể cản bằng cách: **Khi app bị đẩy xuống nền (người dùng đang vuốt đa nhiệm) -> Xóa mờ màn hình**. Hoặc khi họ bật ghi màn hình -> **Che nội dung lại**.

```dart
import 'package:screen_protector/screen_protector.dart';

class SecureScreen extends StatefulWidget {
  @override
  _SecureScreenState createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
  @override
  void initState() {
    super.initState();
    // Bật lớp khiên bảo vệ đa nhiệm (App sẽ trắng bóc khi vuốt thẻ app)
    ScreenProtector.protectDataLeakageWithBlur();
    
    // Lắng nghe khi có người nhấn nút quay màn hình (Trên iOS)
    ScreenProtector.addListener(() {
        print("CẢNH BÁO: ĐANG BỊ QUAY MÀN HÌNH!");
        // Bạn có thể show một Widget màu đen đè lên toàn màn hình
    }, (isCaptured) {
        print("Tắt chế độ quay màn hình");
    });
  }

  @override
  void dispose() {
    // Tắt bảo vệ
    ScreenProtector.removeListener();
    super.dispose();
  }
}
```
