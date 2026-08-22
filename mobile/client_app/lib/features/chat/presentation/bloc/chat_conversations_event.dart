part of 'chat_conversations_bloc.dart';

sealed class ChatConversationsEvent extends Equatable {
  const ChatConversationsEvent();
  @override
  List<Object?> get props => [];
}

class LoadChatConversations extends ChatConversationsEvent {
  const LoadChatConversations();
}

class RefreshChatConversations extends ChatConversationsEvent {
  const RefreshChatConversations([this.completer]);
  final Completer<void>? completer;
}

class DeleteChatConversation extends ChatConversationsEvent {
  const DeleteChatConversation(this.conversationId);
  final int conversationId;
  @override
  List<Object?> get props => [conversationId];
}
