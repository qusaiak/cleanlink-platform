import 'package:equatable/equatable.dart';

class PackageEntity extends Equatable {
  final int id;

  final int serviceId;

  final String name;

  final int duration;

  final double price;

  final double priceAfterDiscount;

  final int minimumWorkers;

  final bool isOpenPackage;

  final List<String> details;

  final DateTime createdAt;

  final DateTime updatedAt;

  const PackageEntity({
    required this.id,
    required this.serviceId,
    required this.name,
    required this.duration,
    required this.price,
    required this.priceAfterDiscount,
    required this.minimumWorkers,
    required this.isOpenPackage,
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
    id,
    serviceId,
    name,
    duration,
    price,
    priceAfterDiscount,
    details,
    minimumWorkers,
    isOpenPackage,
  ];
}
