import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/driving_behavior_repository.dart';
import '../../data/models/trip_model.dart';
import 'dart:async';

// Trip Controller
class TripController extends StateNotifier<bool> {
  final DrivingBehaviorRepository _repository;

  TripController(this._repository)
    : super(false); // false = stopped, true = driving

  Future<void> startTrip() async {
    await _repository.startTrip();
    state = true;
  }

  Future<void> stopTrip() async {
    await _repository.stopTrip();
    state = false;
  }
}

final tripControllerProvider = StateNotifierProvider<TripController, bool>((
  ref,
) {
  return TripController(ref.watch(drivingBehaviorRepositoryProvider));
});

// Event Stream Provider
final drivingEventProvider = StreamProvider.autoDispose<DrivingEvent>((ref) {
  final repo = ref.watch(drivingBehaviorRepositoryProvider);
  return repo.eventStream;
});
