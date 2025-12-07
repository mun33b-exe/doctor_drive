import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/logger.dart';
import '../../../../data/datasources/obd/tcp_socket_service.dart';
import '../../../../data/datasources/obd/obd_command_service.dart';
import 'connection_state.dart';

// Dependency Injection for Socket Service
final tcpSocketServiceProvider = Provider<TcpSocketService>((ref) {
  final service = TcpSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Logic Provider
final connectionProvider =
    StateNotifierProvider<ConnectionNotifier, SocketConnectionState>((ref) {
      return ConnectionNotifier(ref.watch(tcpSocketServiceProvider));
    });

class ConnectionNotifier extends StateNotifier<SocketConnectionState> {
  final TcpSocketService _socketService;

  ConnectionNotifier(this._socketService)
    : super(const SocketConnectionState());

  Future<void> connect({
    String host = AppConstants.defaultObdIp,
    int port = AppConstants.defaultObdPort,
  }) async {
    if (state.status == ConnectionStatus.connecting) return;

    state = state.copyWith(
      status: ConnectionStatus.connecting,
      ipAddress: host,
      port: port,
      errorMessage: null,
    );

    final result = await _socketService.connect(host: host, port: port);

    result.fold(
      (failure) {
        state = state.copyWith(
          status: ConnectionStatus.error,
          errorMessage: failure.message,
        );
      },
      (_) {
        state = state.copyWith(status: ConnectionStatus.connected);
        _initializeObd();
      },
    );
  }

  void _initializeObd() {
    // Basic initialization sequence
    _socketService.sendCommand(ObdCommandService.reset);
    Future.delayed(const Duration(seconds: 1), () {
      _socketService.sendCommand(ObdCommandService.echoOff);
      _socketService.sendCommand(ObdCommandService.headersOff);
      _socketService.sendCommand(ObdCommandService.protocolAuto);
    });
  }

  Future<void> autoReconnect() async {
    const int maxRetries = 3;
    int attempts = 0;
    while (state.status != ConnectionStatus.connected &&
        attempts < maxRetries) {
      attempts++;
      logger.i('Auto-reconnect attempt $attempts');
      await connect();
      if (state.status == ConnectionStatus.connected) break;
      await Future.delayed(const Duration(seconds: 2));
    }
  }

  void disconnect() {
    _socketService.disconnect();
    state = state.copyWith(status: ConnectionStatus.disconnected);
  }
}
