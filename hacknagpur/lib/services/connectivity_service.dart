import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  final Connectivity _connectivity = Connectivity();
  
  // Stream to listen to connectivity changes
  Stream<bool>? _connectionStatusStream;

  factory ConnectivityService() {
    return _instance;
  }

  ConnectivityService._internal();

  /// Check if device is currently connected to internet
  Future<bool> isConnected() async {
    final result = await _connectivity.checkConnectivity();
    return result != ConnectivityResult.none;
  }

  /// Get stream of connectivity status changes
  Stream<bool> getConnectionStatusStream() {
    _connectionStatusStream ??= _connectivity.onConnectivityChanged
        .map((result) => result != ConnectivityResult.none)
        .distinct();
    return _connectionStatusStream!;
  }

  /// Get current connection type
  Future<String> getConnectionType() async {
    final result = await _connectivity.checkConnectivity();
    switch (result) {
      case ConnectivityResult.mobile:
        return 'mobile';
      case ConnectivityResult.wifi:
        return 'wifi';
      case ConnectivityResult.ethernet:
        return 'ethernet';
      case ConnectivityResult.none:
        return 'none';
      default:
        return 'unknown';
    }
  }
}
