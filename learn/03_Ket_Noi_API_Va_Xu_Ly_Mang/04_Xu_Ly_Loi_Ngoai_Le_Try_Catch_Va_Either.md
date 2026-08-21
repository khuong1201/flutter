# Bài 4: Xử Lý Lỗi Ngoại Lệ (Try-Catch) và Either (Functional Programming)

Lỗi (Exception) khi gọi API là điều chắc chắn sẽ xảy ra (Mất mạng, Server sập, Dữ liệu sai). Nếu không bắt lỗi cẩn thận, app của bạn sẽ bị Crash văng ra ngoài.

## 1. Cách thông thường: Try - Catch
Đa số chúng ta dùng `try-catch`. Nhưng vấn đề của `try-catch` là nó không báo cho UI biết "Lỗi cụ thể là gì" một cách rõ ràng (type-safe). Hàm trả về dữ liệu (ví dụ `Future<User>`), nếu lỗi thì nó ném văng ra (throw Exception). UI gọi hàm này lại phải bọc thêm một cái `try-catch` nữa, code rất rườm rà.

```dart
// Tầng Repository (Gọi API)
Future<User> getUser() async {
  try {
    final response = await dio.get('/user');
    return User.fromJson(response.data);
  } catch (e) {
    throw Exception('Lỗi lấy user: $e'); // Ném lỗi văng ra ngoài
  }
}

// Tầng UI hoặc BLoC
void loadUser() async {
  try {
    final user = await getUser();
    // Hiện thông tin User
  } catch (e) {
    // Hiện Popup lỗi. Nhìn code rất lồng ghép mệt mỏi
  }
}
```

## 2. Tiêu chuẩn công nghiệp: Sử dụng Either (fpdart / dartz)
Lập trình hàm (Functional Programming) mang đến một khái niệm gọi là **Either (Hoặc Lỗi, Hoặc Thành Công)**. 
Thay vì NÉM lỗi, hàm của bạn sẽ trả về một gói quà. Mở gói quà ra, nếu bên Trái (Left) thì là Lỗi, nếu bên Phải (Right) thì là Dữ liệu.

**Cài đặt:**
```yaml
dependencies:
  fpdart: ^1.1.0 # (Hoặc dùng thư viện dartz)
```

**Cách sử dụng:**
```dart
import 'package:fpdart/fpdart.dart';

// Tầng Repository
// Hàm trả về Either<Lỗi, Dữ_Liệu>
Future<Either<String, User>> getUser() async {
  try {
    final response = await dio.get('/user');
    final user = User.fromJson(response.data);
    return Right(user); // Thành công: Trả về vế Phải
  } on DioException catch (e) {
    return Left('Lỗi mạng: ${e.message}'); // Thất bại: Trả về vế Trái
  } catch (e) {
    return Left('Lỗi không xác định: $e'); // Thất bại: Trả về vế Trái
  }
}

// Tầng UI hoặc BLoC
void loadUser() async {
  final result = await getUser();
  
  // Xử lý gói quà bằng hàm fold() rất thanh lịch
  result.fold(
    (errorMessage) {
      // Vế Trái (Lỗi): Hiện Dialog báo lỗi
      print('Thất bại: $errorMessage');
    }, 
    (user) {
      // Vế Phải (Thành công): Update UI
      print('Thành công: Tên user là ${user.name}');
    }
  );
}
```

## 3. Lợi ích khổng lồ của Either
1. **Không bao giờ lo App Crash** vì quên bọc `try-catch`.
2. **Type-safe (An toàn kiểu dữ liệu)**: Bạn nhìn vào hàm `Future<Either<Failure, User>>` là biết ngay hàm này có thể bị lỗi, và lỗi tên là `Failure`. Ép buộc bạn phải xử lý lỗi thì trình biên dịch mới cho qua.
3. Code UI sạch sẽ hơn, có tính lặp lại cao. (Thường kết hợp hoàn hảo với BLoC).
