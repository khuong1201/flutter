# Bài 3: Cơ Sở Dữ Liệu Quan Hệ Với SQFlite

SQFlite là plugin bọc lại thư viện SQLite huyền thoại. Đây là loại cơ sở dữ liệu quan hệ (RDBMS) dùng ngôn ngữ SQL thuần.

## 1. Ứng dụng thực tế
**Khi nào nên dùng:**
- Ứng dụng Offline-first (App từ điển, App quản lý chi tiêu cá nhân).
- Dữ liệu có quan hệ phức tạp, cần join nhiều bảng (Ví dụ: Một Bài viết có nhiều Bình luận, Bình luận thuộc về User).
- Cần thực hiện các câu query phức tạp: Tìm bài viết từ ngày A đến ngày B, có tên chứa chữ "Flutter".

**Nhược điểm:**
- Bạn phải biết viết câu lệnh SQL (CREATE TABLE, SELECT, INSERT).
- Việc map từ Cột (Row) trong DB ra Class (Object) tốn nhiều code boilerplate.
- Chậm hơn Hive/Isar.

## 2. Cài đặt
```yaml
dependencies:
  sqflite: ^2.3.0
  path: ^1.8.3 # Dùng để tìm đường dẫn lưu file database trên điện thoại
```

## 3. Thực hành (App Quản lý công việc)

```dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Áp dụng Singleton Pattern để đảm bảo chỉ có 1 kết nối DB duy nhất
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Tìm đường dẫn thư mục chuẩn của thiết bị (Android/iOS)
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    // Mở DB, nếu chưa có thì gọi onCreate để tạo bảng
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    // Viết câu lệnh SQL tạo bảng
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // ---------------- CÁC HÀM CRUD (Create, Read, Update, Delete) ---------------- //

  // THÊM (INSERT)
  Future<int> insertTodo(String title) async {
    final db = await instance.database;
    // Map data
    final data = {'title': title, 'isCompleted': 0}; // 0 = false, 1 = true
    return await db.insert('todos', data);
  }

  // ĐỌC (SELECT)
  Future<List<Map<String, dynamic>>> getAllTodos() async {
    final db = await instance.database;
    // Tương đương SELECT * FROM todos ORDER BY id DESC
    return await db.query('todos', orderBy: 'id DESC');
  }

  // SỬA (UPDATE)
  Future<int> updateTodo(int id, int isCompleted) async {
    final db = await instance.database;
    return await db.update(
      'todos',
      {'isCompleted': isCompleted},
      where: 'id = ?', // Dùng dấu ? để tránh SQL Injection
      whereArgs: [id],
    );
  }

  // XÓA (DELETE)
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;
    return await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
```

*Lời khuyên: Mặc dù SQFlite rất nổi tiếng, nhưng hiện tại xu hướng làm app mới mọi người thường chuyển sang dùng Isar vì Isar sử dụng code generation thay vì viết chuỗi SQL thủ công dễ gây lỗi type (đánh máy sai).*
