# API Design

## Tổng quan

Hệ thống Backend được xây dựng theo kiến trúc **Modular Monolith** và **Domain-Driven Design (DDD)**. Các API được thiết kế theo chuẩn REST và chia thành các module độc lập.

> **Lưu ý:** Source of Truth (Nguồn chân lý) cho toàn bộ tài liệu API là **Swagger**. Tài liệu này chỉ mô tả cấu trúc tổng quan. Để xem chi tiết các parameter, request body và response, vui lòng truy cập giao diện Swagger UI khi chạy dự án.

Đường dẫn Swagger mặc định: `http://localhost:<PORT>/api/docs`

---

## Danh sách các Module & Endpoints

Các Endpoint dưới đây phản ánh chính xác các Controller đang tồn tại trong hệ thống. Hệ thống không sử dụng global prefix (như `/api/v1`) mà truy cập trực tiếp qua tên domain module.

### 1. Module Authentication (`/auth`)
Xử lý các nghiệp vụ xác thực và cấp phát JWT.
- **POST** `/auth/register` - Đăng ký tài khoản mới.
- **POST** `/auth/login` - Đăng nhập, trả về Access Token.

### 2. Module Users (`/users`)
Quản lý thông tin hồ sơ và điểm XP của người dùng. Yêu cầu **JWT Auth**.
- **GET** `/users/profile` - Lấy thông tin cá nhân của người dùng hiện tại (lấy ID từ JWT).

### 3. Module Lessons (`/lessons`)
Quản lý cấu trúc bài học và cấp độ. Yêu cầu **JWT Auth**.
- **GET** `/lessons/levels` - Lấy danh sách các cấp độ (Level) kèm theo bài học (Lesson) tương ứng. Dữ liệu tĩnh nên thường xuyên được lưu cache.

### 4. Module Characters (`/characters`)
Quản lý chi tiết chữ Hán/Kanji, bộ thủ và từ vựng liên quan. Yêu cầu **JWT Auth**.
- **GET** `/characters/:id` - Trả về dữ liệu chi tiết của một chữ bao gồm nét vẽ (`strokeData`), bộ thủ (`radicals`) và từ vựng (`vocabularies`). Dữ liệu có thể được lưu cache.

### 5. Module Practice (`/practice`)
Xử lý kết quả luyện tập và lưu vết (Review Logs). Yêu cầu **JWT Auth**.
- **POST** `/practice/review` - Nơi Client gửi kết quả làm bài tập (đánh giá từ 0-5). API này sẽ lưu lịch sử (ReviewLog) đồng thời gọi ngầm module `Progress` để cập nhật tiến độ thuật toán SM-2.

### 6. Module Health (`/health`)
Endpoint kiểm tra sức khỏe của dịch vụ, phục vụ hệ thống Monitor/Kubernetes.
- **GET** `/health` - Trả về trạng thái hoạt động của Server, Database và Redis.

---

## Nguyên tắc thiết kế API (Theo AGENTS.md)

1. **Thin Controllers:** Controller chỉ làm nhiệm vụ tiếp nhận HTTP request, gọi các **Use Case** tương ứng ở tầng Application và trả về Response. Mọi logic nghiệp vụ phải nằm trong Use Case hoặc Domain Service.
2. **Swagger Required:** Mọi sửa đổi, thêm mới API đều phải gắn Decorator của Swagger (`@ApiTags`, `@ApiOperation`, `@ApiResponse`, v.v.) trong Controller và DTO.
3. **DTO & Validation:** Dữ liệu đầu vào bắt buộc phải đi qua DTO và được validate nghiêm ngặt bằng `class-validator`. Không sử dụng kiểu `any`.
4. **Early Returns & Typed Responses:** Ưu tiên trả về sớm (early returns) nếu xảy ra lỗi. Response trả về cần có kiểu dữ liệu rõ ràng.
5. **Separation of Concerns:** Các module giao tiếp với nhau thông qua Dependency Injection của Use Case hoặc Domain Service (ví dụ: `PracticeModule` gọi `UpdateProgressUseCase` của `ProgressModule`). Tuyệt đối không query cơ sở dữ liệu xuyên module hay bỏ qua Repository.

---

## Kiến trúc luồng xử lý

```text
               Client (Flutter)
                      │
            HTTPS + JWT Authentication
                      │
       ┌──────────────┼──────────────┐
       │              │              │
       ▼              ▼              ▼
     Auth         Characters      Practice
    Users          Lessons       (Progress)
       │              │              │
       └──────────────┼──────────────┘
                      │
               Infrastructure
           (Prisma / PostgreSQL / Redis)
```