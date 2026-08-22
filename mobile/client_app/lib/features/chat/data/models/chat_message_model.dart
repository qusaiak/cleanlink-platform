import '../../domain/entities/chat_message.dart';

class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: _asInt(json['id']),
      role: json['role']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }

  final int id;
  final String role;
  final String content;
  final DateTime? createdAt;

  ChatMessage toEntity() =>
      ChatMessage(id: id, role: role, content: content, createdAt: createdAt);
}

int _asInt(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;
