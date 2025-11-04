import 'dart:io';
import 'package:sqflite_sqlcipher/sqflite.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/entry.dart';
import '../models/insight.dart';
import '../models/settings.dart';
import 'migrations.dart';

class AppDatabase {
  static const _dbName = 'the_dairy.db';
  static const _dbVersion = 1;
  
  static Database? _database;
  static const _storage = FlutterSecureStorage();
  
  static Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }
  
  static Future<Database> _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(documentsDirectory.path, _dbName);
    
    // Get or generate encryption key
    String? key = await _storage.read(key: 'db_encryption_key');
    if (key == null) {
      // Generate a random key (in production, use proper key derivation)
      key = DateTime.now().millisecondsSinceEpoch.toString();
      await _storage.write(key: 'db_encryption_key', value: key);
    }
    
    return await openDatabase(
      dbPath,
      version: _dbVersion,
      password: key,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }
  
  static Future<void> _onCreate(Database db, int version) async {
    await Migrations.runMigration(db, 1);
  }
  
  static Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    for (int v = oldVersion + 1; v <= newVersion; v++) {
      await Migrations.runMigration(db, v);
    }
  }
  
  // Entry CRUD
  static Future<int> insertEntry(Entry entry) async {
    final db = await database;
    final map = entry.toDbMap();
    map.remove('id'); // Let SQLite auto-generate
    return await db.insert('entries', map);
  }
  
  static Future<List<Entry>> getAllEntries() async {
    final db = await database;
    final maps = await db.query('entries', orderBy: 'date DESC');
    return maps.map((map) => EntryExtension.fromDbMap(map)).toList();
  }
  
  static Future<Entry?> getEntryById(int id) async {
    final db = await database;
    final maps = await db.query('entries', where: 'id = ?', whereArgs: [id]);
    if (maps.isEmpty) return null;
    return EntryExtension.fromDbMap(maps.first);
  }
  
  static Future<int> updateEntry(Entry entry) async {
    final db = await database;
    final map = entry.toDbMap();
    map['updated_at'] = DateTime.now().millisecondsSinceEpoch;
    return await db.update('entries', map, where: 'id = ?', whereArgs: [entry.id]);
  }
  
  static Future<int> deleteEntry(int id) async {
    final db = await database;
    return await db.delete('entries', where: 'id = ?', whereArgs: [id]);
  }
  
  // Insight CRUD
  static Future<int> insertInsight(Insight insight) async {
    final db = await database;
    final map = insight.toDbMap();
    map.remove('id');
    return await db.insert('insights', map);
  }
  
  static Future<Insight?> getInsightByEntryId(int entryId) async {
    final db = await database;
    final maps = await db.query('insights', where: 'entry_id = ?', whereArgs: [entryId]);
    if (maps.isEmpty) return null;
    return InsightExtension.fromDbMap(maps.first);
  }
  
  // Settings
  static Future<void> saveSettings(AppSettings settings) async {
    final db = await database;
    final map = settings.toDbMap();
    for (final entry in map.entries) {
      await db.insert(
        'settings',
        {'k': entry.key, 'v': entry.value},
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
  }
  
  static Future<AppSettings> getSettings() async {
    final db = await database;
    final maps = await db.query('settings');
    final settingsMap = <String, String>{};
    for (final map in maps) {
      settingsMap[map['k'] as String] = map['v'] as String;
    }
    return AppSettingsExtension.fromDbMap(settingsMap);
  }
  
  static Future<void> close() async {
    final db = _database;
    if (db != null) {
      await db.close();
      _database = null;
    }
  }
}

