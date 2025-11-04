import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../db/database.dart';

final databaseProvider = Provider<Future<Database>>((ref) async {
  return await AppDatabase.database;
});

