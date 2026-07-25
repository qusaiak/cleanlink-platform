class PackageEntity {
  final int id;

  final int serviceId;

  final String name;

  final int duration;

  final int price;

  final int priceAfterDiscount;

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
    required this.details,
    required this.createdAt,
    required this.updatedAt,
  });
}
