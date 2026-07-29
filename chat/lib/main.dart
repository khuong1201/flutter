import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart'; // Import FCM
import 'services/auth_service.dart';
import 'services/notification_service.dart'; // Import Notification Service
import 'screens/login_screen.dart';
import 'screens/chat_screen.dart';

// ĐIỂM ĂN TIỀN: Hàm này phải độc lập, nằm ngoài class và có @pragma
// Nhiệm vụ: Đánh thức app dậy để nhận cục data Firebase gửi xuống dù app đã tắt.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // Bắt buộc phải khởi tạo lại Firebase trong luồng nền
  print("Đã nhận thông báo ngầm: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Đăng ký luồng chạy ngầm cho FCM
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // Kích hoạt dịch vụ thông báo ngay khi app vừa mở lên
    NotificationService().initNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mini Workspace',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: StreamBuilder<User?>(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const ChatScreen();
          }
          return const LoginScreen();
        },
      ),
    );
  }
}