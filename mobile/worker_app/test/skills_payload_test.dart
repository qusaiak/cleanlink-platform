import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:worker_app/config/constants/skills_payload.dart';
import 'package:worker_app/features/profile/data/models/worker_profile_model.dart';

void main() {
  group('SkillsPayload', () {
    test('array shape encodes to a real JSON array of NUMBERS', () {
      final body = SkillsPayload.preferred.body([4]);

      // The exact bytes that go on the wire — not ["4"], not "[4]".
      expect(jsonEncode(body), '{"skill_ids":[4]}');
      expect(body['skill_ids'], isA<List<int>>());
    });

    test('scalar shape encodes to a bare number', () {
      const scalar = SkillsPayload(field: 'skill_id', asArray: false);
      expect(jsonEncode(scalar.body([4])), '{"skill_id":4}');
    });

    test('candidates cover the four realistic Laravel spellings', () {
      final labels = SkillsPayload.candidates.map((c) => c.label).toList();
      expect(labels, [
        '{"skill_ids": [<int>]}',
        '{"skills": [<int>]}',
        '{"skill_id": <int>}',
        '{"skills": <int>}',
      ]);
      // The preferred shape must be attempted first.
      expect(SkillsPayload.candidates.first, same(SkillsPayload.preferred));
    });
  });

  group('WorkerProfileModel.fromMeJson defensiveness', () {
    /// The attach/detach response, abridged to the fields that are parsed.
    Map<String, dynamic> response({
      dynamic rating = 4.2,
      dynamic experience = 35,
    }) => {
      'status': 200,
      'message': 'Skills assigned to the worker profile successfully',
      'data': {
        'id': 9,
        'fullname': 'Ahmed',
        'email': 'a@example.com',
        'role': 'worker',
        'worker_profile': {
          'id': 1,
          'rating': rating,
          'experience_years': experience,
          'status': 'available',
          'is_leader': true,
          'skills': [
            {
              'id': 4,
              'name_ar': 'تنظيف خزانات المياه',
              'name_en': 'Water Tank Cleaning',
              'pivot': {'worker_profile_id': 1, 'skill_id': 4},
            },
          ],
        },
        'profile': {
          'id': 9,
          'image': 'http://localhost:8000/storage/worker_profiles/x.jpg',
          'address': 'Amman',
          'phone': '0790000000',
        },
      },
    };

    test('parses the attach/detach payload and its skills', () {
      final model = WorkerProfileModel.fromMeJson(response());

      expect(model.skills.single.id, 4);
      expect(model.skills.single.nameFor('ar'), 'تنظيف خزانات المياه');
      expect(model.skills.single.nameFor('en'), 'Water Tank Cleaning');
      expect(model.rating, 4.2);
      expect(model.experienceYears, 35);
      // URL host normalization happens after the local .env is loaded by main.
      expect(model.avatarUrl, contains('/storage/worker_profiles/x.jpg'));
    });

    test('survives rating/experience arriving as STRINGS (Laravel decimal '
        'casts) instead of throwing', () {
      // This is the shape that used to blow up with a TypeError, turning an
      // already-applied change into a reported failure.
      final model = WorkerProfileModel.fromMeJson(
        response(rating: '4.20', experience: '35'),
      );

      expect(model.rating, 4.2);
      expect(model.experienceYears, 35);
      expect(model.skills, hasLength(1));
    });

    test('survives nulls and missing sections', () {
      final model = WorkerProfileModel.fromMeJson(
        response(rating: null, experience: null),
      );
      expect(model.rating, 0);
      expect(model.experienceYears, 0);

      final bare = WorkerProfileModel.fromMeJson({
        'data': {'id': 9},
      });
      expect(bare.skills, isEmpty);
      expect(bare.rating, 0);
      expect(bare.avatarUrl, '');
    });
  });
}
