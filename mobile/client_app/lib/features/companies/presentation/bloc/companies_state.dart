part of 'companies_bloc.dart';

sealed class CompaniesState extends Equatable {
  const CompaniesState();

  @override
  List<Object?> get props => const [];
}

class CompaniesInitial extends CompaniesState {}

class CompaniesLoading extends CompaniesState {
  const CompaniesLoading({this.isRefreshing = false});

  final bool isRefreshing;

  @override
  List<Object?> get props => [isRefreshing];
}

class CompaniesLoaded extends CompaniesState {
  const CompaniesLoaded({
    required this.companies,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory CompaniesLoaded.fromResult(
    PaginatedResult<CompanyEntity> result, {
    List<CompanyEntity>? companies,
  }) => CompaniesLoaded(
    companies: companies ?? result.items,
    currentPage: result.pagination.currentPage,
    perPage: result.pagination.perPage,
    total: result.pagination.total,
    lastPage: result.pagination.lastPage,
    hasMorePages: result.pagination.hasMorePages,
  );

  final List<CompanyEntity> companies;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  CompaniesLoaded copyWith({
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => CompaniesLoaded(
    companies: companies,
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
    companies,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    isLoadingMore,
    loadMoreError,
  ];
}

class CompaniesError extends CompaniesState {
  final String error;

  const CompaniesError(this.error);

  @override
  List<Object?> get props => [error];
}

class CompanyDetailsInitial extends CompaniesState {
  const CompanyDetailsInitial();
}

class CompanyDetailsLoading extends CompaniesState {
  const CompanyDetailsLoading();
}

class CompanyDetailsSuccess extends CompaniesState {
  final CompanyEntity company;

  const CompanyDetailsSuccess(this.company);

  @override
  List<Object?> get props => [company];
}

class CompanyDetailsError extends CompaniesState {
  final Failure failure;

  const CompanyDetailsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
