part of 'regions_bloc.dart';

abstract class RegionsState extends Equatable {
  const RegionsState();

  @override
  List<Object?> get props => [];
}

class RegionsInitial extends RegionsState {
  const RegionsInitial();
}

/// ===== Regions list =====
class RegionsLoading extends RegionsState {
  const RegionsLoading({this.isRefreshing = false});

  final bool isRefreshing;

  @override
  List<Object?> get props => [isRefreshing];
}

class RegionsLoaded extends RegionsState {
  const RegionsLoaded({
    required this.regions,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory RegionsLoaded.fromResult(
    PaginatedResult<RegionEntity> result, {
    List<RegionEntity>? regions,
  }) => RegionsLoaded(
    regions: regions ?? result.items,
    currentPage: result.pagination.currentPage,
    perPage: result.pagination.perPage,
    total: result.pagination.total,
    lastPage: result.pagination.lastPage,
    hasMorePages: result.pagination.hasMorePages,
  );

  final List<RegionEntity> regions;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  RegionsLoaded copyWith({
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => RegionsLoaded(
    regions: regions,
    currentPage: currentPage,
    perPage: perPage,
    total: total,
    lastPage: lastPage,
    hasMorePages: hasMorePages,
    isLoadingMore: isLoadingMore ?? this.isLoadingMore,
    loadMoreError: clearLoadMoreError
        ? null
        : loadMoreError ?? this.loadMoreError,
  );

  @override
  List<Object?> get props => [
    regions,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    isLoadingMore,
    loadMoreError,
  ];
}

class RegionsError extends RegionsState {
  final String message;

  const RegionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegionNamesLoading extends RegionsState {
  const RegionNamesLoading();
}

class RegionNamesLoaded extends RegionsState {
  final List<RegionEntity> regions;

  const RegionNamesLoaded(this.regions);

  @override
  List<Object?> get props => [regions];
}

class RegionNamesError extends RegionsState {
  final String message;

  const RegionNamesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ===== Region details =====
class RegionLoading extends RegionsState {
  const RegionLoading();
}

class RegionLoaded extends RegionsState {
  final RegionDetailsEntity region;

  const RegionLoaded(this.region);

  @override
  List<Object?> get props => [region];
}

class RegionError extends RegionsState {
  final String message;

  const RegionError(this.message);

  @override
  List<Object?> get props => [message];
}
