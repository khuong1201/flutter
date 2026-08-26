import 'package:flutter/material.dart';

class Tilt3DCard extends StatefulWidget {
  final Widget child;
  final double width;
  final double height;

  const Tilt3DCard({
    super.key,
    required this.child,
    this.width = 300,
    this.height = 200,
  });

  @override
  State<Tilt3DCard> createState() => _Tilt3DCardState();
}

class _Tilt3DCardState extends State<Tilt3DCard> {
  double _xOffset = 0.0;
  double _yOffset = 0.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        setState(() {
          // Vuốt sang ngang làm quay theo trục Y
          _yOffset -= details.delta.dx / 100;
          // Vuốt lên xuống làm quay theo trục X
          _xOffset += details.delta.dy / 100;
          
          // Giới hạn góc nghiêng để thẻ không bị lật úp ngược
          if (_yOffset > 0.5) _yOffset = 0.5;
          if (_yOffset < -0.5) _yOffset = -0.5;
          if (_xOffset > 0.5) _xOffset = 0.5;
          if (_xOffset < -0.5) _xOffset = -0.5;
        });
      },
      onPanEnd: (_) {
        // Khi thả tay, thẻ tự động trả về vị trí phẳng (Bằng Implicit Animation)
        setState(() {
          _xOffset = 0;
          _yOffset = 0;
        });
      },
      child: AnimatedContainer(
        duration: _xOffset == 0 && _yOffset == 0 
            ? const Duration(milliseconds: 600) // Đang hồi phục
            : const Duration(milliseconds: 0), // Đang vuốt thì cập nhật ngay
        curve: Curves.easeOutBack,
        width: widget.width,
        height: widget.height,
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001) // Điểm tụ sương mù 3D (Perspective)
          ..rotateX(_xOffset)
          ..rotateY(_yOffset),
        alignment: FractionalOffset.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.3),
                blurRadius: 20,
                // Đổ bóng nghịch hướng với độ nghiêng để tăng tính chân thật
                offset: Offset(-_yOffset * 50, _xOffset * 50 + 10),
              )
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
