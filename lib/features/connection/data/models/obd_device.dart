import 'package:freezed_annotation/freezed_annotation.dart';

part 'obd_device.freezed.dart';
part 'obd_device.g.dart';

@freezed
class ObdDevice with _$ObdDevice {
  const factory ObdDevice({
    required String id,
    required String name, // e.g., "My WiFi Dongle", "Scanner 1"
    required String host,
    required int port,
    @Default(false) bool isLastConnected,
  }) = _ObdDevice;

  factory ObdDevice.fromJson(Map<String, dynamic> json) =>
      _$ObdDeviceFromJson(json);
}
