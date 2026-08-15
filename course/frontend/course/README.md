# Zenith Lingua - Language Learning App

Zenith Lingua is a robust, cross-platform language learning application built with Flutter. Designed with a focus on writing, pronunciation, and daily learning habits, it features an interactive Hanzi/Kanji stroke animation system, a daily contribution tracker (similar to GitHub's streak), and a secure authentication system.

## 🚀 Features

- **Authentication System**
  - Secure Login/Registration flow.
  - JWT Token management using `flutter_secure_storage`.
  - Automatic Dio interceptors for token injection and refresh.

- **Interactive Character Learning & Practice**
  - Animated Chinese (Hanzi) and Japanese (Kanji) stroke drawing.
  - Step-by-step stroke breakdown, rendering SVG path data beautifully on a custom Grid (Tian Zi Ge).
  - Play, Pause, and Re-draw controls with slow-motion visualization for practicing calligraphy.
  - **AI-powered Handwriting Evaluation**: Practice drawing characters directly on the screen and submit to the backend for automatic scoring and personalized feedback.
  - Detailed vocabulary context, readings (Onyomi/Kunyomi, Pinyin), and radicals breakdown.

- **Progress & Statistics Tracker**
  - A dynamic dashboard tracking the user's daily study activity.
  - Visual metrics including Total Learned, Total Mastered, Accuracy Rate, Current Streak, and XP Points.

- **Multi-language Support (i18n)**
  - Fully internationalized (English and Vietnamese).
  - Dynamic language switching via `flutter_localizations` and `.arb` files.

- **Theming**
  - Complete Dark and Light mode support using Material 3 color schemes.

## 🏗 Architecture

The app strictly follows **Clean Architecture** combined with a **Feature-First** approach to ensure high scalability, separation of concerns, and maintainability.

```text
lib/
├── core/                  # Core infrastructure (DI, Error Handling, Network, Storage, Themes)
├── features/              # Isolated feature modules
│   ├── auth/              # Authentication & Token Management
│   ├── characters/        # Kanji/Hanzi SVG Stroke animations & Details
│   ├── home/              # Dashboard & Progress Statistics
│   ├── practice/          # Handwriting Evaluation & Practice Mode
│   └── settings/          # Locale, Theme, and User Settings
├── l10n/                  # Localization (.arb files)
└── routes/                # GoRouter navigation configuration
```

Within each feature, the layers are separated as:
- **Presentation**: UI widgets, Pages, and state management (`flutter_bloc` / Cubit).
- **Domain**: Entities, UseCases, and Repository interfaces.
- **Data**: Data Sources (REST API via `Dio`), Models (JSON serialization), and Repository implementations.

## 🛠 Tech Stack

- **Framework**: Flutter (`^3.11.1`)
- **State Management**: `flutter_bloc` / `cubit`
- **Dependency Injection**: `get_it`
- **Routing**: `go_router`
- **Network**: `dio`
- **Functional Programming**: `dartz` (Either types for robust error handling)
- **Local Storage**: `flutter_secure_storage`
- **Vector Graphics**: `path_drawing` (for parsing SVG strings into PathMetrics)

## 🔧 Workflow & Conventions

1. **State Management**: `Cubit` is used for simpler UI states (auth, theme), while `Bloc` is reserved for complex event-driven streams. Blocs/Cubits *never* call repositories directly; they strictly interface with `UseCases`.
2. **Error Handling**: `dartz` is used to return `Either<Failure, T>` from the Data and Domain layers. Exceptions are caught at the Data layer and never leak to the Presentation layer. `Failure` classes map to localized strings in the UI.
3. **Dependency Injection**: All dependencies are lazily loaded and registered in `lib/core/di/injection.dart`.
4. **UI Guidelines**: No hardcoded strings. Everything is mapped through `app_en.arb` / `app_vi.arb` and generated via `flutter gen-l10n`.

## 🏃 Getting Started

### Prerequisites
- Flutter SDK `^3.11.1`
- Dart SDK

### Installation

1. Clone the repository and navigate to the project directory:
   ```bash
   cd frontend/course
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Generate localization files:
   ```bash
   flutter gen-l10n
   ```

4. Set up environment variables:
   Create a `.env` file in the root directory based on the backend API configuration:
   ```env
   API_URL=http://your-backend-url/api/v1
   ```

5. Run the application:
   ```bash
   flutter run
   ```

## 🤝 Contributing
When adding a new feature, please ensure you follow the standard sequence defined in `.agents/AGENTS.md`:
1. Analyze Data & Domain logic.
2. Define Presentation State.
3. Register DI.
4. Build UI and update `.arb` localization files.
5. Add routing configurations.
6. Verify clean code using `flutter analyze`.
