import '../../domain/entities/search_query.dart';
import '../models/service_summary_model.dart';
import 'search_remote_data_source.dart';

/// In-memory mock of [SearchRemoteDataSource] used while there is no backend.
///
/// Filters a fixed catalogue locally so the search UI is fully functional
/// offline. It mirrors the real source's contract, so switching to the API is
/// a one-line change in `injection_container.dart`.
///
/// Matching rules:
///  - [SearchMode.general] → case-insensitive "contains" across service name,
///    client name and location (empty term → everything).
///  - [SearchMode.custom]  → "contains" against the single chosen field; for
///    [SearchField.time] it matches a few date/time representations.
class FakeSearchRemoteDataSource implements SearchRemoteDataSource {
  // Fixed dates so the mock is stable and doesn't depend on the wall clock.
  // Mirrors the worker's tasks (same ids / request numbers / clients) so a
  // tapped result opens the matching task. The real backend serves the same
  // join from its database.
  final List<ServiceSummaryModel> _catalogue = [
    ServiceSummaryModel(
      id: '1',
      serviceName: 'تنظيف سكني',
      clientName: 'أحمد علي',
      location: 'حي النرجس، الرياض',
      scheduledAt: DateTime(2024, 5, 24, 10, 0),
      requestId: '4589',
      price: 75,
    ),
    ServiceSummaryModel(
      id: '2',
      serviceName: 'تنظيف عميق',
      clientName: 'محمد السالم',
      location: 'حي الياسمين، الرياض',
      scheduledAt: DateTime(2024, 5, 24, 11, 30),
      requestId: '4590',
      price: 200,
    ),
    ServiceSummaryModel(
      id: '3',
      serviceName: 'تنظيف مكتب',
      clientName: 'سارة العتيبي',
      location: 'حي الملقا، الرياض',
      scheduledAt: DateTime(2024, 5, 24, 13, 0),
      requestId: '4591',
      price: 120,
    ),
    ServiceSummaryModel(
      id: '4',
      serviceName: 'تنظيف منزل شامل',
      clientName: 'نورة القحطاني',
      location: 'حي العليا، الرياض',
      scheduledAt: DateTime(2024, 5, 25, 9, 0),
      requestId: '4592',
      price: 300,
    ),
    ServiceSummaryModel(
      id: '5',
      serviceName: 'تنظيف بعد الترميم',
      clientName: 'خالد الزهراني',
      location: 'حي النخيل، جدة',
      scheduledAt: DateTime(2024, 5, 25, 15, 30),
      requestId: '4593',
      price: 180,
    ),
  ];

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 400));

  bool _contains(String haystack, String needle) =>
      haystack.toLowerCase().contains(needle.toLowerCase());

  /// A small set of textual forms a time query might match: ISO date,
  /// "h:mm", 24h "HH:mm", the day number and the hour.
  String _timeHaystack(DateTime dt) {
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    final hour12 = dt.hour % 12 == 0 ? 12 : dt.hour % 12;
    final iso = dt.toIso8601String();
    return '$iso $hh:$mm $hour12:$mm ${dt.day} ${dt.month} ${dt.year}';
  }

  @override
  Future<List<ServiceSummaryModel>> search(SearchQuery query) async {
    await _delay();
    final term = query.term.trim();
    if (term.isEmpty) return List.of(_catalogue);

    return _catalogue.where((s) {
      if (query.mode == SearchMode.general) {
        return _contains(s.serviceName, term) ||
            _contains(s.clientName, term) ||
            _contains(s.location, term) ||
            _contains(_timeHaystack(s.scheduledAt), term);
      }
      switch (query.field) {
        case SearchField.serviceName:
          return _contains(s.serviceName, term);
        case SearchField.clientName:
          return _contains(s.clientName, term);
        case SearchField.location:
          return _contains(s.location, term);
        case SearchField.time:
          return _contains(_timeHaystack(s.scheduledAt), term);
      }
    }).toList();
  }
}
