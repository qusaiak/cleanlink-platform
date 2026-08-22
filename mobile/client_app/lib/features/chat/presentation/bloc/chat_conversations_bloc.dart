import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/usecases/chat_usecases.dart';

part 'chat_conversations_event.dart';
part 'chat_conversations_state.dart';

class ChatConversationsBloc
    extends Bloc<ChatConversationsEvent, ChatConversationsState> {
  ChatConversationsBloc(this._getConversations, this._deleteConversation)
    : super(const ChatConversationsState()) {
    on<LoadChatConversations>(_onLoad);
    on<RefreshChatConversations>(_onRefresh);
    on<DeleteChatConversation>(_onDelete);
  }

  final GetChatConversationsUseCase _getConversations;
  final DeleteChatConversationUseCase _deleteConversation;

  Future<void> _onLoad(
    LoadChatConversations event,
    Emitter<ChatConversationsState> emit,
  ) async {
    if (state.isLoading) return;
    emit(state.copyWith(isLoading: true, clearFailure: true));
    await _load(emit);
  }

  Future<void> _onRefresh(
    RefreshChatConversations event,
    Emitter<ChatConversationsState> emit,
  ) async {
    emit(state.copyWith(isRefreshing: true, clearFailure: true));
    await _load(emit);
    event.completer?.complete();
  }

  Future<void> _load(Emitter<ChatConversationsState> emit) async {
    try {
      emit(
        state.copyWith(
          conversations: await _getConversations(),
          isLoading: false,
          isRefreshing: false,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          isLoading: false,
          isRefreshing: false,
          failure: _historyFailure(error),
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteChatConversation event,
    Emitter<ChatConversationsState> emit,
  ) async {
    if (state.deletingId != null) return;
    emit(state.copyWith(deletingId: event.conversationId, clearFailure: true));
    try {
      await _deleteConversation(event.conversationId);
      emit(
        state.copyWith(
          conversations: state.conversations
              .where((item) => item.id != event.conversationId)
              .toList(growable: false),
          clearDeletingId: true,
          deletedId: event.conversationId,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(clearDeletingId: true, failure: _historyFailure(error)),
      );
    }
  }
}

Failure _historyFailure(Object error) =>
    error is Failure ? error : ServerFailure(error.toString(), '');
