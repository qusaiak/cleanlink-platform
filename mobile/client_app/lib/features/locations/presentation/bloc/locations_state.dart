part of 'locations_bloc.dart';

enum LocationMutation { added, updated, deleted }

class LocationsState extends Equatable {
  const LocationsState({
    this.locations = const [],
    this.hasLoaded = false,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isAdding = false,
    this.updatingLocationId,
    this.deletingLocationId,
    this.errorMessage,
    this.mutation,
    this.mutatedLocation,
  });

  final List<ClientLocationEntity> locations;
  final bool hasLoaded;
  final bool isLoading;
  final bool isRefreshing;
  final bool isAdding;
  final int? updatingLocationId;
  final int? deletingLocationId;
  final String? errorMessage;
  final LocationMutation? mutation;
  final ClientLocationEntity? mutatedLocation;

  bool get hasCachedContent => locations.isNotEmpty;
  bool get isMutating =>
      isAdding || updatingLocationId != null || deletingLocationId != null;

  LocationsState copyWith({
    List<ClientLocationEntity>? locations,
    bool? hasLoaded,
    bool? isLoading,
    bool? isRefreshing,
    bool? isAdding,
    int? updatingLocationId,
    bool clearUpdatingLocationId = false,
    int? deletingLocationId,
    bool clearDeletingLocationId = false,
    String? errorMessage,
    bool clearErrorMessage = false,
    LocationMutation? mutation,
    bool clearMutation = false,
    ClientLocationEntity? mutatedLocation,
    bool clearMutatedLocation = false,
  }) => LocationsState(
    locations: locations ?? this.locations,
    hasLoaded: hasLoaded ?? this.hasLoaded,
    isLoading: isLoading ?? this.isLoading,
    isRefreshing: isRefreshing ?? this.isRefreshing,
    isAdding: isAdding ?? this.isAdding,
    updatingLocationId: clearUpdatingLocationId
        ? null
        : updatingLocationId ?? this.updatingLocationId,
    deletingLocationId: clearDeletingLocationId
        ? null
        : deletingLocationId ?? this.deletingLocationId,
    errorMessage: clearErrorMessage ? null : errorMessage ?? this.errorMessage,
    mutation: clearMutation ? null : mutation ?? this.mutation,
    mutatedLocation: clearMutatedLocation
        ? null
        : mutatedLocation ?? this.mutatedLocation,
  );

  @override
  List<Object?> get props => [
    locations,
    hasLoaded,
    isLoading,
    isRefreshing,
    isAdding,
    updatingLocationId,
    deletingLocationId,
    errorMessage,
    mutation,
    mutatedLocation,
  ];
}
