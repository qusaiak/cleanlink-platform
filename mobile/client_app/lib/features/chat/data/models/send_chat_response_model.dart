import '../../domain/entities/send_chat_result.dart';
import 'chat_message_model.dart';

class SendChatResponseModel {
  const SendChatResponseModel({
    required this.conversationId,
    required this.userMessage,
    required this.assistantMessage,
  });

  factory SendChatResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    if (data is! Map) {
      throw const FormatException('Invalid chat response data');
    }
    final body = Map<String, dynamic>.from(data);
    final user = body['user_message'];
    final assistant = body['assistant_message'];
    if (user is! Map || assistant is! Map) {
      throw const FormatException('Invalid chat messages response');
    }
    return SendChatResponseModel(
      conversationId: int.tryParse('${body['conversation_id']}') ?? 0,
      userMessage: ChatMessageModel.fromJson(Map<String, dynamic>.from(user)),
      assistantMessage: ChatMessageModel.fromJson(
        Map<String, dynamic>.from(assistant),
      ),
    );
  }

  final int conversationId;
  final ChatMessageModel userMessage;
  final ChatMessageModel assistantMessage;

  SendChatResult toEntity() => SendChatResult(
    conversationId: conversationId,
    userMessage: userMessage.toEntity(),
    assistantMessage: assistantMessage.toEntity(),
  );
}
