import '../../domain/entities/booking_entity.dart';

import '../../domain/repositories/bookings_repo.dart';

import '../data_sources/bookings_api_service.dart';

import '../models/booking_model.dart';

class BookingsRepoImpl implements BookingsRepo {
  final BookingsApiService api;

  const BookingsRepoImpl(this.api);

  @override
  Future<List<BookingEntity>> getBookings() async {
    final result = await api.getBookings();

    return result.map((e) => BookingModel.fromJson(e)).toList();
  }
}
