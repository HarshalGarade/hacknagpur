import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';

/// 👤 PROFILE PAGE
class ProfilePage extends StatelessWidget {
  final AppLanguage currentLanguage;
  final ThemeMode currentThemeMode;

  const ProfilePage({
    super.key,
    required this.currentLanguage,
    required this.currentThemeMode,
  });

  String _getText(String key) {
    return LanguageStrings.get(key, currentLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: isDark ? AppTheme.darkGradientPrimary : AppTheme.lightGradientPrimary,
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_back_rounded, color: Colors.white, size: 22),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    _getText('profile'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [colorScheme.primary, colorScheme.secondary],
                        ),
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(36),
                        decoration: BoxDecoration(
                          color: isDark ? colorScheme.surface : Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const Text('👨‍🌾', style: TextStyle(fontSize: 56)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _getText('farmer_name'),
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
