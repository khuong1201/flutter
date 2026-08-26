import 'package:flutter/material.dart';

class SpotlightEffect extends StatefulWidget {
  final Widget child;

  const SpotlightEffect({super.key, required this.child});

  @override
  State<SpotlightEffect> createState() => _SpotlightEffectState();
}

class _SpotlightEffectState extends State<SpotlightEffect> {
  Offset _spotlightPos = const Offset(150, 150);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          _spotlightPos = details.localPosition;
        });
      },
      child: Container(
        color: Colors.black, // Khung nền tối ôm trọn
        child: ShaderMask(
          // Dùng Radial Gradient làm mặt nạ
          shaderCallback: (Rect bounds) {
            return RadialGradient(
              center: FractionalOffset(
                _spotlightPos.dx / bounds.width,
                _spotlightPos.dy / bounds.height,
              ),
              radius: 0.3, // Kích thước của chùm đèn pin
              colors: const [Colors.white, Colors.transparent],
              stops: const [0.5, 1.0], // Độ nhòe của viền đèn
            ).createShader(bounds);
          },
          blendMode: BlendMode.dstIn, // Hiển thị nội dung ở nơi có ánh sáng trắng
          child: widget.child,
        ),
      ),
    );
  }
}
