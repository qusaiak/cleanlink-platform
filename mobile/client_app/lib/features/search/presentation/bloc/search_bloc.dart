import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  SearchBloc() : super(const SearchState()) {
    on<StartSearching>(_onStartSearching);

    on<StopSearching>(_onStopSearching);

    on<UpdateSearchQuery>(_onUpdateSearchQuery);

    on<ClearSearch>(_onClearSearch);

    on<SelectTab>(_onSelectTab);

    on<UpdateAvailability>(_onUpdateAvailability);

    on<UpdateSortOrder>(_onUpdateSortOrder);

    on<UpdatePriceRange>(_onUpdatePriceRange);

    on<UpdateDistance>(_onUpdateDistance);

    on<UpdateMinRate>(_onUpdateMinRate);

    on<ResetFilters>(_onResetFilters);
  }

  void _onStartSearching(StartSearching event, Emitter<SearchState> emit) {
    emit(state.copyWith(isSearching: true));
  }

  void _onStopSearching(StopSearching event, Emitter<SearchState> emit) {
    if (state.searchQuery.isEmpty) {
      emit(state.copyWith(isSearching: false));
    }
  }

  void _onUpdateSearchQuery(
    UpdateSearchQuery event,
    Emitter<SearchState> emit,
  ) {
    if (
    event.query ==
        state.searchQuery
    ) {
      return;
    }
    emit(
      state.copyWith(
        searchQuery: event.query,
        isSearching: event.query.isNotEmpty,
      ),
    );
  }

  void _onClearSearch(ClearSearch event, Emitter<SearchState> emit) {
    emit(state.copyWith(searchQuery: '', isSearching: false));
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

  void _onUpdatePriceRange(
    UpdatePriceRange event,
    Emitter<SearchState> emit,
  ) {
    emit(state.copyWith(priceRange: event.priceRange));
  }

  void _onUpdateDistance(UpdateDistance event, Emitter<SearchState> emit) {
    emit(state.copyWith(distance: event.distance));
  }

  void _onUpdateMinRate(UpdateMinRate event, Emitter<SearchState> emit) {
    emit(state.copyWith(minRate: event.rate));
  }

  void _onResetFilters(ResetFilters event, Emitter<SearchState> emit) {
    emit(
      state.copyWith(
        availability: Availability.today,
        sortOrder: SortOrder.asc,
        priceRange: RangeValues(10, 100),
        distance: 1,
        minRate: 0,
      ),
    );
  }
}
