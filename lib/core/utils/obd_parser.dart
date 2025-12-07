class ObdDataParser {
  /// Decodes standard OBD-II PID responses.
  ///
  /// [response] should be the raw string from ELM327 (e.g., "41 0C 1A F8").
  /// Returns a double value or null if parsing fails.
  static double? parse(String response, String pid) {
    // Remove whitespace, nulls, and ELM327 prompt char '>'
    final cleanResponse = response.replaceAll(RegExp(r'[\s>]+'), '').trim();

    // Check for "41xx" success prefix
    if (!cleanResponse.startsWith('41${pid}')) {
      return null; // Not a valid response for this PID or error
    }

    try {
      // Extract data bytes (skip first 4 chars: 41 + PID)
      final dataHex = cleanResponse.substring(4);
      final bytes = <int>[];
      for (var i = 0; i < dataHex.length; i += 2) {
        if (i + 2 <= dataHex.length) {
          bytes.add(int.parse(dataHex.substring(i, i + 2), radix: 16));
        }
      }

      if (bytes.isEmpty) return null;

      switch (pid) {
        case '0C': // RPM: ((A*256)+B)/4
          if (bytes.length < 2) return null;
          final a = bytes[0];
          final b = bytes[1];
          return ((a * 256.0) + b) / 4.0;

        case '0D': // Speed: A km/h
          if (bytes.length < 1) return null;
          return bytes[0].toDouble();

        case '05': // Coolant Temp: A - 40
          if (bytes.length < 1) return null;
          return bytes[0].toDouble() - 40.0;

        case '04': // Engine Load: A * 100 / 255
          if (bytes.length < 1) return null;
          return (bytes[0] * 100.0) / 255.0;

        default:
          return null;
      }
    } catch (e) {
      return null;
    }
  }
}
