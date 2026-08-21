# Bài 2: Bảo Mật Dữ Liệu Với Flutter Secure Storage

Dữ liệu lưu bằng `shared_preferences` là bản rõ (plain text). Nếu ai đó root điện thoại (hoặc dùng trình giả lập), họ có thể dễ dàng mở file cấu hình của app bạn và lấy trộm thông tin.

Nếu bạn làm app liên quan đến tài khoản, thanh toán, ngân hàng, việc lưu Access Token, Refresh Token, hoặc Mật khẩu vào `shared_preferences` là **TỘI ÁC**.

Bạn phải dùng **flutter_secure_storage**.
Bên dưới, nó sử dụng `EncryptedSharedPreferences` (trên Android) và `Keychain` (trên iOS) được mã hóa bằng chip bảo mật phần cứng của thiết bị.

## 1. Cài đặt
```yaml
dependencies:
  flutter_secure_storage: ^9.0.0
```

## 2. Cấu hình đặc biệt trên Android
Mở file `android/app/build.gradle` và đảm bảo `minSdkVersion` lớn hơn hoặc bằng 18 (Vì tính năng bảo mật này chỉ có từ Android 4.3 trở lên). Hiện tại Flutter mặc định là 21 rồi nên bạn không lo lắm.

## 3. Thực hành lưu và đọc Token

Cách dùng rất giống với SharedPreferences nhưng mọi dữ liệu lưu vào bắt buộc phải là `String` (chuỗi).

```dart
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  // Khởi tạo đối tượng
  static const _storage = FlutterSecureStorage();
  
  static const _tokenKey = 'ACCESS_TOKEN';

  // 1. Lưu Token (Mã hoá và cất vào Keychain/Keystore)
  static Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  // 2. Đọc Token (Giải mã và lấy ra)
  static Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }
  
  // 3. Xóa Token (Khi đăng xuất)
  static Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
    // Xóa toàn bộ dữ liệu: await _storage.deleteAll();
  }
}
```

## 4. Chú ý nghiêm trọng (Lỗi màn hình trắng iOS)
Trên iOS, Keychain mặc định sẽ KHÔNG bị xóa đi khi người dùng Gỡ Cài Đặt (Uninstall) ứng dụng. 
Điều này dẫn đến lỗi: Người dùng đăng nhập -> Xóa app đi -> Tải lại app trên AppStore -> Mở lên App vẫn tưởng chưa bị xóa và lấy Token cũ ra xài -> Lỗi treo app hoặc màn hình trắng nếu Token đó đã bị server chặn.

**Cách khắc phục:** 
Bạn nên kiểm tra xem đây có phải là lần mở app ĐẦU TIÊN TỪ LÚC CÀI ĐẶT hay không. Nếu đúng, hãy dùng lệnh `deleteAll()` để dọn sạch Keychain cũ.
Ta kết hợp `shared_preferences` (sẽ bị xóa khi gỡ app) và `secure_storage`.

```dart
Future<void> checkFirstRunAndCleanKeychain() async {
  final prefs = await SharedPreferences.getInstance();
  
  // Nếu false, nghĩa là app vừa được cài lại (vì prefs bị xóa khi gỡ app)
  if (prefs.getBool('first_run') ?? true) {
    // Dọn rác do app cũ để lại trong Keychain của điện thoại
    await _storage.deleteAll(); 
    // Đánh dấu là đã dọn xong
    await prefs.setBool('first_run', false);
  }
}
```
*Bạn nên gọi hàm này 1 lần duy nhất ở hàm main() lúc khởi động ứng dụng.*
