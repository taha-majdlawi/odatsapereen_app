import 'package:flutter/material.dart';

class AppTheme {
  // اللون الفيراني الفاتح
  static const Color fayraniLight = Color(0xFF6B7280);

  // اللون الأبيض السكري
  static const Color sugarWhite = Color(0xFFFDFCF7);

  static ThemeData lightTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: fayraniLight,
      scaffoldBackgroundColor: sugarWhite,
      cardColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: fayraniLight,
        secondary: fayraniLight.withOpacity(0.8),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: fontSize,
          color: const Color(0xFF2C2C2C),
          height: 1.6,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: fayraniLight,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: fayraniLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  static ThemeData darkTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: fayraniLight,
      scaffoldBackgroundColor: const Color(0xFF1C1C1C),
      cardColor: const Color(0xFF262626),
      colorScheme: ColorScheme.dark(
        primary: fayraniLight,
        secondary: fayraniLight.withOpacity(0.8),
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(
          fontSize: fontSize,
          color: Colors.white70,
          height: 1.6,
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: fayraniLight,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: fayraniLight,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }
}
