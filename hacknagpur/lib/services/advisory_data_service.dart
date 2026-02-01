import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hacknagpur/models/advisory_detail_model.dart';
import 'package:hacknagpur/models/advisory_model.dart';
import './database_service.dart';

class AdvisoryDataService {
  static final AdvisoryDataService _instance = AdvisoryDataService._internal();
  
  // Backend API configuration
  // Use both localhost and network IP - try localhost first, then fall back to network
  final String apiBaseUrl = 'http://localhost:5000';
  final String apiBaseUrlNetwork = 'http://192.168.1.37:5000';
  
  // Cache for advisory data
  Map<String, dynamic>? _englishData;
  Map<String, dynamic>? _hindiData;
  Map<String, dynamic>? _marathiData;
  
  // Database service for offline storage
  final DatabaseService _dbService = DatabaseService();

  factory AdvisoryDataService() {
    return _instance;
  }

  AdvisoryDataService._internal();

  /// Category mappings for different languages
  static const Map<String, Map<String, String>> categoryMappings = {
    'english': {
      // Watering category
      'watering': 'watering',
      'water': 'watering',
      'waters': 'watering',
      'irrigation': 'watering',
      // Fertilizer category
      'fertilizer': 'fertilizer',
      'fertilizers': 'fertilizer',
      'nutrients': 'fertilizer',
      'manure': 'fertilizer',
      'khad': 'fertilizer',
      // Growth category
      'growth': 'growth',
      'growth_stages': 'growth',
      'stages': 'growth',
      'development': 'growth',
      'vikas': 'growth',
      // Storage category
      'storage': 'storage_life_months',
      'storage_life': 'storage_life_months',
      'storage_life_months': 'storage_life_months',
      'shelf_life': 'storage_life_months',
    },
    'hindi': {
      // Watering category - पानी_प्रबंधन
      'watering': 'पानी_प्रबंधन',
      'water': 'पानी_प्रबंधन',
      'waters': 'पानी_प्रबंधन',
      'irrigation': 'पानी_प्रबंधन',
      'पानी': 'पानी_प्रबंधन',
      'पानी_प्रबंधन': 'पानी_प्रबंधन',
      'सिंचाई': 'पानी_प्रबंधन',
      // Fertilizer category - खाद_प्रबंधन
      'fertilizer': 'खाद_प्रबंधन',
      'fertilizers': 'खाद_प्रबंधन',
      'nutrients': 'खाद_प्रबंधन',
      'manure': 'खाद_प्रबंधन',
      'खाद': 'खाद_प्रबंधन',
      'खाद_प्रबंधन': 'खाद_प्रबंधन',
      'खत': 'खाद_प्रबंधन',
      'पोषक': 'खाद_प्रबंधन',
      // Growth category - विकास_चरण
      'growth': 'विकास_चरण',
      'growth_stages': 'विकास_चरण',
      'stages': 'विकास_चरण',
      'development': 'विकास_चरण',
      'विकास': 'विकास_चरण',
      'विकास_चरण': 'विकास_चरण',
      'चरण': 'विकास_चरण',
      // Storage category - भंडारण_आयु_महीने
      'storage': 'भंडारण_आयु_महीने',
      'storage_life': 'भंडारण_आयु_महीने',
      'storage_life_months': 'भंडारण_आयु_महीने',
      'shelf_life': 'भंडारण_आयु_महीने',
      'भंडारण': 'भंडारण_आयु_महीने',
      'भंडारण_आयु_महीने': 'भंडारण_आयु_महीने',
      'आयु': 'भंडारण_आयु_महीने',
    },
    'marathi': {
      // Watering category - पाणी_व्यवस्थापन
      'watering': 'पाणी_व्यवस्थापन',
      'water': 'पाणी_व्यवस्थापन',
      'waters': 'पाणी_व्यवस्थापन',
      'irrigation': 'पाणी_व्यवस्थापन',
      'पाणी': 'पाणी_व्यवस्थापन',
      'पाणी_व्यवस्थापन': 'पाणी_व्यवस्थापन',
      'सिंचन': 'पाणी_व्यवस्थापन',
      // Fertilizer category - खत_व्यवस्थापन
      'fertilizer': 'खत_व्यवस्थापन',
      'fertilizers': 'खत_व्यवस्थापन',
      'nutrients': 'खत_व्यवस्थापन',
      'manure': 'खत_व्यवस्थापन',
      'खत': 'खत_व्यवस्थापन',
      'खत_व्यवस्थापन': 'खत_व्यवस्थापन',
      'पोषक': 'खत_व्यवस्थापन',
      // Growth category - विकास_चरण
      'growth': 'विकास_चरण',
      'growth_stages': 'विकास_चरण',
      'stages': 'विकास_चरण',
      'development': 'विकास_चरण',
      'विकास': 'विकास_चरण',
      'विकास_चरण': 'विकास_चरण',
      'टप्पे': 'विकास_चरण',
      // Storage category - साठवणुकीचा_कालावधी_महिने
      'storage': 'साठवणुकीचा_कालावधी_महिने',
      'storage_life': 'साठवणुकीचा_कालावधी_महिने',
      'storage_life_months': 'साठवणुकीचा_कालावधी_महिने',
      'shelf_life': 'साठवणुकीचा_कालावधी_महिने',
      'साठवण': 'साठवणुकीचा_कालावधी_महिने',
      'साठवणुकीचा_कालावधी_महिने': 'साठवणुकीचा_कालावधी_महिने',
      'कालावधी': 'साठवणुकीचा_कालावधी_महिने',
    },
  };

