class ChatHistoryResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<ChatMessage> results;

  ChatHistoryResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory ChatHistoryResponse.fromJson(Map<String, dynamic> json) => ChatHistoryResponse(
        count: json["count"] ?? 0,
        next: json["next"],
        previous: json["previous"],
        results: json["results"] == null 
            ? [] 
            : List<ChatMessage>.from(json["results"].map((x) => ChatMessage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "count": count,
        "next": next,
        "previous": previous,
        "results": List<dynamic>.from(results.map((x) => x.toJson())),
      };
}

/// Represents a single attachment on a chat message.
class ChatAttachment {
  final int? id;
  final String objectKey;
  final String publicUrl;
  final String contentType;
  final String fileName;
  final int sizeBytes;

  ChatAttachment({
    this.id,
    required this.objectKey,
    required this.publicUrl,
    required this.contentType,
    required this.fileName,
    required this.sizeBytes,
  });

  factory ChatAttachment.fromJson(Map<String, dynamic> json) {
    return ChatAttachment(
      id: json['id'] as int?,
      objectKey: json['object_key'] ?? '',
      publicUrl: json['public_url'] ?? '',
      contentType: json['content_type'] ?? '',
      fileName: json['file_name'] ?? '',
      sizeBytes: json['size_bytes'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'object_key': objectKey,
        'public_url': publicUrl,
        'content_type': contentType,
        'file_name': fileName,
        'size_bytes': sizeBytes,
      };
}

/// Sender info embedded inside each message.
class ChatSender {
  final int id;
  final String email;
  final String roleKind;

  ChatSender({
    required this.id,
    required this.email,
    required this.roleKind,
  });

  factory ChatSender.fromJson(Map<String, dynamic> json) {
    return ChatSender(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      roleKind: json['role_kind'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'role_kind': roleKind,
      };
}

/// A single chat message.
class ChatMessage {
  final int id;
  final int? conversationId;
  final String body;
  final String messageType;
  final DateTime createdAt;
  final ChatSender? sender;
  final List<ChatAttachment> attachments;

  ChatMessage({
    required this.id,
    this.conversationId,
    required this.body,
    required this.messageType,
    required this.createdAt,
    this.sender,
    required this.attachments,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id'] ?? 0,
      conversationId: json['conversation_id'] as int?,
      body: json['body'] ?? json['content'] ?? '',
      messageType: json['message_type'] ?? 'text',
      createdAt: DateTime.tryParse(
              json['created_at'] ?? json['timestamp'] ?? '') ??
          DateTime.now(),
      sender: json['sender'] != null
          ? (json['sender'] is Map<String, dynamic>
              ? ChatSender.fromJson(json['sender'])
              : null)
          : null,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((a) => ChatAttachment.fromJson(a as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'conversation_id': conversationId,
        'body': body,
        'message_type': messageType,
        'created_at': createdAt.toIso8601String(),
        'sender': sender?.toJson(),
        'attachments': List<dynamic>.from(attachments.map((x) => x.toJson())),
      };

  /// Whether the current user sent this message.
  /// Support / admin messages have role_kind == 'admin' or 'support'.
  bool get isSupport {
    final role = sender?.roleKind.toLowerCase() ?? '';
    return role == 'admin' || role == 'support';
  }
}
