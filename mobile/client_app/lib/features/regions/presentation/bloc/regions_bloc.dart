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
    on<GetRegionEvent>(_onGetRegion);
    on<GetRegionNamesEvent>(_onGetRegionNames);
  }

  Future<void> _onGetRegions(
    GetRegionsEvent event,
    Emitter<RegionsState> emit,
  ) async {
    try {
      emit(const RegionsLoading());
      final regions = await getRegionsUseCase();
      emit(RegionsLoaded(regions));
    } catch (e) {
      emit(RegionsError(e.toString()));
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
}
