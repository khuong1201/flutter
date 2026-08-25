import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import '../../components/cards/glass_card.dart';
import '../../components/navigation/floating_bottom_nav.dart';
import '../../components/overlays/modern_bottom_sheet.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Cho phép body cuộn xuống dưới Bottom Nav
      backgroundColor: const Color(0xFFF5F7FA), // Màu xám nhạt hiện đại
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Chào buổi sáng,", style: TextStyle(color: Colors.grey, fontSize: 14)),
                    Text("Tuấn Nguyễn", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Colors.black87)),
                  ],
                ),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 5))
                    ]
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.notifications_none_rounded, color: Colors.black87),
                    onPressed: () {
                      showModernBottomSheet(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100), // Padding đáy chừa chỗ cho Bottom Nav
        children: [
          // Thẻ tín dụng Glassmorphism
          const GlassCard(
            title: "Tổng số dư",
            amount: "\$24,500.00",
            cardNumber: "**** **** **** 1234",
          ),
          const SizedBox(height: 30),
          
          const Text("Thống Kê", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black87)),
          const SizedBox(height: 16),

          // Lưới Bento Grid
          StaggeredGrid.count(
            crossAxisCount: 4,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            children: const [
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: BentoBox(
                  color: Color(0xFFE3F2FD),
                  icon: Icons.arrow_downward_rounded,
                  iconColor: Colors.blue,
                  title: "Thu nhập",
                  value: "+\$4,500",
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 2,
                mainAxisCellCount: 2,
                child: BentoBox(
                  color: Color(0xFFFFEBEE),
                  icon: Icons.arrow_upward_rounded,
                  iconColor: Colors.red,
                  title: "Chi tiêu",
                  value: "-\$1,200",
                ),
              ),
              StaggeredGridTile.count(
                crossAxisCellCount: 4,
                mainAxisCellCount: 2,
                child: BentoBox(
                  color: Colors.white,
                  icon: Icons.pie_chart_rounded,
                  iconColor: Colors.purple,
                  title: "Mục tiêu tài chính",
                  value: "Đạt 75%",
                ),
              ),
            ],
          )
        ],
      ),
      bottomNavigationBar: const FloatingBottomNav(),
    );
  }
}

class BentoBox extends StatelessWidget {
  final Color color;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;

  const BentoBox({
    super.key,
    required this.color,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: color == Colors.white ? Colors.black.withOpacity(0.05) : color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color == Colors.white ? Colors.grey[100] : Colors.white.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.black54, fontSize: 14)),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 22, color: Colors.black87)),
            ],
          )
        ],
      ),
    );
  }
}
