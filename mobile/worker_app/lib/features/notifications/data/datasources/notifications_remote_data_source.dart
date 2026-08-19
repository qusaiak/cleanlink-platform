import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../models/app_notification_model.dart';

/// Remote data source contract for the notifications feature.
///
/// Implementations talk to the network and either return a model or throw a
/// [DioException] on failure; the repository turns those into
/// `Either<Failure, T>`. The production implementation is
/// [NotificationsRemoteDataSourceImpl] (real Dio calls).
abstract class NotificationsRemoteDataSource {
  Future<List<AppNotificationModel>> getNotifications();

  /// Marks the notification [id] read on the server. Returns nothing — the
  /// caller flips the local read flag on success, so the response body's
  /// shape doesn't matter.
  Future<void> markAsRead(String id);

  Future<List<AppNotificationModel>> markAllAsRead();
}

/// Real implementation backed by the shared [Dio] client (production path).
///
/// The live backend answers `GET /api/notifications` with a DOUBLE-wrapped
/// envelope — the standard `{status, message, data}` shell, whose `data` is
/// itself `{data: [...], pagination: {...}}`:
///
/// ```json
/// {
///   "status": 200,
///   "message": "Your notifications inbox synchronized successfully",
///   "data": {
///     "data": [
///       {"id": 68, "title": "…", "body": "…", "is_read": false,
///        "created_at": "2026-08-07T15:47:13.000000Z",
///        "data": {"type": "new_task_assigned", "order_id": 19,
///                 "status": "assigned_to_worker"}}
///     ],
///     "pagination": {"current_page": 1, "per_page": 6, "total": 16,
///                    "last_page": 3, "from": 1, "to": 6,
///                    "has_more_pages": true}
///   }
/// }
/// ```
///
/// [_extractItems] therefore descends through the envelope until it reaches an
/// actual list instead of unwrapping a fixed number of levels.
class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  /// Page size asked of the server.
  ///
  /// The backend's own default is `per_page = 6`
  /// (`NotificationController::index`), so sending nothing silently truncates
  /// the feed to the six newest items — with no "load more" affordance in the
  /// UI, the rest would simply be unreachable. The feed is a flat, fully
  /// scrollable list, so one generous page is requested instead.
  static const int kPageSize = 50;

  final Dio dio;

  NotificationsRemoteDataSourceImpl(this.dio);

  /// Finds the notification array inside whatever envelope the API used.
  ///
  /// Returns `null` when no list is reachable at all — a SHAPE error, which
  /// must be reported as a failure rather than mistaken for an empty inbox.
  /// An empty list that really was present comes back as `[]`.
  ///
  /// Handles, in order of how deeply nested they are:
  ///  - a bare `[...]`;
  ///  - `{"data": [...]}` / `{"notifications": [...]}` (the in-memory mock);
  ///  - `{"data": {"data": [...], "pagination": {…}}}` (this backend);
  ///  - `{"data": {"data": [...], "current_page": 1}}` (a stock Laravel
  ///    paginator, in case the controller is ever simplified to return one).
  static List<dynamic>? _extractItems(dynamic body) {
    dynamic node = body;

    // Bounded so a self-referential or pathological payload cannot loop.
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

  /// Turns a response body into models, skipping (and logging) any single
  /// malformed entry instead of losing the whole feed to one bad row.
  ///
  /// Throws a [FormatException] when the payload's SHAPE is unreadable, so the
  /// repository reports a real failure — the previous behaviour, an unchecked
  /// `as List` cast, surfaced as a bare `TypeError`, and any "return []
  /// on error" alternative would render as a permanently, silently empty
  /// screen.
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
        // One unparsable notification must not empty the list.
        _log('skipped a malformed entry ($error): $item', stackTrace);
      }
    }

    // Newest first. The backend already orders by `created_at desc`; sorting
    // here keeps the order guaranteed no matter which source answered
    // (the in-memory fallback sorts the same way).
    parsed.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return parsed;
  }

  @override
  Future<List<AppNotificationModel>> getNotifications() async {
    final response = await dio.get(
      ApiUrlParameters.notifications,
      // Explicit page 1: without `per_page` the server caps the feed at its
      // own default of 6.
      queryParameters: const {'page': 1, 'per_page': kPageSize},
    );
    _logResponse(response);
    return _parseList(response.data);
  }

  @override
  Future<void> markAsRead(String id) async {
    // POST /api/notifications/{id}/mark-as-read — bearer token via the shared
    // interceptor. Success is the 2xx status itself; the body isn't needed.
    final response = await dio.post(ApiUrlParameters.markNotificationRead(id));
    _logResponse(response);
  }

  @override
  Future<List<AppNotificationModel>> markAllAsRead() async {
    // The backend has NO bulk "mark all read" endpoint, so this fetches the
    // feed and marks each currently-unread item read one by one, then returns
    // the refreshed list. Individual failures are logged but don't abort the
    // batch — a best-effort "mark all" is better than none.
    final current = await getNotifications();
    final unread = current.where((n) => !n.isRead);
    for (final n in unread) {
      try {
        await markAsRead(n.id);
      } catch (error, stackTrace) {
        _log('mark-all: failed to mark ${n.id} ($error)', stackTrace);
      }
    }
    return getNotifications();
  }

  // ---- debug logging (kept for testing; compiled out of release builds) ----

  /// Logs the full URL, status and RAW body of a notifications response, so the
  /// server's actual payload is confirmed rather than guessed. Debug only.
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
