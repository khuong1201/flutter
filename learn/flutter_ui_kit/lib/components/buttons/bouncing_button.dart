import 'package:flutter/material.dart';

class BouncingButton extends StatefulWidget {
  final VoidCallback onTap;
  final Widget child;
  final double scaleFactor;

  const BouncingButton({
    super.key,
    required this.onTap,
    required this.child,
    this.scaleFactor = 0.9,
  });

  @override
  State<BouncingButton> createState() => _BouncingButtonState();
}

class _BouncingButtonState extends State<BouncingButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? widget.scaleFactor : 1.0,
        curve: Curves.elasticOut,
        duration: const Duration(milliseconds: 500),
        child: widget.child,
      ),
    );
  }
}
