import 'chat_message.dart';

class SendChatResult {
  const SendChatResult({
    required this.conversationId,
    required this.userMessage,
    required this.assistantMessage,
  });

  final int conversationId;
  final ChatMessage userMessage;
  final ChatMessage assistantMessage;
}
