import 'package:flutter_test/flutter_test.dart';
import 'package:worker_app/features/tasks/data/models/task_model.dart';
import 'package:worker_app/features/tasks/domain/entities/task.dart';

void main() {
  group('TaskModel.fromJson — real GET /api/tasks list item', () {
    // Verbatim item #2 from the real `GET /api/tasks` response.
    final json = {
      "id": 2,
      "order_id": 2,
      "workgroup_id": 1,
      "status": "on_way",
      "image_before": null,
      "image_after": null,
      "order": {
        "id": 2,
        "client_id": 6,
        "package_id": 1,
        "note": "Generated automatically by system mock testing sequence.",
        "location": "Damascus, Mezzeh Street, Al-Jalaa Building 2",
        "start_time": "2026-07-05T08:00:00.000000Z",
        "end_time": "2026-07-05T08:30:00.000000Z",
        "duration": 30,
        "status": "assigned_to_worker",
        "total_price": "110.00",
        "package": {
          "id": 1,
          "service_id": 1,
          "name_ar": "باقة الاستوديو",
          "name_en": "Studio Package",
          "duration": 30,
          "price": "80.00",
          "price_after_discount": "80.00",
          "details_ar": ["مثالية للمساحات التي تقل عن 60 متر مربع"],
          "details_en": ["Ideal for spaces under 60m²"],
          "service": {
            "id": 1,
            "company_id": 1,
            "category_id": 1,
            "name_ar": "تنظيف الشقق السكنية القياسي",
            "name_en": "Standard Apartment Cleaning",
            "rating": "4.20",
            "min_duration": 120,
            "max_duration": 180,
            "price": "50.00",
            "image":
                "http://localhost:8000/storage/services/standard_apartment.jpg",
            "discount": "0.00",
            "is_favorite": false,
          },
        },
      },
      "workgroup": {
        "id": 1,
        "company_id": 1,
        "name": "Crew Team 1 (EcoClean Pro Solutions)",
        "leader_id": 9,
        "leader": {
          "id": 9,
          "fullname": "Ahmed Ali",
          "email": "ahmed.ali@example.com",
          "role": "worker",
        },
        "workers": [
          {
            "id": 9,
            "fullname": "Ahmed Ali",
            "email": "ahmed.ali@example.com",
            "role": "worker",
          },
          {
            "id": 10,
            "fullname": "Omar Hassan",
            "email": "omar.hassan@example.com",
            "role": "worker",
          },
        ],
      },
    };

    test('maps every field to the Task entity correctly', () {
      final task = TaskModel.fromJson(json);

      expect(task.id, '2');
      expect(task.requestNumber, '2'); // derived from order_id
      expect(task.title, 'Standard Apartment Cleaning');
      expect(task.customerName, ''); // no client relation/name in payload
      expect(task.location, 'Damascus, Mezzeh Street, Al-Jalaa Building 2');
      expect(task.companyName, 'Crew Team 1 (EcoClean Pro Solutions)');
      expect(task.packageName, 'Studio Package');
      expect(task.price, 110.0); // order.total_price (string) -> double
      expect(task.durationLabel, '30');
      expect(task.includedItems, ['Ideal for spaces under 60m²']);
      expect(
        Uri.parse(task.imageUrl).path,
        '/storage/services/standard_apartment.jpg',
      );
      expect(task.scheduledAt, DateTime.parse('2026-07-05T08:00:00.000000Z'));
      expect(task.status, TaskStatus.onTheWay); // "on_way" code
      expect(task.teamMembers.map((member) => member.name), [
        'Ahmed Ali',
        'Omar Hassan',
      ]);
      expect(
        task.details,
        'Generated automatically by system mock testing sequence.',
      );
    });
  });

  group('TaskModel.fromJson — real GET /api/tasks/{id} detail response', () {
    // Verbatim `data` object from the real `GET /api/tasks/2` response. Note
    // The corrected backend uses the same task ID and workgroup shape for the
    // list and detail endpoints.
    final json = {
      "id": 2,
      "order_id": 2,
      "workgroup_id": 1,
      "status": "on_way",
      "image_before": null,
      "image_after": null,
      "order": {
        "id": 2,
        "client_id": 6,
        "package_id": 1,
        "status": "assigned_to_worker",
        "location": "Damascus, Mezzeh Street, Al-Jalaa Building 2",
        "start_time": "2026-07-05T08:00:00.000000Z",
        "end_time": "2026-07-05T08:30:00.000000Z",
        "duration": 30,
        "total_price": "110.00",
        "note": "Generated automatically by system mock testing sequence.",
        "package": {
          "id": 1,
          "service_id": 1,
          "name": "Studio Package",
          "duration": 30,
          "price": 80,
          "price_after_discount": 80,
          "details": [
            "Ideal for spaces under 60m²",
            "Includes 2 rooms and 1 bathroom",
          ],
          "service": {
            "id": 1,
            "company_id": 1,
            "category_id": 1,
            "name": "Standard Apartment Cleaning",
            "description":
                "Vacuuming, mopping, and dusting of living spaces including standard kitchen and bathroom wash.",
            "rating": 4.2,
            "min_duration": 120,
            "max_duration": 180,
            "price": 50,
            "image":
                "http://localhost:8000/storage/services/standard_apartment.jpg",
            "discount": 0,
            "is_favorite": false,
          },
        },
      },
      "workgroup": {
        "id": 1,
        "company_id": 1,
        "name": "Crew Team 1 (EcoClean Pro Solutions)",
        "leader_id": 9,
        "leader": {
          "id": 9,
          "fullname": "Ahmed Ali",
          "email": "ahmed.ali@example.com",
          "role": "worker",
        },
        "workers": [
          {
            "id": 9,
            "fullname": "Ahmed Ali",
            "email": "ahmed.ali@example.com",
            "role": "worker",
          },
          {
            "id": 10,
            "fullname": "Omar Hassan",
            "email": "omar.hassan@example.com",
            "role": "worker",
          },
        ],
      },
    };

    test('maps every field and accepts an explicit route id override', () {
      final task = TaskModel.fromJson(json, idOverride: '2');

      expect(task.id, '2'); // came from idOverride, not the JSON body
      expect(task.requestNumber, '2');
      expect(task.title, 'Standard Apartment Cleaning');
      expect(task.packageName, 'Studio Package');
      expect(task.price, 110.0); // numeric order.total_price -> double
      expect(task.includedItems, [
        'Ideal for spaces under 60m²',
        'Includes 2 rooms and 1 bathroom',
      ]);
      expect(task.status, TaskStatus.onTheWay);
      expect(task.companyName, 'Crew Team 1 (EcoClean Pro Solutions)');
      expect(task.teamMembers, hasLength(2));
    });

    test(
      'uses the task id returned by the backend when no override is given',
      () {
        final task = TaskModel.fromJson(json);
        expect(task.id, '2');
      },
    );
  });

  test('maps Open Package attributes and nullable work images', () {
    final task = TaskModel.fromJson({
      'id': 7,
      'status': 'handling',
      'image_before': 'http://localhost/storage/task_images/before.jpg',
      'image_after': null,
      'order': {
        'id': 18,
        'start_time': '2026-08-26T08:00:00Z',
        'payment_method': 'card',
        'payment_status': 'held',
        'package': {
          'name': 'Flexible cleaning',
          'is_open_package': true,
          'attributes': null,
        },
        'attributes': [
          {'id': 3, 'name': 'Long attribute name', 'type': 'number', 'qty': 4},
          {'id': 4, 'name': 'Optional extra', 'type': 'boolean', 'qty': 0},
        ],
      },
    });

    expect(task.isOpenPackage, isTrue);
    expect(task.packageAttributes, hasLength(2));
    expect(task.packageAttributes.first.name, 'Long attribute name');
    expect(task.packageAttributes.first.quantity, 4);
    expect(task.packageAttributes.last.isBoolean, isTrue);
    expect(task.packageAttributes.last.quantity, 0);
    expect(task.beforePhotos, hasLength(1));
    expect(task.afterPhotos, isEmpty);
    expect(task.paymentMethod, 'card');
    expect(task.paymentStatus, 'held');
    expect(task.status, TaskStatus.inProgress);
  });
}
