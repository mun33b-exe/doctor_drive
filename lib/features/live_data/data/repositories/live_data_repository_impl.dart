import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/obd_pids.dart';
import '../../../../core/utils/logger.dart';
import '../../../../core/utils/obd_parser.dart';
import '../../../../data/datasources/obd/tcp_socket_service.dart';
import '../../../../data/datasources/obd/obd_command_service.dart';
import '../../../connection/presentation/providers/connection_provider.dart';

// Repository Provider
final liveDataRepositoryProvider = Provider<LiveDataRepository>((ref) {
  return LiveDataRepositoryImpl(ref.watch(tcpSocketServiceProvider));
});

abstract class LiveDataRepository {
  Stream<double?> get rpmStream;
  Stream<double?> get speedStream;
  void startPolling();
  void stopPolling();
}

class LiveDataRepositoryImpl implements LiveDataRepository {
  final TcpSocketService _socketService;
  Timer? _pollingTimer;

  // We use broadcast streams derived from the main socket stream
  late final Stream<String> _textStream;

  LiveDataRepositoryImpl(this._socketService) {
    _textStream = _socketService.dataStream
        .map((bytes) => String.fromCharCodes(bytes))
        .asBroadcastStream();
  }

  @override
  Stream<double?> get rpmStream => _textStream.map(
    (response) => ObdDataParser.parse(response, ObdPids.engineRpm),
  );

  @override
  Stream<double?> get speedStream => _textStream.map(
    (response) => ObdDataParser.parse(response, ObdPids.vehicleSpeed),
  );

  @override
  void startPolling() {
    _pollingTimer?.cancel();
    // Alternating poll between RPM and Speed every 200ms
    int counter = 0;
    _pollingTimer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!_socketService.isConnected) return;

      final cmd = counter % 2 == 0
          ? ObdCommandService.formatPid(ObdPids.engineRpm)
          : ObdCommandService.formatPid(ObdPids.vehicleSpeed);

      _socketService.sendCommand(cmd);
      counter++;
    });
    logger.i('Started polling Live Data');
  }

  @override
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
    logger.i('Stopped polling Live Data');
  }
}
