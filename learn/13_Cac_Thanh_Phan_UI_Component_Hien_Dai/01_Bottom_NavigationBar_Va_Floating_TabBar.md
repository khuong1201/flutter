# Bài 1: Bottom Navigation Bar Hiện Đại

Thanh điều hướng dưới đáy (Bottom Navigation Bar) là thành phần không thể thiếu của 99% app Mobile. Ngày nay, thay vì một thanh ngang cứng đơ, các designer chuộng các kiểu Floating (Nổi), Curved (Lõm xuống) hoặc có hiệu ứng mượt mà khi chọn.

## 1. Floating Bottom Nav (Thanh điều hướng lơ lửng)
Thay vì chạm sát đáy màn hình, thanh nav nổi lên một chút, bo tròn mạnh 2 đầu và có bóng râm (Shadow). Trông rất giống Dynamic Island nhưng đặt ở dưới.

**Cách làm bằng Flutter gốc:**
Bạn dùng `BottomAppBar` hoặc gói nó trong một `Container` có margin và viền bo tròn.

```dart
Scaffold(
  // Quan trọng: Cho phép body chui xuống dưới cả BottomNav
  extendBody: true, 
  body: Center(child: Text("Nội dung chính")),
  
  bottomNavigationBar: Container(
    margin: EdgeInsets.all(20), // Tạo khoảng cách để lơ lửng
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30), // Bo tròn như viên thuốc
      boxShadow: [
        BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 5)),
      ],
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BottomNavigationBar(
        backgroundColor: Colors.transparent, // Bắt buộc để thấy màu của Container
        elevation: 0,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    ),
  ),
)
```

## 2. Google Nav Bar (GNav) - Hiệu ứng viên thuốc xịn xò
Rất nhiều App đang dùng kiểu khi chọn 1 tab, cái tab đó sẽ bọc trong một "viên thuốc" (Pill) và hiện chữ ra, còn các tab khác chỉ hiện mỗi icon.

Thư viện: `google_nav_bar`

```dart
import 'package:google_nav_bar/google_nav_bar.dart';

bottomNavigationBar: Container(
  color: Colors.white,
  child: Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20),
    child: GNav(
      backgroundColor: Colors.white,
      color: Colors.grey, // Màu lúc chưa chọn
      activeColor: Colors.white, // Màu icon lúc được chọn
      tabBackgroundColor: Colors.black, // Màu "viên thuốc"
      gap: 8, // Khoảng cách giữa icon và chữ
      padding: EdgeInsets.all(16),
      tabs: const [
        GButton(icon: Icons.home, text: 'Home'),
        GButton(icon: Icons.favorite_border, text: 'Likes'),
        GButton(icon: Icons.search, text: 'Search'),
        GButton(icon: Icons.person, text: 'Profile'),
      ],
    ),
  ),
)
```

## 3. Curved Navigation Bar (Thanh đáy lõm có nút bay lên)
Hiệu ứng khi bạn bấm 1 tab, cái nền màu trắng nó "lõm" xuống giống như một giọt nước, đẩy cái icon trồi lên trên. 

Thư viện: `curved_navigation_bar`

```dart
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

bottomNavigationBar: CurvedNavigationBar(
  backgroundColor: Colors.blueAccent, // Bắt buộc phải trùng màu nền của Body
  color: Colors.white, // Màu của cái thanh uốn lượn
  buttonBackgroundColor: Colors.white, // Màu của cái nút bị đẩy lên
  animationDuration: Duration(milliseconds: 300),
  items: const <Widget>[
    Icon(Icons.add, size: 30),
    Icon(Icons.list, size: 30),
    Icon(Icons.compare_arrows, size: 30),
  ],
  onTap: (index) {
    // Xử lý chuyển trang
  },
)
```
*Lưu ý UX: Curved Navigation Bar nhìn rất bắt mắt nhưng có thể hơi "chói" và chiếm diện tích nếu app của bạn là app thiên về đọc báo, tin tức phức tạp. Hãy cân nhắc!*
