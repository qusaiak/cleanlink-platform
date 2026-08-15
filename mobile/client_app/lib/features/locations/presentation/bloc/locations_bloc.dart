import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/client_location_entity.dart';
import '../../domain/entities/selected_map_location.dart';
import '../../domain/usecases/locations_usecases.dart';

part 'locations_event.dart';
part 'locations_state.dart';

class LocationsBloc extends Bloc<LocationsEvent, LocationsState> {
  LocationsBloc(
    this._getCachedLocations,
    this._refreshLocations,
    this._addLocation,
    this._updateLocation,
    this._deleteLocation,
  ) : super(const LocationsState()) {
    on<LoadLocationsEvent>(_onLoad);
    on<RefreshLocationsEvent>(_onRefresh);
    on<AddLocationEvent>(_onAdd);
    on<UpdateLocationEvent>(_onUpdate);
    on<DeleteLocationEvent>(_onDelete);
    on<ClearLocationsFeedbackEvent>((_, emit) {
      emit(
        state.copyWith(
          clearErrorMessage: true,
          clearMutation: true,
          clearMutatedLocation: true,
        ),
      );
    });
    on<ClearLocationsSessionEvent>((_, emit) {
      emit(const LocationsState());
    });
  }

  final GetCachedLocationsUseCase _getCachedLocations;
  final RefreshLocationsUseCase _refreshLocations;
  final AddLocationUseCase _addLocation;
  final UpdateLocationUseCase _updateLocation;
  final DeleteLocationUseCase _deleteLocation;

  Future<void> _onLoad(
    LoadLocationsEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (state.isLoading || state.isRefreshing) return;
    emit(
      state.copyWith(
        isLoading: !state.hasCachedContent,
        isRefreshing: state.hasCachedContent,
        clearErrorMessage: true,
      ),
    );

    var cached = state.locations;
    try {
      cached = await _getCachedLocations();
      if (cached.isNotEmpty) {
        emit(
          state.copyWith(
            locations: cached,
            isLoading: false,
            isRefreshing: true,
            hasLoaded: true,
          ),
        );
      }
    } catch (_) {
      // A malformed/unavailable cache must never prevent a backend refresh.
    }

    await _refresh(emit, fallback: cached);
  }

  Future<void> _onRefresh(
    RefreshLocationsEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (state.isLoading || state.isRefreshing) {
      event.completer?.complete();
      return;
    }
    emit(state.copyWith(isRefreshing: true, clearErrorMessage: true));
    await _refresh(emit, fallback: state.locations);
    event.completer?.complete();
  }

  Future<void> _refresh(
    Emitter<LocationsState> emit, {
    required List<ClientLocationEntity> fallback,
  }) async {
    try {
      final locations = await _refreshLocations();
      emit(
        state.copyWith(
          locations: locations,
          hasLoaded: true,
          isLoading: false,
          isRefreshing: false,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          locations: fallback,
          hasLoaded: true,
          isLoading: false,
          isRefreshing: false,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> _onAdd(
    AddLocationEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (state.isMutating) return;
    emit(
      state.copyWith(
        isAdding: true,
        clearErrorMessage: true,
        clearMutation: true,
        clearMutatedLocation: true,
      ),
    );
    try {
      final location = await _addLocation(
        localName: event.name?.trim() ?? '',
        address: event.location.formattedAddress,
        latitude: event.location.latitude,
        longitude: event.location.longitude,
      );
      emit(
        state.copyWith(
          locations: [...state.locations, location],
          isAdding: false,
          mutation: LocationMutation.added,
          mutatedLocation: location,
        ),
      );
    } catch (error) {
      emit(state.copyWith(isAdding: false, errorMessage: _message(error)));
    }
  }

  Future<void> _onUpdate(
    UpdateLocationEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (state.isMutating) return;
    emit(
      state.copyWith(
        updatingLocationId: event.id,
        clearErrorMessage: true,
        clearMutation: true,
        clearMutatedLocation: true,
      ),
    );
    try {
      final location = await _updateLocation(
        id: event.id,
        localName: event.name?.trim() ?? '',
        address: event.location.formattedAddress,
        latitude: event.location.latitude,
        longitude: event.location.longitude,
      );
      emit(
        state.copyWith(
          locations: [
            for (final existing in state.locations)
              if (existing.id == event.id) location else existing,
          ],
          clearUpdatingLocationId: true,
          mutation: LocationMutation.updated,
          mutatedLocation: location,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          clearUpdatingLocationId: true,
          errorMessage: _message(error),
        ),
      );
    }
  }

  Future<void> _onDelete(
    DeleteLocationEvent event,
    Emitter<LocationsState> emit,
  ) async {
    if (state.isMutating) return;
    emit(
      state.copyWith(
        deletingLocationId: event.id,
        clearErrorMessage: true,
        clearMutation: true,
        clearMutatedLocation: true,
      ),
    );
    try {
      await _deleteLocation(event.id);
      emit(
        state.copyWith(
          locations: [
            for (final location in state.locations)
              if (location.id != event.id) location,
          ],
          clearDeletingLocationId: true,
          mutation: LocationMutation.deleted,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          clearDeletingLocationId: true,
          errorMessage: _message(error),
        ),
      );
    }
  }

  String _message(Object error) => error is Failure
      ? error.message
      : error.toString().replaceFirst('Exception: ', '');
}
