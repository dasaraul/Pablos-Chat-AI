import 'package:flutter/foundation.dart';

enum UserRole {
  user,
  admin,
  developer,
  tester,
}

enum UserStatus {
  active,
  inactive,
  suspended,
  pending,
}

enum UserPreferredLanguage {
  english,
  indonesian,
  bahasaJaksel,
}

class UserModel {
  final String id;
  final String username;
  final String? email;
  final String? displayName;
  final String? avatarUrl;
  final UserRole role;
  final UserStatus status;
  final UserPreferredLanguage preferredLanguage;
  final DateTime createdAt;
  final DateTime? lastActiveAt;
  final UserPreferences preferences;
  final UserStats stats;
  final Map<String, dynamic>? metadata;

  UserModel({
    required this.id,
    required this.username,
    this.email,
    this.displayName,
    this.avatarUrl,
    this.role = UserRole.user,
    this.status = UserStatus.active,
    this.preferredLanguage = UserPreferredLanguage.bahasaJaksel,
    required this.createdAt,
    this.lastActiveAt,
    required this.preferences,
    required this.stats,
    this.metadata,
  });

  // Factory constructors
  factory UserModel.defaultUser() {
    final now = DateTime.now();
    return UserModel(
      id: 'default_user_${now.millisecondsSinceEpoch}',
      username: 'anonymous_user',
      displayName: 'Anonymous User',
      createdAt: now,
      lastActiveAt: now,
      preferences: UserPreferences.defaultPreferences(),
      stats: UserStats.empty(),
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      username: json['username'] as String,
      email: json['email'] as String?,
      displayName: json['display_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      role: UserRole.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => UserRole.user,
      ),
      status: UserStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => UserStatus.active,
      ),
      preferredLanguage: UserPreferredLanguage.values.firstWhere(
        (e) => e.name == json['preferred_language'],
        orElse: () => UserPreferredLanguage.bahasaJaksel,
      ),
      createdAt: DateTime.parse(json['created_at'] as String),
      lastActiveAt: json['last_active_at'] != null
          ? DateTime.parse(json['last_active_at'] as String)
          : null,
      preferences: UserPreferences.fromJson(
        json['preferences'] as Map<String, dynamic>? ?? {},
      ),
      stats: UserStats.fromJson(
        json['stats'] as Map<String, dynamic>? ?? {},
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Methods
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'display_name': displayName,
      'avatar_url': avatarUrl,
      'role': role.name,
      'status': status.name,
      'preferred_language': preferredLanguage.name,
      'created_at': createdAt.toIso8601String(),
      'last_active_at': lastActiveAt?.toIso8601String(),
      'preferences': preferences.toJson(),
      'stats': stats.toJson(),
      'metadata': metadata,
    };
  }

  UserModel copyWith({
    String? id,
    String? username,
    String? email,
    String? displayName,
    String? avatarUrl,
    UserRole? role,
    UserStatus? status,
    UserPreferredLanguage? preferredLanguage,
    DateTime? createdAt,
    DateTime? lastActiveAt,
    UserPreferences? preferences,
    UserStats? stats,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      status: status ?? this.status,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      createdAt: createdAt ?? this.createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      preferences: preferences ?? this.preferences,
      stats: stats ?? this.stats,
      metadata: metadata ?? this.metadata,
    );
  }

  // Computed properties
  String get displayNameOrUsername => displayName ?? username;
  
  bool get isActive => status == UserStatus.active;
  bool get isAdmin => role == UserRole.admin;
  bool get isDeveloper => role == UserRole.developer;
  
  bool get hasEmail => email != null && email!.isNotEmpty;
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;
  
  Duration? get timeSinceLastActive {
    if (lastActiveAt == null) return null;
    return DateTime.now().difference(lastActiveAt!);
  }
  
  Duration get accountAge => DateTime.now().difference(createdAt);
  
  bool get isNewUser => accountAge.inDays < 7;
  bool get isRecentlyActive {
    final timeSince = timeSinceLastActive;
    return timeSince != null && timeSince.inMinutes < 30;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'UserModel{id: $id, username: $username, role: $role, status: $status}';
  }
}

