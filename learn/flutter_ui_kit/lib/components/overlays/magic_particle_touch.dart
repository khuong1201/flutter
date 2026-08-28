import 'package:flutter/material.dart';
import 'dart:math' as math;

class MagicParticleTouch extends StatefulWidget {
  final Widget child;

  const MagicParticleTouch({super.key, required this.child});

  @override
  State<MagicParticleTouch> createState() => _MagicParticleTouchState();
}

class _Particle {
  double x;
  double y;
  double vx;
  double vy;
  double life; // 1.0 -> 0.0
  Color color;
  double size;

  _Particle(this.x, this.y, this.vx, this.vy, this.color, this.size) : life = 1.0;
}

class _MagicParticleTouchState extends State<MagicParticleTouch> with SingleTickerProviderStateMixin {
  final List<_Particle> _particles = [];
  late AnimationController _ticker;
  final math.Random _random = math.Random();

  @override
  void initState() {
    super.initState();
    _ticker = AnimationController(vsync: this, duration: const Duration(days: 999))..forward();
    _ticker.addListener(_updateParticles);
  }

  void _updateParticles() {
    setState(() {
      for (int i = _particles.length - 1; i >= 0; i--) {
        var p = _particles[i];
        p.x += p.vx;
        p.y += p.vy;
        p.vy += 0.2; // Gravity
        p.life -= 0.03; // Phai màu dần

        if (p.life <= 0) {
          _particles.removeAt(i);
        }
      }
    });
  }

  void _spawnParticles(Offset pos) {
    for (int i = 0; i < 3; i++) { // Sinh 3 hạt mỗi khung hình vuốt
      _particles.add(
        _Particle(
          pos.dx,
          pos.dy,
          (_random.nextDouble() - 0.5) * 5, // Vận tốc ngang ngẫu nhiên
          -(_random.nextDouble() * 5), // Vận tốc nảy lên
          Color.lerp(Colors.orange, Colors.yellow, _random.nextDouble())!,
          _random.nextDouble() * 6 + 2, // Kích thước hạt 2 -> 8
        ),
      );
    }
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        _spawnParticles(details.localPosition);
      },
      onPanDown: (details) {
        _spawnParticles(details.localPosition);
      },
      child: Stack(
        children: [
          widget.child,
          // Lớp vẽ hạt bụi ma thuật đè lên trên cùng
          IgnorePointer(
            child: CustomPaint(
              painter: _ParticlePainter(_particles),
              child: Container(),
            ),
          )
        ],
      ),
    );
  }
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;

  _ParticlePainter(this.particles);

  @override
  void paint(Canvas canvas, Size size) {
    for (var p in particles) {
      final paint = Paint()
        ..color = p.color.withOpacity(p.life.clamp(0.0, 1.0))
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2); // Tỏa sáng nhẹ
      canvas.drawCircle(Offset(p.x, p.y), p.size * p.life, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
