import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/search_query.dart';
import '../models/service_summary_model.dart';

/// Remote data source contract for the search feature.
///
/// Implementations return a list of models or throw a [DioException]; the
/// repository turns those into `Either<Failure, T>`. Three implementations:
///  - [SearchRemoteDataSourceImpl]   — real Dio calls (production path).
///  - `FakeSearchRemoteDataSource`    — in-memory filter used today.
///  - `FallbackSearchRemoteDataSource` — live-with-fallback wrapper.
abstract class SearchRemoteDataSource {
  Future<List<ServiceSummaryModel>> search(SearchQuery query);
}

/// Real implementation backed by the shared [Dio] client (production path).
/// Sends the search as query parameters (`mode`, `field`, `q`).
class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final Dio dio;

  SearchRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ServiceSummaryModel>> search(SearchQuery query) async {
    final response = await dio.get(
      ApiUrlParameters.searchServices,
      queryParameters: {
        'mode': query.modeCode,
        if (query.fieldCode != null) 'field': query.fieldCode,
        'q': query.term,
      },
    );
    final data = response.data;
    final list = data is Map<String, dynamic>
        ? (data['results'] ?? data['data'] ?? const [])
        : data;
    return (list as List)
        .map((e) => ServiceSummaryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