  /// Initialize - Load data from backend
  Future<void> initialize() async {
    try {
      await _preloadAllData();
    } catch (e) {
      print('❌ Error initializing advisory data: $e');
    }
  }

  /// Preload all advisory data from backend for offline storage
  Future<void> _preloadAllData() async {
    try {
      // Fetch all advisories from backend
      final response = await http.get(
        Uri.parse('$apiBaseUrl/api/v1/advisories/all'),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          print('⚠️ Backend timeout - using cached data only');
          throw Exception('Backend timeout');
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        // Store in database for offline access
        if (data['advisories'] != null) {
          for (final advisory in data['advisories']) {
            await _dbService.insertAdvisory(
              Advisory(
                cropId: advisory['crop'] ?? '',
                cropName: advisory['crop'] ?? '',
                advice: advisory['advisory'] ?? '',
                language: advisory['language'] ?? 'en',
                createdAt: DateTime.now(),
                isSynced: true,
              ),
            );
          }
          print('✅ Preloaded ${data['advisories'].length} advisories to local database');
        }
      }
    } catch (e) {
      print('⚠️ Could not preload data from backend: $e - Will fetch on demand');
    }
  }

  /// Get available crops for a language
  Future<AvailableCrops> getAvailableCrops(String language) async {
    try {
      // This would call your backend API to get crop list
      // For now, return sample crops
      final List<String> sampleCrops = [
        'rice',
        'wheat',
        'maize',
        'cotton',
        'sugarcane',
      ];

      return AvailableCrops(
        language: language,
        crops: sampleCrops,
        categories: {
          for (var crop in sampleCrops) crop: ['watering', 'fertilizer', 'growth'],
        },
      );
    } catch (e) {
      print('❌ Error fetching available crops: $e');
      rethrow;
    }
  }

