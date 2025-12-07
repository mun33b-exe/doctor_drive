class ObdCommandService {
  /// Basic AT commands for initialization
  static const String reset = 'AT Z';
  static const String echoOff = 'AT E0';
  static const String protocolAuto = 'AT SP 0';
  static const String headersOff = 'AT H0';
  static const String spacesOff = 'AT S0';

  /// Standard OBD PIDs prefix
  static const String modeCurrentData = '01';
  static const String modeDtc = '03';
  static const String modeClearDtc = '04';

  static String formatPid(String pid) {
    return '$modeCurrentData $pid';
  }
}
