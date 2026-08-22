# Bài 5: Hiệu Ứng Thẻ Xoay 3D (Tinder Swipe & Parallax Card)

Hiệu ứng lướt thẻ trái/phải để Thích/Bỏ qua (như Tinder) hay cầm một cái thẻ vật lý lắc qua lắc lại làm độ bóng của màng kim loại thay đổi trên thẻ (Giống hiệu ứng thẻ bài Pokemon) là những Trend cực đỉnh.

## 1. Vuốt thẻ dạng Tinder (Tinder Swipe)

Thay vì viết code xử lý ngón tay (Drag / Pan) rối rắm toán học hình học không gian, dân Flutter chơi chiêu dùng thư viện `appinio_swiper` hoặc `flutter_card_swiper`.

```dart
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

class TinderSwipeScreen extends StatelessWidget {
  List<Container> cards = [
    Container(color: Colors.red, child: Center(child: Text('Cô gái 1'))),
    Container(color: Colors.blue, child: Center(child: Text('Cô gái 2'))),
    Container(color: Colors.green, child: Center(child: Text('Cô gái 3'))),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CardSwiper(
          cardsCount: cards.length,
          cardBuilder: (context, index, percentThresholdX, percentThresholdY) => cards[index],
          onSwipe: (previousIndex, currentIndex, direction) {
            if (direction == CardSwiperDirection.right) {
               print("Đã thả tim (Quẹt phải) cô gái số $previousIndex");
            } else {
               print("Đã bỏ qua (Quẹt trái)");
            }
            return true;
          },
        ),
      ),
    );
  }
}
```

## 2. Thẻ 3D Xoay Theo Gia Tốc Kế Điện Thoại (Hoặc Ngón Tay)

Đây là đỉnh cao của UI/UX: Cái thẻ nằm trên màn hình, nhưng khi bạn nghiêng cái điện thoại (cầm trên tay), cái thẻ trên màn hình cũng hơi nghiêng theo chiều không gian 3D. 

Cái này dùng toán `Transform` ma trận 4 chiều (Matrix4).

```dart
// Code minh hoạ nghiêng thẻ theo ngón tay trượt trên thẻ
class Card3D extends StatefulWidget {
  @override
  _Card3DState createState() => _Card3DState();
}

class _Card3DState extends State<Card3D> {
  double x = 0; // Độ lệch trục X
  double y = 0; // Độ lệch trục Y

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Khi ngón tay di chuyển trên thẻ
      onPanUpdate: (details) {
        setState(() {
          // Xoay thẻ theo chiều vuốt (Chia số to ra để thẻ xoay nhẹ nhàng)
          y = y - details.delta.dx / 100;
          x = x + details.delta.dy / 100;
        });
      },
      // Khi thả tay ra, thẻ từ từ phục hồi về vị trí thẳng
      onPanEnd: (details) {
        setState(() {
          x = 0;
          y = 0;
        });
      },
      child: Transform(
        // Cú pháp thần chú tạo không gian 3D của Flutter
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Điểm mù không gian (Perspective)
          ..rotateX(x) // Xoay dọc
          ..rotateY(y), // Xoay ngang
        alignment: FractionalOffset.center,
        child: Container(
          width: 300,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            image: DecorationImage(
              image: NetworkImage('https://ảnh_nền_thẻ_tín_dụng.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(child: Text("Thẻ Siêu VIP", style: TextStyle(color: Colors.white, fontSize: 30))),
        ),
      ),
    );
  }
}
```

Hãy copy đoạn code `Transform(Matrix4)` này và trải nghiệm. Bất kể là chữ hay hình ảnh, nó sẽ xoay 3D khiến app của bạn nhìn như một phép thuật!
