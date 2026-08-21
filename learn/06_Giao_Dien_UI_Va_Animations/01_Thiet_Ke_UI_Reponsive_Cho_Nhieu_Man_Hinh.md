# Bài 1: Thiết Kế UI Responsive Cho Nhiều Màn Hình

Flutter có thể build app cho Mobile, Tablet, Web và Desktop. Một màn hình thiết kế cứng (Hardcode) kích thước như `width: 400` sẽ vỡ nát khi chạy trên iPad. Do đó, ta phải áp dụng các kỹ thuật Responsive (Tự động co giãn giao diện).

## 1. Sử dụng LayoutBuilder (Kẻ chia ranh giới)
`LayoutBuilder` giúp bạn biết được kích thước của cha nó (Widget chứa nó) đang là bao nhiêu, từ đó vẽ ra giao diện phù hợp.

Ví dụ: Nếu màn hình nhỏ hơn 600px -> Vẽ danh sách dọc. Nếu lớn hơn 600px (Tablet/Web) -> Vẽ dạng lưới (Grid).

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        // Đọc chiều rộng hiện tại
        if (constraints.maxWidth < 600) {
          return _buildMobileLayout(); // Gọi hàm vẽ giao diện điện thoại
        } else {
          return _buildTabletLayout(); // Gọi hàm vẽ giao diện Ipad
        }
      },
    ),
  );
}
```

## 2. MediaQuery: Lấy thông tin Thiết bị
`MediaQuery` cung cấp toàn bộ thông số về điện thoại (Độ phân giải, có Tai thỏ (Notch) hay không, font size người dùng đang để to hay nhỏ).

```dart
Widget build(BuildContext context) {
  // Lấy kích thước màn hình
  double width = MediaQuery.of(context).size.width;
  double height = MediaQuery.of(context).size.height;
  
  // Kiểm tra màn hình dọc hay ngang
  Orientation orientation = MediaQuery.of(context).orientation;

  return Container(
    // Chiếm 50% chiều rộng màn hình
    width: width * 0.5, 
    height: 100,
  );
}
```

## 3. Các Widget hỗ trợ Responsive "Ăn liền"

- **`Expanded` / `Flexible`**: Chia tỷ lệ khoảng trống trong `Row` hoặc `Column`.
- **`Wrap`**: Tương tự `Row` nhưng nếu các phần tử con vượt quá chiều rộng màn hình, nó sẽ tự động rơi xuống dòng dưới (Rất hợp làm danh sách các Tag/Category).
- **`FittedBox`**: Ép Widget con phải thu nhỏ chữ/ảnh lại để nhét vừa vào một cái hộp cố định (Tránh lỗi vỡ layout chữ báo sọc đen vàng `RenderFlex overflowed`).

## 4. SafeArea: Cứu tinh của Tai thỏ (Notch)
Các dòng điện thoại đời mới (iPhone 14, Android đục lỗ) thường che mất nội dung ở cạnh trên hoặc có thanh gạt ở dưới cùng màn hình.
Để chữ không bị chui vào phần tai thỏ này, luôn bọc toàn bộ Body bằng `SafeArea`.

```dart
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
      // Các thẻ Text bên trong sẽ không bao giờ bị tai thỏ đè lên
      child: Text('Hello Flutter'), 
    ),
  );
}
```

## 5. Sử dụng thư viện `flutter_screenutil` (Dành cho Dev lười)
Đây là cách phổ biến nhất ở các dự án Việt Nam. Designer đưa bản vẽ Figma (Kích thước 375x812). Bạn chỉ cần cài thư viện `flutter_screenutil` và điền thông số y hệt Figma, thư viện sẽ tự động tính toán để scale (thu phóng) ra mọi loại màn hình.

```dart
// Thay vì gõ cứng:
Container(width: 100, height: 100)

// Bạn dùng:
Container(width: 100.w, height: 100.h) 
// .w tự động tính toán tỷ lệ trên các màn hình khác nhau
```

## 6. [Kiến thức mới] Material 3 đã là mặc định (Flutter 3.16+)
Kể từ Flutter 3.16, Google đã ép buộc toàn bộ ứng dụng chuyển sang giao diện **Material Design 3**. 
Điều này có nghĩa là màu sắc mặc định sẽ ám tông tím/xanh nhạt (Dynamic Color), nút bấm bo cong tròn hơn, thanh AppBar không còn đổ bóng (elevation = 0) và đổi màu theo hình nền lúc cuộn.
Nếu bạn thấy giao diện tự nhiên "khác lạ" so với bản thiết kế cũ, đó là do Material 3. Bạn có thể tận dụng nó thay vì tắt đi (`useMaterial3: true`).
