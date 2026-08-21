# Bài 2: Git Flow và Quản Lý Phiên Bản

Git là kỹ năng sống còn. Trong dự án thực tế, bạn không bao giờ commit thẳng lên nhánh `master` hoặc `main`. Chúng ta sử dụng **Git Flow**.

## 1. Các Nhánh (Branches) chính trong Git Flow
- `master` / `main`: Nhánh chứa code đang chạy thực tế trên App Store / Google Play. Cực kỳ ổn định.
- `develop`: Nhánh gom code của cả team. Mọi tính năng mới sẽ được ghép vào đây để test nội bộ.
- `feature/...`: Nhánh dùng để phát triển một tính năng mới (ví dụ: `feature/login`, `feature/cart`). Tách ra từ `develop`.
- `hotfix/...`: Nhánh dùng để sửa lỗi khẩn cấp trên production. Tách ra từ `master`.
- `release/...`: Nhánh dùng để chuẩn bị đóng gói đẩy lên Store.

## 2. Quy trình làm một tính năng bằng Git (Thực hành)

**Bước 1: Cập nhật code mới nhất từ team**
Luôn luôn lấy code mới nhất trước khi làm việc để tránh conflict.
```bash
git checkout develop
git pull origin develop
```

**Bước 2: Tạo nhánh riêng cho tính năng của bạn**
Giả sử bạn làm tính năng Đăng nhập.
```bash
git checkout -b feature/login
```

**Bước 3: Code và Commit**
Bạn tiến hành code Flutter bình thường. Sau khi xong một phần (ví dụ UI xong), hãy commit.
```bash
git add .
git commit -m "feat: Thêm giao diện màn hình đăng nhập"
```
*Lưu ý cách đặt tên commit (Conventional Commits):*
- `feat:` Khi thêm tính năng mới.
- `fix:` Khi sửa một bug.
- `refactor:` Khi sửa code cho đẹp/tốt hơn mà không đổi logic.
- `chore:` Khi cập nhật thư viện, file config.

**Bước 4: Đẩy code lên server (GitHub/GitLab/Bitbucket)**
```bash
git push origin feature/login
```

**Bước 5: Tạo Pull Request (PR)**
- Lên giao diện web của GitHub/GitLab, tạo PR từ nhánh `feature/login` vào nhánh `develop`.
- Tag tên đồng nghiệp vào để họ **Review Code**.
- Nếu họ comment bắt sửa, bạn sửa dưới máy, commit và push lên lại.
- Nếu họ OK (Approve), bạn hoặc Leader sẽ bấm nút **Merge** để trộn code vào `develop`.

## 3. Xử lý Xung đột (Conflict)
Conflict xảy ra khi bạn và đồng nghiệp cùng sửa chung một file ở cùng một dòng.
Cách giải quyết:
1. `git pull origin develop` (lấy code mới nhất về nhánh của bạn).
2. Git sẽ báo file bị conflict (chữ màu đỏ, có các dấu `<<<<<<<`).
3. Mở VS Code, nó sẽ hỏi bạn muốn giữ code của bạn (Current Change) hay code của đồng nghiệp (Incoming Change), hoặc giữ cả hai.
4. Lựa chọn xong, lưu file lại.
5. `git add .` và `git commit -m "fix: resolve conflict"` rồi push lên lại.
