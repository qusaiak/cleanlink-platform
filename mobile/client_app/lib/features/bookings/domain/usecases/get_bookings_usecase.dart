import '../entities/booking_entity.dart';

import '../repositories/bookings_repo.dart';

class GetBookingsUseCase {
  final BookingsRepo repo;

  const GetBookingsUseCase(
      this.repo,
      );

  Future<List<BookingEntity>>
  call() {
    return repo.getBookings();
  }
}