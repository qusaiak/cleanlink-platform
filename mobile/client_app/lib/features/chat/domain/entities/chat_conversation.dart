import 'package:equatable/equatable.dart';

import 'chat_message.dart';

class ChatConversation extends Equatable {
  const ChatConversation({
    required this.id,
    required this.title,
    required this.messagesCount,
    required this.updatedAt,
    this.messages = const [],
  });

  final int id;
  final String? title;
  final int? messagesCount;
  final DateTime? updatedAt;
  final List<ChatMessage> messages;

  @override
  List<Object?> get props => [id, title, messagesCount, updatedAt, messages];
}
