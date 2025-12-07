// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dtc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DtcModel _$DtcModelFromJson(Map<String, dynamic> json) => DtcModel(
      code: json['code'] as String,
      description: json['description'] as String,
      system: json['system'] as String? ?? 'Unknown',
      severity: json['severity'] as String? ?? 'Unknown',
    );

Map<String, dynamic> _$DtcModelToJson(DtcModel instance) => <String, dynamic>{
      'code': instance.code,
      'description': instance.description,
      'system': instance.system,
      'severity': instance.severity,
    };
