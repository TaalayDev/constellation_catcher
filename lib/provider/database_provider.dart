import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../data/database.dart';

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});
