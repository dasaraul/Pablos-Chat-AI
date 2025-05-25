import 'package:flutter/foundation.dart';

enum MessageType {
  user,
  bot,
  system,
  error,
  typing
}

enum MessageStatus {
  sending,
  sent,
  delivered,
  read,
  failed
}

class Message {
  final String id;
  final String content;
  final MessageType type;
  final DateTime timestamp;
  final MessageStatus status;
  final Map<String, dynamic>? metadata;
  final String? avatarUrl;
  final bool isEncrypted;
  final List<MessageAttachment>? attachments;

  const Message({
    required this.id,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sent,
    this.metadata,
    this.avatarUrl,
    this.isEncrypted = false,
    this.attachments,
  });

  // Factory constructor for user messages
  factory Message.user({
    required String content,
    Map<String, dynamic>? metadata,
    List<MessageAttachment>? attachments,
  }) {
    return Message(
      id: _generateId(),
      content: content,
      type: MessageType.user,
      timestamp: DateTime.now(),
      status: MessageStatus.sending,
      metadata: metadata,
      attachments: attachments,
    );
  }

  // Factory constructor for bot messages
  factory Message.bot({
    required String content,
    Map<String, dynamic>? metadata,
    List<MessageAttachment>? attachments,
  }) {
    return Message(
      id: _generateId(),
      content: content,
      type: MessageType.bot,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
      metadata: metadata,
      avatarUrl: 'assets/images/pablos_avatar.png',
      attachments: attachments,
    );
  }

  // Factory constructor for system messages
  factory Message.system({
    required String content,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: _generateId(),
      content: content,
      type: MessageType.system,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
      metadata: metadata,
    );
  }

  // Factory constructor for error messages
  factory Message.error({
    required String content,
    Map<String, dynamic>? metadata,
  }) {
    return Message(
      id: _generateId(),
      content: content,
      type: MessageType.error,
      timestamp: DateTime.now(),
      status: MessageStatus.failed,
      metadata: metadata,
    );
  }

  // Factory constructor for typing indicator
  factory Message.typing() {
    return Message(
      id: 'typing_${DateTime.now().millisecondsSinceEpoch}',
      content: 'PABLOS is processing your request...',
      type: MessageType.typing,
      timestamp: DateTime.now(),
      status: MessageStatus.delivered,
    );
  }

  // Copy with method for immutable updates
  Message copyWith({
    String? id,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    Map<String, dynamic>? metadata,
    String? avatarUrl,
    bool? isEncrypted,
    List<MessageAttachment>? attachments,
  }) {
    return Message(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      metadata: metadata ?? this.metadata,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      attachments: attachments ?? this.attachments,
    );
  }

  // Convert to JSON for storage/transmission
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.toIso8601String(),
      'status': status.name,
      'metadata': metadata,
      'avatarUrl': avatarUrl,
      'isEncrypted': isEncrypted,
      'attachments': attachments?.map((a) => a.toJson()).toList(),
    };
  }

  // Create from JSON
  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      content: json['content'] as String,
      type: MessageType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => MessageType.user,
      ),
      timestamp: DateTime.parse(json['timestamp'] as String),
      status: MessageStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => MessageStatus.sent,
      ),
      metadata: json['metadata'] as Map<String, dynamic>?,
      avatarUrl: json['avatarUrl'] as String?,
      isEncrypted: json['isEncrypted'] as bool? ?? false,
      attachments: (json['attachments'] as List?)
          ?.map((a) => MessageAttachment.fromJson(a))
          .toList(),
    );
  }

  // Check if message is from user
  bool get isUser => type == MessageType.user;

  // Check if message is from bot
  bool get isBot => type == MessageType.bot;

  // Check if message is system message
  bool get isSystem => type == MessageType.system;

  // Check if message is error
  bool get isError => type == MessageType.error;

  // Check if message is typing indicator
  bool get isTyping => type == MessageType.typing;

  // Get formatted timestamp
  String get formattedTime {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) {
      return 'now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours}h ago';
    } else {
      return '${difference.inDays}d ago';
    }
  }

  // Get status icon
  String get statusIcon {
    switch (status) {
      case MessageStatus.sending:
        return '⏳';
      case MessageStatus.sent:
        return '✓';
      case MessageStatus.delivered:
        return '✓✓';
      case MessageStatus.read:
        return '✓✓';
      case MessageStatus.failed:
        return '❌';
    }
  }

  // Generate unique ID
  static String _generateId() {
    return '${DateTime.now().millisecondsSinceEpoch}_${UniqueKey().toString()}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Message &&
        other.id == id &&
        other.content == content &&
        other.type == type &&
        other.timestamp == timestamp;
  }

  @override
  int get hashCode {
    return Object.hash(id, content, type, timestamp);
  }

  @override
  String toString() {
    return 'Message(id: $id, type: $type, content: ${content.substring(0, content.length > 50 ? 50 : content.length)}...)';
  }
}

