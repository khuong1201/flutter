# Bài 4: BLoC và Cubit Cho Các Dự Án Lớn (Enterprise)

Nếu Riverpod và Provider quản lý State theo kiểu "Data Binding" (Dữ liệu đổi -> UI đổi), thì **BLoC (Business Logic Component)** quản lý theo luồng **Event-Driven (Sự kiện)**.
UI bắn ra một Sự kiện (Event) -> BLoC nhận Event, tính toán -> Nhả ra Trạng thái mới (State).

BLoC được các công ty lớn (MoMo, Zalo...) rất ưa chuộng vì nó bắt buộc coder phải viết theo một tiêu chuẩn cực kỳ khắt khe, dễ chia task cho nhiều người làm chung.

## 1. BLoC vs Cubit
- **BLoC**: Cần định nghĩa rõ ràng `Event` và `State`. Code hơi dài.
- **Cubit**: Phiên bản rút gọn của BLoC. Bỏ qua Event, UI gọi thẳng hàm của Cubit và Cubit nhả ra `State`. (Rất giống Provider).
*Lời khuyên: Chỉ dùng BLoC khi có tính năng phức tạp (Search debounce, Socket), bình thường dùng Cubit là đủ.*

## 2. Cài đặt
```yaml
dependencies:
  flutter_bloc: ^8.1.3
  equatable: ^2.0.5 # Thư viện hỗ trợ so sánh State (bắt buộc dùng kèm BLoC)
```

## 3. Thực hành Cubit (Quản lý User)
**Bước 1: Định nghĩa State (`user_state.dart`)**
Tất cả State đều phải kế thừa `Equatable` để BLoC biết khi nào State thực sự thay đổi mới cho render lại UI.
```dart
import 'package:equatable/equatable.dart';

// [Kiến thức mới Dart 3]: Sử dụng từ khoá `sealed` thay cho `abstract`.
// Lợi ích: Bắt buộc hàm switch-case ở UI phải xử lý ĐỦ 4 trường hợp (Initial, Loading, Loaded, Error).
// Nếu thiếu, code sẽ báo lỗi đỏ ngay lúc gõ (Compile-time error).
sealed class UserState extends Equatable {
  const UserState();
  @override
  List<Object> get props => [];
}

class UserInitial extends UserState {}
class UserLoading extends UserState {}
class UserLoaded extends UserState {
  final String name;
  const UserLoaded(this.name);

  @override
  List<Object> get props => [name]; // Nếu name đổi, báo hiệu cho UI vẽ lại
}
class UserError extends UserState {
  final String message;
  const UserError(this.message);
  
  @override
  List<Object> get props => [message];
}
```

**Bước 2: Viết Logic Cubit (`user_cubit.dart`)**
```dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial()); // State mặc định

  Future<void> fetchUser() async {
    emit(UserLoading()); // Nhả state Loading -> UI xoay vòng vòng
    try {
      await Future.delayed(Duration(seconds: 2)); // Call API
      emit(UserLoaded("Trần Văn B")); // Nhả state Loaded
    } catch (e) {
      emit(UserError("Không lấy được dữ liệu"));
    }
  }
}
```

## 4. Hiển thị lên UI (`BlocProvider` và `BlocBuilder`)
Tương tự Provider, bạn cần bọc `BlocProvider` ở ngoài (ví dụ ở `main.dart` hoặc ngoài cùng màn hình).

```dart
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit()..fetchUser(), // Khởi tạo và gọi hàm lấy data ngay
      child: Scaffold(
        appBar: AppBar(title: Text('BLoC / Cubit')),
        body: Center(
          // BlocBuilder sẽ lắng nghe sự thay đổi State từ Cubit
          child: BlocBuilder<UserCubit, UserState>(
            builder: (context, state) {
              if (state is UserLoading) {
                return CircularProgressIndicator();
              } else if (state is UserLoaded) {
                return Text('Tên User: ${state.name}');
              } else if (state is UserError) {
                return Text('Lỗi: ${state.message}', style: TextStyle(color: Colors.red));
              }
              return Text('Nhấn nút để lấy dữ liệu'); // UserInitial
            },
          ),
        ),
      ),
    );
  }
}
```

## 5. `BlocListener` - Khi nào dùng?
Nếu bạn muốn hiển thị một Dialog báo lỗi hoặc chuyển trang (`Navigator.push`), bạn **KHÔNG THỂ** viết trong `BlocBuilder` (vì nó dùng để vẽ giao diện). Bạn phải dùng `BlocListener` hoặc `BlocConsumer`.
```dart
BlocListener<UserCubit, UserState>(
  listener: (context, state) {
    if (state is UserError) {
      // Hiện popup báo lỗi
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.message)),
      );
    }
  },
  child: // Giao diện của bạn
)
```
