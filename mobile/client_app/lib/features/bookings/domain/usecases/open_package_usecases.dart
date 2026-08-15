import '../entities/available_day_entity.dart';
import '../entities/open_package_entities.dart';
import '../repositories/bookings_repo.dart';

class CheckOpenPackagePriceUseCase {
  const CheckOpenPackagePriceUseCase(this.repository);
  final BookingsRepo repository;

  Future<OpenPackageQuote> call({
    required int packageId,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => repository.checkOpenPackagePrice(
    packageId: packageId,
    attributes: attributes,
  );
}

class GetOpenPackageAvailableSlotsUseCase {
  const GetOpenPackageAvailableSlotsUseCase(this.repository);
  final BookingsRepo repository;

  Future<List<AvailableDayEntity>> call({
    required int packageId,
    required double latitude,
    required double longitude,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => repository.getOpenPackageAvailableSlots(
    packageId: packageId,
    latitude: latitude,
    longitude: longitude,
    attributes: attributes,
  );
}
