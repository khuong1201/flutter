# Tài liệu API & Luồng hoạt động (App Flow)

Tài liệu này tóm tắt toàn bộ luồng hoạt động của ứng dụng học tập và chi tiết các API Endpoint (bao gồm Request & Response) phản ánh chính xác cấu trúc Controller hiện tại trong Source Code.
> **Lưu ý quan trọng:** Mọi API ngoại trừ Đăng nhập/Đăng ký đều yêu cầu Header `Authorization: Bearer <access_token>`.

---

## I. Luồng Hoạt Động Của Ứng Dụng (App Flow)

1. **Khởi tạo và Đăng nhập (Auth):** User đăng ký (`/auth/register`) hoặc đăng nhập (`/auth/login`, `/auth/social-login`) để lấy `accessToken` và `refreshToken`.
2. **Khám phá (Curriculum):**
   - Lấy danh sách các cấp độ ngôn ngữ (VD: N5, N4) qua `/levels` hoặc `/lessons/levels`.
   - Xem lộ trình học tập cá nhân qua `/lessons/roadmap`.
   - Chọn một cấp độ để xem các bài học `/levels/:id/lessons`.
   - Xem danh sách chữ Hán/từ vựng trong bài học `/lessons/:id/characters`.
   - Tra cứu từ điển chữ Hán `/characters` và chi tiết chữ Hán `/characters/:id`.
3. **Luyện tập (Practice):** User luyện tập trắc nghiệm qua `/practice/quiz` hoặc luyện viết chữ Hán qua `/practice/evaluate-handwriting`. Khi hoàn thành một bài học, gọi `/lessons/:id/complete` để ghi nhận điểm kinh nghiệm (XP) và đóng góp (Contribution).
4. **Ôn tập (SRS):** Mỗi ngày User mở ứng dụng, lấy danh sách thẻ bài đến hạn ôn tập bằng `/progress/due`, sau đó trả kết quả đánh giá (Grade từ 0-5) về `/practice/review` để thuật toán Spaced Repetition tính toán chu kỳ lặp kế tiếp.
5. **Cộng đồng & Thi đua (Community & Leaderboard):** 
   - Xem thống kê học tập (Accuracy, Streak) qua `/progress/stats`.
   - Xem biểu đồ đóng góp (Heatmap Github-style) qua `/contributions`.
   - Quản lý thông tin cá nhân (`/users/profile`) và đua top (`/users/leaderboard`).

---

## II. Chi Tiết Các Endpoint API

### 1. Identity & Access Management (IAM)

#### `POST /auth/login`
- **Desc:** Đăng nhập bằng email và password.
- **Req:**
```json
{
  "email": "user@example.com",
  "password": "password123"
}
```
- **Res (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUz...",
  "refreshToken": "eyJhbGciOiJIUz..."
}
```

#### `POST /auth/register`
- **Desc:** Đăng ký tài khoản mới (Không yêu cầu targetLanguage trong request).
- **Req:**
```json
{
  "email": "user@example.com",
  "password": "password123",
  "fullName": "Nguyen Van A"
}
```
- **Res (201):**
```json
{
  "accessToken": "eyJhbGciOiJIUz...",
  "refreshToken": "eyJhbGciOiJIUz..."
}
```

#### `POST /auth/social-login`
- **Desc:** Đăng nhập qua mạng xã hội (Google, Apple).
- **Req:**
```json
{
  "provider": "google",
  "idToken": "eyJhb..."
}
```
- **Res (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUz...",
  "refreshToken": "eyJhbGciOiJIUz..."
}
```

#### `POST /auth/refresh-token`
- **Desc:** Cấp lại Token mới khi thẻ Access cũ hết hạn.
- **Req:**
```json
{
  "refreshToken": "eyJhbGciOiJIUz..."
}
```
- **Res (200):**
```json
{
  "accessToken": "eyJhbGciOiJIUz...",
  "refreshToken": "eyJhbGciOiJIUz..."
}
```

#### `GET /users/profile`
- **Desc:** Lấy thông tin cá nhân hiện tại.
- **Res (200):**
```json
{
  "id": "123e4567-e89b-12d3...",
  "email": "user@example.com",
  "fullName": "Nguyen Van A",
  "targetLanguage": "ja",
  "targetLevel": "N5",
  "xpPoints": 1500,
  "currentStreak": 5,
  "longestStreak": 10,
  "avatarUrl": "https://..."
}
```

#### `PUT /users/profile`
- **Desc:** Cập nhật thông tin cá nhân.
- **Req:**
```json
{
  "fullName": "Nguyen Van B",
  "targetLevel": "N4",
  "avatarUrl": "https://..."
}
```
- **Res (200):**
*(Trả về object User tương tự như GET /users/profile)*

#### `GET /users/leaderboard`
- **Desc:** Lấy bảng xếp hạng điểm XP.
- **Query:** `?limit=10`
- **Res (200):**
```json
[
  {
    "id": "uuid",
    "fullName": "Nguyen Van A",
    "xpPoints": 5000,
    "avatarUrl": "https://..."
  }
]
```

---

### 2. Curriculum (Giáo trình & Bài học)

#### `GET /levels`
- **Desc:** Lấy danh sách toàn bộ các cấp độ (VD: N5, N4).
- **Res (200):**
```json
[
  {
    "id": 1,
    "system": "JLPT",
    "code": "N5",
    "name": "JLPT N5",
    "language": "ja"
  }
]
```

