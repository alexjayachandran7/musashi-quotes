# Musashi Quotes — Flutter App

A beautifully crafted quotes app featuring the wisdom of Miyamoto Musashi,
styled with a dark ink-and-gold aesthetic inspired by feudal Japan.

## Features
- 18 quotes from *The Book of Five Rings* and *Dokkōdō*
- Save favourites (persisted with SharedPreferences)
- Browse by book
- Smooth fade animations between quotes
- Works on **iOS, Android, and Web** from one codebase

## Setup

### Prerequisites
- Flutter SDK 3.x: https://flutter.dev/docs/get-started/install
- For iOS: Xcode on Mac, OR use a cloud Mac (MacInCloud, Codemagic)
- For Android: Android Studio or VS Code with Flutter plugin

### Run locally
```bash
# Install dependencies
flutter pub get

# Run on Android emulator or device
flutter run

# Run on iOS (requires Mac + Xcode)
flutter run -d ios

# Run as web app (no Mac needed!)
flutter run -d chrome
```

### Build for Android (no Mac needed)
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-apk/app-release.apk
```

### Build for iOS (requires Mac or cloud CI)
Option 1 — **Codemagic** (free tier available): https://codemagic.io
Option 2 — **MacInCloud**: https://www.macincloud.com
Option 3 — **GitHub Actions** with a Mac runner

```bash
# On a Mac:
flutter build ios --release
```

## Project Structure
```
lib/
  main.dart       # Everything in one clean file
pubspec.yaml      # Dependencies
```

## Customising Quotes
All quotes are in the `quotes` list at the top of `lib/main.dart`.
Add more by appending `Quote(text: "...", book: "...")` entries.

## Dependencies
- `google_fonts` — Cinzel & EB Garamond fonts
- `shared_preferences` — persist favourite quotes
