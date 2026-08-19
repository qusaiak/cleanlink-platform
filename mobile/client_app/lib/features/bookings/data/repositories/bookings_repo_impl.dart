import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/available_day_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repo.dart';
import '../data_sources/bookings_api_service.dart';
import '../models/book_order_request_model.dart';
import '../models/open_package_models.dart';
import '../../domain/entities/open_package_entities.dart';
import '../../../../core/utils/map_address_normalizer.dart';
import '../../../payments/domain/entities/payment_entities.dart';

class BookingsRepoImpl implements BookingsRepo {
  final BookingsApiService api;
  BookingsRepoImpl(this.api);

  @override
  Future<List<AvailableDayEntity>> getAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      return (await api.getAvailableSlots(
        packageId,
        latitude,
        longitude,
      )).data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<List<AvailableDayEntity>> getOpenPackageAvailableSlots({
    required int packageId,
    required double latitude,
    required double longitude,
    required List<SelectedOpenPackageAttribute> attributes,
  }) async {
    try {
      return (await api.getOpenPackageAvailableSlots(
        packageId,
        OpenPackageSlotsRequestModel(
          latitude: latitude,
          longitude: longitude,
          attributes: attributes,
        ),
      )).data.days;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<OpenPackageQuote> checkOpenPackagePrice({
    required int packageId,
    required List<SelectedOpenPackageAttribute> attributes,
  }) async {
    try {
      return (await api.checkOpenPackagePrice(
        packageId,
        OpenPackageAttributesRequestModel(attributes: attributes),
      )).data.data;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    try {
      const pageSize = 100;
      var page = 1;
      final orders = <OrderEntity>[];
      final ids = <int>{};
      while (true) {
        final result = (await api.getOrders(
          page: page,
          perPage: pageSize,
        )).data.data;
        for (final order in result.items) {
          if (ids.add(order.id)) orders.add(order);
        }
        if (!result.pagination.hasMorePages ||
            page >= result.pagination.lastPage) {
          break;
        }
        page++;
      }
      return orders;
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<OrderResult> bookOrder({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    required PaymentMethodType paymentMethod,
  }) async {
    return _book(
      packageId: packageId,
      location: location,
      latitude: latitude,
      longitude: longitude,
      startTime: startTime,
      note: note,
      isOpenPackage: false,
      attributes: const [],
      paymentMethod: paymentMethod,
    );
  }

  @override
  Future<OrderResult> bookOpenPackage({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    String? note,
    required List<SelectedOpenPackageAttribute> attributes,
    required PaymentMethodType paymentMethod,
  }) => _book(
    packageId: packageId,
    location: location,
    latitude: latitude,
    longitude: longitude,
    startTime: startTime,
    note: note,
    isOpenPackage: true,
    attributes: attributes,
    paymentMethod: paymentMethod,
  );

  Future<OrderResult> _book({
    required int packageId,
    required String location,
    required double latitude,
    required double longitude,
    required DateTime startTime,
    required String? note,
    required bool isOpenPackage,
    required List<SelectedOpenPackageAttribute> attributes,
    required PaymentMethodType paymentMethod,
  }) async {
    try {
      final body = BookOrderRequestModel(
        packageId: packageId,
        location: normalizeGoogleMapAddress(location),
        latitude: latitude,
        longitude: longitude,
        startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime),
        note: note?.trim().isEmpty == true ? null : note?.trim(),
        attributes: isOpenPackage ? attributes : null,
        paymentMethod: paymentMethod,
      );
      final response =
          (isOpenPackage
                  ? await api.bookOpenPackage(body)
                  : await api.bookOrder(body))
              .data;
      if (response.data == null) {
        throw const ServerFailure(
          'Booking response did not include an order',
          'EMPTY_DATA',
        );
      }
      return OrderResult(response.data!.toEntity(), response.message ?? '');
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<OrderEntity> showOrder(int orderId) async {
    try {
      final response = (await api.showOrder(orderId)).data;
      if (response.data == null) {
        throw const ServerFailure('Order details were not found', 'EMPTY_DATA');
      }
      return response.data!.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<OrderResult> cancelOrder(int orderId) async {
    try {
      final response = (await api.cancelOrder(orderId)).data;
      if (response.data == null) {
        throw const ServerFailure(
          'Cancel response did not include an order',
          'EMPTY_DATA',
        );
      }
      return OrderResult(response.data!.toEntity(), response.message ?? '');
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }
}