  /// Fetch crop advisory for specific crop, category, and language
  /// RULES: Only return data that exists in the source files
  Future<String?> fetchAdvisory({
    required String cropName,
    required String category,
    required String language,
  }) async {
    try {
      // Normalize crop name for matching
      final normalizedCrop = _normalizeCropName(cropName, language);

      print('🔍 Fetching advisory for: $normalizedCrop [$category] in $language');

      // Try to get from backend first (online mode)
      try {
        final advisoryText = await _fetchFromBackend(
          normalizedCrop,
          category,  // Send category directly - backend handles all mapping
          language,
        );
        
        if (advisoryText != null && advisoryText.isNotEmpty) {
          print('✅ Advisory fetched from backend successfully');
          
          // Try to cache locally, but don't fail if DB is not available
          try {
            await _dbService.insertAdvisory(
              Advisory(
                cropId: normalizedCrop,
                cropName: normalizedCrop,
                advice: advisoryText,
                language: language,
                createdAt: DateTime.now(),
                isSynced: true,
              ),
            );
            print('✅ Advisory cached locally');
          } catch (dbError) {
            print('⚠️ Could not cache to database: $dbError (continuing with online data)');
          }
          
          return advisoryText;
        }
      } catch (e) {
        print('⚠️ Backend fetch error: $e - Trying local cache');
      }

      // Fallback to local database (offline mode)
      final cached = await _getFromLocalDatabase(
        normalizedCrop,
        category,
        language,
      );
      
      if (cached != null) {
        print('✅ Advisory retrieved from local cache');
        return cached;
      }

      print('❌ Advisory not found');
      return null;
    } catch (e) {
      print('❌ Error fetching advisory: $e');
      return null;
    }
  }

  /// Map category to the correct key based on language
  String? _mapCategory(String category, String language) {
    return categoryMappings[language]?[category.toLowerCase()];
  }

  /// Normalize crop name (handle case-insensitive matching)
  String _normalizeCropName(String cropName, String language) {
    if (language == 'english') {
      return cropName.toLowerCase();
    } else if (language == 'hindi' || language == 'marathi') {
      return cropName; // Keep original case for Indian languages
    }
    return cropName;
  }

  /// Fetch advisory from backend API
  Future<String?> _fetchFromBackend(
    String cropName,
    String category,
    String language,
  ) async {
    try {
      // Try to fetch from backend API
      String? advisory = await _tryFetchFromUrl(apiBaseUrl, cropName, category, language);
      
      // If localhost fails, try network IP
      if (advisory == null) {
        print('⚠️ Localhost failed, trying network IP...');
        advisory = await _tryFetchFromUrl(apiBaseUrlNetwork, cropName, category, language);
      }
      
      return advisory;
    } catch (e) {
      print('❌ Backend fetch failed: $e');
      return null;
    }
  }

  /// Try to fetch from a specific URL
  Future<String?> _tryFetchFromUrl(
    String baseUrl,
    String cropName,
    String category,
    String language,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          '$baseUrl/api/v1/advisories/fetch?crop=$cropName&category=$category&language=$language',
        ),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['advisory'] != null && data['advisory'].isNotEmpty) {
          print('✅ Advisory fetched from $baseUrl');
          return data['advisory'];
        }
      } else if (response.statusCode == 404) {
        print('⚠️ Advisory not found on backend: HTTP 404');
      }
    } catch (e) {
      print('⚠️ Failed to reach $baseUrl: $e');
    }
    return null;
  }

  /// Get advisory from local SQLite database
  Future<String?> _getFromLocalDatabase(
    String cropName,
    String category,
    String language,
  ) async {
    try {
      // Query from database
      final db = await _dbService.database;
      final result = await db.query(
        'advisories',
        where: 'crop_name = ? AND category = ? AND language = ?',
        whereArgs: [cropName, category, language],
        limit: 1,
      );

      if (result.isNotEmpty) {
        return result.first['advisory_text'] as String?;
      }
      return null;
    } catch (e) {
      print('❌ Error querying local database: $e');
      return null;
    }
  }

  /// Search advisories by keyword
  Future<List<CropAdvisory>> searchAdvisories({
    required String keyword,
    required String language,
  }) async {
    // This would search through cached advisories
    // For now, return empty list
    return [];
  }

  /// Get all cached advisories
  Future<List<CropAdvisory>> getAllCachedAdvisories() async {
    // Query from database
    return [];
  }

  /// Clear advisory cache
  Future<void> clearCache() async {
    _englishData = null;
    _hindiData = null;
    _marathiData = null;
  }
}
