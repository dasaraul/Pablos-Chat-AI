import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';
import '../config/environment.dart';
import '../utils/helpers.dart';
import '../services/storage_service.dart';

enum AnalyticsEventType {
  appStart,
  appClose,
  screenView,
  userAction,
  chatMessage,
  featureUsage,
  error,
  performance,
}

enum UserActionType {
  tap,
  longPress,
  swipe,
  scroll,
  voice,
  gesture,
}

class AnalyticsService {
  static AnalyticsService? _instance;
  late StorageService _storage;
  final List<AnalyticsEvent> _eventQueue = [];
  final Map<String, dynamic> _sessionData = {};
  DateTime? _sessionStartTime;
  String? _sessionId;
  bool _isInitialized = false;

  AnalyticsService._();

  static Future<AnalyticsService> getInstance() async {
    _instance ??= AnalyticsService._();
    if (!_instance!._isInitialized) {
      await _instance!._initialize();
    }
    return _instance!;
  }

  Future<void> _initialize() async {
    if (!EnvironmentConfig.enableAnalytics) {
      AppHelpers.debugLog('Analytics disabled in current environment');
      _isInitialized = true;
      return;
    }

    try {
      _storage = await StorageService.getInstance();
      _sessionId = _generateSessionId();
      _sessionStartTime = DateTime.now();
      
      await _loadPendingEvents();
      _startSession();
      
      AppHelpers.debugLog('Analytics service initialized');
      _isInitialized = true;
    } catch (e) {
      AppHelpers.debugError('Failed to initialize analytics: $e');
      _isInitialized = true; // Set to true to prevent retry loops
    }
  }

  String _generateSessionId() {
    return 'session_${DateTime.now().millisecondsSinceEpoch}';
  }

  void _startSession() {
    trackEvent(
      type: AnalyticsEventType.appStart,
      name: 'app_start',
      properties: {
        'session_id': _sessionId,
        'app_version': AppConfig.appVersion,
        'platform': AppConfig.getPlatformInfo(),
        'environment': EnvironmentConfig.currentEnvironment.name,
      },
    );
  }

  // Core Tracking Methods
  void trackEvent({
    required AnalyticsEventType type,
    required String name,
    Map<String, dynamic>? properties,
    DateTime? timestamp,
  }) {
    if (!EnvironmentConfig.enableAnalytics) return;

    final event = AnalyticsEvent(
      id: _generateEventId(),
      type: type,
      name: name,
      properties: {
        'session_id': _sessionId,
        'timestamp': (timestamp ?? DateTime.now()).toIso8601String(),
        'app_version': AppConfig.appVersion,
        'platform': AppConfig.getPlatformInfo(),
        ...?properties,
      },
      timestamp: timestamp ?? DateTime.now(),
    );

    _eventQueue.add(event);
    _processEventQueue();

    AppHelpers.debugLog('Analytics event tracked: ${event.name}', tag: 'ANALYTICS');
  }

  void trackScreenView(String screenName, {Map<String, dynamic>? properties}) {
    trackEvent(
      type: AnalyticsEventType.screenView,
      name: 'screen_view',
      properties: {
        'screen_name': screenName,
        ...?properties,
      },
    );
  }

  void trackUserAction({
    required UserActionType actionType,
    required String element,
    String? screen,
    Map<String, dynamic>? properties,
  }) {
    trackEvent(
      type: AnalyticsEventType.userAction,
      name: 'user_action',
      properties: {
        'action_type': actionType.name,
        'element': element,
        if (screen != null) 'screen': screen,
        ...?properties,
      },
    );
  }

  void trackChatMessage({
    required String messageType,
    required int messageLength,
    String? category,
    Map<String, dynamic>? properties,
  }) {
    trackEvent(
      type: AnalyticsEventType.chatMessage,
      name: 'chat_message',
      properties: {
        'message_type': messageType,
        'message_length': messageLength,
        if (category != null) 'category': category,
        ...?properties,
      },
    );
  }

