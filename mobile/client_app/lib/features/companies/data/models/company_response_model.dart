import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import 'company_model.dart';
import '../../domain/entities/company_entity.dart';

class CompanyResponseModel {
  final int status;

  final String message;

  final List<CompanyModel> companies;
  final PaginationModel pagination;

  const CompanyResponseModel({
    required this.status,
    required this.message,
    required this.companies,
    required this.pagination,
  });

  factory CompanyResponseModel.fromJson(Map<String, dynamic> json) {
    final data = _requiredMap(json['data'], 'data');
    final items = data['data'];
    if (items is! List) {
      throw const FormatException('Expected data.data to be a list');
    }
    return CompanyResponseModel(
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      companies: items
          .whereType<Map>()
          .map((item) => CompanyModel.fromJson(Map<String, dynamic>.from(item)))
          .toList(growable: false),
      pagination: PaginationModel.fromJson(
        _requiredMap(data['pagination'], 'data.pagination'),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'data': companies.map((company) => company.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };

  PaginatedResult<CompanyEntity> toEntity() {
    return PaginatedResult(
      items: companies.map((company) => company.toEntity()).toList(),
      pagination: pagination,
    );
  }

  static Map<String, dynamic> _requiredMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected $field to be an object');
  }
}
