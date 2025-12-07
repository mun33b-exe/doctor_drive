// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'obd_device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ObdDeviceImpl _$$ObdDeviceImplFromJson(Map<String, dynamic> json) =>
    _$ObdDeviceImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      host: json['host'] as String,
      port: (json['port'] as num).toInt(),
      isLastConnected: json['isLastConnected'] as bool? ?? false,
    );

Map<String, dynamic> _$$ObdDeviceImplToJson(_$ObdDeviceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'host': instance.host,
      'port': instance.port,
      'isLastConnected': instance.isLastConnected,
    };
