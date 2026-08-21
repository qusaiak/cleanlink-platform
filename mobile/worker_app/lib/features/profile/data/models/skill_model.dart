import '../../../../config/language/app_language_info.dart';
import '../../domain/entities/worker_profile.dart';

class SkillModel extends WorkerSkill {
  const SkillModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
  });

  factory SkillModel.fromJson(
    Map<String, dynamic> json, {
    String? languageCode,
  }) {
    final locale = languageCode ?? AppLanguageInfo.languageCode;

    final nameAr = _string(json['name_ar']);
    final nameEn = _string(json['name_en']);
    if (nameAr.isNotEmpty || nameEn.isNotEmpty) {
      return SkillModel(id: _int(json['id']), nameAr: nameAr, nameEn: nameEn);
    }

    final localized = _firstNonEmpty([
      json['name'],
      json['title'],
      json['skill_name'],
    ]);

    return SkillModel(
      id: _int(json['id']),
      nameAr: locale == 'ar' ? localized : '',
      nameEn: locale == 'ar' ? '' : localized,
    );
  }

  static List<WorkerSkill> listFrom(dynamic body, {String? languageCode}) {
    final list = _unwrap(body);
    if (list is! List) return const [];

    return list
        .whereType<Map>()
        .map(
          (e) => SkillModel.fromJson(
            Map<String, dynamic>.from(e),
            languageCode: languageCode,
          ),
        )
        .where((s) => s.id != 0)
        .toList(growable: false);
  }

  static dynamic _unwrap(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return null;

    final data = body['data'];
    if (data is List) return data;
    if (data is Map && data['skills'] is List) return data['skills'];
    if (body['skills'] is List) return body['skills'];
    return null;
  }

  Map<String, dynamic> toCacheJson() => {
    'id': id,
    'name_ar': nameAr,
    'name_en': nameEn,
  };

  static Map<String, dynamic> cacheJsonOf(WorkerSkill skill) => {
    'id': skill.id,
    'name_ar': skill.nameAr,
    'name_en': skill.nameEn,
  };

  static String _string(dynamic value) => value?.toString().trim() ?? '';

  static int _int(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(_string(value)) ?? 0;
  }

  static String _firstNonEmpty(List<dynamic> candidates) {
    for (final candidate in candidates) {
      final text = _string(candidate);
      if (text.isNotEmpty) return text;
    }
    return '';
  }
}
