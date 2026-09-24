<p align="center">
  <img src="https://img.icons8.com/fluency/96/birthday-cake.png" alt="Age Calculator Logo" width="96" height="96"/>
</p>

<h1 align="center">Age Calculator</h1>

<p align="center">
  A premium, feature-rich age calculator built with Flutter — featuring real-time life tickers, glassmorphic UI, birthday countdown, zodiac profiles, and offline birthday reminders.
</p>

<p align="center">
  <a href="#features">Features</a> •
  <a href="#screenshots">Screenshots</a> •
  <a href="#architecture">Architecture</a> •
  <a href="#getting-started">Getting Started</a> •
  <a href="#tech-stack">Tech Stack</a> •
  <a href="#project-structure">Project Structure</a> •
  <a href="#contributing">Contributing</a> •
  <a href="#license">License</a>
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.47+-02569B?logo=flutter&logoColor=white" alt="Flutter"/>
  <img src="https://img.shields.io/badge/Dart-3.11+-0175C2?logo=dart&logoColor=white" alt="Dart"/>
  <img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green" alt="Platform"/>
  <img src="https://img.shields.io/badge/Architecture-Clean%20Architecture-blueviolet" alt="Architecture"/>
  <img src="https://img.shields.io/badge/License-MIT-yellow" alt="License"/>
</p>

---

## Features

### 🎂 Precise Age Calculator
- Calculate exact age down to **years, months, days, hours, minutes, and seconds**
- Full lifetime breakdown: total months, weeks, days, hours, minutes, and seconds alive
- Day-of-the-week you were born on
- Future age projection via interactive **Time Travel slider**

### ⏱ Real-Time Life Ticker
- Live-updating counter showing your existence ticking in real-time precision
- Pause/resume capability for an immersive experience

### 🎉 Next Birthday Countdown
- Smart countdown to your next birthday with months, days, hours, minutes, and seconds remaining
- Animated year-cycle progress indicator (0–100%)
- Displays what day of the week your next birthday falls on
- Happy Birthday celebration when it's your special day! 🥳

### 📅 Date Difference Calculator
- Compute exact duration between any two dates
- Breakdown into years, months, and days
- **Business day calculator** — working days (Mon–Fri) vs. weekend days (Sat–Sun)
- Optional "include end day (+1)" toggle

### 👨‍👩‍👧‍👦 Family & Friends Birthday Tracker
- Save unlimited profiles with name, date of birth, relationship, and custom avatar color
- Relationship categories: Family, Friend, Partner, Colleague
- Filterable profile list with quick-view age summary
- **1-tap open in Calculator** to view any profile's full age breakdown
- CRUD operations with persistent local SQLite storage

### 🔔 Offline Birthday Reminders
- Local push notifications for birthday reminders — **no internet required**
- Per-profile toggle to enable/disable reminders
- Android & iOS notification permission handling

### 🌟 Life Milestones & Infographics
- Estimated **total heartbeats** (~80 bpm average)
- Estimated **total breaths taken** (~16 bpm average)
- **Hours spent sleeping** (based on ~8 hours/day)
- Rich visual presentation with animated counters

### ♈ Astrological Profile
- **Western Zodiac** — sign, symbol, element, date range, and personality traits
- **Chinese Zodiac** — animal, symbol, element, and personality traits
- Determined automatically from date of birth

### 🎨 Premium Glassmorphic UI
- Full **glassmorphism** design system with frosted-glass cards, backdrop blur, and ambient glow orbs
- **Dynamic birth-month color engine** — accent colors adapt based on user's birth month (12 unique palettes mapped to birthstones/seasons)
- Smooth animated transitions with `AnimatedContainer`
- Dark mode and Light mode with one-tap toggle
- Floating glassmorphic bottom navigation bar
- Responsive layout support

### 🌐 Bilingual Localization
- Full support for **English** and **বাংলা (Bangla/Bengali)**
- Bangla numeral conversion (০১২৩৪৫৬৭৮৯)
- Runtime language switching

