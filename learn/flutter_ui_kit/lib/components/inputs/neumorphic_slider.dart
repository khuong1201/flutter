import 'package:flutter/material.dart';

class NeumorphicSlider extends StatefulWidget {
  final double value;
  final ValueChanged<double> onChanged;

  const NeumorphicSlider({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  State<NeumorphicSlider> createState() => _NeumorphicSliderState();
}

class _NeumorphicSliderState extends State<NeumorphicSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E5EC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          // Bóng tối (Góc dưới phải)
          BoxShadow(
            color: Color(0xFFA3B1C6),
            offset: Offset(4, 4),
            blurRadius: 8,
          ),
          // Bóng sáng (Góc trên trái)
          BoxShadow(
            color: Colors.white,
            offset: Offset(-4, -4),
            blurRadius: 8,
          ),
        ],
      ),
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 12,
          activeTrackColor: Theme.of(context).colorScheme.primary,
          inactiveTrackColor: Colors.transparent, // Dùng nền Neumorphic ở dưới thay thế
          thumbColor: Theme.of(context).colorScheme.primary,
          overlayColor: Theme.of(context).colorScheme.primary.withOpacity(0.2),
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 14),
          trackShape: const RoundedRectSliderTrackShape(),
        ),
        child: Slider(
          value: widget.value,
          onChanged: widget.onChanged,
        ),
      ),
    );
  }
}