  void trackFeatureUsage({
    required String featureName,
    Map<String, dynamic>? properties,
  }) {
    trackEvent(
      type: AnalyticsEventType.featureUsage,
      name: 'feature_usage',
      properties: {
        'feature_name': featureName,
        ...?properties,
      },
    );
  }

  void trackError({
    required String errorType,
    required String errorMessage,
    String? stackTrace,
    Map<String, dynamic>? properties,
  }) {
    trackEvent(
      type: AnalyticsEventType.error,
      name: 'error',
      properties: {
        'error_type': errorType,
        'error_message': errorMessage,
        if (stackTrace != null) 'stack_trace': stackTrace,
        ...?properties,
      },
    );
  }

  void trackPerformance({
    required String operation,
    required int durationMs,
    bool success = true,
    Map<String, dynamic>? properties,
  }) {
    trackEvent(
      type: AnalyticsEventType.performance,
      name: 'performance',
      properties: {
        'operation': operation,
        'duration_ms': durationMs,
        'success': success,
        ...?properties,
      },
    );
  }

  // Session Management
  void updateSessionData(Map<String, dynamic> data) {
    _sessionData.addAll(data);
  }

  void endSession() {
    if (_sessionStartTime != null) {
      final sessionDuration = DateTime.now().difference(_sessionStartTime!);
      
      trackEvent(
        type: AnalyticsEventType.appClose,
        name: 'app_close',
        properties: {
          'session_duration_ms': sessionDuration.inMilliseconds,
          'session_data': _sessionData,
        },
      );
    }

    _flushEvents();
  }

  // Event Processing
  void _processEventQueue() {
    if (_eventQueue.length >= 10) {
      _flushEvents();
    }
  }

  Future<void> _flushEvents() async {
    if (_eventQueue.isEmpty) return;

    try {
      // In a real implementation, you would send events to your analytics service
      // For now, we'll just store them locally
      await _storeEventsLocally();
      _eventQueue.clear();
      
      AppHelpers.debugLog('Analytics events flushed: ${_eventQueue.length} events', tag: 'ANALYTICS');
    } catch (e) {
      AppHelpers.debugError('Failed to flush analytics events: $e');
    }
  }

  Future<void> _storeEventsLocally() async {
    try {
      final existingEvents = await _loadStoredEvents();
      existingEvents.addAll(_eventQueue);
      
      // Keep only last 1000 events
      if (existingEvents.length > 1000) {
        existingEvents.removeRange(0, existingEvents.length - 1000);
      }
      
      final eventsJson = existingEvents.map((e) => e.toJson()).toList();
      await _storage.setString('analytics_events', jsonEncode(eventsJson));
    } catch (e) {
      AppHelpers.debugError('Failed to store analytics events locally: $e');
    }
  }

