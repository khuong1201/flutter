# Bài 5: Các Bước Đẩy Ứng Dụng Lên Store (Bản Chính Thức)

Đây là chặng đường cuối cùng! Đưa "Đứa con tinh thần" của bạn đến tay hàng triệu người dùng.

## 1. Google Play Console (Android)
Phí đăng ký tài khoản lập trình viên: **$25 (Đóng 1 lần duy nhất trọn đời)**.

**Các bước tạo phiên bản phát hành:**
1. Đăng nhập web `play.google.com/console`.
2. Bấm "Tạo ứng dụng" (Create app).
3. Thiết lập thông tin Cửa hàng (Store presence):
   - **Tên app**, Mô tả ngắn, Mô tả dài chuẩn SEO.
   - **Biểu tượng (Icon)**: Khổ 512x512 png.
   - **Đồ hoạ đặc trưng (Feature graphic)**: Khổ 1024x500 (Cái ảnh bìa to chà bá).
   - **Ảnh chụp màn hình (Screenshots)**: Thiết kế ít nhất 4 ảnh đẹp, có chèn khung viền điện thoại vào nhìn cho chuyên nghiệp.
4. Điền phiếu khảo sát nội dung (Phù hợp độ tuổi nào? Có bạo lực không?).
5. Trả lời các câu hỏi về Thu thập Dữ liệu (Rất quan trọng! Nếu app bạn gọi API lấy Tên, Email khách hàng mà bạn không khai báo ở đây, Google phát hiện sẽ Xoá app ngay lập tức).
6. Tạo một Bản phát hành mới (Production Release), up file `.aab` bạn đã build lên.
7. Bấm Gửi để xem xét. Chờ Google duyệt (Khoảng 2 đến 7 ngày).

## 2. App Store Connect (iOS)
Phí đăng ký: **$99 mỗi năm**. Nếu không đóng phí tiếp, App bị gỡ khỏi Store!

**Các bước tạo phiên bản phát hành:**
1. Đăng nhập web `appstoreconnect.apple.com`.
2. Bấm nút dấu + tạo "New App". (Phải chọn đúng cái Bundle ID đã khai báo bên trang Developer lúc tạo Certificate).
3. Tương tự Google, điền các thông tin Tên, Subtitle, Keywords (Từ khóa tìm kiếm).
4. **Khâu mệt mỏi nhất - Chụp Screenshots**: Apple khắt khe kinh khủng. Bạn bắt buộc phải chụp hoặc làm ảnh ghép đúng kích thước phần cứng của iPhone 6.5 inch (1284x2778) và 5.5 inch (1242x2208). Sai 1 pixel nó cũng không cho up.
5. Từ Xcode (Bài 3), sau khi bạn bấm Archive -> Distribute App, file build sẽ chạy lên mây. Bạn quay lại web App Store Connect, cuộn xuống mục **Build**, bấm chọn cái bản vừa đẩy lên.
6. Cung cấp tài khoản test (Demo account) cho nhân viên Apple. Họ không test bằng máy tính, có 1 nhân viên người thật sẽ cầm iPhone tải app của bạn về để dò lỗi. Nếu app bạn yêu cầu Đăng nhập, bạn phải tạo sẵn 1 cái ID và Pass ghi vào form để họ xài.
7. Bấm Submit for Review. Nếu app giật lag hoặc UI quá xấu, nhân viên Apple sẽ đánh rớt (Reject) với lý do: *"Ứng dụng không cung cấp đủ giá trị tối thiểu"*. Bạn phải sửa lại giao diện rồi nộp lại!

**Chúc mừng bạn đã hoàn thành trọn bộ Khóa học Flutter Thực Chiến!!!**
