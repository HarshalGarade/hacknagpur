import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:hacknagpur/models/advisory_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  static Database? _database;

  factory DatabaseService() {
    return _instance;
  }

  DatabaseService._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), 'krishisetu.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _createTables,
    );
  }

  Future<void> _createTables(Database db, int version) async {
    // Advisories table
    await db.execute('''
      CREATE TABLE advisories(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        cropId TEXT NOT NULL,
        cropName TEXT NOT NULL,
        advice TEXT NOT NULL,
        language TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        updatedAt TEXT,
        isSynced INTEGER NOT NULL DEFAULT 0,
        UNIQUE(cropId, language)
      )
    ''');

    // Sync metadata table
    await db.execute('''
      CREATE TABLE sync_metadata(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        lastSyncTime TEXT,
        pendingCount INTEGER DEFAULT 0
      )
    ''');

    // User preferences table
    await db.execute('''
      CREATE TABLE user_preferences(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        key TEXT UNIQUE NOT NULL,
        value TEXT NOT NULL
      )
    ''');
  }

  // ============ ADVISORY OPERATIONS ============

  /// Insert or update an advisory
  Future<int> insertAdvisory(Advisory advisory) async {
    final db = await database;
    return await db.insert(
      'advisories',
      advisory.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get advisory by crop ID
  Future<Advisory?> getAdvisory(String cropId, String language) async {
    final db = await database;
    final result = await db.query(
      'advisories',
      where: 'cropId = ? AND language = ?',
      whereArgs: [cropId, language],
    );
    return result.isNotEmpty ? Advisory.fromMap(result.first) : null;
  }

  /// Get all advisories
  Future<List<Advisory>> getAllAdvisories() async {
    final db = await database;
    final result = await db.query('advisories');
    return result.map((map) => Advisory.fromMap(map)).toList();
  }

  /// Get unsynced advisories (for syncing to global DB)
  Future<List<Advisory>> getUnsyncedAdvisories() async {
    final db = await database;
    final result = await db.query(
      'advisories',
      where: 'isSynced = 0',
    );
    return result.map((map) => Advisory.fromMap(map)).toList();
  }

  /// Mark advisory as synced
  Future<void> markAsSynced(String id) async {
    final db = await database;
    await db.update(
      'advisories',
      {'isSynced': 1, 'updatedAt': DateTime.now().toIso8601String()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  /// Delete advisory
  Future<void> deleteAdvisory(String id) async {
    final db = await database;
    await db.delete(
      'advisories',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ============ SYNC METADATA OPERATIONS ============

  /// Update last sync time
  Future<void> updateLastSyncTime() async {
    final db = await database;
    await db.update(
      'sync_metadata',
      {'lastSyncTime': DateTime.now().toIso8601String()},
      where: 'id = 1',
    );
  }

  /// Get last sync time
  Future<DateTime?> getLastSyncTime() async {
    final db = await database;
    final result = await db.query('sync_metadata', where: 'id = 1');
    if (result.isNotEmpty && result.first['lastSyncTime'] != null) {
      return DateTime.parse(result.first['lastSyncTime'] as String);
    }
    return null;
  }

  /// Get count of pending syncs
  Future<int> getPendingSyncCount() async {
    final db = await database;
    final result = await db.rawQuery('SELECT COUNT(*) as count FROM advisories WHERE isSynced = 0');
    return result.first['count'] as int;
  }

  // ============ USER PREFERENCES OPERATIONS ============

  /// Save preference
  Future<void> setPreference(String key, String value) async {
    final db = await database;
    await db.insert(
      'user_preferences',
      {'key': key, 'value': value},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// Get preference
  Future<String?> getPreference(String key) async {
    final db = await database;
    final result = await db.query(
      'user_preferences',
      where: 'key = ?',
      whereArgs: [key],
    );
    return result.isNotEmpty ? result.first['value'] as String : null;
  }

  // ============ MAINTENANCE ============

  /// Clear all data (for testing or user reset)
  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('advisories');
    await db.delete('user_preferences');
  }

  /// Close database
  Future<void> closeDatabase() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
