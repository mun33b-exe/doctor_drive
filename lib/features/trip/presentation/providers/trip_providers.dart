import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/utils/logger.dart';
import '../../data/repositories/driving_behavior_repository.dart';
import '../../../cloud/data/repositories/cloud_repository.dart';
import '../../data/models/trip_model.dart';
import 'dart:async';

// Trip Controller
class TripController extends StateNotifier<bool> {
  final DrivingBehaviorRepository _repository;
  final CloudRepository _cloudRepository; // Added CloudRepository field

  TripController(this._repository, this._cloudRepository) // Updated constructor
    : super(false); // false = stopped, true = driving

  Future<void> startTrip() async {
    await _repository.startTrip();
    state = true;
  }

  Future<void> stopTrip() async {
    await _repository.stopTrip();
    state = false;

    // In a real app we would get the trip from the repository return value
    // For now, let's create a proxy trip model to demonstrate sync
    // or assume we sync the current session.
    // _cloudRepository.syncTrip(trip);

    // MVP: Just log for now as we don't have the trip object returned yet.
    logger.i('Trip stopped. Syncing to cloud via $_cloudRepository...');
    // _cloudRepository.syncTrip(trip);
  }
}

final tripControllerProvider = StateNotifierProvider<TripController, bool>((
  ref,
) {
  return TripController(
    ref.watch(drivingBehaviorRepositoryProvider),
    CloudRepository(), // Injected CloudRepository
  );
});

// Event Stream Provider
final drivingEventProvider = StreamProvider.autoDispose<DrivingEvent>((ref) {
  final repo = ref.watch(drivingBehaviorRepositoryProvider);
  return repo.eventStream;
});
