import 'package:flutter/material.dart';
import 'package:scratcher/scratcher.dart';
import 'package:confetti/confetti.dart';
import 'dart:math' as dart_math;

class ScratchAndWin extends StatefulWidget {
  const ScratchAndWin({super.key});

  @override
  State<ScratchAndWin> createState() => _ScratchAndWinState();
}

class _ScratchAndWinState extends State<ScratchAndWin> {
  late ConfettiController _confettiController;
  final scratchKey = GlobalKey<ScratcherState>();
  bool _isScratched = false;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Thẻ cào
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Scratcher(
            key: scratchKey,
            brushSize: 40,
            threshold: 50, // Cào 50% là tự động bay hết
            color: Colors.grey[400]!, // Lớp phủ màu xám bạc
            onChange: (value) {
              // Có thể đo % cào ở đây
            },
            onThreshold: () {
              if (!_isScratched) {
                setState(() => _isScratched = true);
                _confettiController.play();
                scratchKey.currentState?.reveal(duration: const Duration(milliseconds: 500));
              }
            },
            child: Container(
              height: 200,
              width: 300,
              decoration: BoxDecoration(
                color: Colors.yellow[100],
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "🎉 TRÚNG THƯỞNG 🎉",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Voucher 500K",
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: Colors.blue),
                  ),
                ],
              ),
            ),
          ),
        ),

        // Máy bắn pháo hoa
        ConfettiWidget(
          confettiController: _confettiController,
          blastDirectionality: BlastDirectionality.explosive, // Bắn tung toé mọi hướng
          shouldLoop: false,
          colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
          createParticlePath: drawStar, // Dùng hạt hình Ngôi Sao
        ),
      ],
    );
  }

  // Thuật toán vẽ hình ngôi sao cho pháo hoa
  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (3.141592653589793 / 180.0);
    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);
    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * 1 * (step).cos(), halfWidth + externalRadius * 1 * (step).sin());
      path.lineTo(halfWidth + internalRadius * 1 * (step + halfDegreesPerStep).cos(), halfWidth + internalRadius * 1 * (step + halfDegreesPerStep).sin());
    }
    path.close();
    return path;
  }
}

// Extension nhỏ để gọi hàm lượng giác (cos, sin) gọn hơn
extension MathDouble on double {
  double cos() => dart_math.cos(this);
  double sin() => dart_math.sin(this);
}
