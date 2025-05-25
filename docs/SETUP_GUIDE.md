# 🚀 PABLOS Setup Guide

Complete setup instructions for the PABLOS Hacker Chat application.

## 📋 Prerequisites

### System Requirements
- **Operating System**: Windows 10+, macOS 10.14+, or Linux (Ubuntu 18.04+)
- **RAM**: 4GB minimum, 8GB recommended
- **Storage**: 2GB free space
- **Internet**: Stable connection required for AI integration

### Development Tools

#### 1. Flutter SDK
```bash
# Download Flutter SDK (latest stable)
# Visit: https://flutter.dev/docs/get-started/install

# Add to PATH (Linux/macOS)
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

#### 2. IDE Setup
**VS Code (Recommended)**
```bash
# Install VS Code extensions
- Flutter
- Dart
- Flutter Widget Snippets
- Bracket Pair Colorizer
- Material Icon Theme
```

**Android Studio (Alternative)**
```bash
# Install plugins
- Flutter plugin
- Dart plugin
```

#### 3. Platform Setup

**Android Development**
```bash
# Install Android Studio
# Setup Android SDK (API Level 21+)
# Create virtual device (Android 7.0+)

# Accept licenses
flutter doctor --android-licenses
```

**iOS Development (macOS only)**
```bash
# Install Xcode from App Store
# Install Xcode command line tools
xcode-select --install

# Install CocoaPods
sudo gem install cocoapods
```

**Web Development**
```bash
# Enable web support
flutter config --enable-web

# Install Chrome for testing
```

## 📦 Project Setup

### 1. Clone Repository
```bash
# Clone the project
git clone https://github.com/tama/pablos-hacker-chat.git
cd pablos-hacker-chat

# Check Flutter compatibility
flutter doctor
```

### 2. Install Dependencies
```bash
# Get Flutter packages
flutter pub get

# Generate platform files (if needed)
flutter create . --platforms=android,ios,web
```

### 3. Font Installation

#### Download Required Fonts
1. **FiraCode** - Terminal/Programming Font
   ```bash
   # Download from Google Fonts
   wget https://fonts.google.com/specimen/Fira+Code
   
   # Or manually download:
   # https://github.com/tonsky/FiraCode/releases
   ```

2. **JetBrains Mono** - Code Font
   ```bash
   # Download from JetBrains
   wget https://github.com/JetBrains/JetBrainsMono/releases
   ```

#### Install Fonts
```bash
# Create fonts directory
mkdir -p assets/fonts

# Copy font files to assets/fonts/
cp ~/Downloads/FiraCode-Regular.ttf assets/fonts/
cp ~/Downloads/FiraCode-Bold.ttf assets/fonts/
cp ~/Downloads/JetBrainsMono-Regular.ttf assets/fonts/
cp ~/Downloads/JetBrainsMono-Bold.ttf assets/fonts/
```

Font files should be placed as follows:
```
assets/
└── fonts/
    ├── FiraCode-Regular.ttf
    ├── FiraCode-Bold.ttf
    ├── JetBrainsMono-Regular.ttf
    └── JetBrainsMono-Bold.ttf
```

### 4. Configuration

#### Environment Setup
```bash
# Create environment file
cp .env.example .env

# Edit environment variables
nano .env
```

Example `.env` file:
```bash
# Environment
ENVIRONMENT=development

# API Configuration
PROD_API_URL=https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run
PROD_AGENT_ID=6c58e25c-3913-11f0-bf8f-4e013e2ddde4
PROD_CHATBOT_ID=SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q

# Development URLs (optional)
DEV_API_URL=https://dev-api.pablos.local
DEV_AGENT_ID=dev-agent-id-123
DEV_CHATBOT_ID=dev-chatbot-id-789

# Features
ENABLE_ANALYTICS=false
ENABLE_DEBUG_MODE=true
```

#### Platform Configuration

**Android Configuration**
```bash
# Edit android/app/build.gradle
android {
    compileSdkVersion 34
    
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}

# Update android/app/src/main/AndroidManifest.xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
```

**iOS Configuration**
```bash
# Edit ios/Runner/Info.plist
<key>NSAppTransportSecurity</key>
<dict>
    <key>NSAllowsArbitraryLoads</key>
    <true/>
</dict>
```

**Web Configuration**
```bash
# Edit web/index.html to add meta tags
<meta name="description" content="PABLOS - Tama The God AI Assistant">
<meta name="theme-color" content="#00FF41">
```

## 🔧 Build & Run

### Development Mode
```bash
# Run on specific platform
flutter run -d chrome      # Web
flutter run -d android     # Android
flutter run -d ios         # iOS

# Run with hot reload
flutter run --hot

# Run with debug logging
flutter run --verbose
```

### Production Build

#### Android APK
```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APKs by architecture
flutter build apk --split-per-abi
```

#### iOS App
```bash
# Development build
flutter build ios --debug

# Release build
flutter build ios --release

# Build for App Store
flutter build ipa
```

#### Web App
```bash
# Debug build
flutter build web --debug

# Release build
flutter build web --release

# Build with custom base href
flutter build web --base-href=/pablos/
```

## 🧪 Testing

### Unit Tests
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/unit_tests/chat_provider_test.dart

# Run with coverage
flutter test --coverage
```

### Integration Tests
```bash
# Run integration tests
flutter test integration_test/

# Run on specific device
flutter test integration_test/app_test.dart -d chrome
```

### Widget Tests
```bash
# Run widget tests
flutter test test/widget_test.dart

# Run with verbose output
flutter test --verbose
```

