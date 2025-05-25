import 'package:flutter/foundation.dart';

enum MessageType {
  general,
  technical,
  security,
  academic,
  development,
  welcome,
  error,
  system,
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  failed,
}

class ChatMessage {
  final String id;
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String sender;
  final MessageType messageType;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;
  final List<String>? attachments;
  final String? replyToId;

  ChatMessage({
    required this.id,
    required this.text,
    required this.isUser,
    required this.timestamp,
    required this.sender,
    this.messageType = MessageType.general,
    this.status = MessageStatus.sent,
    this.metadata,
    this.attachments,
    this.replyToId,
  });

  ChatMessage copyWith({
    String? id,
    String? text,
    bool? isUser,
    DateTime? timestamp,
    String? sender,
    MessageType? messageType,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
    List<String>? attachments,
    String? replyToId,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      text: text ?? this.text,
      isUser: isUser ?? this.isUser,
      timestamp: timestamp ?? this.timestamp,
      sender: sender ?? this.sender,
      messageType: messageType ?? this.messageType,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      attachments: attachments ?? this.attachments,
      replyToId: replyToId ?? this.replyToId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'isUser': isUser,
      'timestamp': timestamp.toIso8601String(),
      'sender': sender,
      'messageType': messageType.name,
      'status': status.name,
      'metadata': metadata,
      'attachments': attachments,
      'replyToId': replyToId,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] as String,
      text: json['text'] as String,
      isUser: json['isUser'] as bool,
      timestamp: DateTime.parse(json['timestamp'] as String),
      sender: json['sender'] as String,
      messageType: MessageType.values.firstWhere(
        (e) => e.name == json['messageType'],
        orElse: () => MessageType.general,
      ),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      attachments: (json['attachments'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      replyToId: json['replyToId'] as String?,
    );
  }

  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d';
    } else {
      return '${timestamp.day}/${timestamp.month}';
    }
  }

  String get fullFormattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:'
           '${timestamp.minute.toString().padLeft(2, '0')} - '
           '${timestamp.day}/${timestamp.month}/${timestamp.year}';
  }

  bool get isToday {
    final now = DateTime.now();
    return timestamp.year == now.year &&
           timestamp.month == now.month &&
           timestamp.day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final difference = now.difference(timestamp);
    return difference.inDays < 7;
  }

  String get messageTypeIcon {
    switch (messageType) {
      case MessageType.general:
        return '💬';
      case MessageType.technical:
        return '⚙️';
      case MessageType.security:
        return '🔒';
      case MessageType.academic:
        return '📚';
      case MessageType.development:
        return '💻';
      case MessageType.welcome:
        return '👋';
      case MessageType.error:
        return '❌';
      case MessageType.system:
        return '🤖';
    }
  }

  String get messageTypeLabel {
    switch (messageType) {
      case MessageType.general:
        return 'General';
      case MessageType.technical:
        return 'Technical';
      case MessageType.security:
        return 'Security';
      case MessageType.academic:
        return 'Academic';
      case MessageType.development:
        return 'Development';
      case MessageType.welcome:
        return 'Welcome';
      case MessageType.error:
        return 'Error';
      case MessageType.system:
        return 'System';
    }
  }

  bool get hasAttachments => attachments != null && attachments!.isNotEmpty;
  bool get isReply => replyToId != null;
  bool get hasMetadata => metadata != null && metadata!.isNotEmpty;
  
  int get wordCount => text.split(' ').length;
  int get characterCount => text.length;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is ChatMessage && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'ChatMessage{id: $id, sender: $sender, isUser: $isUser, type: $messageType, time: $formattedTime}';
  }
}