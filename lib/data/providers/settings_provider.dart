import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../models/settings.dart';

final settingsProvider = FutureProvider<AppSettings>((ref) async {
  return await AppDatabase.getSettings();
});

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AsyncValue<AppSettings>>((ref) {
  return SettingsNotifier(ref);
});

class SettingsNotifier extends StateNotifier<AsyncValue<AppSettings>> {
  final Ref _ref;
  
  SettingsNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadSettings();
  }
  
  Future<void> _loadSettings() async {
    try {
      final settings = await AppDatabase.getSettings();
      state = AsyncValue.data(settings);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> updateSettings(AppSettings settings) async {
    await AppDatabase.saveSettings(settings);
    _loadSettings();
  }
  
  void refresh() {
    _loadSettings();
  }
}

