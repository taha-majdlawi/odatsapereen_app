import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFFF7F7F7),
      cardColor: Colors.white,
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: fontSize, color: Colors.black87),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }

  static ThemeData darkTheme(double fontSize) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.deepPurple,
      scaffoldBackgroundColor: const Color(0xFF121212),
      cardColor: const Color(0xFF1E1E1E),
      textTheme: TextTheme(
        bodyLarge: TextStyle(fontSize: fontSize, color: Colors.white70),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
    );
  }
}
