import 'package:http/http.dart' as http;
import 'dart:convert';

class DiseaseService {
  static const String baseUrl = 'http://localhost:5000';

  /// Fetch disease data from backend
  static Future<Map<String, dynamic>> getDiseaseData() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/disease/all'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print('✅ Disease data loaded from backend');
        // Extract disease_data from response
        if (data['disease_data'] != null) {
          return Map<String, dynamic>.from(data['disease_data']);
        }
        return data;
      } else {
        throw Exception('Failed to load disease data: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading disease data: $e');
      return {};
    }
  }

  /// Get diseases for a specific crop
  static Future<List<Map<String, dynamic>>> getDiseasesForCrop(String cropId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/disease/crop/$cropId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        }
        return [];
      } else {
        throw Exception('Failed to load diseases: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading diseases for crop: $e');
      return [];
    }
  }

  /// Get disease details
  static Future<Map<String, dynamic>> getDiseaseDetail(
    String cropId,
    String diseaseId,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/v1/disease/$cropId/$diseaseId'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw Exception('Request timeout'),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to load disease detail: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading disease detail: $e');
      return {};
    }
  }
}
