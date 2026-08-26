import 'package:flutter/material.dart';

class Hidden3DDrawer extends StatefulWidget {
  final Widget drawerContent;
  final Widget mainScreen;

  const Hidden3DDrawer({
    super.key,
    required this.drawerContent,
    required this.mainScreen,
  });

  @override
  State<Hidden3DDrawer> createState() => Hidden3DDrawerState();
}

class Hidden3DDrawerState extends State<Hidden3DDrawer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isDrawerOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void toggleDrawer() {
    if (_isDrawerOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isDrawerOpen = !_isDrawerOpen;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF1E1E2C), // Màu nền phía sau Drawer
      body: Stack(
        children: [
          // 1. Màn hình Drawer nằm ở dưới cùng
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.translate(
                offset: Offset(size.width * 0.6 * (_controller.value - 1), 0),
                child: child,
              );
            },
            child: SizedBox(
              width: size.width * 0.6,
              height: size.height,
              child: widget.drawerContent,
            ),
          ),

          // 2. Màn hình chính (Sẽ thu nhỏ và nghiêng 3D đi khi mở Drawer)
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              // Điểm tụ sương mù 3D
              final matrix = Matrix4.identity()
                ..setEntry(3, 2, 0.001)
                ..translate(size.width * 0.6 * _controller.value) // Dịch sang phải
                ..scale(1.0 - (0.2 * _controller.value)) // Thu nhỏ 20%
                ..rotateY(-0.3 * _controller.value); // Nghiêng 3D

              return Transform(
                transform: matrix,
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: _isDrawerOpen ? toggleDrawer : null,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(_controller.value * 30),
                    child: IgnorePointer(
                      ignoring: _isDrawerOpen, // Khóa tương tác Màn hình chính khi đang mở Drawer
                      child: child,
                    ),
                  ),
                ),
              );
            },
            child: widget.mainScreen,
          ),
        ],
      ),
    );
  }
}
