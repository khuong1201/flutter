# Database Design

## Tổng quan

Cơ sở dữ liệu được thiết kế theo mô hình quan hệ (Relational Database) sử dụng PostgreSQL nhằm phục vụ ứng dụng học viết Kanji/Hán tự. Hệ thống được chia thành ba nhóm dữ liệu chính:

- **Authentication & User:** Quản lý tài khoản người dùng.
- **Content:** Quản lý cấp độ, bài học, bộ thủ, từ vựng và dữ liệu Kanji/Hán tự (đặc biệt là dữ liệu nét chữ phục vụ học viết).
- **Progress & Spaced Repetition:** Theo dõi tiến độ học tập, đánh giá lỗi sai và lịch ôn tập theo thuật toán SM-2.

Tổng cộng hệ thống gồm **10 bảng**.

---

# MODULE 1: AUTH & USER

## Bảng `users`

Lưu trữ thông tin tài khoản người dùng.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | UUID | PK | Khóa chính |
| email | VARCHAR(100) | UNIQUE, NOT NULL | Email đăng nhập |
| password_hash | VARCHAR(255) | | Mật khẩu đã mã hóa (NULL nếu login OAuth) |
| full_name | VARCHAR(100) | NOT NULL | Tên hiển thị |
| target_language | VARCHAR(10) | NOT NULL | Ngôn ngữ học (`JP` hoặc `CN`) |
| xp_points | INT | DEFAULT 0 | Tổng điểm kinh nghiệm |
| created_at | TIMESTAMP | DEFAULT NOW() | Thời gian tạo |
| updated_at | TIMESTAMP | DEFAULT NOW() | Thời gian cập nhật |

---

# MODULE 2: CONTENT

## Bảng `levels`

Quản lý các cấp độ học (N5, N4, HSK1,...).

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | SERIAL | PK | Khóa chính |
| code | VARCHAR(20) | UNIQUE, NOT NULL | Mã cấp độ (JP_N5, CN_HSK1,...) |
| name | VARCHAR(50) | NOT NULL | Tên cấp độ |
| language | VARCHAR(10) | NOT NULL | Ngôn ngữ (`JP` hoặc `CN`) |

---

## Bảng `lessons`

Lưu danh sách các bài học thuộc từng cấp độ.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | SERIAL | PK | Khóa chính |
| level_id | INT | FK → levels(id) | Thuộc cấp độ nào |
| title | VARCHAR(150) | NOT NULL | Tên bài học |
| order_index | INT | NOT NULL | Thứ tự bài học trong level |

---

## Bảng `radicals` (Bộ thủ)

Lưu trữ thông tin các bộ thủ (dùng cho cả tiếng Trung và tiếng Nhật). Việc học bộ thủ rất quan trọng trong việc ghi nhớ nét chữ.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | SERIAL | PK | Khóa chính |
| radical_text | VARCHAR(5) | NOT NULL | Chữ bộ thủ (VD: 日, 月) |
| meaning | VARCHAR(100) | NOT NULL | Nghĩa bộ thủ |
| variants | JSONB | | Các biến thể (VD: Tâm đứng, Thủy ba chấm) |

---

## Bảng `characters`

Lưu trữ thông tin các Kanji/Hán tự. Dữ liệu nét vẽ (`stroke_data`) là trung tâm của tính năng học viết.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | SERIAL | PK | Khóa chính |
| char_text | VARCHAR(5) | NOT NULL | Chữ Kanji/Hán tự |
| language | VARCHAR(10) | NOT NULL | Ngôn ngữ (`JP` hoặc `CN`) |
| meaning | VARCHAR(255) | NOT NULL | Nghĩa tiếng Việt |
| pronunciation | JSONB | | Thông tin phát âm (On/Kun hoặc Pinyin) |
| audio_url | VARCHAR(255) | | Đường dẫn file phát âm |
| stroke_data | JSONB | NOT NULL | Dữ liệu vẽ nét chuẩn xác |

### Cấu trúc `stroke_data` (JSONB)

Mỗi phần tử trong mảng đại diện cho **một nét vẽ** theo đúng thứ tự (Index = Thứ tự viết). Khung mặc định (viewBox) cho các path là `1024x1024`.

