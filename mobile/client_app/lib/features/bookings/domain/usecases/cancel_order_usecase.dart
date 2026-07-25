import '../repositories/bookings_repo.dart';

class CancelOrderUseCase {
  final BookingsRepo repository;
  const CancelOrderUseCase(this.repository);
  Future<OrderResult> call(int orderId) => repository.cancelOrder(orderId);
}
