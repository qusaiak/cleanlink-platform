import 'dart:async';

import 'package:client_app/features/bookings/data/models/book_order_request_model.dart';
import 'package:client_app/features/bookings/data/models/booking_model.dart';
import 'package:client_app/features/bookings/domain/entities/available_day_entity.dart';
import 'package:client_app/features/bookings/domain/entities/booking_entity.dart';
import 'package:client_app/features/bookings/domain/entities/open_package_entities.dart';
import 'package:client_app/features/bookings/domain/repositories/bookings_repo.dart';
import 'package:client_app/features/bookings/domain/usecases/book_order_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/cancel_order_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/get_available_slots_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/get_bookings_usecase.dart';
import 'package:client_app/features/bookings/domain/usecases/show_order_usecase.dart';
import 'package:client_app/features/bookings/presentation/bloc/bookings_bloc.dart';
import 'package:client_app/features/locations/domain/entities/selected_map_location.dart';
import 'package:client_app/features/payments/domain/entities/payment_entities.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('booking location payload', () {
    test('serializes the selected address and exact coordinates', () {
      const request = BookOrderRequestModel(
        packageId: 4,
        location: 'Al-Mazzeh, Damascus',
        latitude: 33.5031234,
        longitude: 36.2556789,
        startTime: '2026-08-10 08:00:00',
        note: 'Call before arrival',
      );

      expect(request.toJson(), {
        'package_id': 4,
        'location': 'Al-Mazzeh, Damascus',
        'latitude': 33.5031234,
        'longitude': 36.2556789,
        'start_time': '2026-08-10 08:00:00',
        'payment_method': 'cash',
        'note': 'Call before arrival',
      });
    });

    test('parses coordinate and travel values from strings or numbers', () {
      final stringCoordinates = BookingModel.fromJson({
        'id': 1,
        'location': 'Home',
        'latitude': '33.5031234',
        'longitude': '36.2556789',
        'duration': '90',
        'travel_buffer_minutes': '30',
        'total_price': '80.00',
        'status': 'in_process',
      }).toEntity();
      final numericCoordinates = BookingModel.fromJson({
        'id': 2,
        'location': 'Work',
        'latitude': 33.5,
        'longitude': 36,
        'duration': 60,
        'travel_buffer_minutes': 0,
        'total_price': 80,
      }).toEntity();

      expect(stringCoordinates.latitude, 33.5031234);
      expect(stringCoordinates.longitude, 36.2556789);
      expect(stringCoordinates.travelBufferMinutes, 30);
      expect(stringCoordinates.statusType, OrderStatus.inProcess);
      expect(numericCoordinates.latitude, 33.5);
      expect(numericCoordinates.longitude, 36);
      expect(numericCoordinates.travelBufferMinutes, 0);
    });
  });

  test('changing location clears stale slots and selected time', () async {
    final repository = _LocationBookingRepo();
    final bloc = BookingsBloc(
      GetAvailableSlotsUseCase(repository),
      GetOrdersUseCase(repository),
      BookOrderUseCase(repository),
      ShowOrderUseCase(repository),
      CancelOrderUseCase(repository),
    );
    addTearDown(bloc.close);

    const home = SelectedMapLocation(
      latitude: 33.5,
      longitude: 36.2,
      formattedAddress: 'Home',
      savedLocationId: 7,
      name: 'Home',
    );
    const work = SelectedMapLocation(
      latitude: 33.6,
      longitude: 36.3,
      formattedAddress: 'Work',
    );

    expect(home.isSaved, isTrue);
    expect(work.isSaved, isFalse);

    bloc.add(const SelectBookingLocation(packageId: 4, location: home));
    await bloc.stream.firstWhere(
      (state) => !state.isLoadingSlots && state.availableDays.isNotEmpty,
    );
    bloc.add(const SelectTime('08:00'));
    await bloc.stream.firstWhere((state) => state.selectedTime == '08:00');

    bloc.add(const SelectBookingLocation(packageId: 4, location: work));
    final cleared = await bloc.stream.firstWhere(
      (state) => state.selectedLocation == work && state.selectedTime == null,
    );
    final loaded = await bloc.stream.firstWhere(
      (state) =>
          state.selectedLocation == work &&
          !state.isLoadingSlots &&
          state.availableDays.isNotEmpty,
    );

    expect(cleared.availableDays, isEmpty);
    expect(loaded.selectedTime, isNull);
    expect(repository.slotRequests.last, (4, 33.6, 36.3));
  });

  test('a stale slot response cannot overwrite a newer location', () async {
    final repository = _RacingLocationBookingRepo();
    final bloc = BookingsBloc(
      GetAvailableSlotsUseCase(repository),
      GetOrdersUseCase(repository),
      BookOrderUseCase(repository),
      ShowOrderUseCase(repository),
      CancelOrderUseCase(repository),
    );
    addTearDown(bloc.close);

    const first = SelectedMapLocation(
      latitude: 33.5,
      longitude: 36.2,
      formattedAddress: 'First',
    );
    const second = SelectedMapLocation(
      latitude: 33.6,
      longitude: 36.3,
      formattedAddress: 'Second',
    );

    bloc.add(const SelectBookingLocation(packageId: 4, location: first));
    await repository.firstRequested.future;
    bloc.add(const SelectBookingLocation(packageId: 4, location: second));
    await repository.secondRequested.future;

    repository.second.complete([
      AvailableDayEntity(date: DateTime(2026, 8, 11), slots: const ['10:00']),
    ]);
    await bloc.stream.firstWhere(
      (state) =>
          state.selectedLocation == second &&
          state.availableDays.firstOrNull?.slots.firstOrNull == '10:00',
    );

    repository.first.complete([
      AvailableDayEntity(date: DateTime(2026, 8, 10), slots: const ['08:00']),
    ]);
    await Future<void>.delayed(Duration.zero);

    expect(bloc.state.selectedLocation, second);
    expect(bloc.state.availableDays.single.slots, ['10:00']);
  });
}

