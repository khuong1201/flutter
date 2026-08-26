import 'package:flutter/material.dart';

class ParallaxCarousel extends StatefulWidget {
  final List<String> images;
  const ParallaxCarousel({super.key, required this.images});

  @override
  State<ParallaxCarousel> createState() => _ParallaxCarouselState();
}

class _ParallaxCarouselState extends State<ParallaxCarousel> {
  late PageController _pageController;
  double _pageOffset = 0;

  @override
  void initState() {
    super.initState();
    // viewportFraction: 0.8 giúp các ảnh hiển thị lọt thỏm ở giữa và thò ra 2 bên
    _pageController = PageController(viewportFraction: 0.8);
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: PageView.builder(
        controller: _pageController,
        itemCount: widget.images.length,
        itemBuilder: (context, index) {
          // Tính toán khoảng cách từ thẻ hiện tại đến thẻ đang được chọn
          double difference = index - _pageOffset;
          
          return AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            margin: EdgeInsets.only(
              right: 15,
              left: 15,
              top: difference.abs() * 20, // Hiệu ứng Scale down khi thẻ bị lệch
              bottom: difference.abs() * 20,
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Hiệu ứng Parallax: Dịch chuyển ảnh ngược chiều cuộn
                  Positioned(
                    left: difference * 100, // Ảnh di chuyển theo hướng ngược lại
                    right: -difference * 100,
                    child: Container(
                      color: index % 2 == 0 ? Colors.blueGrey : Colors.indigo,
                      child: Center(
                        child: Icon(Icons.image, size: 80, color: Colors.white.withOpacity(0.5)),
                      ),
                    ),
                  ),
                  // Bóng mờ (Vignette) để text dễ đọc hơn
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.7),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 20,
                    left: 20,
                    child: Text(
                      'Bộ Sưu Tập ${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
