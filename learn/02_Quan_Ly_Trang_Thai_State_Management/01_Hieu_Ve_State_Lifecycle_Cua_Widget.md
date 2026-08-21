# Bài 1: Hiểu về State và Vòng Đời (Lifecycle) Của Widget

Trong Flutter, mọi thứ đều là Widget, và Widget được điều khiển bởi **State (Trạng thái)**. Hiểu rõ State là bước quan trọng nhất trước khi bạn học bất kỳ thư viện quản lý trạng thái nào.

## 1. Ephemeral State vs App State
Có hai loại State trong Flutter:
- **Ephemeral State (State Tạm Thời)**: Chỉ tồn tại trong một Widget duy nhất. (Ví dụ: Trạng thái đang tải `isLoading` của một nút bấm, tab đang được chọn ở BottomNavigationBar). Chúng ta thường quản lý nó bằng `StatefulWidget` và `setState()`.
- **App State (State Ứng Dụng)**: Trạng thái được chia sẻ giữa nhiều màn hình. (Ví dụ: Thông tin User đã đăng nhập, Danh sách giỏ hàng). Chúng ta quản lý nó bằng Provider, Riverpod, BLoC...

## 2. Khi nào dùng `setState()`?
Nhiều người mới học thường lạm dụng `setState()` cho mọi thứ. Điều này khiến toàn bộ màn hình bị render (vẽ) lại liên tục, gây giật lag.
**Nguyên tắc:** Chỉ dùng `setState()` khi sự thay đổi chỉ ảnh hưởng đến UI nhỏ gọn bên trong màn hình hiện tại. Tuyệt đối không truyền State thông qua tham số (pass param) qua quá nhiều cấp Widget.

```dart
// Ví dụ đúng về Ephemeral State
class LikeButton extends StatefulWidget {
  @override
  _LikeButtonState createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
      color: isLiked ? Colors.red : Colors.grey,
      onPressed: () {
        setState(() { // Chỉ vẽ lại nút này, không ảnh hưởng toàn màn hình
          isLiked = !isLiked;
        });
      },
    );
  }
}
```

## 3. Vòng đời của StatefulWidget (Lifecycle)
Khi phỏng vấn, câu hỏi này xuất hiện 99%:

1. **`initState()`**: Chạy MỘT LẦN duy nhất khi Widget được tạo ra. Thường dùng để khởi tạo biến, đăng ký Stream, AnimationController. Không được gọi `context` ở đây trừ khi dùng `Future.delayed`.
2. **`didChangeDependencies()`**: Chạy ngay sau `initState()`, và chạy lại mỗi khi dependency (như InheritedWidget/Provider) thay đổi. Dùng khi cần lấy dữ liệu từ Provider lúc khởi tạo.
3. **`build()`**: Hàm quan trọng nhất. Được gọi nhiều lần để vẽ UI. Tuyệt đối KHÔNG ĐƯỢC call API hay tính toán nặng trong hàm này.
4. **`didUpdateWidget(oldWidget)`**: Chạy khi Widget cha vẽ lại và truyền tham số mới xuống Widget con này.
5. **`dispose()`**: Chạy MỘT LẦN khi Widget bị hủy (người dùng bấm back khỏi màn hình). Bắt buộc phải hủy (cancel) Stream, Timer, Controller ở đây để tránh **Memory Leak** (Rò rỉ bộ nhớ).

```dart
@override
void dispose() {
  _textEditingController.dispose();
  _scrollController.dispose();
  super.dispose();
}
```
