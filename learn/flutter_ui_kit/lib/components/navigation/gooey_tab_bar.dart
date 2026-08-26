import 'package:flutter/material.dart';

class GooeyTabBar extends StatefulWidget {
  final List<IconData> icons;
  final ValueChanged<int> onTabChanged;

  const GooeyTabBar({
    super.key,
    required this.icons,
    required this.onTabChanged,
  });

  @override
  State<GooeyTabBar> createState() => _GooeyTabBarState();
}

class _GooeyTabBarState extends State<GooeyTabBar> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 20, offset: Offset(0, 10))
        ],
      ),
      child: Stack(
        children: [
          // Gooey Indicator (Lớp nền di chuyển mượt)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut, // Hiệu ứng kéo dãn lò xo
            left: _calculateIndicatorPosition(context),
            top: 10,
            bottom: 10,
            child: Container(
              width: 50,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(25),
              ),
            ),
          ),
          
          // Các Icon tĩnh
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(widget.icons.length, (index) {
              final isSelected = _selectedIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onTabChanged(index);
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 50,
                  child: Center(
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: EdgeInsets.only(bottom: isSelected ? 10 : 0), // Nhảy lên một chút
                      child: Icon(
                        widget.icons[index],
                        color: isSelected ? Theme.of(context).colorScheme.primary : Colors.grey,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  double _calculateIndicatorPosition(BuildContext context) {
    // Tính toán tọa độ của giọt nước theo chiều rộng màn hình
    final totalWidth = MediaQuery.of(context).size.width - 40; // Trừ margin 2 bên
    final sectionWidth = totalWidth / widget.icons.length;
    // Đẩy indicator vào giữa khu vực của tab
    return (sectionWidth * _selectedIndex) + (sectionWidth / 2) - 25; // 25 là một nửa chiều rộng của indicator
  }
}
