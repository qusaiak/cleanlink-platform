part of 'locations_bloc.dart';

sealed class LocationsEvent extends Equatable {
  const LocationsEvent();

  @override
  List<Object?> get props => [];
}

class LoadLocationsEvent extends LocationsEvent {
  const LoadLocationsEvent();
}

class RefreshLocationsEvent extends LocationsEvent {
  const RefreshLocationsEvent({this.completer});
  final Completer<void>? completer;

  @override
  List<Object?> get props => [completer];
}

class AddLocationEvent extends LocationsEvent {
  const AddLocationEvent({required this.location, this.name});
  final SelectedMapLocation location;
  final String? name;

  @override
  List<Object?> get props => [location, name];
}

class UpdateLocationEvent extends LocationsEvent {
  const UpdateLocationEvent({
    required this.id,
    required this.location,
    this.name,
  });
  final int id;
  final SelectedMapLocation location;
  final String? name;

  @override
  List<Object?> get props => [id, location, name];
}

class DeleteLocationEvent extends LocationsEvent {
  const DeleteLocationEvent(this.id);
  final int id;

  @override
  List<Object?> get props => [id];
}

class ClearLocationsFeedbackEvent extends LocationsEvent {
  const ClearLocationsFeedbackEvent();
}

class ClearLocationsSessionEvent extends LocationsEvent {
  const ClearLocationsSessionEvent();
}
