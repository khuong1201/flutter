# Language Learning Dataset Import Plan

## 1. Mục tiêu

Xây dựng pipeline để thu thập, chuẩn hóa và import dữ liệu tiếng Trung và tiếng Nhật vào database của ứng dụng.

Mục tiêu cuối:

```text
Dataset
   ↓
Normalize
   ↓
Validate
   ↓
Transform
   ↓
Database
   ↓
Level → Lesson → Vocabulary → Character → StrokeData
```

---

# 2. Nguồn dữ liệu

## 2.1 Chinese — HSK

### HSK chính thức

Nguồn tham khảo chính:

* Chinese Testing International / Chinese Test
* HSK syllabus và các tài liệu chính thức liên quan

HSK được sử dụng để xác định:

```text
HSK 1
HSK 2
HSK 3
HSK 4
HSK 5
HSK 6
...
```

**Lưu ý:** Không nên coi các website tổng hợp vocabulary là "nguồn chính thức" của HSK. Khi cần xác nhận level, ưu tiên syllabus/tài liệu chính thức.

---

## 2.2 Japanese — JLPT

Nguồn chính thức:

* Japan Foundation / JLPT
* Official JLPT website

JLPT có các level:

```text
N5
N4
N3
N2
N1
```

JLPT chính thức mô tả năng lực cần đạt ở từng level.

**Quan trọng:**

JLPT không công bố một vocabulary/kanji list chính thức hoàn chỉnh cho từng level.

Vì vậy:

```text
JLPT official
    ↓
Xác định level / tiêu chuẩn

Community datasets
    ↓
Vocabulary / Kanji candidate data
```

Dataset cộng đồng phải được ghi rõ nguồn và version.

---

# 3. Japanese Dictionary Data

## KANJIDIC2

Nguồn:

EDRDG — Electronic Dictionary Research and Development Group.

KANJIDIC2 cung cấp thông tin về Kanji, bao gồm:

```text
Kanji
Unicode
Readings
Meanings
Radical information
JLPT-related information
Frequency / dictionary information
```

KANJIDIC2 bao phủ một lượng lớn Kanji Nhật và được phân phối dưới giấy phép CC BY-SA 4.0.

Dùng cho:

```text
Character
    ├── meaning
    ├── reading
    ├── radical
    └── metadata
```

Không dùng KANJIDIC2 làm nguồn stroke animation chính.

---

# 4. Japanese Vocabulary

## JMdict

Nguồn:

EDRDG — Electronic Dictionary Research and Development Group.

JMdict là cơ sở dữ liệu từ vựng đa ngôn ngữ với tiếng Nhật làm ngôn ngữ trung tâm.

Dữ liệu có:

```text
Vocabulary
Kanji form
Kana reading
Meaning
Part of speech
Cross reference
Miscellaneous information
```

Dùng cho:

```text
Vocabulary
    ├── word
    ├── reading
    ├── meaning
    └── related characters
```

---

# 5. Japanese Stroke Data

## KanjiVG

Nguồn:

KanjiVG — Kanji Vector Graphics.

KanjiVG cung cấp dữ liệu vector cho Kanji và stroke information.

Dữ liệu SVG có thể dùng để lấy:

```text
Character
    ↓
Stroke
    ├── order
    ├── SVG outline
    ├── radical information
    └── component information
```

Ứng dụng Flutter:

```text
SVG stroke
    ↓
parseSvgPathData()
    ↓
Path
    ↓
PathMetric
    ↓
CustomPainter
    ↓
Stroke Animation
```

KanjiVG được phát hành dưới CC BY-SA 3.0.

---

# 6. Chinese Stroke Data

## Make Me a Hanzi

Make Me a Hanzi cung cấp dữ liệu cho hơn 9.000 chữ Hán phổ biến, bao gồm:

```text
Character
Stroke order
Stroke vector graphics
Median paths
Dictionary information
Character decomposition
```

Đặc biệt phù hợp với animation vì dữ liệu có thể chuyển thành:

```text
outlinePath
medianPath
```

Ví dụ:

```json
{
  "character": "学",
  "strokes": [
    "M...",
    "M..."
  ],
  "medians": [
    [[x,y], [x,y]],
    [[x,y], [x,y]]
  ]
}
```

Dữ liệu stroke có thể chuyển thành format thống nhất với KanjiVG.

---

# 7. Unified Data Pipeline

```text
                    DATA SOURCES
                         │
        ┌────────────────┼────────────────┐
        │                │                │
        ▼                ▼                ▼
      HSK              JLPT          Dictionary
        │                │                │
        │                │          ┌─────┴─────┐
        │                │          │           │
        │                │       KANJIDIC2   JMdict
        │                │          │           │
        └────────┬───────┴──────────┴───────────┘
                 │
                 ▼
          DATA NORMALIZATION
                 │
                 ├── Unicode normalize
                 ├── Remove duplicates
                 ├── Validate level
                 ├── Normalize readings
                 ├── Normalize meanings
                 └── Normalize character
                 │
                 ▼
             CHARACTER MAP
                 │
                 ├── Chinese → Make Me a Hanzi
                 └── Japanese → KanjiVG
                 │
                 ▼
            STROKE ENRICHMENT
                 │
                 ├── order
                 ├── medianPath
                 └── outlinePath
                 │
                 ▼
             LESSON BUILDER
                 │
                 ▼
               DATABASE
```

---

# 8. Database Model

Recommended structure:

```text
Level
 │
 └── Lesson
      │
      └── LessonVocabulary
             │
             ▼
         Vocabulary
             │
             ├── Character
             │      │
             │      └── StrokeData
             │
             ├── Reading
             └── Meaning
```

---

# 9. Level

Ví dụ:

```json
{
  "code": "HSK1",
  "name": "HSK Level 1",
  "language": "zh"
}
```

Japanese:

```json
{
  "code": "JLPT_N5",
  "name": "JLPT N5",
  "language": "ja"
}
```

---

# 10. Vocabulary

Ví dụ:

```json
{
  "word": "学习",
  "language": "zh",
  "reading": "xuéxí",
  "meaning": "to study"
}
```

Japanese:

```json
{
  "word": "勉強",
  "language": "ja",
  "reading": "べんきょう",
  "meaning": "study"
}
```

---

# 11. Character Extraction

Vocabulary không được lưu trực tiếp thành Character.

Ví dụ:

```text
学习
```

được tách thành:

```text
学
习
```

Sau đó:

```text
Vocabulary
   │
   ├── 学
   └── 习
```

Một Character có thể xuất hiện trong nhiều Vocabulary.

Ví dụ:

```text
学
├── 学习
├── 学生
├── 学校
└── 学问
```

Vì vậy Character và Vocabulary phải là quan hệ riêng.

---

# 12. Stroke Enrichment

Sau khi Character được tạo:

```text
Character
    │
    ▼
Stroke Dataset Lookup
    │
    ├── Chinese
    │      ↓
    │   Make Me a Hanzi
    │
    └── Japanese
           ↓
        KanjiVG
```

Kết quả:

```json
{
  "character": "学",
  "strokes": [
    {
      "order": 1,
      "medianPath": "...",
      "outlinePath": "..."
    }
  ]
}
```

---

# 13. Lesson Generation

Không nên import dataset thành Lesson trực tiếp.

Pipeline:

```text
HSK/JLPT
   ↓
Vocabulary
   ↓
Character
   ↓
Deduplicate
   ↓
Sort
   ↓
Lesson Generation
```

Ví dụ:

```text
HSK1
│
├── Lesson 01
│   ├── 你
│   ├── 好
│   └── 我
│
├── Lesson 02
│   ├── 学
│   ├── 生
│   └── 人
│
└── Lesson 03
    └── ...
```

Lesson là cấu trúc học tập của ứng dụng, **không phải cấu trúc nguyên bản của dataset**.

---

# 14. Validation

Trước khi insert database:

```text
Validate
 │
 ├── Character không rỗng
 ├── Unicode hợp lệ
 ├── Language hợp lệ
 ├── Level tồn tại
 ├── Vocabulary không duplicate
 ├── Stroke order hợp lệ
 ├── Stroke path hợp lệ
 └── Reading/meaning hợp lệ
```

