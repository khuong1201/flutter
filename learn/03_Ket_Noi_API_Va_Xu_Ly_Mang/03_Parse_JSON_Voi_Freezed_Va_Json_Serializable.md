# Bài 3: Parse JSON Với Freezed và Json_Serializable

Khi gọi API, Backend sẽ trả về chuỗi JSON. Việc map tay (gõ tay từng field) từ JSON sang Object cực kỳ nguy hiểm, dễ gây lỗi Runtime (Crash app) do sai chính tả (Typo) hoặc sai kiểu dữ liệu (Int vs String).

Ví dụ viết tay **rất tệ**:
```dart
class User {
  final String name;
  User.fromJson(Map<String, dynamic> json) : name = json['name']; 
  // Nếu Backend đổi 'name' thành 'full_name' hoặc trả về null -> App CRASH NGAY LẬP TỨC.
}
```

Giải pháp tiêu chuẩn công nghiệp: Sinh code tự động (Code Generation) với **Freezed** và **Json_Serializable**.

## 1. Cài đặt
```yaml
dependencies:
  freezed_annotation: ^2.4.1
  json_annotation: ^4.8.1

dev_dependencies:
  build_runner: ^2.4.9
  freezed: ^2.4.5
  json_serializable: ^6.7.1
```

## 2. Tạo Model bằng Freezed
Tạo file `user_model.dart`.
Freezed yêu cầu chúng ta khai báo Interface (factory) rồi nó sẽ tự sinh ra class hoàn chỉnh.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

// Bắt buộc phải có 2 dòng part này
part 'user_model.freezed.dart';
part 'user_model.g.dart';

@freezed
class UserModel with _$UserModel {
  const factory UserModel({
    // Sử dụng @JsonKey để map đúng tên trường từ Backend trả về
    @JsonKey(name: 'id') required int id,
    @JsonKey(name: 'first_name') required String firstName,
    @JsonKey(name: 'last_name') required String lastName,
    
    // Thuộc tính có thể null (có dấu ?)
    @JsonKey(name: 'avatar_url') String? avatarUrl, 
    
    // Thuộc tính có giá trị mặc định nếu Backend không trả về
    @Default(false) @JsonKey(name: 'is_active') bool isActive,
  }) = _UserModel;

  // Cú pháp bắt buộc để sinh hàm fromJson / toJson
  factory UserModel.fromJson(Map<String, dynamic> json) => _$UserModelFromJson(json);
}
```

## 3. Chạy lệnh sinh code
Sau khi viết xong, mở Terminal chạy lệnh:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```
Lệnh này sẽ quét toàn bộ dự án và tạo ra 2 file `user_model.freezed.dart` và `user_model.g.dart`.

## 4. Những Lợi Ích Khổng Lồ Của Freezed

### a. `fromJson` và `toJson` an toàn tuyệt đối
```dart
// Gọi API xong, quăng data vào là xong, không lo Crash app
final user = UserModel.fromJson(response.data); 
print(user.firstName);
```

### b. Hàm `copyWith` tự động sinh ra
Object trong Freezed là Immutable (không thể thay đổi). Nếu muốn sửa `firstName`, bạn không thể gán `user.firstName = 'B'`. Bạn phải dùng `copyWith`:
```dart
// Tạo ra một user mới, copy y hệt dữ liệu cũ, chỉ đổi firstName
final updatedUser = user.copyWith(firstName: 'Nguyễn Văn B');
```

### c. Hàm `==` (So sánh) tự động sinh ra
Bình thường trong Dart, nếu bạn tạo `User('A') == User('A')`, kết quả là `false` (do khác địa chỉ bộ nhớ).
Với Freezed, nó so sánh từng field bên trong. Nên `User('A') == User('A')` sẽ trả về `true`. Điều này cực kỳ quan trọng khi làm việc với BLoC hoặc Riverpod để tránh vẽ lại UI dư thừa.

## 5. [Kiến thức mới] Dart 3 Records (Bản thay thế nhẹ nhàng)
Kể từ Dart 3, nếu bạn chỉ cần nhóm 2-3 biến lại (ví dụ trả về vĩ độ và kinh độ) mà lười tạo class và chạy Freezed, bạn có thể xài **Records**:

```dart
// Hàm trả về thẳng 1 cục gồm String và Int mà không cần tạo Class
(String name, int age) getUserBasicInfo() {
  return ('Nguyễn Văn A', 25);
}

void main() {
  final info = getUserBasicInfo();
  print(info.$1); // In ra Nguyễn Văn A
}
```
