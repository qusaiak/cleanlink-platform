import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/chat_action.dart';
import '../../domain/usecases/chat_usecases.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc(this._getConversation, this._sendMessage, this._deleteConversation)
    : super(const ChatState()) {
    on<OpenNewChat>(_onNewChat);
    on<LoadChatConversation>(_onLoadConversation);
    on<SendChatMessage>(_onSendMessage);
    on<RetryFailedChatMessage>(_onRetryFailedMessage);
    on<DeleteCurrentConversation>(_onDeleteConversation);
    on<ClearChatError>((_, emit) => emit(state.copyWith(clearFailure: true)));
    on<ChatActionHandled>(
      (_, emit) => emit(state.copyWith(clearActionToHandle: true)),
    );
  }

  final GetChatConversationUseCase _getConversation;
  final SendChatMessageUseCase _sendMessage;
  final DeleteChatConversationUseCase _deleteConversation;

  void _onNewChat(OpenNewChat event, Emitter<ChatState> emit) {
    if (state.isSending) return;
    emit(const ChatState());
  }

  Future<void> _onLoadConversation(
    LoadChatConversation event,
    Emitter<ChatState> emit,
  ) async {
    if (state.isLoading || state.isSending) return;
    emit(
      state.copyWith(
        conversationId: event.conversationId,
        messages: const [],
        isLoading: true,
        clearFailure: true,
      ),
    );
    try {
      final conversation = await _getConversation(event.conversationId);
      emit(
        state.copyWith(
          conversationId: conversation.id,
          messages: conversation.messages,
          isLoading: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          failure: _failure(error),
          clearConversationId: true,
        ),
      );
    }
  }

  Future<void> _onSendMessage(
    SendChatMessage event,
    Emitter<ChatState> emit,
  ) async {
    await _send(event.message, emit);
  }

  Future<void> _onRetryFailedMessage(
    RetryFailedChatMessage event,
    Emitter<ChatState> emit,
  ) async {
    final message = state.failedMessage;
    if (message == null) return;
    await _send(message, emit);
  }

  Future<void> _send(String rawMessage, Emitter<ChatState> emit) async {
    final message = rawMessage.trim();
    if (message.isEmpty || message.length > 2000 || state.isSending) return;

    final optimistic = ChatMessage(
      id: -DateTime.now().microsecondsSinceEpoch,
      role: 'user',
      content: message,
      createdAt: DateTime.now(),
      isPending: true,
    );
    final previousMessages = state.messages;
    emit(
      state.copyWith(
        messages: [...previousMessages, optimistic],
        isSending: true,
        clearFailure: true,
        clearFailedMessage: true,
      ),
    );

    try {
      final result = await _sendMessage(
        message: message,
        conversationId: state.conversationId,
      );
      emit(
        state.copyWith(
          conversationId: result.conversationId,
          messages: [
            ...previousMessages,
            result.userMessage,
            result.assistantMessage,
          ],
          isSending: false,
          clearFailedMessage: true,
          actionToHandle: result.assistantMessage.action,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          messages: previousMessages,
          isSending: false,
          failure: _failure(error),
          failedMessage: message,
        ),
      );
    }
  }

  Future<void> _onDeleteConversation(
    DeleteCurrentConversation event,
    Emitter<ChatState> emit,
  ) async {
    final conversationId = state.conversationId;
    if (conversationId == null || state.isDeleting || state.isSending) return;
    emit(state.copyWith(isDeleting: true, clearFailure: true));
    try {
      await _deleteConversation(conversationId);
      emit(const ChatState(deleteSucceeded: true));
    } catch (error) {
      emit(state.copyWith(isDeleting: false, failure: _failure(error)));
    }
  }
}

Failure _failure(Object error) =>
    error is Failure ? error : ServerFailure(error.toString(), '');
