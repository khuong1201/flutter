# Bài 1: Quy Trình Phát Triển Phần Mềm (Agile/Scrum) trong Dự án Flutter

Khi tham gia vào một dự án thực tế, bạn không chỉ "mở máy lên và code". Làm việc nhóm đòi hỏi một quy trình chuẩn xác để mọi người hiểu nhau và tiến độ được đảm bảo. Phương pháp phổ biến nhất hiện nay là **Agile/Scrum**.

## 1. Các khái niệm cơ bản trong Scrum
- **Product Backlog**: Danh sách toàn bộ các tính năng cần làm của ứng dụng (Ví dụ: Đăng nhập, Đăng ký, Xem danh sách sản phẩm...).
- **Sprint**: Một vòng lặp thời gian ngắn (thường từ 1 đến 2 tuần). Team cam kết hoàn thành một lượng công việc nhất định trong khoảng thời gian này.
- **Sprint Planning**: Buổi họp đầu Sprint để chọn task từ Backlog đưa vào Sprint hiện tại.
- **Daily Standup**: Buổi họp ngắn 15 phút mỗi sáng. Mỗi người trả lời 3 câu: Hôm qua làm gì? Hôm nay làm gì? Có khó khăn (blocker) gì không?
- **Sprint Review & Retrospective**: Cuối Sprint, demo sản phẩm cho khách hàng và họp nội bộ rút kinh nghiệm.

## 2. Quy trình nhận Task và xử lý (Thực tế)
Giả sử bạn được giao một Task trên Jira: *"Làm màn hình Đăng nhập"*.

### Bước 1: Đọc và phân tích Requirement (Yêu cầu)
- Đọc kỹ mô tả (Description), các tiêu chí chấp nhận (Acceptance Criteria).
- Xem thiết kế trên Figma/Zeplin.
- Nếu thấy thiếu API hoặc thiết kế không hợp lý -> Hỏi lại BA (Business Analyst) hoặc Designer ngay lập tức. Không tự ý bịa ra.

### Bước 2: Estimate (Ước lượng thời gian)
- Chia nhỏ Task ra:
  - Cắt giao diện UI: 4 giờ
  - Viết logic Validate form (Email hợp lệ, Pass > 6 ký tự): 2 giờ
  - Ghép API Login: 2 giờ
  - Test lại các trường hợp lỗi: 1 giờ
- Tổng cộng: 9 giờ (~ 1 ngày làm việc hơn).

### Bước 3: Bắt tay vào Code
- Tạo nhánh (Branch) mới trên Git (Chúng ta sẽ học chi tiết ở bài 2).
- Bắt đầu code theo chuẩn kiến trúc của dự án.
- Viết Unit Test (nếu dự án yêu cầu).

### Bước 4: Review và Merge Code
- Chạy thử trên máy thật hoặc máy ảo để đảm bảo không lỗi.
- Tạo Pull Request (PR) hoặc Merge Request (MR).
- Nhờ Leader hoặc đồng nghiệp review code. Sửa code nếu được yêu cầu.
- Merge code vào nhánh chung (develop).

### Bước 5: Cập nhật trạng thái
- Kéo Task trên Jira từ trạng thái `In Progress` sang `Resolved` hoặc `Ready for QA`.
- Tester (QA) sẽ nhảy vào test tính năng của bạn. Nếu có Bug, họ sẽ log Bug và assign lại cho bạn.

---
> Mẹo: Đừng bao giờ âm thầm chịu đựng khi bị kẹt (block). Nếu bạn tìm lỗi (debug) quá 2 tiếng mà không ra, hãy mạnh dạn nhờ đồng nghiệp hoặc Leader giúp đỡ. Giao tiếp là kỹ năng quan trọng nhất của một lập trình viên.
