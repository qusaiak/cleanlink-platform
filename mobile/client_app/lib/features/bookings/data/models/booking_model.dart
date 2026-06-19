import '../../domain/entities/booking_entity.dart';

import 'worker_model.dart';

class BookingModel extends BookingEntity {
  const BookingModel({
    required super.id,
    required super.serviceName,
    required super.companyName,
    required super.worker,
    required super.date,
    required super.time,
    required super.status,
    required super.price,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json["id"],

      serviceName: json["service_name"],

      companyName: json["company_name"],

      worker: json["worker"] == null
          ? null
          : WorkerModel.fromJson(json["worker"]),

      date: DateTime.parse(json["date"]),

      time: json["time"],

      status: json["status"],

      price: (json["price"] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "service_name": serviceName,

      "company_name": companyName,

      "worker": worker == null
          ? null
          : {"id": worker!.id, "name": worker!.name, "image": worker!.image},

      "date": date.toIso8601String(),

      "time": time,

      "status": status,

      "price": price,
    };
  }
}
