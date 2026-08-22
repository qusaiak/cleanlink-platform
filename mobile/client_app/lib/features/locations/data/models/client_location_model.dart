import '../../domain/entities/client_location_entity.dart';

class ClientLocationModel {
  const ClientLocationModel({
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

  factory ClientLocationModel.fromRemoteJson(Map<String, dynamic> json) {
    return ClientLocationModel(
      id: _parseInt(json['id'], field: 'id'),
      userId: _parseInt(json['user_id'], field: 'user_id'),
      address: json['address']?.toString() ?? '',
      localName: json['name']?.toString().trim() ?? '',
      latitude: _parseDouble(json['latitude'], field: 'latitude'),
      longitude: _parseDouble(json['longitude'], field: 'longitude'),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
    );
  }

  factory ClientLocationModel.fromCacheJson(Map<String, dynamic> json) =>
      ClientLocationModel(
        id: _parseInt(json['id'], field: 'id'),
        userId: _parseInt(json['user_id'], field: 'user_id'),
        address: json['address']?.toString() ?? '',
        localName:
            json['local_name']?.toString() ?? json['name']?.toString() ?? '',
        latitude: _parseDouble(json['latitude'], field: 'latitude'),
        longitude: _parseDouble(json['longitude'], field: 'longitude'),
        createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
        updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? ''),
      );

  factory ClientLocationModel.fromEntity(ClientLocationEntity entity) {
    return ClientLocationModel(
      id: entity.id,
      userId: entity.userId,
      address: entity.address,
      localName: entity.localName,
      latitude: entity.latitude,
      longitude: entity.longitude,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_id': userId,
    'address': address,
    'local_name': localName,
    'latitude': latitude,
    'longitude': longitude,
    if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
    if (updatedAt != null) 'updated_at': updatedAt!.toIso8601String(),
  };

  ClientLocationEntity toEntity() => ClientLocationEntity(
    id: id,
    userId: userId,
    address: address,
    localName: localName,
    latitude: latitude,
    longitude: longitude,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  ClientLocationModel copyWith({String? address, String? localName}) =>
      ClientLocationModel(
        id: id,
        userId: userId,
        address: address ?? this.address,
        localName: localName ?? this.localName,
        latitude: latitude,
        longitude: longitude,
        createdAt: createdAt,
        updatedAt: updatedAt,
      );
}

int _parseInt(dynamic value, {required String field}) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  final parsed = int.tryParse(value?.toString() ?? '');
  if (parsed != null) return parsed;
  throw FormatException('Invalid $field');
}

double _parseDouble(dynamic value, {required String field}) {
  if (value is num) return value.toDouble();
  final parsed = double.tryParse(value?.toString() ?? '');
  if (parsed != null) return parsed;
  throw FormatException('Invalid $field');
}
