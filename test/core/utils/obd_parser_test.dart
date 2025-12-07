import 'package:flutter_test/flutter_test.dart';
import 'package:doctor_drive/core/utils/obd_parser.dart';
import 'package:doctor_drive/core/constants/obd_pids.dart';

void main() {
  group('ObdDataParser', () {
    test('parses RPM correctly', () {
      // 41 0C 1A F8
      // A = 1A (26), B = F8 (248)
      // ((26 * 256) + 248) / 4 = (6656 + 248) / 4 = 6904 / 4 = 1726
      const response = '41 0C 1A F8';
      final result = ObdDataParser.parse(response, ObdPids.engineRpm);
      expect(result, 1726.0);
    });

    test('parses Speed correctly', () {
      // 41 0D 32
      // A = 32 (50)
      const response = '41 0D 32';
      final result = ObdDataParser.parse(response, ObdPids.vehicleSpeed);
      expect(result, 50.0);
    });

    test('returns null for invalid prefix', () {
      const response = '41 05 32'; // PID 05 but parsed as 0D (if requested)
      // Parser checks prefix matches requested PID
      final result = ObdDataParser.parse(response, ObdPids.vehicleSpeed);
      expect(result, null);
    });

    test('returns null for malformed data', () {
      const response = 'GARBAGE';
      final result = ObdDataParser.parse(response, ObdPids.engineRpm);
      expect(result, null);
    });

    test('parses RPM with spaces and newlines', () {
      const response = '\r\n> 41 0C 0F A0 \r\n';
      // A=0F(15), B=A0(160) => (3840 + 160)/4 = 1000
      final result = ObdDataParser.parse(response, ObdPids.engineRpm);
      expect(result, 1000.0);
    });
  });
}
