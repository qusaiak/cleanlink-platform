import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import 'service_model.dart';
import '../../domain/entities/service_entity.dart';

class ServicesResponseModel {
  final int status;
  final String message;
  final List<ServiceModel> services;
  final PaginationModel pagination;

  const ServicesResponseModel({
    required this.status,
    required this.message,
    required this.services,
    required this.pagination,
  });

  factory ServicesResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is Map ? Map<String, dynamic>.from(rawData) : null;
    final items = data?['data'] ?? rawData;
    if (items is! List) {
      throw const FormatException('Expected data or data.data to be a list');
    }
    return ServicesResponseModel(
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      services: items
          .whereType<Map>()
          .map((item) => ServiceModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      pagination: data == null
          ? PaginationModel(
              currentPage: 1,
              perPage: items.length,
              total: items.length,
              lastPage: 1,
              from: items.isEmpty ? null : 1,
              to: items.isEmpty ? null : items.length,
              hasMorePages: false,
            )
          : PaginationModel.fromJson(
              _requiredMap(data['pagination'], 'data.pagination'),
            ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'data': services.map((service) => service.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };

  PaginatedResult<ServiceEntity> toEntity() {
    return PaginatedResult(
      items: services.map((service) => service.toEntity()).toList(),
      pagination: pagination,
    );
  }

  static Map<String, dynamic> _requiredMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected $field to be an object');
  }
}
