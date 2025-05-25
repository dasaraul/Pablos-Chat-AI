import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:math';
import 'constants.dart';

class AppHelpers {
  // Text Utilities
  static String capitalizeFirst(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }
  
  static String formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    
    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }
  
  static String formatDetailedTime(DateTime timestamp) {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')} - '
           '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }
  
  // Message Processing
  static String sanitizeMessage(String message) {
    return message.trim().replaceAll(RegExp(r'\s+'), ' ');
  }
  
  static bool isValidMessage(String message) {
    final sanitized = sanitizeMessage(message);
    return sanitized.isNotEmpty && 
           sanitized.length >= AppConstants.minMessageLength &&
           sanitized.length <= AppConstants.maxMessageLength;
  }
  
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength - 3)}...';
  }
  
  // Random Generators
  static String getRandomOpeningMessage() {
    final random = Random();
    final messages = AppConstants.openingMessages;
    return messages[random.nextInt(messages.length)];
  }
  
  static String getRandomErrorMessage() {
    final random = Random();
    final messages = AppConstants.errorMessages;
    return messages[random.nextInt(messages.length)];
  }
  
  static String getRandomLoadingMessage() {
    final random = Random();
    final messages = AppConstants.loadingMessages;
    return messages[random.nextInt(messages.length)];
  }
  
  static String getRandomTerminalCommand() {
    final random = Random();
    final commands = AppConstants.terminalCommands;
    return commands[random.nextInt(commands.length)];
  }
  
  // Color Utilities
  static Color adjustColorBrightness(Color color, double factor) {
    return Color.fromRGBO(
      (color.red * factor).round().clamp(0, 255),
      (color.green * factor).round().clamp(0, 255),
      (color.blue * factor).round().clamp(0, 255),
      color.opacity,
    );
  }
  
  static Color getContrastColor(Color backgroundColor) {
    final brightness = backgroundColor.computeLuminance();
    return brightness > 0.5 ? Colors.black : Colors.white;
  }
  
  // Animation Utilities
  static Duration getStaggeredDelay(int index, {int baseDelay = 100}) {
    return Duration(milliseconds: baseDelay * index);
  }
  
  static Curve getRandomCurve() {
    final curves = [
      Curves.easeIn,
      Curves.easeOut,
      Curves.easeInOut,
      Curves.bounceIn,
      Curves.bounceOut,
      Curves.elasticIn,
      Curves.elasticOut,
    ];
    final random = Random();
    return curves[random.nextInt(curves.length)];
  }
  
  // File Utilities
  static String generateExportFileName() {
    final now = DateTime.now();
    final timestamp = '${now.year}-${now.month.toString().padLeft(2, '0')}-'
                     '${now.day.toString().padLeft(2, '0')}_'
                     '${now.hour.toString().padLeft(2, '0')}-'
                     '${now.minute.toString().padLeft(2, '0')}-'
                     '${now.second.toString().padLeft(2, '0')}';
    return '${AppConstants.exportFileName}_$timestamp${AppConstants.exportFileExtension}';
  }
  
  static Map<String, dynamic> prepareExportData(List<dynamic> messages) {
    return {
      'app_name': AppConstants.appName,
      'app_version': AppConstants.appVersion,
      'export_date': DateTime.now().toIso8601String(),
      'message_count': messages.length,
      'messages': messages,
      'metadata': {
        'agent_id': AppConstants.agentId,
        'chatbot_id': AppConstants.chatbotId,
        'author': AppConstants.author,
      },
    };
  }
  
  // Network Utilities
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
    } catch (e) {
      return false;
    }
  }
  
  static Map<String, String> getRequestHeaders({Map<String, String>? additional}) {
    final headers = Map<String, String>.from(AppConstants.defaultHeaders);
    if (additional != null) {
      headers.addAll(additional);
    }
    return headers;
  }
  
  // Validation Utilities
  static bool isEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isStrongPassword(String password) {
    return password.length >= 8 && 
           RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]').hasMatch(password);
  }
  
  // Platform Utilities
  static bool get isWeb => identical(0, 0.0);
  
  static bool get isMobile => !isWeb;
  
  // Haptic Feedback
  static void lightHaptic() {
    if (AppConstants.enableHapticFeedback) {
      HapticFeedback.lightImpact();
    }
  }
  
  static void mediumHaptic() {
    if (AppConstants.enableHapticFeedback) {
      HapticFeedback.mediumImpact();
    }
  }
  
  static void heavyHaptic() {
    if (AppConstants.enableHapticFeedback) {
      HapticFeedback.heavyImpact();
    }
  }
  
  // Debug Utilities
  static void debugLog(String message, {String? tag}) {
    if (AppConstants.enableDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag ?? 'PABLOS';
      print('[$timestamp] [$logTag] $message');
    }
  }
  
  static void debugError(String error, {String? tag, dynamic stackTrace}) {
    if (AppConstants.enableDebugMode) {
      final timestamp = DateTime.now().toIso8601String();
      final logTag = tag ?? 'PABLOS_ERROR';
      print('[$timestamp] [$logTag] ERROR: $error');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }
  
  // Message Type Detection
  static bool isGreeting(String message) {
    final greetings = ['hi', 'hello', 'hey', 'halo', 'hai', 'wassup', 'yo'];
    final lowercaseMessage = message.toLowerCase();
    return greetings.any((greeting) => lowercaseMessage.contains(greeting));
  }
  
  static bool isTechnicalQuestion(String message) {
    final techKeywords = [
      'digital ocean', 'droplet', 'vps', 'server', 'cloud', 'hosting',
      'deployment', 'docker', 'nginx', 'database', 'mysql', 'postgresql',
      'ubuntu', 'linux', 'ssh', 'domain', 'ssl', 'backup'
    ];
    final lowercaseMessage = message.toLowerCase();
    return techKeywords.any((keyword) => lowercaseMessage.contains(keyword));
  }
  
  static bool isSecurityQuestion(String message) {
    final securityKeywords = [
      'security', 'hack', 'cybersecurity', 'firewall', 'malware', 
      'vulnerability', 'penetration', 'encryption', 'password', 'auth'
    ];
    final lowercaseMessage = message.toLowerCase();
    return securityKeywords.any((keyword) => lowercaseMessage.contains(keyword));
  }
  
  static bool isAcademicQuestion(String message) {
    final academicKeywords = [
      'unas', 'university', 'academic', 'thesis', 'research', 'assignment',
      'study', 'course', 'exam', 'grade', 'professor', 'student'
    ];
    final lowercaseMessage = message.toLowerCase();
    return academicKeywords.any((keyword) => lowercaseMessage.contains(keyword));
  }
  
  // Storage Utilities
  static String encodeData(Map<String, dynamic> data) {
    return base64Encode(utf8.encode(jsonEncode(data)));
  }
  
  static Map<String, dynamic>? decodeData(String encodedData) {
    try {
      final decodedString = utf8.decode(base64Decode(encodedData));
      return jsonDecode(decodedString) as Map<String, dynamic>;
    } catch (e) {
      debugError('Failed to decode data: $e');
      return null;
    }
  }
  
  // Performance Utilities
  static Future<T> withTimeout<T>(
    Future<T> future, {
    int timeoutSeconds = AppConstants.connectionTimeout,
  }) {
    return future.timeout(
      Duration(seconds: timeoutSeconds),
      onTimeout: () => throw TimeoutException(
        'Operation timed out after $timeoutSeconds seconds',
        Duration(seconds: timeoutSeconds),
      ),
    );
  }
  
  // UI Utilities
  static void showSnackBar(
    BuildContext context, 
    String message, {
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontFamily: 'JetBrainsMono',
          ),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
  
  static void copyToClipboard(String text, {BuildContext? context}) {
    Clipboard.setData(ClipboardData(text: text));
    if (context != null) {
      showSnackBar(context, 'Copied to clipboard');
    }
    lightHaptic();
  }
}

class TimeoutException implements Exception {
  final String message;
  final Duration timeout;
  
  const TimeoutException(this.message, this.timeout);
  
  @override
  String toString() => 'TimeoutException: $message';
}