import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/obd_device.dart';

class DeviceRepository {
  final SharedPreferences _prefs;
  static const String _keyDevices = 'saved_obd_devices';

  DeviceRepository(this._prefs);

  List<ObdDevice> getSavedDevices() {
    final jsonString = _prefs.getString(_keyDevices);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList.map((e) => ObdDevice.fromJson(e)).toList();
  }

  Future<void> saveDevice(ObdDevice device) async {
    final devices = getSavedDevices();

    // Check if exists, update if so
    final index = devices.indexWhere(
      (d) => d.host == device.host && d.port == device.port,
    );
    if (index != -1) {
      devices[index] = device;
    } else {
      devices.add(device);
    }

    await _saveList(devices);
  }

  Future<void> removeDevice(String id) async {
    final devices = getSavedDevices();
    devices.removeWhere((d) => d.id == id);
    await _saveList(devices);
  }

  Future<void> setLastConnected(String id) async {
    final devices = getSavedDevices();
    final updated = devices
        .map((d) => d.copyWith(isLastConnected: d.id == id))
        .toList();
    await _saveList(updated);
  }

  Future<void> _saveList(List<ObdDevice> devices) async {
    final jsonString = jsonEncode(devices.map((e) => e.toJson()).toList());
    await _prefs.setString(_keyDevices, jsonString);
  }
}
