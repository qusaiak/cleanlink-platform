import 'package:client_app/features/bookings/data/models/book_order_request_model.dart';
import 'package:client_app/features/bookings/data/models/booking_model.dart';
import 'package:client_app/features/bookings/domain/entities/booking_entity.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('booking models', () {
    test('parses total_price from a numeric string', () {
      final model = BookingModel.fromJson({
        'id': 10,
        'client_id': 109,
        'package_id': 13,
        'status': 'canceled',
        'location': 'Damascus',
        'duration': 30,
        'total_price': '80.00',
      });

      expect(model.toEntity().totalPrice, 80.0);
      expect(model.toEntity().status, 'canceled');
    });

    test('serializes the booking API field names', () {
      const request = BookOrderRequestModel(
        packageId: 13,
        location: 'Damascus',
        latitude: 33.5138,
        longitude: 36.2765,
        startTime: '2026-07-06 14:00:00',
        note: 'Pet hair',
      );

      expect(request.toJson(), {
        'package_id': 13,
        'location': 'Damascus',
        'latitude': 33.5138,
        'longitude': 36.2765,
        'start_time': '2026-07-06 14:00:00',
        'note': 'Pet hair',
      });
    });

    test('maps backend statuses and nullable leader data safely', () {
      final model = BookingModel.fromJson({
        'id': 7,
        'client_id': 109,
        'package_id': 10,
        'status': 'assigned_to_worker',
        'location': 'Damascus',
        'duration': 30,
        'total_price': 80,
        'leader': {
          'id': 9,
          'fullname': 'Ahmed Ali',
          'email': 'ahmed.ali@example.com',
          'role': 'worker',
          'profile': {
            'id': 9,
            'user_id': 9,
            'image': null,
            'phone': '+201057656460',
          },
        },
      });

      final entity = model.toEntity();

      expect(entity.statusType, OrderStatus.assigned);
      expect(entity.leader?.fullname, 'Ahmed Ali');
      expect(entity.leader?.phone, '+201057656460');
    });
  });
}
