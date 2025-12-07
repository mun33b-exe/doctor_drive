import 'dart:async';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:geolocator/geolocator.dart';
import '../../../../core/utils/logger.dart';

class SensorService {
  StreamSubscription? _accelSubscription;
  StreamSubscription? _gyroSubscription;
  StreamSubscription? _positionSubscription;

  // Broadcast streams for filtered data
  final _accelController = StreamController<UserAccelerometerEvent>.broadcast();
  final _positionController = StreamController<Position>.broadcast();

  Stream<UserAccelerometerEvent> get accelerationStream =>
      _accelController.stream;
  Stream<Position> get positionStream => _positionController.stream;

  Future<void> initialize() async {
    // Request permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        logger.w('Location permissions are denied');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      logger.w('Location permissions are permanently denied');
      return;
    }

    startMonitoring();
  }

  void startMonitoring() {
    _accelSubscription =
        userAccelerometerEventStream(
          samplingPeriod: SensorInterval.gameInterval,
        ).listen(
          (event) {
            _accelController.add(event);
          },
          onError: (e) {
            logger.e('Accelerometer error', error: e);
          },
        );

    // Configure location settings
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,
    );

    _positionSubscription =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position? position) {
            if (position != null) {
              _positionController.add(position);
            }
          },
          onError: (e) {
            logger.e('Location stream error', error: e);
          },
        );

    logger.i('Sensor monitoring started');
  }

  void stopMonitoring() {
    _accelSubscription?.cancel();
    _gyroSubscription?.cancel();
    _positionSubscription?.cancel();
    logger.i('Sensor monitoring stopped');
  }
}
