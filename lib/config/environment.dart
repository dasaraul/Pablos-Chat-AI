import 'package:flutter/foundation.dart';

enum Environment {
  development,
  staging,
  production,
}

class EnvironmentConfig {
  static Environment _currentEnvironment = _getEnvironment();
  
  // Environment Detection
  static Environment _getEnvironment() {
    if (kDebugMode) {
      return Environment.development;
    }
    
    // Check for build constants or environment variables
    const envString = String.fromEnvironment('ENVIRONMENT', defaultValue: 'production');
    
    switch (envString.toLowerCase()) {
      case 'development':
      case 'dev':
        return Environment.development;
      case 'staging':
      case 'stage':
        return Environment.staging;
      case 'production':
      case 'prod':
      default:
        return Environment.production;
    }
  }
  
  // Environment Properties
  static Environment get currentEnvironment => _currentEnvironment;
  static bool get isDevelopment => _currentEnvironment == Environment.development;
  static bool get isStaging => _currentEnvironment == Environment.staging;
  static bool get isProduction => _currentEnvironment == Environment.production;
  
  // API Configuration
  static String get baseUrl {
    switch (_currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment(
          'DEV_API_URL',
          defaultValue: 'https://dev-api.pablos.local',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'STAGING_API_URL',
          defaultValue: 'https://staging-api.pablos.ai',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'PROD_API_URL',
          defaultValue: 'https://wnkqkhbxixel3rjeb66derpx.agents.do-ai.run',
        );
    }
  }
  
  static String get agentId {
    switch (_currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment(
          'DEV_AGENT_ID',
          defaultValue: 'dev-agent-id-123',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'STAGING_AGENT_ID',
          defaultValue: 'staging-agent-id-456',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'PROD_AGENT_ID',
          defaultValue: '6c58e25c-3913-11f0-bf8f-4e013e2ddde4',
        );
    }
  }
  
  static String get chatbotId {
    switch (_currentEnvironment) {
      case Environment.development:
        return const String.fromEnvironment(
          'DEV_CHATBOT_ID',
          defaultValue: 'dev-chatbot-id-789',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'STAGING_CHATBOT_ID',
          defaultValue: 'staging-chatbot-id-012',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'PROD_CHATBOT_ID',
          defaultValue: 'SKmeFU5N3XgR9bdQ16Nwl86jsj2df73Q',
        );
    }
  }
  
  // API Keys and Secrets
  static String get apiKey {
    return const String.fromEnvironment(
      'API_KEY',
      defaultValue: '',
    );
  }
  
  static String get apiSecret {
    return const String.fromEnvironment(
      'API_SECRET',
      defaultValue: '',
    );
  }
  
  static String get encryptionKey {
    return const String.fromEnvironment(
      'ENCRYPTION_KEY',
      defaultValue: 'default-encryption-key-change-in-production',
    );
  }
  
