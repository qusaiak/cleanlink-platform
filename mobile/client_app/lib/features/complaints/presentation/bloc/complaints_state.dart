part of 'complaints_bloc.dart';

class ComplaintTabState extends Equatable {
  const ComplaintTabState({
    this.items = const [],
    this.hasLoaded = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.error,
  });

  final List<ComplaintEntity> items;
  final bool hasLoaded;
  final bool isLoading;
  final bool isRefreshing;
  final String? error;

  bool get isInitialLoading => isLoading && !hasLoaded;

  ComplaintTabState copyWith({
    List<ComplaintEntity>? items,
    bool? hasLoaded,
    bool? isLoading,
    bool? isRefreshing,
    String? error,
    bool clearError = false,
  }) => ComplaintTabState(
    items: items ?? this.items,
    hasLoaded: hasLoaded ?? this.hasLoaded,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    error: clearError ? null : error ?? this.error,
  );

  @override
  List<Object?> get props => [items, hasLoaded, isLoading, isRefreshing, error];
}

class ComplaintsState extends Equatable {
  const ComplaintsState({
    this.services = const ComplaintTabState(),
    this.companies = const ComplaintTabState(),
    this.selectedComplaint,
    this.isLoadingDetails = false,
    this.detailsError,
    this.isCreating = false,
    this.createSucceeded = false,
    this.createError,
    this.unreadCount = 0,
  });

  final ComplaintTabState services;
  final ComplaintTabState companies;
  final ComplaintEntity? selectedComplaint;
  final bool isLoadingDetails;
  final String? detailsError;
  final bool isCreating;
  final bool createSucceeded;
  final String? createError;
  final int unreadCount;

  ComplaintTabState listFor(ComplaintType type) =>
      type == ComplaintType.company ? companies : services;

  ComplaintsState withList(ComplaintType type, ComplaintTabState list) =>
      type == ComplaintType.company
      ? copyWith(companies: list)
      : copyWith(services: list);

  ComplaintsState copyWith({
    ComplaintTabState? services,
    ComplaintTabState? companies,
    ComplaintEntity? selectedComplaint,
    bool clearSelectedComplaint = false,
    bool? isLoadingDetails,
    String? detailsError,
    bool clearDetailsError = false,
    bool? isCreating,
    bool? createSucceeded,
    String? createError,
    bool clearCreateError = false,
    int? unreadCount,
  }) => ComplaintsState(
    services: services ?? this.services,
    companies: companies ?? this.companies,
    selectedComplaint: clearSelectedComplaint
        ? null
        : selectedComplaint ?? this.selectedComplaint,
    isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
    detailsError: clearDetailsError ? null : detailsError ?? this.detailsError,
    isCreating: isCreating ?? this.isCreating,
    createSucceeded: createSucceeded ?? this.createSucceeded,
    createError: clearCreateError ? null : createError ?? this.createError,
    unreadCount: unreadCount ?? this.unreadCount,
  );

  @override
  List<Object?> get props => [
    services,
    companies,
    selectedComplaint,
    isLoadingDetails,
    detailsError,
    isCreating,
    createSucceeded,
    createError,
    unreadCount,
  ];
}
