import '../entities/available_day_entity.dart';
import '../entities/booking_entity.dart';
import '../entities/open_package_entities.dart';

class OrderResult {
  final OrderEntity order;
  final String message;
  const OrderResult(this.order, this.message);
}

abstract class BookingsRepo {
  Future<List<AvailableDayEntity>> getAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
  });
  Future<List<AvailableDayEntity>> getOpenPackageAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => throw UnsupportedError('Open Package slots are not implemented');
  Future<OpenPackageQuote> checkOpenPackagePrice({
    required int packageId,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => throw UnsupportedError('Open Package pricing is not implemented');
  Future<List<OrderEntity>> getOrders();
  Future<OrderResult> bookOrder({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
  });
  Future<OrderResult> bookOpenPackage({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    required List<SelectedOpenPackageAttribute> attributes,
  }) => throw UnsupportedError('Open Package booking is not implemented');
  Future<OrderEntity> showOrder(int orderId);
  Future<OrderResult> cancelOrder(int orderId);
}
