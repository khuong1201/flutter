# Bài 3: Menu Bên (Drawer) Hiện Đại và 3D

Ngăn kéo (Drawer) mặc định của Flutter trượt từ cạnh trái ra đen thui một mảng lớn. Nó vẫn xài tốt cho App quản lý nội bộ, nhưng đối với các App hướng tới người dùng trẻ trung (App game, Music player), người ta dùng **Hidden Drawer (Ngăn kéo ẩn)** hoặc **3D Zoom Drawer**.

Bản chất của các kiểu Menu này: Menu thực chất nằm lót phía DƯỚI đáy màn hình chính. Khi bạn bấm nút Menu, cái màn hình chính (Trang chủ) sẽ **thu nhỏ lại và bị đẩy trượt sang một bên**, để lộ ra Menu ở đằng sau lưng nó.

## 1. 3D Zoom Drawer (Giao diện đẩy màn hình)

Thư viện khuyên dùng: `flutter_zoom_drawer`

**Cài đặt:**
```yaml
dependencies:
  flutter_zoom_drawer: ^3.1.1
```

**Cách triển khai:**
Thay vì `Scaffold` nằm ngoài cùng, bạn dùng `ZoomDrawer` bọc lấy 2 phần: Màn hình Menu (Lót dưới) và Màn hình Chính (Trang chủ, nằm trên).

```dart
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class ModernDrawerScreen extends StatelessWidget {
  final ZoomDrawerController _drawerController = ZoomDrawerController();

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: _drawerController,
      // Hiệu ứng đẩy 3D góc bo tròn
      style: DrawerStyle.defaultStyle, 
      
      // Độ nghiêng xoay không gian 3D
      angle: -12.0, 
      
      showShadow: true, // Đổ bóng râm từ màn hình chính xuống Menu
      backgroundColor: Colors.orangeAccent,
      slideWidth: MediaQuery.of(context).size.width * 0.65,
      
      // 1. MÀN HÌNH MENU Ở DƯỚI
      menuScreen: Scaffold(
        backgroundColor: Colors.indigo,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
               Text("MENU", style: TextStyle(color: Colors.white, fontSize: 30)),
               ListTile(leading: Icon(Icons.home, color: Colors.white), title: Text("Trang chủ", style: TextStyle(color: Colors.white))),
               ListTile(leading: Icon(Icons.settings, color: Colors.white), title: Text("Cài đặt", style: TextStyle(color: Colors.white))),
            ],
          ),
        ),
      ),
      
      // 2. MÀN HÌNH CHÍNH Ở TRÊN (Bị thu nhỏ và xê dịch khi mở Menu)
      mainScreen: Scaffold(
        appBar: AppBar(
          title: Text("Trang chủ App"),
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              // Bấm nút để đóng/mở Menu thu nhỏ 3D
              _drawerController.toggle?.call();
            },
          ),
        ),
        body: Center(child: Text("Nội dung màn hình chính", style: TextStyle(fontSize: 24))),
      ),
    );
  }
}
```

## 2. Hidden Drawer (Ngăn kéo trượt thẻ)
Khá giống ZoomDrawer nhưng hiệu ứng chuyển động giống hệt như lấy các tờ giấy xếp so le nhau.

Thư viện: `hidden_drawer_menu`

**Ưu điểm của Hidden Drawer & Zoom Drawer:**
- Trông cực kỳ sành điệu, "Hack não" người dùng (Wow Effect).
- Tránh việc cái bóng đen che khuất màn hình gốc 100%, người dùng vẫn có cảm giác không gian app nối liền nhau.

**Nhược điểm:**
- Chỉ nên dùng ở màn hình Home (Trang chủ đầu tiên). Tránh dùng ở trang chi tiết con sẽ làm rối luồng điều hướng của người dùng.
