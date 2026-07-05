import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/search_usecase.dart';
import '../../domain/entities/search_entity.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final SearchUseCase searchUseCase;

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
    emit(state.copyWith(searchQuery: event.query));
  }

  Future<void> _onSearch(Search event, Emitter<SearchState> emit) async {
    if (state.searchQuery.trim().isEmpty) {
      return;
    }

    emit(state.copyWith(isLoading: true));

    try {
      print("state.regionId");
      print(state.regionId);
      print(state.priceRange);
      print(state.minRate);

      final result = await searchUseCase(
        state.searchQuery,
        state.hasRegionFilter ? state.regionId : null,
        state.hasPriceFilter
            ? "${state.priceRange.start.toInt()}-${state.priceRange.end.toInt()}"
            : null,
        state.hasRateFilter ? state.minRate : null,
      );

      emit(state.copyWith(isLoading: false, hasSearched: true, data: result));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(const SearchState());
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
    emit(state.copyWith(priceRange: event.priceRange, hasPriceFilter: true));
  }

  void _onUpdateDistance(UpdateDistance event, Emitter<SearchState> emit) {
    emit(state.copyWith(distance: event.distance));
  }

  void _onUpdateMinRate(UpdateMinRate event, Emitter<SearchState> emit) {
    emit(state.copyWith(minRate: event.rate, hasRateFilter: true));
  }

  void _onUpdateRegion(UpdateRegion event, Emitter<SearchState> emit) {
    emit(state.copyWith(regionId: event.regionId, hasRegionFilter: true));
  }

  void _onResetFilters(ResetFilters event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        availability: Availability.today,

        sortOrder: SortOrder.asc,

        priceRange: const RangeValues(10, 1000),

        regionId: 0,

        minRate: 0,

        hasPriceFilter: false,

        hasRateFilter: false,

        hasRegionFilter: false,
      ),
    );
  }

  Future<void> _onApplyFiltersAndSearch(
    ApplyFiltersAndSearch event,
    Emitter<SearchState> emit,
  ) async {
    if (state.searchQuery.trim().isEmpty) {
      state.copyWith(
        regionId: event.regionId,
        priceRange: event.priceRange,
        minRate: event.rate,

        hasRegionFilter: true,
        hasPriceFilter: true,
        hasRateFilter: true,
      );
    } else {
      emit(
        state.copyWith(
          regionId: event.regionId,
          priceRange: event.priceRange,
          minRate: event.rate,
          hasRegionFilter: true,
          hasPriceFilter: true,
          hasRateFilter: true,
          isLoading: true,
        ),
      );

      final result = await searchUseCase(
        state.searchQuery,
        event.regionId,

        "${event.priceRange.start.round()} - ${event.priceRange.end.round()}",
        event.rate,
      );

      emit(
        state.copyWith(
          regionId: event.regionId,
          priceRange: event.priceRange,
          minRate: event.rate,
          hasRegionFilter: event.regionId != null,
          hasPriceFilter: true,
          hasRateFilter: event.rate != null,
          isLoading: false,
          hasSearched: true,
          data: result,
        ),
      );
    }
  }
}
