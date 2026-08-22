import '../entities/chat_conversation.dart';
import '../entities/send_chat_result.dart';

abstract class ChatRepository {
  Future<List<ChatConversation>> getConversations();
  Future<ChatConversation> getConversation(int conversationId);
  Future<SendChatResult> sendMessage({
    required String message,
    int? conversationId,
  });
  Future<void> deleteConversation(int conversationId);
}
