# Bài 4: Thiết Lập CI/CD Để Tự Động Hóa Build App

Khi dự án có nhiều Dev cùng code chung, việc 1 người build app rồi gửi file APK/IPA thủ công cho Tester là cực kỳ thiếu chuyên nghiệp, tốn thời gian và dễ nhầm lẫn phiên bản.

**CI/CD (Continuous Integration / Continuous Deployment)** là quy trình: Khi bạn gõ `git push` code lên nhánh `main`, một con máy chủ (Server) trên mây sẽ TỰ ĐỘNG lấy code về, tự động chạy Unit Test, tự động Build ra file APK/IPA, tự động gửi thư báo cho Tester, và tự động đẩy thẳng lên App Store/Google Play. Bạn không phải làm bất kỳ thao tác tay nào!

## 1. Fastlane (Dành cho Server nội bộ)
Fastlane là bộ công cụ mã nguồn mở viết bằng ngôn ngữ Ruby. Nếu công ty bạn có sẵn một cái máy Mac chạy làm server, bạn cài Fastlane lên đó.

**Cài đặt:** `brew install fastlane` (trên Mac).
Bạn cấu hình một file gọi là `Fastfile`. Ví dụ kịch bản (lane) build Android lên Google Play:

```ruby
default_platform(:android)

platform :android do
  desc "Tự động build và upload lên Google Play"
  lane :deploy_playstore do
    # 1. Chạy lệnh build của Flutter
    sh("flutter build appbundle --release")
    
    # 2. Dùng action 'supply' của Fastlane để đẩy thẳng lên kho
    supply(
      track: "internal", # Đẩy lên nhánh thử nghiệm nội bộ
      aab: "../build/app/outputs/bundle/release/app-release.aab"
    )
    
    # 3. Gửi thông báo vô kênh chat Slack báo team vào test
    slack(message: "Bản build mới đã có mặt trên Google Play!")
  end
end
```
Sau khi cài đặt xong, coder chỉ cần gõ đúng 1 dòng `fastlane deploy_playstore` là đi pha cà phê uống, máy tính sẽ tự làm nốt phần còn lại.

## 2. Codemagic (Giải pháp Đám mây tiện lợi nhất cho Flutter)
Thay vì tự mua máy Mac, bạn xài Cloud. Có nhiều dịch vụ như GitHub Actions, Bitrise, CircleCI. Nhưng **Codemagic** là dịch vụ sinh ra MẶC ĐỊNH là để phục vụ riêng cho Flutter, giao diện cực kì dễ xài.

**Cách làm:**
1. Tạo tài khoản trên web `codemagic.io`.
2. Kết nối nó với kho GitHub / GitLab chứa mã nguồn của bạn.
3. Nó tự nhận diện đây là dự án Flutter.
4. Mở file `codemagic.yaml` cấu hình (Hoặc chỉ đơn giản click các nút trên giao diện web của nó).
Bạn điền file `Keystore` (Android) và `Certificate` (iOS) vào phần cấu hình bảo mật của nó. 
5. Cài đặt Trigger: Đặt quy tắc *"Bất cứ khi nào có người tạo Pull Request hợp nhất vào nhánh `master`, máy chủ hãy kích hoạt luồng build"*.

Codemagic cho phép team dùng miễn phí 500 phút build mỗi tháng. Quá đủ cho startup!
