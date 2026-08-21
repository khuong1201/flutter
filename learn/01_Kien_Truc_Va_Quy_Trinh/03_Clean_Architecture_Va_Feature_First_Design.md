# Bài 3: Clean Architecture và Feature-First Design trong Flutter

Khi dự án lớn lên (hàng trăm file), nếu bạn ném tất cả vào một thư mục `lib`, dự án sẽ trở thành một "bãi rác" không thể bảo trì. Do đó, chúng ta cần chia cấu trúc thư mục hợp lý.

Hiện nay, cộng đồng Flutter ưu chuộng nhất là cấu trúc **Feature-First** (Gom nhóm theo tính năng) kết hợp với các nguyên lý của **Clean Architecture** (chia lớp theo trách nhiệm).

## 1. Cấu trúc Feature-First
Thay vì nhóm theo loại file (tất cả models vào 1 chỗ, tất cả screens vào 1 chỗ), ta nhóm theo **Tính năng (Feature)**.

Ví dụ về cấu trúc thư mục:
```text
lib/
├── core/                   # Chứa các file dùng chung toàn app
│   ├── constants/          # Màu sắc, font chữ, các hằng số
│   ├── network/            # Cấu hình API chung (Dio, Interceptors)
│   ├── errors/             # Định nghĩa các loại lỗi (Exceptions, Failures)
│   ├── utils/              # Các hàm helper, format ngày tháng
│   └── widgets/            # Các widget dùng chung (CustomButton, Loading...)
│
├── features/               # Chứa các tính năng chính của app
│   ├── auth/               # Tính năng xác thực (Đăng nhập, đăng ký)
│   │   ├── data/           # Lớp dữ liệu
│   │   │   ├── models/     # Chuyển đổi JSON <-> Object
│   │   │   ├── datasources/# Gọi API hoặc gọi Database local
│   │   │   └── repositories/# Nơi quyết định lấy data từ local hay remote
│   │   ├── domain/         # Lớp cốt lõi (Không phụ thuộc Flutter)
│   │   │   ├── entities/   # Các Object thuần (User, Token)
│   │   │   ├── repositories/# Các interface hợp đồng (abstract classes)
│   │   │   └── usecases/   # Logic nghiệp vụ (Ví dụ: LoginUseCase)
│   │   └── presentation/   # Lớp giao diện (Flutter)
│   │       ├── bloc/       # State Management (BLoC/Cubit/Riverpod)
│   │       ├── screens/    # Các màn hình (LoginScreen)
│   │       └── widgets/    # Widget chỉ dùng riêng cho auth
│   │
│   ├── products/           # Tính năng sản phẩm
│   └── cart/               # Tính năng giỏ hàng
│
└── main.dart               # Điểm khởi chạy app
```

## 2. Lợi ích của kiến trúc này
1. **Dễ tìm kiếm**: Cần sửa lỗi đăng nhập? Cứ vào thẳng `features/auth`. Không cần phải nhảy múa giữa hàng tá thư mục.
2. **Khả năng tái sử dụng**: Bất cứ cái gì dùng ở 2 màn hình trở lên -> Đẩy vào `core/`.
3. **Độc lập (Decoupling)**: UI không bao giờ gọi trực tiếp API. UI gọi State Management (BLoC), State Management gọi UseCase, UseCase gọi Repository, Repository gọi Datasource. Nhờ đó, nếu đổi từ REST API sang Firebase, bạn chỉ cần sửa ở lớp Data, UI không hề bị ảnh hưởng.
4. **Dễ Test**: Việc chia nhỏ như thế này giúp bạn viết Unit Test cực kỳ dễ dàng bằng cách Mock (làm giả) các tầng bên dưới.

## 3. Thực hành
*Ghi chú: Trong các bài học tiếp theo, chúng ta sẽ bắt đầu viết code thực tế dựa trên chính bộ khung kiến trúc này.*
