# Bài 1: Giao Tiếp Với Native Code (Java/Kotlin trên Android)

Mặc dù Flutter có hàng chục ngàn thư viện (packages) trên `pub.dev`, nhưng đôi khi bạn phải làm việc với một thiết bị phần cứng đặc thù (máy in hóa đơn Bluetooth, máy quẹt thẻ POS) mà nhà sản xuất chỉ cung cấp SDK bằng Java/Kotlin cho Android.

Lúc này, bạn bắt buộc phải viết code Native trên Android và dùng **MethodChannel** để làm cái "cầu nối" gọi code đó từ Flutter.

## 1. Cơ chế hoạt động của MethodChannel
Flutter (Dart) và Native (Android/iOS) là hai thế giới cách biệt. 
- Flutter gửi một cái "tên hàm" và "tham số" qua cầu (MethodChannel).
- Native nghe thấy, bèn chạy code Java/Kotlin tương ứng.
- Chạy xong, Native ném kết quả trả ngược về lại cầu. Flutter nhận được (dưới dạng Future).

## 2. Thực hành: Lấy phần trăm Pin (Battery) của Android

**Bước 1: Viết code ở phía Flutter (Dart)**
Tạo một kênh giao tiếp có tên (ví dụ: `com.myapp/battery`).

```dart
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BatteryScreen extends StatefulWidget {
  @override
  _BatteryScreenState createState() => _BatteryScreenState();
}

class _BatteryScreenState extends State<BatteryScreen> {
  // 1. Tạo kênh giao tiếp (Tên kênh phải duy nhất)
  static const platform = MethodChannel('com.myapp/battery');
  
  String _batteryLevel = 'Chưa biết mức pin.';

  Future<void> _getBatteryLevel() async {
    String batteryLevel;
    try {
      // 2. Gửi yêu cầu gọi hàm tên là 'getBatteryLevel' sang Native
      final int result = await platform.invokeMethod('getBatteryLevel');
      batteryLevel = 'Mức pin hiện tại là $result % .';
    } on PlatformException catch (e) {
      batteryLevel = "Không lấy được pin: '${e.message}'.";
    }

    setState(() {
      _batteryLevel = batteryLevel;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_batteryLevel),
            ElevatedButton(
              onPressed: _getBatteryLevel,
              child: const Text('Lấy Pin Android'),
            ),
          ],
        ),
      ),
    );
  }
}
```

**Bước 2: Viết code ở phía Android (Kotlin)**
Mở thư mục `android/app/src/main/kotlin/.../MainActivity.kt`.

```kotlin
package com.example.my_app

import android.os.BatteryManager
import android.content.Context.BATTERY_SERVICE
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    // Phải khớp y hệt tên kênh đã khai báo bên Dart
    private val CHANNEL = "com.myapp/battery"

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Tạo người lắng nghe (Listener) trên kênh này
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
            call, result ->
            // Bắt được tên hàm truyền từ Dart sang
            if (call.method == "getBatteryLevel") {
                val batteryLevel = getBatteryLevel()

                if (batteryLevel != -1) {
                    // Trả kết quả thành công về lại Dart
                    result.success(batteryLevel) 
                } else {
                    // Trả lỗi về Dart
                    result.error("UNAVAILABLE", "Không lấy được pin.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    // Viết logic Kotlin thuần túy
    private fun getBatteryLevel(): Int {
        val batteryManager = getSystemService(BATTERY_SERVICE) as BatteryManager
        return batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY)
    }
}
```

Chạy thử trên máy ảo Android (hoặc điện thoại Android thật), bạn sẽ thấy Flutter gọi được thành công code Kotlin!
