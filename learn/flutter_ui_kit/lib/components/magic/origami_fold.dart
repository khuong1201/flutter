import 'package:flutter/material.dart';
import 'dart:math' as math;

class OrigamiFold extends StatefulWidget {
  final Widget child; // Một cái ảnh hoặc khối cần gập làm đôi

  const OrigamiFold({
    super.key,
    required this.child,
  });

  @override
  State<OrigamiFold> createState() => _OrigamiFoldState();
}

class _OrigamiFoldState extends State<OrigamiFold> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isFolded = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleFold() {
    if (_isFolded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
    _isFolded = !_isFolded;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleFold,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          // Animation lật (90 độ -> 0 độ)
          // Khi bị lật 90 độ (Pi/2) thì nó vuông góc với mắt người nhìn (Ẩn đi)
          final topAngle = (1 - _controller.value) * (math.pi / 2);
          final bottomAngle = -(1 - _controller.value) * (math.pi / 2);

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Nửa trên (Gập xuống)
              ClipRect(
                child: Align(
                  alignment: Alignment.topCenter,
                  heightFactor: 0.5, // Chỉ lấy nửa trên của Child
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(topAngle), // Gập lên
                    alignment: Alignment.bottomCenter, // Khớp bản lề ở đáy
                    child: widget.child,
                  ),
                ),
              ),
              // Nửa dưới (Gập lên)
              ClipRect(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  heightFactor: 0.5, // Chỉ lấy nửa dưới của Child
                  child: Transform(
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.001)
                      ..rotateX(bottomAngle), // Gập xuống
                    alignment: Alignment.topCenter, // Khớp bản lề ở đỉnh
                    child: widget.child,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
