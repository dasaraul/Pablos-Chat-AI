import 'package:flutter/foundation.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';
import '../utils/helpers.dart';
import '../config/api_config.dart';

enum ConnectionStatus {
  connected,
  disconnected,
  connecting,
  unstable,
  limited,
}

enum ConnectionType {
  wifi,
  mobile,
  ethernet,
  none,
  unknown,
}

class ConnectionProvider extends ChangeNotifier {
  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;
  Timer? _statusCheckTimer;
  Timer? _reconnectTimer;

  ConnectionStatus _status = ConnectionStatus.disconnected;
  ConnectionType _type = ConnectionType.none;
  bool _isOnline = false;
  DateTime? _lastConnectedAt;
  DateTime? _lastDisconnectedAt;
  int _reconnectAttempts = 0;
  double _connectionQuality = 0.0;
  int _latencyMs = 0;
  List<ConnectionEvent> _connectionHistory = [];

  // Getters
  ConnectionStatus get status => _status;
  ConnectionType get type => _type;
  bool get isOnline => _isOnline;
  bool get isOffline => !_isOnline;
  DateTime? get lastConnectedAt => _lastConnectedAt;
  DateTime? get lastDisconnectedAt => _lastDisconnectedAt;
  int get reconnectAttempts => _reconnectAttempts;
  double get connectionQuality => _connectionQuality;
  int get latencyMs => _latencyMs;
  List<ConnectionEvent> get connectionHistory => List.unmodifiable(_connectionHistory);

  // Status checks
  bool get isConnected => _status == ConnectionStatus.connected;
  bool get isConnecting => _status == ConnectionStatus.connecting;
  bool get isUnstable => _status == ConnectionStatus.unstable;
  bool get hasLimitedConnection => _status == ConnectionStatus.limited;

  ConnectionProvider() {
    _initializeConnectivity();
    _startPeriodicStatusCheck();
  }

  Future<void> _initializeConnectivity() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
      
