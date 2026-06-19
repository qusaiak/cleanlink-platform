import '../entities/booking_entity.dart';

abstract class BookingsRepo {
  Future<List<BookingEntity>>
  getBookings();
}