### 📱 Home Screen Widget
- Native Android/iOS home screen widget support via `home_widget`
- Displays user name, current age, and days until next birthday
- Syncs automatically when age is calculated

---

## Architecture

The project follows **Clean Architecture** principles with a clear separation of concerns:

```
┌──────────────────────────────────────────────────────┐
│                    UI Layer                          │
│  (Screens, Widgets, ViewModels via Provider)         │
├──────────────────────────────────────────────────────┤
│                  Domain Layer                        │
│  (Entities, Repository Contracts, Use Cases)         │
├──────────────────────────────────────────────────────┤
│                   Data Layer                         │
│  (Models, Repository Implementations, Local DB)      │
└──────────────────────────────────────────────────────┘
```

| Layer    | Responsibility                                                              |
|----------|-----------------------------------------------------------------------------|
| **UI**   | Screens, reusable widgets, ViewModels (`ChangeNotifier` + `Provider`)       |
| **Domain** | Pure business entities, abstract repository contracts, use case classes    |
| **Data** | SQLite data sources (`sqflite`), data models with serialization, repo impls |
| **Core** | Theme engine, color system, localization, notification & widget services, utilities |

### State Management

- **Provider** (`ChangeNotifierProvider`) for reactive state management
- Dedicated `ViewModel` per feature screen
- Global `ThemeProvider` and `LocaleProvider` for app-wide state

---

## Getting Started

### Prerequisites

| Requirement  | Minimum Version |
|-------------|----------------|
| Flutter SDK | `3.47.0+`      |
| Dart SDK    | `3.11.0+`      |
| Android     | API 21+ (Lollipop) |
| iOS         | 12.0+          |

### Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/sksojib6860/age-calculator.git
   cd age-calculator
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Run the app**

   ```bash
   # Debug mode
   flutter run

   # Release mode (Android)
   flutter run --release

   # Release mode (iOS)
   flutter run --release --no-codesign
   ```

4. **Run tests**

   ```bash
   flutter test
   ```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle (for Google Play)
flutter build appbundle --release

