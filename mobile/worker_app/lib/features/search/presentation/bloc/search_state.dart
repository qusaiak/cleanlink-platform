part of 'search_bloc.dart';

enum SearchStatus { initial, loading, loaded, error }

class SearchState extends Equatable {
  final SearchStatus status;
  final SearchQuery query;
  final List<ServiceSummary> results;
  final Failure? error;

  const SearchState({
    this.status = SearchStatus.initial,
    this.query = const SearchQuery(),
    this.results = const [],
    this.error,
  });

  SearchState copyWith({
    SearchStatus? status,
    SearchQuery? query,
    List<ServiceSummary>? results,
    Failure? error,
  }) {
    return SearchState(
      status: status ?? this.status,
      query: query ?? this.query,
      results: results ?? this.results,
      error: error,
    );
  }

  @override
  List<Object?> get props => [status, query, results, error];
}
