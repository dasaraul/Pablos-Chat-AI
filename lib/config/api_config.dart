import '../utils/constants.dart';

class ApiConfig {
  // Base Configuration
  static const String baseUrl = AppConstants.baseUrl;
  static const String agentId = AppConstants.agentId;
  static const String chatbotId = AppConstants.chatbotId;
  
  // API Endpoints
  static const String chatEndpoint = AppConstants.chatEndpoint;
  static const String statusEndpoint = AppConstants.statusEndpoint;
  static const String configEndpoint = AppConstants.configEndpoint;
  
  // Full API URLs
  static String get chatUrl => '$baseUrl$chatEndpoint';
  static String get statusUrl => '$baseUrl$statusEndpoint';
  static String get configUrl => '$baseUrl$configEndpoint';
  
  // Additional Endpoints
  static const String healthCheckEndpoint = '/api/health';
  static const String metricsEndpoint = '/api/metrics';
  static const String feedbackEndpoint = '/api/feedback';
  static const String analyticsEndpoint = '/api/analytics';
  static const String uploadEndpoint = '/api/upload';
  static const String downloadEndpoint = '/api/download';
  
  // Full URLs for additional endpoints
  static String get healthCheckUrl => '$baseUrl$healthCheckEndpoint';
  static String get metricsUrl => '$baseUrl$metricsEndpoint';
  static String get feedbackUrl => '$baseUrl$feedbackEndpoint';
  static String get analyticsUrl => '$baseUrl$analyticsEndpoint';
  static String get uploadUrl => '$baseUrl$uploadEndpoint';
  static String get downloadUrl => '$baseUrl$downloadEndpoint';
  
  // HTTP Methods
  static const String methodGet = 'GET';
  static const String methodPost = 'POST';
  static const String methodPut = 'PUT';
  static const String methodDelete = 'DELETE';
  static const String methodPatch = 'PATCH';
  
