# Bài 4: Sử Dụng Rive Và Lottie Cho Hoạt Hình Phức Tạp

Đôi khi Designer vẽ ra một con gấu đang nhảy múa hoặc một cái hòm châu báu mở ra cực kỳ phức tạp. Bạn KHÔNG THỂ viết code thủ công bằng `AnimationController` cho từng cái chân, cái tay của con gấu được.

Đó là lúc chúng ta nhờ đến các thư viện thứ 3 xuất file trực tiếp từ phần mềm thiết kế (After Effects, Rive) đưa thẳng vào Flutter.

## 1. Lottie (Của AirBnb)
Lottie hỗ trợ xuất file dạng JSON từ Adobe After Effects. Dành cho các hình hoạt hình truyền thống. Cực nhẹ và cực mượt.

**Cài đặt:**
```yaml
dependencies:
  lottie: ^2.6.0
```

**Sử dụng:**
Tải một file `loading.json` từ Lottiefiles.com, để vào thư mục `assets` của dự án.
```dart
import 'package:lottie/lottie.dart';

class LoadingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      // Hiển thị file Lottie, nó tự động lặp lại liên tục
      child: Lottie.asset('assets/loading.json', width: 200, height: 200),
      
      // Hoặc lấy trực tiếp từ Internet
      // child: Lottie.network('https://.../file.json'),
    );
  }
}
```

## 2. Rive (Tương lai của Hoạt hình UI)
Rive mạnh mẽ hơn Lottie ở chỗ: Rive **có tính tương tác (Interactive)**.
Nghĩa là con gấu Rive có thể nhìn theo ngón tay người dùng chạm trên màn hình, hoặc khi người dùng nhập sai mật khẩu, con gấu Rive sẽ lắc đầu. Rive cho phép Designer tạo các Trạng thái (State Machine) gắn thẳng vào file vẽ (đuôi `.riv`).

**Cài đặt:**
```yaml
dependencies:
  rive: ^0.11.12
```

**Sử dụng Rive Cơ Bản:**
```dart
import 'package:rive/rive.dart';

class TeddyLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 300,
        height: 300,
        // Chạy file .riv tải từ rive.app
        child: RiveAnimation.asset(
          'assets/teddy.riv',
          stateMachines: ['Login Machine'], // Gọi tên logic Machine mà Designer đã setup
        ),
      ),
    );
  }
}
```
*Gợi ý: Tìm từ khoá "Flutter Rive Login" trên Youtube để xem con gấu che mắt cực nổi tiếng.*
