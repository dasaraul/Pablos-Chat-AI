import '../utils/constants.dart';

class AppValidators {
  // Message Validation
  static ValidationResult validateMessage(String message) {
    if (message.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Message cannot be empty',
        errorCode: 'EMPTY_MESSAGE',
      );
    }

    final trimmed = message.trim();
    if (trimmed.length < AppConstants.minMessageLength) {
      return ValidationResult(
        isValid: false,
        error: 'Message is too short',
        errorCode: 'MESSAGE_TOO_SHORT',
      );
    }

    if (trimmed.length > AppConstants.maxMessageLength) {
      return ValidationResult(
        isValid: false,
        error: 'Message is too long (max ${AppConstants.maxMessageLength} characters)',
        errorCode: 'MESSAGE_TOO_LONG',
      );
    }

    // Check for spam patterns
    if (_isSpamMessage(trimmed)) {
      return ValidationResult(
        isValid: false,
        error: 'Message appears to be spam',
        errorCode: 'SPAM_DETECTED',
      );
    }

    // Check for inappropriate content
    if (_hasInappropriateContent(trimmed)) {
      return ValidationResult(
        isValid: false,
        error: 'Message contains inappropriate content',
        errorCode: 'INAPPROPRIATE_CONTENT',
      );
    }

    return ValidationResult(isValid: true);
  }

  static bool _isSpamMessage(String message) {
    final lowerMessage = message.toLowerCase();
    
    // Check for excessive repetition
    final words = lowerMessage.split(' ');
    final wordCount = <String, int>{};
    
    for (final word in words) {
      if (word.length > 2) {
        wordCount[word] = (wordCount[word] ?? 0) + 1;
        if (wordCount[word]! > 5) {
          return true; // Same word repeated more than 5 times
        }
      }
    }

    // Check for excessive special characters
    final specialCharCount = message.replaceAll(RegExp(r'[a-zA-Z0-9\s]'), '').length;
    if (specialCharCount > message.length * 0.5) {
      return true;
    }

    // Check for excessive capitalization
    final upperCaseCount = message.replaceAll(RegExp(r'[^A-Z]'), '').length;
    if (upperCaseCount > message.length * 0.7 && message.length > 10) {
      return true;
    }

    return false;
  }

  static bool _hasInappropriateContent(String message) {
    // Simple inappropriate content detection
    // In a real app, you'd use a more sophisticated content moderation service
    final inappropriateWords = [
      'spam', 'scam', 'hack', 'exploit', 'malware', 'virus',
      // Add more as needed, but be careful not to block legitimate technical discussions
    ];

    final lowerMessage = message.toLowerCase();
    
    // Only flag if the context suggests malicious intent
    for (final word in inappropriateWords) {
      if (lowerMessage.contains(word)) {
        // Check context - allow if it's clearly educational/technical
        if (_isEducationalContext(lowerMessage, word)) {
          continue;
        }
        return true;
      }
    }

    return false;
  }

  static bool _isEducationalContext(String message, String flaggedWord) {
    final educationalIndicators = [
      'learn', 'education', 'study', 'research', 'academic', 'university',
      'course', 'tutorial', 'guide', 'documentation', 'protect', 'defense',
      'security', 'cybersecurity', 'ethical', 'prevention', 'awareness'
    ];

    return educationalIndicators.any((indicator) => message.contains(indicator));
  }

  // URL Validation
  static ValidationResult validateUrl(String url) {
    if (url.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'URL cannot be empty',
        errorCode: 'EMPTY_URL',
      );
    }

    try {
      final uri = Uri.parse(url);
      
      if (!uri.hasScheme) {
        return ValidationResult(
          isValid: false,
          error: 'URL must include a scheme (http:// or https://)',
          errorCode: 'MISSING_SCHEME',
        );
      }

      if (uri.scheme != 'http' && uri.scheme != 'https') {
        return ValidationResult(
          isValid: false,
          error: 'URL must use HTTP or HTTPS protocol',
          errorCode: 'INVALID_SCHEME',
        );
      }

      if (!uri.hasAuthority) {
        return ValidationResult(
          isValid: false,
          error: 'URL must include a domain',
          errorCode: 'MISSING_DOMAIN',
        );
      }

      return ValidationResult(isValid: true);
    } catch (e) {
      return ValidationResult(
        isValid: false,
        error: 'Invalid URL format',
        errorCode: 'INVALID_FORMAT',
      );
    }
  }

  // Email Validation
  static ValidationResult validateEmail(String email) {
    if (email.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Email cannot be empty',
        errorCode: 'EMPTY_EMAIL',
      );
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return ValidationResult(
        isValid: false,
        error: 'Invalid email format',
        errorCode: 'INVALID_EMAIL_FORMAT',
      );
    }

    return ValidationResult(isValid: true);
  }

  // Username Validation
  static ValidationResult validateUsername(String username) {
    if (username.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Username cannot be empty',
        errorCode: 'EMPTY_USERNAME',
      );
    }

    if (username.length > AppConstants.maxUsernameLength) {
      return ValidationResult(
        isValid: false,
        error: 'Username is too long (max ${AppConstants.maxUsernameLength} characters)',
        errorCode: 'USERNAME_TOO_LONG',
      );
    }

    final usernameRegex = RegExp(r'^[a-zA-Z0-9_-]+);
    if (!usernameRegex.hasMatch(username)) {
      return ValidationResult(
        isValid: false,
        error: 'Username can only contain letters, numbers, underscores, and hyphens',
        errorCode: 'INVALID_USERNAME_FORMAT',
      );
    }

    return ValidationResult(isValid: true);
  }

  // Password Validation
  static ValidationResult validatePassword(String password) {
    if (password.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Password cannot be empty',
        errorCode: 'EMPTY_PASSWORD',
      );
    }

    if (password.length < 8) {
      return ValidationResult(
        isValid: false,
        error: 'Password must be at least 8 characters long',
        errorCode: 'PASSWORD_TOO_SHORT',
      );
    }

    if (password.length > 128) {
      return ValidationResult(
        isValid: false,
        error: 'Password is too long (max 128 characters)',
        errorCode: 'PASSWORD_TOO_LONG',
      );
    }

    final hasUppercase = RegExp(r'[A-Z]').hasMatch(password);
    final hasLowercase = RegExp(r'[a-z]').hasMatch(password);
    final hasDigits = RegExp(r'\d').hasMatch(password);
    final hasSpecialChars = RegExp(r'[!@#$%^&*()_+\-=\[\]{};:"\\|,.<>\/?]').hasMatch(password);

    final weakPatterns = ['password', '123456', 'qwerty', 'admin', 'user'];
    if (weakPatterns.any((pattern) => password.toLowerCase().contains(pattern))) {
      return ValidationResult(
        isValid: false,
        error: 'Password contains common weak patterns',
        errorCode: 'WEAK_PASSWORD_PATTERN',
      );
    }

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialChars) {
      return ValidationResult(
        isValid: false,
        error: 'Password must contain uppercase, lowercase, numbers, and special characters',
        errorCode: 'PASSWORD_COMPLEXITY_REQUIREMENT',
      );
    }

    return ValidationResult(isValid: true);
  }

  // File Validation
  static ValidationResult validateFile({
    required String fileName,
    required int fileSize,
    List<String>? allowedExtensions,
    int? maxSizeBytes,
  }) {
    if (fileName.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'File name cannot be empty',
        errorCode: 'EMPTY_FILENAME',
      );
    }

    // Check file extension
    if (allowedExtensions != null && allowedExtensions.isNotEmpty) {
      final extension = fileName.split('.').last.toLowerCase();
      if (!allowedExtensions.contains(extension)) {
        return ValidationResult(
          isValid: false,
          error: 'File type not allowed. Allowed types: ${allowedExtensions.join(', ')}',
          errorCode: 'INVALID_FILE_TYPE',
        );
      }
    }

    // Check file size
    final maxSize = maxSizeBytes ?? AppConstants.maxExportFileSize;
    if (fileSize > maxSize) {
      final maxSizeMB = (maxSize / (1024 * 1024)).toStringAsFixed(1);
      return ValidationResult(
        isValid: false,
        error: 'File size exceeds limit (max ${maxSizeMB}MB)',
        errorCode: 'FILE_TOO_LARGE',
      );
    }

    if (fileSize <= 0) {
      return ValidationResult(
        isValid: false,
        error: 'File appears to be empty',
        errorCode: 'EMPTY_FILE',
      );
    }

    return ValidationResult(isValid: true);
  }

  // JSON Validation
  static ValidationResult validateJson(String jsonString) {
    if (jsonString.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'JSON string cannot be empty',
        errorCode: 'EMPTY_JSON',
      );
    }

    try {
      final decoded = jsonDecode(jsonString);
      if (decoded == null) {
        return ValidationResult(
          isValid: false,
          error: 'JSON decoded to null',
          errorCode: 'NULL_JSON',
        );
      }
      return ValidationResult(isValid: true, data: decoded);
    } catch (e) {
      return ValidationResult(
        isValid: false,
        error: 'Invalid JSON format: ${e.toString()}',
        errorCode: 'INVALID_JSON_FORMAT',
      );
    }
  }

  // Configuration Validation
  static ValidationResult validateAppConfig(Map<String, dynamic> config) {
    final requiredKeys = ['agentId', 'chatbotId', 'baseUrl'];
    
    for (final key in requiredKeys) {
      if (!config.containsKey(key) || config[key] == null) {
        return ValidationResult(
          isValid: false,
          error: 'Missing required configuration key: $key',
          errorCode: 'MISSING_CONFIG_KEY',
        );
      }
    }

    // Validate specific config values
    final agentId = config['agentId'] as String?;
    if (agentId == null || agentId.isEmpty) {
      return ValidationResult(
        isValid: false,
        error: 'Agent ID cannot be empty',
        errorCode: 'INVALID_AGENT_ID',
      );
    }

    final baseUrl = config['baseUrl'] as String?;
    if (baseUrl != null) {
      final urlValidation = validateUrl(baseUrl);
      if (!urlValidation.isValid) {
        return ValidationResult(
          isValid: false,
          error: 'Invalid base URL: ${urlValidation.error}',
          errorCode: 'INVALID_BASE_URL',
        );
      }
    }

    return ValidationResult(isValid: true);
  }

  // Theme Settings Validation
  static ValidationResult validateThemeSettings(Map<String, dynamic> settings) {
    // Validate font size multiplier
    if (settings.containsKey('fontSizeMultiplier')) {
      final fontSize = settings['fontSizeMultiplier'];
      if (fontSize is! double || fontSize < 0.8 || fontSize > 1.5) {
        return ValidationResult(
          isValid: false,
          error: 'Font size multiplier must be between 0.8 and 1.5',
          errorCode: 'INVALID_FONT_SIZE',
        );
      }
    }

    // Validate theme mode
    if (settings.containsKey('themeMode')) {
      final themeMode = settings['themeMode'];
      if (themeMode is! int || themeMode < 0 || themeMode > 4) {
        return ValidationResult(
          isValid: false,
          error: 'Invalid theme mode value',
          errorCode: 'INVALID_THEME_MODE',
        );
      }
    }

    // Validate boolean settings
    final booleanKeys = ['glowEnabled', 'animationsEnabled', 'matrixRainEnabled'];
    for (final key in booleanKeys) {
      if (settings.containsKey(key) && settings[key] is! bool) {
        return ValidationResult(
          isValid: false,
          error: 'Setting $key must be a boolean value',
          errorCode: 'INVALID_BOOLEAN_SETTING',
        );
      }
    }

    return ValidationResult(isValid: true);
  }

  // Input Sanitization
  static String sanitizeInput(String input) {
    return input
        .trim()
        .replaceAll(RegExp(r'\s+'), ' ') // Replace multiple spaces with single space
        .replaceAll(RegExp(r'[^\w\s\-_.,!?()[\]{}:;"\'@#\$%^&*+=<>/\\|`~]'), '') // Remove potentially harmful characters
        .substring(0, input.length > 5000 ? 5000 : input.length); // Limit length
  }

  // Rate Limiting Validation
  static ValidationResult validateRateLimit({
    required int requestCount,
    required Duration timeWindow,
    required int maxRequests,
  }) {
    if (requestCount > maxRequests) {
      final remainingTime = timeWindow.inSeconds;
      return ValidationResult(
        isValid: false,
        error: 'Rate limit exceeded. Try again in $remainingTime seconds.',
        errorCode: 'RATE_LIMIT_EXCEEDED',
        data: {'remainingTime': remainingTime},
      );
    }

    return ValidationResult(isValid: true);
  }

  // Batch Validation
  static List<ValidationResult> validateBatch(
    List<String> inputs,
    ValidationResult Function(String) validator,
  ) {
    return inputs.map(validator).toList();
  }

  // Custom Validation with Callback
  static ValidationResult validateCustom(
    dynamic input,
    bool Function(dynamic) validator,
    String errorMessage,
    String errorCode,
  ) {
    try {
      if (validator(input)) {
        return ValidationResult(isValid: true);
      } else {
        return ValidationResult(
          isValid: false,
          error: errorMessage,
          errorCode: errorCode,
        );
      }
    } catch (e) {
      return ValidationResult(
        isValid: false,
        error: 'Validation error: ${e.toString()}',
        errorCode: 'VALIDATION_EXCEPTION',
      );
    }
  }
}

class ValidationResult {
  final bool isValid;
  final String? error;
  final String? errorCode;
  final dynamic data;

  ValidationResult({
    required this.isValid,
    this.error,
    this.errorCode,
    this.data,
  });

  @override
  String toString() {
    if (isValid) {
      return 'ValidationResult: Valid';
    } else {
      return 'ValidationResult: Invalid - $error ($errorCode)';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'isValid': isValid,
      'error': error,
      'errorCode': errorCode,
      'data': data,
    };
  }
}

// Extension for easy validation chaining
extension ValidationChaining on ValidationResult {
  ValidationResult chain(ValidationResult Function() nextValidation) {
    if (!isValid) return this;
    return nextValidation();
  }
}

// Predefined validators for common use cases
class CommonValidators {
  static final messageValidator = AppValidators.validateMessage;
  static final emailValidator = AppValidators.validateEmail;
  static final urlValidator = AppValidators.validateUrl;
  static final usernameValidator = AppValidators.validateUsername;
  static final passwordValidator = AppValidators.validatePassword;
  static final jsonValidator = AppValidators.validateJson;
}