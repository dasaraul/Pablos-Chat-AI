import 'package:flutter/foundation.dart';

enum ResponseType {
  text,
  code,
  list,
  structured,
  error,
  system,
}

enum ResponseStatus {
  success,
  partial,
  failed,
  timeout,
  rateLimited,
}

enum ResponseConfidence {
  high,
  medium,
  low,
  uncertain,
}

enum ResponseCategory {
  general,
  technical,
  security,
  academic,
  development,
  personal,
  greeting,
  farewell,
}

class AIResponseModel {
  final String id;
  final String text;
  final ResponseType type;
  final ResponseStatus status;
  final ResponseConfidence confidence;
  final ResponseCategory category;
  final DateTime timestamp;
  final int processingTimeMs;
  final Map<String, dynamic>? metadata;
  final List<String>? suggestions;
  final List<ResponseAction>? actions;
  final ResponseContext? context;
  final ResponseAnalytics? analytics;

  AIResponseModel({
    required this.id,
    required this.text,
    this.type = ResponseType.text,
    this.status = ResponseStatus.success,
    this.confidence = ResponseConfidence.medium,
    this.category = ResponseCategory.general,
    required this.timestamp,
    this.processingTimeMs = 0,
    this.metadata,
    this.suggestions,
    this.actions,
    this.context,
    this.analytics,
  });

