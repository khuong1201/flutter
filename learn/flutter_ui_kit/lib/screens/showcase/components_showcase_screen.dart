import 'package:flutter/material.dart';
import '../../components/carousels/parallax_carousel.dart';
import '../../components/inputs/modern_textfield.dart';
import '../../components/inputs/neumorphic_slider.dart';
import '../../components/switches/animated_switch.dart';
import '../../components/loaders/shimmer_loading.dart';
import '../../components/avatars/stacked_avatars.dart';
import '../../components/overlays/dynamic_island.dart';
import '../../components/cards/animated_gradient_border.dart';
import '../../components/cards/perforated_ticket.dart';
import '../../components/cards/morphing_hero_card.dart';
import '../../components/navigation/liquid_pull_wrapper.dart';
import '../../components/magic/scratch_and_win.dart';
import '../../components/magic/magnetic_button.dart';
import '../../components/magic/glitch_text.dart';
import '../../components/magic/tilt_3d_card.dart';
import '../../components/navigation/hidden_3d_drawer.dart';
import '../../components/buttons/exploding_radial_menu.dart';
import '../../components/navigation/gooey_tab_bar.dart';
import '../../components/inputs/claymorphic_keypad.dart';
import '../../components/cards/flip_3d_card.dart';
import '../../components/loaders/water_fill_progress.dart';
import '../../components/overlays/spotlight_effect.dart';
import '../../components/magic/origami_fold.dart';
import '../../components/carousels/tinder_swipe_deck.dart';
import '../../components/navigation/curved_bottom_nav.dart';
import 'dart:ui'; // Bắt buộc cho BackdropFilter

class ComponentsShowcaseScreen extends StatefulWidget {
  const ComponentsShowcaseScreen({super.key});

  @override
  State<ComponentsShowcaseScreen> createState() => _ComponentsShowcaseScreenState();
}

class _ComponentsShowcaseScreenState extends State<ComponentsShowcaseScreen> {
  double _sliderValue = 0.5;

  final List<String> _carouselImages = [
    'asset_carousel_1',
    'asset_carousel_2',
    'asset_carousel_3',
  ];

  final List<String> _avatarImages = [
    'avatar_1',
    'avatar_2',
    'avatar_3',
    'avatar_4',
    'avatar_5',
    'avatar_6',
  ];

