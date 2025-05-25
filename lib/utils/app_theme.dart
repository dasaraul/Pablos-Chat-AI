import 'package:flutter/material.dart';

class AppTheme {
  // Blackhat Hacker Color Palette
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color terminalGreen = Color(0xFF00FF41);
  static const Color matrixGreen = Color(0xFF00D97E);
  static const Color darkGreen = Color(0xFF003300);
  static const Color cyberRed = Color(0xFF FF0040);
  static const Color hackerBlue = Color(0xFF00FFFF);
  static const Color ghostWhite = Color(0xFFE0E0E0);
  static const Color carbonGray = Color(0xFF1A1A1A);
  static const Color deepGray = Color(0xFF2A2A2A);
  static const Color borderGreen = Color(0xFF00AA33);

  // Original PABLOS Colors (kept for reference)
  static const Color darkNavy = Color(0xFF333446);
  static const Color slateBlue = Color(0xFF7F8CAA);
  static const Color softTeal = Color(0xFFB8CFCE);
  static const Color offWhite = Color(0xFFEAEFEF);

  static ThemeData get darkHackerTheme {
    return ThemeData(
      primarySwatch: Colors.green,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: primaryBlack,
      
      // App Bar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: carbonGray,
        foregroundColor: terminalGreen,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'FiraCode',
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: terminalGreen,
        ),
        iconTheme: IconThemeData(color: terminalGreen),
      ),

      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'FiraCode',
          color: terminalGreen,
          fontWeight: FontWeight.bold,
        ),
        displayMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: terminalGreen,
          fontWeight: FontWeight.bold,
        ),
        displaySmall: TextStyle(
          fontFamily: 'FiraCode',
          color: terminalGreen,
          fontWeight: FontWeight.w600,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'FiraCode',
          color: matrixGreen,
          fontWeight: FontWeight.bold,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: matrixGreen,
          fontWeight: FontWeight.w600,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'FiraCode',
          color: matrixGreen,
        ),
        titleLarge: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
          fontWeight: FontWeight.w600,
        ),
        titleMedium: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
        ),
        titleSmall: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
          fontSize: 14,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
          fontSize: 16,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontFamily: 'JetBrainsMono',
          color: ghostWhite,
          fontSize: 12,
        ),
        labelLarge: TextStyle(
          fontFamily: 'FiraCode',
          color: terminalGreen,
          fontWeight: FontWeight.bold,
        ),
        labelMedium: TextStyle(
          fontFamily: 'FiraCode',
          color: terminalGreen,
        ),
        labelSmall: TextStyle(
          fontFamily: 'FiraCode',
          color: matrixGreen,
          fontSize: 10,
        ),
      ),

      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: carbonGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGreen, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: borderGreen, width: 1),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: terminalGreen, width: 2),
        ),
        hintStyle: const TextStyle(
          color: matrixGreen,
          fontFamily: 'JetBrainsMono',
        ),
        labelStyle: const TextStyle(
          color: terminalGreen,
          fontFamily: 'FiraCode',
        ),
      ),

      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: darkGreen,
          foregroundColor: terminalGreen,
          shadowColor: terminalGreen.withOpacity(0.3),
          elevation: 8,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: const BorderSide(color: borderGreen, width: 1),
          ),
          textStyle: const TextStyle(
            fontFamily: 'FiraCode',
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),

      // Card Theme
      cardTheme: CardTheme(
        color: carbonGray,
        shadowColor: terminalGreen.withOpacity(0.2),
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGreen, width: 0.5),
        ),
      ),

      // Icon Theme
      iconTheme: const IconThemeData(
        color: terminalGreen,
        size: 24,
      ),

      // Floating Action Button Theme
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: darkGreen,
        foregroundColor: terminalGreen,
        elevation: 8,
        shape: CircleBorder(
          side: BorderSide(color: borderGreen, width: 2),
        ),
      ),

      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: carbonGray,
        selectedItemColor: terminalGreen,
        unselectedItemColor: matrixGreen,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
      ),

      // Divider Theme
      dividerTheme: const DividerThemeData(
        color: borderGreen,
        thickness: 0.5,
      ),

      // Chip Theme
      chipTheme: ChipThemeData(
        backgroundColor: darkGreen,
        labelStyle: const TextStyle(
          color: terminalGreen,
          fontFamily: 'FiraCode',
          fontSize: 12,
        ),
        side: const BorderSide(color: borderGreen, width: 1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),

      // Dialog Theme
      dialogTheme: DialogTheme(
        backgroundColor: carbonGray,
        titleTextStyle: const TextStyle(
          color: terminalGreen,
          fontFamily: 'FiraCode',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        contentTextStyle: const TextStyle(
          color: ghostWhite,
          fontFamily: 'JetBrainsMono',
          fontSize: 14,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: borderGreen, width: 1),
        ),
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: terminalGreen,
        linearTrackColor: deepGray,
        circularTrackColor: deepGray,
      ),

      // Color Scheme
      colorScheme: const ColorScheme.dark(
        primary: terminalGreen,
        secondary: matrixGreen,
        surface: carbonGray,
        background: primaryBlack,
        error: cyberRed,
        onPrimary: primaryBlack,
        onSecondary: primaryBlack,
        onSurface: ghostWhite,
        onBackground: ghostWhite,
        onError: ghostWhite,
        brightness: Brightness.dark,
      ),
    );
  }

  // Custom Gradient Decorations
  static BoxDecoration get terminalGradient {
    return const BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          primaryBlack,
          carbonGray,
          primaryBlack,
        ],
        stops: [0.0, 0.5, 1.0],
      ),
    );
  }

  static BoxDecoration get hackerBorder {
    return BoxDecoration(
      color: carbonGray,
      border: Border.all(color: borderGreen, width: 1),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: terminalGreen.withOpacity(0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  static BoxDecoration get glowEffect {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: terminalGreen.withOpacity(0.3),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    );
  }
}