import '../../../../core/pagination/paginated_result.dart';
import '../../../../core/pagination/pagination_model.dart';
import '../../domain/entities/category_entity.dart';
import 'category_model.dart';

class CategoriesResponseModel {
  const CategoriesResponseModel({
    required this.status,
    required this.message,
    required this.categories,
    required this.pagination,
  });

  final int status;
  final String message;
  final List<CategoryModel> categories;
  final PaginationModel pagination;

  factory CategoriesResponseModel.fromJson(Map<String, dynamic> json) {
    final outerData = _requiredMap(json['data'], 'data');
    final rawCategories = outerData['data'];
    if (rawCategories is! List) {
      throw const FormatException('Expected data.data to be a list');
    }

    return CategoriesResponseModel(
      status: int.tryParse(json['status']?.toString() ?? '') ?? 0,
      message: json['message']?.toString() ?? '',
      categories: rawCategories
          .whereType<Map>()
          .map(
            (item) => CategoryModel.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false),
      pagination: PaginationModel.fromJson(
        _requiredMap(outerData['pagination'], 'data.pagination'),
      ),
    );
  }

  Map<String, dynamic> toJson() => {
    'status': status,
    'message': message,
    'data': {
      'data': categories.map((category) => category.toJson()).toList(),
      'pagination': pagination.toJson(),
    },
  };

  PaginatedResult<CategoryEntity> toEntity() => PaginatedResult(
    items: categories.map((category) => category.toEntity()).toList(),
    pagination: pagination,
  );

  static Map<String, dynamic> _requiredMap(Object? value, String field) {
    if (value is Map) return Map<String, dynamic>.from(value);
    throw FormatException('Expected $field to be an object');
  }
}
