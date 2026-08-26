import 'package:flutter/material.dart';

class CurvedBottomNav extends StatelessWidget {
  final List<IconData> icons;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onFabTapped;

  const CurvedBottomNav({
    super.key,
    required this.icons,
    required this.onTabSelected,
    required this.onFabTapped,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      shape: const CircularNotchedRectangle(), // Khoét lỗ (Notch)
      notchMargin: 10.0, // Khe hở quanh nút bấm giữa
      color: Colors.white,
      elevation: 20,
      shadowColor: Colors.black26,
      child: SizedBox(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Nửa bên trái
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabItem(icons[0], 0, context),
                _buildTabItem(icons[1], 1, context),
              ],
            ),
            // Nửa bên phải
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTabItem(icons[2], 2, context),
                _buildTabItem(icons[3], 3, context),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(IconData icon, int index, BuildContext context) {
    return MaterialButton(
      minWidth: 40,
      onPressed: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.grey),
        ],
      ),
    );
  }
}
