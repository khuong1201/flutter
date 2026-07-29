import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';

class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    // 1. Xin quyền hiển thị thông báo (Bắt buộc với iOS, Android 13+)
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Người dùng đã cấp quyền nhận thông báo');
    }

    // 2. Lấy FCM Token (Điểm ăn tiền)
    // Trong thực tế, bạn sẽ lưu token này lên Firestore gắn với UserID
    // Để server biết chính xác cần gửi thông báo đến cái điện thoại nào.
    String? token = await _messaging.getToken();
    print('FCM Token của thiết bị này: $token');

    // 3. Xử lý thông báo khi App ĐANG MỞ (Foreground)
    // Mặc định FCM không hiện popup nếu app đang mở, bạn phải tự lắng nghe và xử lý.
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Nhận tin nhắn khi app đang mở: ${message.notification?.title}');
      // Ở đây bạn có thể dùng flutter_local_notifications để hiện popup nhỏ
      // Hoặc đơn giản là gọi hàm hiển thị một cái SnackBar báo có tin nhắn mới.
    });

    // 4. Xử lý khi người dùng BẤM VÀO THÔNG BÁO từ Background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Người dùng bấm vào thông báo: ${message.notification?.title}');
      // Code điều hướng (Navigator) vào đúng phòng chat tương ứng
    });
  }
}