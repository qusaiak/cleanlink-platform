import '../entities/available_day_entity.dart';
import '../entities/booking_entity.dart';
import '../../../../core/pagination/paginated_result.dart';

class OrderResult {
  final OrderEntity order;
  final String message;
  const OrderResult(this.order, this.message);
}

abstract class BookingsRepo {
  Future<List<AvailableDayEntity>> getAvailableSlots(int packageId);
  Future<PaginatedResult<OrderEntity>> getOrders({
    required int page,
    required int perPage,
  });
  Future<OrderResult> bookOrder({
    required int packageId,
    required String location,
    required DateTime startTime,
    String? note,
  });
  Future<OrderEntity> showOrder(int orderId);
  Future<OrderResult> cancelOrder(int orderId);
}
