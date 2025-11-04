import 'package:sqflite_sqlcipher/sqflite.dart';

class Migrations {
  static Future<void> runMigration(Database db, int version) async {
    switch (version) {
      case 1:
        await _v001(db);
        break;
      default:
        throw Exception('Unknown migration version: $version');
    }
  }
  
  static Future<void> _v001(Database db) async {
    await db.execute('''
      PRAGMA foreign_keys = ON;
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS entries (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        date INTEGER NOT NULL,
        text TEXT,
        mood_score INTEGER,
        tags TEXT,
        media_refs TEXT,
        created_at INTEGER NOT NULL,
        updated_at INTEGER
      );
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS insights (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entry_id INTEGER NOT NULL,
        sentiment TEXT,
        sentiment_strength REAL,
        symptoms TEXT,
        factors TEXT,
        companion_last_triggered_at INTEGER,
        last_scenario_tags TEXT,
        FOREIGN KEY(entry_id) REFERENCES entries(id) ON DELETE CASCADE
      );
    ''');
    
    await db.execute('''
      CREATE TABLE IF NOT EXISTS settings (
        k TEXT PRIMARY KEY,
        v TEXT NOT NULL
      );
    ''');
    
    // Insert default settings
    await db.insert('settings', {'k': 'companion_persona', 'v': 'buddy_light'});
    await db.insert('settings', {'k': 'tone_level', 'v': '2'});
    await db.insert('settings', {'k': 'intimacy_level', 'v': '2'});
    await db.insert('settings', {'k': 'reach_freq', 'v': 'record_only'});
  }
}

