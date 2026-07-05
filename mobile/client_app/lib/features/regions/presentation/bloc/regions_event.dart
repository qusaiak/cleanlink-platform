part of 'regions_bloc.dart';

abstract class RegionsEvent extends Equatable {
  const RegionsEvent();

  @override
  List<Object?> get props => [];
}

class GetRegionsEvent extends RegionsEvent {
  const GetRegionsEvent();
}

class GetRegionNamesEvent extends RegionsEvent {
  const GetRegionNamesEvent();
}

class GetRegionEvent extends RegionsEvent {
  final int id;

  const GetRegionEvent(this.id);

  @override
  List<Object?> get props => [id];
}