# iOS
flutter build ios --release
```

---

## Tech Stack

| Category               | Technology                                                                 |
|------------------------|---------------------------------------------------------------------------|
| **Framework**          | [Flutter](https://flutter.dev) 3.47+                                      |
| **Language**           | [Dart](https://dart.dev) 3.11+                                            |
| **State Management**   | [Provider](https://pub.dev/packages/provider) 6.x                        |
| **Local Database**     | [sqflite](https://pub.dev/packages/sqflite) 2.x                          |
| **Notifications**      | [flutter_local_notifications](https://pub.dev/packages/flutter_local_notifications) 22.x |
| **Home Screen Widget** | [home_widget](https://pub.dev/packages/home_widget) 0.10.x               |
| **Internationalization** | [intl](https://pub.dev/packages/intl) + `flutter_localizations`        |
| **Unique IDs**         | [uuid](https://pub.dev/packages/uuid) 4.x                                |
| **File Paths**         | [path_provider](https://pub.dev/packages/path_provider) + [path](https://pub.dev/packages/path) |

---

## Project Structure

```
lib/
├── main.dart                          # App entry point & DI setup
│
├── core/                              # Shared infrastructure
│   ├── constants/
│   │   ├── app_colors.dart            # Color system + 12 birth-month palettes
│   │   ├── app_dimensions.dart        # Spacing, radii, blur constants
│   │   └── app_text_styles.dart       # Typography scale
│   ├── localization/
│   │   ├── app_localizations.dart     # EN/BN translation map + delegate
│   │   └── locale_provider.dart       # Runtime locale switching
│   ├── services/
│   │   ├── home_widget_service.dart   # Native home screen widget sync
│   │   └── notification_service.dart  # Offline birthday notification manager
│   ├── theme/
│   │   ├── app_theme.dart             # Light/Dark Material themes
│   │   └── theme_provider.dart        # Theme mode + birth-month accent state
│   ├── utils/
│   │   ├── date_calculator.dart       # Core age & date arithmetic
│   │   ├── milestone_calculator.dart  # Heartbeat, breath, sleep estimations
│   │   └── zodiac_helper.dart         # Western & Chinese zodiac resolver
│   └── widgets/
│       ├── animated_counter.dart      # Animated number counter widget
│       ├── custom_date_picker_field.dart
│       ├── glass_card.dart            # Glassmorphic card with BackdropFilter
│       └── responsive_wrapper.dart    # Screen-size responsive layout wrapper
│
├── data/                              # Data layer
│   ├── datasources/local/
│   │   ├── app_database.dart          # SQLite database helper
│   │   └── profile_dao.dart           # Profile CRUD data access object
│   ├── models/
│   │   └── profile_model.dart         # DB model with JSON serialization
│   └── repositories/
│       └── profile_repository_impl.dart
│
├── domain/                            # Domain layer (pure Dart)
│   ├── entities/
│   │   ├── age_result.dart            # AgeResult, NextBirthdayInfo, FutureAgeResult
│   │   ├── date_diff_result.dart      # DateDiffResult (with business days)
│   │   ├── friend_profile.dart        # FriendProfile entity
│   │   └── life_milestones.dart       # LifeMilestones, WesternZodiac, ChineseZodiac
│   ├── repositories/
│   │   └── profile_repository.dart    # Abstract repository contract
│   └── use_cases/
│       ├── calculate_age_use_case.dart
│       ├── calculate_date_diff_use_case.dart
│       ├── calculate_milestones_use_case.dart
│       └── profile_use_cases.dart     # Get, Save, Delete profile use cases
│
└── ui/                                # Presentation layer
    └── features/
        ├── home_shell_screen.dart     # Main shell with gradient BG & nav bar
        ├── dashboard/
        │   ├── views/
        │   │   ├── dashboard_screen.dart
        │   │   └── widgets/
        │   │       ├── age_summary_card.dart
        │   │       ├── birthday_countdown_card.dart
        │   │       ├── live_ticker_card.dart
        │   │       ├── milestones_card.dart
        │   │       └── time_travel_card.dart
        │   └── view_models/
        │       └── dashboard_view_model.dart
        ├── date_difference/
        │   ├── views/
        │   │   └── date_difference_view.dart
        │   └── view_models/
        │       └── date_diff_view_model.dart
        └── family_friends/
            ├── views/
            │   ├── family_friends_view.dart
            │   └── add_edit_profile_sheet.dart
            └── view_models/
                └── family_friends_view_model.dart

test/
├── date_calculator_test.dart          # Unit tests for date calculation logic
├── milestone_calculator_test.dart     # Unit tests for milestone estimation
└── widget_test.dart                   # Widget smoke test
```

---

## Key Design Decisions

| Decision | Rationale |
|----------|-----------|
| **Clean Architecture** | Enforces testability, separation of concerns, and independent business logic |
| **Provider over Riverpod/Bloc** | Lightweight state management sufficient for the app's complexity |
| **sqflite for persistence** | Mature, reliable SQLite wrapper for structured local data with no server dependency |
| **Glassmorphism design system** | Premium, modern UI aesthetic with frosted-glass effect using `BackdropFilter` |
| **Birth-month color engine** | Personalized UX — 12 unique color palettes mapped to birthstones and seasons |
| **Offline-first notifications** | No backend required; birthday reminders work entirely offline via local notifications |
| **Bilingual from day one** | Full EN/BN support including numeral conversion for Bangla-speaking users |

---

## Contributing

Contributions are welcome! Please follow these steps:

1. **Fork** the repository
2. **Create** your feature branch: `git checkout -b feature/amazing-feature`
3. **Commit** your changes: `git commit -m 'Add some amazing feature'`
4. **Push** to the branch: `git push origin feature/amazing-feature`
5. **Open** a Pull Request

### Code Guidelines

- Follow [Effective Dart](https://dart.dev/effective-dart) style guidelines
- Write unit tests for all business logic in `domain/` and `core/utils/`
- Keep UI widgets composable and single-responsibility
- Run `dart analyze` and `dart format .` before committing

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.

---

<p align="center">
  Made with ❤️ using Flutter
</p>
