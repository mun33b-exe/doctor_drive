import 'package:json_annotation/json_annotation.dart';

part 'trip_model.g.dart';

@JsonSerializable()
class TripModel {
  final String id;
  final DateTime startTime;
  final DateTime? endTime;
  final double distanceKm;
  final double maxSpeed;
  final List<DrivingEvent> events;

  TripModel({
    required this.id,
    required this.startTime,
    this.endTime,
    this.distanceKm = 0.0,
    this.maxSpeed = 0.0,
    this.events = const [],
  });

  factory TripModel.fromJson(Map<String, dynamic> json) =>
      _$TripModelFromJson(json);
  Map<String, dynamic> toJson() => _$TripModelToJson(this);

  TripModel copyWith({
    DateTime? endTime,
    double? distanceKm,
    double? maxSpeed,
    List<DrivingEvent>? events,
  }) {
    return TripModel(
      id: id,
      startTime: startTime,
      endTime: endTime ?? this.endTime,
      distanceKm: distanceKm ?? this.distanceKm,
      maxSpeed: maxSpeed ?? this.maxSpeed,
      events: events ?? this.events,
    );
  }
}

@JsonSerializable()
class DrivingEvent {
  final String type; // 'HARD_BRAKE', 'RAPID_ACCEL', 'SPEEDING'
  final DateTime timestamp;
  final double value; // g-force or speed
  final double latitude;
  final double longitude;

  DrivingEvent({
    required this.type,
    required this.timestamp,
    required this.value,
    this.latitude = 0.0,
    this.longitude = 0.0,
  });

  factory DrivingEvent.fromJson(Map<String, dynamic> json) =>
      _$DrivingEventFromJson(json);
  Map<String, dynamic> toJson() => _$DrivingEventToJson(this);
}
