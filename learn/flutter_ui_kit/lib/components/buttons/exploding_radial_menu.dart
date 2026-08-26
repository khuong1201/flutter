import 'package:flutter/material.dart';
import 'dart:math' as math;

class ExplodingRadialMenu extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onItemSelected;

  const ExplodingRadialMenu({
    super.key,
    required this.icons,
    required this.onItemSelected,
  });

  @override
  State<ExplodingRadialMenu> createState() => _ExplodingRadialMenuState();
}

class _ExplodingRadialMenuState extends State<ExplodingRadialMenu> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleMenu() {
    if (_isOpen) {
      _controller.reverse();
    } else {
      _controller.forward();
    }
    _isOpen = !_isOpen;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.bottomRight, // Đặt menu ở góc dưới phải
        children: [
          // Render các nút con
          ...List.generate(widget.icons.length, (index) {
            return _buildChildButton(index);
          }),
          
          // Nút chính (Nút to ở giữa)
          FloatingActionButton(
            heroTag: 'main_fab',
            onPressed: _toggleMenu,
            backgroundColor: Colors.black87,
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * math.pi / 4, // Xoay 45 độ thành chữ X
                  child: const Icon(Icons.add, color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChildButton(int index) {
    // Góc chia đều trên cung tròn 90 độ (Pi/2)
    final double angle = (math.pi / 2) / (widget.icons.length - 1) * index;

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Tọa độ bắn ra theo lượng giác (sin, cos)
        final double distance = 100.0 * Curves.elasticOut.transform(_controller.value);
        final double x = distance * math.cos(angle);
        final double y = distance * math.sin(angle);

        return Transform.translate(
          // Trừ x, trừ y vì bắn lên trên và sang trái
          offset: Offset(-x, -y),
          child: Transform.scale(
            scale: _controller.value, // Phóng to dần
            child: child,
          ),
        );
      },
      child: FloatingActionButton(
        heroTag: 'child_fab_$index',
        mini: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black87,
        onPressed: () {
          widget.onItemSelected(index);
          _toggleMenu();
        },
        child: Icon(widget.icons[index]),
      ),
    );
  }
}
