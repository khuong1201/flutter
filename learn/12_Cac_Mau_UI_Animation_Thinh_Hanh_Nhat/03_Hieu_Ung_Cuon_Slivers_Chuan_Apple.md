# Bài 3: Hiệu Ứng Cuộn "Chuẩn Apple" Với Slivers

Nếu bạn để ý các app iOS mặc định (như Cài đặt, Danh bạ, App Store), bạn sẽ thấy khi bạn vuốt xuống, thanh Tiêu đề (AppBar) không bị trôi tuột đi mất, mà nó **từ từ thu nhỏ lại**, mờ dần, và dính (pin) lại ở trên đỉnh. Hoặc tấm ảnh bìa ở trên cùng sẽ bị **kéo dãn ra (stretch)** khi bạn cố tình vuốt ngược lên trên (overscroll).

Trong Flutter, bạn KHÔNG THỂ làm được điều này bằng `ListView` hay `SingleChildScrollView`. Vũ khí bí mật mang tên: **Slivers**.

## 1. CustomScrollView - Trái Tim Của Slivers
`CustomScrollView` là một cái khung cuộn đặc biệt. Bên trong nó, bạn không được dùng Widget thường (như `Container`, `Text`), mà phải dùng các Widget có chữ `Sliver` ở trước.

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      // 1. Thanh tiêu đề xịn xò có thể thu phóng
      SliverAppBar(
        expandedHeight: 250.0, // Độ cao tối đa khi kéo giãn
        pinned: true, // Cuộn xuống sẽ ghim lại thành AppBar nhỏ xíu ở trên đỉnh
        stretch: true, // Hiệu ứng kéo cao su (Bounce) khi cuộn ngược đỉnh

        flexibleSpace: FlexibleSpaceBar(
          title: Text('Chi tiết sản phẩm'), // Tiêu đề từ từ mờ đi và bay lên
          stretchModes: const [
            StretchMode.zoomBackground, // Kéo xuống ảnh bìa bị dãn to ra
          ],
          background: Image.network(
            'https://ảnh_sản_phẩm_chất_lượng_cao',
            fit: BoxFit.cover,
          ),
        ),
      ),

      // 2. Nội dung bên dưới (Văn bản, v.v...)
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Mô tả sản phẩm rất dài...'),
        ),
      ),

      // 3. Danh sách cuộn mượt mà
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) => ListTile(title: Text('Bình luận $index')),
          childCount: 50,
        ),
      ),
    ],
  ),
)
```

## 2. SliverPersistentHeader - Dính Widget Lại Khi Cuộn (Sticky Header)
Rất nhiều App như Zalo, Shopee có thanh Filter (Lọc: Mới nhất, Bán chạy). Khi cuộn qua thì thanh Filter dính cứng ngắc lên mép trên cùng, còn danh sách cứ chui luồn xuống dưới thanh đó.

Đây là hiệu ứng rất ăn tiền trên Dribbble.

```dart
// Bỏ cục này vào trong mảng `slivers: []`
SliverPersistentHeader(
  pinned: true, // Dính chặt lên mép
  delegate: MySliverHeaderDelegate(
    minHeight: 50.0,
    maxHeight: 50.0,
    child: Container(
      color: Colors.white,
      child: Text('Bộ lọc: Giá từ thấp đến cao'),
    ),
  ),
)
```
*(Lưu ý: Bạn phải tự tạo một class `MySliverHeaderDelegate extends SliverPersistentHeaderDelegate` để định nghĩa độ cao của nó).*

## 3. Tóm Lại Về Slivers
- Bất cứ khi nào Designer yêu cầu: *"Em làm cho anh cuộn cái này lên thì cái kia mờ đi, cái kia dính lại, cái nọ chạy chậm hơn"* -> Hãy nhớ ngay tới `CustomScrollView` và anh em nhà `Sliver`.
- Trông code có vẻ loằng ngoằng, nhưng hiệu ứng cuộn nó tạo ra mượt 60fps và sướng tay vô cùng!
