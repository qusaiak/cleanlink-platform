import 'package:equatable/equatable.dart';

import 'pagination_model.dart';

class PaginatedResult<T> extends Equatable {
  const PaginatedResult({required this.items, required this.pagination});

  final List<T> items;
  final PaginationModel pagination;

  @override
  List<Object?> get props => [
    items,
    pagination.currentPage,
    pagination.perPage,
    pagination.total,
    pagination.lastPage,
    pagination.from,
    pagination.to,
    pagination.hasMorePages,
  ];
}
