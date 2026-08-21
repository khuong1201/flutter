# Bài 3: Điều Hướng Thông Minh Với AutoRoute

AutoRoute là một đối thủ đáng gờm của GoRouter. Khác với GoRouter (chạy bằng chuỗi URL), **AutoRoute sử dụng Code Generation** để sinh ra các hàm chuyển trang Type-Safe (an toàn kiểu dữ liệu).

Nếu truyền tham số thiếu, hoặc gõ sai tên trang, **app sẽ báo lỗi đỏ gạch chân ngay lúc gõ code** (Compile time) chứ không đợi chạy app lên mới Crash như GoRouter.

## 1. Cài đặt
```yaml
dependencies:
  auto_route: ^7.8.4

dev_dependencies:
  build_runner: ^2.4.9
  auto_route_generator: ^7.3.2
```

## 2. Gắn Annotation (Đánh dấu màn hình)
Điểm đặc biệt của AutoRoute là bạn vào từng file giao diện (Screen) và đánh dấu nó bằng từ khóa `@RoutePage()`.

```dart
import 'package:auto_route/auto_route.dart';

@RoutePage() // Bắt buộc thêm dòng này
class UserDetailScreen extends StatelessWidget {
  final int userId;
  final String userName;

  // AutoRoute sẽ tự đọc các biến này để bắt bạn phải truyền đúng lúc chuyển trang
  const UserDetailScreen({
    Key? key, 
    required this.userId, 
    required this.userName
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(userName)),
    );
  }
}
```

## 3. Tạo file Cấu hình Router
Tạo file `app_router.dart`:

```dart
import 'package:auto_route/auto_route.dart';
// Import file sinh ra tự động
part 'app_router.gr.dart'; 

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
    // Định nghĩa danh sách các trang
    AutoRoute(page: HomeRoute.page, initial: true), // Trang chủ
    AutoRoute(page: UserDetailRoute.page), // Trang chi tiết (sinh ra từ tên UserDetailScreen)
  ];
}
```

Mở terminal chạy lệnh:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## 4. Sử dụng AutoRoute trên UI
Thiết lập ở `main.dart`:
```dart
final _appRouter = AppRouter();

void main() {
  runApp(MaterialApp.router(
    routerConfig: _appRouter.config(),
  ));
}
```

Cách chuyển trang an toàn tuyệt đối:
```dart
// Nếu bạn quên truyền userId, VS Code sẽ gạch đít đỏ báo lỗi ngay.
// Không bao giờ có chuyện gõ sai chính tả tên Route.
context.router.push(UserDetailRoute(userId: 1, userName: "Nguyễn Văn A"));

// Quay lại
context.router.pop();
```

> **Tổng kết:**
> - Làm App Web -> Chọn **GoRouter** (Vì xử lý URL cực tốt).
> - Làm App Mobile ưu tiên sự an toàn, lười gõ tên Router thủ công -> Chọn **AutoRoute**.
