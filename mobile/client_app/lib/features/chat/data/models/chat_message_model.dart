import '../../domain/entities/chat_message.dart';
import 'chat_action_model.dart';

class ChatMessageModel {
  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.action,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: _asInt(json['id']),
      role: json['role']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      action: json['action'] is Map
          ? ChatActionModel.fromJson(
              Map<String, dynamic>.from(json['action'] as Map),
            )
          : null,
    );
  }

  final int id;
  final String role;
  final String content;
  final DateTime? createdAt;
  final ChatActionModel? action;

  ChatMessage toEntity() => ChatMessage(
    id: id,
    role: role,
    content: content,
    createdAt: createdAt,
    action: action?.entity,
  );
}

int _asInt(dynamic value) => value is int ? value : int.tryParse('$value') ?? 0;
