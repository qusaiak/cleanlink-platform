class ServiceGalleryImageEntity {
  final int id;
  final int serviceId;
  final String imageBefore;
  final String imageAfter;

  const ServiceGalleryImageEntity({
    required this.id,
    required this.serviceId,
    required this.imageBefore,
    required this.imageAfter,
  });
}
