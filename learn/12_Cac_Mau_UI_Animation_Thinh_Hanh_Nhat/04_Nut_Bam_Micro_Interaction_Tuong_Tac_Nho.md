# Bài 4: Nút Bấm Có Vi Tương Tác (Micro-Interaction)

Ngày xưa, khi bấm một cái nút, cùng lắm là nó đổi màu từ xanh sang xám. Ngày nay, một cái nút đạt chuẩn UX (Trải nghiệm người dùng) tốt phải biết "phản ứng" lại thao tác của người dùng.

Hiệu ứng kinh điển nhất: **Bouncing Button (Nút nảy)** giống như lò xo. Khi đè ngón tay xuống, nút lún vào. Khi thả tay ra, nút bật nảy trở lại. Thao tác này kích thích não bộ (giống bóp xốp nổ bong bóng) khiến người dùng thích bấm hơn.

## 1. Tạo Nút Bấm "Lún và Nảy" Tự Chế (Bằng Implicit Animation)

Thay vì dùng `ElevatedButton` hay `GestureDetector` thông thường nhạt nhẽo, ta sẽ tự build một Widget riêng để dùng cho toàn app.

```dart
import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;

  const BouncingButton({Key? key, required this.onTap, required this.child}) : super(key: key);

  @override
  _BouncingButtonState createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> {
  // Trạng thái: Ngón tay có đang đè lên nút không?
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bắt đầu đè ngón tay xuống
      onTapDown: (_) => setState(() => _isPressed = true),
      // Thả ngón tay ra (hoặc trượt ngón tay đi chỗ khác)
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap(); // Gọi hàm của người dùng truyền vào
      },
      onTapCancel: () => setState(() => _isPressed = false),
      
      // Dùng AnimatedScale để làm hiệu ứng thu nhỏ
      child: AnimatedScale(
        // Nếu đang đè thì thu nhỏ lại còn 90%, thả ra thì về 100%
        scale: _isPressed ? 0.9 : 1.0, 
        
        // Cú nảy lò xo (Overshoot) thần thánh
        curve: Curves.elasticOut, 
        
        // Thời gian nảy (500ms là đẹp nhất)
        duration: const Duration(milliseconds: 500), 
        
        child: Container(
           padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
           decoration: BoxDecoration(
             color: Colors.blueAccent,
             borderRadius: BorderRadius.circular(16),
             boxShadow: _isPressed 
                 ? [] // Lún xuống thì mất bóng râm
                 : [BoxShadow(color: Colors.blue.withOpacity(0.4), blurRadius: 10, offset: Offset(0, 5))], // Thả ra thì có bóng râm
           ),
           child: widget.child,
        ),
      ),
    );
  }
}
```

## 2. Nút Thả Tim Bắn Pháo Hoa (Nút Like của Twitter/X)

Khi bạn thả tim một bài viết, icon trái tim không chỉ đỏ lên, mà nó bung ra các hạt pháo hoa li ti. 
Để làm thủ công hiệu ứng này bằng `AnimationController` thì vỡ nát bàn phím. Cách khôn ngoan nhất là xài thư viện.

**Thư viện**: `like_button`

**Cách dùng**:
```dart
import 'package:like_button/like_button.dart';

LikeButton(
  size: 40,
  circleColor: const CircleColor(start: Color(0xff00ddff), end: Color(0xff0099cc)), // Vòng sáng khi nổ
  bubblesColor: const BubblesColor(
    dotPrimaryColor: Color(0xff33b5e5),
    dotSecondaryColor: Color(0xff0099cc),
  ), // Hạt pháo hoa
  likeBuilder: (bool isLiked) {
    return Icon(
      Icons.favorite,
      color: isLiked ? Colors.pinkAccent : Colors.grey,
      size: 40,
    );
  },
  onTap: (isLiked) async {
    // Gọi API lưu thả tim ở đây...
    return !isLiked;
  },
)
```

**Bài học UX:** Đừng bắt người dùng đợi Call API thành công rồi trái tim mới đỏ. Hãy đổi màu trái tim và bắn pháo hoa **NGAY LẬP TỨC** khi họ bấm (gọi là Optimistic UI). Sau đó Call API ngầm, nếu lỗi API thì thông báo mờ trái tim sau. Trải nghiệm app sẽ mượt như chớp!