  Future<List<AnalyticsEvent>> _loadStoredEvents() async {
    try {
      final eventsString = _storage.getString('analytics_events');
      if (eventsString == null) return [];
      
      final eventsList = jsonDecode(eventsString) as List<dynamic>;
      return eventsList
          .map((e) => AnalyticsEvent.fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (e) {
      AppHelpers.debugError('Failed to load stored analytics events: $e');
      return [];
    }
  }

  Future<void> _loadPendingEvents() async {
    try {
      final storedEvents = await _loadStoredEvents();
      _eventQueue.addAll(storedEvents);
      
      if (_eventQueue.isNotEmpty) {
        AppHelpers.debugLog('Loaded ${_eventQueue.length} pending analytics events');
      }
    } catch (e) {
      AppHelpers.debugError('Failed to load pending analytics events: $e');
    }
  }

  String _generateEventId() {
    return 'event_${DateTime.now().millisecondsSinceEpoch}_${_eventQueue.length}';
  }

  // Data Access Methods
  Future<List<AnalyticsEvent>> getStoredEvents() async {
    return await _loadStoredEvents();
  }

  Future<Map<String, dynamic>> getAnalyticsSummary() async {
    final events = await _loadStoredEvents();
    
    final summary = <String, dynamic>{
      'total_events': events.length,
      'events_by_type': <String, int>{},
      'most_common_events': <String, int>{},
      'session_count': <String>{}.length,
      'date_range': {
        'start': events.isNotEmpty ? events.first.timestamp.toIso8601String() : null,
        'end': events.isNotEmpty ? events.last.timestamp.toIso8601String() : null,
      },
    };

    // Count events by type
    for (final event in events) {
      final type = event.type.name;
      summary['events_by_type'][type] = (summary['events_by_type'][type] ?? 0) + 1;
      
      final name = event.name;
      summary['most_common_events'][name] = (summary['most_common_events'][name] ?? 0) + 1;
    }

    return summary;
  }

  Future<void> clearAnalyticsData() async {
    try {
      await _storage.remove('analytics_events');
      _eventQueue.clear();
      _sessionData.clear();
      
      AppHelpers.debugLog('Analytics data cleared');
    } catch (e) {
      AppHelpers.debugError('Failed to clear analytics data: $e');
    }
  }

  // Privacy Methods
  bool get isAnalyticsEnabled => EnvironmentConfig.enableAnalytics;
  
  void setAnalyticsEnabled(bool enabled) {
    // In a real implementation, you would update user preferences
    // and potentially clear existing data if disabled
    AppHelpers.debugLog('Analytics ${enabled ? 'enabled' : 'disabled'}');
  }

  Future<void> exportAnalyticsData() async {
    try {
      final events = await _loadStoredEvents();
      final summary = await getAnalyticsSummary();
      
      final exportData = {
        'metadata': {
          'export_date': DateTime.now().toIso8601String(),
          'app_version': AppConfig.appVersion,
          'total_events': events.length,
        },
        'summary': summary,
        'events': events.map((e) => e.toJson()).toList(),
      };

      // In a real implementation, you would save this to a file or send it somewhere
      AppHelpers.debugLog('Analytics data exported: ${events.length} events');
      
    } catch (e) {
      AppHelpers.debugError('Failed to export analytics data: $e');
    }
  }

  // Dispose
  void dispose() {
    endSession();
  }
}

class AnalyticsEvent {
  final String id;
  final AnalyticsEventType type;
  final String name;
  final Map<String, dynamic> properties;
  final DateTime timestamp;

  AnalyticsEvent({
    required this.id,
    required this.type,
    required this.name,
    required this.properties,
    required this.timestamp,
  });

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      id: json['id'] as String,
      type: AnalyticsEventType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => AnalyticsEventType.userAction,
      ),
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>? ?? {},
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'name': name,
      'properties': properties,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'AnalyticsEvent{id: $id, type: $type, name: $name}';
  }
}

// Convenience methods for common tracking scenarios
extension AnalyticsExtensions on AnalyticsService {
  void trackButtonTap(String buttonName, {String? screen}) {
    trackUserAction(
      actionType: UserActionType.tap,
      element: buttonName,
      screen: screen,
    );
  }

  void trackScreenTransition(String fromScreen, String toScreen) {
    trackUserAction(
      actionType: UserActionType.tap,
      element: 'navigation',
      properties: {
        'from_screen': fromScreen,
        'to_screen': toScreen,
      },
    );
  }

  void trackThemeChange(String newTheme, String previousTheme) {
    trackFeatureUsage(
      featureName: 'theme_change',
      properties: {
        'new_theme': newTheme,
        'previous_theme': previousTheme,
      },
    );
  }

  void trackChatSession({
    required int messageCount,
    required int durationMs,
    required String category,
  }) {
    trackFeatureUsage(
      featureName: 'chat_session',
      properties: {
        'message_count': messageCount,
        'duration_ms': durationMs,
        'category': category,
      },
    );
  }
}