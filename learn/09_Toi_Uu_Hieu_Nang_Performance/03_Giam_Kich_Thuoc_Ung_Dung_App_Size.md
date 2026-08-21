# Bài 3: Giảm Kích Thước Ứng Dụng (App Size)

Một app quá nặng (trên 100MB) sẽ khiến người dùng e ngại tải về, đặc biệt khi dùng 3G/4G. Flutter build ra app bản chất đã nặng hơn Native một chút do phải nhúng theo Engine C++ của Flutter. Việc tối ưu App Size là bước bắt buộc trước khi đưa lên Store.

## 1. Nén ảnh và âm thanh
Thủ phạm số 1 làm phình to dung lượng app là tài nguyên (Assets).
- **Tuyệt đối không dùng ảnh PNG hoặc JPG nguyên gốc** (1 tấm có thể nặng 2-5MB).
- Hãy dùng phần mềm hoặc trang web (như Squoosh.app, tinypng) để nén ảnh lại hoặc chuyển sang định dạng **WebP** (WebP nhẹ hơn JPG/PNG tới 30-50% mà chất lượng không giảm, Flutter hỗ trợ hiển thị WebP hoàn hảo).
- Nếu dùng icon, thay vì dùng ảnh, hãy chuyển thành SVG hoặc font chữ (ttf). (Thư viện `flutter_svg`).

## 2. Build Split APK (Dành cho Android)
Khi bạn build một file APK thông thường (`flutter build apk`), Flutter sẽ ném vào đó toàn bộ mã nguồn để chạy được trên cả chip 32-bit (armeabi-v7a), 64-bit (arm64-v8a), và giả lập (x86). File APK này rất mập!

Khi đẩy lên Google Play, **ĐỪNG BAO GIỜ UP FILE APK**. Hãy dùng lệnh:
```bash
flutter build appbundle
```
File `.aab` (App Bundle) này Google Play sẽ giữ, khi người dùng tải app, Google sẽ tự động cắt ra một bản APK nhỏ gọn nhất vừa khít với cấu hình điện thoại của họ. Nó giảm được tới 40% dung lượng.

Nếu bạn bắt buộc phải gửi file APK cho khách hàng test qua Zalo/Email, hãy dùng lệnh chia nhỏ apk:
```bash
flutter build apk --split-per-abi
```
Nó sẽ sinh ra 3 file APK nhỏ (mỗi file tầm mười mấy MB), bạn hãy gửi cái file có chữ `arm64-v8a` cho điện thoại xịn, và `armeabi-v7a` cho điện thoại đời cũ.

## 3. Loại bỏ code thừa (Tree Shaking)
Mặc định khi build ở chế độ Release, Flutter đã tự động áp dụng Tree Shaking (Tự tìm và xóa những hàm/class bạn có cài trong thư viện mà không dùng tới).

Bạn có thể ép mạnh tay hơn bằng lệnh:
```bash
flutter build appbundle --obfuscate --split-debug-info=./debug_info
```
Lệnh này vừa làm rối mã nguồn (bảo mật, rút gọn tên biến thành a, b, c) vừa đẩy file lỗi (debug info) ra ngoài, giúp app nhẹ hơn một chút.

## 4. Kiểm tra xem thứ gì đang ngốn dung lượng nhất
Chạy lệnh phân tích:
```bash
flutter build apk --analyze-size
```
Flutter sẽ xuất ra một file JSON mô tả chi tiết: Thư viện `firebase` chiếm 2MB, font chữ chiếm 5MB, thư viện ảnh chiếm 3MB... Dựa vào đó bạn sẽ biết cần "trảm" cái gì.
