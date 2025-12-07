// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'trip_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TripModel _$TripModelFromJson(Map<String, dynamic> json) => TripModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] == null
          ? null
          : DateTime.parse(json['endTime'] as String),
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      maxSpeed: (json['maxSpeed'] as num?)?.toDouble() ?? 0.0,
      events: (json['events'] as List<dynamic>?)
              ?.map((e) => DrivingEvent.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );

Map<String, dynamic> _$TripModelToJson(TripModel instance) => <String, dynamic>{
      'id': instance.id,
      'startTime': instance.startTime.toIso8601String(),
      'endTime': instance.endTime?.toIso8601String(),
      'distanceKm': instance.distanceKm,
      'maxSpeed': instance.maxSpeed,
      'events': instance.events,
    };

DrivingEvent _$DrivingEventFromJson(Map<String, dynamic> json) => DrivingEvent(
      type: json['type'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      value: (json['value'] as num).toDouble(),
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DrivingEventToJson(DrivingEvent instance) =>
    <String, dynamic>{
      'type': instance.type,
      'timestamp': instance.timestamp.toIso8601String(),
      'value': instance.value,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
