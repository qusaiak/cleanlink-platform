import 'package:json_annotation/json_annotation.dart';

import '../../domain/entities/company_work_time_entity.dart';

part 'company_work_time_model.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake, createFactory: false)
class CompanyWorkTimeModel {
  final int id;
  final int companyId;
  final int dayOfWeek;
  final String? openAt;
  final String? closeAt;
  final bool isHoliday;

  const CompanyWorkTimeModel({
    required this.id,
    required this.companyId,
    required this.dayOfWeek,
    required this.openAt,
    required this.closeAt,
    required this.isHoliday,
  });

  factory CompanyWorkTimeModel.fromJson(Map<String, dynamic> json) {
    final model = CompanyWorkTimeModel.tryFromJson(json);
    if (model == null) {
      throw const FormatException('Invalid company working-time item');
    }
    return model;
  }

  static CompanyWorkTimeModel? tryFromJson(Map<String, dynamic> json) {
    final id = _parseInt(json['id']);
    final companyId = _parseInt(json['company_id']);
    final dayOfWeek = _parseInt(json['day_of_week']);
    if (id == null ||
        companyId == null ||
        dayOfWeek == null ||
        dayOfWeek < 0 ||
        dayOfWeek > 6) {
      return null;
    }

    return CompanyWorkTimeModel(
      id: id,
      companyId: companyId,
      dayOfWeek: dayOfWeek,
      openAt: _parseNullableString(json['open_at']),
      closeAt: _parseNullableString(json['close_at']),
      isHoliday: parseWorkTimeBoolean(json['is_holiday']),
    );
  }

  Map<String, dynamic> toJson() => _$CompanyWorkTimeModelToJson(this);

  CompanyWorkTimeEntity toEntity() => CompanyWorkTimeEntity(
    id: id,
    companyId: companyId,
    dayOfWeek: dayOfWeek,
    openAt: openAt,
    closeAt: closeAt,
    isHoliday: isHoliday,
  );
}

bool parseWorkTimeBoolean(dynamic value) {
  if (value is bool) return value;
  if (value is num) return value == 1;
  if (value is String) {
    final normalized = value.trim().toLowerCase();
    return normalized == '1' || normalized == 'true';
  }
  return false;
}

int? _parseInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  return int.tryParse(value?.toString() ?? '');
}

String? _parseNullableString(dynamic value) {
  if (value == null) return null;
  final text = value.toString().trim();
  return text.isEmpty ? null : text;
}
