# Bài 3: Sử Dụng Riverpod và Code Generation

Riverpod (là phép đảo chữ của Provider) được tạo ra bởi chính tác giả của Provider (Remi Rousselet) nhằm khắc phục những nhược điểm chí mạng của Provider (ví dụ: Lỗi `ProviderNotFoundException` vào runtime).

Riverpod an toàn lúc biên dịch (Compile-safe) và không phụ thuộc vào `BuildContext`. Hiện tại, phiên bản mới nhất (Riverpod 2.0+) khuyến khích sử dụng **Code Generation** (Tự động sinh code).

## 1. Cài đặt
Cần cài khá nhiều thư viện vì chúng ta dùng code generation:
```yaml
dependencies:
  flutter_riverpod: ^2.5.1
  riverpod_annotation: ^2.3.5

dev_dependencies:
  build_runner: ^2.4.9
  riverpod_generator: ^2.4.0
```

## 2. Bọc App bằng `ProviderScope`
Khác với MultiProvider phải định nghĩa từng cái, Riverpod chỉ cần một dòng bọc ở `main.dart`.

```dart
void main() {
  runApp(
    ProviderScope( // Khởi tạo Riverpod ở đây
      child: MyApp(),
    ),
  );
}
```

## 3. Tạo Provider với Code Generation
Tạo file `counter_provider.dart`.
Chú ý: Bạn sẽ thấy báo lỗi đỏ ở `part ...`, đừng lo, chúng ta sẽ chạy lệnh sinh code sau.

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Bắt buộc phải có dòng part này để sinh code
part 'counter_provider.g.dart'; 

// [Kiến thức mới Riverpod 2.0+]: 
// Thư viện sẽ tự động sinh ra class kế thừa từ `Notifier` (hoặc `AsyncNotifier`).
// Thay vì dùng StateNotifier cũ kỹ, cách viết @riverpod này ngắn và an toàn type-safe hơn rất nhiều.
@riverpod
class Counter extends _$Counter {
  @override
  int build() {
    return 0; // Giá trị khởi tạo
  }

  void increment() {
    state++; // state được cung cấp sẵn
  }
}
```

Mở Terminal gõ lệnh:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
Lệnh này sẽ tự động sinh ra file `counter_provider.g.dart` và tạo ra biến toàn cục `counterProvider` cho bạn xài.

## 4. Xử lý API (AsyncValue) - Sức mạnh thực sự của Riverpod
Riverpod cực mạnh ở khoản gọi API với `@riverpod`. Nó tự quản lý trạng thái Loading, Data, Error cho bạn (kiểu `AsyncValue`).

```dart
@riverpod
Future<String> fetchUser(FetchUserRef ref) async {
  await Future.delayed(Duration(seconds: 2)); // Giả lập call API
  // throw Exception("Mất mạng!"); // Thử mở cái này ra để test lỗi
  return "Nguyễn Văn A";
}
```

## 5. Đọc State trên UI (ConsumerWidget)
Màn hình muốn đọc Riverpod phải kế thừa từ `ConsumerWidget` thay vì `StatelessWidget`. Nó sẽ có thêm biến `WidgetRef` ở hàm `build`.

```dart
class UserScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ref.watch: Lắng nghe sự thay đổi
    final userAsyncValue = ref.watch(fetchUserProvider);
    
    // ref.read: Chỉ đọc một lần hoặc gọi hàm (Dùng trong sự kiện như onPress)
    // final counterNotifier = ref.read(counterProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: Text('Riverpod AsyncValue')),
      body: Center(
        // AsyncValue cung cấp sẵn hàm when siêu xịn:
        child: userAsyncValue.when(
          data: (name) => Text('Xin chào $name', style: TextStyle(fontSize: 24)),
          loading: () => CircularProgressIndicator(),
          error: (err, stack) => Text('Lỗi: $err'),
        ),
      ),
    );
  }
}
```

**Tại sao Riverpod lại "đỉnh"?**
Bạn không cần viết code `isLoading = true`, rồi Try/Catch mệt mỏi như Provider. Mọi trạng thái bất đồng bộ được Riverpod bắt trọn bằng `AsyncValue.when`.
