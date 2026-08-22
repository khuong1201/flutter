# Bài 2: Dashboard Tài Chính với Lưới Bento và Glassmorphism

Nếu bạn lên Behance và tìm "Finance App UI" (Giao diện App Ngân hàng/Tiền ảo), 90% kết quả trả về trong top đều mang phong cách: Nền tối (Dark Mode) + Thẻ ngân hàng trong suốt như kính mờ (Glassmorphism) + Bố cục Lưới xếp gạch (Bento Grid).

## 1. Phân Tích Cấu Trúc Màn Hình Dashboard "Triệu Đô"

- **Header**: Chữ "Chào buổi sáng, Tuấn" cực to. Góc phải là Avatar có viền Gradient nhấp nháy nhẹ.
- **Thẻ Chính (Credit Card)**: Đặt ở giữa màn hình, chiếm 1/3 diện tích. Không đổ màu bệt mà dùng Glassmorphism trong suốt đè lên một cục Mesh Gradient loang lổ phía sau.
- **Lưới Bento (Thống kê)**: 4 ô vuông bên dưới, 2 ô nhỏ (chiếm 50% ngang) và 1 ô to (chiếm 100% ngang). Các ô này dùng màu xám đen (`#1E1E1E`) trên nền đen tuyền (`#000000`).

## 2. Cách Code Hiệu Ứng Thẻ Kính Mờ (Glass Card)

Bạn KHÔNG NÊN dùng ảnh tĩnh Photoshop xuất ra. Phải code bằng Flutter để thẻ có thể co giãn và đổi số tiền linh hoạt.

```dart
// Bọc thẻ bằng ClipRRect để không bị tràn viền kính
ClipRRect(
  borderRadius: BorderRadius.circular(24),
  child: BackdropFilter(
    // Hiệu ứng làm mờ cảnh vật phía sau (như nhìn qua kính phòng tắm)
    filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
    child: Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        // Màu trắng bán trong suốt
        color: Colors.white.withOpacity(0.1),
        
        // Viền thẻ có độ sáng nhẹ (Mô phỏng ánh sáng chiếu vào cạnh kính)
        border: Border.all(
          color: Colors.white.withOpacity(0.2), 
          width: 1.5
        ),
        borderRadius: BorderRadius.circular(24),
        
        // Đổ bóng gradient bên trong góc thẻ
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.15),
            Colors.white.withOpacity(0.05),
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tổng số dư', style: TextStyle(color: Colors.white70)),
            Text('\$24,500.00', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white)),
            // ... Logo Visa/Mastercard
          ],
        ),
      ),
    ),
  ),
)
```

## 3. Tạo Lưới Bento Bằng Thư Viện
Thay vì dùng `Row`, `Column` lồng nhau lộn xộn, giới UI rất ưa chuộng thư viện `flutter_staggered_grid_view`. Nó cho phép xếp gạch các thẻ to nhỏ một cách hoàn hảo, không bị khoảng trống hở hang.

```dart
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

StaggeredGrid.count(
  crossAxisCount: 4, // Chia màn hình thành 4 cột
  mainAxisSpacing: 16,
  crossAxisSpacing: 16,
  children: [
    // Thẻ nhỏ: Chiếm 2 cột dọc, 2 cột ngang
    StaggeredGridTile.count(
      crossAxisCellCount: 2,
      mainAxisCellCount: 2,
      child: MyBentoCard('Gửi tiền'),
    ),
    // Thẻ dài: Chiếm 4 cột ngang (Full viền), 2 cột dọc
    StaggeredGridTile.count(
      crossAxisCellCount: 4,
      mainAxisCellCount: 2,
      child: MyChartCard('Biểu đồ tiêu dùng'),
    ),
  ],
)
```
Giao diện này nhìn trên iPhone Pro Max hoặc màn hình gập của Samsung Galaxy Z Fold sẽ tự động bung ra cực kỳ đẳng cấp!
