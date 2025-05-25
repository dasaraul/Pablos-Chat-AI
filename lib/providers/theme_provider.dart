import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum HackerThemeMode {
  classic,      // Green on black (default)
  redHat,       // Red on black
  blueTeam,     // Blue on black
  matrix,       // Bright green matrix style
  cyberpunk,    // Purple and cyan
}

class ThemeProvider extends ChangeNotifier {
  HackerThemeMode _currentTheme = HackerThemeMode.classic;
  bool _isGlowEnabled = true;
  bool _isAnimationsEnabled = true;
  bool _isMatrixRainEnabled = false;
  double _fontSizeMultiplier = 1.0;

  HackerThemeMode get currentTheme => _currentTheme;
  bool get isGlowEnabled => _isGlowEnabled;
  bool get isAnimationsEnabled => _isAnimationsEnabled;
  bool get isMatrixRainEnabled => _isMatrixRainEnabled;
  double get fontSizeMultiplier => _fontSizeMultiplier;

  static const String _themeKey = 'hacker_theme_mode';
  static const String _glowKey = 'glow_enabled';
  static const String _animationsKey = 'animations_enabled';
  static const String _matrixRainKey = 'matrix_rain_enabled';
  static const String _fontSizeKey = 'font_size_multiplier';

  ThemeProvider() {
    _loadThemeSettings();
  }

  Future<void> _loadThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      final themeIndex = prefs.getInt(_themeKey) ?? 0;
      _currentTheme = HackerThemeMode.values[themeIndex];
      