class _LocationBookingRepo implements BookingsRepo {
  final List<(int, double, double)> slotRequests = [];

  @override
  Future<List<AvailableDayEntity>> getAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
  }) async {
    slotRequests.add((packageId, latitude, longitude));
    return [
      AvailableDayEntity(
        date: DateTime(2026, 8, 10),
        slots: const ['08:00', '09:00'],
      ),
      AvailableDayEntity(date: DateTime(2026, 8, 11), slots: const []),
    ];
  }

  @override
  Future<OrderResult> bookOrder({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    required PaymentMethodType paymentMethod,
  }) => throw UnimplementedError();

  @override
  Future<OrderResult> bookOpenPackage({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    required List<SelectedOpenPackageAttribute> attributes,
    required PaymentMethodType paymentMethod,
  }) => throw UnimplementedError();

  @override
  Future<OpenPackageQuote> checkOpenPackagePrice({
    required int packageId,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => throw UnimplementedError();

  @override
  Future<List<AvailableDayEntity>> getOpenPackageAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => throw UnimplementedError();

  @override
  Future<OrderResult> cancelOrder(int orderId) => throw UnimplementedError();

  @override
  Future<List<OrderEntity>> getOrders() => throw UnimplementedError();

  @override
  Future<OrderEntity> showOrder(int orderId) => throw UnimplementedError();
}

class _RacingLocationBookingRepo extends _LocationBookingRepo {
  final first = Completer<List<AvailableDayEntity>>();
  final second = Completer<List<AvailableDayEntity>>();
  final firstRequested = Completer<void>();
  final secondRequested = Completer<void>();

  @override
  Future<List<AvailableDayEntity>> getAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
  }) {
    if (latitude == 33.5) {
      firstRequested.complete();
      return first.future;
    }
    secondRequested.complete();
    return second.future;
  }
}