  factory AIResponseModel.fromJson(Map<String, dynamic> json) {
    return AIResponseModel(
      id: json['id'] as String,
      text: json['text'] as String,
      type: ResponseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ResponseType.text,
      ),
      status: ResponseStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ResponseStatus.success,
      ),
      confidence: ResponseConfidence.values.firstWhere(
        (e) => e.name == json['confidence'],
        orElse: () => ResponseConfidence.medium,
      ),
      category: ResponseCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ResponseCategory.general,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      processingTimeMs: json['processing_time_ms'] as int? ?? 0,
      metadata: json['metadata'] as Map<String, dynamic>?,
      suggestions: (json['suggestions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      actions: (json['actions'] as List<dynamic>?)
          ?.map((e) => ResponseAction.fromJson(e as Map<String, dynamic>))
          .toList(),
      context: json['context'] != null
          ? ResponseContext.fromJson(json['context'] as Map<String, dynamic>)
          : null,
      analytics: json['analytics'] != null
          ? ResponseAnalytics.fromJson(json['analytics'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'type': type.name,
      'status': status.name,
      'confidence': confidence.name,
      'category': category.name,
      'timestamp': timestamp.toIso8601String(),
      'processing_time_ms': processingTimeMs,
      'metadata': metadata,
      'suggestions': suggestions,
      'actions': actions?.map((e) => e.toJson()).toList(),
      'context': context?.toJson(),
      'analytics': analytics?.toJson(),
    };
  }

  AIResponseModel copyWith({
    String? id,
    String? text,
    ResponseType? type,
    ResponseStatus? status,
    ResponseConfidence? confidence,
    ResponseCategory? category,
    DateTime? timestamp,
    int? processingTimeMs,
    Map<String, dynamic>? metadata,
    List<String>? suggestions,
    List<ResponseAction>? actions,
    ResponseContext? context,
    ResponseAnalytics? analytics,
  }) {
    return AIResponseModel(
      id: id ?? this.id,
      text: text ?? this.text,
      type: type ?? this.type,
      status: status ?? this.status,
      confidence: confidence ?? this.confidence,
      category: category ?? this.category,
      timestamp: timestamp ?? this.timestamp,
      processingTimeMs: processingTimeMs ?? this.processingTimeMs,
      metadata: metadata ?? this.metadata,
      suggestions: suggestions ?? this.suggestions,
      actions: actions ?? this.actions,
      context: context ?? this.context,
      analytics: analytics ?? this.analytics,
    );
  }

  // Computed properties
  bool get isSuccessful => status == ResponseStatus.success;
  bool get hasError => status == ResponseStatus.failed;
  bool get isHighConfidence => confidence == ResponseConfidence.high;
  bool get hasSuggestions => suggestions != null && suggestions!.isNotEmpty;
  bool get hasActions => actions != null && actions!.isNotEmpty;
  bool get hasContext => context != null;
  
  String get confidenceLabel {
    switch (confidence) {
      case ResponseConfidence.high:
        return 'High';
      case ResponseConfidence.medium:
        return 'Medium';
      case ResponseConfidence.low:
        return 'Low';
      case ResponseConfidence.uncertain:
        return 'Uncertain';
    }
  }
  
  String get categoryLabel {
    switch (category) {
      case ResponseCategory.general:
        return 'General';
      case ResponseCategory.technical:
        return 'Technical';
      case ResponseCategory.security:
        return 'Security';
      case ResponseCategory.academic:
        return 'Academic';
      case ResponseCategory.development:
        return 'Development';
      case ResponseCategory.personal:
        return 'Personal';
      case ResponseCategory.greeting:
        return 'Greeting';
      case ResponseCategory.farewell:
        return 'Farewell';
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AIResponseModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'AIResponseModel{id: $id, type: $type, status: $status, category: $category}';
  }
}

class ResponseAction {
  final String id;
  final String type;
  final String label;
  final String? description;
  final Map<String, dynamic>? parameters;
  final bool isEnabled;

  ResponseAction({
    required this.id,
    required this.type,
    required this.label,
    this.description,
    this.parameters,
    this.isEnabled = true,
  });

  factory ResponseAction.fromJson(Map<String, dynamic> json) {
    return ResponseAction(
      id: json['id'] as String,
      type: json['type'] as String,
      label: json['label'] as String,
      description: json['description'] as String?,
      parameters: json['parameters'] as Map<String, dynamic>?,
      isEnabled: json['is_enabled'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'label': label,
      'description': description,
      'parameters': parameters,
      'is_enabled': isEnabled,
    };
  }

  ResponseAction copyWith({
    String? id,
    String? type,
    String? label,
    String? description,
    Map<String, dynamic>? parameters,
    bool? isEnabled,
  }) {
    return ResponseAction(
      id: id ?? this.id,
      type: type ?? this.type,
      label: label ?? this.label,
      description: description ?? this.description,
      parameters: parameters ?? this.parameters,
      isEnabled: isEnabled ?? this.isEnabled,
    );
  }
}

class ResponseContext {
  final String? conversationId;
  final String? userId;
  final String? sessionId;
  final int messageIndex;
  final List<String> previousMessages;
  final Map<String, dynamic> userContext;
  final Map<String, dynamic> systemContext;

  ResponseContext({
    this.conversationId,
    this.userId,
    this.sessionId,
    this.messageIndex = 0,
    this.previousMessages = const [],
    this.userContext = const {},
    this.systemContext = const {},
  });

  factory ResponseContext.fromJson(Map<String, dynamic> json) {
    return ResponseContext(
      conversationId: json['conversation_id'] as String?,
      userId: json['user_id'] as String?,
      sessionId: json['session_id'] as String?,
      messageIndex: json['message_index'] as int? ?? 0,
      previousMessages: (json['previous_messages'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      userContext: json['user_context'] as Map<String, dynamic>? ?? {},
      systemContext: json['system_context'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'conversation_id': conversationId,
      'user_id': userId,
      'session_id': sessionId,
      'message_index': messageIndex,
      'previous_messages': previousMessages,
      'user_context': userContext,
      'system_context': systemContext,
    };
  }

  ResponseContext copyWith({
    String? conversationId,
    String? userId,
    String? sessionId,
    int? messageIndex,
    List<String>? previousMessages,
    Map<String, dynamic>? userContext,
    Map<String, dynamic>? systemContext,
  }) {
    return ResponseContext(
      conversationId: conversationId ?? this.conversationId,
      userId: userId ?? this.userId,
      sessionId: sessionId ?? this.sessionId,
      messageIndex: messageIndex ?? this.messageIndex,
      previousMessages: previousMessages ?? this.previousMessages,
      userContext: userContext ?? this.userContext,
      systemContext: systemContext ?? this.systemContext,
    );
  }
}

class ResponseAnalytics {
  final int tokenCount;
  final double sentimentScore;
  final List<String> detectedTopics;
  final Map<String, double> confidenceScores;
  final List<String> languagesDetected;
  final Map<String, int> entityCounts;
  final double complexityScore;
  final double relevanceScore;

  ResponseAnalytics({
    this.tokenCount = 0,
    this.sentimentScore = 0.0,
    this.detectedTopics = const [],
    this.confidenceScores = const {},
    this.languagesDetected = const [],
    this.entityCounts = const {},
    this.complexityScore = 0.0,
    this.relevanceScore = 0.0,
  });

  factory ResponseAnalytics.fromJson(Map<String, dynamic> json) {
    return ResponseAnalytics(
      tokenCount: json['token_count'] as int? ?? 0,
      sentimentScore: (json['sentiment_score'] as num?)?.toDouble() ?? 0.0,
      detectedTopics: (json['detected_topics'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      confidenceScores: (json['confidence_scores'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, (v as num).toDouble())) ?? {},
      languagesDetected: (json['languages_detected'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ?? [],
      entityCounts: (json['entity_counts'] as Map<String, dynamic>?)
          ?.map((k, v) => MapEntry(k, v as int)) ?? {},
      complexityScore: (json['complexity_score'] as num?)?.toDouble() ?? 0.0,
      relevanceScore: (json['relevance_score'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token_count': tokenCount,
      'sentiment_score': sentimentScore,
      'detected_topics': detectedTopics,
      'confidence_scores': confidenceScores,
      'languages_detected': languagesDetected,
      'entity_counts': entityCounts,
      'complexity_score': complexityScore,
      'relevance_score': relevanceScore,
    };
  }

  ResponseAnalytics copyWith({
    int? tokenCount,
    double? sentimentScore,
    List<String>? detectedTopics,
    Map<String, double>? confidenceScores,
    List<String>? languagesDetected,
    Map<String, int>? entityCounts,
    double? complexityScore,
    double? relevanceScore,
  }) {
    return ResponseAnalytics(
      tokenCount: tokenCount ?? this.tokenCount,
      sentimentScore: sentimentScore ?? this.sentimentScore,
      detectedTopics: detectedTopics ?? this.detectedTopics,
      confidenceScores: confidenceScores ?? this.confidenceScores,
      languagesDetected: languagesDetected ?? this.languagesDetected,
      entityCounts: entityCounts ?? this.entityCounts,
      complexityScore: complexityScore ?? this.complexityScore,
      relevanceScore: relevanceScore ?? this.relevanceScore,
    );
  }

  // Computed properties
  bool get isPositiveSentiment => sentimentScore > 0.2;
  bool get isNegativeSentiment => sentimentScore < -0.2;
  bool get isNeutralSentiment => sentimentScore.abs() <= 0.2;
  
  bool get isHighComplexity => complexityScore > 0.7;
  bool get isHighRelevance => relevanceScore > 0.8;
  
  String get sentimentLabel {
    if (isPositiveSentiment) return 'Positive';
    if (isNegativeSentiment) return 'Negative';
    return 'Neutral';
  }
  
  String get complexityLabel {
    if (complexityScore > 0.8) return 'Very High';
    if (complexityScore > 0.6) return 'High';
    if (complexityScore > 0.4) return 'Medium';
    if (complexityScore > 0.2) return 'Low';
    return 'Very Low';
  }
}