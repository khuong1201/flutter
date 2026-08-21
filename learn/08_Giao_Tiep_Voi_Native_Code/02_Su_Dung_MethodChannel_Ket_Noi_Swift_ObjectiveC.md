# Bài 2: Giao Tiếp Với Native Code (Swift/Objective-C trên iOS)

Tương tự như Android, nếu bạn cần tương tác sâu vào phần cứng của iPhone/iPad (Ví dụ: Đọc cảm biến nhịp tim trên Apple Watch, giao tiếp với các thư viện đóng gói dạng `.framework` của các ngân hàng), bạn phải mở Xcode lên và viết Swift.

## 1. Lưu ý quan trọng trước khi code iOS Native
- Bắt buộc phải có máy tính MacOS. (Bạn không thể code và chạy thử code Swift trên Windows).
- Cấu trúc MethodChannel hoàn toàn giống với Android. Chỉ khác là ở tầng dưới (Native), ta dùng ngôn ngữ Swift thay vì Kotlin.

## 2. Thực hành: Lấy phần trăm Pin (Battery) của iOS

Phần code giao diện Dart trong Flutter hoàn toàn KHÔNG THAY ĐỔI (Bạn có thể dùng nguyên lại file `BatteryScreen` ở Bài 1). Tên kênh vẫn là `com.myapp/battery` và tên hàm vẫn là `getBatteryLevel`.

**Viết code ở phía iOS (Swift):**
Bật máy Mac lên, mở file `ios/Runner.xcworkspace` bằng phần mềm **Xcode**.
Tìm file `AppDelegate.swift` và sửa lại như sau:

```swift
import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    
    // 1. Lấy root view controller của Flutter
    let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
    
    // 2. Khởi tạo Kênh giao tiếp (Phải khớp tên với Dart)
    let batteryChannel = FlutterMethodChannel(name: "com.myapp/battery",
                                              binaryMessenger: controller.binaryMessenger)
    
    // 3. Lắng nghe tín hiệu gọi từ Dart
    batteryChannel.setMethodCallHandler({
      (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
      
      // Bắt tên hàm
      if call.method == "getBatteryLevel" {
        self.receiveBatteryLevel(result: result)
      } else {
        result(FlutterMethodNotImplemented)
      }
    })

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // Logic Swift thuần tuý lấy phần trăm pin iPhone
  private func receiveBatteryLevel(result: FlutterResult) {
    let device = UIDevice.current
    device.isBatteryMonitoringEnabled = true
    
    if device.batteryState == UIDevice.BatteryState.unknown {
      // Trả lỗi về cho Flutter
      result(FlutterError(code: "UNAVAILABLE",
                        message: "Battery info unavailable",
                        details: nil))
    } else {
      // Trả số nguyên (Int) về cho Flutter
      result(Int(device.batteryLevel * 100))
    }
  }
}
```

## 3. EventChannel - Lắng nghe liên tục (Stream)
MethodChannel là dạng "Hỏi - Trả lời 1 lần" (Giống HTTP GET).
Nhưng nếu bạn muốn iOS/Android gửi liên tục tọa độ GPS cứ mỗi 1 giây về cho Flutter, thì MethodChannel không đáp ứng được. Lúc này bạn phải tìm hiểu **EventChannel** (Học cách đẩy dữ liệu qua cầu theo dạng Stream).
