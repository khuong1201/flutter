# Bài 5: Cơ Sở Dữ Liệu Hiệu Suất Cao Với Isar

Isar được viết bởi chính tác giả của Hive. Nó ra đời để **thay thế cả Hive và SQFlite**. 
- Nó nhanh như Hive (NoSQL, lưu dưới dạng object).
- Khả năng truy vấn (Query) mạnh mẽ, full-text search, sắp xếp, lọc nhiều điều kiện, hỗ trợ quan hệ (Links/Relations) đỉnh như SQL.
- Là cơ sở dữ liệu hiện đại, hỗ trợ ACID và làm việc mượt mà với nhiều Isolate (đa luồng).

## 1. Cài đặt
```yaml
dependencies:
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0 # Thư viện lõi C++ của Isar

dev_dependencies:
  build_runner: ^2.4.9
  isar_generator: ^3.1.0
```

## 2. Tạo Collection (Bảng)
Giả sử tạo bảng `Email`. Tạo file `email.dart`.

```dart
import 'package:isar/isar.dart';

part 'email.g.dart';

@collection
class Email {
  // Bắt buộc phải có id kiểu Id
  Id id = Isar.autoIncrement;

  // Đánh index (chỉ mục) để tăng tốc độ tìm kiếm
  @Index(type: IndexType.value)
  String? title;

  String? body;
  
  bool isRead = false;
}
```

Chạy lệnh sinh code: `flutter pub run build_runner build`

## 3. Khởi tạo Isar
Ở hàm `main.dart` hoặc trong Repository:
```dart
import 'package:path_provider/path_provider.dart';

Future<Isar> initIsar() async {
  final dir = await getApplicationDocumentsDirectory();
  // Khởi tạo và đưa các Schema vào
  final isar = await Isar.open(
    [EmailSchema], // Sinh ra từ file email.g.dart
    directory: dir.path,
  );
  return isar;
}
```

## 4. Sức mạnh của Query trong Isar

Điểm ăn tiền nhất của Isar là cú pháp Query cực kỳ dễ hiểu, hỗ trợ tự động gợi ý code (type-safe), không sợ gõ sai tên cột như SQL.

```dart
void doSomething(Isar isar) async {
  
  // THÊM DỮ LIỆU
  // Isar bắt buộc mọi lệnh thêm/sửa/xóa phải nằm trong writeTxn (Transaction)
  await isar.writeTxn(() async {
    final email = Email()..title = 'Xin chào'..body = 'Nội dung';
    await isar.emails.put(email);
  });

  // TÌM KIẾM ĐƠN GIẢN (ĐỌC)
  // Lấy ra tất cả email
  final allEmails = await isar.emails.where().findAll();

  // TÌM KIẾM NÂNG CAO (Không sợ sai tên cột)
  final unreadEmails = await isar.emails.filter()
      .titleStartsWith('Xin') // Tên bắt đầu bằng chữ Xin
      .and()
      .isReadEqualTo(false) // Chưa đọc
      .sortByTitle() // Sắp xếp theo title
      .findAll();

  // XÓA
  await isar.writeTxn(() async {
    // Xóa email có id = 1
    await isar.emails.delete(1);
    
    // Xóa theo điều kiện (Xóa tất cả email đã đọc)
    await isar.emails.filter().isReadEqualTo(true).deleteAll();
  });
}
```

> **Tổng kết chương 4:**
> - Cấu hình nhỏ (Token, Theme) -> **Shared Preferences / Secure Storage**.
> - Database lớn, phức tạp -> Mặc định chọn **Isar** cho mọi dự án mới (vừa nhanh, vừa dễ dùng).