class UserPreferences {
  final String themeMode;
  final bool darkModeEnabled;
  final bool glowEffectsEnabled;
  final bool animationsEnabled;
  final bool matrixRainEnabled;
  final bool hapticFeedbackEnabled;
  final bool soundEffectsEnabled;
  final double fontSizeMultiplier;
  final bool notificationsEnabled;
  final bool autoSaveEnabled;
  final int maxChatHistory;
  final Map<String, dynamic> customSettings;

  UserPreferences({
    this.themeMode = 'classic',
    this.darkModeEnabled = true,
    this.glowEffectsEnabled = true,
    this.animationsEnabled = true,
    this.matrixRainEnabled = false,
    this.hapticFeedbackEnabled = true,
    this.soundEffectsEnabled = false,
    this.fontSizeMultiplier = 1.0,
    this.notificationsEnabled = true,
    this.autoSaveEnabled = true,
    this.maxChatHistory = 1000,
    this.customSettings = const {},
  });

  factory UserPreferences.defaultPreferences() {
    return UserPreferences();
  }

  factory UserPreferences.fromJson(Map<String, dynamic> json) {
    return UserPreferences(
      themeMode: json['theme_mode'] as String? ?? 'classic',
      darkModeEnabled: json['dark_mode_enabled'] as bool? ?? true,
      glowEffectsEnabled: json['glow_effects_enabled'] as bool? ?? true,
      animationsEnabled: json['animations_enabled'] as bool? ?? true,
      matrixRainEnabled: json['matrix_rain_enabled'] as bool? ?? false,
      hapticFeedbackEnabled: json['haptic_feedback_enabled'] as bool? ?? true,
      soundEffectsEnabled: json['sound_effects_enabled'] as bool? ?? false,
      fontSizeMultiplier: (json['font_size_multiplier'] as num?)?.toDouble() ?? 1.0,
      notificationsEnabled: json['notifications_enabled'] as bool? ?? true,
      autoSaveEnabled: json['auto_save_enabled'] as bool? ?? true,
      maxChatHistory: json['max_chat_history'] as int? ?? 1000,
      customSettings: json['custom_settings'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'theme_mode': themeMode,
      'dark_mode_enabled': darkModeEnabled,
      'glow_effects_enabled': glowEffectsEnabled,
      'animations_enabled': animationsEnabled,
      'matrix_rain_enabled': matrixRainEnabled,
      'haptic_feedback_enabled': hapticFeedbackEnabled,
      'sound_effects_enabled': soundEffectsEnabled,
      'font_size_multiplier': fontSizeMultiplier,
      'notifications_enabled': notificationsEnabled,
      'auto_save_enabled': autoSaveEnabled,
      'max_chat_history': maxChatHistory,
      'custom_settings': customSettings,
    };
  }

  UserPreferences copyWith({
    String? themeMode,
    bool? darkModeEnabled,
    bool? glowEffectsEnabled,
    bool? animationsEnabled,
    bool? matrixRainEnabled,
    bool? hapticFeedbackEnabled,
    bool? soundEffectsEnabled,
    double? fontSizeMultiplier,
    bool? notificationsEnabled,
    bool? autoSaveEnabled,
    int? maxChatHistory,
    Map<String, dynamic>? customSettings,
  }) {
    return UserPreferences(
      themeMode: themeMode ?? this.themeMode,
      darkModeEnabled: darkModeEnabled ?? this.darkModeEnabled,
      glowEffectsEnabled: glowEffectsEnabled ?? this.glowEffectsEnabled,
      animationsEnabled: animationsEnabled ?? this.animationsEnabled,
      matrixRainEnabled: matrixRainEnabled ?? this.matrixRainEnabled,
      hapticFeedbackEnabled: hapticFeedbackEnabled ?? this.hapticFeedbackEnabled,
      soundEffectsEnabled: soundEffectsEnabled ?? this.soundEffectsEnabled,
      fontSizeMultiplier: fontSizeMultiplier ?? this.fontSizeMultiplier,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      autoSaveEnabled: autoSaveEnabled ?? this.autoSaveEnabled,
      maxChatHistory: maxChatHistory ?? this.maxChatHistory,
      customSettings: customSettings ?? this.customSettings,
    );
  }
}

class UserStats {
  final int totalMessages;
  final int totalSessions;
  final int totalTimeSpentMinutes;
  final DateTime? firstMessageAt;
  final DateTime? lastMessageAt;
  final Map<String, int> messagesByType;
  final Map<String, int> featureUsageCount;
  final int streakDays;
  final int maxStreakDays;
  final List<String> achievements;
  final Map<String, dynamic> customStats;

