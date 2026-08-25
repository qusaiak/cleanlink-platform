part of 'chat_bloc.dart';

class ChatState extends Equatable {
  const ChatState({
    this.messages = const [],
    this.conversationId,
    this.isLoading = false,
    this.isSending = false,
    this.isDeleting = false,
    this.failure,
    this.failedMessage,
    this.deleteSucceeded = false,
    this.actionToHandle,
  });

  final List<ChatMessage> messages;
  final int? conversationId;
  final bool isLoading;
  final bool isSending;
  final bool isDeleting;
  final Failure? failure;
  final String? failedMessage;
  final bool deleteSucceeded;
  final ChatAction? actionToHandle;

  ChatState copyWith({
    List<ChatMessage>? messages,
    int? conversationId,
    bool clearConversationId = false,
    bool? isLoading,
    bool? isSending,
    bool? isDeleting,
    Failure? failure,
    bool clearFailure = false,
    String? failedMessage,
    bool clearFailedMessage = false,
    bool? deleteSucceeded,
    ChatAction? actionToHandle,
    bool clearActionToHandle = false,
  }) => ChatState(
    messages: messages ?? this.messages,
    conversationId: clearConversationId
        ? null
        : conversationId ?? this.conversationId,
    isLoading: isLoading ?? this.isLoading,
    isSending: isSending ?? this.isSending,
    isDeleting: isDeleting ?? this.isDeleting,
    failure: clearFailure ? null : failure ?? this.failure,
    failedMessage: clearFailedMessage
        ? null
        : failedMessage ?? this.failedMessage,
    deleteSucceeded: deleteSucceeded ?? this.deleteSucceeded,
    actionToHandle: clearActionToHandle
        ? null
        : actionToHandle ?? this.actionToHandle,
  );

  @override
  List<Object?> get props => [
    messages,
    conversationId,
    isLoading,
    isSending,
    isDeleting,
    failure,
    failedMessage,
    deleteSucceeded,
    actionToHandle,
  ];
}
