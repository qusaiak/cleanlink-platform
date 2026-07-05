part of 'regions_bloc.dart';

abstract class RegionsState extends Equatable {
  const RegionsState();

  @override
  List<Object?> get props => [];
}

class RegionsInitial extends RegionsState {
  const RegionsInitial();
}

/// ===== Regions list =====
class RegionsLoading extends RegionsState {
  const RegionsLoading();
}

class RegionsLoaded extends RegionsState {
  final List<RegionEntity> regions;

  const RegionsLoaded(this.regions);

  @override
  List<Object?> get props => [regions];
}

class RegionsError extends RegionsState {
  final String message;

  const RegionsError(this.message);

  @override
  List<Object?> get props => [message];
}

class RegionNamesLoading extends RegionsState {
  const RegionNamesLoading();
}

class RegionNamesLoaded extends RegionsState {
  final List<RegionEntity> regions;

  const RegionNamesLoaded(this.regions);

  @override
  List<Object?> get props => [regions];
}

class RegionNamesError extends RegionsState {
  final String message;

  const RegionNamesError(this.message);

  @override
  List<Object?> get props => [message];
}

/// ===== Region details =====
class RegionLoading extends RegionsState {
  const RegionLoading();
}

class RegionLoaded extends RegionsState {
  final RegionDetailsEntity region;

  const RegionLoaded(this.region);

  @override
  List<Object?> get props => [region];
}

class RegionError extends RegionsState {
  final String message;

  const RegionError(this.message);

  @override
  List<Object?> get props => [message];
}
