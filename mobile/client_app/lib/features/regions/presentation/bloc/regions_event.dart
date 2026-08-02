part of 'regions_bloc.dart';

abstract class RegionsEvent extends Equatable {
  const RegionsEvent();

  @override
  List<Object?> get props => [];
}

class GetRegionsEvent extends RegionsEvent {
  const GetRegionsEvent({this.refresh = false, this.completer});

  final bool refresh;
  final Completer<void>? completer;

  @override
  List<Object?> get props => [refresh];
}

class GetMoreRegionsEvent extends RegionsEvent {
  const GetMoreRegionsEvent({this.retry = false});

  final bool retry;

  @override
  List<Object?> get props => [retry];
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