      _isGlowEnabled = prefs.getBool(_glowKey) ?? true;
      _isAnimationsEnabled = prefs.getBool(_animationsKey) ?? true;
      _isMatrixRainEnabled = prefs.getBool(_matrixRainKey) ?? false;
      _fontSizeMultiplier = prefs.getDouble(_fontSizeKey) ?? 1.0;
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading theme settings: $e');
      }
    }
  }

  Future<void> _saveThemeSettings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setInt(_themeKey, _currentTheme.index);
      await prefs.setBool(_glowKey, _isGlowEnabled);
      await prefs.setBool(_animationsKey, _isAnimationsEnabled);
      await prefs.setBool(_matrixRainKey, _isMatrixRainEnabled);
      await prefs.setDouble(_fontSizeKey, _fontSizeMultiplier);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving theme settings: $e');
      }
    }
  }

  void changeTheme(HackerThemeMode newTheme) {
    if (_currentTheme != newTheme) {
      _currentTheme = newTheme;
      _saveThemeSettings();
      notifyListeners();
    }
  }

  void toggleGlow() {
    _isGlowEnabled = !_isGlowEnabled;
    _saveThemeSettings();
    notifyListeners();
  }

  void toggleAnimations() {
    _isAnimationsEnabled = !_isAnimationsEnabled;
    _saveThemeSettings();
    notifyListeners();
  }

  void toggleMatrixRain() {
    _isMatrixRainEnabled = !_isMatrixRainEnabled;
    _saveThemeSettings();
    notifyListeners();
  }

  void setFontSizeMultiplier(double multiplier) {
    if (multiplier >= 0.8 && multiplier <= 1.5) {
      _fontSizeMultiplier = multiplier;
      _saveThemeSettings();
      notifyListeners();
    }
  }

  void resetToDefaults() {
    _currentTheme = HackerThemeMode.classic;
    _isGlowEnabled = true;
    _isAnimationsEnabled = true;
    _isMatrixRainEnabled = false;
    _fontSizeMultiplier = 1.0;
    _saveThemeSettings();
    notifyListeners();
  }

  // Theme-specific color getters
  Map<String, dynamic> get currentThemeColors {
    switch (_currentTheme) {
      case HackerThemeMode.classic:
        return {
          'primary': const Color(0xFF00FF41),      // Terminal Green
          'secondary': const Color(0xFF00D97E),    // Matrix Green
          'accent': const Color(0xFF00AA33),       // Border Green
          'background': const Color(0xFF0A0A0A),   // Primary Black
          'surface': const Color(0xFF1A1A1A),      // Carbon Gray
          'text': const Color(0xFFE0E0E0),         // Ghost White
        };
        
      case HackerThemeMode.redHat:
        return {
          'primary': const Color(0xFFFF0040),      // Cyber Red
          'secondary': const Color(0xFFFF4466),    // Light Red
          'accent': const Color(0xFFAA0022),       // Dark Red
          'background': const Color(0xFF0A0A0A),   // Primary Black
          'surface': const Color(0xFF1A1A1A),      // Carbon Gray
          'text': const Color(0xFFE0E0E0),         // Ghost White
        };
        
      case HackerThemeMode.blueTeam:
        return {
          'primary': const Color(0xFF00FFFF),      // Hacker Blue
          'secondary': const Color(0xFF0099CC),    // Light Blue
          'accent': const Color(0xFF006699),       // Dark Blue
          'background': const Color(0xFF0A0A0A),   // Primary Black
          'surface': const Color(0xFF1A1A1A),      // Carbon Gray
          'text': const Color(0xFFE0E0E0),         // Ghost White
        };
        
      case HackerThemeMode.matrix:
        return {
          'primary': const Color(0xFF00FF00),      // Bright Matrix Green
          'secondary': const Color(0xFF00CC00),    // Medium Green
          'accent': const Color(0xFF009900),       // Dark Green
          'background': const Color(0xFF000000),   // Pure Black
          'surface': const Color(0xFF111111),      // Dark Gray
          'text': const Color(0xFF00FF00),         // Green Text
        };
        
      case HackerThemeMode.cyberpunk:
        return {
          'primary': const Color(0xFFFF00FF),      // Magenta
          'secondary': const Color(0xFF00FFFF),    // Cyan
          'accent': const Color(0xFF9900CC),       // Purple
          'background': const Color(0xFF0A0A0A),   // Primary Black
          'surface': const Color(0xFF1A1A1A),      // Carbon Gray
          'text': const Color(0xFFE0E0E0),         // Ghost White
        };
    }
  }

  String get currentThemeName {
    switch (_currentTheme) {
      case HackerThemeMode.classic:
        return 'Classic Hacker';
      case HackerThemeMode.redHat:
        return 'Red Hat';
      case HackerThemeMode.blueTeam:
        return 'Blue Team';
      case HackerThemeMode.matrix:
        return 'Matrix Code';
      case HackerThemeMode.cyberpunk:
        return 'Cyberpunk';
    }
  }

  String get currentThemeDescription {
    switch (_currentTheme) {
      case HackerThemeMode.classic:
        return 'The traditional green-on-black terminal theme';
      case HackerThemeMode.redHat:
        return 'Red team penetration testing theme';
      case HackerThemeMode.blueTeam:
        return 'Blue team defensive security theme';
      case HackerThemeMode.matrix:
        return 'Bright matrix digital rain style';
      case HackerThemeMode.cyberpunk:
        return 'Futuristic neon cyberpunk aesthetic';
    }
  }

  List<String> get availableThemes {
    return HackerThemeMode.values.map((theme) {
      switch (theme) {
        case HackerThemeMode.classic:
          return 'Classic Hacker';
        case HackerThemeMode.redHat:
          return 'Red Hat';
        case HackerThemeMode.blueTeam:
          return 'Blue Team';
        case HackerThemeMode.matrix:
          return 'Matrix Code';
        case HackerThemeMode.cyberpunk:
          return 'Cyberpunk';
      }
    }).toList();
  }

  // Accessibility helpers
  bool get isHighContrast => _currentTheme == HackerThemeMode.matrix;
  bool get isDarkTheme => true; // All themes are dark
  
  double get recommendedFontSize {
    return 14.0 * _fontSizeMultiplier;
  }

  @override
  void dispose() {
    super.dispose();
  }
}