# Bài 1: Navigator 1.0 Cơ Bản

Navigator 1.0 là hệ thống chuyển trang mặc định, được xây dựng sẵn trong Flutter từ những ngày đầu. Nó hoạt động giống như một **Ngăn xếp (Stack)** thẻ bài. Trang mới mở ra sẽ đè lên trang cũ.

## 1. Cách chuyển trang (Push)
Để mở một màn hình mới (ví dụ từ Màn A sang Màn B):

```dart
// Mở màn hình B (đè lên màn hình A)
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ScreenB(),
  ),
);
```

## 2. Truyền tham số qua màn hình khác
Giả sử bạn muốn truyền `id` từ danh sách sản phẩm sang trang chi tiết.

**Ở Screen B (Trang chi tiết):**
```dart
class ScreenB extends StatelessWidget {
  final int productId;
  // Khai báo biến trong constructor
  const ScreenB({Key? key, required this.productId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sản phẩm $productId')),
    );
  }
}
```

**Ở Screen A (Gọi chuyển trang):**
```dart
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => const ScreenB(productId: 42),
  ),
);
```

## 3. Cách quay lại (Pop)
Để đóng màn hình hiện tại và quay về màn hình trước đó:
```dart
// Có thể trả về một giá trị (ví dụ: true/false) cho trang trước đó
Navigator.pop(context, true); 
```

## 4. Chuyển trang và Xóa lịch sử (Push Replacement)
Ví dụ: Sau khi Đăng nhập thành công, chuyển sang màn hình Trang Chủ. Bạn không muốn người dùng bấm nút Back (Trở về) để quay lại màn hình Đăng nhập được nữa.

```dart
// Mở Trang Chủ và Xóa Đăng nhập khỏi bộ nhớ
Navigator.pushReplacement(
  context,
  MaterialPageRoute(
    builder: (context) => const HomeScreen(),
  ),
);
```
Hoặc xóa trắng toàn bộ lịch sử trước đó (Thường dùng khi Đăng xuất):
```dart
Navigator.pushAndRemoveUntil(
  context,
  MaterialPageRoute(builder: (context) => const LoginScreen()),
  (Route<dynamic> route) => false, // false nghĩa là xóa hết
);
```

## 5. Hạn chế của Navigator 1.0
- Không hỗ trợ **Deep Link** tốt. Nếu bạn mở app trên Web (`domain.com/product/42`), Navigator 1.0 không tự hiểu URL này để nhảy thẳng vào trang chi tiết sản phẩm.
- Khó quản lý khi ứng dụng lớn lên (chứa hàng trăm màn hình).
- Không an toàn kiểu dữ liệu (Truyền tham số thiếu hoặc sai kiểu thì chạy app mới biết bị lỗi).

*Vì vậy, Flutter ra mắt Navigator 2.0 (GoRouter / AutoRoute).*
