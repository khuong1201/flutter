# Bài 1: Viết Unit Test (Kiểm Thử Đơn Vị) Cho Logic

Unit Test là viết code để kiểm tra... code. Chức năng chính là để đảm bảo khi sau này bạn thêm tính năng mới, bạn không vô tình làm "chết" các tính năng cũ.

Unit Test dùng để kiểm tra các Hàm thuần túy, các phép toán (Utils, Helpers), và các lớp Logic (BLoC, Provider) mà KHÔNG cần vẽ lên giao diện (UI).

## 1. Cài đặt thư viện
Flutter đã có sẵn `flutter_test`. Chúng ta chỉ cần cài thêm thư viện làm giả dữ liệu (Mocking) tên là `mockito` hoặc `mocktail`. Ở đây tôi hướng dẫn `mocktail` vì nó dễ hơn, không cần sinh code.
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.0
```

## 2. Viết Unit Test cơ bản (Test hàm thuần)
Tất cả code test bắt buộc phải nằm trong thư mục `test` ở ngoài cùng dự án (ngang hàng với `lib`).
Luôn đặt tên file test có chữ `_test.dart` ở cuối.

Ví dụ tạo hàm cần test trong `lib/utils/calculator.dart`:
```dart
class Calculator {
  int add(int a, int b) => a + b;
}
```

Tạo file `test/calculator_test.dart`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:my_app/utils/calculator.dart';

void main() {
  // test() là một trường hợp kiểm thử cụ thể
  test('Hàm add phải cộng đúng 2 số', () {
    // 1. Arrange: Khởi tạo dữ liệu
    final calc = Calculator();
    
    // 2. Act: Thực hiện hành động
    final result = calc.add(2, 3);
    
    // 3. Assert: So sánh xem kết quả có đúng kỳ vọng không
    expect(result, 5); // Kỳ vọng result phải bằng 5
  });
}
```

## 3. Viết Unit Test nâng cao với Mocking (Giả lập Call API)
Khi test, ta không bao giờ thực sự gọi API (Vì mạng có thể lag, hoặc server chết làm test sai). Ta phải "làm giả" hành động gọi API đó.

Giả sử có hàm lấy User:
```dart
class UserRepository {
  final ApiClient apiClient;
  UserRepository(this.apiClient);
  
  Future<String> getUserName() async {
    return await apiClient.fetchName(); 
  }
}
```

Viết Test dùng `mocktail`:
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

// Tạo một lớp làm giả (Mock) từ ApiClient thật
class MockApiClient extends Mock implements ApiClient {}

void main() {
  late UserRepository repo;
  late MockApiClient mockClient;

  // setUp chạy trước mỗi test
  setUp(() {
    mockClient = MockApiClient();
    repo = UserRepository(mockClient);
  });

  test('Lấy tên user thành công', () async {
    // 1. Dạy cho thằng "làm giả" biết phải trả về cái gì
    // (Bất cứ khi nào hàm fetchName được gọi, hãy trả về chữ "Tuấn")
    when(() => mockClient.fetchName()).thenAnswer((_) async => "Tuấn");

    // 2. Gọi hàm thực tế
    final result = await repo.getUserName();

    // 3. Kiểm tra kết quả
    expect(result, "Tuấn");
    
    // Đảm bảo hàm API đã được gọi đúng 1 lần
    verify(() => mockClient.fetchName()).called(1);
  });
}
```
Chạy test trên Terminal:
```bash
flutter test
```
