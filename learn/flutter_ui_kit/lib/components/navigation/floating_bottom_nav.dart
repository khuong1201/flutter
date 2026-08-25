import 'package:flutter/material.dart';

class FloatingBottomNav extends StatefulWidget {
  const FloatingBottomNav({super.key});

  @override
  State<FloatingBottomNav> createState() => _FloatingBottomNavState();
}

class _FloatingBottomNavState extends State<FloatingBottomNav> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20, bottom: 20), // Tạo lơ lửng
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed, // Không bị giật chữ khi có nhiều item
          showSelectedLabels: false,
          showUnselectedLabels: false,
          currentIndex: _currentIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Colors.grey[400],
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            _buildNavItem(Icons.home_rounded, 0),
            _buildNavItem(Icons.bar_chart_rounded, 1),
            _buildNavItem(Icons.account_balance_wallet_rounded, 2),
            _buildNavItem(Icons.person_rounded, 3),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData icon, int index) {
    // Thêm hiệu ứng viên thuốc nhỏ (Pill) ở dưới Icon đang chọn
    return BottomNavigationBarItem(
      icon: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 4),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOutCubic,
            height: 4,
            width: _currentIndex == index ? 20 : 0,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          )
        ],
      ),
      label: '',
    );
  }
}
