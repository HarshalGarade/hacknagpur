import 'package:flutter/material.dart';
import '../config/language.dart';
import '../models/crop_model.dart';
import '../services/advisory_data_service.dart';
import './advisory_detail_page.dart';

class CropAdvisoryPage extends StatefulWidget {
  final Crop crop;
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const CropAdvisoryPage({
    Key? key,
    required this.crop,
    required this.currentLanguage,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  State<CropAdvisoryPage> createState() => _CropAdvisoryPageState();
}

class _CropAdvisoryPageState extends State<CropAdvisoryPage> {
  final AdvisoryDataService _advisoryService = AdvisoryDataService();
  bool _isLoading = false;

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

  Future<void> _fetchAndNavigateToAdvisory(String category) async {
    setState(() => _isLoading = true);

    try {
      print('🔄 Fetching advisory for crop: ${widget.crop.id}, category: $category, lang: ${widget.currentLanguage}');
      
      final advisory = await _advisoryService.fetchAdvisory(
        cropName: widget.crop.id,
        category: _getCategoryCode(category),
        language: _getLanguageCode(widget.currentLanguage),
      );

      print('📝 Advisory received: ${advisory?.substring(0, 50)}...');

      if (mounted) {
        if (advisory == null || advisory.isEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('No advisory data found for this crop and category'),
              backgroundColor: Colors.orange,
            ),
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => AdvisoryDetailPage(
                crop: widget.crop,
                category: category,
                advisoryText: advisory,
                currentLanguage: widget.currentLanguage,
                onLanguageChange: widget.onLanguageChange,
              ),
            ),
          );
        }
      }
    } catch (e) {
      print('❌ Error fetching advisory: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error fetching advisory: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getLanguageCode(String lang) {
    switch (lang) {
      case 'hi':
        return 'hindi';
      case 'mr':
        return 'marathi';
      default:
        return 'english';
    }
  }

  String _getCategoryCode(String category) {
    switch (category) {
      case 'watering':
        return 'watering';
      case 'fertilizer':
        return 'fertilizer';
      case 'growth':
        return 'growth';
      case 'storage':
        return 'storage';  // Send 'storage' - service will map to 'storage_life_months'
      default:
        return category;
    }
  }

  String _getCategoryLabel(String category) {
    switch (widget.currentLanguage) {
      case 'hi':
        return category == 'watering'
            ? 'पानी प्रबंधन'
            : category == 'fertilizer'
                ? 'उर्वरक'
                : category == 'growth'
                    ? 'वृद्धि'
                    : 'भंडारण';
      case 'mr':
        return category == 'watering'
            ? 'पाणी व्यवस्थापन'
            : category == 'fertilizer'
                ? 'खते'
                : category == 'growth'
                    ? 'वाढ'
                    : 'साठवण';
      default:
        return category == 'watering'
            ? 'Water Advisory'
            : category == 'fertilizer'
                ? 'Fertilizer Advisory'
                : category == 'growth'
                    ? 'Growth Advisory'
                    : 'Storage Advisory';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getCropName()),
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Crop Icon & Name
              Center(
                child: Column(
                  children: [
                    Icon(widget.crop.icon, size: 72, color: widget.crop.color),
                    const SizedBox(height: 16),
                    Text(
                      _getCropName(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (widget.currentLanguage == 'en')
                      Text(
                        widget.crop.id,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              // Advisory Categories
              Text(
                LanguageConfig.getTranslation('select_advisory', widget.currentLanguage),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              // Water Advisory Button
              _buildAdvisoryButton(
                icon: Icons.water_drop,
                category: 'watering',
                label: _getCategoryLabel('watering'),
                color: Colors.blue,
              ),
              const SizedBox(height: 16),
              // Fertilizer Advisory Button
              _buildAdvisoryButton(
                icon: Icons.eco,
                category: 'fertilizer',
                label: _getCategoryLabel('fertilizer'),
                color: Colors.green,
              ),
              const SizedBox(height: 16),
              // Growth Advisory Button
              _buildAdvisoryButton(
                icon: Icons.grass,
                category: 'growth',
                label: _getCategoryLabel('growth'),
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              // Storage Advisory Button
              _buildAdvisoryButton(
                icon: Icons.storage,
                category: 'storage',
                label: _getCategoryLabel('storage'),
                color: Colors.brown,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAdvisoryButton({
    required IconData icon,
    required String category,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: _isLoading ? null : () => _fetchAndNavigateToAdvisory(category),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withOpacity(0.1),
        foregroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: color, width: 2),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (_isLoading)
            const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          else
            const Icon(Icons.arrow_forward_ios, size: 18),
        ],
      ),
    );
  }
}
