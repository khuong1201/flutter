# Bài 1: Mã Hóa Code (Obfuscation) Chống Dịch Ngược

## 1. Dịch ngược (Reverse Engineering) là gì?
Khi bạn build app ra file `.apk` (Android) hoặc `.ipa` (iOS), tin tặc hoàn toàn có thể dùng các tool decompiler (như apktool) để bung file cài đặt ra.
Với ứng dụng Flutter, nếu không được bảo vệ, tin tặc có thể đọc được file `libapp.so` chứa toàn bộ code Dart của bạn (chúng có thể thấy rõ các hàm `login()`, `checkVip()`, các câu IF/ELSE).

Từ đó, tin tặc có thể sửa lại code (Ví dụ: Sửa hàm `checkVip() { return true; }` để xài chùa), rồi đóng gói lại thành APK mới và phân phát trên mạng.

## 2. Mã hóa nguồn (Obfuscate)
Obfuscation là kỹ thuật "làm rối" code. Nó sẽ tự động đổi tên các class, hàm, biến có ý nghĩa (như `UserRepository`, `checkPassword`) thành các ký tự vô nghĩa ngẫu nhiên (`a`, `b`, `c1`, `x2`).
Điều này khiến tin tặc đọc code bị... rối loạn tiền đình và rất khó để hiểu logic.

Để bật tính năng này khi build release, bạn phải thêm 2 cờ `--obfuscate` và `--split-debug-info`:

**Cho Android (App Bundle lên Google Play):**
```bash
flutter build appbundle --obfuscate --split-debug-info=./debug_info
```

**Cho iOS:**
```bash
flutter build ipa --obfuscate --split-debug-info=./debug_info
```

*Giải thích:*
- `--obfuscate`: Bật tính năng làm rối code.
- `--split-debug-info=./debug_info`: Tách các ký hiệu (symbol) đã bị làm rối lưu vào một thư mục riêng tên là `debug_info` trên máy tính của bạn. Bạn **phải giữ lại thư mục này** (có thể cất lên Google Drive).

## 3. Khôi phục lỗi khi đã Obfuscate
Khi app của bạn đã bị làm rối tên biến, nếu người dùng bị Crash App, trên Firebase Crashlytics sẽ báo lỗi rất kỳ cục kiểu:
`Lỗi ở dòng 42 của hàm a, class x`. Bạn sẽ không biết đó là chỗ nào trong code của mình!

Lúc này, bạn mở Terminal, dùng file symbol trong thư mục `debug_info` (mà bạn đã cất giữ) để "dịch" lại cái đống bùi nhùi đó ra tên class gốc.

```bash
flutter symbolize -i <đường_dẫn_tới_file_báo_lỗi.txt> -d ./debug_info
```
Nó sẽ in ra màn hình cho bạn biết hàm `a` thực chất là hàm `login` của class `AuthRepository`!
