import 'package:equatable/equatable.dart';

import 'selected_map_location.dart';

class ClientLocationEntity extends Equatable {
  const ClientLocationEntity({
    required this.id,
    required this.userId,
    required this.address,
    required this.localName,
    required this.latitude,
    required this.longitude,
    this.createdAt,
    this.updatedAt,
  });

  final int id;
  final int userId;
  final String address;
  final String localName;
  final double latitude;
  final double longitude;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  SelectedMapLocation toSelectedMapLocation() => SelectedMapLocation(
    latitude: latitude,
    longitude: longitude,
    formattedAddress: address,
    savedLocationId: id,
    name: localName,
  );

  @override
  List<Object?> get props => [
    id,
    userId,
    address,
    localName,
    latitude,
    longitude,
    createdAt,
    updatedAt,
  ];
}
