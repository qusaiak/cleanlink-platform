import '../../../companies/data/models/company_model.dart';
import '../../../companies/domain/entities/company_entity.dart';
import '../../../services/data/models/service_model.dart';
import '../../../services/domain/entities/service_entity.dart';
import '../../domain/entities/my_review_entity.dart';

enum MyReviewKind { company, service }

class MyReviewsResponseModel {
  final int status;
  final String message;
  final MyReviewsDataModel? data;

  const MyReviewsResponseModel({
    required this.status,
    required this.message,
    required this.data,
  });

  factory MyReviewsResponseModel.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    return MyReviewsResponseModel(
      status: _intValue(json['status']),
      message: json['message']?.toString() ?? '',
      data: rawData is Map
          ? MyReviewsDataModel.fromJson(Map<String, dynamic>.from(rawData))
          : null,
    );
  }
}

class MyReviewsDataModel {
  final List<MyReviewModel> companies;
  final List<MyReviewModel> services;

  const MyReviewsDataModel({
    this.companies = const [],
    this.services = const [],
  });

  factory MyReviewsDataModel.fromJson(Map<String, dynamic> json) {
    return MyReviewsDataModel(
      companies: _reviewList(json['companies'], MyReviewKind.company),
      services: _reviewList(json['services'], MyReviewKind.service),
    );
  }

  MyReviewsEntity toEntity({required String languageCode}) {
    return MyReviewsEntity(
      companies: companies
          .map((review) => review.toEntity(languageCode: languageCode))
          .toList(growable: false),
      services: services
          .map((review) => review.toEntity(languageCode: languageCode))
          .toList(growable: false),
    );
  }
}

class MyReviewModel {
  final int id;
  final int clientId;
  final String? comment;
  final int rating;
  final int reviewableId;
  final String reviewableType;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final Map<String, dynamic>? reviewable;
  final MyReviewKind kind;

  const MyReviewModel({
    required this.id,
    required this.clientId,
    required this.comment,
    required this.rating,
    required this.reviewableId,
    required this.reviewableType,
    required this.createdAt,
    required this.updatedAt,
    required this.reviewable,
    required this.kind,
  });

  factory MyReviewModel.fromJson(
    Map<String, dynamic> json, {
    required MyReviewKind kind,
  }) {
    final rawReviewable = json['reviewable'];
    final normalizedComment = json['comment']?.toString().trim();
    return MyReviewModel(
      id: _intValue(json['id']),
      clientId: _intValue(json['client_id']),
      comment: normalizedComment == null || normalizedComment.isEmpty
          ? null
          : normalizedComment,
      rating: _intValue(json['rating']).clamp(0, 5).toInt(),
      reviewableId: _intValue(json['reviewable_id']),
      reviewableType: json['reviewable_type']?.toString() ?? '',
      createdAt: _dateValue(json['created_at']),
      updatedAt: _dateValue(json['updated_at']),
      reviewable: rawReviewable is Map
          ? Map<String, dynamic>.from(rawReviewable)
          : null,
      kind: kind,
    );
  }

  MyReviewEntity toEntity({required String languageCode}) {
    final isArabic = languageCode.toLowerCase().startsWith('ar');
    return MyReviewEntity(
      id: id,
      clientId: clientId,
      comment: comment,
      rating: rating,
      reviewableId: reviewableId,
      reviewableType: reviewableType,
      createdAt: createdAt,
      updatedAt: updatedAt,
      company: kind == MyReviewKind.company
          ? _companyEntity(reviewable, isArabic: isArabic)
          : null,
      service: kind == MyReviewKind.service
          ? _serviceEntity(reviewable, isArabic: isArabic)
          : null,
    );
  }
}

