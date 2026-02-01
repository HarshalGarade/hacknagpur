import 'package:flutter/material.dart';
import '../config/language.dart';
import '../models/crop_model.dart';

class AdvisoryDetailPage extends StatefulWidget {
  final Crop crop;
  final String category;
  final String advisoryText;
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const AdvisoryDetailPage({
    Key? key,
    required this.crop,
    required this.category,
    required this.advisoryText,
    required this.currentLanguage,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  State<AdvisoryDetailPage> createState() => _AdvisoryDetailPageState();
}

class _AdvisoryDetailPageState extends State<AdvisoryDetailPage> {
  @override
  void initState() {
    super.initState();
  }

  String _getCropName() {
    final appLang = _getAppLanguage(widget.currentLanguage);
    return widget.crop.getName(appLang);
  }

  AppLanguage _getAppLanguage(String lang) {
    switch (lang) {
      case 'hi':
        return AppLanguage.hindi;
      case 'mr':
        return AppLanguage.marathi;
      default:
        return AppLanguage.english;
    }
  }

  String _getCategoryLabel(String category) {
    switch (widget.currentLanguage) {
      case 'hi':
        return category == 'watering'
            ? 'पानी प्रबंधन'
            : category == 'fertilizer'
                ? 'उर्वरक'
                : 'वृद्धि';
      case 'mr':
        return category == 'watering'
            ? 'वाटेबाजी'
            : category == 'fertilizer'
                ? 'सुपीक'
                : 'वाढ';
      default:
        return category.toUpperCase();
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'watering':
        return Colors.blue;
      case 'fertilizer':
        return Colors.green;
      case 'growth':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'watering':
        return Icons.water_drop;
      case 'fertilizer':
        return Icons.spa;
      case 'growth':
        return Icons.eco;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final categoryColor = _getCategoryColor(widget.category);
    final categoryIcon = _getCategoryIcon(widget.category);
    final categoryLabel = _getCategoryLabel(widget.category);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.category.replaceAll('_', ' ').toUpperCase(),
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: categoryColor,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            onSelected: (language) {
              widget.onLanguageChange(language);
              setState(() {});
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 'en',
                child: Text('EN - English'),
              ),
              const PopupMenuItem(
                value: 'hi',
                child: Text('HI - हिंदी'),
              ),
              const PopupMenuItem(
                value: 'mr',
                child: Text('MR - मराठी'),
              ),
            ],
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                widget.currentLanguage.toUpperCase(),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Category Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: categoryColor.withOpacity(0.1),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(categoryIcon, color: categoryColor, size: 32),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              categoryLabel,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: categoryColor,
                              ),
                            ),
                            Text(
                              _getCropName(),
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: categoryColor.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.cloud_done, color: categoryColor, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Offline Available',
                          style: TextStyle(
                            color: categoryColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Advisory Content
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.currentLanguage == 'en'
                        ? 'Advisory Information'
                        : widget.currentLanguage == 'hi'
                            ? 'सलाह जानकारी'
                            : 'सल्ल्याद माहिती',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: categoryColor.withOpacity(0.3)),
                      borderRadius: BorderRadius.circular(8),
                      color: categoryColor.withOpacity(0.05),
                    ),
                    child: Text(
                      widget.advisoryText,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.6,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Tips Section
                  Text(
                    widget.currentLanguage == 'en'
                        ? 'Quick Tips'
                        : widget.currentLanguage == 'hi'
                            ? 'त्वरित सुझाव'
                            : 'द्रुत टिप्स',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    icon: Icons.check_circle,
                    title: widget.currentLanguage == 'en'
                        ? 'Best Time'
                        : widget.currentLanguage == 'hi'
                            ? 'सर्वश्रेष्ठ समय'
                            : 'सर्वोत्तम वेळ',
                    description: widget.currentLanguage == 'en'
                        ? 'Apply during early morning or late evening'
                        : widget.currentLanguage == 'hi'
                            ? 'सुबह जल्दी या शाम को देर से लागू करें'
                            : 'सकाळी लवकर किंवा संध्याकाळी लागू करा',
                    color: categoryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    icon: Icons.info,
                    title: widget.currentLanguage == 'en'
                        ? 'Frequency'
                        : widget.currentLanguage == 'hi'
                            ? 'आवृत्ति'
                            : 'वारंवारता',
                    description: widget.currentLanguage == 'en'
                        ? 'Follow the recommended schedule for best results'
                        : widget.currentLanguage == 'hi'
                            ? 'सर्वोत्तम परिणामों के लिए अनुशंसित समय सारणी का पालन करें'
                            : 'सर्वोत्तम परिणामांसाठी शिफारस केलेल्या वेळापत्रकाचे अनुसरण करा',
                    color: categoryColor,
                  ),
                  const SizedBox(height: 12),
                  _buildTipCard(
                    icon: Icons.warning,
                    title: widget.currentLanguage == 'en'
                        ? 'Precautions'
                        : widget.currentLanguage == 'hi'
                            ? 'सावधानियां'
                            : 'खबरदारी',
                    description: widget.currentLanguage == 'en'
                        ? 'Wear protective gear while handling'
                        : widget.currentLanguage == 'hi'
                            ? 'संभालते समय सुरक्षात्मक गियर पहनें'
                            : 'हाताळताना सुरक्षा गियर घा',
                    color: categoryColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTipCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: color.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(8),
        color: color.withOpacity(0.05),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.black87,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
