import '../entities/booking_entity.dart';
import '../repositories/bookings_repo.dart';

class ShowOrderUseCase {
  final BookingsRepo repository;
  const ShowOrderUseCase(this.repository);
  Future<OrderEntity> call(int orderId) => repository.showOrder(orderId);
}
