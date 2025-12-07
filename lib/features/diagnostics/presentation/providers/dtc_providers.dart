import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/dtc_repository_impl.dart';
import '../../data/models/dtc_model.dart';

// Fetch Stored Codes Provider
final storedDtcProvider = FutureProvider.autoDispose<List<DtcModel>>((
  ref,
) async {
  final repo = ref.watch(dtcRepositoryProvider);
  return repo.getStoredDtcs();
});

// Access Full Database Provider
final dtcDatabaseProvider = FutureProvider<List<DtcModel>>((ref) async {
  final repo = ref.watch(dtcRepositoryProvider);
  return repo.getAllDtcsFromDatabase();
});

// Clear Codes Controller
final clearDtcProvider = FutureProvider.autoDispose<void>((ref) async {
  final repo = ref.watch(dtcRepositoryProvider);
  await repo.clearDtcs();
});