// Message attachment model
class MessageAttachment {
  final String id;
  final String fileName;
  final String fileType;
  final int fileSize;
  final String? filePath;
  final String? thumbnailPath;
  final Map<String, dynamic>? metadata;

  const MessageAttachment({
    required this.id,
    required this.fileName,
    required this.fileType,
    required this.fileSize,
    this.filePath,
    this.thumbnailPath,
    this.metadata,
  });

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fileName': fileName,
      'fileType': fileType,
      'fileSize': fileSize,
      'filePath': filePath,
      'thumbnailPath': thumbnailPath,
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory MessageAttachment.fromJson(Map<String, dynamic> json) {
    return MessageAttachment(
      id: json['id'] as String,
      fileName: json['fileName'] as String,
      fileType: json['fileType'] as String,
      fileSize: json['fileSize'] as int,
      filePath: json['filePath'] as String?,
      thumbnailPath: json['thumbnailPath'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  // Get formatted file size
  String get formattedSize {
    if (fileSize < 1024) {
      return '${fileSize}B';
    } else if (fileSize < 1024 * 1024) {
      return '${(fileSize / 1024).toStringAsFixed(1)}KB';
    } else if (fileSize < 1024 * 1024 * 1024) {
      return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)}MB';
    } else {
      return '${(fileSize / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
    }
  }

  // Check if file is image
  bool get isImage {
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(
      fileType.toLowerCase(),
    );
  }

  // Check if file is document
  bool get isDocument {
    return ['pdf', 'doc', 'docx', 'txt', 'rtf'].contains(
      fileType.toLowerCase(),
    );
  }

  // Check if file is video
  bool get isVideo {
    return ['mp4', 'avi', 'mov', 'wmv', 'flv', 'webm'].contains(
      fileType.toLowerCase(),
    );
  }

  // Check if file is audio
  bool get isAudio {
    return ['mp3', 'wav', 'flac', 'aac', 'ogg'].contains(
      fileType.toLowerCase(),
    );
  }
}

// Conversation model to group messages
class Conversation {
  final String id;
  final String title;
  final List<Message> messages;
  final DateTime createdAt;
  final DateTime lastMessageAt;
  final Map<String, dynamic>? metadata;

  const Conversation({
    required this.id,
    required this.title,
    required this.messages,
    required this.createdAt,
    required this.lastMessageAt,
    this.metadata,
  });

  // Add message to conversation
  Conversation addMessage(Message message) {
    return copyWith(
      messages: [...messages, message],
      lastMessageAt: message.timestamp,
    );
  }

  // Update message in conversation
  Conversation updateMessage(String messageId, Message updatedMessage) {
    final updatedMessages = messages.map((msg) {
      return msg.id == messageId ? updatedMessage : msg;
    }).toList();

    return copyWith(messages: updatedMessages);
  }

  // Remove message from conversation
  Conversation removeMessage(String messageId) {
    final filteredMessages = messages.where((msg) => msg.id != messageId).toList();
    return copyWith(messages: filteredMessages);
  }

  // Copy with method
  Conversation copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    DateTime? createdAt,
    DateTime? lastMessageAt,
    Map<String, dynamic>? metadata,
  }) {
    return Conversation(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      createdAt: createdAt ?? this.createdAt,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      metadata: metadata ?? this.metadata,
    );
  }

  // Get last message
  Message? get lastMessage {
    return messages.isNotEmpty ? messages.last : null;
  }

  // Get message count
  int get messageCount => messages.length;

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'messages': messages.map((m) => m.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'lastMessageAt': lastMessageAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  // Create from JSON
  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      messages: (json['messages'] as List)
          .map((m) => Message.fromJson(m))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastMessageAt: DateTime.parse(json['lastMessageAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }
}