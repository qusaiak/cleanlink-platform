import '../../domain/entities/chat_conversation.dart';
import 'chat_message_model.dart';

class ChatConversationModel {
  const ChatConversationModel({
    required this.id,
    required this.title,
    required this.messagesCount,
    required this.updatedAt,
    required this.messages,
  });

  factory ChatConversationModel.fromJson(Map<String, dynamic> json) {
    final rawMessages = json['messages'];
    return ChatConversationModel(
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      title: json['title']?.toString(),
      messagesCount: json['messages_count'] == null
          ? null
          : int.tryParse('${json['messages_count']}'),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      messages: rawMessages is List
          ? rawMessages
                .whereType<Map>()
                .map(
                  (item) => ChatMessageModel.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }

  final int id;
  final String? title;
  final int? messagesCount;
  final DateTime? updatedAt;
  final List<ChatMessageModel> messages;

  ChatConversation toEntity() => ChatConversation(
    id: id,
    title: title,
    messagesCount: messagesCount,
    updatedAt: updatedAt,
    messages: messages
        .map((message) => message.toEntity())
        .toList(growable: false),
  );
}
