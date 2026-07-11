import '../repositories/bookings_repo.dart';

class BookOrderUseCase {
  final BookingsRepo repository;
  const BookOrderUseCase(this.repository);
  Future<OrderResult> call(
          {required int packageId,
          required String location,
          required DateTime startTime,
          String? note}) =>
      repository.bookOrder(
          packageId: packageId,
          location: location,
          startTime: startTime,
          note: note);
}