```json
[
  {
    "type": "horizontal",
    "outline_path": "M10,20 L35,20...",
    "median_path": "M12,21 L33,21...",
    "points": [{"x": 12, "y": 21}, {"x": 33, "y": 21}]
  }
]
```
- `type`: Tên/loại nét (Ngang, Sổ, Phẩy...) để đọc hướng dẫn.
- `outline_path`: Đường viền bao ngoài, dùng vẽ tĩnh/bút lông cho đẹp.
- `median_path` (hoặc `points`): Đường xướng (centerline), dùng để thu thập hướng vuốt tay của người dùng và **chấm điểm độ chính xác**.

---

## Bảng `character_radicals`

Bảng trung gian để biết một chữ Kanji/Hán tự được cấu thành từ những bộ thủ nào.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| character_id | INT | PK, FK → characters(id) | Chữ Kanji/Hán tự |
| radical_id | INT | PK, FK → radicals(id) | Bộ thủ |

---

## Bảng `lesson_characters`

Bảng trung gian phân phối chữ vào các bài học.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| lesson_id | INT | PK, FK → lessons(id) | Bài học |
| character_id | INT | PK, FK → characters(id) | Chữ |
| order_index | INT | NOT NULL | Thứ tự xuất hiện trong bài |

---

## Bảng `vocabularies`

Lưu các từ vựng/ví dụ ghép từ Kanji/Hán tự để minh họa thực tế.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | SERIAL | PK | Khóa chính |
| character_id | INT | FK → characters(id) | Chữ chính |
| word | VARCHAR(50) | NOT NULL | Từ vựng (VD: 日本) |
| meaning | VARCHAR(255) | NOT NULL | Nghĩa của từ |
| pronunciation | VARCHAR(100) | | Cách đọc |

---

# MODULE 3: PROGRESS & SPACED REPETITION

## Bảng `user_progress`

Lưu tiến độ học tập chữ Hán/Kanji của từng người dùng (theo SM-2).

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | UUID | PK | Khóa chính |
| user_id | UUID | FK → users(id) | Người học |
| character_id | INT | FK → characters(id) | Chữ đang học |
| status | VARCHAR(20) | DEFAULT 'learning' | learning, review, graduated |
| ease_factor | DECIMAL(5,2) | DEFAULT 2.50 | Hệ số SM-2 |
| interval_days | INT | DEFAULT 0 | Chu kỳ ôn tập (ngày) |
| next_review_at | TIMESTAMP | NOT NULL | Lần ôn tiếp theo |
| total_reviews | INT | DEFAULT 0 | Tổng lượt ôn tập |
| consecutive_correct | INT | DEFAULT 0 | Chuỗi đúng liên tiếp |

---

## Bảng `review_logs`

Lịch sử ôn tập kèm chi tiết lỗi sai khi viết nét.

| Cột | Kiểu dữ liệu | Ràng buộc | Mô tả |
|------|--------------|-----------|-------|
| id | UUID | PK | Khóa chính |
| user_id | UUID | FK → users(id) | Người học |
| character_id | INT | FK → characters(id) | Chữ được ôn |
| action_type | VARCHAR(20) | NOT NULL | write_practice, quiz,... |
| grade | INT | NOT NULL | Điểm (0-5) |
| error_details | JSONB | | Lưu chi tiết lỗi (VD: sai nét thứ mấy, sai thứ tự) |
| created_at | TIMESTAMP | DEFAULT NOW() | Thời điểm ôn tập |

---

# Tóm tắt cơ sở dữ liệu

| Bảng | Chức năng |
|------|-----------|
| users | Quản lý tài khoản |
| levels | Quản lý cấp độ (N5, HSK1...) |
| lessons | Quản lý bài học |
| radicals | Quản lý bộ thủ |
| characters | Lưu dữ liệu chữ và nét vẽ chuẩn xác (hỗ trợ path/median) |
| character_radicals | Liên kết bộ thủ tạo thành chữ Hán/Kanji |
| lesson_characters | Liên kết bài học với chữ |
| vocabularies | Từ vựng/ví dụ ứng dụng chữ Hán/Kanji |
| user_progress | Tiến độ học tập và lịch SM-2 |
| review_logs | Lịch sử học tập và log lỗi chi tiết từng nét |