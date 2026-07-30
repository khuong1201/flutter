import 'package:flutter/services.dart';

class HardwareService {
  // Tên channel phải KHỚP TUYỆT ĐỐI với bên Kotlin
  static const MethodChannel _channel = MethodChannel('com.hippo.hardware/advanced');

  // Lấy tên thiết bị
  Future<String> getDeviceModel() async {
    try {
      final String model = await _channel.invokeMethod('getDeviceModel');
      return model;
    } catch (e) {
      return 'Không xác định';
    }
  }

  // Bật/tắt đèn Flash
  Future<bool> toggleFlashlight(bool turnOn) async {
    try {
      await _channel.invokeMethod('toggleFlashlight', {'isOn': turnOn});
      return true;
    } catch (e) {
      print("Lỗi đèn Flash: $e");
      return false;
    }
  }

  // Kiểm tra trạng thái Wifi
  Future<bool> checkWifiStatus() async {
    try {
      final bool isWifiOn = await _channel.invokeMethod('checkWifiStatus');
      return isWifiOn;
    } catch (e) {
      return false;
    }
  }
}