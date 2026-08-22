part of 'chat_bloc.dart';

sealed class ChatEvent extends Equatable {
  const ChatEvent();
  @override
  List<Object?> get props => [];
}

class OpenNewChat extends ChatEvent {
  const OpenNewChat();
}

class LoadChatConversation extends ChatEvent {
  const LoadChatConversation(this.conversationId);
  final int conversationId;
  @override
  List<Object?> get props => [conversationId];
}

class SendChatMessage extends ChatEvent {
  const SendChatMessage(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class RetryFailedChatMessage extends ChatEvent {
  const RetryFailedChatMessage();
}

class DeleteCurrentConversation extends ChatEvent {
  const DeleteCurrentConversation();
}

class ClearChatError extends ChatEvent {
  const ClearChatError();
}
