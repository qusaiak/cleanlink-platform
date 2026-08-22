class LocationRequestModel {
  const LocationRequestModel({
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.name,
  });

  final double latitude;
  final double longitude;
  final String address;
  final String? name;

  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'address': address,
    'name': name,
  };
}