#### `GET /levels/:id/lessons`
- **Desc:** Lấy danh sách bài học thuộc một cấp độ cụ thể.
- **Res (200):**
```json
[
  {
    "id": 101,
    "levelId": 1,
    "title": "Lesson 1: Greetings",
    "orderIndex": 1
  }
]
```

#### `GET /lessons/roadmap`
- **Desc:** Lấy lộ trình học tập của user, gom nhóm theo từng cấp độ và bao gồm trạng thái bài học.
- **Res (200):**
```json
[
  {
    "levelId": 1,
    "levelName": "JLPT N5",
    "lessons": [
      {
        "id": 101,
        "title": "Lesson 1",
        "status": "completed"
      }
    ]
  }
]
```

#### `GET /lessons/:id/characters`
- **Desc:** Lấy danh sách các chữ Hán có trong một bài học.
- **Res (200):**
```json
[
  {
    "id": 501,
    "charText": "今",
    "language": "ja",
    "meaning": "Hiện tại",
    "audioKey": "audio/ima.mp3",
    "pronunciation": "いま"
  }
]
```

#### `POST /lessons/:id/complete`
- **Desc:** Đánh dấu một bài học là đã hoàn thành. Hệ thống sẽ cấp điểm XP và ghi nhận một Contribution vào lịch sử học tập trong ngày.
- **Res (201):**
```json
{
  "success": true
}
```

#### `GET /characters`
- **Desc:** Tìm kiếm chữ Hán.
- **Query:** `?q=hello&limit=10`
- **Res (200):**
*(Trả về mảng Object Character thu gọn)*

#### `GET /characters/:id`
- **Desc:** Xem chi tiết 1 chữ Hán, bao gồm âm đọc, bộ thủ và danh sách nét (strokes).
- **Res (200):**
```json
{
  "id": 501,
  "charText": "今",
  "language": "ja",
  "meaning": "Hiện tại",
  "audioKey": "audio/characters/ima.mp3",
  "readings": [
    { "reading": "コン", "readingType": "onyomi" },
    { "reading": "いま", "readingType": "kunyomi" }
  ],
  "radicals": [
    { "id": 10, "radicalText": "人", "meaning": "Người" }
  ],
  "strokes": [
    { "order": 1, "medianPath": "[[10,20], [15,25]]", "outlinePath": "..." }
  ]
}
```

#### `GET /characters/:id/audio`
- **Desc:** Lấy audio đọc chữ Hán. Hệ thống sử dụng TTS nếu chưa có audio cache sẵn trong Storage.
- **Res (200):** *(Trả về file âm thanh stream/binary)*

---

### 3. Learning & Progress (Ôn tập & Đánh giá)

#### `GET /progress/due`
- **Desc:** Lấy danh sách các chữ Hán đến hạn ôn tập trong ngày hôm nay theo thuật toán SRS.
- **Res (200):**
```json
[
  {
    "id": "uuid",
    "characterId": 501,
    "status": "learning",
    "nextReviewAt": "2026-08-14T00:00:00Z",
    "character": {
      "id": 501,
      "charText": "今",
      "meaning": "Hiện tại"
    }
  }
]
```

#### `GET /progress/stats`
- **Desc:** Xem các thống kê học tập (dành cho màn Profile).
- **Res (200):**
```json
{
  "totalLearned": 150,
  "totalMastered": 50,
  "accuracyRate": 85.5,
  "currentStreak": 5,
  "xpPoints": 1500
}
```

#### `GET /practice/quiz`
- **Desc:** Sinh bài tập trắc nghiệm ngẫu nhiên từ bài học.
- **Query:** `?lessonId=1&limit=10`
- **Res (200):**
```json
[
  {
    "questionType": "meaning",
    "characterId": 501,
    "question": "Nghĩa của chữ 今 là gì?",
    "options": ["Hiện tại", "Tương lai", "Quá khứ", "Hôm nay"],
    "correctAnswer": "Hiện tại"
  }
]
```

#### `POST /practice/review`
- **Desc:** Gửi điểm đánh giá (Grade) của thẻ bài để hệ thống SRS tính toán chu kỳ lặp (interval) kế tiếp.
- **Req:**
```json
{
  "characterId": 501,
  "grade": 4 
}
```
*(grade từ 0 đến 5, 0 = Quên sạch, 3 = Nhớ mang máng, 5 = Nhớ hoàn hảo)*
- **Res (201):**
```json
{
  "success": true
}
```

#### `POST /practice/evaluate-handwriting`
- **Desc:** Chấm điểm độ chính xác nét vẽ Hán tự viết tay của người dùng so với nét chuẩn.
- **Req:** 
```json
{
  "characterId": 501,
  "userStrokes": [
    [{"x": 10, "y": 20}, {"x": 15, "y": 25}],
    [{"x": 5, "y": 50}, {"x": 12, "y": 55}]
  ]
}
```
- **Res (201):**
```json
{
  "score": 85,
  "feedback": "Good, but could be more accurate."
}
```

---

### 4. Community (Cộng đồng)

#### `GET /contributions`
- **Desc:** Lấy biểu đồ đóng góp (Contribution Heatmap) tương tự Github.
- **Query:** `?year=2026` (Tùy chọn)
- **Res (200):**
```json
[
  {
    "date": "2026-08-14",
    "count": 5
  },
  {
    "date": "2026-08-15",
    "count": 2
  }
]
```