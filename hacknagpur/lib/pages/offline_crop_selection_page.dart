import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/models/crop_model.dart';
import 'package:hacknagpur/pages/disease_selection_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// 🌾 OFFLINE CROP SELECTION PAGE (WITH MULTILINGUAL SUPPORT)
class OfflineCropSelectionPage extends StatefulWidget {
  final AppLanguage currentLanguage;

  const OfflineCropSelectionPage({
    super.key,
    required this.currentLanguage,
  });

  @override
  State<OfflineCropSelectionPage> createState() => _OfflineCropSelectionPageState();
}

class _OfflineCropSelectionPageState extends State<OfflineCropSelectionPage> {
  String? _selectedCropId;
  Map<String, dynamic> _diseaseData = {};

  String _getText(String key) {
    return LanguageStrings.get(key, widget.currentLanguage);
  }

  @override
  void initState() {
    super.initState();
    _loadDiseaseData();
  }

  void _loadDiseaseData() async {
    try {
      final response = await http.get(
        Uri.parse('http://localhost:5000/api/v1/disease/all'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData is Map<String, dynamic> && jsonData.containsKey('disease_data')) {
          setState(() {
            _diseaseData = jsonData['disease_data'];
          });
          print('✓ Disease data loaded: ${_diseaseData.keys.length} crops');
        }
      } else {
        print('Error loading disease data: ${response.statusCode}');
      }
    } catch (e) {
      print('Error loading disease data: $e');
    }
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _getText('select_crop'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          _getText('tap_crop'),
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(16),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 0.85,
                ),
                itemCount: CropData.crops.length,
                itemBuilder: (context, index) {
                  final crop = CropData.crops[index];
                  final isSelected = _selectedCropId == crop.id;
                  
                  return _buildCropCard(crop, isSelected, isDark, colorScheme);
                },
              ),
            ),
            // KNOW DISEASE BUTTON
            if (_selectedCropId != null)
              Container(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                decoration: BoxDecoration(
                  color: isDark ? colorScheme.surface : Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              CropData.crops.firstWhere((c) => c.id == _selectedCropId).icon,
                              color: colorScheme.primary,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${_getText('crop_selected')}: ${CropData.crops.firstWhere((c) => c.id == _selectedCropId).getName(widget.currentLanguage)}',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      GestureDetector(
                        onTap: () {
                          final selectedCrop = CropData.crops.firstWhere((c) => c.id == _selectedCropId);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DiseaseSelectionPage(
                                crop: selectedCrop,
                                currentLanguage: widget.currentLanguage,
                                diseaseData: _diseaseData,
                              ),
                            ),
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            gradient: isDark ? AppTheme.darkGradientButton : AppTheme.lightGradientButton,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: colorScheme.primary.withOpacity(0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.bug_report_rounded, color: Colors.white, size: 22),
                              const SizedBox(width: 10),
                              const Text(
                                'Know Disease',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
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

  Widget _buildCropCard(Crop crop, bool isSelected, bool isDark, ColorScheme colorScheme) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedCropId = crop.id;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: isSelected
              ? crop.color.withOpacity(0.2)
              : (isDark ? colorScheme.surface : Colors.white),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? crop.color : (isDark ? Colors.white.withOpacity(0.1) : Colors.grey[300]!),
            width: isSelected ? 2.5 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: crop.color.withOpacity(0.35),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: crop.color.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                crop.icon,
                color: crop.color,
                size: 28,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                crop.getName(widget.currentLanguage),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                  color: isSelected ? crop.color : colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
            ),
            if (isSelected) ...[
              const SizedBox(height: 4),
              Icon(Icons.check_circle, color: crop.color, size: 14),
            ],
          ],
        ),
      ),
    );
  }
}