List<MyReviewModel> _reviewList(dynamic value, MyReviewKind kind) {
  if (value is! List) return const [];
  final reviews = <MyReviewModel>[];
  for (final item in value) {
    if (item is! Map) continue;
    try {
      reviews.add(
        MyReviewModel.fromJson(Map<String, dynamic>.from(item), kind: kind),
      );
    } catch (_) {
      // A malformed review must not invalidate the rest of the response.
    }
  }
  return List.unmodifiable(reviews);
}

CompanyModel? _companyModel(
  Map<String, dynamic>? json, {
  required bool isArabic,
}) {
  if (json == null) return null;
  try {
    final normalized = Map<String, dynamic>.from(json)
      ..['name'] = _localizedValue(json, 'name', isArabic)
      ..['description'] = _localizedValue(json, 'description', isArabic)
      ..['location'] = _localizedValue(json, 'location', isArabic)
      ..['id'] = _nullableInt(json['id'])
      ..['manager_id'] = _nullableInt(json['manager_id'])
      ..['region_id'] = _nullableInt(json['region_id'])
      ..['rating'] = _nullableDouble(json['rating'])
      ..['is_favorite'] = _boolValue(json['is_favorite'])
      ..['created_at'] = _validDateText(json['created_at'])
      ..['updated_at'] = _validDateText(json['updated_at']);
    return CompanyModel.fromJson(normalized);
  } catch (_) {
    return null;
  }
}

ServiceModel? _serviceModel(
  Map<String, dynamic>? json, {
  required bool isArabic,
}) {
  if (json == null) return null;
  try {
    final normalized = Map<String, dynamic>.from(json)
      ..['name'] = _localizedValue(json, 'name', isArabic)
      ..['description'] = _localizedValue(json, 'description', isArabic)
      ..['id'] = _nullableInt(json['id'])
      ..['company_id'] = _nullableInt(json['company_id'])
      ..['category_id'] = _nullableInt(json['category_id'])
      ..['rating'] = _nullableDouble(json['rating'])
      ..['min_duration'] = _nullableInt(json['min_duration'])
      ..['max_duration'] = _nullableInt(json['max_duration'])
      ..['price'] = _nullableInt(json['price'])
      ..['discount'] = _nullableInt(json['discount'])
      ..['is_favorite'] = _boolValue(json['is_favorite'])
      ..['created_at'] = _validDateText(json['created_at'])
      ..['updated_at'] = _validDateText(json['updated_at']);
    return ServiceModel.fromJson(normalized);
  } catch (_) {
    return null;
  }
}

String _localizedValue(Map<String, dynamic> json, String field, bool isArabic) {
  final preferred = json['${field}_${isArabic ? 'ar' : 'en'}']?.toString();
  final fallback = json['${field}_${isArabic ? 'en' : 'ar'}']?.toString();
  return preferred?.trim().isNotEmpty == true
      ? preferred!.trim()
      : fallback?.trim() ?? json[field]?.toString().trim() ?? '';
}

int _intValue(dynamic value) => _nullableInt(value) ?? 0;

int? _nullableInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  final text = value?.toString() ?? '';
  return int.tryParse(text) ?? double.tryParse(text)?.toInt();
}

double? _nullableDouble(dynamic value) {
  if (value is num) return value.toDouble();
  return double.tryParse(value?.toString() ?? '');
}

bool? _boolValue(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value != 0;
  final normalized = value?.toString().trim().toLowerCase();
  if (normalized == 'true' || normalized == '1') return true;
  if (normalized == 'false' || normalized == '0') return false;
  return null;
}

DateTime? _dateValue(dynamic value) =>
    DateTime.tryParse(value?.toString() ?? '');

String? _validDateText(dynamic value) {
  final parsed = _dateValue(value);
  return parsed?.toIso8601String();
}

CompanyEntity? _companyEntity(
  Map<String, dynamic>? json, {
  required bool isArabic,
}) => _companyModel(json, isArabic: isArabic)?.toEntity();

ServiceEntity? _serviceEntity(
  Map<String, dynamic>? json, {
  required bool isArabic,
}) => _serviceModel(json, isArabic: isArabic)?.toEntity();
