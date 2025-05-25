# 🚀 PABLOS Deployment Guide

Comprehensive deployment guide for PABLOS Hacker Chat application across all platforms.

## 📋 Pre-Deployment Checklist

### ✅ Code Quality
- [ ] All tests passing (`flutter test`)
- [ ] Code analysis clean (`flutter analyze`)
- [ ] Performance profiling completed
- [ ] Security audit completed
- [ ] Documentation updated

### ✅ Configuration
- [ ] Production API endpoints configured
- [ ] Environment variables set
- [ ] App signing certificates ready
- [ ] Analytics/monitoring configured
- [ ] Feature flags reviewed

### ✅ Assets & Resources
- [ ] All fonts included and working
- [ ] Images optimized and compressed
- [ ] Icons generated for all platforms
- [ ] App metadata completed
- [ ] Privacy policy and terms updated

## 🤖 Android Deployment

### Google Play Store

#### 1. App Signing Setup
```bash
# Generate release keystore
keytool -genkey -v -keystore ~/pablos-release-key.jks \
  -keyalg RSA -keysize 2048 -validity 10000 -alias pablos

# Store keystore securely
# Never commit to version control!
```

#### 2. Configure Gradle Signing
Create `android/key.properties`:
```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=pablos
storeFile=/path/to/pablos-release-key.jks
```

Update `android/app/build.gradle`:
```gradle
def keystoreProperties = new Properties()
def keystorePropertiesFile = rootProject.file('key.properties')
if (keystorePropertiesFile.exists()) {
    keystoreProperties.load(new FileInputStream(keystorePropertiesFile))
}

android {
    signingConfigs {
        release {
            keyAlias keystoreProperties['keyAlias']
            keyPassword keystoreProperties['keyPassword']
            storeFile keystoreProperties['storeFile'] ? file(keystoreProperties['storeFile']) : null
            storePassword keystoreProperties['storePassword']
        }
    }
    buildTypes {
        release {
            signingConfig signingConfigs.release
            shrinkResources true
            minifyEnabled true
        }
    }
}
```

#### 3. Build Release APK/AAB
```bash
# Build App Bundle (recommended for Play Store)
flutter build appbundle --release --obfuscate --split-debug-info=build/debug-info

# Build APK (for direct distribution)
flutter build apk --release --split-per-abi
```

#### 4. Google Play Console Setup
1. **Create App Listing**
   - App title: "PABLOS - AI Assistant"
   - Short description: "Advanced AI chat with hacker theme"
   - Full description: Include features, capabilities
   - Screenshots: All required sizes and orientations
   - Feature graphic: 1024x500px

2. **Content Rating**
   - Complete content rating questionnaire
   - Target audience: 13+ (due to hacker theme)

3. **App Content**
   - Privacy policy URL
   - App category: Productivity/Tools
   - Content guidelines compliance

4. **Release Management**
   - Upload AAB file
   - Set rollout percentage (start with 5-10%)
   - Configure release notes

### Alternative Android Distribution

#### Direct APK Distribution
```bash
# Build optimized APK
flutter build apk --release --target-platform android-arm64

# Host on website or distribute directly
# APK location: build/app/outputs/flutter-apk/app-release.apk
```

#### Samsung Galaxy Store
```bash
# Follow Samsung's guidelines
# Similar process to Google Play
# Additional Samsung-specific optimizations
```

## 🍎 iOS Deployment

### App Store Connect

#### 1. Apple Developer Setup
```bash
# Ensure you have:
# - Apple Developer Program membership ($99/year)
# - Xcode with latest iOS SDK
# - Valid provisioning profiles
```

#### 2. Configure iOS Project
Update `ios/Runner/Info.plist`:
```xml
<key>CFBundleDisplayName</key>
<string>PABLOS</string>
<key>CFBundleName</key>
<string>PABLOS</string>
<key>CFBundleShortVersionString</key>
<string>1.0.0</string>
<key>CFBundleVersion</key>
<string>1</string>
```

#### 3. Build for iOS
```bash
# Build iOS release
flutter build ios --release

# Generate IPA
flutter build ipa --release
```

#### 4. Xcode Configuration
```bash
# Open Xcode project
open ios/Runner.xcworkspace

# Configure signing:
# - Team: Your development team
# - Bundle Identifier: com.tama.pablos
# - Signing Certificate: Distribution certificate
```

#### 5. App Store Connect Setup
1. **App Information**
   - Name: PABLOS
   - Bundle ID: com.tama.pablos
   - SKU: unique identifier
   - Primary language: English/Indonesian

2. **App Privacy**
   - Data collection practices
   - Privacy policy URL
   - Privacy questions

3. **Pricing and Availability**
   - Free app
   - Territory availability
   - Release scheduling

4. **App Review Information**
   - Contact information
   - Demo account (if needed)
   - Review notes

