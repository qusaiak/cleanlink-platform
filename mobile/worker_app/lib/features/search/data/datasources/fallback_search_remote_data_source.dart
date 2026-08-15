import 'package:dio/dio.dart';

import '../../domain/entities/search_query.dart';
import '../models/service_summary_model.dart';
import 'search_remote_data_source.dart';

/// A [SearchRemoteDataSource] that prefers live results from the
/// backend/database but transparently falls back to the in-memory filter when
/// the server is unreachable — mirroring the other fallback sources.
class FallbackSearchRemoteDataSource implements SearchRemoteDataSource {
  final SearchRemoteDataSource primary;
  final SearchRemoteDataSource fallback;

  FallbackSearchRemoteDataSource({
    required this.primary,
    required this.fallback,
  });

  bool _isServerUnreachable(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return false;
    }
  }

  @override
  Future<List<ServiceSummaryModel>> search(SearchQuery query) async {
    try {
      return await primary.search(query);
    } on DioException catch (e) {
      if (_isServerUnreachable(e)) return await fallback.search(query);
      rethrow;
    }
  }
}
