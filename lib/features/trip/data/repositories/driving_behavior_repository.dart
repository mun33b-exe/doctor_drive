import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import '../../../../core/utils/logger.dart';
import '../datasources/sensor_service.dart';
import '../models/trip_model.dart';

// Provider
final drivingBehaviorRepositoryProvider = Provider<DrivingBehaviorRepository>((
  ref,
) {
  return DrivingBehaviorRepositoryImpl(SensorService());
});

abstract class DrivingBehaviorRepository {
  Stream<DrivingEvent> get eventStream;
  Future<void> startTrip();
  Future<void> stopTrip();
}

class DrivingBehaviorRepositoryImpl implements DrivingBehaviorRepository {
  final SensorService _sensorService;

  // Stream controller for outputting detected events
  final _eventController = StreamController<DrivingEvent>.broadcast();

  // Thresholds (simplified for MVP)
  // Hard Braking: Neg Z/Y acceleration > 12 m/s^2 (approx 1.2g)
  // Rapid Accel: Pos Y acceleration > 10 m/s^2
  static const double brakeThreshold = 12.0;
  static const double accelThreshold = 10.0;

  TripModel? _currentTrip;

  DrivingBehaviorRepositoryImpl(this._sensorService);

  @override
  Stream<DrivingEvent> get eventStream => _eventController.stream;

  @override
  Future<void> startTrip() async {
    await _sensorService.initialize();
    _currentTrip = TripModel(
      id: DateTime.now().toIso8601String(),
      startTime: DateTime.now(),
    );

    // Listen to accel stream
    _sensorService.accelerationStream.listen((event) {
      _analyzeAcceleration(event);
    });

    logger.i('Trip started. Monitoring behavior.');
  }

  @override
  Future<void> stopTrip() async {
    _sensorService.stopMonitoring();
    _currentTrip = _currentTrip?.copyWith(endTime: DateTime.now());
    // TODO: Save trip to local DB or Cloud
    logger.i('Trip stopped.');
  }

  void _analyzeAcceleration(UserAccelerometerEvent event) {
    // Simplified logic: Y axis is usually forward/back on phone in mount
    // Dependent on phone orientation. Assuming portrait mount.
    // Z is forward/back? No, usually Y.
    // Let's take magnitude of total acceleration for impact,
    // but for brake/accel we need direction.
    // For MVP, enable "Any Axis > Threshold"

    if (event.y.abs() > brakeThreshold) {
      _detectedEvent('HARD_BRAKE', event.y);
    } else if (event.y > accelThreshold) {
      _detectedEvent('RAPID_ACCEL', event.y);
    }
  }

  void _detectedEvent(String type, double value) {
    // Debounce logic would go here to avoid multiple events per second
    final event = DrivingEvent(
      type: type,
      timestamp: DateTime.now(),
      value: value,
    );
    _eventController.add(event);
    logger.i('Detected $type: $value');
  }
}
