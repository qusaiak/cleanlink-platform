import '../models/chat_conversation_model.dart';
import '../models/send_chat_response_model.dart';
import 'chat_api_service.dart';

abstract class ChatRemoteDataSource {
  Future<List<ChatConversationModel>> getConversations();
  Future<ChatConversationModel> getConversation(int conversationId);
  Future<SendChatResponseModel> sendMessage({
    required String message,
    int? conversationId,
  });
  Future<void> deleteConversation(int conversationId);
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  const ChatRemoteDataSourceImpl(this.api);

  final ChatApiService api;

  @override
  Future<List<ChatConversationModel>> getConversations() async {
    final response = await api.getConversations();
    final body = response.data;
    if (body is! Map) {
      throw const FormatException('Invalid conversations response');
    }
    final raw = body['data'];
    if (raw is! List) {
      throw const FormatException('Invalid conversations response');
    }
    return raw
        .whereType<Map>()
        .map(
          (item) =>
              ChatConversationModel.fromJson(Map<String, dynamic>.from(item)),
        )
        .toList(growable: false);
  }

  @override
  Future<ChatConversationModel> getConversation(int conversationId) async {
    final response = await api.getConversation(conversationId);
    final body = response.data;
    if (body is! Map) {
      throw const FormatException('Invalid conversation response');
    }
    final raw = body['data'];
    if (raw is! Map) {
      throw const FormatException('Invalid conversation response');
    }
    return ChatConversationModel.fromJson(Map<String, dynamic>.from(raw));
  }

  @override
  Future<SendChatResponseModel> sendMessage({
    required String message,
    int? conversationId,
  }) async {
    final body = <String, dynamic>{'message': message};
    if (conversationId != null) body['conversation_id'] = conversationId;
    final response = await api.sendMessage(body);
    final data = response.data;
    if (data is! Map) throw const FormatException('Invalid chat response');
    return SendChatResponseModel.fromJson(Map<String, dynamic>.from(data));
  }

  @override
  Future<void> deleteConversation(int conversationId) async {
    await api.deleteConversation(conversationId);
  }
}
