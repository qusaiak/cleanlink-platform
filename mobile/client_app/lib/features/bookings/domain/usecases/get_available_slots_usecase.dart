import '../entities/available_day_entity.dart';
import '../repositories/bookings_repo.dart';

class GetAvailableSlotsUseCase {
  final BookingsRepo repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<List<AvailableDayEntity>> call(int packageId) {
    return repository.getAvailableSlots(packageId);
  }
}
