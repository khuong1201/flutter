# Bài 5: Bottom Sheet và Modal Đa Điểm Tuỳ Chỉnh

Bottom Sheet (Tấm thẻ kéo từ dưới đáy lên) đã trở thành giải pháp UI ưu việt nhất hiện nay để thay thế cho Alert Dialog (Cửa sổ bật lên giữa màn hình). 

Lý do: Cầm điện thoại bằng 1 tay vuốt ngón cái từ đáy màn hình lên sẽ DỄ DÀNG HƠN RẤT NHIỀU so với việc với ngón tay lên giữa màn hình bấm Dialog.

## 1. DraggableScrollableSheet - Kéo nửa vời
Một Bottom Sheet hiện đại (Như Apple Maps, Google Maps) không bao giờ chỉ có 2 trạng thái Bật/Tắt. Khi bạn kéo lên 1 chút, nó nằm yên ở mức 30% màn hình. Bạn lấy tay vuốt lên mạnh cái nữa, nó bung ra chiếm 90% màn hình.

Đó chính là sức mạnh của `DraggableScrollableSheet`.

```dart
// Gọi hàm mở Bottom Sheet
showModalBottomSheet(
  context: context,
  isScrollControlled: true, // BẮT BUỘC có dòng này thì Sheet mới có thể mở bự 90%
  backgroundColor: Colors.transparent, // Nền trong suốt để tự vẽ góc bo tròn
  builder: (context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3, // Lúc mới mở lên chiếm 30% màn hình
      minChildSize: 0.1,     // Vuốt xuống dưới 10% thì nó tự đóng
      maxChildSize: 0.9,     // Vuốt kịch kim lên được 90% màn hình
      builder: (BuildContext context, ScrollController scrollController) {
        // Bên trong là một Container chứa ListView
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Thanh nắm vuốt xám xám ở trên cùng (Handle Bar)
              Center(
                child: Container(
                  margin: EdgeInsets.only(top: 8, bottom: 8),
                  height: 5,
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              Expanded(
                // PHẢI dùng scrollController này nhét vào ListView thì mới vuốt đồng bộ được
                child: ListView.builder(
                  controller: scrollController, 
                  itemCount: 25,
                  itemBuilder: (context, index) => ListTile(title: Text('Mục $index')),
                ),
              ),
            ],
          ),
        );
      },
    );
  },
);
```

## 2. Glassmorphism Bottom Sheet
Khái niệm Kính Mờ (Glassmorphism - đã nói ở Bài 5 Chương 6) cũng áp dụng cực xịn vào Bottom Sheet. 

Nếu bạn cho màu nền của thẻ Bottom Sheet là `Colors.white.withOpacity(0.3)` và bọc bên ngoài `BackdropFilter(ImageFilter.blur(sigmaX: 20, sigmaY: 20))`, khi kéo tấm thẻ lên, các nội dung ở màn hình chính bên dưới sẽ bị mờ nhoè đi đằng sau tấm kính của Bottom Sheet. Hiệu ứng này nhìn trên màn hình OLED siêu tuyệt vời!

**Tóm tắt chung:**
Thay vì dùng Navigator Push nhảy qua 1 trang hoàn toàn mới, xu hướng hiện tại là "Gom mọi thao tác phụ vào Bottom Sheet". Sửa hồ sơ? Mở Bottom Sheet. Chọn bộ lọc? Mở Bottom Sheet. Chuyển tiền? Vuốt Bottom Sheet.
Nó giúp người dùng không cảm thấy bị "lạc lối" vì họ vẫn thấy màn hình trang chủ lờ mờ bên dưới tấm thẻ!
