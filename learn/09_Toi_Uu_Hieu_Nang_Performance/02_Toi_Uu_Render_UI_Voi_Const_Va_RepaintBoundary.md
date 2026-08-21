# Bài 2: Tối Ưu Render UI: Const và RepaintBoundary

Mục tiêu tối thượng của một app Flutter là đạt **60 FPS** (Khung hình/giây), hoặc 120 FPS trên các thiết bị cao cấp. Để làm được, hàm `build()` phải chạy cực nhanh và chỉ vẽ lại những thứ THỰC SỰ cần vẽ.

## 1. Sức mạnh của từ khóa `const`
Trong Flutter, nếu bạn dùng `const` trước một Widget, bạn đang nói với trình biên dịch: *"Cái này không bao giờ thay đổi hình dạng chữ nghĩa đâu, hãy vẽ nó đúng 1 lần lúc khởi động rồi lưu vào bộ nhớ cache, đừng bao giờ bắt tôi vẽ lại nó nữa"*.

**Không có const:**
```dart
// Mỗi lần hàm build() gọi lại (do setState), máy tính phải tính toán và tạo ra một object Text mới tinh. Rất tốn CPU.
Widget build(BuildContext context) {
  return Text('Xin chào'); 
}
```

**Có const:**
```dart
// Text này được lưu cứng trên thanh RAM, hàm build chạy 1000 lần thì nó vẫn chỉ móc từ RAM ra. Cực mượt!
Widget build(BuildContext context) {
  return const Text('Xin chào'); 
}
```
*-> Quy tắc: Đặt linter (Bài 4 Chương 1) để ép team luôn dùng `const` mọi lúc có thể.*

## 2. Tránh "Cháy Rừng" (Rebuild nguyên cây Widget)
Khi gọi `setState`, toàn bộ những thứ bên trong hàm `build()` hiện tại sẽ bị quét qua 1 lần.
Nếu màn hình của bạn dài 1000 dòng code, chỉ vì bạn bấm 1 nút Like mà nó quét lại toàn bộ 1000 dòng thì quá phí phạm.

**Giải pháp:** Tách nhỏ Widget ra.
Cái nút Like nên được ném ra thành một Widget riêng (ví dụ `LikeButton`). Khi bấm, chỉ hàm `build()` của `LikeButton` chạy lại, màn hình to vẫn đứng im. (Tham khảo lại Bài 1 - Chương 2).

## 3. RepaintBoundary - Tường lửa chặn vẽ lại
Có những Animation chạy liên tục (Ví dụ hình cái đồng hồ đếm ngược, hoặc file Lottie). Flutter có cơ chế vẽ theo từng Lớp (Layer). Nếu cái đồng hồ thay đổi, nó sẽ rủ theo các widget khác nằm trên cùng 1 lớp bị vẽ lại theo.

Để "cách ly" những thành phần thay đổi liên tục, ta bọc nó trong `RepaintBoundary`.

```dart
Widget build(BuildContext context) {
  return Stack(
    children: [
      const NgayXuaNgayXuaWidget(), // Hình nền cực kỳ phức tạp (Nhiều cây cỏ)
      
      // Đồng hồ nhấp nháy 60 lần/giây
      RepaintBoundary( 
        child: DongHoDemNguocWidget(),
      ),
    ],
  );
}
```
Nhờ `RepaintBoundary`, Flutter tạo ra một bức tường. Cái đồng hồ có nhấp nháy cỡ nào thì cái Hình nền cũng không bị ép vẽ lại. CPU được giảm tải đáng kể.

## 4. [Kiến thức mới] Engine đồ họa Impeller (Flutter 3.10+)
Kể từ Flutter 3.10 (trên iOS) và Flutter 3.16+ (trên Android), Google đã chính thức thay thế engine vẽ **Skia** cũ kỹ bằng **Impeller**.

Impeller biên dịch trước các shader đồ họa (Precompiled Shaders) thay vì biên dịch lúc đang chạy app. Nhờ vậy, hiện tượng "giật lag lần đầu tiên chạy animation" (Jank) đã bị triệt tiêu hoàn toàn. Bạn không cần phải quá lo lắng về việc tối ưu Shader như ngày xưa nữa, cứ tự tin mà quẩy Animation!
