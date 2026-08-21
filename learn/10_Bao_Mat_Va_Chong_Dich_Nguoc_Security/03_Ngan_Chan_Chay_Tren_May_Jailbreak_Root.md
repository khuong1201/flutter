# Bài 3: Ngăn Chặn Chạy Trên Máy Đã Jailbreak / Root

Nếu máy Android đã bị Root hoặc iOS đã bị Jailbreak, hệ điều hành không còn được bảo vệ nguyên vẹn. Tin tặc có thể cài các tool hack (như GameGuardian, Frida) chọc thẳng vào RAM của máy để đổi số dư tài khoản của App bạn từ 100k thành 1 tỷ. 
Với các App Ngân hàng, Ví điện tử, App có tính năng thanh toán, bạn BẮT BUỘC phải "Đá văng" (văng app) người dùng ra nếu phát hiện máy của họ đã bị Root/Jailbreak.

## 1. Sử dụng thư viện `flutter_jailbreak_detection`
Cộng đồng Flutter cung cấp một thư viện rất tốt để dò tìm các dấu hiệu Root/Jailbreak phổ biến.

**Cài đặt:**
```yaml
dependencies:
  flutter_jailbreak_detection: ^0.1.1
```

## 2. Cách kiểm tra khi khởi động app
Tại hàm `main()` hoặc Màn hình Splash Screen đầu tiên, bạn gọi logic kiểm tra.

```dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  bool isJailBroken = false;
  
  try {
    // Trả về true nếu là máy Root/Jailbreak
    isJailBroken = await FlutterJailbreakDetection.jailbroken;
    
    // (Tuỳ chọn) Trả về true nếu app đang chạy trên Máy Ảo (Simulator/Emulator)
    // Các app ngân hàng thường không cho chạy trên máy ảo để chống tool auto cày cuốc.
    // bool isDeveloperMode = await FlutterJailbreakDetection.developerMode; 
  } on PlatformException {
    isJailBroken = true; // Lỗi gì đó thì cứ an toàn cho là máy đã hack
  }

  if (isJailBroken) {
    // Nếu bị hack, đá văng khỏi app (Crash có chủ đích)
    exit(0); 
  } else {
    // Máy sạch, cho phép chạy app bình thường
    runApp(MyApp());
  }
}
```

## 3. Các chiêu trò Lách luật (Và cách đối phó của Enterprise)
Thư viện trên chỉ quét được các tool Root "phổ thông" (như Magisk, SuperSU).
Những tin tặc chuyên nghiệp sẽ có chiêu (Magisk Hide, Zygisk) để giấu đi việc máy đã Root, đánh lừa thư viện trên.

Nếu bạn làm cho một tập đoàn lớn, họ sẽ KHÔNG tin tưởng thư viện mã nguồn mở này. Họ thường mua bản quyền các giải pháp "Bảo vệ Runtime Điện thoại" cấp doanh nghiệp trị giá hàng chục ngàn USD như:
- **DexGuard** (Bản siêu nâng cấp của ProGuard).
- **Appdome** (Tự động tiêm lớp giáp chống Root/Frida vào file APK).
- Các dịch vụ quét tính toàn vẹn của Google (Play Integrity API) và Apple (DeviceCheck).
