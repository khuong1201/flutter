# Bài 3: Hiệu Ứng Animation Nâng Cao (Explicit)

Nếu Implicit Animation chỉ tự động chạy 1 chiều, thì **Explicit Animation** cho phép bạn nắm toàn quyền sinh sát: Chạy, Dừng, Tua lại, Chạy vô hạn (Loop).

Để làm được điều này, bạn phải trực tiếp điều khiển một thứ gọi là `AnimationController`.

## 1. Các thành phần bắt buộc
- **TickerProvider**: Nhịp đập thời gian của ứng dụng (Thường là 60 nhịp/giây). Để lấy nhịp đập, StatefulWidget phải dùng `with SingleTickerProviderStateMixin`.
- **AnimationController**: Quản lý trạng thái (Play/Stop/Reverse) và thường chạy giá trị từ `0.0` đến `1.0`.
- **Tween**: Công cụ chuyển đổi giá trị. Trình điều khiển chạy từ `0 -> 1`, Tween sẽ nội suy giá trị (Ví dụ nội suy vị trí từ X=0px đến X=100px).

## 2. Thực hành: Một quả bóng chạy tới chạy lui vô hạn

```dart
import 'package:flutter/material.dart';

// Bắt buộc phải có SingleTickerProviderStateMixin
class AdvancedAnimationScreen extends StatefulWidget {
  @override
  _AdvancedAnimationScreenState createState() => _AdvancedAnimationScreenState();
}

class _AdvancedAnimationScreenState extends State<AdvancedAnimationScreen> 
    with SingleTickerProviderStateMixin { 
      
  late AnimationController _controller;
  late Animation<double> _animation; // Giá trị đã nội suy qua Tween

  @override
  void initState() {
    super.initState();
    
    // 1. Khởi tạo Controller chạy trong 2 giây
    _controller = AnimationController(
      vsync: this, // Lấy nhịp đập từ Mixin
      duration: const Duration(seconds: 2),
    );

    // 2. Định nghĩa Tween (Chạy từ 0 đến 300)
    _animation = Tween<double>(begin: 0, end: 300).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // 3. Cho phép chạy (repeat: lặp lại, reverse: chạy giật lùi khi hết 2 giây)
    _controller.repeat(reverse: true); 
  }

  @override
  void dispose() {
    // QUAN TRỌNG: Bắt buộc hủy Controller để tránh rò rỉ RAM (Memory Leak)
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _animation, // Lắng nghe sự thay đổi của animation này
        builder: (context, child) {
          // Hàm này sẽ được gọi 60 lần 1 giây (60fps)
          return Transform.translate(
            // Di chuyển Widget theo trục Y (dọc) bằng giá trị nội suy
            offset: Offset(0, _animation.value), 
            child: child,
          );
        },
        child: const Icon(Icons.sports_basketball, size: 50, color: Colors.orange),
      ),
    );
  }
}
```

## 3. Dấu hiệu nhận biết
Các Widget hỗ trợ Explicit Animation thường có chữ `Transition` ở cuối (Ví dụ: `SlideTransition`, `FadeTransition`, `RotationTransition`, `ScaleTransition`).
Bản chất của chúng là gói gém bớt đoạn code `AnimatedBuilder` ở trên giúp bạn gõ code nhanh hơn.
