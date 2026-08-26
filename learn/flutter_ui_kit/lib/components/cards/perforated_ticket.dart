import 'package:flutter/material.dart';

class PerforatedTicket extends StatelessWidget {
  final Widget child;
  final double radius;
  final double holeRadius;

  const PerforatedTicket({
    super.key,
    required this.child,
    this.radius = 16.0,
    this.holeRadius = 15.0,
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: _TicketClipper(radius: radius, holeRadius: holeRadius),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(radius),
        ),
        child: child,
      ),
    );
  }
}

class _TicketClipper extends CustomClipper<Path> {
  final double radius;
  final double holeRadius;

  _TicketClipper({required this.radius, required this.holeRadius});

  @override
  Path getClip(Size size) {
    final path = Path();
    
    // Bắt đầu từ góc trên trái
    path.lineTo(0.0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width, 0.0);
    path.close();

    // Khoét lỗ ở giữa 2 cạnh bên
    final holePath = Path();
    
    // Lỗ bên trái
    holePath.addOval(Rect.fromCircle(
      center: Offset(0, size.height / 2),
      radius: holeRadius,
    ));

    // Lỗ bên phải
    holePath.addOval(Rect.fromCircle(
      center: Offset(size.width, size.height / 2),
      radius: holeRadius,
    ));

    // Hợp nhất (Khoét lỗ từ Path chính)
    return Path.combine(PathOperation.difference, path, holePath);
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
