import 'package:equatable/equatable.dart';

import 'chat_action.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isPending = false,
    this.action,
  });

  final int id;
  final String role;
  final String content;
  final DateTime? createdAt;
  final bool isPending;
  final ChatAction? action;

  bool get isUser => role == 'user';

  @override
  List<Object?> get props => [id, role, content, createdAt, isPending, action];
}
