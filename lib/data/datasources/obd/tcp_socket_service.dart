import 'dart:async';
import 'dart:io';

import '../../../core/utils/logger.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/errors/failure.dart';
import 'package:fpdart/fpdart.dart';

class TcpSocketService {
  Socket? _socket;
  final StreamController<List<int>> _dataController =
      StreamController.broadcast();

  Stream<List<int>> get dataStream => _dataController.stream;

  bool get isConnected => _socket != null;

  Future<Either<Failure, Unit>> connect({
    String host = AppConstants.defaultObdIp,
    int port = AppConstants.defaultObdPort,
  }) async {
    try {
      logger.i('Attempting to connect to $host:$port');
      _socket = await Socket.connect(
        host,
        port,
        timeout: const Duration(milliseconds: AppConstants.connectionTimeoutMs),
      );

      _socket!.listen(
        (data) {
          // logger.d('Received: ${String.fromCharCodes(data).trim()}'); // Verbose logging
          _dataController.add(data);
        },
        onError: (error) {
          logger.e('Socket error: $error');
          disconnect();
        },
        onDone: () {
          logger.w('Socket closed by remote');
          disconnect();
        },
      );

      logger.i('Connected to ELM327');
      return const Right(unit);
    } catch (e) {
      logger.e('Connection failed', error: e);
      return Left(ConnectionFailure(e.toString()));
    }
  }

  void sendCommand(String command) {
    if (_socket == null) {
      logger.e('Cannot send command: Socket not connected');
      return;
    }
    try {
      // ELM327 requires \r at end of command
      final cmd = command.endsWith('\r') ? command : '$command\r';
      _socket!.write(cmd);
    } catch (e) {
      logger.e('Error sending command: $e');
      disconnect();
    }
  }

  void disconnect() {
    _socket?.destroy();
    _socket = null;
    logger.i('Disconnected');
  }

  void dispose() {
    disconnect();
    _dataController.close();
  }
}
