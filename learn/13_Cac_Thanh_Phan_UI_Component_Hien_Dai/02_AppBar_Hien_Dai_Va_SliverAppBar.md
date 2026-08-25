# Bài 2: AppBar Hiện Đại và Thanh Tìm Kiếm

`AppBar` mặc định của Material 2 (chữ nằm lệch trái, đổ bóng màu xanh dương đậm) đã cực kỳ lỗi thời. Material 3 mang đến `AppBar` phẳng hơn, nhưng dân UI trên Dribbble còn thích các kiểu "Trong suốt", "Mờ ảo" hoặc nhúng thẳng thanh Search bự chà bá vào Header.

## 1. Transparent & Blur AppBar (Kính mờ)
App iOS thường có thanh AppBar phía trên làm bằng kính mờ. Khi bạn cuộn danh sách, chữ sẽ luồn bên dưới thanh AppBar này tạo hiệu ứng rất đẹp.

**Cách làm:**
```dart
Scaffold(
  // 1. Cho Body chạy tuột lên đỉnh màn hình, lót dưới AppBar
  extendBodyBehindAppBar: true, 
  
  appBar: AppBar(
    // 2. Chỉnh nền AppBar thành trong suốt hoàn toàn
    backgroundColor: Colors.transparent, 
    elevation: 0, 
    
    // 3. Dùng flexibleSpace để nhét kính mờ (BackdropFilter) vào
    flexibleSpace: ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: Colors.white.withOpacity(0.5), // Kính trắng đục nhẹ
        ),
      ),
    ),
    title: const Text('Kính Mờ AppBar', style: TextStyle(color: Colors.black)),
  ),
  
  body: ListView.builder(
    itemCount: 50,
    itemBuilder: (c, i) => ListTile(title: Text("Bình luận $i")),
  ),
)
```

## 2. AppBar Gắn Liền Thanh Tìm Kiếm (SearchBar)
Thay vì một thanh AppBar truyền thống chỉ có chữ, nhiều app (Tiki, Shopee) dùng hẳn nguyên vùng Header trên cùng để đặt một thanh Tìm Kiếm to và dài, kèm theo nút Giỏ hàng kế bên.

**Cách làm:**
Sử dụng `PreferredSize` để tạo AppBar tuỳ biến.

```dart
Scaffold(
  appBar: PreferredSize(
    preferredSize: Size.fromHeight(80.0), // Chiều cao tuỳ chỉnh
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            // Thanh Search chiếm phần lớn
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200], // Nền xám nhạt
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    prefixIcon: Icon(Icons.search, color: Colors.grey),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
            ),
            SizedBox(width: 16),
            // Nút Giỏ hàng / Thông báo
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey[200],
              ),
              child: IconButton(
                icon: Icon(Icons.notifications_none),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    ),
  ),
  body: Center(child: Text("Nội dung")),
)
```

## 3. Large Title (Tiêu đề bự kiểu Apple)
Nếu bạn để ý App Cài đặt của iPhone, chữ "Settings" nằm rất to bên dưới. Khi vuốt lên, nó chạy lên trên và thu nhỏ lại ở giữa AppBar.

Trong Flutter, bạn có thể dễ dàng làm được bằng cách sử dụng `SliverAppBar(largeTitle: true)` (Cách này yêu cầu dùng `CustomScrollView` như Bài 3 Chương 12) hoặc tận dụng gói mặc định của Material 3 (Nhưng M3 nhìn hơi lai tạp Android). 

Gợi ý: Nếu làm App nhắm tới iOS nhiều, hãy dùng thư viện `cupertino_icons` và học widget `CupertinoSliverNavigationBar` - nó cung cấp hiệu ứng chữ bự y hệt Apple gốc 100% không tốn 1 giọt mồ hôi!
