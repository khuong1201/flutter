import 'package:flutter/material.dart';
import 'dart:ui';

class SpatialUICard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const SpatialUICard({
    super.key,
    required this.child,
    this.width = 320,
    this.height = 200,
  });

  @override
  State<SpatialUICard> createState() => _SpatialUICardState();
}

class _SpatialUICardState extends State<SpatialUICard> {
  double _xOffset = 0.0;
  double _yOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    // Tính toán vị trí của dải lóa sáng (Glare) dựa trên góc nghiêng
    final glareX = (_xOffset * 2).clamp(-1.0, 1.0);
    final glareY = (_yOffset * 2).clamp(-1.0, 1.0);

    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _yOffset -= details.delta.dx / 150;
          _xOffset += details.delta.dy / 150;

          if (_yOffset > 0.3) _yOffset = 0.3;
          if (_yOffset < -0.3) _yOffset = -0.3;
          if (_xOffset > 0.3) _xOffset = 0.3;
          if (_xOffset < -0.3) _xOffset = -0.3;
        });
      },
      onPanEnd: (_) {
        setState(() {
          _xOffset = 0;
          _yOffset = 0;
        });
      },
      child: AnimatedContainer(
        duration: _xOffset == 0 && _yOffset == 0
            ? const Duration(milliseconds: 600)
            : const Duration(milliseconds: 0),
        curve: Curves.easeOutBack,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // 3D Perspective
          ..rotateX(_xOffset)
          ..rotateY(_yOffset),
        alignment: FractionalOffset.center,
        child: Stack(
          children: [
            // Lớp Kính Mờ (Frosted Glass)
            ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
                    ],
                  ),
                  child: widget.child, // Nội dung chính
                ),
              ),
            ),
            
            // Lớp Bóng Lóa Sáng (Glare Reflection) di chuyển theo tay
            IgnorePointer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment(glareX - 1, glareY - 1),
                      end: Alignment(glareX + 1, glareY + 1),
                      colors: [
                        Colors.white.withOpacity(0.0),
                        Colors.white.withOpacity(0.4),
                        Colors.white.withOpacity(0.0),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