  // Request Headers
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'User-Agent': 'PABLOS-Mobile/${AppConstants.appVersion}',
    'X-Agent-ID': agentId,
    'X-Chatbot-ID': chatbotId,
    'X-Client-Version': AppConstants.appVersion,
  };
  
  static Map<String, String> getAuthHeaders(String? token) => {
    ...defaultHeaders,
    if (token != null) 'Authorization': 'Bearer $token',
  };
  
  static Map<String, String> getCustomHeaders(Map<String, String>? additional) => {
    ...defaultHeaders,
    if (additional != null) ...additional,
  };
  
  // Request Configuration
  static const int connectTimeout = AppConstants.connectionTimeout * 1000; // Convert to milliseconds
  static const int receiveTimeout = 30000; // 30 seconds
  static const int sendTimeout = 15000; // 15 seconds
  
  // Retry Configuration
  static const int maxRetryAttempts = AppConstants.maxRetryAttempts;
  static const int retryDelay = AppConstants.retryDelay;
  static const List<int> retryStatusCodes = [408, 429, 500, 502, 503, 504];
  
  // Rate Limiting
  static const int maxRequestsPerMinute = 60;
  static const int maxRequestsPerHour = 1000;
  static const int rateLimitWindowMinutes = 1;
  static const int rateLimitWindowHours = 60;
  
  // File Upload Configuration
  static const int maxFileSize = AppConstants.maxExportFileSize;
  static const List<String> allowedFileTypes = [
    'json', 'txt', 'csv', 'xml', 'log'
  ];
  static const List<String> allowedImageTypes = [
    'jpg', 'jpeg', 'png', 'gif', 'webp'
  ];
  
  // Websocket Configuration (for future real-time features)
  static String get websocketUrl => baseUrl.replaceFirst('https://', 'wss://').replaceFirst('http://', 'ws://');
  static const String wsEndpoint = '/ws';
  static String get fullWebsocketUrl => '$websocketUrl$wsEndpoint';
  
  // Cache Configuration
  static const int cacheMaxAge = 300; // 5 minutes
  static const int cacheMaxStale = 600; // 10 minutes
  static const List<String> cacheableEndpoints = [
    statusEndpoint,
    configEndpoint,
    healthCheckEndpoint,
  ];
  
  // Error Codes
  static const Map<int, String> errorMessages = {
    400: 'Bad Request - Invalid input parameters',
    401: 'Unauthorized - Authentication required',
    403: 'Forbidden - Access denied',
    404: 'Not Found - Resource not available',
    408: 'Request Timeout - Please try again',
    429: 'Too Many Requests - Rate limit exceeded',
    500: 'Internal Server Error - Server issue',
    502: 'Bad Gateway - Service temporarily unavailable',
    503: 'Service Unavailable - Maintenance mode',
    504: 'Gateway Timeout - Service timeout',
  };
  
  // API Response Codes
  static const String successCode = 'SUCCESS';
  static const String errorCode = 'ERROR';
  static const String warningCode = 'WARNING';
  static const String infoCode = 'INFO';
  
  // PABLOS Specific Configuration
  static const Map<String, dynamic> pablosConfig = {
    'personality': {
      'language_style': 'bahasa_jaksel',
      'pronouns': {
        'first_person': 'gw',
        'second_person': 'elu',
      },
      'expressions': ['literally', 'whichis'],
      'creator_reference': 'bos gw Tama',
    },
    'expertise_domains': [
      'digital_ocean',
      'cybersecurity',
      'web_development',
      'academic_unas',
      'general_chat',
    ],
    'response_style': {
      'friendly': true,
      'professional': true,
      'empathetic': true,
      'technical': true,
    },
  };
  
  // Environment-specific configurations
  static bool get isDevelopment => baseUrl.contains('localhost') || baseUrl.contains('dev');
  static bool get isProduction => baseUrl.contains('agents.do-ai.run');
  static bool get isStaging => baseUrl.contains('staging');
  
  // Debug Configuration
  static bool get enableRequestLogging => isDevelopment;
  static bool get enableResponseLogging => isDevelopment;
  static bool get enableErrorLogging => true;
  
  // Monitoring Configuration
  static const Map<String, dynamic> monitoringConfig = {
    'enable_performance_monitoring': true,
    'enable_error_reporting': true,
    'enable_analytics': false, // Disabled for privacy
    'sample_rate': 0.1, // 10% sampling for performance
  };
  
  // Security Configuration
  static const Map<String, dynamic> securityConfig = {
    'enable_certificate_pinning': true,
    'enable_request_signing': false,
    'enable_encryption': true,
    'min_tls_version': '1.2',
  };
  
  // Feature Flags
  static const Map<String, bool> featureFlags = {
    'enable_websocket': false,
    'enable_file_upload': true,
    'enable_voice_messages': false,
    'enable_image_upload': false,
    'enable_offline_mode': true,
    'enable_chat_export': true,
    'enable_theme_switching': true,
    'enable_matrix_rain': true,
    'enable_glitch_effects': true,
  };
  
  // Utility Methods
  static String buildUrl(String path, {Map<String, String>? queryParams}) {
    var url = '$baseUrl$path';
    
    if (queryParams != null && queryParams.isNotEmpty) {
      final query = queryParams.entries
          .map((e) => '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');
      url += '?$query';
    }
    
    return url;
  }
  
  static bool isRetryableError(int statusCode) {
    return retryStatusCodes.contains(statusCode);
  }
  
  static String getErrorMessage(int statusCode) {
    return errorMessages[statusCode] ?? 'Unknown error occurred';
  }
  
  static bool isFeatureEnabled(String feature) {
    return featureFlags[feature] ?? false;
  }
  
  static Duration getRetryDelay(int attemptNumber) {
    // Exponential backoff: 2s, 4s, 8s
    return Duration(milliseconds: retryDelay * (1 << (attemptNumber - 1)));
  }
}