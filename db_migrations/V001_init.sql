-- V001_init.sql
PRAGMA foreign_keys = ON;

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

CREATE TABLE IF NOT EXISTS settings (
  k TEXT PRIMARY KEY,
  v TEXT NOT NULL
);

INSERT OR IGNORE INTO settings(k, v) VALUES
  ('companion_persona', 'buddy_light'),
  ('tone_level', '2'),
  ('intimacy_level', '2'),
  ('reach_freq', 'record_only');

