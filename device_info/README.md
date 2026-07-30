# 📱 Hardware Diagnostics Bridge - Flutter x Native

Một ứng dụng Flutter minh họa khả năng giao tiếp sâu với phần cứng và hệ điều hành thông qua kiến trúc **MethodChannel**. Dự án tập trung vào việc xử lý các tác vụ Native (Kotlin/Android) trực tiếp mà không phụ thuộc vào các thư viện bên thứ ba (3rd-party packages) trên pub.dev.

---

## 🎯 Vấn đề & Tư duy giải quyết (The "Why")

Trong các dự án Flutter thực tế, việc lạm dụng quá nhiều thư viện (packages) có sẵn để truy cập phần cứng thường dẫn đến các rủi ro:
1. **Bảo mật & Cập nhật:** Thư viện bị bỏ hoang, không tương thích kịp thời khi Google/Apple ra mắt hệ điều hành mới.
2. **Phình to ứng dụng (App Size):** Tải nguyên một thư viện khổng lồ chỉ để dùng một hàm duy nhất.
3. **Blackbox:** Khó debug khi có lỗi xảy ra ở tầng Native.

**👉 Giải pháp của dự án:** 
Áp dụng **Adapter Pattern** thông qua `MethodChannel`. Ứng dụng tự định nghĩa các luồng giao tiếp (Channels), tự viết mã Kotlin/Swift để tương tác trực tiếp với SDK của hệ điều hành, giúp kiểm soát 100% vòng đời và hiệu năng của tính năng.

---

## 🛠 Công nghệ sử dụng (Tech Stack)

* **UI Framework:** Flutter (Dart)
* **Native Android:** Kotlin, Android SDK
* **Giao tiếp đa nền tảng:** `MethodChannel` API
* **Quyền hệ thống (Permissions):** Android Manifest (Camera, Flash, Network State)

---

## 🚀 Tính năng cốt lõi (Core Features)

Dự án triển khai 3 nhóm tính năng tương tác phần cứng tiêu biểu:

1. **System Information (Thông tin hệ thống):**
   * Lấy mã định danh dòng máy (Device Model) thông qua `android.os.Build`.
2. **Hardware Control (Điều khiển phần cứng):**
   * Bật/tắt đèn Flash của thiết bị theo thời gian thực sử dụng `CameraManager` API. Cấp quyền truy cập Camera phần cứng trực tiếp.
3. **Network Connectivity (Trạng thái mạng):**
   * Đọc trạng thái card mạng, xác định thiết bị có đang kết nối Wi-Fi hay không thông qua `ConnectivityManager` và `NetworkCapabilities`.

---

## 🏗 Kiến trúc & Cấu trúc thư mục (Architecture)

Dự án phân tách hoàn toàn Logic Giao diện (Flutter) và Logic Nền tảng (Native OS).

```text
📦 TẦNG FLUTTER (UI & Cầu nối)
 ┣ 📂 lib/
 ┃ ┣ 📂 services/
 ┃ ┃ ┗ 📜 hardware_service.dart   # Khởi tạo MethodChannel, đóng gói các hàm invokeMethod()
 ┃ ┣ 📂 screens/
 ┃ ┃ ┗ 📜 dashboard_screen.dart   # UI nhận dữ liệu qua Future và hiển thị (setState)

📦 TẦNG NATIVE (Xử lý phần cứng gốc)
 ┣ 📂 android/app/src/main/
 ┃ ┣ 📜 AndroidManifest.xml       # Khai báo <uses-permission> cho Camera và Network
 ┃ ┗ 📂 kotlin/.../
 ┃   ┗ 📜 MainActivity.kt         # Mở cổng MethodChannel, lắng nghe và gọi Android SDK