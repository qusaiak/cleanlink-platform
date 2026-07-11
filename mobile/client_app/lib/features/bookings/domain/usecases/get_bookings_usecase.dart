import '../entities/booking_entity.dart';
import '../repositories/bookings_repo.dart';

class GetOrdersUseCase {
  final BookingsRepo repository;
  const GetOrdersUseCase(this.repository);
  Future<List<OrderEntity>> call() => repository.getOrders();
}
