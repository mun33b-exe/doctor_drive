import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/obd_device.dart';
import '../../data/repositories/device_repository.dart';

// Needs to be overridden in main.dart with initialized prefs
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError();
});

final deviceRepositoryProvider = Provider<DeviceRepository>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return DeviceRepository(prefs);
});

final savedDevicesProvider =
    StateNotifierProvider<SavedDevicesNotifier, List<ObdDevice>>((ref) {
      return SavedDevicesNotifier(ref.watch(deviceRepositoryProvider));
    });

class SavedDevicesNotifier extends StateNotifier<List<ObdDevice>> {
  final DeviceRepository _repository;

  SavedDevicesNotifier(this._repository) : super([]) {
    _load();
  }

  void _load() {
    state = _repository.getSavedDevices();
  }

  Future<void> addDevice(String name, String host, int port) async {
    final device = ObdDevice(
      id: const Uuid().v4(),
      name: name,
      host: host,
      port: port,
    );
    await _repository.saveDevice(device);
    _load();
  }

  Future<void> deleteDevice(String id) async {
    await _repository.removeDevice(id);
    _load();
  }

  Future<void> markConnected(String id) async {
    await _repository.setLastConnected(id);
    _load();
  }
}
