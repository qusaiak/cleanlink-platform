import 'package:dio/dio.dart';

class BookingsApiService {
  final Dio dio;

  const BookingsApiService(this.dio);

  Future<List<dynamic>> getBookings() async {
    final response = await dio.get("/bookings");

    return response.data;
  }
}
