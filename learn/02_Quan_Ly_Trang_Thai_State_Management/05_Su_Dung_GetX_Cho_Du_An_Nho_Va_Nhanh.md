# Bài 5: GetX Cho Dự Án Nhỏ, Build Nhanh Chóng

GetX là một thư viện "Tất cả trong một" (All-in-one). Nó không chỉ quản lý State mà còn quản lý Router (Chuyển trang), Quản lý Dependency (Tiêm biến), Quản lý Ngôn ngữ (Đa ngôn ngữ).

GetX cực kỳ phổ biến vì nó viết code **rất ngắn**, không cần Context (BuildContext), và rất dễ học. Nhược điểm của GetX là nó "vượt quyền" Flutter quá nhiều (không dùng Context), khiến code trở nên khó bảo trì nếu dự án quá lớn.

## 1. Cài đặt
```yaml
dependencies:
  get: ^4.6.6
```
Bắt buộc đổi `MaterialApp` thành `GetMaterialApp` trong file `main.dart`:
```dart
void main() {
  runApp(GetMaterialApp(home: HomeScreen()));
}
```

## 2. Quản lý State với GetX (Reactive State)
Để biến một biến bình thường thành Reactive (Biến có thể tự update UI khi đổi giá trị), ta thêm `.obs` vào cuối.

```dart
import 'package:get/get.dart';

class CounterController extends GetxController {
  // Thêm .obs (observable) vào để GetX lắng nghe
  var count = 0.obs; 
  
  // Dành cho kiểu dữ liệu phức tạp
  var user = User(name: 'A').obs;

  void increment() {
    count.value++; // Phải gọi .value để lấy/gán giá trị
  }
}
```

## 3. Hiển thị UI bằng `Obx`
Obx (Observer) là widget ma thuật của GetX. Bất kỳ biến `.obs` nào nằm trong Obx thay đổi, Obx sẽ tự động render lại.

```dart
class HomeScreen extends StatelessWidget {
  // Khởi tạo Controller. (Get.put tương tự như việc tạo Singleton)
  final CounterController controller = Get.put(CounterController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("GetX Reactive")),
      body: Center(
        // Bọc Widget nào cần thay đổi bằng Obx
        child: Obx(() => Text(
          "Số đếm: ${controller.count.value}",
          style: TextStyle(fontSize: 30),
        )),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Gọi thẳng hàm không cần context
          controller.increment();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
```

## 4. Chuyển trang và Hiển thị Popup (Không cần Context)
Đây là tính năng làm nên tên tuổi của GetX. Bạn có thể code logic ở file class riêng mà vẫn gọi được Dialog (Không cần truyền `context`).

**Chuyển trang (Routing):**
```dart
// Thay vì Navigator.push(context, MaterialPageRoute(...))
Get.to(DetailScreen());

// Quay về màn trước (pop)
Get.back();
```

**Hiển thị Snackbar báo lỗi:**
```dart
// Thay vì ScaffoldMessenger.of(context).showSnackBar(...)
Get.snackbar(
  "Thành công", 
  "Lưu dữ liệu thành công!",
  snackPosition: SnackPosition.BOTTOM,
);
```

**Hiển thị Dialog:**
```dart
Get.defaultDialog(
  title: "Cảnh báo",
  middleText: "Bạn có chắc muốn xóa?",
  textConfirm: "OK",
  onConfirm: () => Get.back(),
);
```

> **Tổng kết:** GetX sinh ra dành cho các dự án Startup cần ra mắt siêu tốc. Tuy nhiên, nếu bạn join vào một công ty làm Product dài hạn, họ thường ưu tiên BLoC hoặc Riverpod hơn để đảm bảo tính minh bạch của `BuildContext`.
