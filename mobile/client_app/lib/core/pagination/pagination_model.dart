class PaginationModel {
  const PaginationModel({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.hasMorePages,
  });

  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;
  final bool hasMorePages;

  factory PaginationModel.fromJson(Map<String, dynamic> json) {
    return PaginationModel(
      currentPage: _toInt(json['current_page']) ?? 1,
      perPage: _toInt(json['per_page']) ?? 0,
      total: _toInt(json['total']) ?? 0,
      lastPage: _toInt(json['last_page']) ?? 1,
      from: _toInt(json['from']),
      to: _toInt(json['to']),
      hasMorePages: _toBool(json['has_more_pages']),
    );
  }

  Map<String, dynamic> toJson() => {
    'current_page': currentPage,
    'per_page': perPage,
    'total': total,
    'last_page': lastPage,
    'from': from,
    'to': to,
    'has_more_pages': hasMorePages,
  };

  static int? _toInt(Object? value) => int.tryParse(value?.toString() ?? '');

  static bool _toBool(Object? value) {
    if (value is bool) return value;
    if (value is num) return value != 0;
    return const {
      '1',
      'true',
      'yes',
    }.contains(value?.toString().trim().toLowerCase());
  }
}
