# Tài Liệu API Contract & ApiCode cho Frontend

Tài liệu này mô tả định dạng chuẩn của toàn bộ API trả về từ Backend (kể cả thành công hay thất bại), giúp Frontend dễ dàng xây dựng Base API Client (như Axios Interceptors) và xử lý giao diện.

---

## 1. Định Dạng Chuẩn Của API (Standard API Wrapper)

Tất cả các API (trừ khi có thiết kế đặc biệt) sẽ luôn trả về một JSON Object gồm 3 fields chính: `code`, `message`, và `data`.

### 🟢 Khi Thành Công (Success Response)

- **HTTP Status Code**: `200 OK` hoặc `201 Created`
- `code`: Luôn là `"SUCCESS"`
- `data`: Chứa kết quả thực tế của API (object, mảng, v.v.). Có thể là `null` nếu API không có dữ liệu trả về.

**Ví dụ:**
```json
{
  "code": "SUCCESS",
  "message": "Success",
  "data": {
    "accessToken": "eyJhbGciOiJIUzI1NiIsInR5c..."
  }
}
```

### 🔴 Khi Thất Bại (Error Response)

- **HTTP Status Code**: `400`, `401`, `403`, `404`, `409`, `500`...
- `code`: Mã lỗi định danh (String) giúp FE xác định chính xác nguyên nhân lỗi (tham khảo bảng ApiCode bên dưới).
- `data`: Luôn là `null` (hoặc chứa thông tin debug nếu có).
- `statusCode`: Mã HTTP Status thực tế (nếu FE cần dùng thêm).

**Ví dụ (Lỗi Đăng Nhập):**
```json
{
  "code": "INVALID_CREDENTIALS",
  "message": "Invalid email or password",
  "data": null,
  "statusCode": 401,
  "timestamp": "2026-08-11T01:03:20Z",
  "path": "/auth/login"
}
```

**Ví dụ (Lỗi Validation đầu vào):**
```json
{
  "code": "BAD_REQUEST",
  "message": ["email must be an email", "password should not be empty"],
  "data": null,
  "statusCode": 400,
  "timestamp": "2026-08-11T01:03:20Z",
  "path": "/auth/register"
}
```

---

## 2. Bảng Danh Sách ApiCode

FE nên tạo một Enum hoặc Constant với các mã này để so sánh logic khi nhận response (ví dụ: `if (response.code === ApiCode.TOKEN_EXPIRED) { logout() }`).

| ApiCode | HTTP Status | Mô Tả Dành Cho FE |
| :--- | :--- | :--- |
| `SUCCESS` | `200` / `201` | Gọi API thành công. |
| `BAD_REQUEST` | `400` | Dữ liệu FE gửi lên bị sai (sai format, thiếu field, validation failed...). Thông báo lỗi chi tiết nằm trong `message`. |
| `UNAUTHORIZED` | `401` | User chưa đăng nhập, chưa truyền Token hoặc truy cập bị chặn. |
| `FORBIDDEN` | `403` | User đã đăng nhập nhưng không có quyền thực hiện hành động này. |
| `NOT_FOUND` | `404` | Không tìm thấy resource yêu cầu (ví dụ: Get user profile nhưng user bị xoá). |
| `INTERNAL_ERROR` | `500` | Lỗi bất ngờ từ Backend (Server Crash, Database Die). FE nên hiện thông báo chung "Hệ thống đang bảo trì...". |
| `VALIDATION_ERROR` | `400` | Dữ liệu không hợp lệ (tương tự BAD_REQUEST nhưng đặc tả riêng cho validation logic). |
| `USER_EXISTS` | `409` | Lỗi khi gọi Đăng Ký: Email hoặc Username đã tồn tại trong hệ thống. |
| `USER_NOT_FOUND` | `404` | Không tìm thấy User (có thể xảy ra khi tra cứu thông tin user khác). |
| `INVALID_CREDENTIALS`| `401` | Lỗi khi gọi Đăng Nhập: Sai email, password hoặc account đăng nhập bằng Google/Apple nhưng lại dùng form mật khẩu. |
| `TOKEN_EXPIRED` | `401` | Token JWT đã hết hạn. Màn hình nên gọi API Refresh Token hoặc force logout User. |
| `TOKEN_INVALID` | `401` | Token JWT truyền lên bị sai, bị thay đổi hoặc không hợp lệ. Nên force logout User. |

---

> **Gợi ý thiết kế API Client cho FE:**
> FE nên cấu hình Axios Interceptors:
> 1. Bắt tất cả Response, nếu trả về HTTP 2xx thì return trực tiếp `response.data.data` cho Component dùng.
> 2. Nếu trả về HTTP 4xx/5xx thì check `response.data.code` để `Toast/Alert` tự động, hoặc catch riêng biệt trong các form (VD: form Login check `INVALID_CREDENTIALS`).
> 3. Nếu `code` là `TOKEN_EXPIRED` hoặc `TOKEN_INVALID` thì tự động xóa token ở local storage và redirect về màn hình Login.
