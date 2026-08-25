import '../repositories/bookings_repo.dart';
import '../entities/open_package_entities.dart';
import '../../../payments/domain/entities/payment_entities.dart';

class BookOrderUseCase {
  final BookingsRepo repository;
  const BookOrderUseCase(this.repository);
  Future<OrderResult> call({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    bool isOpenPackage = false,
    List<SelectedOpenPackageAttribute> attributes = const [],
    PaymentMethodType paymentMethod = PaymentMethodType.cash,
  }) => isOpenPackage
      ? repository.bookOpenPackage(
          packageId: packageId,
          location: location,
          latitude: latitude,
          longitude: longitude,
          startTime: startTime,
          note: note,
          attributes: attributes,
          paymentMethod: paymentMethod,
        )
      : repository.bookOrder(
          packageId: packageId,
          location: location,
          latitude: latitude,
          longitude: longitude,
          startTime: startTime,
          note: note,
          paymentMethod: paymentMethod,
        );
}
