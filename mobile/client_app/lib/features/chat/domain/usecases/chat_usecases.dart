import '../entities/chat_conversation.dart';
import '../entities/send_chat_result.dart';
import '../repositories/chat_repository.dart';

class GetChatConversationsUseCase {
  const GetChatConversationsUseCase(this.repository);
  final ChatRepository repository;
  Future<List<ChatConversation>> call() => repository.getConversations();
}

class GetChatConversationUseCase {
  const GetChatConversationUseCase(this.repository);
  final ChatRepository repository;
  Future<ChatConversation> call(int conversationId) =>
      repository.getConversation(conversationId);
}

class SendChatMessageUseCase {
  const SendChatMessageUseCase(this.repository);
  final ChatRepository repository;
  Future<SendChatResult> call({required String message, int? conversationId}) =>
      repository.sendMessage(message: message, conversationId: conversationId);
}

class DeleteChatConversationUseCase {
  const DeleteChatConversationUseCase(this.repository);
  final ChatRepository repository;
  Future<void> call(int conversationId) =>
      repository.deleteConversation(conversationId);
}
