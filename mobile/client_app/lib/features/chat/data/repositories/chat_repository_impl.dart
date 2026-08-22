import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/chat_conversation.dart';
import '../../domain/entities/send_chat_result.dart';
import '../../domain/repositories/chat_repository.dart';
import '../chat_failure_mapper.dart';
import '../data_sources/chat_remote_data_source.dart';

class ChatRepositoryImpl implements ChatRepository {
  const ChatRepositoryImpl(this.remoteDataSource);

  final ChatRemoteDataSource remoteDataSource;

  @override
  Future<List<ChatConversation>> getConversations() => _guard(
    () async => (await remoteDataSource.getConversations())
        .map((conversation) => conversation.toEntity())
        .toList(growable: false),
  );

  @override
  Future<ChatConversation> getConversation(int conversationId) => _guard(
    () async =>
        (await remoteDataSource.getConversation(conversationId)).toEntity(),
  );

  @override
  Future<SendChatResult> sendMessage({
    required String message,
    int? conversationId,
  }) => _guard(
    () async => (await remoteDataSource.sendMessage(
      message: message,
      conversationId: conversationId,
    )).toEntity(),
  );

  @override
  Future<void> deleteConversation(int conversationId) =>
      _guard(() => remoteDataSource.deleteConversation(conversationId));

  Future<T> _guard<T>(Future<T> Function() operation) async {
    try {
      return await operation();
    } on DioException catch (error) {
      throw ChatFailureMapper.fromDio(error);
    } on Failure {
      rethrow;
    } on FormatException catch (error) {
      throw ServerFailure(error.message, '');
    }
  }
}
