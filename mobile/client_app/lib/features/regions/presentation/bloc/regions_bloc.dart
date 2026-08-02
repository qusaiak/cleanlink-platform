import 'dart:async';

import '../../../../config/constants/pagination_constants.dart';
import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_utils.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/region_details_entity.dart';
import '../../domain/entities/region_entity.dart';
import '../../domain/usecases/get_region_names_usecase.dart';
import '../../domain/usecases/get_region_usecase.dart';
import '../../domain/usecases/get_regions_usecase.dart';

part 'regions_event.dart';
part 'regions_state.dart';

class RegionsBloc extends Bloc<RegionsEvent, RegionsState> {
  final GetRegionsUseCase getRegionsUseCase;
  final GetRegionUseCase getRegionUseCase;
  final GetRegionNamesUseCase getRegionNamesUseCase;

  RegionsBloc(
    this.getRegionsUseCase,
    this.getRegionUseCase,
    this.getRegionNamesUseCase,
  ) : super(const RegionsInitial()) {
    on<GetRegionsEvent>(_onGetRegions);
    on<GetMoreRegionsEvent>(_onGetMoreRegions);
    on<GetRegionEvent>(_onGetRegion);
    on<GetRegionNamesEvent>(_onGetRegionNames);
  }

  Future<void> _onGetRegions(
    GetRegionsEvent event,
    Emitter<RegionsState> emit,
  ) async {
    if (state is RegionsLoading ||
        (event.refresh &&
            state is RegionsLoaded &&
            (state as RegionsLoaded).isLoadingMore)) {
      _complete(event.completer);
      return;
    }
    try {
      emit(RegionsLoading(isRefreshing: event.refresh));
      final result = await getRegionsUseCase(
        page: 1,
        perPage: PaginationConstants.regionsPageSize,
      );
      emit(RegionsLoaded.fromResult(result));
    } catch (e) {
      emit(RegionsError(e.toString()));
    } finally {
      _complete(event.completer);
    }
  }

  Future<void> _onGetMoreRegions(
    GetMoreRegionsEvent event,
    Emitter<RegionsState> emit,
  ) async {
    final current = state;
    if (current is! RegionsLoaded ||
        !current.canLoadMore ||
        (current.loadMoreError != null && !event.retry)) {
      return;
    }

    emit(current.copyWith(isLoadingMore: true, clearLoadMoreError: true));
    try {
      final result = await getRegionsUseCase(
        page: current.currentPage + 1,
        perPage: PaginationConstants.regionsPageSize,
      );
      emit(
        RegionsLoaded.fromResult(
          result,
          regions: mergeWithoutDuplicates(
            current.regions,
            result.items,
            (region) => region.id,
          ),
        ),
      );
    } catch (e) {
      emit(current.copyWith(isLoadingMore: false, loadMoreError: e.toString()));
    }
  }

  Future<void> _onGetRegionNames(
    GetRegionNamesEvent event,
    Emitter<RegionsState> emit,
  ) async {
    try {
      emit(const RegionNamesLoading());
      final regions = await getRegionNamesUseCase();
      emit(RegionNamesLoaded(regions));
    } catch (e) {
      emit(RegionNamesError(e.toString()));
    }
  }

  Future<void> _onGetRegion(
    GetRegionEvent event,
    Emitter<RegionsState> emit,
  ) async {
    try {
      emit(const RegionLoading());
      final region = await getRegionUseCase(event.id);
      emit(RegionLoaded(region));
    } catch (e) {
      emit(RegionError(e.toString()));
    }
  }

  static void _complete(Completer<void>? completer) {
    if (completer != null && !completer.isCompleted) completer.complete();
  }
}
