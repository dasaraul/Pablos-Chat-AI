import 'package:flutter/material.dart';

class AppTheme {
  // Hacker Color Palette
  static const Color primaryBlack = Color(0xFF0A0A0A);
  static const Color secondaryBlack = Color(0xFF1A1A1A);
  static const Color matrixGreen = Color(0xFF00FF41);
  static const Color cyanBlue = Color(0xFF00FFFF);
  static const Color hackerRed = Color(0xFF FF0040);
  static const Color darkGrey = Color(0xFF2A2A2A);
  static const Color lightGrey = Color(0xFF3A3A3A);
  static const Color terminalGreen = Color(0xFF39FF14);
  static const Color ghostWhite = Color(0xFFF8F8F2);

  static ThemeData get darkHackerTheme {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: _createMaterialColor(matrixGreen),
      scaffoldBackgroundColor: primaryBlack,
      fontFamily: 'Courier',
      
      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: secondaryBlack,
        foregroundColor: matrixGreen,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontFamily: 'Courier',
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: matrixGreen,
          letterSpacing: 2,
        ),
        iconTheme: IconThemeData(
          color: matrixGreen,
          size: 24,
        ),
      ),
      
      // Card Theme
      cardTheme: CardTheme(
        color: secondaryBlack,
        elevation: 8,
        shadowColor: matrixGreen.withOpacity(0.3),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(
            color: matrixGreen.withOpacity(0.3),
            width: 1,
          ),
        ),
      ),
      
      // Text Theme
      textTheme: const TextTheme(
        displayLarge: TextStyle(
          fontFamily: 'Courier',
          color: ghostWhite,
          fontSize: 32,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Courier',
          color: matrixGreen,
          fontSize: 24,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Courier',
          color: cyanBlue,
          fontSize: 20,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
        headlineLarge: TextStyle(
          fontFamily: 'Courier',
          color: ghostWhite,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Courier',
          color: matrixGreen,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyLarge: TextStyle(
          fontFamily: 'Courier',
          color: ghostWhite,
          fontSize: 14,
          height: 1.4,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Courier',
          color: ghostWhite,
          fontSize: 12,
          height: 1.3,
        ),
        labelLarge: TextStyle(
          fontFamily: 'Courier',
          color: cyanBlue,
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.5,
        ),
      ),
      
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: secondaryBlack,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: darkGrey,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(
            color: darkGrey,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: matrixGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(
            color: hackerRed,
            width: 1,
          ),
        ),
        hintStyle: TextStyle(
          fontFamily: 'Courier',
          color: lightGrey,
          fontSize: 14,
        ),
        labelStyle: const TextStyle(
          fontFamily: 'Courier',
          color: cyanBlue,
          fontSize: 14,
        ),
      ),
      
      // Elevated Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: matrixGreen,
          foregroundColor: primaryBlack,
          elevation: 4,
          shadowColor: matrixGreen.withOpacity(0.5),
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
      ),
      
      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: cyanBlue,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 8,
          ),
          textStyle: const TextStyle(
            fontFamily: 'Courier',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
        ),
      ),
      
      // Icon Theme
      iconTheme: const IconThemeData(
        color: matrixGreen,
        size: 24,
      ),
      
      // Divider Theme
      dividerTheme: DividerThemeData(
        color: darkGrey,
        thickness: 1,
        indent: 16,
        endIndent: 16,
      ),
      
      // Bottom Navigation Bar Theme
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: secondaryBlack,
        selectedItemColor: matrixGreen,
        unselectedItemColor: lightGrey,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle: TextStyle(
          fontFamily: 'Courier',
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: 'Courier',
          fontSize: 12,
        ),
      ),
      
      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: matrixGreen,
        linearTrackColor: darkGrey,
        circularTrackColor: darkGrey,
      ),
      
      // Slider Theme
      sliderTheme: SliderThemeData(
        activeTrackColor: matrixGreen,
        inactiveTrackColor: darkGrey,
        thumbColor: matrixGreen,
        overlayColor: matrixGreen.withOpacity(0.2),
        valueIndicatorColor: matrixGreen,
        valueIndicatorTextStyle: const TextStyle(
          fontFamily: 'Courier',
          color: primaryBlack,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
      
      // Switch Theme
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return matrixGreen;
          }
          return lightGrey;
        }),
        trackColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return matrixGreen.withOpacity(0.5);
          }
          return darkGrey;
        }),
      ),
      
      // Checkbox Theme
      checkboxTheme: CheckboxThemeData(
        checkColor: MaterialStateProperty.all(primaryBlack),
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return matrixGreen;
          }
          return Colors.transparent;
        }),
        side: const BorderSide(
          color: matrixGreen,
          width: 2,
        ),
      ),
      
      // Radio Theme
      radioTheme: RadioThemeData(
        fillColor: MaterialStateProperty.resolveWith((states) {
          if (states.contains(MaterialState.selected)) {
            return matrixGreen;
          }
          return lightGrey;
        }),
      ),
    );
  }

  // Helper method to create MaterialColor from Color
  static MaterialColor _createMaterialColor(Color color) {
    List strengths = <double>[.05];
    final Map<int, Color> swatch = {};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }
    for (var strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromRGBO(
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
        1,
      );
    }
    return MaterialColor(color.value, swatch);
  }

  // Custom Box Decoration for hacker-style containers
  static BoxDecoration get hackerContainer {
    return BoxDecoration(
      color: secondaryBlack,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(
        color: matrixGreen.withOpacity(0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: matrixGreen.withOpacity(0.1),
          blurRadius: 10,
          spreadRadius: 2,
        ),
      ],
    );
  }

  // Glowing text style for important elements
  static TextStyle get glowingText {
    return const TextStyle(
      fontFamily: 'Courier',
      color: matrixGreen,
      fontSize: 14,
      fontWeight: FontWeight.bold,
      shadows: [
        Shadow(
          color: matrixGreen,
          blurRadius: 10,
        ),
      ],
    );
  }

  // Terminal-style text style
  static TextStyle get terminalText {
    return const TextStyle(
      fontFamily: 'Courier',
      color: terminalGreen,
      fontSize: 12,
      height: 1.2,
      letterSpacing: 0.5,
    );
  }
}