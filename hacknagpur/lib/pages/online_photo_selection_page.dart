import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';

/// 📸 ONLINE PHOTO SELECTION PAGE (WITH PROPER IMAGE HANDLING)
class OnlinePhotoSelectionPage extends StatefulWidget {
  final AppLanguage currentLanguage;

  const OnlinePhotoSelectionPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  State<OnlinePhotoSelectionPage> createState() => _OnlinePhotoSelectionPageState();
}

class _OnlinePhotoSelectionPageState extends State<OnlinePhotoSelectionPage> {
  final ImagePicker _picker = ImagePicker();
  Uint8List? _selectedImageBytes;
  String? _selectedImagePath;
  bool _isLoading = false;

  String _getText(String key) {
    return LanguageStrings.get(key, widget.currentLanguage);
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      setState(() {
        _isLoading = true;
      });

      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        final bytes = await pickedFile.readAsBytes();
        setState(() {
          _selectedImageBytes = bytes;
          _selectedImagePath = pickedFile.path;
          _isLoading = false;
        });
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImageBytes = null;
      _selectedImagePath = null;
    });
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
                      _getText('upload_photo'),
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
              child: _isLoading
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(color: colorScheme.primary),
                          const SizedBox(height: 16),
                          Text(
                            _getText('select_image'),
                            style: TextStyle(color: colorScheme.onSurface),
                          ),
                        ],
                      ),
                    )
                  : _selectedImageBytes != null
                      ? _buildImagePreview(isDark, colorScheme)
                      : _buildPhotoOptions(isDark, colorScheme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImagePreview(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(18),
                child: Image.memory(
                  _selectedImageBytes!,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.error_outline, size: 48, color: Colors.red),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  icon: Icons.close,
                  label: _getText('retake'),
                  color: Colors.red,
                  onTap: _clearImage,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: _buildActionButton(
                  icon: Icons.check_circle,
                  label: _getText('analyze'),
                  color: colorScheme.primary,
                  onTap: () {
                    // Analyze image
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoOptions(bool isDark, ColorScheme colorScheme) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildPhotoOptionCard(
            isDark: isDark,
            colorScheme: colorScheme,
            icon: Icons.camera_alt,
            title: _getText('take_photo'),
            subtitle: _getText('camera'),
            color: const Color(0xFF1E88E5),
            onTap: () => _pickImage(ImageSource.camera),
          ),
          const SizedBox(height: 18),
          _buildPhotoOptionCard(
            isDark: isDark,
            colorScheme: colorScheme,
            icon: Icons.photo_library,
            title: _getText('upload_photo'),
            subtitle: _getText('from_gallery'),
            color: const Color(0xFF43A047),
            onTap: () => _pickImage(ImageSource.gallery),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoOptionCard({
    required bool isDark,
    required ColorScheme colorScheme,
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: isDark ? colorScheme.surface : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: color.withOpacity(0.3), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.15),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: color, size: 32),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 18),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.35),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