  // Feature Flags by Environment
  static bool get enableLogging {
    switch (_currentEnvironment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
  
  static bool get enableDebugMode {
    switch (_currentEnvironment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
  
  static bool get enableAnalytics {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return false;
      case Environment.production:
        return const bool.fromEnvironment('ENABLE_ANALYTICS', defaultValue: false);
    }
  }
  
  static bool get enableCrashReporting {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static bool get enablePerformanceMonitoring {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static bool get enableExperimentalFeatures {
    switch (_currentEnvironment) {
      case Environment.development:
        return true;
      case Environment.staging:
        return true;
      case Environment.production:
        return false;
    }
  }
  
  // Network Configuration
  static int get connectionTimeout {
    switch (_currentEnvironment) {
      case Environment.development:
        return 60; // Longer timeout for development
      case Environment.staging:
        return 45;
      case Environment.production:
        return 30;
    }
  }
  
  static int get maxRetryAttempts {
    switch (_currentEnvironment) {
      case Environment.development:
        return 5;
      case Environment.staging:
        return 3;
      case Environment.production:
        return 3;
    }
  }
  
  // Database Configuration (if needed)
  static String get databaseUrl {
    return const String.fromEnvironment(
      'DATABASE_URL',
      defaultValue: '',
    );
  }
  
  static String get databaseName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'pablos_dev';
      case Environment.staging:
        return 'pablos_staging';
      case Environment.production:
        return 'pablos_prod';
    }
  }
  
  // Storage Configuration
  static String get storagePrefix {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'pablos_dev_';
      case Environment.staging:
        return 'pablos_staging_';
      case Environment.production:
        return 'pablos_';
    }
  }
  
  // Third-party Service Configuration
  static String get sentryDsn {
    return const String.fromEnvironment(
      'SENTRY_DSN',
      defaultValue: '',
    );
  }
  
  static String get mixpanelToken {
    return const String.fromEnvironment(
      'MIXPANEL_TOKEN',
      defaultValue: '',
    );
  }
  
  static String get firebaseProjectId {
    return const String.fromEnvironment(
      'FIREBASE_PROJECT_ID',
      defaultValue: '',
    );
  }
  
  // App Configuration by Environment
  static String get appName {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'PABLOS Dev';
      case Environment.staging:
        return 'PABLOS Staging';
      case Environment.production:
        return 'PABLOS';
    }
  }
  
  static String get appSuffix {
    switch (_currentEnvironment) {
      case Environment.development:
        return '.dev';
      case Environment.staging:
        return '.staging';
      case Environment.production:
        return '';
    }
  }
  
  // Build Configuration
  static String get buildType {
    switch (_currentEnvironment) {
      case Environment.development:
        return 'debug';
      case Environment.staging:
        return 'release';
      case Environment.production:
        return 'release';
    }
  }
  
  static bool get minifyEnabled {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  // Security Configuration
  static bool get enableCertificatePinning {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return true;
      case Environment.production:
        return true;
    }
  }
  
  static bool get enableRequestSigning {
    switch (_currentEnvironment) {
      case Environment.development:
        return false;
      case Environment.staging:
        return false;
      case Environment.production:
        return const bool.fromEnvironment('ENABLE_REQUEST_SIGNING', defaultValue: false);
    }
  }
  
  // Custom Environment Variables
  static String getCustomString(String key, String defaultValue) {
    return String.fromEnvironment(key, defaultValue: defaultValue);
  }
  
  static bool getCustomBool(String key, bool defaultValue) {
    return bool.fromEnvironment(key, defaultValue: defaultValue);
  }
  
  static int getCustomInt(String key, int defaultValue) {
    return int.fromEnvironment(key, defaultValue: defaultValue);
  }
  
  // Environment Info
  static Map<String, dynamic> getEnvironmentInfo() {
    return {
      'environment': _currentEnvironment.toString().split('.').last,
      'is_development': isDevelopment,
      'is_staging': isStaging,
      'is_production': isProduction,
      'base_url': baseUrl,
      'agent_id': agentId,
      'chatbot_id': chatbotId,
      'app_name': appName,
      'build_type': buildType,
              'features': {
        'logging': enableLogging,
        'debug_mode': enableDebugMode,
        'analytics': enableAnalytics,
        'crash_reporting': enableCrashReporting,
        'performance_monitoring': enablePerformanceMonitoring,
        'experimental_features': enableExperimentalFeatures,
      },
      'network': {
        'connection_timeout': connectionTimeout,
        'max_retry_attempts': maxRetryAttempts,
      },
      'security': {
        'certificate_pinning': enableCertificatePinning,
        'request_signing': enableRequestSigning,
      },
    };
  }
  
  // Validation
  static bool validateConfiguration() {
    final issues = <String>[];
    
    if (baseUrl.isEmpty) {
      issues.add('Base URL is not configured');
    }
    
    if (agentId.isEmpty) {
      issues.add('Agent ID is not configured');
    }
    
    if (chatbotId.isEmpty) {
      issues.add('Chatbot ID is not configured');
    }
    
    if (isProduction && apiKey.isEmpty) {
      issues.add('API Key is required for production');
    }
    
    if (issues.isNotEmpty) {
      if (enableLogging) {
        print('Configuration issues found:');
        for (final issue in issues) {
          print('- $issue');
        }
      }
      return false;
    }
    
    return true;
  }
  
  // Override Environment (for testing)
  static void setEnvironment(Environment environment) {
    _currentEnvironment = environment;
  }
  
  // Reset to detected environment
  static void resetEnvironment() {
    _currentEnvironment = _getEnvironment();
  }
}