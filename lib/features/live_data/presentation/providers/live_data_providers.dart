import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/live_data_repository_impl.dart';

// Stream Providers for UI consumption
final rpmProvider = StreamProvider.autoDispose<double>((ref) {
  final repo = ref.watch(liveDataRepositoryProvider);
  // Filter out nulls and handle stream lifecycle
  return repo.rpmStream.where((val) => val != null).cast<double>();
});

final speedProvider = StreamProvider.autoDispose<double>((ref) {
  final repo = ref.watch(liveDataRepositoryProvider);
  return repo.speedStream.where((val) => val != null).cast<double>();
});

// Polling Controller
// When the Dashboard is active, we should start polling.
final pollingControllerProvider = Provider.autoDispose((ref) {
  final repo = ref.watch(liveDataRepositoryProvider);
  repo.startPolling();
  ref.onDispose(() => repo.stopPolling());
});
