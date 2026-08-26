import 'package:flutter/material.dart';
import 'dart:math' as math;

class WaterFillProgress extends StatefulWidget {
  final double progress; // 0.0 -> 1.0

  const WaterFillProgress({
    super.key,
    required this.progress,
  });

  @override
  State<WaterFillProgress> createState() => _WaterFillProgressState();
}

class _WaterFillProgressState extends State<WaterFillProgress> with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2), // Tốc độ vỗ sóng
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Theme.of(context).colorScheme.primary, width: 4),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 5))
        ],
      ),
      child: ClipOval(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Vẽ chất lỏng
            AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(150, 150),
                  painter: _WaterPainter(
                    progress: widget.progress,
                    wavePhase: _waveController.value * 2 * math.pi, // Di chuyển pha của sóng
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.6),
                  ),
                );
              },
            ),
            // Hiện % Loading
            Text(
              "${(widget.progress * 100).toInt()}%",
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _WaterPainter extends CustomPainter {
  final double progress;
  final double wavePhase;
  final Color color;

  _WaterPainter({
    required this.progress,
    required this.wavePhase,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final path = Path();
    
    // Tính toán chiều cao mức nước (Progress 0.0 -> nằm dưới đáy, 1.0 -> nằm trên đỉnh)
    final waterHeight = size.height * (1 - progress);

    path.moveTo(0, size.height); // Bắt đầu từ góc dưới trái
    path.lineTo(0, waterHeight); // Kéo lên ngang mặt nước

    // Vẽ gợn sóng bằng hàm Sin
    for (double i = 0; i <= size.width; i++) {
      // Công thức sóng: y = A * sin(kx - phase) + y0
      // A = 10 (độ cao sóng)
      // k = chu kỳ sóng
      final waveY = 8 * math.sin((i / size.width) * 2 * math.pi + wavePhase) + waterHeight;
      path.lineTo(i, waveY);
    }

    path.lineTo(size.width, size.height); // Kéo xuống góc dưới phải
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
