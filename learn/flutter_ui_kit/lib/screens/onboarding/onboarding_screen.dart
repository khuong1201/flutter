import 'package:flutter/material.dart';
import '../dashboard/dashboard_screen.dart';
import '../../components/buttons/bouncing_button.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  double _pageOffset = 0.0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _pageOffset = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Background Parallax
          Positioned(
            left: -(_pageOffset * 50), // Di chuyển nền chậm hơn
            top: 0,
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width * 2,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF1E1E2C), Color(0xFF000000)],
                ),
              ),
              // Nếu có ảnh nền thực tế, hãy dùng:
              // child: Image.network('...', fit: BoxFit.cover),
            ),
          ),

          // Nội dung PageView
          PageView(
            controller: _pageController,
            children: const [
              _OnboardingPage(
                title: "Khám Phá\nTài Chính",
                subtitle: "Quản lý chi tiêu dễ dàng với giao diện hiện đại.",
                icon: Icons.account_balance_wallet,
              ),
              _OnboardingPage(
                title: "Thanh Toán\nSiêu Tốc",
                subtitle: "Giao dịch an toàn và mượt mà trong nháy mắt.",
                icon: Icons.rocket_launch,
              ),
              _OnboardingPage(
                title: "Bảo Mật\nTuyệt Đối",
                subtitle: "Dữ liệu của bạn luôn được mã hoá và an toàn.",
                icon: Icons.security,
              ),
            ],
          ),

          // Nút Bắt đầu nổi
          Positioned(
            bottom: 50,
            right: 30,
            child: BouncingButton(
              onTap: () {
                if (_pageController.page == 2) {
                  // Chuyển sang Dashboard
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                  );
                } else {
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: const Row(
                  children: [
                    Text("Tiếp theo", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _OnboardingPage extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;

  const _OnboardingPage({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 100, color: Colors.white70),
          const SizedBox(height: 40),
          Text(
            title,
            style: const TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.w900,
              color: Colors.white,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white54,
            ),
          ),
        ],
      ),
    );
  }
}
