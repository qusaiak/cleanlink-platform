import 'worker_entity.dart';

class BookingEntity {
  final int id;

  final String serviceName;

  final String companyName;

  final WorkerEntity? worker;

  final DateTime date;

  final String time;

  final String status;

  final double price;

  const BookingEntity({
    required this.id,
    required this.serviceName,
    required this.companyName,
    required this.worker,
    required this.date,
    required this.time,
    required this.status,
    required this.price,
  });
}
