import 'package:flutter/material.dart';
import '../config/language.dart';
import '../models/crop_model.dart';
import './crop_advisory_page.dart';

class ManualCropEntryPage extends StatefulWidget {
  final String currentLanguage;
  final Function(String) onLanguageChange;

  const ManualCropEntryPage({
    Key? key,
    required this.currentLanguage,
    required this.onLanguageChange,
  }) : super(key: key);

  @override
  State<ManualCropEntryPage> createState() => _ManualCropEntryPageState();
}

class _ManualCropEntryPageState extends State<ManualCropEntryPage> {
  late TextEditingController _searchController;
  List<Crop> _filteredCrops = [];
  List<Crop> _allCrops = CropData.crops;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _filteredCrops = _allCrops;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterCrops(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCrops = _allCrops;
      } else {
        final appLang = _getAppLanguage(widget.currentLanguage);
        _filteredCrops = _allCrops
            .where((crop) =>
                crop.getName(appLang).toLowerCase().contains(query.toLowerCase()) ||
                crop.id.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _selectCrop(Crop crop) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CropAdvisoryPage(
          crop: crop,
          currentLanguage: widget.currentLanguage,
          onLanguageChange: widget.onLanguageChange,
        ),
      ),
    );
  }

  String _getCropName(Crop crop) {
    final appLang = _getAppLanguage(widget.currentLanguage);
    return crop.getName(appLang);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(LanguageConfig.getTranslation('manual_crop_search', widget.currentLanguage)),
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
      body: Column(
        children: [
          // Search Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              onChanged: _filterCrops,
              decoration: InputDecoration(
                hintText: LanguageConfig.getTranslation('search_crop', widget.currentLanguage),
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
          ),
          // Crops List
          Expanded(
            child: _filteredCrops.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 48,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          LanguageConfig.getTranslation('crop_not_found', widget.currentLanguage),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredCrops.length,
                    itemBuilder: (context, index) {
                      final crop = _filteredCrops[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: Icon(crop.icon, color: crop.color, size: 32),
                          title: Text(
                            _getCropName(crop),
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            crop.id,
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => _selectCrop(crop),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
