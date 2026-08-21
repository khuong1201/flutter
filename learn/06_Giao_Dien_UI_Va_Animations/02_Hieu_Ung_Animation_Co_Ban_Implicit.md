# Bài 2: Hiệu Ứng Animation Cơ Bản (Implicit)

Flutter được mệnh danh là Vua của Animation. Việc tạo ra các chuyển động mượt mà 60fps là vô cùng dễ dàng.
Loại Animation dễ nhất là **Implicit Animation (Animation ngầm)**. Bạn chỉ cần thay đổi 1 giá trị (kích thước, màu sắc), Flutter sẽ tự động tính toán và vẽ ra quá trình chuyển động.

## 1. Dấu hiệu nhận biết
Tất cả các Widget có chữ `Animated...` ở đầu đều thuộc nhóm này. (Ví dụ: `AnimatedContainer`, `AnimatedOpacity`, `AnimatedPadding`...).

## 2. Thực hành: Thay đổi hình dạng nút bấm mượt mà
Khi bấm nút, cái hộp vuông màu xanh sẽ biến đổi từ từ thành hình tròn màu đỏ trong vòng 1 giây.

```dart
import 'package:flutter/material.dart';

class BasicAnimationScreen extends StatefulWidget {
  @override
  _BasicAnimationScreenState createState() => _BasicAnimationScreenState();
}

class _BasicAnimationScreenState extends State<BasicAnimationScreen> {
  // Biến trạng thái
  bool isClicked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: GestureDetector(
          onTap: () {
             // Đổi trạng thái
            setState(() {
              isClicked = !isClicked;
            });
          },
          // THAY VÌ DÙNG Container, hày dùng AnimatedContainer
          child: AnimatedContainer(
            // Bắt buộc phải khai báo duration (Thời gian chuyển động)
            duration: const Duration(seconds: 1),
            // Đường cong chuyển động mượt (Curves)
            curve: Curves.easeInOut, 
            
            // Các thuộc tính sẽ TỰ ĐỘNG animate khi có thay đổi
            width: isClicked ? 200 : 100,
            height: isClicked ? 200 : 100,
            decoration: BoxDecoration(
              color: isClicked ? Colors.red : Colors.blue,
              borderRadius: BorderRadius.circular(isClicked ? 100 : 8),
            ),
          ),
        ),
      ),
    );
  }
}
```

## 3. AnimatedOpacity (Làm mờ dần)
Dùng để làm hiệu ứng ẩn/hiện một Widget.

```dart
AnimatedOpacity(
  // Nếu false thì mờ tịt (0.0), true thì hiện rõ (1.0)
  opacity: isVisible ? 1.0 : 0.0, 
  duration: const Duration(milliseconds: 500),
  child: const Text('Hello World'),
)
```

## 4. Ưu và nhược điểm
- **Ưu điểm**: Quá dễ học, code cực ngắn.
- **Nhược điểm**: Chỉ chạy một lần khi có sự thay đổi (State thay đổi). Bạn không thể bắt nó chạy đi chạy lại vô hạn (vòng lặp), cũng không thể Tạm dừng (Pause), Tua ngược (Reverse) giữa chừng được. Muốn làm điều đó, bạn phải dùng Explicit Animation (Bài tiếp theo).
