import '../../../../config/language/app_language_info.dart';
import '../../domain/entities/worker_profile.dart';

/// Data-layer representation of [WorkerSkill], and the ONE place a skill is
/// parsed out of JSON.
///
/// The API returns a skill in **two different shapes**, and both reach this
/// class:
///
/// 1. the DICTIONARY (`GET /api/skills`) — `{"id": 1, "name": "..."}`, a single
///    `name` the SERVER already localized from the `Accept-Language` header;
/// 2. the worker's OWN skills (`data.worker_profile.skills[]` in the
///    attach/detach and `/me` responses) —
///    `{"id": 4, "name_ar": "...", "name_en": "...", "pivot": {...}}`, both
///    languages, unlocalized.
///
/// The entity keeps both names ([WorkerSkill.nameAr] / [WorkerSkill.nameEn]) so
/// shape 2 re-localizes instantly on a language switch. Shape 1 only carries
/// one string and cannot be split, so it is stored under the language it was
/// fetched in; [WorkerSkill.nameFor] falls back to the populated field, so the
/// name is never blank in the meantime — and the dictionary is re-fetched on a
/// language change, which is what actually translates it. Nothing here ever
/// translates a name on the client.
///
/// Every field is read defensively: a missing, null or wrongly-typed `id`,
/// `name`, `name_ar` or `name_en` yields a neutral default instead of throwing.
class SkillModel extends WorkerSkill {
  const SkillModel({
    required super.id,
    required super.nameAr,
    required super.nameEn,
  });

  /// Parses ONE skill in either shape.
  ///
  /// [languageCode] is the language the payload was fetched in — it only
  /// matters for shape 1 (`name`), to decide which field the localized string
  /// belongs in. Defaults to the app's current language.
  factory SkillModel.fromJson(Map<String, dynamic> json, {String? languageCode}) {
    final locale = languageCode ?? AppLanguageInfo.languageCode;

    // Shape 2 first: when the pair is present it is strictly richer than
    // `name`, so it wins even if the server ever sent all three.
    final nameAr = _string(json['name_ar']);
    final nameEn = _string(json['name_en']);
    if (nameAr.isNotEmpty || nameEn.isNotEmpty) {
      return SkillModel(id: _int(json['id']), nameAr: nameAr, nameEn: nameEn);
    }

    // Shape 1: one already-localized `name`. `title` / `skill_name` are
    // accepted as defensive aliases so a small server-side rename does not
    // blank out the whole dictionary.
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

  /// Parses a skills payload in any of the forms the API uses: the wrapped
  /// dictionary envelope `{status, message, data: [...]}`, a bare list, or a
  /// `{data: {skills: [...]}}` nesting.
  ///
  /// Entries that are not objects, and entries whose `id` could not be read,
  /// are skipped — an unusable row must not take the whole list down.
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

  /// Digs the actual array out of whatever envelope wraps it.
  static dynamic _unwrap(dynamic body) {
    if (body is List) return body;
    if (body is! Map) return null;

    final data = body['data'];
    if (data is List) return data;
    if (data is Map && data['skills'] is List) return data['skills'];
    if (body['skills'] is List) return body['skills'];
    return null;
  }

  /// The cache shape written to `LoginSession.skills` — deliberately the
  /// SERVER's own `{id, name_ar, name_en}` spelling, so a cached list and a
  /// freshly-parsed one go through exactly the same code path.
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

  /// A string from any scalar the server might send (`"x"`, `1`, `null`).
  static String _string(dynamic value) => value?.toString().trim() ?? '';

  /// An int from `4`, `"4"` or `4.0`; `0` when unreadable (that row is dropped
  /// by [listFrom], because a skill without an id can be neither attached nor
  /// detached).
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
