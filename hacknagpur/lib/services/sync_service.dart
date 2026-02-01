import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:hacknagpur/models/advisory_model.dart';
import 'package:hacknagpur/services/database_service.dart';
import 'package:hacknagpur/services/connectivity_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  
  // Backend API URL - Replace with your actual backend
  static const String apiBaseUrl = 'https://api.krishisetu.com';
  final DatabaseService _db = DatabaseService();
  final ConnectivityService _connectivity = ConnectivityService();

  factory SyncService() {
    return _instance;
  }

  SyncService._internal();

  /// Sync all unsynced advisories to global database
  Future<bool> syncToGlobalDatabase() async {
    try {
      // Check if connected
      if (!await _connectivity.isConnected()) {
        print('⚠️ No internet connection. Sync will retry when online.');
        return false;
      }

      // Get unsynced advisories
      final unsyncedAdvisories = await _db.getUnsyncedAdvisories();
      if (unsyncedAdvisories.isEmpty) {
        print('✅ All advisories are synced');
        return true;
      }

      print('📤 Syncing ${unsyncedAdvisories.length} advisories...');

      // Upload unsynced advisories
      for (var advisory in unsyncedAdvisories) {
        final success = await _uploadAdvisory(advisory);
        if (success) {
          await _db.markAsSynced(advisory.id ?? '');
        }
      }

      // Update last sync time
      await _db.updateLastSyncTime();
      print('✅ Sync completed successfully');
      return true;
    } catch (e) {
      print('❌ Sync error: $e');
      return false;
    }
  }

  /// Download latest advisories from global database
  Future<bool> syncFromGlobalDatabase() async {
    try {
      if (!await _connectivity.isConnected()) {
        print('⚠️ No internet connection. Cannot download latest advisories.');
        return false;
      }

      print('📥 Downloading latest advisories...');

      final response = await http.get(
        Uri.parse('$apiBaseUrl/advisories'),
        headers: {'Content-Type': 'application/json'},
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        for (var item in data) {
          final advisory = Advisory(
            cropId: item['cropId'],
            cropName: item['cropName'],
            advice: item['advice'],
            language: item['language'],
            createdAt: DateTime.parse(item['createdAt']),
            isSynced: true, // Mark downloaded data as synced
          );
          await _db.insertAdvisory(advisory);
        }

        await _db.updateLastSyncTime();
        print('✅ Downloaded ${data.length} advisories');
        return true;
      }
    } catch (e) {
      print('❌ Download error: $e');
    }
    return false;
  }

  /// Upload single advisory to backend
  Future<bool> _uploadAdvisory(Advisory advisory) async {
    try {
      final response = await http.post(
        Uri.parse('$apiBaseUrl/advisories'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(advisory.toJson()),
      ).timeout(const Duration(seconds: 5));

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print('Error uploading advisory: $e');
      return false;
    }
  }

  /// Bi-directional sync (upload + download)
  Future<bool> fullSync() async {
    print('🔄 Starting full sync...');
    
    final uploadSuccess = await syncToGlobalDatabase();
    final downloadSuccess = await syncFromGlobalDatabase();
    
    if (uploadSuccess && downloadSuccess) {
      print('✅ Full sync completed');
      return true;
    }
    return false;
  }

  /// Get pending sync count
  Future<int> getPendingCount() async {
    return await _db.getPendingSyncCount();
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    return await _db.getLastSyncTime();
  }
}
