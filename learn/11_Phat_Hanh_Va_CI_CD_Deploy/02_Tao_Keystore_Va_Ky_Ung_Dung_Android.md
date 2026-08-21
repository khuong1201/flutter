# Bài 2: Tạo Keystore và Ký Ứng Dụng Android

Để đưa app lên Google Play, ứng dụng của bạn PHẢI được "Ký" (Signed) bằng một file chứng chỉ (Keystore). 
File Keystore này giống như con dấu của riêng công ty bạn. Nếu mất file này, bạn sẽ KHÔNG BAO GIỜ có thể cập nhật app lên Google Play được nữa. Hãy cất nó cẩn thận!

## 1. Tạo file Keystore (.jks)
Mở Terminal (trên máy Mac/Linux) hoặc Command Prompt (trên Windows), chạy lệnh sau:

**Mac / Linux:**
```bash
keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

**Windows:**
```bash
keytool -genkey -v -keystore c:\Users\USER_NAME\upload-keystore.jks -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

Nó sẽ yêu cầu bạn nhập:
- **Password**: Gõ 2 lần (Lưu ý gõ nó không hiện ký tự ra màn hình, cứ gõ rồi enter). Phải nhớ mật khẩu này!
- Các thông tin tên, họ, tổ chức (cứ gõ bừa hoặc điền đàng hoàng).
- Bấm `Y` (Yes) để xác nhận.
Kết quả, bạn thu được file `upload-keystore.jks`. Hãy copy file này bỏ vào thư mục `android/app` của dự án Flutter.

## 2. Cấu hình file `key.properties`
Trong thư mục `android/`, tạo một file tên là `key.properties` và điền thông tin sau:

```properties
storePassword=<mật_khẩu_bạn_vừa_tạo>
keyPassword=<mật_khẩu_bạn_vừa_tạo>
keyAlias=upload
storeFile=upload-keystore.jks
```

*Lưu ý: Phải mở file `.gitignore` và thêm dòng `key.properties` và `*.jks` vào để không lỡ tay đẩy mật khẩu lên GitHub.*

## 3. Chỉnh sửa file build.gradle
Mở file `android/app/build.gradle` và thêm phần đọc cấu hình ký tự động:

Tìm khối `android { ... }` và nhúng đoạn này lên TRƯỚC nó:
```groovy
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}
```

Trong khối `android {`, sửa lại phần `buildTypes` và `signingConfigs`:
```groovy
android {
    // ...
    signingConfigs {
        release {
            keyAlias = keystoreProperties['keyAlias']
            keyPassword = keystoreProperties['keyPassword']
            storeFile = keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword = keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release // Gắn cấu hình ký vào bản Release
        }
    }
}
```

## 4. Build bản đóng gói App Bundle
Chạy lệnh:
```bash
flutter build appbundle
```
File đóng gói thành công sẽ nằm tại: `build/app/outputs/bundle/release/app-release.aab`. 
Hãy cầm file này up lên trang Google Play Console!
