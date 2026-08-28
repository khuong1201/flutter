import 'package:flutter/material.dart';

class WheelDialPicker extends StatefulWidget {
  const WheelDialPicker({super.key});

  @override
  State<WheelDialPicker> createState() => _WheelDialPickerState();
}

class _WheelDialPickerState extends State<WheelDialPicker> {
  int _selectedValue = 50;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      height: 250,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[200],
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 10)),
          BoxShadow(color: Colors.white, blurRadius: 15, offset: Offset(-10, -10)),
        ],
        border: Border.all(color: Colors.white, width: 5),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Bánh xe số
          ListWheelScrollView.useDelegate(
            itemExtent: 60,
            diameterRatio: 1.5,
            physics: const FixedExtentScrollPhysics(),
            onSelectedItemChanged: (index) {
              setState(() => _selectedValue = index);
              // Thêm Haptic Feedback ở đây nếu test trên máy thật
            },
            childDelegate: ListWheelChildBuilderDelegate(
              builder: (context, index) {
                final isSelected = _selectedValue == index;
                return Center(
                  child: Text(
                    index.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: isSelected ? 48 : 24,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected ? Colors.deepOrange : Colors.grey,
                    ),
                  ),
                );
              },
              childCount: 100, // Chọn từ 00 đến 99
            ),
          ),
          
          // Kính lúp ở giữa
          IgnorePointer(
            child: Container(
              height: 65,
              width: 150,
              decoration: BoxDecoration(
                border: Border.symmetric(
                  horizontal: BorderSide(color: Colors.deepOrange.withOpacity(0.5), width: 2),
                ),
                color: Colors.deepOrange.withOpacity(0.1),
              ),
            ),
          )
        ],
      ),
    );
  }
}
