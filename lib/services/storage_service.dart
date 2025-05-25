import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/chat_message.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _prefs;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // Chat History Management
  Future<bool> saveChatHistory(List<ChatMessage> messages) async {
    try {
      final jsonList = messages.map((message) => message.toJson()).toList();
      final encodedData = AppHelpers.encodeData({'messages': jsonList});
      final success = await _prefs!.setString(AppConstants.chatHistoryKey, encodedData);
      
      AppHelpers.debugLog('Chat history saved: ${messages.length} messages');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to save chat history: $e');
      return false;
    }
  }

  Future<List<ChatMessage>> loadChatHistory() async {
    try {
      final encodedData = _prefs!.getString(AppConstants.chatHistoryKey);
      if (encodedData == null) return [];

      final decodedData = AppHelpers.decodeData(encodedData);
      if (decodedData == null) return [];

      final messagesList = decodedData['messages'] as List<dynamic>;
      final messages = messagesList
          .map((json) => ChatMessage.fromJson(json as Map<String, dynamic>))
          .toList();

      AppHelpers.debugLog('Chat history loaded: ${messages.length} messages');
      return messages;
    } catch (e) {
      AppHelpers.debugError('Failed to load chat history: $e');
      return [];
    }
  }

  Future<bool> clearChatHistory() async {
    try {
      final success = await _prefs!.remove(AppConstants.chatHistoryKey);
      AppHelpers.debugLog('Chat history cleared');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to clear chat history: $e');
      return false;
    }
  }

  // Theme Settings
  Future<bool> saveThemeSettings({
    required int themeMode,
    required bool glowEnabled,
    required bool animationsEnabled,
    required bool matrixRainEnabled,
    required double fontSizeMultiplier,
  }) async {
    try {
      final settings = {
        'themeMode': themeMode,
        'glowEnabled': glowEnabled,
        'animationsEnabled': animationsEnabled,
        'matrixRainEnabled': matrixRainEnabled,
        'fontSizeMultiplier': fontSizeMultiplier,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final encodedData = AppHelpers.encodeData(settings);
      final success = await _prefs!.setString(AppConstants.themeKey, encodedData);
      
      AppHelpers.debugLog('Theme settings saved');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to save theme settings: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadThemeSettings() async {
    try {
      final encodedData = _prefs!.getString(AppConstants.themeKey);
      if (encodedData == null) return null;

      final decodedData = AppHelpers.decodeData(encodedData);
      AppHelpers.debugLog('Theme settings loaded');
      return decodedData;
    } catch (e) {
      AppHelpers.debugError('Failed to load theme settings: $e');
      return null;
    }
  }

  // User Preferences
  Future<bool> saveUserPreferences(Map<String, dynamic> preferences) async {
    try {
      final data = {
        ...preferences,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final encodedData = AppHelpers.encodeData(data);
      final success = await _prefs!.setString(AppConstants.userPrefsKey, encodedData);
      
      AppHelpers.debugLog('User preferences saved');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to save user preferences: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadUserPreferences() async {
    try {
      final encodedData = _prefs!.getString(AppConstants.userPrefsKey);
      if (encodedData == null) return null;

      final decodedData = AppHelpers.decodeData(encodedData);
      AppHelpers.debugLog('User preferences loaded');
      return decodedData;
    } catch (e) {
      AppHelpers.debugError('Failed to load user preferences: $e');
      return null;
    }
  }

  // App Settings
  Future<bool> saveAppSettings(Map<String, dynamic> settings) async {
    try {
      final data = {
        ...settings,
        'version': AppConstants.appVersion,
        'lastUpdated': DateTime.now().toIso8601String(),
      };

      final encodedData = AppHelpers.encodeData(data);
      final success = await _prefs!.setString(AppConstants.settingsKey, encodedData);
      
      AppHelpers.debugLog('App settings saved');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to save app settings: $e');
      return false;
    }
  }

  Future<Map<String, dynamic>?> loadAppSettings() async {
    try {
      final encodedData = _prefs!.getString(AppConstants.settingsKey);
      if (encodedData == null) return null;

      final decodedData = AppHelpers.decodeData(encodedData);
      AppHelpers.debugLog('App settings loaded');
      return decodedData;
    } catch (e) {
      AppHelpers.debugError('Failed to load app settings: $e');
      return null;
    }
  }

  // Simple Key-Value Storage
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs!.setString(key, value);
    } catch (e) {
      AppHelpers.debugError('Failed to set string: $e');
      return false;
    }
  }

  String? getString(String key, {String? defaultValue}) {
    try {
      return _prefs!.getString(key) ?? defaultValue;
    } catch (e) {
      AppHelpers.debugError('Failed to get string: $e');
      return defaultValue;
    }
  }

  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs!.setInt(key, value);
    } catch (e) {
      AppHelpers.debugError('Failed to set int: $e');
      return false;
    }
  }

  int? getInt(String key, {int? defaultValue}) {
    try {
      return _prefs!.getInt(key) ?? defaultValue;
    } catch (e) {
      AppHelpers.debugError('Failed to get int: $e');
      return defaultValue;
    }
  }

  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs!.setBool(key, value);
    } catch (e) {
      AppHelpers.debugError('Failed to set bool: $e');
      return false;
    }
  }

  bool? getBool(String key, {bool? defaultValue}) {
    try {
      return _prefs!.getBool(key) ?? defaultValue;
    } catch (e) {
      AppHelpers.debugError('Failed to get bool: $e');
      return defaultValue;
    }
  }

  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs!.setDouble(key, value);
    } catch (e) {
      AppHelpers.debugError('Failed to set double: $e');
      return false;
    }
  }

  double? getDouble(String key, {double? defaultValue}) {
    try {
      return _prefs!.getDouble(key) ?? defaultValue;
    } catch (e) {
      AppHelpers.debugError('Failed to get double: $e');
      return defaultValue;
    }
  }

  // Batch Operations
  Future<bool> setMultiple(Map<String, dynamic> data) async {
    try {
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _prefs!.setString(key, value);
        } else if (value is int) {
          await _prefs!.setInt(key, value);
        } else if (value is bool) {
          await _prefs!.setBool(key, value);
        } else if (value is double) {
          await _prefs!.setDouble(key, value);
        } else {
          // Convert complex objects to JSON string
          await _prefs!.setString(key, jsonEncode(value));
        }
      }
      
      AppHelpers.debugLog('Multiple values set: ${data.length} items');
      return true;
    } catch (e) {
      AppHelpers.debugError('Failed to set multiple values: $e');
      return false;
    }
  }

  Map<String, dynamic> getMultiple(List<String> keys) {
    final result = <String, dynamic>{};
    
    try {
      for (final key in keys) {
        final value = _prefs!.get(key);
        if (value != null) {
          result[key] = value;
        }
      }
      
      AppHelpers.debugLog('Multiple values retrieved: ${result.length} items');
    } catch (e) {
      AppHelpers.debugError('Failed to get multiple values: $e');
    }
    
    return result;
  }

  // Utility Methods
  Future<bool> remove(String key) async {
    try {
      final success = await _prefs!.remove(key);
      AppHelpers.debugLog('Key removed: $key');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to remove key: $e');
      return false;
    }
  }

  Future<bool> clear() async {
    try {
      final success = await _prefs!.clear();
      AppHelpers.debugLog('All storage cleared');
      return success;
    } catch (e) {
      AppHelpers.debugError('Failed to clear storage: $e');
      return false;
    }
  }

  bool containsKey(String key) {
    try {
      return _prefs!.containsKey(key);
    } catch (e) {
      AppHelpers.debugError('Failed to check key existence: $e');
      return false;
    }
  }

  Set<String> getAllKeys() {
    try {
      return _prefs!.getKeys();
    } catch (e) {
      AppHelpers.debugError('Failed to get all keys: $e');
      return <String>{};
    }
  }

  // Storage Statistics
  Map<String, dynamic> getStorageStats() {
    try {
      final keys = getAllKeys();
      final stats = <String, dynamic>{
        'totalKeys': keys.length,
        'keys': keys.toList(),
        'chatHistoryExists': containsKey(AppConstants.chatHistoryKey),
        'themeSettingsExists': containsKey(AppConstants.themeKey),
        'userPreferencesExists': containsKey(AppConstants.userPrefsKey),
        'appSettingsExists': containsKey(AppConstants.settingsKey),
        'timestamp': DateTime.now().toIso8601String(),
      };

      // Calculate approximate storage size
      int totalSize = 0;
      for (final key in keys) {
        final value = _prefs!.get(key);
        if (value is String) {
          totalSize += value.length * 2; // Rough UTF-16 estimation
        }
      }
      stats['approximateSize'] = totalSize;
      stats['approximateSizeKB'] = (totalSize / 1024).toStringAsFixed(2);

      return stats;
    } catch (e) {
      AppHelpers.debugError('Failed to get storage stats: $e');
      return {
        'error': 'Failed to calculate storage statistics',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  // Backup and Restore
  Future<Map<String, dynamic>> exportAllData() async {
    try {
      final keys = getAllKeys();
      final exportData = <String, dynamic>{
        'exportDate': DateTime.now().toIso8601String(),
        'appVersion': AppConstants.appVersion,
        'dataVersion': '1.0',
        'data': {},
      };

      for (final key in keys) {
        final value = _prefs!.get(key);
        exportData['data'][key] = value;
      }

      AppHelpers.debugLog('Data exported: ${keys.length} keys');
      return exportData;
    } catch (e) {
      AppHelpers.debugError('Failed to export data: $e');
      return {
        'error': 'Export failed',
        'timestamp': DateTime.now().toIso8601String(),
      };
    }
  }

  Future<bool> importAllData(Map<String, dynamic> importData) async {
    try {
      final data = importData['data'] as Map<String, dynamic>?;
      if (data == null) return false;

      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _prefs!.setString(key, value);
        } else if (value is int) {
          await _prefs!.setInt(key, value);
        } else if (value is bool) {
          await _prefs!.setBool(key, value);
        } else if (value is double) {
          await _prefs!.setDouble(key, value);
        }
      }

      AppHelpers.debugLog('Data imported: ${data.length} keys');
      return true;
    } catch (e) {
      AppHelpers.debugError('Failed to import data: $e');
      return false;
    }
  }
}