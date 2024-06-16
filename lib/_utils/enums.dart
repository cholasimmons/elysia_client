enum ConnectionStatus {
  online,
  offline,
  connecting,
  error,
}

extension ConnectionStatusExtension on ConnectionStatus {
  String get name {
    switch (this) {
      case ConnectionStatus.online:
        return 'Online';
      case ConnectionStatus.offline:
        return 'Offline';
      case ConnectionStatus.connecting:
        return 'Connecting';
      case ConnectionStatus.error:
        return 'Error';
      default:
        return 'Unknown';
    }
  }
}
