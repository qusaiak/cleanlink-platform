class PackageEntity {
  final int id;

  final int serviceId;

  final String nameAr;

  final String nameEn;

  final int duration;

  final String price;

  final String priceAfterDiscount;

  final List<String> detailsAr;

  final List<String> detailsEn;

  final DateTime createdAt;

  final DateTime updatedAt;

  const PackageEntity({
    required this.id,
    required this.serviceId,
    required this.nameAr,
    required this.nameEn,
    required this.duration,
    required this.price,
    required this.priceAfterDiscount,
    required this.detailsAr,
    required this.detailsEn,
    required this.createdAt,
    required this.updatedAt,
  });
}