## 🐛 Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues
```bash
# Fix Android licenses
flutter doctor --android-licenses

# Fix iOS setup
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer

# Fix web setup
flutter config --enable-web
```

#### 2. Font Loading Issues
```bash
# Verify font files exist
ls -la assets/fonts/

# Check pubspec.yaml font configuration
flutter packages get

# Clear font cache
flutter clean
flutter pub get
```

#### 3. Build Errors
```bash
# Clean project
flutter clean

# Remove build artifacts
rm -rf build/
rm -rf .dart_tool/

# Reinstall dependencies
flutter pub get

# Rebuild
flutter run
```

#### 4. Network Issues
```bash
# Check internet connection
ping google.com

# Verify API endpoints
curl https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run/api/health

# Check firewall settings
```

#### 5. Platform-Specific Issues

**Android Issues**
```bash
# Check Android SDK
flutter doctor -v

# Update Gradle
cd android && ./gradlew wrapper --gradle-version=7.6

# Clear Gradle cache
cd android && ./gradlew clean
```

**iOS Issues**
```bash
# Update CocoaPods
cd ios && pod install --repo-update

# Clean iOS build
cd ios && xcodebuild clean

# Reset iOS Simulator
xcrun simctl erase all
```

**Web Issues**
```bash
# Enable web support
flutter config --enable-web

# Check Chrome installation
which google-chrome

# Clear web cache
flutter clean
```

## 🚀 Deployment

### Android Deployment

#### Google Play Store
```bash
# Generate signed APK
flutter build apk --release

# Generate App Bundle (recommended)
flutter build appbundle --release

# Upload to Google Play Console
# Follow: https://developer.android.com/distribute/console
```

#### Direct APK Distribution
```bash
# Build release APK
flutter build apk --release

# APK location: build/app/outputs/flutter-apk/app-release.apk
```

### iOS Deployment

#### App Store
```bash
# Build for iOS
flutter build ios --release

# Open Xcode project
open ios/Runner.xcworkspace

# Archive and upload via Xcode
# Or use command line tools
```

#### TestFlight
```bash
# Build IPA
flutter build ipa

# Upload via Xcode or Application Loader
```

### Web Deployment

#### Static Hosting (Netlify, Vercel)
```bash
# Build web app
flutter build web --release

# Deploy build/web/ directory
# Configure routing for SPA
```

#### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase init hosting

# Deploy
firebase deploy
```

### Desktop Deployment

#### Windows
```bash
# Build Windows app
flutter build windows --release

# Create installer (optional)
# Use Inno Setup or similar
```

#### macOS
```bash
# Build macOS app
flutter build macos --release

# Create DMG (optional)
# Use create-dmg or similar
```

#### Linux
```bash
# Build Linux app
flutter build linux --release

# Create AppImage or Snap package
```

## 🔒 Security Setup

### Code Signing

#### Android
```bash
# Generate keystore
keytool -genkey -v -keystore ~/pablos-release-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias pablos

# Configure signing in android/app/build.gradle
```

#### iOS
```bash
# Configure signing in Xcode
# Set up provisioning profiles
# Enable automatic signing (development)
```

### Environment Security
```bash
# Never commit .env files
echo ".env" >> .gitignore

# Use build-time variables for sensitive data
flutter build apk --dart-define=API_KEY=your_key_here
```

## 📊 Performance Optimization

### Build Optimization
```bash
# Enable obfuscation (release builds)
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Reduce APK size
flutter build apk --release --target-platform android-arm64
```

### Runtime Optimization
```bash
# Profile app performance
flutter run --profile

# Analyze bundle size
flutter build apk --analyze-size
```

## 🔄 CI/CD Setup

### GitHub Actions
Create `.github/workflows/build.yml`:
```yaml
name: Build and Test
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: flutter test
      - run: flutter build apk --debug
```

### GitLab CI
Create `.gitlab-ci.yml`:
```yaml
stages:
  - test
  - build

flutter_test:
  stage: test
  image: cirrusci/flutter:stable
  script:
    - flutter pub get
    - flutter test

flutter_build:
  stage: build
  image: cirrusci/flutter:stable
  script:
    - flutter build apk --release
```

## 📱 Device Testing

### Physical Device Testing
```bash
# Enable USB debugging on Android
# Connect device and verify
flutter devices

# Run on connected device
flutter run -d <device-id>
```

### Emulator Testing
```bash
# List available emulators
flutter emulators

# Launch emulator
flutter emulators --launch <emulator-id>

# Run on emulator
flutter run
```

## 📚 Additional Resources

### Documentation
- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Guide](https://dart.dev/guides)
- [Material Design Guidelines](https://material.io/design)

### Community
- [Flutter Community](https://flutter.dev/community)
- [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter)
- [Reddit r/FlutterDev](https://reddit.com/r/FlutterDev)

### Tools
- [Flutter Inspector](https://flutter.dev/docs/development/tools/inspector)
- [Dart DevTools](https://dart.dev/tools/dart-devtools)
- [Firebase Console](https://console.firebase.google.com)

## 🆘 Getting Help

### Support Channels
1. **GitHub Issues**: Report bugs and feature requests
2. **Documentation**: Check this guide and API docs
3. **Community Forums**: Flutter and Dart communities
4. **Direct Contact**: Email support@pablos.ai

### Debug Information
When seeking help, include:
```bash
# Flutter version
flutter --version

# Doctor output
flutter doctor -v

# Error logs
flutter logs

# Build verbose output
flutter build <platform> --verbose
```

---

**🎉 Congratulations!** You've successfully set up PABLOS. Now you can start chatting with Tama The God! 

For advanced configuration and customization, check the other documentation files in the `/docs` folder.