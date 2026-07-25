import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../entities/search_query.dart';
import '../entities/service_summary.dart';

/// Domain contract for searching services / job requests. Returns
/// `Either<Failure, T>` consistent with the rest of the app.
abstract class SearchRepository {
  Future<Either<Failure, List<ServiceSummary>>> search(SearchQuery query);
}
