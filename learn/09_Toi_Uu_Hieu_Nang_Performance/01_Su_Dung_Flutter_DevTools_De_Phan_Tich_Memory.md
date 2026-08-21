# Bài 1: Sử Dụng Flutter DevTools Để Phân Tích Memory (RAM)

Flutter DevTools là bộ công cụ quyền năng nhất để "khám bệnh" cho ứng dụng. Khi app chạy mượt trên máy tính bạn, chưa chắc nó đã mượt trên một chiếc Android đời cũ RAM 2GB. 

Lỗi phổ biến nhất gây sập App chính là **Memory Leak (Rò rỉ bộ nhớ)**.

## 1. Rò rỉ bộ nhớ là gì?
Khi bạn mở màn hình A, app tốn 10MB RAM. Bạn tắt màn hình A đi, đúng ra 10MB đó phải được hệ thống dọn dẹp (Garbage Collector). 
Nhưng vì lý do gì đó (bạn quên tắt Stream, quên xóa Controller), hệ thống tưởng bạn vẫn đang dùng nó -> RAM không được giải phóng. Bạn mở lại màn hình A 10 lần -> App ngốn 100MB RAM. Đến một mức giới hạn, HĐH sẽ "giết" app của bạn không thương tiếc (Crash).

## 2. Cách mở Flutter DevTools
1. Trong VS Code, khi đang chạy App, bấm `Ctrl + Shift + P` (hoặc `Cmd + Shift + P`).
2. Gõ `Flutter: Open DevTools`.
3. Trình duyệt web sẽ mở ra một bảng điều khiển siêu xịn.

## 3. Sử dụng Tab Memory
- Khi app đang chạy, nhìn vào biểu đồ Memory. Đường màu xanh thể hiện lượng RAM đang bị chiếm.
- Hãy thử mở 1 trang mới, biểu đồ sẽ nhích lên. Bấm back lại trang cũ, sau đó bấm nút **Force GC** (Bắt buộc dọn rác). Nếu đường màu xanh tụt xuống như cũ -> Chúc mừng, app bạn sạch.
- Nếu đường màu xanh cứ tăng dần, tăng dần mãi theo thời gian -> Bạn đã dính Memory Leak.

## 4. Những nguyên nhân kinh điển gây Memory Leak

**A. Quên `dispose` các Controller**
```dart
class _MyState extends State<MyWidget> {
  final TextEditingController _textCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();
  final AnimationController _animCtrl = AnimationController(...);

  @override
  void dispose() {
    // QUAN TRỌNG: LUÔN LUÔN PHẢI GỌI DISPOSE
    _textCtrl.dispose();
    _scrollCtrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }
}
```

**B. Quên hủy lắng nghe Stream (StreamSubscription)**
Nếu bạn lắng nghe vị trí GPS mà chuyển trang không tắt, nó sẽ chạy ngầm cắn sạch RAM và Pin.
```dart
StreamSubscription? _sub;

@override
void initState() {
  super.initState();
  _sub = Geolocator.getPositionStream().listen((pos) {
    print(pos);
  });
}

@override
void dispose() {
  _sub?.cancel(); // Phải cancel stream
  super.dispose();
}
```

**C. Timer chạy vô hạn**
```dart
Timer? _timer;

@override
void initState() {
  // Cứ 1 giây chạy 1 lần
  _timer = Timer.periodic(Duration(seconds: 1), (timer) { ... });
}

@override
void dispose() {
  _timer?.cancel(); // Phải tắt timer
  super.dispose();
}
```
