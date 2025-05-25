import 'package:flutter/foundation.dart';
import '../utils/constants.dart';

class AppConfig {
  // App Information
  static const String appName = AppConstants.appName;
  static const String appVersion = AppConstants.appVersion;
  static const String appDescription = AppConstants.appDescription;
  static const String author = AppConstants.author;
  
  // Build Configuration
  static const String buildNumber = '1';
  static const String buildDate = '2024-12-01';
  static const String buildEnvironment = kDebugMode ? 'debug' : 'release';
  
  // Platform Configuration
  static bool get isAndroid => defaultTargetPlatform == TargetPlatform.android;
  static bool get isIOS => defaultTargetPlatform == TargetPlatform.iOS;
  static bool get isWeb => kIsWeb;
  static bool get isDesktop => 
    defaultTargetPlatform == TargetPlatform.windows ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.linux;
  
  // Feature Configuration
  static const Map<String, bool> features = {
    // Core Features
    'chat_enabled': true,
    'ai_integration': true,
    'offline_mode': true,
    'local_storage': true,
    
    // UI Features
    'theme_switching': true,
    'dark_mode_only': true,
    'matrix_rain_effect': true,
    'glitch_animations': true,
    'glow_effects': true,
    'haptic_feedback': true,
    
    // Advanced Features
    'file_export': true,
    'chat_history': true,
    'settings_backup': true,
    'debug_mode': kDebugMode,
    
    // Experimental Features
    'voice_chat': false,
    'image_sharing': false,
    'multi_language': false,
    'plugins': false,
  };
  
  // Theme Configuration
  static const Map<String, dynamic> themeConfig = {
    'default_theme': 'classic',
    'available_themes': [
      'classic',
      'red_hat',
      'blue_team',
      'matrix',
      'cyberpunk',
    ],
    'theme_switching_enabled': true,
    'auto_theme_detection': false,
    'system_theme_sync': false,
  };
  
  // Animation Configuration
  static const Map<String, dynamic> animationConfig = {
    'splash_duration': AppConstants.splashDuration,
    'typing_delay': AppConstants.typingDelay,
    'message_animation_duration': AppConstants.messageAnimationDuration,
    'glitch_animation_duration': AppConstants.glitchAnimationDuration,
    'scanline_animation_duration': AppConstants.scanlineAnimationDuration,
    'enable_reduced_motion': false,
    'high_performance_mode': false,
  };
  
  // Storage Configuration
  static const Map<String, dynamic> storageConfig = {
    'max_chat_history': AppConstants.maxChatHistory,
    'auto_cleanup_enabled': true,
    'cleanup_interval_days': 30,
    'backup_enabled': true,
    'compression_enabled': true,
    'encryption_enabled': false, // Would require additional setup
  };
  
  // Network Configuration
  static const Map<String, dynamic> networkConfig = {
    'connection_timeout': AppConstants.connectionTimeout,
    'typing_indicator_timeout': AppConstants.typingIndicatorTimeout,
    'max_retry_attempts': AppConstants.maxRetryAttempts,
    'retry_delay': AppConstants.retryDelay,
    'offline_support': true,
    'background_sync': false,
  };
  
  // Privacy Configuration
  static const Map<String, dynamic> privacyConfig = {
    'analytics_enabled': AppConstants.enableAnalytics,
    'crash_reporting': kDebugMode,
    'usage_statistics': false,
    'data_collection_minimal': true,
    'local_processing_preferred': true,
    'gdpr_compliant': true,
  };
  
  // Security Configuration
  static const Map<String, dynamic> securityConfig = {
    'input_validation': true,
    'output_sanitization': true,
    'rate_limiting': true,
    'spam_detection': true,
    'content_filtering': true,
    'secure_storage': true,
  };
  
  // Accessibility Configuration
  static const Map<String, dynamic> accessibilityConfig = {
    'font_scaling': true,
    'min_font_size': AppConstants.minFontSize,
    'max_font_size': AppConstants.maxFontSize,
    'high_contrast_support': true,
    'screen_reader_support': true,
    'keyboard_navigation': true,
  };
  
  // Performance Configuration
  static const Map<String, dynamic> performanceConfig = {
    'lazy_loading': true,
    'image_caching': true,
    'memory_optimization': true,
    'battery_optimization': true,
    'frame_rate_limit': 60,
    'gpu_acceleration': true,
  };
  
