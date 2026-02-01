import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/pages/advisory_mode_selection_page.dart';
import 'package:hacknagpur/pages/manual_crop_entry_page.dart';
import 'package:hacknagpur/services/connectivity_service.dart';
import 'package:hacknagpur/services/sync_service.dart';

/// 📱 DASHBOARD PAGE - Main home screen with navigation
class DashboardPage extends StatefulWidget {
  final VoidCallback onThemeToggle;
  final ThemeMode currentThemeMode;
  final AppLanguage currentLanguage;
  final Function(AppLanguage) onLanguageChange;

  const DashboardPage({
    super.key,
    required this.onThemeToggle,
    required this.currentThemeMode,
    required this.currentLanguage,
    required this.onLanguageChange,
  });

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  bool _isOnline = true;
  final ConnectivityService _connectivity = ConnectivityService();
  final SyncService _sync = SyncService();

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Listen to connectivity changes
    _connectivity.getConnectionStatusStream().listen((isOnline) {
      setState(() {
        _isOnline = isOnline;
      });
      // Auto-sync when connection is restored
      if (isOnline) {
        _showSyncNotification();
      }
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _shimmerController.dispose();
    super.dispose();
  }

  String _getText(String key) {
    return LanguageStrings.get(key, widget.currentLanguage);
  }

  void _showAdvisoryModeSelection() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AdvisoryModeSelectionPage(
          currentLanguage: widget.currentLanguage,
        ),
      ),
    );
  }

  void _navigateToManualCropEntry() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManualCropEntryPage(
          currentLanguage: _getLanguageCode(widget.currentLanguage),
          onLanguageChange: (newLang) {
            final appLangMap = {
              'en': AppLanguage.english,
              'hi': AppLanguage.hindi,
              'mr': AppLanguage.marathi,
            };
            widget.onLanguageChange(appLangMap[newLang] ?? AppLanguage.english);
          },
        ),
      ),
    );
  }

  String _getLanguageCode(AppLanguage lang) {
    switch (lang) {
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.marathi:
        return 'mr';
      default:
        return 'en';
    }
  }

  void _showSyncNotification() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Colors.white)),
            ),
            const SizedBox(width: 12),
            Text('${_getText('syncing')}...'),
          ],
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    _sync.fullSync();
  }

  Future<void> _manualSync() async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_getText('syncing'))),
    );
    final success = await _sync.fullSync();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success ? '✅ ${_getText('sync_complete')}' : '❌ ${_getText('sync_failed')}'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final List<Widget> pages = [
      _buildDashboardPage(context, isDark, colorScheme),
      _buildMyAdvicePage(colorScheme),
      _buildSettingsPage(colorScheme),
    ];

    return Scaffold(
      backgroundColor: colorScheme.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildCompactHeader(context, isDark, colorScheme),
            Expanded(child: pages[_selectedIndex]),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNav(colorScheme, isDark),
    );
  }

  // 🎨 FIXED COMPACT HEADER - FLUSH TO TOP
  Widget _buildCompactHeader(BuildContext context, bool isDark, ColorScheme colorScheme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Connectivity Status Bar
        if (!_isOnline)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.orange.shade700,
              boxShadow: const [BoxShadow(blurRadius: 4, offset: Offset(0, 2))],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cloud_off, color: Colors.white, size: 18),
                const SizedBox(width: 8),
                Text(
                  _getText('offline_mode'),
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        // Main Header
        Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppTheme.darkGradientPrimary : AppTheme.lightGradientPrimary,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text('🌱', style: TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getText('app_name'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  Text(
                    _getText('app_subtitle'),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 10,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
            _buildThemeToggle(isDark),
            const SizedBox(width: 8),
            _buildLanguageButton(context, isDark),
            const SizedBox(width: 8),
            _buildProfileButton(context, isDark, colorScheme),
          ],
        ),
      ),
        ),
      ],
    );
  }

  Widget _buildThemeToggle(bool isDark) {
    return GestureDetector(
      onTap: widget.onThemeToggle,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
          color: isDark ? Colors.amber[300] : Colors.yellow[700],
          size: 18,
        ),
      ),
    );
  }

  Widget _buildLanguageButton(BuildContext context, bool isDark) {
    final languageIcons = {
      AppLanguage.english: 'EN',
      AppLanguage.hindi: 'हिं',
      AppLanguage.marathi: 'मरा',
    };

    return GestureDetector(
      onTap: () => _showLanguageBottomSheet(context, isDark),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.language_rounded, color: Colors.white, size: 16),
            const SizedBox(width: 4),
            Text(
              languageIcons[widget.currentLanguage] ?? 'EN',
              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, bool isDark, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        // Navigate to profile page
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: const Icon(Icons.person_rounded, color: Colors.white, size: 18),
      ),
    );
  }

  void _showLanguageBottomSheet(BuildContext context, bool isDark) {
    final colorScheme = Theme.of(context).colorScheme;
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getText('select_language'),
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildLanguageOption(context, AppLanguage.english, '🇬🇧', _getText('english'), isDark, colorScheme),
                  const SizedBox(height: 12),
                  _buildLanguageOption(context, AppLanguage.hindi, '🇮🇳', _getText('hindi'), isDark, colorScheme),
                  const SizedBox(height: 12),
                  _buildLanguageOption(context, AppLanguage.marathi, '🇮🇳', _getText('marathi'), isDark, colorScheme),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLanguageOption(BuildContext context, AppLanguage language, String flag, String label, bool isDark, ColorScheme colorScheme) {
    final isSelected = widget.currentLanguage == language;
    
    return GestureDetector(
      onTap: () {
        widget.onLanguageChange(language);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? colorScheme.primary.withOpacity(0.15)
              : (isDark ? Colors.white.withOpacity(0.05) : Colors.grey[100]),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isSelected ? colorScheme.primary : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Text(flag, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: colorScheme.onSurface,
                ),
              ),
            ),
            if (isSelected) Icon(Icons.check_circle, color: colorScheme.primary, size: 22),
          ],
        ),
      ),
    );
  }

  // 📱 IMPROVED DASHBOARD PAGE
  Widget _buildDashboardPage(BuildContext context, bool isDark, ColorScheme colorScheme) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeroActionCard(context, isDark, colorScheme),
            const SizedBox(height: 16),
            // Manual Crop Entry Button
            _buildManualCropEntryButton(context, isDark, colorScheme),
            const SizedBox(height: 16),
            _buildInfoCard(isDark, colorScheme),
            const SizedBox(height: 20),
            _buildRecentAdvisoriesCard(isDark, colorScheme),
          ],
        ),
      ),
    );
  }

  Widget _buildManualCropEntryButton(BuildContext context, bool isDark, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _navigateToManualCropEntry,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: isDark 
            ? Colors.blue.shade900.withOpacity(0.3)
            : Colors.blue.shade50,
          border: Border.all(
            color: colorScheme.primary.withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.search,
                  color: colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Manual Crop Search',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Search 30+ crops in your language',
                      style: TextStyle(
                        fontSize: 13,
                        color: colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: colorScheme.primary.withOpacity(0.6),
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeroActionCard(BuildContext context, bool isDark, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: _showAdvisoryModeSelection,
      child: AnimatedBuilder(
        animation: _pulseController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (_pulseController.value * 0.01),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: isDark ? AppTheme.darkGradientButton : AppTheme.lightGradientButton,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withOpacity(0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  AnimatedBuilder(
                    animation: _shimmerController,
                    builder: (context, child) {
                      return Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Transform.translate(
                            offset: Offset(_shimmerController.value * 400 - 200, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.transparent,
                                    Colors.white.withOpacity(0.15),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.0, 0.5, 1.0],
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Text('🌾', style: TextStyle(fontSize: 44)),
                          ),
                          const SizedBox(height: 18),
                          Text(
                            _getText('start_advisory'),
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            _getText('advisory_title'),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.white.withOpacity(0.85),
                              fontWeight: FontWeight.w500,
                              height: 1.3,
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
        },
      ),
    );
  }

  Widget _buildInfoCard(bool isDark, ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildInfoItem(Icons.offline_bolt, _getText('offline_mode'), colorScheme.primary),
          Container(width: 1, height: 36, color: colorScheme.onSurface.withOpacity(0.15)),
          _buildInfoItem(Icons.wifi, _getText('online_mode'), colorScheme.tertiary),
          Container(width: 1, height: 36, color: colorScheme.onSurface.withOpacity(0.15)),
          _buildInfoItem(Icons.language, _getText('multi_lang'), Colors.purple),
        ],
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, Color color) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 22),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 9,
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  // 📜 RECENT ADVISORIES CARD
  Widget _buildRecentAdvisoriesCard(bool isDark, ColorScheme colorScheme) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.primary.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.2 : 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                _getText('recent_advisories'),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          _buildAdvisoryItem('🌾', 'Rice', 'Leaf Blight Detected', '2 days ago', colorScheme, isDark),
          const SizedBox(height: 10),
          _buildAdvisoryItem('🌽', 'Maize', 'Nitrogen Deficiency', '5 days ago', colorScheme, isDark),
          const SizedBox(height: 10),
          _buildAdvisoryItem('🥔', 'Potato', 'Healthy Crop Status', '1 week ago', colorScheme, isDark),
        ],
      ),
    );
  }

  Widget _buildAdvisoryItem(String emoji, String crop, String status, String time, ColorScheme colorScheme, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.05) : Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  crop,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: TextStyle(
              fontSize: 10,
              color: colorScheme.onSurface.withOpacity(0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMyAdvicePage(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('📜', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            _getText('my_advice'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsPage(ColorScheme colorScheme) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('⚙️', style: TextStyle(fontSize: 64)),
          const SizedBox(height: 16),
          Text(
            _getText('settings'),
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }

  // 🧭 FIXED BOTTOM NAVIGATION
  Widget _buildBottomNav(ColorScheme colorScheme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_rounded, 'home', isDark, colorScheme),
              _buildNavItem(1, Icons.history_rounded, 'my_advice', isDark, colorScheme),
              _buildNavItem(2, Icons.settings_rounded, 'settings', isDark, colorScheme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String labelKey, bool isDark, ColorScheme colorScheme) {
    final isSelected = _selectedIndex == index;
    
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? colorScheme.primary.withOpacity(0.12) : Colors.transparent,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? colorScheme.primary : (isDark ? Colors.white54 : Colors.grey[600]),
                size: 24,
              ),
              const SizedBox(height: 4),
              Text(
                _getText(labelKey),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? colorScheme.primary : (isDark ? Colors.white54 : Colors.grey[600]),
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
