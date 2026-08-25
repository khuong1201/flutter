# Bài 4: Nút Bấm Nổi Mở Rộng (Expandable FAB / Speed Dial)

Nút tròn lơ lửng góc dưới bên phải (Floating Action Button - FAB) là đặc sản của Google Material Design. Tuy nhiên, nếu bạn chỉ gắn 1 nút (+) vào đó thì hơi lãng phí khoảng không.

Hiện nay, các App như Evernote, Ngân hàng thường dùng hiệu ứng **Speed Dial**: Khi bấm vào nút (+), thay vì chuyển trang, cái nút (+) sẽ xoay vòng thành hình chữ (X) và đồng thời "bung" thêm 3-4 cái nút nhỏ khác chui từ dưới lên.

## 1. Sử dụng thư viện `flutter_speed_dial`

Thư viện này cung cấp một cái nút FAB bung xoè với hiệu ứng rất mượt, có cả tính năng hiện nhãn (Label) cho từng nút con.

**Cài đặt:**
```yaml
dependencies:
  flutter_speed_dial: ^3.0.5
```

**Cách dùng trong Scaffold:**
```dart
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

Scaffold(
  body: Center(child: Text("Màn hình chính")),
  
  // Trỏ thẳng floatingActionButton vào widget SpeedDial
  floatingActionButton: SpeedDial(
    animatedIcon: AnimatedIcons.menu_close, // Icon tự xoay từ Menu sang Dấu X
    animatedIconTheme: IconThemeData(size: 22.0),
    backgroundColor: Colors.blueAccent,
    visible: true,
    curve: Curves.bounceIn, // Hiệu ứng bung ra như lò xo
    
    // Nút FAB sẽ mờ cả nền đằng sau lại khi đang mở (Tập trung điểm nhìn)
    overlayColor: Colors.black,
    overlayOpacity: 0.5,
    
    // Danh sách các nút con bung ra
    children: [
      SpeedDialChild(
        child: Icon(Icons.accessibility, color: Colors.white),
        backgroundColor: Colors.red,
        onTap: () => print('Bấm Thêm Khách Hàng'),
        label: 'Khách hàng', // Dòng chữ hiện ra cạnh nút
        labelStyle: TextStyle(fontWeight: FontWeight.w500),
      ),
      SpeedDialChild(
        child: Icon(Icons.brush, color: Colors.white),
        backgroundColor: Colors.green,
        onTap: () => print('Bấm Tạo Mới'),
        label: 'Sản phẩm mới',
      ),
    ],
  ),
)
```

## 2. FAB Trượt Lên Giấu Đi Khi Cuộn
Theo chuẩn UI/UX, khi người dùng cuộn nội dung (ListView) để đọc báo hoặc lướt Feed dài dằng dặc, cái nút FAB lơ lửng góc dưới sẽ GÂY CHE KHUẤT chữ bên dưới.

Do đó, bạn phải viết logic: **Hễ cuộn xuống (Vuốt lên trên) -> Ẩn nút FAB đi. Hễ cuộn ngược lên (Vuốt xuống dưới) -> Hiện nút FAB lại.**

Trong Flutter, bạn có thể tự làm bằng cách lắng nghe sự kiện `NotificationListener<ScrollNotification>` hoặc dùng các thư viện xịn như `hidable` để bọc cái nút FAB lại là xong. Không bao giờ để nút FAB "trơ lì" dính mặt vào nội dung đang cuộn nhé!
