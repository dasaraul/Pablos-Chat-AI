import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/api_config.dart';
import '../utils/helpers.dart';
import '../models/ai_response_model.dart';

class NetworkService {
  static NetworkService? _instance;
  late http.Client _client;
  final Map<String, String> _defaultHeaders = ApiConfig.defaultHeaders;

  NetworkService._() {
    _client = http.Client();
  }

  static NetworkService getInstance() {
    _instance ??= NetworkService._();
    return _instance!;
  }

  // GET Request
  Future<NetworkResponse<T>> get<T>(
    String endpoint, {
    Map<String, String>? headers,
    Map<String, String>? queryParams,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = ApiConfig.buildUrl(endpoint, queryParams: queryParams);
      final requestHeaders = ApiConfig.getCustomHeaders(headers);

      AppHelpers.debugLog('GET Request: $url', tag: 'NETWORK');

      final response = await AppHelpers.withTimeout(
        _client.get(Uri.parse(url), headers: requestHeaders),
        timeoutSeconds: ApiConfig.connectTimeout ~/ 1000,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      AppHelpers.debugError('GET request failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('Network request failed: ${e.toString()}');
    }
  }

  // POST Request
  Future<NetworkResponse<T>> post<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = ApiConfig.buildUrl(endpoint);
      final requestHeaders = ApiConfig.getCustomHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      AppHelpers.debugLog('POST Request: $url', tag: 'NETWORK');
      if (body != null) {
        AppHelpers.debugLog('POST Body: ${jsonEncode(body)}', tag: 'NETWORK');
      }

      final response = await AppHelpers.withTimeout(
        _client.post(
          Uri.parse(url),
          headers: requestHeaders,
          body: jsonBody,
        ),
        timeoutSeconds: ApiConfig.sendTimeout ~/ 1000,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      AppHelpers.debugError('POST request failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('Network request failed: ${e.toString()}');
    }
  }

  // PUT Request
  Future<NetworkResponse<T>> put<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = ApiConfig.buildUrl(endpoint);
      final requestHeaders = ApiConfig.getCustomHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      AppHelpers.debugLog('PUT Request: $url', tag: 'NETWORK');

      final response = await AppHelpers.withTimeout(
        _client.put(
          Uri.parse(url),
          headers: requestHeaders,
          body: jsonBody,
        ),
        timeoutSeconds: ApiConfig.sendTimeout ~/ 1000,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      AppHelpers.debugError('PUT request failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('Network request failed: ${e.toString()}');
    }
  }

  // DELETE Request
  Future<NetworkResponse<T>> delete<T>(
    String endpoint, {
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = ApiConfig.buildUrl(endpoint);
      final requestHeaders = ApiConfig.getCustomHeaders(headers);

      AppHelpers.debugLog('DELETE Request: $url', tag: 'NETWORK');

      final response = await AppHelpers.withTimeout(
        _client.delete(Uri.parse(url), headers: requestHeaders),
        timeoutSeconds: ApiConfig.connectTimeout ~/ 1000,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      AppHelpers.debugError('DELETE request failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('Network request failed: ${e.toString()}');
    }
  }

  // PATCH Request
  Future<NetworkResponse<T>> patch<T>(
    String endpoint, {
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    T Function(Map<String, dynamic>)? fromJson,
  }) async {
    try {
      final url = ApiConfig.buildUrl(endpoint);
      final requestHeaders = ApiConfig.getCustomHeaders(headers);
      final jsonBody = body != null ? jsonEncode(body) : null;

      AppHelpers.debugLog('PATCH Request: $url', tag: 'NETWORK');

      final response = await AppHelpers.withTimeout(
        _client.patch(
          Uri.parse(url),
          headers: requestHeaders,
          body: jsonBody,
        ),
        timeoutSeconds: ApiConfig.sendTimeout ~/ 1000,
      );

      return _handleResponse<T>(response, fromJson);
    } catch (e) {
      AppHelpers.debugError('PATCH request failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('Network request failed: ${e.toString()}');
    }
  }

  // Handle Response
  NetworkResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>)? fromJson,
  ) {
    AppHelpers.debugLog(
      'Response: ${response.statusCode} - ${response.body}',
      tag: 'NETWORK',
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        if (fromJson != null) {
          final data = fromJson(jsonData);
          return NetworkResponse.success(data, response.statusCode);
        } else {
          return NetworkResponse.success(jsonData as T, response.statusCode);
        }
      } catch (e) {
        AppHelpers.debugError('Failed to parse response: $e', tag: 'NETWORK');
        return NetworkResponse.error('Failed to parse response data');
      }
    } else {
      final errorMessage = _getErrorMessage(response);
      return NetworkResponse.error(errorMessage, response.statusCode);
    }
  }

  String _getErrorMessage(http.Response response) {
    try {
      final errorData = jsonDecode(response.body);
      return errorData['message'] ?? 
             errorData['error'] ?? 
             ApiConfig.getErrorMessage(response.statusCode);
    } catch (e) {
      return ApiConfig.getErrorMessage(response.statusCode);
    }
  }

  // Retry Logic
  Future<NetworkResponse<T>> retryRequest<T>(
    Future<NetworkResponse<T>> Function() request, {
    int maxAttempts = 3,
  }) async {
    NetworkResponse<T>? lastResponse;
    
    for (int attempt = 1; attempt <= maxAttempts; attempt++) {
      try {
        final response = await request();
        
        if (response.isSuccess || !ApiConfig.isRetryableError(response.statusCode ?? 0)) {
          return response;
        }
        
        lastResponse = response;
        
        if (attempt < maxAttempts) {
          final delay = ApiConfig.getRetryDelay(attempt);
          AppHelpers.debugLog('Retrying request in ${delay.inMilliseconds}ms (attempt $attempt/$maxAttempts)');
          await Future.delayed(delay);
        }
      } catch (e) {
        AppHelpers.debugError('Retry attempt $attempt failed: $e');
        if (attempt == maxAttempts) {
          return NetworkResponse.error('All retry attempts failed: ${e.toString()}');
        }
      }
    }
    
    return lastResponse ?? NetworkResponse.error('Request failed after $maxAttempts attempts');
  }

  // Specialized AI Chat Request
  Future<NetworkResponse<AIResponseModel>> sendChatMessage(
    String message, {
    String? conversationId,
    Map<String, dynamic>? context,
  }) async {
    final body = {
      'message': message,
      'agent_id': ApiConfig.agentId,
      'chatbot_id': ApiConfig.chatbotId,
      'timestamp': DateTime.now().toIso8601String(),
      if (conversationId != null) 'conversation_id': conversationId,
      if (context != null) 'context': context,
    };

    return retryRequest(
      () => post<AIResponseModel>(
        ApiConfig.chatEndpoint,
        body: body,
        fromJson: (json) => AIResponseModel.fromJson(json),
      ),
    );
  }

  // Health Check
  Future<NetworkResponse<Map<String, dynamic>>> healthCheck() async {
    return get<Map<String, dynamic>>(
      ApiConfig.healthCheckEndpoint,
      fromJson: (json) => json,
    );
  }

  // Get System Status
  Future<NetworkResponse<Map<String, dynamic>>> getSystemStatus() async {
    return get<Map<String, dynamic>>(
      ApiConfig.statusEndpoint,
      fromJson: (json) => json,
    );
  }

  // Send Feedback
  Future<NetworkResponse<Map<String, dynamic>>> sendFeedback({
    required String feedback,
    required String type,
    Map<String, dynamic>? metadata,
  }) async {
    final body = {
      'feedback': feedback,
      'type': type,
      'timestamp': DateTime.now().toIso8601String(),
      'agent_id': ApiConfig.agentId,
      if (metadata != null) 'metadata': metadata,
    };

    return post<Map<String, dynamic>>(
      ApiConfig.feedbackEndpoint,
      body: body,
      fromJson: (json) => json,
    );
  }

  // Upload File
  Future<NetworkResponse<Map<String, dynamic>>> uploadFile({
    required String filePath,
    required String fileName,
    Map<String, String>? additionalFields,
  }) async {
    try {
      final url = ApiConfig.buildUrl(ApiConfig.uploadEndpoint);
      final request = http.MultipartRequest('POST', Uri.parse(url));
      
      // Add headers
      request.headers.addAll(_defaultHeaders);
      
      // Add file
      final file = await http.MultipartFile.fromPath('file', filePath, filename: fileName);
      request.files.add(file);
      
      // Add additional fields
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }
      
      request.fields['agent_id'] = ApiConfig.agentId;
      request.fields['timestamp'] = DateTime.now().toIso8601String();

      AppHelpers.debugLog('Upload Request: $url', tag: 'NETWORK');

      final streamedResponse = await AppHelpers.withTimeout(
        request.send(),
        timeoutSeconds: 60, // Longer timeout for file uploads
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      return _handleResponse<Map<String, dynamic>>(response, (json) => json);
    } catch (e) {
      AppHelpers.debugError('File upload failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('File upload failed: ${e.toString()}');
    }
  }

  // Download File
  Future<NetworkResponse<List<int>>> downloadFile(String fileId) async {
    try {
      final url = ApiConfig.buildUrl('${ApiConfig.downloadEndpoint}/$fileId');
      
      AppHelpers.debugLog('Download Request: $url', tag: 'NETWORK');

      final response = await AppHelpers.withTimeout(
        _client.get(Uri.parse(url), headers: _defaultHeaders),
        timeoutSeconds: 60, // Longer timeout for downloads
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return NetworkResponse.success(response.bodyBytes, response.statusCode);
      } else {
        final errorMessage = _getErrorMessage(response);
        return NetworkResponse.error(errorMessage, response.statusCode);
      }
    } catch (e) {
      AppHelpers.debugError('File download failed: $e', tag: 'NETWORK');
      return NetworkResponse.error('File download failed: ${e.toString()}');
    }
  }

  // Cancel all requests
  void cancelAllRequests() {
    _client.close();
    _client = http.Client();
  }

  // Dispose
  void dispose() {
    _client.close();
  }
}

class NetworkResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;
  final bool isSuccess;

  NetworkResponse._({
    this.data,
    this.error,
    this.statusCode,
    required this.isSuccess,
  });

  factory NetworkResponse.success(T data, int statusCode) {
    return NetworkResponse._(
      data: data,
      statusCode: statusCode,
      isSuccess: true,
    );
  }

  factory NetworkResponse.error(String error, [int? statusCode]) {
    return NetworkResponse._(
      error: error,
      statusCode: statusCode,
      isSuccess: false,
    );
  }

  bool get isError => !isSuccess;
  bool get hasData => data != null;
  bool get isClientError => statusCode != null && statusCode! >= 400 && statusCode! < 500;
  bool get isServerError => statusCode != null && statusCode! >= 500;
  bool get isNetworkError => statusCode == null;

  @override
  String toString() {
    if (isSuccess) {
      return 'NetworkResponse.success(data: $data, statusCode: $statusCode)';
    } else {
      return 'NetworkResponse.error(error: $error, statusCode: $statusCode)';
    }
  }
}