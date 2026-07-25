import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/search_query.dart';
import '../entities/service_summary.dart';
import '../repositories/search_repository.dart';

/// Searches services / job requests for the given [SearchQuery] (general or
/// custom-by-field).
class SearchServicesUseCase
    implements UseCase<Either<Failure, List<ServiceSummary>>, SearchQuery> {
  final SearchRepository repository;

  SearchServicesUseCase(this.repository);

  @override
  Future<Either<Failure, List<ServiceSummary>>> call({SearchQuery? params}) {
    return repository.search(params ?? const SearchQuery());
  }
}
