import 'package:json_annotation/json_annotation.dart';

part 'dtc_model.g.dart';

@JsonSerializable()
class DtcModel {
  final String code;
  final String description;
  final String system; // e.g., Powertrain, Chassis
  final String severity; // High, Medium, Low

  const DtcModel({
    required this.code,
    required this.description,
    this.system = 'Unknown',
    this.severity = 'Unknown',
  });

  factory DtcModel.fromJson(Map<String, dynamic> json) =>
      _$DtcModelFromJson(json);
  Map<String, dynamic> toJson() => _$DtcModelToJson(this);
}
