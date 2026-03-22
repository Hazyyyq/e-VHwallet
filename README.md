# Wallet Apps - Flutter Mobile Wallet Application

A professional mobile wallet application built with Flutter, designed for seamless digital payment and financial management experiences.

> **Note:** This application was originally designed for mobile phones. While it can run on desktop browsers (Chrome) and web, some features may not work as intended on laptops/desktops. For the best experience, please use a physical Android device.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Running the Application](#running-the-application)
  - [Run on Chrome (Web)](#run-on-chrome-web)
  - [Run on Android Device (Phone)](#run-on-android-device-phone)
  - [Run on Android Emulator](#run-on-android-emulator)
- [Common Troubleshooting](#common-troubleshooting)
- [Project Structure](#project-structure)
- [Build for Production](#build-for-production)

---

## Prerequisites

Before running this project, ensure you have the following installed:

| Requirement | Version | Description |
|-------------|---------|-------------|
| Flutter SDK | 3.9.0+ | [Download Flutter](https://docs.flutter.dev/get-started/install) |
| Dart SDK | 3.9.0+ | Comes with Flutter SDK |
| Git | Latest | For version control |
| Android Studio | Latest | For Android development (optional for phone) |
| Chrome | Latest | For web development |

### For Android Device Development

- Android SDK configured
- USB debugging enabled on your phone
- A physical Android device (recommended) or Android emulator

---

## Installation

### 1. Clone the Repository

```bash
git clone <repository-url>
cd VHACKATON/e-VHwallet/wallet_apps
```

### 2. Install Dependencies

```bash
flutter pub get
```

This will download all required packages defined in `pubspec.yaml`.

---

## Running the Application

### Run on Chrome (Web)

**Best for:** Quick testing and development on desktop

```bash
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps
flutter run -d chrome
```

Or simply:

```bash
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps
flutter run
```

> **Note:** Chrome support is available but some mobile-specific features (camera for QR scanning, etc.) may require additional configuration or may not work on desktop browsers.

---

### Run on Android Device (Phone)

**Recommended for:** Full functionality and best user experience

#### Step 1: Enable Developer Options on Your Phone

1. Go to **Settings** > **About Phone**
2. Tap **Build Number** 7 times
3. Go back to **Settings** > **System** > **Developer Options**
4. Enable **USB Debugging**

#### Step 2: Connect Your Phone

1. Connect your Android phone to your computer via USB cable
2. Trust the computer if prompted on your phone
3. Make sure your phone screen is unlocked

#### Step 3: Run with Debug Mode Enabled

```bash
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps
flutter run -d <device-id>
```

To see available devices:

```bash
flutter devices
```

To run with verbose logging (for debugging):

```bash
flutter run -v
```

To hot-reload while debugging:

```bash
# Press 'r' in the terminal where flutter is running
# Or press 'R' for hot restart
```

#### Debug Mode Features

When running with debug mode, you can access:

- **Flutter DevTools** - Performance profiling
- **Hot Reload** - See code changes instantly
- **Breakpoints** - Debug using IDE
- **Widget Inspector** - Inspect UI hierarchy

---

### Run on Android Emulator

**Best for:** Testing without a physical device

```bash
# List available emulators
flutter emulators

# Launch an emulator (example)
flutter emulators --launch <emulator-id>

# Run on emulator
flutter run -d emulator
```

---

## Common Troubleshooting

### Problem: "No pubspec.yaml file found"

**Cause:** You're not in the correct project directory.

**Solution:**

```bash
# Navigate to the correct directory
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps

# Then run your command
flutter pub get
flutter run
```

---

### Problem: "Expected to find project root in current working directory"

**Cause:** Same as above - wrong directory.

**Solution:**

```bash
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps
```

---

### Problem: Dependencies are outdated or broken

**Solution 1: Get fresh dependencies**

```bash
flutter pub get
```

**Solution 2: Clean and reinstall**

```bash
# Clean build artifacts
flutter clean

# Delete pubspec.lock for a fresh install
del pubspec.lock

# Get dependencies again
flutter pub get

# Build again
flutter build windows
```

---

### Problem: Build errors or stale cache

**Solution: Full clean**

```bash
# Clean all build caches
flutter clean

# Clear pub cache (optional - use if issues persist)
flutter pub cache repair

# Reinstall dependencies
flutter pub get
```

---

### Problem: Flutter SDK not found or command not recognized

**Cause:** Flutter is not in your system PATH.

**Solution:**

1. Add Flutter to your PATH:
   - Open **System Properties** > **Environment Variables**
   - Add Flutter bin directory to PATH:
     ```
     C:\Users\haziq\Downloads\FlutterLearn\flutter\bin
     ```

2. Or use the full path:
   ```bash
   C:\Users\haziq\Downloads\FlutterLearn\flutter\bin\flutter.exe run
   ```

---

### Problem: Android device not detected

**Solution:**

```bash
# Check connected devices
flutter devices

# If device not showing, try:
adb devices

# Restart ADB server
adb kill-server
adb start-server
```

---

### Problem: "Error: Unable to determine engine version"

**Solution:**

```bash
# Navigate to Flutter SDK
cd C:\Users\haziq\Downloads\FlutterLearn\flutter

# Clean cache
git merge --abort
flutter doctor
flutter clean
```

---

### Problem: App crashes on startup

**Solution:**

```bash
flutter clean
flutter pub get
flutter run
```

---

## Project Structure

```
wallet_apps/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── Components/               # Reusable UI components
│   ├── Design/                   # Design utilities
│   ├── Pages/                    # Screen pages
│   ├── screens/                  # Additional screens
│   └── Utilities/                # Helper functions
├── android/                      # Android native code
├── ios/                          # iOS native code
├── web/                          # Web assets
├── windows/                      # Windows native code
├── pubspec.yaml                  # Dependencies
└── README.md                     # This file
```

---

## Build for Production

### Build for Windows

```bash
cd C:\Users\haziq\VHACKATON\e-VHwallet\wallet_apps
flutter build windows
```

Output: `build\windows\x64\runner\Release\wallet_apps.exe`

### Build for Web

```bash
flutter build web
```

Output: `build/web/`

### Build for Android APK

```bash
flutter build apk --release
```

Output: `build/app/outputs/flutter-apk/app-release.apk`

### Build for Android App Bundle

```bash
flutter build appbundle --release
```

---

## Quick Reference Commands

| Command | Description |
|---------|-------------|
| `flutter pub get` | Download dependencies |
| `flutter clean` | Remove build artifacts |
| `flutter doctor` | Check Flutter setup |
| `flutter devices` | List available devices |
| `flutter run` | Run the app |
| `flutter run -d chrome` | Run on Chrome |
| `flutter run -d <id>` | Run on specific device |
| `flutter build windows` | Build for Windows |
| `flutter build apk` | Build for Android APK |
| `flutter analyze` | Analyze code issues |

---

## Support

If you encounter any issues not covered here:

1. Run `flutter doctor` to check your setup
2. Try `flutter clean` and `flutter pub get`
3. Check the [Flutter Documentation](https://docs.flutter.dev/)
4. Ensure your Flutter SDK is up to date

---

## License

This project is for educational and development purposes.
