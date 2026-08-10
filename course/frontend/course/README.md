# Zenith Lingua (Flutter Course Project)

Dự án này là một ứng dụng Flutter được xây dựng theo chuẩn mực **Clean Architecture** kết hợp với mô hình **Feature-First**. Cấu trúc mã nguồn được thiết kế để dễ dàng mở rộng (scale), bảo trì và làm việc nhóm hiệu quả.

---

## 🚀 Công nghệ sử dụng (Tech Stack)

Dự án sử dụng các package (thư viện) mạnh mẽ và phổ biến nhất trong cộng đồng Flutter hiện nay:

- **[flutter_bloc](https://pub.dev/packages/flutter_bloc):** State Management chuẩn mực, tách biệt hoàn toàn Business Logic ra khỏi UI.
- **[go_router](https://pub.dev/packages/go_router):** Quản lý điều hướng (Routing) hiện đại, hỗ trợ deep-linking và Auth Guards (bảo vệ luồng đăng nhập).
- **[get_it](https://pub.dev/packages/get_it):** Dependency Injection (Service Locator) giúp quản lý khởi tạo các object, repository, usecase và bloc toàn cục.
- **[dio](https://pub.dev/packages/dio):** HTTP Client mạnh mẽ thay thế cho `http` mặc định. Hỗ trợ Interceptors, timeout, cấu hình global (như tự động đính kèm Token).
- **[flutter_secure_storage](https://pub.dev/packages/flutter_secure_storage):** Lưu trữ an toàn (mã hoá) cho các dữ liệu nhạy cảm như Access Token.
- **[dartz](https://pub.dev/packages/dartz):** Xử lý lỗi an toàn thông qua functional programming (`Either<Failure, T>`), loại bỏ hoàn toàn `try-catch` lồng nhau ở phía giao diện.
- **[flutter_dotenv](https://pub.dev/packages/flutter_dotenv):** Quản lý biến môi trường an toàn qua file `.env`, tránh hardcode các thông tin nhạy cảm như API_URL.
- **[flutter_localizations](https://docs.flutter.dev/ui/accessibility-and-localization/internationalization) & [intl](https://pub.dev/packages/intl):** Hỗ trợ ứng dụng đa ngôn ngữ (Tiếng Việt & Tiếng Anh).

---

## 📂 Cấu trúc thư mục (Architecture)

Mô hình dự án tuân theo triết lý **Feature-First**. Mỗi tính năng (ví dụ: `auth`, `home`) sẽ là một module độc lập chứa đầy đủ từ Giao diện (UI) đến Logic nghiệp vụ (Domain) và Gọi dữ liệu (Data).

```text
lib/
├── core/                       # Chứa các file dùng chung toàn hệ thống
│   ├── constants/              # Các hằng số (Colors, Dimens, Assets...)
│   ├── di/                     # Dependency Injection (injection.dart)
│   ├── error/                  # Định nghĩa lỗi (failures.dart)
│   ├── network/                # Cấu hình network, Interceptors (token_interceptor.dart)
│   ├── local_storage/          # Secure Storage Helpers
│   ├── theme/                  # Theme chung cho ứng dụng
│   ├── utils/                  # Các hàm tiện ích (Extensions, Formatters...)
│   └── widgets/                # Các UI Component dùng lại ở nhiều màn hình
│
├── features/                   # Chứa các tính năng chính của app
│   ├── auth/                   # Tính năng Xác thực (Đăng nhập, Đăng ký)
│   │   ├── data/               # Models, Data Sources & Repository Implementations
│   │   ├── domain/             # Entities, Repositories (Interface) & UseCases
│   │   └── presentation/       # Cubit (State Management), Pages (UI) & Widgets
│   │
│   └── home/                   # Tính năng Trang chủ
│
├── l10n/                       # File đa ngôn ngữ (.arb files)
├── routes/                     # Cấu hình GoRouter (app_router.dart, app_routes.dart)
├── app.dart                    # Material App root
└── main.dart                   # Entry point, khởi tạo biến môi trường, DI
```

---

## 🛠 Hướng dẫn cài đặt & Chạy ứng dụng

### 1. Cài đặt các gói phụ thuộc
Chạy lệnh sau ở thư mục gốc của dự án:
```bash
flutter pub get
```

### 2. Thiết lập biến môi trường (.env)
Dự án sử dụng file `.env` để bảo mật thông tin.
Hãy tạo file `.env` ở thư mục gốc (cùng cấp với `pubspec.yaml`) với nội dung sau:
```env
API_URL=https://api.zenithlingua.com
```

### 3. Khởi tạo file Đa ngôn ngữ (l10n)
Dự án có hỗ trợ Tiếng Việt & Tiếng Anh thông qua file `.arb`. Trước khi chạy ứng dụng hoặc nếu có cập nhật file ngôn ngữ, bạn cần sinh ra các class phụ trợ bằng lệnh:
```bash
flutter gen-l10n
```

### 4. Khởi chạy
Giờ bạn có thể chạy ứng dụng trên máy ảo hoặc thiết bị thật:
```bash
flutter run
```

---

## 📝 Quy chuẩn viết code (Coding Guidelines)

- Không hardcode các text vào trong code, đặc biệt là các thông báo hiển thị cho người dùng. Mọi text phải được cấu hình vào `app_vi.arb` và `app_en.arb`.
- Xử lý lỗi từ Data Layer phải bắt buộc trả về `Either<Failure, T>` thông qua thư viện `dartz`.
- Cubit/Bloc chỉ tương tác với **UseCases**, không gọi thẳng vào Repository.
- Bất kỳ API request nào cần Authentication sẽ tự động được gán Bearer Token nhờ vào `TokenInterceptor`. Nếu token hết hạn (HTTP 401), Interceptor sẽ tự động thông báo để `AuthCubit` đẩy người dùng ra trang Đăng nhập.