  // PABLOS Specific Configuration
  static const Map<String, dynamic> pablosConfig = {
    'personality': {
      'name': 'PABLOS',
      'full_name': 'PABLOS "Tama The God"',
      'creator': 'Tama The God',
      'language_style': 'bahasa_jaksel',
      'personality_traits': [
        'friendly',
        'professional',
        'empathetic',
        'technical',
        'supportive',
      ],
    },
    'expertise': {
      'primary_domains': [
        'digital_ocean',
        'cybersecurity',
        'web_development',
        'academic_support',
      ],
      'secondary_domains': [
        'general_chat',
        'life_advice',
        'technical_troubleshooting',
        'learning_support',
      ],
    },
    'response_style': {
      'use_jaksel': true,
      'personal_pronouns': {
        'first_person': 'gw',
        'second_person': 'elu',
      },
      'common_expressions': [
        'literally',
        'whichis',
        'basically',
      ],
      'creator_references': [
        'bos gw Tama',
        'Tama The God',
      ],
    },
  };
  
  // Logging Configuration
  static const Map<String, dynamic> loggingConfig = {
    'enable_logging': AppConstants.enableDebugMode,
    'log_level': kDebugMode ? 'debug' : 'info',
    'log_to_file': false,
    'log_rotation': true,
    'max_log_files': 5,
    'max_log_size_mb': 10,
  };
  
  // Development Configuration
  static const Map<String, dynamic> developmentConfig = {
    'debug_mode': kDebugMode,
    'show_debug_info': kDebugMode,
    'enable_inspector': kDebugMode,
    'hot_reload': kDebugMode,
    'performance_overlay': false,
    'show_fps': false,
  };
  
  // Platform-specific Configuration
  static Map<String, dynamic> get platformConfig => {
    'android': {
      'min_sdk_version': 21,
      'target_sdk_version': 34,
      'support_material_you': true,
      'edge_to_edge': true,
    },
    'ios': {
      'min_ios_version': '12.0',
      'support_dark_mode': true,
      'support_dynamic_type': true,
    },
    'web': {
      'pwa_enabled': true,
      'offline_support': true,
      'responsive_design': true,
    },
    'desktop': {
      'window_management': true,
      'system_integration': true,
      'native_styling': true,
    },
  };
  
  // Error Handling Configuration
  static const Map<String, dynamic> errorHandlingConfig = {
    'show_error_details': kDebugMode,
    'error_reporting': kDebugMode,
    'fallback_responses': true,
    'graceful_degradation': true,
    'retry_logic': true,
    'user_friendly_messages': true,
  };
  
  // Utility Methods
  static bool isFeatureEnabled(String feature) {
    return features[feature] ?? false;
  }
  
  static T getConfig<T>(String category, String key, T defaultValue) {
    final configs = {
      'theme': themeConfig,
      'animation': animationConfig,
      'storage': storageConfig,
      'network': networkConfig,
      'privacy': privacyConfig,
      'security': securityConfig,
      'accessibility': accessibilityConfig,
      'performance': performanceConfig,
      'pablos': pablosConfig,
      'logging': loggingConfig,
      'development': developmentConfig,
      'error_handling': errorHandlingConfig,
    };
    
    final config = configs[category];
    if (config != null && config.containsKey(key)) {
      return config[key] as T;
    }
    return defaultValue;
  }
  
  static Map<String, dynamic> getAllConfigs() {
    return {
      'app': {
        'name': appName,
        'version': appVersion,
        'build_number': buildNumber,
        'build_date': buildDate,
        'build_environment': buildEnvironment,
      },
      'platform': {
        'is_android': isAndroid,
        'is_ios': isIOS,
        'is_web': isWeb,
        'is_desktop': isDesktop,
      },
      'features': features,
      'theme': themeConfig,
      'animation': animationConfig,
      'storage': storageConfig,
      'network': networkConfig,
      'privacy': privacyConfig,
      'security': securityConfig,
      'accessibility': accessibilityConfig,
      'performance': performanceConfig,
      'pablos': pablosConfig,
      'logging': loggingConfig,
      'development': developmentConfig,
      'platform_specific': platformConfig,
      'error_handling': errorHandlingConfig,
    };
  }
  
  static String getAppInfo() {
    return '$appName v$appVersion ($buildNumber) - $buildEnvironment';
  }
  
  static String getPlatformInfo() {
    if (isAndroid) return 'Android';
    if (isIOS) return 'iOS';
    if (isWeb) return 'Web';
    if (isDesktop) {
      if (defaultTargetPlatform == TargetPlatform.windows) return 'Windows';
      if (defaultTargetPlatform == TargetPlatform.macOS) return 'macOS';
      if (defaultTargetPlatform == TargetPlatform.linux) return 'Linux';
    }
    return 'Unknown';
  }
}