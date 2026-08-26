import 'package:flutter/material.dart';
import 'dart:math' as math;

class Flip3DCard extends StatefulWidget {
  final Widget front;
  final Widget back;

  const Flip3DCard({
    super.key,
    required this.front,
    required this.back,
  });

  @override
  State<Flip3DCard> createState() => _Flip3DCardState();
}

class _Flip3DCardState extends State<Flip3DCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _flipCard() {
    if (_isFront) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFront = !_isFront;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _flipCard,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Xoay quanh trục Y từ 0 đến Pi (180 độ)
          final angle = _controller.value * math.pi;

          // Nếu góc xoay > 90 độ (Pi/2), tức là lật mặt sau
          final isBackVisible = angle > math.pi / 2;

          return Transform(
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001) // Điểm tụ sương mù 3D
              ..rotateY(angle),
            alignment: Alignment.center,
            child: isBackVisible
                ? Transform(
                    // Xoay mặt sau lại 180 độ để nó không bị ngược chữ
                    transform: Matrix4.identity()..rotateY(math.pi),
                    alignment: Alignment.center,
                    child: widget.back,
                  )
                : widget.front,
          );
        },
      ),
    );
  }
}
