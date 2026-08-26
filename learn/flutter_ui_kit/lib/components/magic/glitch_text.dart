import 'dart:math';
import 'package:flutter/material.dart';

class GlitchText extends StatefulWidget {
  final String text;
  final TextStyle style;

  const GlitchText({
    super.key,
    required this.text,
    required this.style,
  });

  @override
  State<GlitchText> createState() => _GlitchTextState();
}

class _GlitchTextState extends State<GlitchText> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Tạo nhiễu ngẫu nhiên
        final dx1 = (_random.nextDouble() * 4 - 2);
        final dy1 = (_random.nextDouble() * 4 - 2);
        final dx2 = (_random.nextDouble() * 4 - 2);
        final dy2 = (_random.nextDouble() * 4 - 2);

        // Đôi lúc chữ sẽ chớp tắt (Opacity = 0.5)
        final isGlitching = _random.nextDouble() > 0.8; 

        if (isGlitching) {
          return Stack(
            children: [
              // Lớp nền Đỏ chệch sang trái
              Transform.translate(
                offset: Offset(dx1, dy1),
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(color: Colors.red.withOpacity(0.8)),
                ),
              ),
              // Lớp nền Cyan chệch sang phải
              Transform.translate(
                offset: Offset(dx2, dy2),
                child: Text(
                  widget.text,
                  style: widget.style.copyWith(color: Colors.cyan.withOpacity(0.8)),
                ),
              ),
              // Lớp chữ Trắng chính giữa
              Text(
                widget.text,
                style: widget.style,
              ),
            ],
          );
        } else {
          return Text(widget.text, style: widget.style);
        }
      },
    );
  }
}
