part of 'categories_bloc.dart';

abstract class CategoriesState extends Equatable {
  const CategoriesState();

  @override
  List<Object?> get props => const [];
}

class CategoriesInitial extends CategoriesState {
  const CategoriesInitial();
}

/// ===== Categories list =====
class CategoriesLoading extends CategoriesState {
  const CategoriesLoading();
}

class CategoriesLoaded extends CategoriesState {
  const CategoriesLoaded({
    required this.categories,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory CategoriesLoaded.fromResult(
    PaginatedResult<CategoryEntity> result, {
    List<CategoryEntity>? categories,
  }) => CategoriesLoaded(
    categories: categories ?? result.items,
    currentPage: result.pagination.currentPage,
    perPage: result.pagination.perPage,
    total: result.pagination.total,
    lastPage: result.pagination.lastPage,
    hasMorePages: result.pagination.hasMorePages,
  );

  final List<CategoryEntity> categories;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  CategoriesLoaded copyWith({
    List<CategoryEntity>? categories,
    int? currentPage,
    int? perPage,
    int? total,
    int? lastPage,
    bool? hasMorePages,
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => CategoriesLoaded(
    categories: categories ?? this.categories,
    currentPage: currentPage ?? this.currentPage,
    perPage: perPage ?? this.perPage,
    total: total ?? this.total,
    lastPage: lastPage ?? this.lastPage,
    hasMorePages: hasMorePages ?? this.hasMorePages,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
  );

  @override
  List<Object?> get props => [
    categories,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    isLoadingMore,
    loadMoreError,
  ];
}

class CategoriesError extends CategoriesState {
  final String message;

  const CategoriesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ===== Single category (details) =====
class CategoryLoading extends CategoriesState {
  const CategoryLoading();
}

class CategoryLoaded extends CategoriesState {
  final CategoryEntity category;

  const CategoryLoaded(this.category);

  @override
  List<Object?> get props => [category];
}

class CategoryError extends CategoriesState {
  final Failure failure;

  const CategoryError(this.failure);

  @override
  List<Object?> get props => [failure];
}
