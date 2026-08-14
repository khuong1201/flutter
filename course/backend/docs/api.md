# Tài liệu API & Luồng hoạt động (App Flow)

Tài liệu này tóm tắt toàn bộ luồng hoạt động của ứng dụng học tập và chi tiết các API Endpoint (bao gồm Request & Response) để đội ngũ Frontend dễ dàng tích hợp.
> **Lưu ý quan trọng:** Mọi API ngoại trừ Đăng nhập/Đăng ký đều yêu cầu Header `Authorization: Bearer <access_token>`.

---

## I. Luồng Hoạt Động Của Ứng Dụng (App Flow)

1. **Khởi tạo và Đăng nhập (Auth):** User đăng nhập hoặc đăng ký để lấy `accessToken` và `refreshToken`.
2. **Khám phá (Curriculum):** App gọi `/levels` -> `/levels/:id/lessons` -> `/lessons/:id/vocabularies` để hiển thị cây bài học và danh sách từ vựng/chữ Hán.
3. **Luyện tập (Practice):** User luyện tập trắc nghiệm qua `/practice/quiz` hoặc luyện viết qua `/practice/evaluate-handwriting`.
4. **Ôn tập (SRS):** Mỗi ngày User vào app, gọi `/progress/due-reviews` để lấy danh sách thẻ bài đến hạn ôn tập, sau đó trả kết quả về `/practice/review` để hệ thống tính toán chu kỳ lặp kế tiếp.
5. **Cạnh tranh (Leaderboard):** User xem thông tin cá nhân (`/users/profile`) và đua top (`/users/leaderboard`).

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
- **Desc:** Đăng ký tài khoản mới.
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
- **Req:** *None*
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
- **Req:** *None*
- **Res (200):**
```json
[
  {
    "id": "uuid",
    "fullName": "Nguyen Van A",
    "xpPoints": 5000,
    "avatarUrl": "https://..."
  },
  {
    "id": "uuid2",
    "fullName": "Le Thi B",
    "xpPoints": 4500,
    "avatarUrl": "https://..."
  }
]
```

---

### 2. Curriculum (Chương trình học Read-only)

#### `GET /levels`
- **Desc:** Lấy danh sách các cấp độ (HSK 1-9, JLPT N5-N1).
- **Req:** *None*
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
- **Req:** *None*
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

#### `GET /lessons/:id/vocabularies`
- **Desc:** Lấy toàn bộ danh sách từ vựng, âm đọc, và các chữ Hán cấu thành.
- **Req:** *None*
- **Res (200):**
```json
[
  {
    "id": 1001,
    "word": "こんにちは",
    "meaning": "Xin chào",
    "language": "ja",
    "readings": [
      { "reading": "こんにちは", "romaji": "konnichiwa" }
    ],
    "characters": [
      {
        "id": 501,
        "charText": "今",
        "meaning": "Hiện tại",
        "orderIndex": 1
      }
    ]
  }
]
```

#### `GET /characters/:id`
- **Desc:** Xem chi tiết 1 chữ Hán.
- **Req:** *None*
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

#### `GET /characters/search`
- **Desc:** Tìm kiếm chữ Hán.
- **Query:** `?q=hello`
- **Req:** *None*
- **Res (200):**
*(Trả về mảng Object Character tương tự API chi tiết ở trên nhưng rút gọn)*

---

### 3. Learning & Practice (Học tập & SRS)

#### `GET /progress/due-reviews`
- **Desc:** Lấy danh sách các Chữ Hán/Từ vựng đến hạn phải ôn tập trong ngày hôm nay theo thuật toán SRS.
- **Req:** *None*
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
- **Desc:** Xem các thống kê học tập cá nhân.
- **Req:** *None*
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
- **Desc:** Sinh một bài trắc nghiệm ngẫu nhiên.
- **Query:** `?lessonId=1&limit=10`
- **Req:** *None*
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
- **Desc:** Gửi kết quả chấm điểm ôn tập để hệ thống cập nhật thẻ ghi nhớ SRS.
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
- **Desc:** Chấm điểm độ chính xác nét vẽ do người dùng viết tay so với nét chuẩn.
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
- **Res (200):**
```json
{
  "score": 85,
  "feedback": "Good, but could be more accurate."
}
```