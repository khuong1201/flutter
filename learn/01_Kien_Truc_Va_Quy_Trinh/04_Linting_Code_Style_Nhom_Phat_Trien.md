# Bài 4: Linting và Code Style Cho Nhóm Phát Triển

Khi làm việc nhóm, mỗi người có một "gu" viết code khác nhau (người thích dùng `'` nháy đơn, người thích `"` nháy kép, người thích xuống dòng nhiều...). Để code của cả team đồng nhất, chúng ta cần công cụ ép buộc luật lệ: **Linter**.

Flutter/Dart mặc định cung cấp `flutter_lints` (lưu trong file `analysis_options.yaml`). Tuy nhiên, bản mặc định hơi "hiền". Trong dự án thực tế, người ta thường dùng các bộ quy tắc khắt khe hơn.

## 1. Cấu hình file `analysis_options.yaml`
Hãy mở file `analysis_options.yaml` (nằm ngoài cùng thư mục dự án) và thêm các luật nghiêm ngặt sau:

```yaml
include: package:flutter_lints/flutter.yaml

analyzer:
  # Cảnh báo mạnh mẽ về việc dùng biến chưa khai báo kiểu
  strong-mode:
    implicit-casts: false
    implicit-dynamic: false
  errors:
    # Biến lỗi thành error bắt buộc phải sửa thì mới cho chạy app
    missing_required_param: error
    missing_return: error
    must_be_immutable: error

linter:
  rules:
    # --- CÁC LUẬT FORMAT CODE ---
    # Bắt buộc khai báo biến rõ ràng
    always_declare_return_types: true
    
    # Ép dùng nháy đơn cho String ('chữ' thay vì "chữ")
    prefer_single_quotes: true
    
    # Ép dùng từ khóa const ở mọi nơi có thể (Tăng hiệu năng)
    prefer_const_constructors: true
    prefer_const_literals_to_create_immutables: true
    
    # Không dùng print (phải dùng log hoặc thư viện logger để dễ kiểm soát)
    avoid_print: true
    
    # Tránh dùng toán tử ! ép kiểu non-null quá bừa bãi
    avoid_non_null_assertions: true
    
    # Đặt tên hàm và biến chuẩn xác (camelCase, PascalCase...)
    camel_case_types: true
    camel_case_extensions: true
    non_constant_identifier_names: true
```

## 2. Thư viện khuyên dùng: `very_good_analysis`
Thay vì tự viết tay hàng chục quy tắc, bạn có thể cài một package cực xịn từ cộng đồng có tên là `very_good_analysis`. Nó chứa những quy chuẩn code khắt khe và sạch sẽ nhất.

**Cài đặt:**
```bash
flutter pub add dev:very_good_analysis
```
Sau đó sửa `analysis_options.yaml` thành:
```yaml
include: package:very_good_analysis/analysis_options.yaml

# Bạn có thể ghi đè (tắt/bật) một số luật nếu thấy quá khắt khe:
linter:
  rules:
    public_member_api_docs: false # Không bắt buộc viết comment cho mọi hàm public
```

## 3. Format code tự động khi lưu (VS Code)
Để không phải tự tay chỉnh sửa, hãy cấu hình VS Code tự động format và thêm từ khóa `const` mỗi khi bạn bấm `Ctrl + S`.
Trong VS Code, mở `settings.json` và thêm:
```json
"[dart]": {
    "editor.formatOnSave": true,
    "editor.formatOnType": true,
    "editor.rulers": [80],
    "editor.selectionHighlight": false,
    "editor.suggest.snippetsPreventQuickSuggestions": false,
    "editor.suggestSelection": "first",
    "editor.tabCompletion": "onlySnippets",
    "editor.wordBasedSuggestions": "off",
    "editor.codeActionsOnSave": {
        "source.fixAll": "explicit",
        "source.organizeImports": "explicit"
    }
}
```
Nhờ cấu hình `source.fixAll`, VS Code sẽ tự động nhét chữ `const` vào mọi chỗ linter yêu cầu mỗi khi bạn lưu file. Cực kỳ tiện lợi!
