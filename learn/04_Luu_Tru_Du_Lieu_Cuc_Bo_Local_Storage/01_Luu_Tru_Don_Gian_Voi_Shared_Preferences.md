# Bài 1: Lưu Trữ Đơn Giản Với Shared Preferences

`shared_preferences` là cách đơn giản nhất để lưu dữ liệu dưới dạng Key-Value (Chìa khóa - Giá trị) vào bộ nhớ thiết bị.
Bên dưới, nó sử dụng `SharedPreferences` (trên Android) và `NSUserDefaults` (trên iOS).

## 1. Ứng dụng thực tế
**Khi nào nên dùng:**
- Lưu trạng thái đăng nhập (boolean: `isLoggedIn`).
- Lưu Theme của app (sáng/tối).
- Lưu ngôn ngữ được chọn.
- Lưu lịch sử tìm kiếm ngắn.
- Lưu cờ "Đã xem hướng dẫn mở đầu" (`hasSeenTutorial`) để lần mở app sau không hiện lại.

**Khi nào KHÔNG NÊN dùng:**
- KHÔNG lưu mảng/danh sách dữ liệu lớn (Ví dụ: danh sách 1000 user).
- KHÔNG lưu dữ liệu quan trọng như Mật khẩu, Token ngân hàng (Dùng Secure Storage ở Bài 2).

## 2. Cài đặt
```yaml
dependencies:
  shared_preferences: ^2.2.2
```

## 3. Thực hành lưu và đọc dữ liệu

```dart
import 'package:shared_preferences/shared_preferences.dart';

class ThemeStorage {
  // Key dùng để lưu
  static const String _themeKey = 'IS_DARK_MODE';

  // 1. Ghi dữ liệu (Lưu lại lúc người dùng bấm đổi theme)
  static Future<void> saveTheme(bool isDark) async {
    // Phải chờ lấy được instance của bộ nhớ
    final prefs = await SharedPreferences.getInstance();
    
    // Hàm setBool trả về true/false báo hiệu lưu thành công không
    await prefs.setBool(_themeKey, isDark); 
  }

  // 2. Đọc dữ liệu (Đọc lúc khởi động app)
  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    
    // Nếu chưa từng lưu (lần đầu mở app), hàm getBool sẽ trả về null.
    // Toán tử ?? false nghĩa là nếu null thì mặc định lấy false (Sáng).
    return prefs.getBool(_themeKey) ?? false;
  }
  
  // 3. Xóa dữ liệu (Reset)
  static Future<void> removeTheme() async {
     final prefs = await SharedPreferences.getInstance();
     await prefs.remove(_themeKey);
     // Hoặc xoá TRẮNG toàn bộ mọi key đã lưu: await prefs.clear();
  }
}
```

## 4. Mẹo nâng cao: Lưu Object bằng SharedPreferences
SharedPreferences chỉ hỗ trợ kiểu dữ liệu nguyên thủy (Int, Double, Bool, String, List<String>). Nếu bạn muốn lưu một Object (Ví dụ: User profile), bạn phải biến nó thành chuỗi JSON (String).

```dart
// Lưu User
final userJsonString = jsonEncode({'id': 1, 'name': 'ABC'});
prefs.setString('USER_INFO', userJsonString);

// Đọc User
final str = prefs.getString('USER_INFO');
if(str != null) {
  final Map<String, dynamic> userMap = jsonDecode(str);
  print(userMap['name']);
}
```
Tuy nhiên, nếu bạn lưu danh sách (List Object), hãy dùng Hive hoặc Isar thay vì ép kiểu JSON như thế này vì nó rất chậm.
