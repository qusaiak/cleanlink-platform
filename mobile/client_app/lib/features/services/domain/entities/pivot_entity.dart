class PivotEntity {
  final int serviceId;

  final int attributeId;

  final String price;

  final int duration;

  final DateTime createdAt;

  final DateTime updatedAt;

  const PivotEntity({
    required this.serviceId,
    required this.attributeId,
    required this.price,
    required this.duration,
    required this.createdAt,
    required this.updatedAt,
  });
}
