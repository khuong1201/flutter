## 🧠 Chi tiết kỹ thuật & Logic xử lý (Core Implementation Details)

Dự án này không tập trung vào độ phức tạp của giao diện mà tập trung vào sự bền bỉ (robustness) của mã nguồn. Dưới đây là cách hệ thống xử lý các vấn đề cốt lõi:

### 1. Data Layer: Xử lý JSON an toàn (Null Safety & Parsing)
* **Vấn đề:** Ứng dụng rất dễ bị crash (văng app) nếu API thay đổi cấu trúc trả về, hoặc trả về giá trị `null` ở một số trường dữ liệu.
* **Cách giải quyết trong code (`CoinModel`):** 
* Sử dụng toán tử `??` để cung cấp giá trị mặc định (fallback value) thay vì để ứng dụng nhận giá trị null.
* Chủ động ép kiểu dữ liệu: Sử dụng `.toString()` cho chuỗi và `.toDouble()` cho các con số để tránh lỗi sai định dạng giữa kiểu `int` và `double` từ Backend.

### 2. Network Layer: Quản lý rủi ro kết nối (API Service)
* **Vấn đề:** Mạng chậm, rớt mạng, hoặc server của bên thứ ba bị sập.
* **Cách giải quyết trong code (`ApiService`):**
* Thiết lập `timeout` cứng (10 giây) cho mọi request HTTP để ứng dụng không bị treo vô hạn ở màn hình loading khi mạng yếu.
* Phân tích rõ các mã HTTP Status Code: Trả về dữ liệu nếu `200 OK`, ném ra Exception (ngoại lệ) cảnh báo quá tải nếu gặp `429 Too Many Requests`, và báo lỗi hệ thống nếu gặp `500 Server Error`.
* Bọc toàn bộ quá trình gọi mạng trong khối `try-catch` để bắt lỗi rớt mạng hoàn toàn.

### 3. Business Logic Layer: Quản lý trạng thái (State Management)
* **Vấn đề:** Giao diện cần phản hồi ngay lập tức theo quá trình gọi mạng mà không làm giật lag ứng dụng.
* **Cách giải quyết trong code (`MarketProvider`):**
* Tách biệt 3 trạng thái rõ ràng: `_isLoading` (đang tải), `_errorMessage` (lỗi), và `_coins` (dữ liệu thành công).
* Xử lý luồng Pull-to-refresh: Khi người dùng chủ động vuốt để làm mới (`isRefresh = true`), hệ thống không kích hoạt lại trạng thái `_isLoading` toàn màn hình để giữ cho trải nghiệm cuộn được mượt mà, chỉ cập nhật lại danh sách ngầm và gọi `notifyListeners()`.

### 4. Presentation Layer: Tối ưu hiển thị (UI & UX)
* **Vấn đề:** Dữ liệu thô từ API thường không đẹp mắt và tải nhiều ảnh có thể làm tràn RAM.
* **Cách giải quyết trong code (`HomeScreen` & `CoinCard`):**
* Định dạng lại toàn bộ dữ liệu số bằng thư viện `intl` (hiển thị `$68,456.12` thay vì `68456.12`).
* Đổi màu động (Dynamic color): Chuyển UI sang màu Xanh/Đỏ tùy thuộc vào số liệu tăng hay giảm của đồng tiền.
* Sử dụng `cached_network_image` để tự động lưu ảnh logo vào bộ nhớ tạm (cache) của thiết bị, giúp giảm thiểu việc gọi lại mạng và tiết kiệm băng thông ở những lần mở app sau.
* Sử dụng `Future.microtask` trong hàm `initState` để gọi API an toàn trong chu trình build widget đầu tiên mà không vi phạm luồng render của Flutter.