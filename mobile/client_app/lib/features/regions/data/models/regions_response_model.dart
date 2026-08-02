import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/region_entity.dart';
import 'region_model.dart';

class RegionsResponseModel {
  final int status;
  final String message;
  final List<RegionModel> regions;
  final PaginationModel pagination;

  const RegionsResponseModel({
    required this.status,
    required this.message,
    required this.regions,
    required this.pagination,
  });

  factory RegionsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final data = rawData is Map ? Map<String, dynamic>.from(rawData) : null;
    final items = data?['data'] ?? rawData;
    if (items is! List) {
      throw const FormatException('Expected data or data.data to be a list');
    }
    return RegionsResponseModel(
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      regions: items
          .whereType<Map>()
          .map((item) => RegionModel.fromJson(Map<String, dynamic>.from(item)))
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
      'data': regions.map((region) => region.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };

  PaginatedResult<RegionEntity> toEntity() => PaginatedResult(
    items: regions.map((region) => region.toEntity()).toList(),
    pagination: pagination,
  );

  static Map<String, dynamic> _requiredMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected $field to be an object');
  }
}
