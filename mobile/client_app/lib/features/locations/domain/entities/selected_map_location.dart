import 'package:equatable/equatable.dart';

class SelectedMapLocation extends Equatable {
  const SelectedMapLocation({
    required this.latitude,
    required this.longitude,
    required this.formattedAddress,
    this.placeId,
    this.savedLocationId,
    this.name,
  });

  final double latitude;
  final double longitude;
  final String formattedAddress;
  final String? placeId;
  final int? savedLocationId;
  final String? name;

  bool get isSaved => savedLocationId != null;

  bool get hasValidCoordinates =>
      latitude >= -90 &&
      latitude <= 90 &&
      longitude >= -180 &&
      longitude <= 180;

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    formattedAddress,
    placeId,
    savedLocationId,
    name,
  ];
}
