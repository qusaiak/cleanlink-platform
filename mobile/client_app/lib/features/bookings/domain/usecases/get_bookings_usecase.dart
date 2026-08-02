import '../entities/booking_entity.dart';
import '../repositories/bookings_repo.dart';
import '../../../../core/pagination/paginated_result.dart';

class GetOrdersUseCase {
  final BookingsRepo repository;
  const GetOrdersUseCase(this.repository);
  Future<PaginatedResult<OrderEntity>> call({
    required int page,
    required int perPage,
  }) => repository.getOrders(page: page, perPage: perPage);
}
