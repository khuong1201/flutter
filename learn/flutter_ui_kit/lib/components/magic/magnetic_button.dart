import 'package:flutter/material.dart';

class MagneticButton extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const MagneticButton({
    super.key,
    required this.child,
    required this.onTap,
  });

  @override
  State<MagneticButton> createState() => _MagneticButtonState();
}

class _MagneticButtonState extends State<MagneticButton> {
  double _x = 0;
  double _y = 0;
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Bắt đầu chạm
      onPanDown: (_) => setState(() => _isHovering = true),
      // Bắt đầu kéo xung quanh
      onPanUpdate: (details) {
        setState(() {
          // Tính toán khoảng cách kéo (Giới hạn khoảng cách tối đa để nút không bay đi mất)
          _x += details.delta.dx;
          _y += details.delta.dy;

          // Giới hạn trong khoảng -30 đến 30 pixel
          if (_x > 30) _x = 30;
          if (_x < -30) _x = -30;
          if (_y > 30) _y = 30;
          if (_y < -30) _y = -30;
        });
      },
      // Thả tay ra -> Bật nảy về vị trí 0,0
      onPanEnd: (_) {
        setState(() {
          _x = 0;
          _y = 0;
          _isHovering = false;
        });
      },
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: _isHovering ? const Duration(milliseconds: 0) : const Duration(milliseconds: 600),
        curve: _isHovering ? Curves.linear : Curves.elasticOut, // Khi thả tay thì bung lò xo
        transform: Matrix4.translationValues(_x, _y, 0),
        child: widget.child,
      ),
    );
  }
}
