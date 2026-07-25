part of 'search_bloc.dart';

/// Events for the search feature.
sealed class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

/// Run a search for the given [query] (mode + optional field + term).
class SubmitSearch extends SearchEvent {
  final SearchQuery query;

  const SubmitSearch(this.query);

  @override
  List<Object?> get props => [query];
}
