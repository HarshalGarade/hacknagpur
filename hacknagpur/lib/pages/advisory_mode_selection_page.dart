import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/pages/offline_crop_selection_page.dart';
import 'package:hacknagpur/pages/online_photo_selection_page.dart';
import 'package:hacknagpur/pages/ai_crop_detection_page.dart';

/// 🎯 ADVISORY MODE SELECTION PAGE
class AdvisoryModeSelectionPage extends StatefulWidget {
  final AppLanguage currentLanguage;

  const AdvisoryModeSelectionPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  State<AdvisoryModeSelectionPage> createState() => _AdvisoryModeSelectionPageState();
}

class _AdvisoryModeSelectionPageState extends State<AdvisoryModeSelectionPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getText(String key) {
    return LanguageStrings.get(key, widget.currentLanguage);
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
                  Expanded(
                    child: Text(
                      _getText('advisory_title'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                      _buildModeCard(
                        context,
                        isDark,
                        colorScheme,
                        icon: Icons.touch_app,
                        title: _getText('select_manually'),
                        subtitle: _getText('select_manually_subtitle'),
                        description: _getText('select_crop'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OfflineCropSelectionPage(
                                currentLanguage: widget.currentLanguage,
                              ),
                            ),
                          );
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFF66BB6A), Color(0xFF4CAF50), Color(0xFF388E3C)],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildModeCard(
                        context,
                        isDark,
                        colorScheme,
                        icon: Icons.camera_alt,
                        title: _getText('take_photo_mode'),
                        subtitle: _getText('take_photo_subtitle'),
                        description: _getText('smart_detection'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OnlinePhotoSelectionPage(
                                currentLanguage: widget.currentLanguage,
                              ),
                            ),
                          );
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFF42A5F5), Color(0xFF1E88E5), Color(0xFF1565C0)],
                        ),
                      ),
                      const SizedBox(height: 20),
                      _buildModeCard(
                        context,
                        isDark,
                        colorScheme,
                        icon: Icons.smart_toy,
                        title: 'AI Crop Detection',
                        subtitle: 'Detect crop with AI',
                        description: 'Take photo & detect crop automatically',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AICropDetectionPage(
                                currentLanguage: widget.currentLanguage,
                              ),
                            ),
                          );
                        },
                        gradient: const LinearGradient(
                          colors: [Color(0xFFAB47BC), Color(0xFF8E24AA), Color(0xFF6A1B9A)],
                        ),
                      ),
                    ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModeCard(
    BuildContext context,
    bool isDark,
    ColorScheme colorScheme, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
    required LinearGradient gradient,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: gradient,
          boxShadow: [
            BoxShadow(
              color: gradient.colors[1].withOpacity(0.35),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.25),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.9),
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
