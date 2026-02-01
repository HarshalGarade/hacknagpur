import 'package:flutter/material.dart';
import 'package:hacknagpur/config/language.dart';
import 'package:hacknagpur/config/theme.dart';
import 'package:hacknagpur/models/crop_model.dart';

/// 🔬 DISEASE DETAIL PAGE - Shows cause, symptoms, prevention, chemical control
class DiseaseDetailPage extends StatefulWidget {
  final Crop crop;
  final Map<String, dynamic> disease;
  final AppLanguage currentLanguage;

  const DiseaseDetailPage({
    super.key,
    required this.crop,
    required this.disease,
    required this.currentLanguage,
  });

  @override
  State<DiseaseDetailPage> createState() => _DiseaseDetailPageState();
}

class _DiseaseDetailPageState extends State<DiseaseDetailPage> with SingleTickerProviderStateMixin {
  late AnimationController _scrollController;
  late ScrollController _scrollView;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _scrollView = ScrollController();
    _scrollController.forward();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _scrollView.dispose();
    super.dispose();
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

  String _getTextFromMap(Map<String, dynamic>? map, String defaultText) {
    if (map == null) return defaultText;
    return map[_getLanguageCode()]?.toString() ?? defaultText;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;

    final diseaseName = _getDiseaseName(widget.disease);
    final about = _getTextFromMap(widget.disease['about'] as Map<String, dynamic>?, 'No information');
    final cause = _getTextFromMap(widget.disease['cause'] as Map<String, dynamic>?, 'No information');
    final symptoms = _getTextFromMap(widget.disease['symptoms'] as Map<String, dynamic>?, 'No information');
    final prevention = _getTextFromMap(widget.disease['prevention'] as Map<String, dynamic>?, 'No information');
    
    final chemicalControl = widget.disease['chemical_control'] as Map<String, dynamic>?;
    final chemicalName = chemicalControl?['chemical_name']?.toString() ?? 'N/A';
    final quantity = chemicalControl?['quantity']?.toString() ?? 'N/A';
    final applicationMethod = _getTextFromMap(
      chemicalControl?['application_method'] as Map<String, dynamic>?,
      'No information',
    );

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
                    child: Text(
                      diseaseName,
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

            // Content
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollView,
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Crop Name & Disease Name
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: colorScheme.primary.withOpacity(0.3),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                'Crop: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Text(
                                widget.crop.getName(widget.currentLanguage),
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onBackground,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Text(
                                'Disease: ',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: colorScheme.primary,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  diseaseName,
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // About
                    _buildSection(
                      context,
                      'About the Disease',
                      about,
                      Icons.info_rounded,
                      Colors.blue,
                    ),

                    const SizedBox(height: 16),

                    // Cause
                    _buildSection(
                      context,
                      'Cause',
                      cause,
                      Icons.warning_rounded,
                      Colors.orange,
                    ),

                    const SizedBox(height: 16),

                    // Symptoms
                    _buildSection(
                      context,
                      'Symptoms',
                      symptoms,
                      Icons.visibility_rounded,
                      Colors.red,
                    ),

                    const SizedBox(height: 16),

                    // Prevention
                    _buildSection(
                      context,
                      'Prevention',
                      prevention,
                      Icons.shield_rounded,
                      Colors.green,
                    ),

                    const SizedBox(height: 16),

                    // Chemical Control
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.amber.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.amber.withOpacity(0.3),
                        ),
                      ),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.amber,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(
                                  Icons.science_rounded,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  'Chemical Control',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onBackground,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildChemicalDetail('Chemical Name', chemicalName),
                          const SizedBox(height: 10),
                          _buildChemicalDetail('Dosage/Quantity', quantity),
                          const SizedBox(height: 10),
                          _buildChemicalDetail('Application Method', applicationMethod),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    IconData icon,
    Color color,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onBackground,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: TextStyle(
              fontSize: 13,
              color: colorScheme.onBackground.withOpacity(0.8),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChemicalDetail(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.onBackground,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
