import 'package:client_app/features/reviews/data/models/my_reviews_response_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('safely maps localized reviewables and mixed numeric values', () {
    final response = MyReviewsResponseModel.fromJson({
      'status': 200,
      'message': 'ok',
      'data': {
        'companies': [
          {
            'id': 63,
            'client_id': 109,
            'rating': '2',
            'reviewable_id': 1,
            'reviewable_type': r'App\Models\Company',
            'created_at': 'invalid',
            'reviewable': {
              'id': '1',
              'name_en': 'EcoClean',
              'name_ar': 'إيكو كلين',
              'rating': '3.00',
              'location_en': 'Damascus',
              'location_ar': 'دمشق',
            },
          },
        ],
        'services': [
          {
            'id': 61,
            'client_id': 109,
            'comment': null,
            'rating': 5.0,
            'reviewable_id': 2,
            'reviewable_type': r'App\Models\Service',
            'reviewable': {
              'id': 2,
              'name_en': 'Deep Care',
              'name_ar': 'تنظيف عميق',
              'rating': '3.6',
              'price': '120.9',
            },
          },
        ],
      },
    });

    final english = response.data!.toEntity(languageCode: 'en');
    final arabic = response.data!.toEntity(languageCode: 'ar');

    expect(english.companies.single.company!.name, 'EcoClean');
    expect(arabic.companies.single.company!.name, 'إيكو كلين');
    expect(english.companies.single.rating, 2);
    expect(english.companies.single.createdAt, isNull);
    expect(english.services.single.comment, isNull);
    expect(english.services.single.service!.rating, 3.6);
    expect(english.services.single.service!.price, 120);
  });

  test('keeps multiple reviews for the same reviewable id', () {
    final response = MyReviewsResponseModel.fromJson({
      'status': 200,
      'message': 'ok',
      'data': {
        'companies': const [],
        'services': [
          {'id': 1, 'reviewable_id': 9, 'rating': 2},
          {'id': 2, 'reviewable_id': 9, 'rating': 5},
        ],
      },
    });

    expect(response.data!.services.map((review) => review.id), [1, 2]);
  });
}
