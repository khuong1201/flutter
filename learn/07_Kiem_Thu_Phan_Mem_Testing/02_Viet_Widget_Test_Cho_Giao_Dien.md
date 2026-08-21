# Bài 2: Viết Widget Test (Kiểm Thử Giao Diện)

Widget Test dùng để kiểm tra xem một phần giao diện (UI) hoặc một Màn hình cụ thể có hiển thị đúng các thẻ Text, nút bấm không, và khi bấm vào nút thì có chuyển trạng thái không. 
Nó giống Unit Test, chạy rất nhanh (Không cần bật máy ảo Simulator).

## 1. Viết Widget Test cơ bản

Giả sử ta có một Widget đơn giản là nút đếm Counter quen thuộc của Flutter.

Tạo file `test/counter_widget_test.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/main.dart'; // Nơi chứa MyApp()

void main() {
  // Thay vì test(), ta dùng testWidgets()
  testWidgets('Bấm nút cộng sẽ tăng số đếm lên 1', (WidgetTester tester) async {
    
    // 1. Dựng widget lên trong môi trường ảo
    await tester.pumpWidget(const MyApp());

    // 2. Tìm kiếm (Find) widget trên màn hình
    // Lúc đầu, trên màn hình phải có số '0'
    expect(find.text('0'), findsOneWidget); 
    // Màn hình KHÔNG được có số '1'
    expect(find.text('1'), findsNothing); 

    // 3. Tương tác (Act)
    // Giả lập thao tác bấm ngón tay vào cái Icon có hình dấu +
    await tester.tap(find.byIcon(Icons.add));
    
    // Bắt buộc gọi pump() để UI vẽ lại (tương đương gọi setState)
    await tester.pump(); 

    // 4. Kiểm tra lại kết quả (Assert)
    // Màn hình đã biến mất số '0' và hiện lên số '1'
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
```

## 2. Các hàm `Finders` hay dùng trong Widget Test
Để test UI, quan trọng nhất là bạn phải "tìm" được thành phần UI đó.

- `find.text('Xin chào')`: Tìm chữ.
- `find.byKey(Key('login_button'))`: Cực kỳ khuyên dùng. Gắn Key vào Widget gốc và dùng hàm này tìm là chính xác tuyệt đối.
- `find.byType(ElevatedButton)`: Tìm nút bấm. (Tuy nhiên nếu màn hình có 2 nút Elevated thì nó sẽ báo lỗi).
- `find.byIcon(Icons.add)`: Tìm icon.

## 3. Scroll (Cuộn chuột) trong Test
Đôi khi nút bấm nằm tuốt dưới cùng màn hình (Ví dụ form đăng ký quá dài). Bạn gọi lệnh `tester.tap()` nó sẽ báo lỗi là "Nút này chưa được hiển thị trên màn hình". Bạn phải bắt tester cuộn xuống.

```dart
// Kéo ListView lên (hoặc xuống) cho đến khi tìm thấy nút Submit
await tester.dragUntilVisible(
  find.text('Submit'), // Thứ cần tìm
  find.byType(ListView), // Cuộn ở cái ListView nào
  const Offset(0, -200), // Kéo xuống dưới (trục Y âm)
);
```

> **Lời khuyên thực tế:** Viết Widget Test tốn khá nhiều thời gian và đôi khi dễ hỏng (brittle) do designer đổi cấu trúc giao diện. Các công ty nhỏ ít khi ép viết Widget test, nhưng Unit Test (Bài 1) thì luôn luôn bắt buộc.
