part of 'services_bloc.dart';

abstract class ServicesState extends Equatable {
  const ServicesState();

  @override
  List<Object?> get props => const [];
}

class ServicesInitial extends ServicesState {}

class ServicesLoading extends ServicesState {
  const ServicesLoading({this.isRefreshing = false});

  final bool isRefreshing;

  @override
  List<Object?> get props => [isRefreshing];
}

class ServicesLoaded extends ServicesState {
  const ServicesLoaded({
    required this.services,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory ServicesLoaded.fromResult(
    PaginatedResult<ServiceEntity> result, {
    List<ServiceEntity>? services,
  }) => ServicesLoaded(
    services: services ?? result.items,
    currentPage: result.pagination.currentPage,
    perPage: result.pagination.perPage,
    total: result.pagination.total,
    lastPage: result.pagination.lastPage,
    hasMorePages: result.pagination.hasMorePages,
  );

  final List<ServiceEntity> services;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  ServicesLoaded copyWith({
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => ServicesLoaded(
    services: services,
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
    services,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    isLoadingMore,
    loadMoreError,
  ];
}

class ServicesError extends ServicesState {
  final String message;

  const ServicesError(this.message);

  @override
  List<Object?> get props => [message];
}

class OffersLoading extends ServicesState {
  const OffersLoading({this.isRefreshing = false});

  final bool isRefreshing;

  @override
  List<Object?> get props => [isRefreshing];
}

class OffersLoaded extends ServicesState {
  const OffersLoaded({
    required this.offers,
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMorePages,
    this.isLoadingMore = false,
    this.loadMoreError,
  });

  factory OffersLoaded.fromResult(
    PaginatedResult<ServiceEntity> result, {
    List<ServiceEntity>? offers,
  }) => OffersLoaded(
    offers: offers ?? result.items,
    currentPage: result.pagination.currentPage,
    perPage: result.pagination.perPage,
    total: result.pagination.total,
    lastPage: result.pagination.lastPage,
    hasMorePages: result.pagination.hasMorePages,
  );

  final List<ServiceEntity> offers;
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMorePages;
  final bool isLoadingMore;
  final String? loadMoreError;

  bool get canLoadMore => hasMorePages && !isLoadingMore;

  OffersLoaded copyWith({
    bool? isLoadingMore,
    String? loadMoreError,
    bool clearLoadMoreError = false,
  }) => OffersLoaded(
    offers: offers,
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
    offers,
    currentPage,
    perPage,
    total,
    lastPage,
    hasMorePages,
    isLoadingMore,
    loadMoreError,
  ];
}

class OffersError extends ServicesState {
  final String message;

  const OffersError(this.message);

  @override
  List<Object?> get props => [message];
}

class ServiceDetailsInitial extends ServicesState {
  const ServiceDetailsInitial();
}

class ServiceDetailsLoading extends ServicesState {
  const ServiceDetailsLoading();
}

class ServiceDetailsLoaded extends ServicesState {
  final ServiceEntity service;

  final PackageEntity? selectedPackage;
  final Map<int, int> openPackageAttributeQuantities;

  const ServiceDetailsLoaded({
    required this.service,
    this.selectedPackage,
    this.openPackageAttributeQuantities = const {},
  });

  ServiceDetailsLoaded copyWith({
    ServiceEntity? service,
    PackageEntity? selectedPackage,
    Map<int, int>? openPackageAttributeQuantities,
  }) {
    return ServiceDetailsLoaded(
      service: service ?? this.service,
      selectedPackage: selectedPackage ?? this.selectedPackage,
      openPackageAttributeQuantities:
          openPackageAttributeQuantities ?? this.openPackageAttributeQuantities,
    );
  }

  @override
  List<Object?> get props => [
    service,
    selectedPackage,
    openPackageAttributeQuantities,
  ];
}

class ServiceDetailsError extends ServicesState {
  final Failure failure;

  const ServiceDetailsError(this.failure);

  @override
  List<Object?> get props => [failure];
}
