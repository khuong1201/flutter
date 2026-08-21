# Bài 2: Sử Dụng Provider Cơ Bản Đến Nâng Cao

Provider là công cụ quản lý state phổ biến và "chính thống" (được Google khuyên dùng). Mặc dù hiện nay nhiều người chuyển sang Riverpod (do cùng tác giả), Provider vẫn chiếm số lượng dự án rất lớn.

Bản chất của Provider là gói gọn `InheritedWidget` để chia sẻ dữ liệu dễ dàng hơn.

## 1. Cài đặt
Thêm thư viện vào `pubspec.yaml`:
```yaml
dependencies:
  provider: ^6.1.1
```

## 2. Tạo một State (ChangeNotifier)
Chúng ta tạo một class kế thừa từ `ChangeNotifier`. Khi nào dữ liệu thay đổi, ta gọi `notifyListeners()` để báo cho UI biết.

```dart
import 'package:flutter/material.dart';

class CounterProvider extends ChangeNotifier {
  int _count = 0;
  int get count => _count; // Chỉ cho phép đọc từ bên ngoài

  void increment() {
    _count++;
    notifyListeners(); // Kêu gọi tất cả widget lắng nghe hãy vẽ lại
  }
}
```

## 3. Cung cấp State cho UI (MultiProvider)
Thường ta sẽ bọc Provider ở cấp cao nhất của App (`main.dart`).

```dart
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CounterProvider()),
        // Khai báo thêm UserProvider, CartProvider ở đây
      ],
      child: MyApp(),
    ),
  );
}
```

## 4. Lắng nghe và Cập nhật UI (Consumer vs context.read)
Làm sao để màn hình hiển thị được số `count`?

**Cách 1: `context.watch()` - Lắng nghe toàn bộ màn hình**
```dart
Widget build(BuildContext context) {
  // BẤT KỲ khi nào count thay đổi, TOÀN BỘ hàm build này chạy lại
  final counter = context.watch<CounterProvider>(); 
  return Text('${counter.count}');
}
```
*-> Khuyết điểm: Dễ gây giật lag nếu màn hình to, vì nó vẽ lại toàn bộ.*

**Cách 2: `Consumer` - Chỉ vẽ lại vùng cần thiết (Khuyên dùng)**
```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      // Chỉ vẽ lại thẻ Text bên trong này
      child: Consumer<CounterProvider>(
        builder: (context, provider, child) {
          return Text('${provider.count}');
        },
      ),
    ),
    floatingActionButton: FloatingActionButton(
      onPressed: () {
        // Chỉ gọi hàm, KHÔNG lắng nghe sự thay đổi UI -> Dùng context.read()
        context.read<CounterProvider>().increment();
      },
      child: Icon(Icons.add),
    ),
  );
}
```

## 5. Kinh nghiệm thực chiến
- **Tuyệt đối không dùng `context.watch()` bên trong hàm xử lý sự kiện (onPressed, onTap)**. Nếu cần gọi hàm từ provider, LUÔN LUÔN dùng `context.read()`.
- **Selector**: Nếu Provider của bạn chứa nhiều biến (tên, tuổi, địa chỉ), mà màn hình chỉ cần hiện "tuổi", hãy dùng `Selector`. Khi đổi "tên", màn hình hiện "tuổi" sẽ không bị vẽ lại oan uổng.

```dart
Selector<UserProvider, int>(
  selector: (context, provider) => provider.age,
  builder: (context, age, child) {
    return Text('Tuổi: $age');
  },
);
```
