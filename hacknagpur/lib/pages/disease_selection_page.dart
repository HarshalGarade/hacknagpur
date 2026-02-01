import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/models/crop_model.dart';
import 'package:hacknagpur/pages/disease_detail_page.dart';
import 'dart:convert';

/// 🦠 DISEASE SELECTION PAGE - Shows 3 diseases for selected crop
class DiseaseSelectionPage extends StatefulWidget {
  final Crop crop;
  final AppLanguage currentLanguage;
  final Map<String, dynamic> diseaseData;

  const DiseaseSelectionPage({
    super.key,
    required this.crop,
    required this.currentLanguage,
    required this.diseaseData,
  });

  @override
  State<DiseaseSelectionPage> createState() => _DiseaseSelectionPageState();
}

class _DiseaseSelectionPageState extends State<DiseaseSelectionPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  List<Map<String, dynamic>> _diseases = [];

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
    
    _loadDiseases();
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadDiseases() {
    try {
      print('🔍 Loading diseases for crop: ${widget.crop.id}');
      print('🔍 Disease data available: ${widget.diseaseData.isNotEmpty}');
      
      // Try to find the crop in disease data
      Map<String, dynamic>? cropData;
      
      // Check different possible keys (lowercase, exact match, etc.)
      for (var key in widget.diseaseData.keys) {
        print('Available crop keys: $key');
        if (key.toString().toLowerCase() == widget.crop.id.toLowerCase()) {
          cropData = widget.diseaseData[key];
          print('✓ Found crop data for: $key');
          break;
        }
      }
      
      if (cropData != null) {
        final diseasesList = cropData['disease_identification'];
        if (diseasesList is List) {
          setState(() {
            _diseases = List<Map<String, dynamic>>.from(diseasesList);
          });
          print('✓ Loaded ${_diseases.length} diseases for ${widget.crop.id}');
        } else {
          print('❌ disease_identification is not a list');
        }
      } else {
        print('❌ Crop ${widget.crop.id} not found in disease data');
        print('Available crops: ${widget.diseaseData.keys.toList()}');
      }
    } catch (e) {
      print('Error loading diseases: $e');
    }
  }

  String _getText(String key) {
    return LanguageStrings.get(key, widget.currentLanguage);
  }

  String _getLanguageCode() {
    switch (widget.currentLanguage) {
      case AppLanguage.hindi:
        return 'hindi';
      case AppLanguage.marathi:
        return 'marathi';
      default:
        return 'english';
    }
  }

  String _getDiseaseName(Map<String, dynamic> disease) {
    final nameMap = disease['name'] as Map<String, dynamic>?;
    if (nameMap != null) {
      return nameMap[_getLanguageCode()]?.toString() ?? 'Unknown Disease';
    }
    return 'Unknown Disease';
  }

  String _getDiseaseAbout(Map<String, dynamic> disease) {
    final aboutMap = disease['about'] as Map<String, dynamic>?;
    if (aboutMap != null) {
      return aboutMap[_getLanguageCode()]?.toString() ?? 'No information available';
    }
    return 'No information available';
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
            // Header
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
                          'Know Disease',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Select a disease for ${widget.crop.getName(widget.currentLanguage)}',
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

            // Disease Cards
            Expanded(
              child: _diseases.isEmpty
                  ? Center(
                      child: Text(
                        'No diseases found for this crop',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    )
                  : FadeTransition(
                      opacity: _fadeAnimation,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _diseases.length,
                        itemBuilder: (context, index) {
                          final disease = _diseases[index];
                          return _buildDiseaseCard(
                            context,
                            disease,
                            isDark,
                            colorScheme,
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiseaseCard(
    BuildContext context,
    Map<String, dynamic> disease,
    bool isDark,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DiseaseDetailPage(
              crop: widget.crop,
              disease: disease,
              currentLanguage: widget.currentLanguage,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              colorScheme.primary.withOpacity(0.8),
              colorScheme.primary.withOpacity(0.4),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withOpacity(0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.bug_report_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getDiseaseName(disease),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white.withOpacity(0.8),
                    size: 20,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                _getDiseaseAbout(disease),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.white.withOpacity(0.9),
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
