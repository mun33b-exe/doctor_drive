enum ConnectionStatus {
  initial,
  connecting,
  connected,
  disconnecting,
  disconnected,
  error,
}

class SocketConnectionState {
  final ConnectionStatus status;
  final String? errorMessage;
  final String? ipAddress;
  final int? port;

  const SocketConnectionState({
    this.status = ConnectionStatus.initial,
    this.errorMessage,
    this.ipAddress,
    this.port,
  });

  SocketConnectionState copyWith({
    ConnectionStatus? status,
    String? errorMessage,
    String? ipAddress,
    int? port,
  }) {
    return SocketConnectionState(
      status: status ?? this.status,
      errorMessage: errorMessage,
      ipAddress: ipAddress ?? this.ipAddress,
      port: port ?? this.port,
    );
  }
}
