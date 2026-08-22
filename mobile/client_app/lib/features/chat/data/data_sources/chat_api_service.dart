import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../config/constants/api_endpoints.dart';

part 'chat_api_service.g.dart';

@RestApi()
abstract class ChatApiService {
  factory ChatApiService(Dio dio, {String? baseUrl}) = _ChatApiService;

  @GET(ApiEndpoints.chatConversationsEndpoint)
  Future<HttpResponse<dynamic>> getConversations();

  @GET(ApiEndpoints.chatConversationEndpoint)
  Future<HttpResponse<dynamic>> getConversation(
    @Path('conversationId') int conversationId,
  );

  @POST(ApiEndpoints.chatMessagesEndpoint)
  Future<HttpResponse<dynamic>> sendMessage(@Body() Map<String, dynamic> body);

  @DELETE(ApiEndpoints.chatConversationEndpoint)
  Future<HttpResponse<dynamic>> deleteConversation(
    @Path('conversationId') int conversationId,
  );
}
