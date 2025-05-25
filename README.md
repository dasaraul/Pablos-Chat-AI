# 🚀 PABLOS Hacker Chat App

> **"Tama The God" AI Assistant with Blackhat Hacker Theme**

[![Flutter](https://img.shields.io/badge/Flutter-3.10.0+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.0.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![License](https://img.shields.io/badge/License-MIT-00FF41?style=for-the-badge)](LICENSE)

A sophisticated Flutter application featuring PABLOS, an AI assistant with expertise in Digital Ocean, Cybersecurity, Web Development, and Academic support. Built with a stunning blackhat hacker aesthetic that will make you feel like you're in The Matrix! 🔥💚

## 📱 Screenshots

```
┌─────────────────────────────────────────┐
│ ███████╗ ██████╗ ██████╗ ██╗      ██████╗ ███████╗│
│ ██╔════╝██╔═══██╗██╔══██╗██║     ██╔═══██╗██╔════╝│
│ ███████╗██║   ██║██████╔╝██║     ██║   ██║███████╗│
│ ╚════██║██║   ██║██╔══██╗██║     ██║   ██║╚════██║│
│ ███████║╚██████╔╝██████╔╝███████╗╚██████╔╝███████║│
│ ╚══════╝ ╚═════╝ ╚═════╝ ╚══════╝ ╚═════╝ ╚══════╝│
│                                                 │
│           "Tama The God" AI System             │
└─────────────────────────────────────────┘
```

## ✨ Features

### 🎨 **Hacker Aesthetic**
- **5 Blackhat Themes**: Classic, Red Hat, Blue Team, Matrix, Cyberpunk
- **Matrix Rain Effects**: Animated digital rain background
- **Glitch Animations**: Terminal-style glitch effects
- **Terminal UI**: Authentic command-line interface design
- **Neon Glow Effects**: Customizable glow animations

### 🤖 **AI Capabilities**
- **Multi-Domain Expertise**: Digital Ocean, Cybersecurity, Web Dev, Academic
- **Personality**: Bahasa Jaksel style ("gw", "elu", "literally", "whichis")
- **Smart Responses**: Context-aware AI powered by advanced language model
- **Quick Actions**: Pre-built command shortcuts
- **Real-time Chat**: Smooth conversation flow with typing indicators

### 🛠️ **Technical Features**
- **State Management**: Provider pattern for scalable architecture
- **Local Storage**: Persistent chat history and settings
- **Responsive Design**: Works on mobile, tablet, web, and desktop
- **Custom Animations**: Hand-crafted animations for premium UX
- **Modular Architecture**: Clean, maintainable codebase

## 🚀 Quick Start

### Prerequisites
- Flutter SDK 3.10.0+
- Dart SDK 3.0.0+
- Android Studio / VS Code
- Git

### Installation

```bash
# Clone the repository
git clone https://github.com/tama/pablos-hacker-chat.git
cd pablos-hacker-chat

# Install dependencies
flutter pub get

# Download required fonts (see Fonts section below)

# Run the app
flutter run
```

### 🎨 Fonts Setup

Download and place these fonts in `assets/fonts/`:

1. **FiraCode** (Terminal/Code font)
   ```bash
   # Download from Google Fonts
   https://fonts.google.com/specimen/Fira+Code
   
   # Required files:
   - FiraCode-Regular.ttf
   - FiraCode-Bold.ttf
   ```

2. **JetBrains Mono** (Programming font)
   ```bash
   # Download from JetBrains
   https://www.jetbrains.com/lp/mono/
   
   # Required files:
   - JetBrainsMono-Regular.ttf
   - JetBrainsMono-Bold.ttf
   ```

## 🏗️ Project Structure

```
pablos_hacker_chat/
├── 📁 lib/
│   ├── 📄 main.dart                     # App entry point
│   ├── 📁 screens/                      # UI Screens
│   │   ├── 📄 splash_screen.dart        # Loading screen with animations
│   │   ├── 📄 home_screen.dart          # Main chat interface
│   │   └── 📄 settings_screen.dart      # Configuration panel
│   ├── 📁 widgets/                      # Reusable Components
│   │   ├── 📄 chat_message_widget.dart  # Message display
│   │   ├── 📄 typing_indicator.dart     # AI typing animation
│   │   ├── 📄 hacker_app_bar.dart       # Custom app bar
│   │   ├── 📄 quick_actions_panel.dart  # Command shortcuts
│   │   ├── 📄 matrix_rain_widget.dart   # Matrix background
│   │   └── 📄 glitch_text_widget.dart   # Text glitch effects
│   ├── 📁 providers/                    # State Management
│   │   ├── 📄 chat_provider.dart        # Chat logic
│   │   └── 📄 theme_provider.dart       # Theme management
│   ├── 📁 services/                     # Business Logic
│   │   ├── 📄 pablos_ai_service.dart    # AI integration
│   │   └── 📄 storage_service.dart      # Local storage
│   ├── 📁 models/                       # Data Models
│   │   └── 📄 chat_message.dart         # Message structure
│   └── 📁 utils/                        # Utilities
│       ├── 📄 app_theme.dart            # Theme configuration
│       ├── 📄 constants.dart            # App constants
│       ├── 📄 helpers.dart              # Helper functions
│       └── 📄 validators.dart           # Input validation
├── 📁 assets/                           # Static Assets
│   ├── 📁 fonts/                        # Custom fonts
│   ├── 📁 images/                       # Images
│   └── 📁 animations/                   # Lottie files
└── 📄 pubspec.yaml                      # Dependencies
```

## 🎯 AI Integration

The app integrates with a powerful AI agent platform:

```dart
// Configuration
static const String agentId = '6c58e25c-3913-11f0-bf8f-4e013e2ddde4';
static const String chatbotId = 'SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q';
static const String baseUrl = 'https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run';
```

### 🧠 PABLOS Personality

PABLOS speaks in natural Bahasa Jaksel style:
- **"gw"** instead of "saya" (I/me)
- **"elu"** instead of "kamu" (you)
- **"literally"** for emphasis
- **"whichis"** as connective
- **"bos gw Tama"** referring to the creator

### 💬 Sample Conversations

```
User: "Hi PABLOS!"
PABLOS: "Halo bestie! Gw Pablos, literally siap bantuin elu anything! 
         From droplet setup sampe curhat session - what's up?"

User: "Bantuin setup Digital Ocean dong"
PABLOS: "Oh technical question nih! Gw expert banget di Digital Ocean 
         sama server management. Literally, bos gw Tama udah train gw 
         buat handle semua VPS issues. Spill the details dong!"
```

## 🎨 Themes

### Available Themes

1. **Classic Hacker** (Default)
   - Primary: `#00FF41` (Terminal Green)
   - Background: `#0A0A0A` (Deep Black)
   - Accent: `#00D97E` (Matrix Green)

2. **Red Hat** 
   - Primary: `#FF0040` (Cyber Red)
   - Background: `#0A0A0A` (Deep Black)
   - Accent: `#FF4466` (Light Red)

3. **Blue Team**
   - Primary: `#00FFFF` (Hacker Blue)
   - Background: `#0A0A0A` (Deep Black)
   - Accent: `#0099CC` (Light Blue)

4. **Matrix Code**
   - Primary: `#00FF00` (Bright Green)
   - Background: `#000000` (Pure Black)
   - Accent: `#00CC00` (Medium Green)

5. **Cyberpunk**
   - Primary: `#FF00FF` (Magenta)
   - Background: `#0A0A0A` (Deep Black)
   - Accent: `#00FFFF` (Cyan)

## 🛡️ Security Features

- **Input Validation**: Comprehensive message sanitization
- **Rate Limiting**: Prevents spam and abuse
- **Secure Storage**: Encrypted local data storage
- **Privacy First**: No unnecessary data collection

## 📊 Performance

- **Smooth Animations**: 60fps animations with GPU acceleration
- **Memory Efficient**: Optimized for mobile devices
- **Fast Startup**: Lazy loading and code splitting
- **Responsive UI**: Adapts to all screen sizes

## 🧪 Testing

```bash
# Run unit tests
flutter test

# Run integration tests
flutter test integration_test/

# Run with coverage
flutter test --coverage
```

## 📦 Build

### Android APK
```bash
flutter build apk --release
```

### iOS IPA
```bash
flutter build ios --release
```

### Web
```bash
flutter build web --release
```

### Desktop
```bash
# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### 📝 Commit Convention

```
feat: add new feature
fix: bug fix
docs: documentation
style: formatting
refactor: code refactoring
test: adding tests
chore: maintenance
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**Tama The God**
- GitHub: [@tama](https://github.com/tama)
- LinkedIn: [Tama](https://linkedin.com/in/tama)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Font creators (FiraCode, JetBrains Mono)
- The Matrix movie for inspiration
- Cyberpunk aesthetic community
- All contributors and testers

## 📞 Support

Having issues? Need help?

- 📧 Email: support@pablos.ai
- 💬 Discord: [PABLOS Community](https://discord.gg/pablos)
- 📚 Docs: [Documentation](https://docs.pablos.ai)
- 🐛 Issues: [GitHub Issues](https://github.com/tama/pablos-hacker-chat/issues)

## 🔮 Roadmap

- [ ] Voice chat integration
- [ ] Multiple AI models support
- [ ] Plugin system
- [ ] Team collaboration features
- [ ] Desktop-specific optimizations
- [ ] Advanced terminal emulator
- [ ] Code syntax highlighting
- [ ] File sharing capabilities

---

<div align="center">

**Made with 💚 by Tama The God**

*"In the matrix of code, PABLOS is your guide"*

[![Star this repo](https://img.shields.io/github/stars/tama/pablos-hacker-chat?style=social)](https://github.com/tama/pablos-hacker-chat)

</div>

---

## 🔧 Troubleshooting

### Common Issues

**Q: Fonts not loading properly**
```bash
# Make sure fonts are placed in assets/fonts/
# Check pubspec.yaml font declarations
# Run: flutter clean && flutter pub get
```

**Q: AI not responding**
```bash
# Check internet connection
# Verify API credentials in constants.dart
# Check logs: flutter logs
```

**Q: Animations laggy**
```bash
# Enable GPU acceleration
# Reduce animation complexity in settings
# Close background apps
```

**Q: Build issues**
```bash
# Clean build
flutter clean
flutter pub get
flutter pub deps

# Update Flutter
flutter upgrade
```

### Debug Mode

Enable debug mode in settings to see:
- Network requests
- Performance metrics
- Error logs
- AI response details