import 'package:equatable/equatable.dart';

/// How a search is scoped:
/// - [general] → free-text across everything (service name, client, location…).
/// - [custom]  → restricted to a single [SearchField].
enum SearchMode { general, custom }

/// The dimension a [SearchMode.custom] search targets.
enum SearchField { serviceName, clientName, location, time }

/// A search request: the [mode], the [field] it targets when custom, and the
/// [term] being searched for. Pure domain value object.
class SearchQuery extends Equatable {
  final SearchMode mode;

  /// Only meaningful when [mode] is [SearchMode.custom]; ignored otherwise.
  final SearchField field;
  final String term;

  const SearchQuery({
    this.mode = SearchMode.general,
    this.field = SearchField.serviceName,
    this.term = '',
  });

  SearchQuery copyWith({
    SearchMode? mode,
    SearchField? field,
    String? term,
  }) {
    return SearchQuery(
      mode: mode ?? this.mode,
      field: field ?? this.field,
      term: term ?? this.term,
    );
  }

  @override
  List<Object?> get props => [mode, field, term];

  // ---- string code mapping shared with the backend query params ----

  String get modeCode => mode == SearchMode.custom ? 'custom' : 'general';

  String? get fieldCode {
    if (mode != SearchMode.custom) return null;
    switch (field) {
      case SearchField.serviceName:
        return 'service_name';
      case SearchField.clientName:
        return 'client_name';
      case SearchField.location:
        return 'location';
      case SearchField.time:
        return 'time';
    }
  }
}
