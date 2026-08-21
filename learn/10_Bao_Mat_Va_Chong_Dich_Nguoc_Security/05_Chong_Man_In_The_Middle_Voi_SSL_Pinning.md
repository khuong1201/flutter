# Bài 5: Chống Man-In-The-Middle với SSL Pinning

Giả sử App của bạn gọi API đến `https://api.mybank.com`. Tin tặc (hoặc chính người dùng dùng máy đã root) có thể dùng một phần mềm bắt gói tin (như Charles Proxy, Wireshark, Proxyman). Họ cấu hình điện thoại đi qua mạng Proxy của họ, cài chứng chỉ SSL giả. Lúc này, mọi dữ liệu gửi đi (kể cả Token, Mật khẩu thẻ tín dụng qua HTTPS) đều bị họ phơi bày rõ mồn một. Lỗi bảo mật này gọi là **Man-In-The-Middle (MITM) - Tấn công kẻ đứng giữa**.

## 1. SSL Pinning (Ghim chứng chỉ) là gì?
Mặc định, HĐH điện thoại tin tưởng HÀNG TRĂM chứng chỉ gốc (Root CA) được cấp bởi VeriSign, Let's Encrypt... Tin tặc có thể cài thêm một chứng chỉ giả của Charles Proxy vào máy và điện thoại vẫn báo "Tin tưởng".

SSL Pinning là kỹ thuật ta ép mã nguồn App: **"Mày chỉ được phép tin tưởng duy nhất 1 chứng chỉ HTTPS đích danh của tao thôi (Ví dụ mã băm vân tay SHA-256 của api.mybank.com). Còn lại tao từ chối tất cả".**

Do đó, dù tin tặc có cài chứng chỉ giả vào máy, App vẫn phát hiện ra đó là chứng chỉ giả (vì mã băm khác nhau) và Lập tức ngắt kết nối mạng.

## 2. Thực hành với thư viện Dio (Nhanh nhất)
Flutter + Dio cung cấp cách ghim SSL cực kỳ đơn giản.

**Bước 1: Lấy dấu vân tay SHA-256 của Server bạn**
Mở terminal trên máy tính gõ:
```bash
openssl s_client -servername api.mybank.com -connect api.mybank.com:443 < /dev/null 2>/dev/null \
  | openssl x509 -pubkey -noout | openssl pkey -pubin -outform der | openssl dgst -sha256 -binary | openssl enc -base64
```
Nó sẽ in ra một chuỗi băm (Hash), ví dụ: `k2v657xBsOVe1PQRwOsHsw3bsGT2VzIqz5K+59sNQvQ=`

**Bước 2: Cấu hình Dio**
Mở file cấu hình Dio (Bạn đã học ở Chương 3 - Bài 2).

```dart
import 'package:dio/dio.dart';
import 'package:http_certificate_pinning/http_certificate_pinning.dart';

class ApiClient {
  late Dio dio;

  ApiClient() {
    dio = Dio(BaseOptions(baseUrl: 'https://api.mybank.com'));

    // Gắn SSL Pinning Interceptor
    dio.interceptors.add(
      CertificatePinningInterceptor(
        allowedSHAFingerprints: [
          // Điền chuỗi băm lấy được ở bước 1 vào đây
          'k2v657xBsOVe1PQRwOsHsw3bsGT2VzIqz5K+59sNQvQ=' 
        ], 
      )
    );
  }
}
```
*Lưu ý: Bạn phải tải thêm plugin `http_certificate_pinning` để có đoạn code trên.*

## 3. Cảnh báo "Chết chóc" khi dùng SSL Pinning
Chứng chỉ SSL thường có thời hạn 1 năm.
Nếu máy chủ bạn hết hạn SSL, bạn đi gia hạn cái mới -> Chuỗi mã băm bị đổi sang một mã khác.
Lúc này, MỌI ỨNG DỤNG trên máy khách hàng đang cài sẽ TỪ CHỐI KẾT NỐI MẠNG (vì mã băm trong app là mã cũ, mã trên server là mã mới). App bạn biến thành cục gạch, gọi API báo lỗi hàng loạt! Người dùng phải tải App mới từ Store thì mới chạy lại được.

**Kinh nghiệm:**
Chỉ ghim SSL khi thật sự cần thiết (Dự án có tiền). Luôn có thông báo ép người dùng "Cập nhật App" trước khi chứng chỉ server hết hạn 1 tháng.
