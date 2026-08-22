part of 'chat_conversations_bloc.dart';

class ChatConversationsState extends Equatable {
  const ChatConversationsState({
    this.conversations = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.deletingId,
    this.deletedId,
    this.failure,
  });

  final List<ChatConversation> conversations;
  final bool isLoading;
  final bool isRefreshing;
  final int? deletingId;
  final int? deletedId;
  final Failure? failure;

  ChatConversationsState copyWith({
    List<ChatConversation>? conversations,
    bool? isLoading,
    bool? isRefreshing,
    int? deletingId,
    bool clearDeletingId = false,
    int? deletedId,
    Failure? failure,
    bool clearFailure = false,
  }) => ChatConversationsState(
    conversations: conversations ?? this.conversations,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    deletingId: clearDeletingId ? null : deletingId ?? this.deletingId,
    deletedId: deletedId ?? this.deletedId,
    failure: clearFailure ? null : failure ?? this.failure,
  );

  @override
  List<Object?> get props => [
    conversations,
    isLoading,
    isRefreshing,
    deletingId,
    deletedId,
    failure,
  ];
}
