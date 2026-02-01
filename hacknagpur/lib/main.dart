import 'package:flutter/material.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/models/crop_model.dart';
import 'package:hacknagpur/pages/dashboard_page.dart';

void main() {
  runApp(const MyApp());
}

/// 🌾 MAIN APP CLASS
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.light;
  AppLanguage _currentLanguage = AppLanguage.english;

  void _toggleTheme() {
    setState(() {
      _themeMode = _themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  void _changeLanguage(AppLanguage language) {
    setState(() {
      _currentLanguage = language;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KrishiSetu',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: _themeMode,
      home: DashboardPage(
        onThemeToggle: _toggleTheme,
        currentThemeMode: _themeMode,
        currentLanguage: _currentLanguage,
        onLanguageChange: _changeLanguage,
      ),
    );
  }
}
