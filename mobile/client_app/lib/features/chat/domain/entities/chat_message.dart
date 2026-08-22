import 'package:equatable/equatable.dart';

class ChatMessage extends Equatable {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.createdAt,
    this.isPending = false,
  });

  final int id;
  final String role;
  final String content;
  final DateTime? createdAt;
  final bool isPending;

  bool get isUser => role == 'user';

  @override
  List<Object?> get props => [id, role, content, createdAt, isPending];
}
