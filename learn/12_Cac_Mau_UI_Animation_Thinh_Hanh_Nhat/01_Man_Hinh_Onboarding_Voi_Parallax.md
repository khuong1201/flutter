# Bài 1: Màn Hình Onboarding Với Parallax và Hoạt Hình

Trên các diễn đàn Dribbble và Behance, màn hình Onboarding (Chào mừng khi lần đầu mở App) không bao giờ chỉ là mấy tấm ảnh tĩnh nhàm chán lướt qua lướt lại nữa. 
Xu hướng hiện nay là **Parallax Scrolling (Cuộn thị sai)** kết hợp với vật thể chuyển động 3D/2D lơ lửng.

## 1. Parallax Scrolling là gì?
Khi bạn vuốt màn hình sang ngang, thay vì cả cụm chữ và ảnh chạy đi cùng một tốc độ, thì **ảnh nền sẽ trôi chậm hơn chữ ở phía trước**. Nó tạo ra một ảo giác về chiều sâu 3D (cảm giác không gian lớp trước, lớp sau).

## 2. Cách xây dựng trong Flutter (Thư viện `smooth_page_indicator` + `PageView`)

**Kiến trúc Widget cơ bản:**
```dart
Stack(
  children: [
    // LỚP NỀN DƯỚI CÙNG: Dùng AnimatedBuilder lắng nghe PageController
    // Để dịch chuyển background từ từ (tốc độ bằng 1/3 tốc độ vuốt)
    Positioned(
       // Tính toán độ lệch (offset) dựa trên giá trị của pageController.page
       left: - (pageOffset * 0.3), 
       child: Image.asset('background_mesh_gradient.png'),
    ),

    // LỚP CHÍNH: PageView cho phép vuốt 3 trang
    PageView.builder(
      controller: pageController,
      itemCount: 3,
      itemBuilder: (context, index) {
        return Column(
          children: [
             // Chèn ảnh Lottie lơ lửng ở giữa
             Lottie.asset('assets/astronaut_floating.json'),
             
             // Dòng chữ (Tốc độ trôi bình thường)
             Text('Khám phá vũ trụ'),
          ],
        );
      },
    ),

    // LỚP TRÊN CÙNG: Chấm tròn chỉ báo trang (Indicator)
    Align(
       alignment: Alignment.bottomCenter,
       child: SmoothPageIndicator(
          controller: pageController,
          count:  3,
          effect: ExpandingDotsEffect( // Hiệu ứng chấm tròn kéo dài ra (Cực kỳ thịnh hành)
            activeDotColor: Colors.white,
            dotColor: Colors.white.withOpacity(0.5),
          ),
       ),
    )
  ]
)
```

## 3. Bí kíp từ Dribbble
1. **Tuyệt đối không dùng chữ đen trên nền trắng cho Onboarding**. Dùng nền Mesh Gradient loang lổ nhiều màu tối, kết hợp chữ Trắng bự (Font chữ Inter hoặc Montserrat).
2. Tấm ảnh minh họa phải dùng ảnh nền trong suốt (PNG) hoặc hoạt hình JSON (Lottie).
3. Thêm một nút `FloatingActionButton` dưới góc phải màn hình, nút này không trôi đi mà chỉ **xoay nhẹ một góc** hoặc đổi icon từ "Mũi tên" sang chữ "Bắt đầu" khi vuốt tới trang cuối cùng.