  UserStats({
    this.totalMessages = 0,
    this.totalSessions = 0,
    this.totalTimeSpentMinutes = 0,
    this.firstMessageAt,
    this.lastMessageAt,
    this.messagesByType = const {},
    this.featureUsageCount = const {},
    this.streakDays = 0,
    this.maxStreakDays = 0,
    this.achievements = const [],
    this.customStats = const {},
  });

  factory UserStats.empty() {
    return UserStats();
  }

  factory UserStats.fromJson(Map<String, dynamic> json) {
    return UserStats(
      totalMessages: json['total_messages'] as int? ?? 0,
      totalSessions: json['total_sessions'] as int? ?? 0,
      totalTimeSpentMinutes: json['total_time_spent_minutes'] as int? ?? 0,
      firstMessageAt: json['first_message_at'] != null
          ? DateTime.parse(json['first_message_at'] as String)
          : null,
      lastMessageAt: json['last_message_at'] != null
          ? DateTime.parse(json['last_message_at'] as String)
          : null,
      messagesByType: Map<String, int>.from(json['messages_by_type'] as Map? ?? {}),
      featureUsageCount: Map<String, int>.from(json['feature_usage_count'] as Map? ?? {}),
      streakDays: json['streak_days'] as int? ?? 0,
      maxStreakDays: json['max_streak_days'] as int? ?? 0,
      achievements: List<String>.from(json['achievements'] as List? ?? []),
      customStats: json['custom_stats'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_messages': totalMessages,
      'total_sessions': totalSessions,
      'total_time_spent_minutes': totalTimeSpentMinutes,
      'first_message_at': firstMessageAt?.toIso8601String(),
      'last_message_at': lastMessageAt?.toIso8601String(),
      'messages_by_type': messagesByType,
      'feature_usage_count': featureUsageCount,
      'streak_days': streakDays,
      'max_streak_days': maxStreakDays,
      'achievements': achievements,
      'custom_stats': customStats,
    };
  }

  UserStats copyWith({
    int? totalMessages,
    int? totalSessions,
    int? totalTimeSpentMinutes,
    DateTime? firstMessageAt,
    DateTime? lastMessageAt,
    Map<String, int>? messagesByType,
    Map<String, int>? featureUsageCount,
    int? streakDays,
    int? maxStreakDays,
    List<String>? achievements,
    Map<String, dynamic>? customStats,
  }) {
    return UserStats(
      totalMessages: totalMessages ?? this.totalMessages,
      totalSessions: totalSessions ?? this.totalSessions,
      totalTimeSpentMinutes: totalTimeSpentMinutes ?? this.totalTimeSpentMinutes,
      firstMessageAt: firstMessageAt ?? this.firstMessageAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      messagesByType: messagesByType ?? this.messagesByType,
      featureUsageCount: featureUsageCount ?? this.featureUsageCount,
      streakDays: streakDays ?? this.streakDays,
      maxStreakDays: maxStreakDays ?? this.maxStreakDays,
      achievements: achievements ?? this.achievements,
      customStats: customStats ?? this.customStats,
    );
  }

  // Computed properties
  double get averageMessagesPerSession {
    if (totalSessions == 0) return 0.0;
    return totalMessages / totalSessions;
  }

  double get averageTimePerSession {
    if (totalSessions == 0) return 0.0;
    return totalTimeSpentMinutes / totalSessions;
  }

  bool get isActiveUser => totalMessages > 10 && totalSessions > 3;
  bool get isPowerUser => totalMessages > 100 && totalSessions > 20;
  
  String get userLevel {
    if (totalMessages < 10) return 'Beginner';
    if (totalMessages < 50) return 'Regular';
    if (totalMessages < 200) return 'Advanced';
    return 'Expert';
  }
}