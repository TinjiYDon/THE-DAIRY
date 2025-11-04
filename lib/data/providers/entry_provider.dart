import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';
import '../models/entry.dart';

final entriesProvider = FutureProvider<List<Entry>>((ref) async {
  return await AppDatabase.getAllEntries();
});

final entryProvider = FutureProvider.family<Entry?, int>((ref, id) async {
  return await AppDatabase.getEntryById(id);
});

final entryNotifierProvider = StateNotifierProvider<EntryNotifier, AsyncValue<List<Entry>>>((ref) {
  return EntryNotifier(ref);
});

class EntryNotifier extends StateNotifier<AsyncValue<List<Entry>>> {
  final Ref _ref;
  
  EntryNotifier(this._ref) : super(const AsyncValue.loading()) {
    _loadEntries();
  }
  
  Future<void> _loadEntries() async {
    try {
      final entries = await AppDatabase.getAllEntries();
      state = AsyncValue.data(entries);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
  
  Future<void> addEntry(Entry entry) async {
    await AppDatabase.insertEntry(entry);
    _loadEntries();
  }
  
  Future<void> updateEntry(Entry entry) async {
    await AppDatabase.updateEntry(entry);
    _loadEntries();
  }
  
  Future<void> deleteEntry(int id) async {
    await AppDatabase.deleteEntry(id);
    _loadEntries();
  }
  
  void refresh() {
    _loadEntries();
  }
}

