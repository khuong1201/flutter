# 💬 Mini Workspace - Real-time Team Chat App

Một ứng dụng trò chuyện nội bộ theo thời gian thực (Real-time), xây dựng trên nền tảng Flutter và Firebase. Dự án tập trung giải quyết các bài toán về đồng bộ dữ liệu liên tục, quản lý trạng thái xác thực và tối ưu hóa vòng đời ứng dụng (Push Notifications).

---

## 🛠 Công nghệ sử dụng (Tech Stack)

* **Nền tảng & Ngôn ngữ:** Flutter / Dart
* **Xác thực danh tính (Authentication):** Firebase Authentication (Email/Password)
* **Cơ sở dữ liệu (Database):** Cloud Firestore (NoSQL, Real-time Sync, Offline Persistence)
* **Thông báo đẩy (Push Notifications):** Firebase Cloud Messaging (FCM)
* **Quản lý trạng thái & Phản ứng (Reactivity):** `StreamBuilder` (Lắng nghe luồng dữ liệu thời gian thực)
* **Khởi tạo & Cấu hình môi trường:** FlutterFire CLI (`firebase_options.dart`)

---

## 🔄 Luồng ứng dụng (Application Flow)

Hệ thống được thiết kế theo hướng điều hướng tự động (Reactive Routing) dựa trên trạng thái của luồng dữ liệu, loại bỏ hoàn toàn việc chuyển trang thủ công (`Navigator.push`).

1. **App Initialization:** 
   Khởi tạo `Firebase.initializeApp()` và dịch vụ FCM ngay khi chạy `main.dart`.
2. **Authentication Flow (Luồng Xác thực):**
   * Sử dụng `StreamBuilder` lắng nghe `authStateChanges` từ Firebase Auth.
   * **Nếu chưa đăng nhập:** Render `LoginScreen`.
   * **Nếu đã đăng nhập (có Token hợp lệ):** Render thẳng vào `ChatScreen`.
   * *Đặc biệt:* Nếu người dùng bấm "Đăng xuất" hoặc Token hết hạn, Stream sẽ tự động nhả dữ liệu `null` và đá văng người dùng về màn hình Login ngay lập tức.
3. **Messaging Flow (Luồng Tin nhắn):**
   * **Gửi tin (Write):** Người dùng nhập text -> Gọi Service -> Đẩy JSON lên collection `messages` trên Firestore.
   * **Nhận tin (Read/Sync):** `StreamBuilder` tại `ChatScreen` mở một socket lắng nghe Firestore. Khi có bất kỳ thay đổi nào (tin mới, xóa tin), UI sẽ tự động re-render tức thì theo chiều từ dưới lên (`ListView(reverse: true)`).
4. **Notification Flow (Luồng Thông báo đẩy):**
   * Foreground (App đang mở): Bắt sự kiện qua `FirebaseMessaging.onMessage`.
   * Background / Terminated (App thu nhỏ / Đóng hoàn toàn): Bắt sự kiện qua Top-level function `@pragma('vm:entry-point')` để xử lý ngầm mà không làm crash ứng dụng.

---

## 💼 Luồng nghiệp vụ & Giải pháp kỹ thuật (Business Logic & Core Solutions)

Dự án áp dụng các quy tắc nghiệp vụ chặt chẽ để đảm bảo tính toàn vẹn của dữ liệu trong môi trường hệ thống phân tán:

### 1. Đồng bộ thời gian phân tán (Distributed Timestamping)
* **Vấn đề:** Nếu sử dụng thời gian của thiết bị (`DateTime.now()`) để gán cho tin nhắn, sẽ xảy ra lỗi sai lệch thứ tự chat nếu người dùng A cài đặt sai giờ trên điện thoại của họ.
* **Giải pháp:** Bắt buộc sử dụng `FieldValue.serverTimestamp()` ở tầng Service. Thời gian của tin nhắn sẽ được quyết định bởi máy chủ của Google, đảm bảo sự chính xác tuyệt đối về mặt thứ tự (Chronological order).

### 2. Xử lý Trạng thái Ngoại tuyến (Offline Capabilities)
* **Vấn đề:** Ứng dụng chat cần đảm bảo trải nghiệm không bị gián đoạn khi người dùng đi vào vùng mất sóng (thang máy, hầm).
* **Giải pháp:** Tận dụng tính năng Offline Persistence của Firestore. Khi mất mạng, tin nhắn được lưu tạm vào bộ nhớ đệm (Cache) của máy và hiển thị ngay lên UI. Khi thiết bị có mạng trở lại, Firestore SDK sẽ tự động đồng bộ (sync) các tin nhắn này lên Server mà không cần viết thêm logic xử lý hàng đợi (Queue).

### 3. Tách biệt kiến trúc (Separation of Concerns)
* Toàn bộ mã nguồn giao tiếp với Firebase (Auth, Firestore, Messaging) được cô lập hoàn toàn vào các lớp **Services** (`auth_service.dart`, `chat_service.dart`).
* Tầng UI (Màn hình và Widgets) tuyệt đối không chứa các câu lệnh `Firebase.instance`. Dữ liệu trả về được ép kiểu an toàn qua các lớp **Models** (VD: `MessageModel`), giúp chống lại lỗi Null Pointer Exception nếu cấu trúc database bị thay đổi đột ngột.

---

## 📂 Cấu trúc thư mục (Folder Architecture)

```text
lib/
 ┣ models/           # Ép kiểu dữ liệu an toàn từ JSON/Map (message_model.dart)
 ┣ services/         # Cô lập logic giao tiếp với Firebase API
 ┃ ┣ auth_service.dart
 ┃ ┣ chat_service.dart
 ┃ ┗ notification_service.dart
 ┣ screens/          # Các màn hình chính (login_screen.dart, chat_screen.dart)
 ┣ widgets/          # Component UI tái sử dụng (message_bubble.dart)
 ┣ firebase_options.dart # Cấu hình môi trường tự động từ FlutterFire
 ┗ main.dart         # Entry point & Cấu hình Reactive Routing