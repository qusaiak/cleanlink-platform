import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../models/app_notification_model.dart';
import '../../domain/entities/app_notification.dart';

abstract class NotificationsRemoteDataSource {
  Future<NotificationsPageResult> getNotifications({
    int page = 1,
    int perPage = 20,
  });

  Future<void> markAsRead(String id);

  Future<List<AppNotificationModel>> markAllAsRead();
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final Dio dio;

  NotificationsRemoteDataSourceImpl(this.dio);

  static List<dynamic>? _extractItems(dynamic body) {
    dynamic node = body;

    for (var depth = 0; depth < 5; depth++) {
      if (node is List) return node;
      if (node is! Map) return null;

      final next =
          node['notifications'] ??
          node['data'] ??
          node['items'] ??
          node['results'];
      if (next == null) return null;
      node = next;
    }
    return null;
  }

  List<AppNotificationModel> _parseList(dynamic body) {
    final items = _extractItems(body);
    if (items == null) {
      _logRaw('unrecognised payload shape', body);
      throw const FormatException(
        'Unrecognised notifications payload: no list found in the envelope',
      );
    }

    final parsed = <AppNotificationModel>[];
    for (final item in items) {
      if (item is! Map) {
        _log('skipped a non-object entry: $item');
        continue;
      }
      try {
        parsed.add(
          AppNotificationModel.fromJson(Map<String, dynamic>.from(item)),
        );
      } catch (error, stackTrace) {
        _log('skipped a malformed entry ($error): $item', stackTrace);
      }
    }

    parsed.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return parsed;
  }

  @override
  Future<NotificationsPageResult> getNotifications({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await dio.get(
      ApiUrlParameters.notifications,

      queryParameters: {'page': page, 'per_page': perPage},
    );
    _logResponse(response);
    final items = _parseList(response.data);
    final envelope = response.data is Map
        ? Map<String, dynamic>.from(response.data as Map)
        : const <String, dynamic>{};
    final data = envelope['data'] is Map
        ? Map<String, dynamic>.from(envelope['data'] as Map)
        : const <String, dynamic>{};
    final pagination = data['pagination'] is Map
        ? Map<String, dynamic>.from(data['pagination'] as Map)
        : const <String, dynamic>{};
    return NotificationsPageResult(
      items: items,
      currentPage: (pagination['current_page'] as num?)?.toInt() ?? page,
      hasMore: pagination['has_more_pages'] == true,
    );
  }

  @override
  Future<void> markAsRead(String id) async {
    final response = await dio.post(ApiUrlParameters.markNotificationRead(id));
    _logResponse(response);
  }

  @override
  Future<List<AppNotificationModel>> markAllAsRead() async {
    final current = await getNotifications(perPage: 100);
    final unread = current.items.where((n) => !n.isRead);
    for (final n in unread) {
      try {
        await markAsRead(n.id);
      } catch (error, stackTrace) {
        _log('mark-all: failed to mark ${n.id} ($error)', stackTrace);
      }
    }
    return (await getNotifications(
      perPage: 100,
    )).items.whereType<AppNotificationModel>().toList();
  }

  void _logResponse(Response<dynamic> response) {
    if (!kDebugMode) return;
    final request = response.requestOptions;
    _log(
      '${request.method} ${request.uri}\n'
      '  status : ${response.statusCode}\n'
      '  headers: ${request.headers}\n'
      '  body   : ${response.data}',
    );
  }

  void _logRaw(String reason, dynamic body) {
    if (!kDebugMode) return;
    _log('$reason\n  raw body: $body');
  }

  void _log(String message, [StackTrace? stackTrace]) {
    if (!kDebugMode) return;
    log(message, name: 'Notifications', stackTrace: stackTrace);
  }
}