#### 6. Upload and Submit
```bash
# Upload via Xcode
# Or use Application Loader
# Or use command line tools

# Submit for review
# Review process: 24-48 hours typically
```

### TestFlight Beta Testing
```bash
# Upload build to TestFlight
# Add internal testers (up to 100)
# Add external testers (up to 10,000)
# Collect feedback before App Store release
```

## 🌐 Web Deployment

### Static Hosting Platforms

#### Netlify Deployment
```bash
# Build web app
flutter build web --release --base-href="/"

# Deploy via Netlify CLI
npm install -g netlify-cli
netlify login
netlify deploy --prod --dir=build/web

# Or drag & drop build/web/ to Netlify dashboard
```

Create `build/web/_redirects`:
```
/*    /index.html   200
```

#### Vercel Deployment
```bash
# Install Vercel CLI
npm install -g vercel

# Deploy
cd build/web
vercel --prod
```

Create `vercel.json`:
```json
{
  "rewrites": [
    { "source": "/(.*)", "destination": "/index.html" }
  ]
}
```

#### GitHub Pages
```bash
# Build with proper base href
flutter build web --base-href="/pablos-hacker-chat/"

# Push to gh-pages branch
git subtree push --prefix build/web origin gh-pages
```

#### Firebase Hosting
```bash
# Install Firebase CLI
npm install -g firebase-tools

# Initialize Firebase
firebase login
firebase init hosting

# Configure firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}

# Deploy
flutter build web --release
firebase deploy
```

### Custom Server Deployment

#### Nginx Configuration
```nginx
server {
    listen 80;
    server_name pablos.yourdomain.com;
    root /var/www/pablos/build/web;
    index index.html;

    location / {
        try_files $uri $uri/ /index.html;
    }

    # Enable gzip compression
    gzip on;
    gzip_types text/css application/javascript application/json;

    # Cache static assets
    location ~* \.(js|css|png|jpg|jpeg|gif|ico|svg|woff|woff2)$ {
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
}
```

#### Apache Configuration
```apache
<VirtualHost *:80>
    ServerName pablos.yourdomain.com
    DocumentRoot /var/www/pablos/build/web
    
    <Directory /var/www/pablos/build/web>
        Options Indexes FollowSymLinks
        AllowOverride All
        Require all granted
    </Directory>
    
    # Handle client-side routing
    RewriteEngine On
    RewriteCond %{REQUEST_FILENAME} !-f
    RewriteCond %{REQUEST_FILENAME} !-d
    RewriteRule . /index.html [L]
</VirtualHost>
```

## 🖥️ Desktop Deployment

### Windows

#### Windows Store (MSIX)
```bash
# Build Windows app
flutter build windows --release

# Package as MSIX
# Install Windows App SDK
# Use Visual Studio or command line tools
```

#### Direct Distribution
```bash
# Build Windows executable
flutter build windows --release

# Create installer with Inno Setup
# Script example:
[Setup]
AppName=PABLOS
AppVersion=1.0.0
DefaultDirName={autopf}\PABLOS
OutputBaseFilename=PABLOS-Setup

[Files]
Source: "build\windows\runner\Release\*"; DestDir: "{app}"; Flags: recursesubdirs
```

### macOS

#### Mac App Store
```bash
# Build macOS app
flutter build macos --release

# Configure in Xcode
# - Signing certificates
# - Entitlements
# - Sandbox settings

# Submit via App Store Connect
```

#### Direct Distribution
```bash
# Build macOS app
flutter build macos --release

# Create DMG
create-dmg \
  --volname "PABLOS Installer" \
  --window-pos 200 120 \
  --window-size 800 400 \
  PABLOS-1.0.0.dmg \
  build/macos/Build/Products/Release/PABLOS.app
```

### Linux

#### Snap Package
```yaml
# snapcraft.yaml
name: pablos
version: '1.0.0'
summary: PABLOS AI Assistant
description: Advanced AI chat with hacker theme

parts:
  pablos:
    plugin: flutter
    source: .
    flutter-target: lib/main.dart

apps:
  pablos:
    command: pablos
    extensions: [flutter-dev]
```

```bash
# Build snap
snapcraft

# Upload to Snap Store
snapcraft upload pablos_1.0.0_amd64.snap
```

#### AppImage
```bash
# Build Linux app
flutter build linux --release

# Create AppImage using linuxdeploy
# Follow AppImage documentation
```

## 📊 Monitoring & Analytics

### Crash Reporting

#### Sentry Setup
```bash
# Add to pubspec.yaml
dependencies:
  sentry_flutter: ^7.0.0

# Configure in main.dart
await SentryFlutter.init(
  (options) {
    options.dsn = 'YOUR_SENTRY_DSN';
  },
  appRunner: () => runApp(PablosApp()),
);
```

