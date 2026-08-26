import 'package:flutter/material.dart';

class ClaymorphicKeypad extends StatelessWidget {
  final ValueChanged<String> onKeyPressed;

  const ClaymorphicKeypad({super.key, required this.onKeyPressed});

  @override
  Widget build(BuildContext context) {
    final keys = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['*', '0', '#'],
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Màu xanh biển rất nhạt
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: keys.map((row) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((key) {
                return _ClayButton(
                  text: key,
                  onTap: () => onKeyPressed(key),
                );
              }).toList(),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _ClayButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;

  const _ClayButton({required this.text, required this.onTap});

  @override
  State<_ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<_ClayButton> {
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 70,
        height: 70,
        decoration: BoxDecoration(
          color: const Color(0xFFF0F4F8),
          borderRadius: BorderRadius.circular(35), // Claymorphism thường siêu bo tròn
          boxShadow: _isPressed
              ? [
                  // Khi bấm: Đổ bóng vào trong (Inset shadow giả lập) bằng cách giảm bóng ngoài
                  const BoxShadow(color: Color(0xFFD1D9E6), offset: Offset(2, 2), blurRadius: 2),
                  const BoxShadow(color: Colors.white, offset: Offset(-2, -2), blurRadius: 2),
                ]
              : [
                  // Khi nhả: Đổ bóng cực bồng bềnh, phồng rộp (Clay)
                  const BoxShadow(
                    color: Color(0xFFD1D9E6), // Bóng tối êm
                    offset: Offset(8, 8),
                    blurRadius: 15,
                  ),
                  const BoxShadow(
                    color: Colors.white, // Bóng sáng trên đỉnh
                    offset: Offset(-8, -8),
                    blurRadius: 15,
                  ),
                  // Thêm bóng viền giả 3D
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    offset: const Offset(4, 4),
                    blurRadius: 5,
                    spreadRadius: -2,
                  )
                ],
        ),
        child: Center(
          child: Text(
            widget.text,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: _isPressed ? Theme.of(context).colorScheme.primary : Colors.black87,
            ),
          ),
        ),
      ),
    );
  }
}
