import '../entities/available_day_entity.dart';
import '../repositories/bookings_repo.dart';

class GetAvailableSlotsUseCase {
  final BookingsRepo repository;

  GetAvailableSlotsUseCase(this.repository);

  Future<List<AvailableDayEntity>> call({
    required int packageId,
    required double latitude,
    required double longitude,
  }) {
    return repository.getAvailableSlots(
      packageId: packageId,
      latitude: latitude,
      longitude: longitude,
    );
  }
}
