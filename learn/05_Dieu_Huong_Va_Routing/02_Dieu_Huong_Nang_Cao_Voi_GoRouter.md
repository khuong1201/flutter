# Bài 2: Điều Hướng Nâng Cao Với GoRouter

GoRouter là thư viện được chính Google bảo trợ để thay thế Navigator 1.0. Nó sinh ra để giải quyết bài toán phức tạp của Navigator 2.0. GoRouter dựa trên định dạng **URL (Đường dẫn)** giống hệt như làm Web.

## 1. Cài đặt
```yaml
dependencies:
  go_router: ^12.1.1
```

## 2. Cấu hình Router (Khai báo tập trung)
Thay vì chuyển trang ở đâu thì gọi `MaterialPageRoute` ở đó, GoRouter bắt buộc bạn phải khai báo **toàn bộ màn hình** ở một nơi duy nhất. Thường đặt trong `app_router.dart`.

```dart
import 'package:go_router/go_router.dart';

final GoRouter router = GoRouter(
  initialLocation: '/', // Trang đầu tiên khi mở app
  routes: [
    GoRoute(
      path: '/', // URL: /
      name: 'home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      // URL: /product/42
      // Chữ :id là tham số động (Path parameter)
      path: '/product/:id', 
      name: 'product_detail',
      builder: (context, state) {
        // Lấy tham số id từ URL
        final productId = state.pathParameters['id']!;
        return ProductDetailScreen(id: int.parse(productId));
      },
    ),
  ],
  // Điều hướng nếu URL không tồn tại (Lỗi 404)
  errorBuilder: (context, state) => const NotFoundScreen(),
);
```

## 3. Tích hợp vào MaterialApp
Bạn phải đổi `MaterialApp` thành `MaterialApp.router`:

```dart
void main() {
  runApp(
    MaterialApp.router(
      routerConfig: router, // Truyền router vào đây
      title: 'GoRouter App',
    ),
  );
}
```

## 4. Cách chuyển trang với GoRouter

**Cách 1: Chuyển bằng Path (URL)**
```dart
// Nhảy đến trang chi tiết sản phẩm 42
context.go('/product/42'); 
```

**Cách 2: Chuyển bằng Name (An toàn hơn)**
Nếu sau này bạn đổi cấu trúc thư mục `/product` thành `/item`, bạn chỉ cần đổi ở cục cấu hình `GoRouter`, còn mã nguồn dùng tên (name) sẽ không bị lỗi.
```dart
context.goNamed(
  'product_detail', 
  pathParameters: {'id': '42'},
);
```

## 5. go() vs push()
- `context.go('/B')`: Nhảy thẳng tới B. Lịch sử bị thay thế. (Giống gõ URL mới trên trình duyệt web).
- `context.push('/B')`: Mở B đè lên màn hình hiện tại (Giữ lịch sử để bấm nút Back quay lại).

## 6. Điểm mạnh lớn nhất: Redirect (Chuyển hướng tự động)
GoRouter cho phép bạn viết logic kiểm tra Đăng nhập ở một chỗ duy nhất. Nếu user chưa Đăng nhập mà cố tình gõ URL vào trang Cá nhân, nó sẽ đá về trang Đăng nhập.

```dart
final GoRouter router = GoRouter(
  redirect: (context, state) {
    final bool loggedIn = checkUserLoggedIn(); // Tự viết hàm này
    final bool isLoginRoute = state.matchedLocation == '/login';

    if (!loggedIn && !isLoginRoute) {
       // Nếu chưa log in mà đòi vào trang khác -> Đá về login
       return '/login';
    }
    return null; // Không can thiệp, cho đi tiếp
  },
  //...
);
```

## 7. [Kiến thức mới] GoRouter 7+ và StatefulShellRoute
Trong các phiên bản GoRouter mới, tính năng **StatefulShellRoute** là một "vũ khí tối thượng" để làm Bottom Navigation Bar.
Thay vì mỗi lần chuyển tab ở dưới đáy màn hình bị load lại từ đầu, `StatefulShellRoute` giúp **giữ nguyên trạng thái (State) của từng Tab**. Khi bạn lướt danh sách ở Tab 1, nhảy sang Tab 2 rồi quay lại Tab 1, vị trí cuộn vẫn y nguyên như cũ!
