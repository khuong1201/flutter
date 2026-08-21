# Bài 4: Cơ Sở Dữ Liệu NoSQL Cực Nhanh Với Hive

Hive là một database dạng NoSQL (giống MongoDB, Firebase). Thay vì lưu bằng Bảng (Table) và Cột (Column) như SQL, Hive lưu dữ liệu theo dạng **Box (Hộp)** dưới định dạng Key-Value cực kỳ tối ưu.
Tác giả quảng cáo Hive nhanh hơn SQLite rất nhiều lần vì nó chạy hoàn toàn trên Dart (không thông qua Native bridge).

## 1. Ứng dụng thực tế
- Cache dữ liệu từ API về (Ví dụ danh sách bài báo) để lần sau mở app đọc offline ngay lập tức.
- Ứng dụng không cần query chéo quá lằng nhằng (JOIN 2 3 bảng).

## 2. Cài đặt
Hive bắt buộc phải dùng Code Generation để tạo TypeAdapter (Giúp Hive hiểu Object của bạn).
```yaml
dependencies:
  hive: ^2.2.3
  hive_flutter: ^1.1.0 # Thêm vài hàm hỗ trợ riêng cho Flutter

dev_dependencies:
  build_runner: ^2.4.9
  hive_generator: ^2.0.1
```

## 3. Tạo Object và Sinh Code
Giả sử ta làm App quản lý danh bạ. Ta tạo file `person.dart`.

```dart
import 'package:hive/hive.dart';

part 'person.g.dart'; // Bắt buộc

@HiveType(typeId: 0) // typeId phải duy nhất cho mỗi class (0 đến 255)
class Person {
  @HiveField(0)
  String name;

  @HiveField(1)
  int age;

  Person({required this.name, required this.age});
}
```

Mở terminal chạy lệnh sinh code: `flutter pub run build_runner build`
Nó sẽ sinh ra file `person.g.dart` chứa class `PersonAdapter`.

## 4. Khởi tạo và Lưu Dữ Liệu

**Bước 1: Khởi tạo ở `main.dart`**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Hive
  await Hive.initFlutter();
  
  // Đăng ký Adapter vừa sinh ra
  Hive.registerAdapter(PersonAdapter());
  
  // Mở cái Hộp (Box) có tên là 'myBox'
  await Hive.openBox<Person>('myBox');
  
  runApp(MyApp());
}
```

**Bước 2: Viết/Đọc/Sửa/Xóa (CRUD)**
Code của Hive ngắn và dễ thở hơn SQFlite gấp vạn lần.

```dart
void doSomething() {
  // Lấy cái hộp ra (Đã open ở hàm main)
  var box = Hive.box<Person>('myBox');

  // Thêm dữ liệu (Hive tự đánh ID)
  box.add(Person(name: 'Vũ', age: 25)); 
  
  // Thêm dữ liệu với Key tự chọn
  box.put('vip_user', Person(name: 'Sếp', age: 40));

  // Đọc dữ liệu
  Person? vip = box.get('vip_user');
  print(vip?.name);

  // Đọc danh sách (Từ cái hộp ra list)
  List<Person> allPersons = box.values.toList();

  // Xóa
  box.delete('vip_user'); // Xóa theo key
  box.deleteAt(0); // Xóa theo thứ tự
}
```

## 5. Nhược điểm của Hive
- Hạn chế khi cần Query phức tạp. Ví dụ bạn muốn tìm "Tất cả user có age > 20 và tên bắt đầu bằng chữ V", với SQL thì gõ 1 câu lệnh là xong, còn với Hive, bạn phải kéo toàn bộ dữ liệu ra thành mảng List, rồi dùng hàm `.where()` của Dart để lọc. Nếu data có 100,000 dòng thì làm thế này sẽ tràn RAM. 
- (Đó là lý do Isar ra đời - xem Bài 5).
