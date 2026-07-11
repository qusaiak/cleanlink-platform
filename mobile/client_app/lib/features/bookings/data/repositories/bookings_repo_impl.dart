import 'package:dio/dio.dart';
import 'package:intl/intl.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/network/network_exceptions.dart';
import '../../domain/entities/available_day_entity.dart';
import '../../domain/entities/booking_entity.dart';
import '../../domain/repositories/bookings_repo.dart';
import '../data_sources/bookings_api_service.dart';
import '../models/book_order_request_model.dart';

class BookingsRepoImpl implements BookingsRepo {
  final BookingsApiService api;
  BookingsRepoImpl(this.api);

  @override
  Future<List<AvailableDayEntity>> getAvailableSlots(int packageId) async {
    try {
      return (await api.getAvailableSlots(packageId)).data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<List<OrderEntity>> getOrders() async {
    try {
      return (await api.getOrders()).data.toEntity();
    } on DioException catch (e) {
      throw NetworkExceptions.fromDio(e);
    }
  }

  @override
  Future<OrderResult> bookOrder({
    required int packageId,
    required String location,
    required DateTime startTime,
    String? note,
  }) async {
    try {
      final response = (await api.bookOrder(
        BookOrderRequestModel(
          packageId: packageId,
          location: location,
          startTime: DateFormat('yyyy-MM-dd HH:mm:ss').format(startTime),
          note: note?.trim().isEmpty == true ? null : note?.trim(),
        ),
      )).data;
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