Nếu lỗi:

```text
invalid/
├── missing-stroke.json
├── invalid-unicode.json
├── duplicate.json
└── invalid-level.json
```

Không nên silently bỏ qua dữ liệu lỗi.

---

# 15. Versioning

Mỗi dataset import phải lưu version:

```json
{
  "source": "KanjiVG",
  "version": "20260714",
  "importedAt": "2026-08-11"
}
```

Ví dụ:

```text
HSK
version: HSK 3.0

KanjiVG
version: r20260714

KANJIDIC2
version: YYYY-NN

JMdict
version: YYYY-MM-DD
```

Điều này giúp sau này cập nhật dataset mà không mất khả năng truy vết.

---

# 16. Recommended Sources

### Chinese

* HSK / Chinese Testing International:
  https://www.chinesetest.cn/

* Make Me a Hanzi:
  https://github.com/skishore/makemeahanzi

### Japanese

* Official JLPT:
  https://www.jlpt.jp/

* KANJIDIC2 / EDRDG:
  https://www.edrdg.org/wiki/KANJIDIC_Project.html

* JMdict / EDRDG:
  https://www.edrdg.org/jmdict/j_jmdict.html

* KanjiVG:
  https://github.com/KanjiVG/kanjivg

---

# 17. Recommended Project Structure

```text
backend/
│
├── data/
│   ├── raw/
│   │   ├── hsk/
│   │   ├── jlpt/
│   │   ├── kanjidic2/
│   │   ├── jmdict/
│   │   ├── kanjivg/
│   │   └── makemeahanzi/
│   │
│   ├── normalized/
│   │
│   ├── validated/
│   │
│   └── generated/
│
├── scripts/
│   ├── import-hsk/
│   ├── import-jlpt/
│   ├── import-kanjidic/
│   ├── import-jmdict/
│   ├── import-kanjivg/
│   ├── import-hanzi/
│   └── generate-lessons/
│
└── prisma/
    └── schema.prisma
```

---

# 18. Final Architecture

```text
             OFFICIAL / TRUSTED SOURCES
                       │
                       ▼
                Raw Dataset Files
                       │
                       ▼
                  Normalizer
                       │
                       ▼
                   Validator
                       │
                       ▼
              Character/Vocabulary
                    Mapping
                       │
              ┌────────┴────────┐
              ▼                 ▼
        Dictionary          Stroke Data
              │                 │
              └────────┬────────┘
                       ▼
                 Lesson Builder
                       │
                       ▼
                    Prisma
                       │
                       ▼
                  PostgreSQL
                       │
                       ▼
                    REST API
                       │
                       ▼
                    Flutter
                       │
             ┌─────────┴─────────┐
             ▼                   ▼
        Lesson Screen       Character Screen
                                  │
                                  ▼
                           Stroke Animation
```

## Nguyên tắc

1. **Không lấy một dataset duy nhất làm tất cả.**
2. **HSK/JLPT dùng để xác định curriculum/level.**
3. **KANJIDIC2/JMdict dùng để enrich Japanese data.**
4. **Make Me a Hanzi dùng cho Chinese stroke data.**
5. **KanjiVG dùng cho Japanese stroke data.**
6. **Vocabulary và Character là hai entity khác nhau.**
7. **Lesson là cấu trúc riêng của ứng dụng.**
8. **Mọi dataset phải lưu source + version.**
9. **Normalize và validate trước khi seed database.**
10. **Không import trực tiếp raw dataset vào production database.**

### Nguồn đã kiểm tra

KanjiVG hiện có release `r20260714`; repository mô tả rõ dữ liệu SVG, license CC BY-SA 3.0 và các format phát hành.

Make Me a Hanzi cung cấp dữ liệu dictionary và graphical/stroke-order cho hơn 9.000 chữ Hán phổ biến.

KANJIDIC2 là dự án của EDRDG và cung cấp dữ liệu Kanji, readings, meanings cùng nhiều metadata; dự án công bố license CC BY-SA 4.0.

JMdict là database từ vựng đa ngôn ngữ với tiếng Nhật làm ngôn ngữ trung tâm và được EDRDG duy trì.
