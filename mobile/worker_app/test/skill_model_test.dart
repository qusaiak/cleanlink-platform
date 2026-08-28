import 'package:flutter_test/flutter_test.dart';
import 'package:worker_app/features/profile/data/models/skill_model.dart';

/// Covers the one thing the skills feature cannot get wrong: the API returns a
/// skill in TWO different shapes, and both have to land on the same entity.
void main() {
  group('SkillModel.fromJson', () {
    test('dictionary shape ({id, name}) files the name under the fetch '
        'language', () {
      final ar = SkillModel.fromJson({
        'id': 1,
        'name': 'التنظيف العام',
      }, languageCode: 'ar');
      expect(ar.id, 1);
      expect(ar.nameAr, 'التنظيف العام');
      expect(ar.nameEn, '');
      // Falls back to the populated side rather than rendering blank.
      expect(ar.nameFor('en'), 'التنظيف العام');
      expect(ar.nameFor('ar'), 'التنظيف العام');

      final en = SkillModel.fromJson({
        'id': 2,
        'name': 'General Cleaning',
      }, languageCode: 'en');
      expect(en.nameEn, 'General Cleaning');
      expect(en.nameAr, '');
      expect(en.nameFor('ar'), 'General Cleaning');
    });

    test('worker shape ({id, name_ar, name_en, pivot}) keeps both names', () {
      final skill = SkillModel.fromJson({
        'id': 4,
        'name_ar': 'تلميع الأرضيات',
        'name_en': 'Floor Polishing',
        'pivot': {'worker_profile_id': 1, 'skill_id': 4},
      }, languageCode: 'en');

      expect(skill.id, 4);
      expect(skill.nameFor('ar'), 'تلميع الأرضيات');
      expect(skill.nameFor('en'), 'Floor Polishing');
    });

    test('never throws when fields are missing, null or wrongly typed', () {
      final empty = SkillModel.fromJson(const {}, languageCode: 'en');
      expect(empty.id, 0);
      expect(empty.nameFor('en'), '');

      final nulls = SkillModel.fromJson(const {
        'id': null,
        'name': null,
        'name_ar': null,
        'name_en': null,
      }, languageCode: 'ar');
      expect(nulls.id, 0);
      expect(nulls.nameFor('ar'), '');

      // id arriving as a string is still usable — it is what attach/detach send.
      final stringId = SkillModel.fromJson(const {
        'id': '7',
        'name': 'Windows',
      }, languageCode: 'en');
      expect(stringId.id, 7);

      // Only one of the pair present.
      final arOnly = SkillModel.fromJson(const {
        'id': 3,
        'name_ar': 'نوافذ',
        'name_en': null,
      }, languageCode: 'en');
      expect(arOnly.nameFor('en'), 'نوافذ');
    });
  });

  group('SkillModel.listFrom', () {
    test('unwraps the dictionary envelope', () {
      final skills = SkillModel.listFrom({
        'status': 200,
        'message': 'Skills dictionary fetched successfully',
        'data': [
          {'id': 1, 'name': 'General Cleaning'},
          {'id': 2, 'name': 'Window Cleaning'},
        ],
      }, languageCode: 'en');

      expect(skills.map((s) => s.id), [1, 2]);
      expect(skills.first.nameFor('en'), 'General Cleaning');
    });

    test('unwraps a bare list and drops unusable rows', () {
      final skills = SkillModel.listFrom([
        {'id': 1, 'name': 'Ok'},
        {'name': 'no id — dropped'},
        'not an object',
        null,
      ], languageCode: 'en');

      expect(skills.length, 1);
      expect(skills.single.id, 1);
    });

    test('returns empty for a non-list payload instead of throwing', () {
      expect(SkillModel.listFrom(null), isEmpty);
      expect(SkillModel.listFrom('boom'), isEmpty);
      expect(SkillModel.listFrom({'status': 500}), isEmpty);
    });
  });
}
