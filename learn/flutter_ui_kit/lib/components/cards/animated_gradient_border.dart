import 'package:flutter/material.dart';

class AnimatedGradientBorder extends StatefulWidget {
  final Widget child;
  final double borderRadius;

  const AnimatedGradientBorder({
    super.key,
    required this.child,
    this.borderRadius = 24.0,
  });

  @override
  State<AnimatedGradientBorder> createState() => _AnimatedGradientBorderState();
}

class _AnimatedGradientBorderState extends State<AnimatedGradientBorder> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Khối Gradient xoay vòng
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * 3.141592653589793,
                child: Container(
                  width: MediaQuery.of(context).size.width * 2, // Phải to hơn card
                  height: MediaQuery.of(context).size.width * 2,
                  decoration: const BoxDecoration(
                    gradient: SweepGradient(
                      colors: [
                        Colors.transparent,
                        Colors.cyanAccent,
                        Colors.transparent,
                        Colors.purpleAccent,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
          
          // Lớp nền đen che lấp ở giữa (Chỉ hở ra cái viền sáng)
          Padding(
            padding: const EdgeInsets.all(3.0), // Độ dày của viền sáng (3px)
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2C), // Trùng màu nền của App
                borderRadius: BorderRadius.circular(widget.borderRadius - 3),
              ),
              child: widget.child,
            ),
          ),
        ],
      ),
    );
  }
}
