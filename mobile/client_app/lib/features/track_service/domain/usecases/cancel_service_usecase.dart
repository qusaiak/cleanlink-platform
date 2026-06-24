import '../repositories/track_service_repo.dart';

class CancelServiceUseCase {
  final TrackServiceRepo repo;

  const CancelServiceUseCase(this.repo);

  Future<void> call(int bookingId) {
    return repo.cancelService(bookingId);
  }
}