  @override
  Widget build(BuildContext context) {
    // Scaffold chính của phòng trưng bày
    final mainScreen = Scaffold(
      extendBodyBehindAppBar: true, // Để nền chui xuống dưới AppBar
      backgroundColor: Colors.transparent, // Nền sẽ do Stack phía sau quyết định
      appBar: AppBar(
        title: const Text('Kho Đồ Chơi UI', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Tạo Glassmorphism AppBar
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.black.withOpacity(0.2)),
          ),
        ),
        leading: Builder(
          builder: (context) {
            // Nút mở Drawer (Sẽ gọi lên cây Widget để tìm Hidden3DDrawerState)
            return IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {
                context.findAncestorStateOfType<Hidden3DDrawerState>()?.toggleDrawer();
              },
            );
          },
        ),
      ),
      // Tích hợp Curved Bottom Nav (Giai đoạn 6)
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: CurvedBottomNav(
        icons: const [Icons.home, Icons.search, Icons.favorite, Icons.person],
        onTabSelected: (index) {},
        onFabTapped: () {},
      ),
      body: Stack(
        children: [
          // Nền Mesh Gradient thời thượng
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFff9a9e), Color(0xFFfecfef), Color(0xFFa18cd1)], // Hồng đào -> Xanh tím
              ),
            ),
          ),
          
          LiquidPullWrapper(
            onRefresh: () async {
              await Future.delayed(const Duration(seconds: 2));
            },
            child: ListView(
              padding: const EdgeInsets.only(top: 100, bottom: 20),
              children: [
                // Cụm Giai đoạn 6: The Final Bosses
                _buildSectionTitle('🌟 1. Đèn Pin Rọi Điểm (Vuốt ngón tay)'),
                const Center(
                  child: SizedBox(
                    width: double.infinity,
                    height: 200,
                    child: SpotlightEffect(
                      child: Center(
                        child: Text("BÍ MẬT ẨN GIẤU", style: TextStyle(color: Colors.white, fontSize: 36, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('🌟 2. Tinder Swipe Deck (Quẹt thẻ)'),
                TinderSwipeDeck(
                  cards: [
                    Container(color: Colors.red, child: const Center(child: Text("Thẻ 1", style: TextStyle(color: Colors.white, fontSize: 30)))),
                    Container(color: Colors.green, child: const Center(child: Text("Thẻ 2", style: TextStyle(color: Colors.white, fontSize: 30)))),
                    Container(color: Colors.blue, child: const Center(child: Text("Thẻ 3", style: TextStyle(color: Colors.white, fontSize: 30)))),
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('🌟 3. Thẻ Ngân Hàng 3D Lật'),
                Center(
                  child: Flip3DCard(
                    front: _buildCreditCard(Colors.blueGrey, "MẶT TRƯỚC"),
                    back: _buildCreditCard(Colors.grey, "CVV: 123", isBack: true),
                  ),
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('🌟 4. Bóng Nước Loading'),
                const Center(child: WaterFillProgress(progress: 0.65)), // Hiển thị 65%

                const SizedBox(height: 40),
                _buildSectionTitle('🌟 5. Bản Đồ Gập Giấy (Bấm vào)'),
                Center(
                  child: OrigamiFold(
                    child: Container(
                      width: 300,
                      height: 300,
                      color: Colors.brown[300],
                      child: const Center(child: Icon(Icons.map, size: 100, color: Colors.white)),
                    ),
                  ),
                ),

                const SizedBox(height: 60),
                // Cụm Giai đoạn 5
                _buildSectionTitle('💎 1. Bàn phím Bọt Biển (Claymorphism)'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: ClaymorphicKeypad(
                    onKeyPressed: (val) {
                      print("Bấm phím: $val");
                    },
                  ),
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('💎 2. Gooey Tab Bar'),
                GooeyTabBar(
                  icons: const [Icons.home, Icons.search, Icons.favorite, Icons.person],
                  onTabChanged: (index) {},
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('💎 3. Exploding Radial Menu'),
                Center(
                  child: ExplodingRadialMenu(
                    icons: const [Icons.camera, Icons.photo, Icons.mic, Icons.map],
                    onItemSelected: (index) {},
                  ),
                ),

                const SizedBox(height: 60),
                // Cụm Ma thuật UI (Giai đoạn 4)
                _buildSectionTitle('🔮 1. Thẻ 3D Chao Đảo (Vuốt lên thẻ)'),
            const Center(
              child: Tilt3DCard(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [Colors.orange, Colors.deepOrange]),
                  ),
                  child: Center(child: Icon(Icons.ac_unit, size: 80, color: Colors.white)),
                ),
              ),
            ),

            const SizedBox(height: 40),
            _buildSectionTitle('🔮 2. Nút Bấm Từ Tính (Chạm & Vuốt nhẹ)'),
            Center(
              child: MagneticButton(
                onTap: () {
                  print("Đã bấm nút từ tính");
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text("Bấm thử xem", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ),
            ),

            const SizedBox(height: 40),
            _buildSectionTitle('🔮 3. Chữ Nhiễu Sóng Cyberpunk'),
            Container(
              color: Colors.black87,
              padding: const EdgeInsets.all(20),
              child: const Center(
                child: GlitchText(
                  text: "CYBERPUNK 2077",
                  style: TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w900, letterSpacing: 5),
                ),
              ),
            ),

            const SizedBox(height: 40),
            _buildSectionTitle('🔮 4. Thẻ Cào Trúng Thưởng (Cào để nhận)'),
            const Center(child: ScratchAndWin()),

            const SizedBox(height: 60),
            // Cụm Behance Collection (Giai đoạn 3)
            _buildSectionTitle('🏝️ Dynamic Island'),
            const Center(child: DynamicIsland()),
            const SizedBox(height: 20),
            
            _buildSectionTitle('🌟 Morphing Hero Card (Nhấn vào thẻ)'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: MorphingHeroCard(
                closedWidget: Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Center(child: Text("Nhấn để bung rộng (Hero)", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                ),
                openWidget: Scaffold(
                  appBar: AppBar(title: const Text('Chi Tiết')),
                  body: const Center(child: Text('Đã bung toàn màn hình cực mượt!')),
                ),
              ),
            ),
            
            const SizedBox(height: 40),
            _buildSectionTitle('🌟 Animated Gradient Border & Ticket'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  const Expanded(
                    child: AnimatedGradientBorder(
                      child: Padding(
                        padding: EdgeInsets.all(20.0),
                        child: Text("Thẻ VIP\nPhát Sáng", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PerforatedTicket(
                      child: Column(
                        children: const [
                          Text("VÉ XEM PHIM", style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 8),
                          Icon(Icons.qr_code_2, size: 40),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            _buildSectionTitle('1. Parallax Carousel (Trượt 3D)'),
          ParallaxCarousel(images: _carouselImages),

          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('2. Modern TextField'),
                const ModernTextField(
                  label: 'Nhập email của bạn',
                  icon: Icons.email_outlined,
                ),
                
                const SizedBox(height: 40),
                _buildSectionTitle('3. Animated Switch'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Kích hoạt Dark Mode', style: TextStyle(fontSize: 16)),
                    AnimatedSwitch(
                      onChanged: (val) {
                        // Chuyển đổi trạng thái
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('4. Shimmer Loading (Skeleton)'),
                const Row(
                  children: [
                    ShimmerLoading(width: 60, height: 60, borderRadius: 30), // Hình tròn giả Avatar
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ShimmerLoading(width: 200, height: 16), // Dòng chữ 1
                        SizedBox(height: 8),
                        ShimmerLoading(width: 150, height: 16), // Dòng chữ 2
                      ],
                    )
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('5. Stacked Avatars (Chồng ảnh)'),
                Row(
                  children: [
                    StackedAvatars(imageUrls: _avatarImages, size: 45),
                    const SizedBox(width: 16),
                    const Text('đã thả tim', style: TextStyle(color: Colors.grey, fontSize: 16)),
                  ],
                ),

                const SizedBox(height: 40),
                _buildSectionTitle('6. Neumorphic Slider'),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE0E5EC), // Màu nền chuẩn Neumorphic
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: NeumorphicSlider(
                    value: _sliderValue,
                    onChanged: (val) {
                      setState(() {
                        _sliderValue = val;
                      });
                    },
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        ],
      ),
          )
        ],
      ),
    );

    // Gói toàn bộ vào Hidden3DDrawer
    return Hidden3DDrawer(
      drawerContent: Container(
        color: const Color(0xFF1E1E2C), // Màu nền menu
        padding: const EdgeInsets.only(top: 80, left: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white24,
              child: Icon(Icons.person, size: 40, color: Colors.white),
            ),
            const SizedBox(height: 20),
            const Text("Trần Huỳnh", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 40),
            _buildDrawerItem(Icons.home, "Trang chủ"),
            _buildDrawerItem(Icons.settings, "Cài đặt"),
            _buildDrawerItem(Icons.star, "Đánh giá App"),
            _buildDrawerItem(Icons.logout, "Đăng xuất"),
          ],
        ),
      ),
      mainScreen: mainScreen,
    );
  }

  Widget _buildDrawerItem(IconData icon, String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          const SizedBox(width: 15),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 18)),
        ],
      ),
    );
  }

  // Hàm tạo giao diện thẻ ngân hàng giả
  Widget _buildCreditCard(Color color, String text, {bool isBack = false}) {
    return Container(
      width: 320,
      height: 200,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5))],
      ),
      child: isBack
          ? Column(
              children: [
                Container(height: 40, color: Colors.black87, margin: const EdgeInsets.only(top: 10, bottom: 20)),
                Container(height: 30, color: Colors.white, alignment: Alignment.centerRight, padding: const EdgeInsets.only(right: 10), child: Text(text, style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold))),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Icon(Icons.contactless, color: Colors.white, size: 30),
                Text(text, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold, letterSpacing: 2)),
              ],
            ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16, left: 20, right: 20),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.white, // Đổi sang chữ trắng để nổi trên nền Gradient
          shadows: [Shadow(color: Colors.black45, blurRadius: 4, offset: Offset(1, 1))],
        ),
      ),
    );
  }
}
