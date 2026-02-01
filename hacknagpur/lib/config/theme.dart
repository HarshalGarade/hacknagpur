import 'package:flutter/material.dart';

/// 🎨 THEME CONFIGURATION
/// Centralized theme definitions for light and dark modes with gradients
class AppTheme {
  static final lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF2E7D32),
      secondary: Color(0xFF4CAF50),
      tertiary: Color(0xFF1E88E5),
      surface: Colors.white,
      background: Color(0xFFF5F9F5),
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF1B5E20),
      onBackground: Color(0xFF1B5E20),
    ),
    scaffoldBackgroundColor: const Color(0xFFF5F9F5),
    cardColor: Colors.white,
    fontFamily: 'Roboto',
  );

  static final darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF66BB6A),
      secondary: Color(0xFF4DB6AC),
      tertiary: Color(0xFF42A5F5),
      surface: Color(0xFF1A1A1A),
      background: Color(0xFF0F1F14),
      onPrimary: Color(0xFFE8F5E9),
      onSecondary: Color(0xFFE0F2F1),
      onSurface: Color(0xFFE8F5E9),
      onBackground: Color(0xFFE8F5E9),
    ),
    scaffoldBackgroundColor: const Color(0xFF0F1F14),
    cardColor: const Color(0xFF1A1A1A),
    fontFamily: 'Roboto',
  );

  // Light Theme Gradients
  static const lightGradientPrimary = LinearGradient(
    colors: [Color(0xFF1B5E20), Color(0xFF2E7D32), Color(0xFF4CAF50)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const lightGradientButton = LinearGradient(
    colors: [Color(0xFF43A047), Color(0xFF66BB6A), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Dark Theme Gradients
  static const darkGradientPrimary = LinearGradient(
    colors: [Color(0xFF1B3A1E), Color(0xFF2D5F33), Color(0xFF3E7D44)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const darkGradientButton = LinearGradient(
    colors: [Color(0xFF4CAF50), Color(0xFF66BB6A), Color(0xFF81C784)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
