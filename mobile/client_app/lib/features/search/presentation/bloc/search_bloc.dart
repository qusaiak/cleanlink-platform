import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/search_usecase.dart';
import '../../domain/entities/search_entity.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase searchUseCase;
  int _requestVersion = 0;

  SearchBloc(this.searchUseCase) : super(const SearchState()) {
    on<UpdateSearchQuery>(_onUpdateSearchQuery);

    on<Search>(_onSearch);

    on<ClearSearch>(_onClearSearch);

    on<SelectTab>(_onSelectTab);

    on<UpdateAvailability>(_onUpdateAvailability);

    on<UpdateSortOrder>(_onUpdateSortOrder);

    on<UpdatePriceRange>(_onUpdatePriceRange);

    on<UpdateDistance>(_onUpdateDistance);

    on<UpdateMinRate>(_onUpdateMinRate);

    on<UpdateRegion>(_onUpdateRegion);

    on<ResetFilters>(_onResetFilters);

    on<ApplyFiltersAndSearch>(_onApplyFiltersAndSearch);
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<SearchState> emit,
  ) {
    _requestVersion++;
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSearch(Search event, Emitter<SearchState> emit) async {
    final query = state.searchQuery.trim();
    if (query.isEmpty) return;
    await _executeSearch(
      emit,
      query: query,
      regionId: state.regionId,
      minimumPrice: state.minimumPrice,
      maximumPrice: state.maximumPrice,
      rating: state.rating,
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    _requestVersion++;
    emit(
      state.copyWith(
        searchQuery: '',
        isLoading: false,
        hasSearched: false,
        clearData: true,
        clearErrorMessage: true,
      ),
    );
  }

  void _onSelectTab(SelectTab event, Emitter<SearchState> emit) {
    emit(state.copyWith(selectedTab: event.tab));
  }

  void _onUpdateAvailability(
    UpdateAvailability event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(availability: event.availability));
  }

  void _onUpdateSortOrder(UpdateSortOrder event, Emitter<SearchState> emit) {
    emit(state.copyWith(sortOrder: event.order));
  }

  void _onUpdatePriceRange(UpdatePriceRange event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        priceRange: event.priceRange,
        minimumPrice: event.priceRange.start,
        maximumPrice: event.priceRange.end,
      ),
    );
  }

  void _onUpdateDistance(UpdateDistance event, Emitter<SearchState> emit) {
    emit(state.copyWith(distance: event.distance));
  }

  void _onUpdateMinRate(UpdateMinRate event, Emitter<SearchState> emit) {
    emit(state.copyWith(rating: event.rate, clearRating: event.rate == 0));
  }

  void _onUpdateRegion(UpdateRegion event, Emitter<SearchState> emit) {
    emit(state.copyWith(regionId: event.regionId));
  }

  Future<void> _onResetFilters(
    ResetFilters event,
    Emitter<SearchState> emit,
  ) async {
    final query = state.searchQuery.trim();
    emit(
      state.copyWith(
        availability: Availability.today,

        sortOrder: SortOrder.asc,

        priceRange: const RangeValues(10, 1000),

        clearRegion: true,
        clearPrice: true,
        clearRating: true,
        isLoading: query.isNotEmpty,
        hasSearched: query.isNotEmpty,
        clearData: true,
        clearErrorMessage: true,
      ),
    );
    if (query.isEmpty) {
      _requestVersion++;
      return;
    }
    await _executeSearch(
      emit,
      query: query,
      regionId: null,
      minimumPrice: null,
      maximumPrice: null,
      rating: null,
      loadingAlreadyEmitted: true,
    );
  }

  Future<void> _onApplyFiltersAndSearch(
    ApplyFiltersAndSearch event,
    Emitter<SearchState> emit,
  ) async {
    final query = state.searchQuery.trim();
    final regionId = event.regionId == null || event.regionId == 0
        ? null
        : event.regionId;
    final rate = event.rate == null || event.rate == 0 ? null : event.rate;
    final hasPriceFilter = event.priceRange != const RangeValues(10, 1000);
    final minimumPrice = hasPriceFilter ? event.priceRange.start : null;
    final maximumPrice = hasPriceFilter ? event.priceRange.end : null;
    if (query.isEmpty) {
      emit(
        state.copyWith(
          regionId: regionId,
          clearRegion: regionId == null,
          priceRange: event.priceRange,
          minimumPrice: minimumPrice,
          maximumPrice: maximumPrice,
          clearPrice: !hasPriceFilter,
          rating: rate,
          clearRating: rate == null,
        ),
      );
    } else {
      emit(
        state.copyWith(
          regionId: regionId,
          clearRegion: regionId == null,
          priceRange: event.priceRange,
          minimumPrice: minimumPrice,
          maximumPrice: maximumPrice,
          clearPrice: !hasPriceFilter,
          rating: rate,
          clearRating: rate == null,
          isLoading: true,
          hasSearched: true,
          clearData: true,
          clearErrorMessage: true,
        ),
      );
      await _executeSearch(
        emit,
        query: query,
        regionId: regionId,
        minimumPrice: minimumPrice,
        maximumPrice: maximumPrice,
        rating: rate,
        loadingAlreadyEmitted: true,
      );
    }
  }

  Future<void> _executeSearch(
    Emitter<SearchState> emit, {
    required String query,
    required int? regionId,
    required double? minimumPrice,
    required double? maximumPrice,
    required double? rating,
    bool loadingAlreadyEmitted = false,
  }) async {
    final requestVersion = ++_requestVersion;
    if (!loadingAlreadyEmitted) {
      emit(
        state.copyWith(
          isLoading: true,
          hasSearched: true,
          clearData: true,
          clearErrorMessage: true,
        ),
      );
    }

    try {
      final result = await searchUseCase(
        query: query,
        regionId: regionId,
        minimumPrice: minimumPrice,
        maximumPrice: maximumPrice,
        rating: rating,
      );
      if (requestVersion != _requestVersion) return;
      emit(
        state.copyWith(
          isLoading: false,
          hasSearched: true,
          data: result,
          clearErrorMessage: true,
        ),
      );
    } catch (error) {
      if (requestVersion != _requestVersion) return;
      emit(
        state.copyWith(
          isLoading: false,
          hasSearched: true,
          clearData: true,
          errorMessage: error is Failure
              ? error.message
              : error.toString().replaceFirst('Exception: ', ''),
        ),
      );
    }
  }
}
