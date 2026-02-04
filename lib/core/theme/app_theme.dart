import 'package:flutter/material.dart';

class AppTheme {
  static const Color primary = Color(0xFFC8A27A);
  static const Color secondary = Color(0xFF8B5E3C);
  static const Color background = Color(0xFFFAF6F1);
  static const Color surface = Color(0xFFEFE3D3);
  static const Color textPrimary = Color(0xFF3E2C23);
  static const Color textSecondary = Color(0xFF6F4E37);

  static ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: background,

    colorScheme: ColorScheme.light(
      primary: primary,
      secondary: secondary,
      background: background,
      surface: surface,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onBackground: textPrimary,
      onSurface: textPrimary,
    ),

    textTheme: const TextTheme(
      headlineLarge: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.bold,
        color: textPrimary,
      ),
      headlineMedium: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      ),
      bodyLarge: TextStyle(fontSize: 16, color: textSecondary),
      bodyMedium: TextStyle(fontSize: 14, color: textSecondary),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primary, width: 2),
      ),
      labelStyle: const TextStyle(color: textSecondary),
    ),
  );
}
