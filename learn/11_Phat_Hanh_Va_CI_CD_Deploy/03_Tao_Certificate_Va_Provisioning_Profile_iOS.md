# Bài 3: Tạo Certificate và Provisioning Profile iOS

Việc phát hành app iOS gian nan và phức tạp hơn Android rất nhiều. Bắt buộc bạn phải mua tài khoản Apple Developer (Giá 99$ / năm).

## 1. Yêu cầu tiên quyết
- Máy Mac (MacBook, Mac Mini).
- Phần mềm Xcode.
- Đã đăng nhập Apple ID có quyền Developer vào máy Mac.

## 2. Tạo Certificate (Chứng chỉ phát triển)
1. Mở phần mềm **Keychain Access** trên máy Mac.
2. Từ thanh menu trên cùng, chọn: `Keychain Access` > `Certificate Assistant` > `Request a Certificate from a Certificate Authority...`
3. Điền email của bạn, chọn mục **"Saved to disk"** rồi bấm Continue. Nó sẽ tải về 1 file `.certSigningRequest` (CSR).
4. Truy cập trang web: `developer.apple.com/account`.
5. Vào mục **Certificates, IDs & Profiles**. Bấm dấu + tạo Certificate mới.
6. Chọn **Apple Distribution** (Bản để đăng Store) -> Tải file CSR ở bước 3 lên.
7. Apple cấp cho bạn 1 file `.cer`. Tải về nhấp đúp để cài vào máy Mac.

## 3. Đăng ký Bundle ID (App ID)
Mỗi ứng dụng phải có 1 cái tên duy nhất toàn cầu (Ví dụ: `com.congty.myapp`).
1. Cũng trên web Apple Developer, mục **Identifiers**, bấm dấu +.
2. Chọn **App IDs** -> Điền mô tả và điền chính xác Bundle ID (Giống hệt cái bundle ID khai báo trong file cấu hình Flutter).
3. Đánh dấu tick vào các tính năng app bạn xài (Ví dụ: Push Notification, Sign in with Apple...).

## 4. Tạo Provisioning Profile (Hồ sơ uỷ quyền)
Provisioning Profile là thứ kết nối App ID (bước 3) và Certificate (bước 2) lại với nhau.

1. Vào mục **Profiles**, bấm dấu +.
2. Chọn **App Store** (dưới nhóm Distribution).
3. Chọn App ID đã tạo ở bước 3.
4. Chọn Certificate đã tạo ở bước 2.
5. Đặt tên, bấm Tải về (`.mobileprovision`) và nhấp đúp để cài vào máy Mac.

## 5. Build và Ký Ứng Dụng Bằng Xcode
1. Mở Terminal, gõ lệnh để build phần khung Flutter trước:
```bash
flutter build ipa --export-options-plist=ios/ExportOptions.plist
```
(Cách dễ nhất đối với người mới là chạy `flutter build ios`, sau đó mở Xcode lên thao tác bằng tay).

2. Mở file `ios/Runner.xcworkspace` bằng Xcode.
3. Bấm vào dự án `Runner` bên cột trái, chọn tab **Signing & Capabilities**.
4. Bỏ dấu tick "Automatically manage signing" đi (nếu muốn làm thủ công). Chọn Provisioning Profile mà bạn vừa tạo.
5. Ở thanh công cụ trên cùng, chọn Build Target là **"Any iOS Device (arm64)"**.
6. Chọn thanh menu `Product` -> `Archive`.
7. Xcode sẽ biên dịch mất vài phút, sau đó mở cửa sổ Organizer. Bấm nút **Distribute App** để bắn thẳng bản build này lên máy chủ App Store Connect.
