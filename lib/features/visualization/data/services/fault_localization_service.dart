import '../../../diagnostics/data/models/dtc_model.dart';

class FaultLocalizationService {
  /// Returns a camera target/orbit for the 3D viewer based on the DTC system.
  /// Returns null if no specific localization is found.
  ///
  /// Format: "orbitX orbitY orbitZ" or camera target instructions.
  /// For flutter_3d_controller, we control camera orbit.
  ///
  /// Example:
  /// Engine: Front view
  /// Brakes: Wheel view
  static String? getCameraOrbitForDtc(DtcModel dtc) {
    // Simplified mapping based on system prefix or description
    final system = dtc.system.toLowerCase();

    if (system.contains('engine') || dtc.code.startsWith('P')) {
      // Powertrain -> Front hood open view?
      // Orbit: theta phi radius
      return '0deg 60deg 2m'; // Front-ish view
    } else if (system.contains('brake') || system.contains('abs')) {
      // Brakes -> Side wheel view
      return '90deg 80deg 1.5m';
    } else if (system.contains('transmission')) {
      return '0deg 90deg 1.5m'; // Undercarriage?
    } else if (system.contains('body') || dtc.code.startsWith('B')) {
      return '45deg 45deg 3m'; // General view
    }

    // Default default view
    return null;
  }

  static String getPartDescription(DtcModel dtc) {
    if (dtc.code == 'P0300') return 'Engine Cylinders';
    if (dtc.code == 'P0101') return 'Mass Air Flow Sensor';
    return dtc.system;
  }
}
