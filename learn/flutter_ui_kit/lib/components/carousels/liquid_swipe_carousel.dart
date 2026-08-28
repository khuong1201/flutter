import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';

class LiquidSwipeCarousel extends StatelessWidget {
  const LiquidSwipeCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    // Các trang với màu nền sặc sỡ để dễ thấy hiệu ứng chất lỏng
    final pages = [
      Container(
        color: Colors.pink,
        child: const Center(
          child: Text(
            "Trang 1\n(Vuốt mẻ trái/phải)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Container(
        color: Colors.blueAccent,
        child: const Center(
          child: Text(
            "Trang 2\n(Nước chảy mượt mà)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Container(
        color: Colors.amber,
        child: const Center(
          child: Text(
            "Trang 3\n(Hoàn hảo cho Onboarding)",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ];

    return SizedBox(
      height: 400, // Chiều cao cố định cho Showcase
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: LiquidSwipe(
          pages: pages,
          fullTransitionValue: 400, // Quãng đường kéo dãn giọt nước trước khi vỡ
          enableLoop: true, // Vuốt đến cuối thì quay lại vòng lặp
          positionSlideIcon: 0.5, // Nút gợn sóng mặc định ở giữa
          slideIconWidget: const Icon(Icons.arrow_back_ios, color: Colors.white),
          waveType: WaveType.liquidReveal,
        ),
      ),
    );
  }
}
