import 'client_location_model.dart';

class LocationsResponseModel {
  const LocationsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  final int status;
  final String message;
  final List<ClientLocationModel> data;

  factory LocationsResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return LocationsResponseModel(
      status: _status(json['status']),
      message: json['message']?.toString() ?? '',
      data: raw is List
          ? raw
                .whereType<Map>()
                .map(
                  (item) => ClientLocationModel.fromRemoteJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }
}

class LocationResponseModel {
  const LocationResponseModel({
    required this.status,
    required this.message,
    this.data,
  });

  final int status;
  final String message;
  final ClientLocationModel? data;

  factory LocationResponseModel.fromJson(Map<String, dynamic> json) {
    final raw = json['data'];
    return LocationResponseModel(
      status: _status(json['status']),
      message: json['message']?.toString() ?? '',
      data: raw is Map
          ? ClientLocationModel.fromRemoteJson(Map<String, dynamic>.from(raw))
          : null,
    );
  }
}

class DeleteLocationResponseModel {
  const DeleteLocationResponseModel({
    required this.status,
    required this.message,
  });

  final int status;
  final String message;

  factory DeleteLocationResponseModel.fromJson(Map<String, dynamic> json) =>
      DeleteLocationResponseModel(
        status: _status(json['status']),
        message: json['message']?.toString() ?? '',
      );
}

int _status(dynamic value) =>
    value is num ? value.toInt() : int.tryParse(value?.toString() ?? '') ?? 0;