#### Firebase Crashlytics
```bash
# Add Firebase Crashlytics
flutter pub add firebase_crashlytics

# Configure and initialize
```

### Performance Monitoring

#### Firebase Performance
```bash
# Add Firebase Performance
flutter pub add firebase_performance

# Monitor app performance metrics
```

### Analytics Integration

#### Firebase Analytics
```bash
# Add Firebase Analytics
flutter pub add firebase_analytics

# Track user events and screens
```

## 🚀 CI/CD Pipeline

### GitHub Actions

Create `.github/workflows/deploy.yml`:
```yaml
name: Deploy PABLOS

on:
  push:
    branches: [main]
    tags: ['v*']

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.10.0'
      - run: flutter pub get
      - run: flutter test
      - run: flutter analyze

  deploy-web:
    needs: test
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter build web --release
      - name: Deploy to Netlify
        uses: nwtgck/actions-netlify@v2.0
        with:
          publish-dir: './build/web'
          production-branch: main
        env:
          NETLIFY_AUTH_TOKEN: ${{ secrets.NETLIFY_AUTH_TOKEN }}
          NETLIFY_SITE_ID: ${{ secrets.NETLIFY_SITE_ID }}

  deploy-android:
    needs: test
    runs-on: ubuntu-latest
    if: startsWith(github.ref, 'refs/tags/')
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-java@v3
        with:
          distribution: 'zulu'
          java-version: '11'
      - uses: subosito/flutter-action@v2
      - run: flutter build appbundle --release
      - name: Upload to Play Store
        uses: r0adkll/upload-google-play@v1
        with:
          serviceAccountJsonPlainText: ${{ secrets.GOOGLE_PLAY_SERVICE_ACCOUNT }}
          packageName: com.tama.pablos
          releaseFiles: build/app/outputs/bundle/release/app-release.aab
          track: internal
```

### GitLab CI

Create `.gitlab-ci.yml`:
```yaml
stages:
  - test
  - build
  - deploy

variables:
  FLUTTER_VERSION: "3.10.0"

before_script:
  - apt-get update -qq && apt-get install -y -qq curl
  - curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz | tar -xJ
  - export PATH="$PATH:`pwd`/flutter/bin"
  - flutter doctor -v

test:
  stage: test
  script:
    - flutter pub get
    - flutter test
    - flutter analyze

build:web:
  stage: build
  script:
    - flutter build web --release
  artifacts:
    paths:
      - build/web/
    expire_in: 1 hour

deploy:web:
  stage: deploy
  script:
    - echo "Deploying to production server"
    # Add your deployment script here
  only:
    - tags
```

## 🔒 Security Considerations

### App Security
```bash
# Enable obfuscation
flutter build apk --release --obfuscate --split-debug-info=build/debug-info

# Remove debug symbols
flutter build ios --release --no-tree-shake-icons
```

### API Security
```bash
# Use HTTPS only
# Implement certificate pinning
# Validate all API responses
# Never expose API keys in client code
```

### Data Protection
```bash
# Encrypt sensitive local data
# Implement proper session management
# Follow platform security guidelines
# Regular security audits
```

## 📈 Post-Deployment

### Monitoring
- [ ] App crash rates < 0.1%
- [ ] App load times < 3 seconds
- [ ] API response times < 2 seconds
- [ ] User retention tracking
- [ ] Performance metrics

### User Feedback
- [ ] App store reviews monitoring
- [ ] In-app feedback collection
- [ ] Support ticket system
- [ ] User surveys

### Updates & Maintenance
- [ ] Regular dependency updates
- [ ] Security patches
- [ ] Feature updates based on feedback
- [ ] Performance optimizations

## 🆘 Rollback Procedures

### Emergency Rollback
```bash
# Google Play Console
# - Use release management
# - Roll back to previous version
# - Adjust rollout percentage

# App Store Connect
# - Remove current version from sale
# - Submit previous version update

# Web hosting
# - Revert to previous build
# - Update CDN cache
```

### Hotfix Deployment
```bash
# Create hotfix branch
git checkout -b hotfix/critical-fix

# Make minimal changes
# Test thoroughly
# Deploy with expedited review (if needed)
```

---

## 📞 Support & Resources

### Deployment Support
- **Google Play**: [Play Console Help](https://support.google.com/googleplay/android-developer)
- **App Store**: [App Store Connect Help](https://developer.apple.com/support/app-store-connect/)
- **Firebase**: [Firebase Documentation](https://firebase.google.com/docs)

### Community Resources
- [Flutter Deployment Guide](https://flutter.dev/docs/deployment)
- [r/FlutterDev](https://reddit.com/r/FlutterDev)
- [Flutter Community Discord](https://discord.gg/flutter)

---

**🎉 Congratulations!** PABLOS is now deployed and ready to help users with their AI assistant needs. Monitor the deployment closely for the first few days and be ready to respond to any issues quickly.