      _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
        _updateConnectionStatus,
        onError: (error) {
          AppHelpers.debugError('Connectivity stream error: $error');
        },
      );
    } catch (e) {
      AppHelpers.debugError('Failed to initialize connectivity: $e');
    }
  }

  Future<void> _updateConnectionStatus(ConnectivityResult result) async {
    final previousStatus = _status;
    final previousType = _type;

    // Update connection type
    _type = _mapConnectivityResult(result);
    
    // Update online status
    final wasOnline = _isOnline;
    _isOnline = _type != ConnectionType.none;

    if (_isOnline && !wasOnline) {
      _lastConnectedAt = DateTime.now();
      _reconnectAttempts = 0;
      await _checkConnectionQuality();
      _addConnectionEvent(ConnectionEventType.connected);
    } else if (!_isOnline && wasOnline) {
      _lastDisconnectedAt = DateTime.now();
      _addConnectionEvent(ConnectionEventType.disconnected);
    }

    // Update connection status
    if (_isOnline) {
      _status = ConnectionStatus.connected;
      if (_connectionQuality < 0.5) {
        _status = ConnectionStatus.unstable;
      } else if (_connectionQuality < 0.3) {
        _status = ConnectionStatus.limited;
      }
    } else {
      _status = ConnectionStatus.disconnected;
    }

    // Log status changes
    if (previousStatus != _status || previousType != _type) {
      AppHelpers.debugLog(
        'Connection changed: ${previousStatus.name} -> ${_status.name}, '
        'Type: ${previousType.name} -> ${_type.name}',
        tag: 'CONNECTION',
      );
    }

    notifyListeners();

    // Start reconnection attempts if disconnected
    if (!_isOnline) {
      _startReconnectionAttempts();
    } else {
      _stopReconnectionAttempts();
    }
  }

  ConnectionType _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectionType.wifi;
      case ConnectivityResult.mobile:
        return ConnectionType.mobile;
      case ConnectivityResult.ethernet:
        return ConnectionType.ethernet;
      case ConnectivityResult.none:
        return ConnectionType.none;
      default:
        return ConnectionType.unknown;
    }
  }

  void _startPeriodicStatusCheck() {
    _statusCheckTimer?.cancel();
    _statusCheckTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _performStatusCheck(),
    );
  }

  Future<void> _performStatusCheck() async {
    if (!_isOnline) return;

    try {
      await _checkConnectionQuality();
      
      // Update status based on quality
      final previousStatus = _status;
      if (_connectionQuality >= 0.7) {
        _status = ConnectionStatus.connected;
      } else if (_connectionQuality >= 0.4) {
        _status = ConnectionStatus.unstable;
      } else {
        _status = ConnectionStatus.limited;
      }

      if (previousStatus != _status) {
        AppHelpers.debugLog('Connection quality changed: ${_connectionQuality.toStringAsFixed(2)}');
        notifyListeners();
      }
    } catch (e) {
      AppHelpers.debugError('Status check failed: $e');
      if (_status == ConnectionStatus.connected) {
        _status = ConnectionStatus.unstable;
        notifyListeners();
      }
    }
  }

  Future<void> _checkConnectionQuality() async {
    if (!_isOnline) {
      _connectionQuality = 0.0;
      _latencyMs = 0;
      return;
    }

    try {
      final stopwatch = Stopwatch()..start();
      
      // Simple ping test to API endpoint
      final response = await AppHelpers.withTimeout(
        Future.delayed(const Duration(seconds: 1)), // Simulated ping
        timeoutSeconds: 5,
      );
      
      stopwatch.stop();
      _latencyMs = stopwatch.elapsedMilliseconds;

      // Calculate quality based on latency
      if (_latencyMs < 100) {
        _connectionQuality = 1.0; // Excellent
      } else if (_latencyMs < 300) {
        _connectionQuality = 0.8; // Good
      } else if (_latencyMs < 1000) {
        _connectionQuality = 0.6; // Fair
      } else if (_latencyMs < 3000) {
        _connectionQuality = 0.3; // Poor
      } else {
        _connectionQuality = 0.1; // Very poor
      }

    } catch (e) {
      _connectionQuality = 0.2; // Assume poor quality on error
      _latencyMs = 5000;
      AppHelpers.debugError('Connection quality check failed: $e');
    }
  }

  void _startReconnectionAttempts() {
    if (_reconnectTimer?.isActive ?? false) return;

    _reconnectTimer = Timer.periodic(
      Duration(seconds: 5 + (_reconnectAttempts * 2)), // Exponential backoff
      (_) => _attemptReconnection(),
    );
  }

  void _stopReconnectionAttempts() {
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
  }

  Future<void> _attemptReconnection() async {
    if (_isOnline) {
      _stopReconnectionAttempts();
      return;
    }

    _reconnectAttempts++;
    AppHelpers.debugLog('Reconnection attempt #$_reconnectAttempts');

    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
      
      if (_isOnline) {
        _addConnectionEvent(ConnectionEventType.reconnected);
        AppHelpers.debugLog('Reconnection successful after $_reconnectAttempts attempts');
      }
    } catch (e) {
      AppHelpers.debugError('Reconnection attempt failed: $e');
    }

    // Stop trying after too many attempts
    if (_reconnectAttempts >= ApiConfig.maxRetryAttempts) {
      _stopReconnectionAttempts();
      _addConnectionEvent(ConnectionEventType.reconnectionFailed);
      AppHelpers.debugLog('Max reconnection attempts reached');
    }
  }

  void _addConnectionEvent(ConnectionEventType eventType) {
    final event = ConnectionEvent(
      type: eventType,
      timestamp: DateTime.now(),
      connectionType: _type,
      quality: _connectionQuality,
      latencyMs: _latencyMs,
    );

    _connectionHistory.add(event);

    // Keep only last 50 events
    if (_connectionHistory.length > 50) {
      _connectionHistory.removeAt(0);
    }
  }

  // Public methods
  Future<void> refresh() async {
    try {
      final result = await _connectivity.checkConnectivity();
      await _updateConnectionStatus(result);
    } catch (e) {
      AppHelpers.debugError('Failed to refresh connection status: $e');
    }
  }

  Future<bool> testConnection() async {
    try {
      _status = ConnectionStatus.connecting;
      notifyListeners();

      await _checkConnectionQuality();
      
      final isHealthy = _connectionQuality > 0.5;
      _status = isHealthy ? ConnectionStatus.connected : ConnectionStatus.unstable;
      
      notifyListeners();
      return isHealthy;
    } catch (e) {
      _status = ConnectionStatus.disconnected;
      notifyListeners();
      return false;
    }
  }

  void forceReconnect() {
    _reconnectAttempts = 0;
    _stopReconnectionAttempts();
    refresh();
  }

  String getStatusMessage() {
    switch (_status) {
      case ConnectionStatus.connected:
        return 'Connected';
      case ConnectionStatus.disconnected:
        return 'No internet connection';
      case ConnectionStatus.connecting:
        return 'Connecting...';
      case ConnectionStatus.unstable:
        return 'Unstable connection';
      case ConnectionStatus.limited:
        return 'Limited connectivity';
    }
  }

  String getConnectionTypeLabel() {
    switch (_type) {
      case ConnectionType.wifi:
        return 'Wi-Fi';
      case ConnectionType.mobile:
        return 'Mobile Data';
      case ConnectionType.ethernet:
        return 'Ethernet';
      case ConnectionType.none:
        return 'No Connection';
      case ConnectionType.unknown:
        return 'Unknown';
    }
  }

  String getQualityLabel() {
    if (_connectionQuality >= 0.8) return 'Excellent';
    if (_connectionQuality >= 0.6) return 'Good';
    if (_connectionQuality >= 0.4) return 'Fair';
    if (_connectionQuality >= 0.2) return 'Poor';
    return 'Very Poor';
  }

  Map<String, dynamic> getConnectionInfo() {
    return {
      'status': _status.name,
      'type': _type.name,
      'is_online': _isOnline,
      'quality': _connectionQuality,
      'quality_label': getQualityLabel(),
      'latency_ms': _latencyMs,
      'reconnect_attempts': _reconnectAttempts,
      'last_connected_at': _lastConnectedAt?.toIso8601String(),
      'last_disconnected_at': _lastDisconnectedAt?.toIso8601String(),
    };
  }

  @override
  void dispose() {
    _connectivitySubscription?.cancel();
    _statusCheckTimer?.cancel();
    _reconnectTimer?.cancel();
    super.dispose();
  }
}

enum ConnectionEventType {
  connected,
  disconnected,
  reconnected,
  reconnectionFailed,
  qualityChanged,
}

class ConnectionEvent {
  final ConnectionEventType type;
  final DateTime timestamp;
  final ConnectionType connectionType;
  final double quality;
  final int latencyMs;

  ConnectionEvent({
    required this.type,
    required this.timestamp,
    required this.connectionType,
    required this.quality,
    required this.latencyMs,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'connection_type': connectionType.name,
      'quality': quality,
      'latency_ms': latencyMs,
    };
  }

  @override
  String toString() {
    return 'ConnectionEvent{type: $type, connectionType: $connectionType, quality: $quality}';
  }
}