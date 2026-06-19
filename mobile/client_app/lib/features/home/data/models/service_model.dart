import '../../../../core/utils/gen/assets.gen.dart';

class ServiceModel {
  final String title;
  final String price;
  final String duration;
  final String company;
  final String image;

  const ServiceModel({
    required this.title,
    required this.price,
    required this.duration,
    required this.company,
    required this.image,
  });
}

class ServicesData {
  static final List<ServiceModel> all = [
    ServiceModel(
      title: "House Cleaning",
      price: "\$25",
      duration: "2h",
      company: "SparkleClean",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Deep Cleaning",
      price: "\$60",
      duration: "3h",
      company: "ShinePro",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Office Cleaning",
      price: "\$40",
      duration: "2.5h",
      company: "CleanMaster",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Carpet Cleaning",
      price: "\$35",
      duration: "1.5h",
      company: "ProWash",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "House Cleaning",
      price: "\$25",
      duration: "2h",
      company: "SparkleClean",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Deep Cleaning",
      price: "\$60",
      duration: "3h",
      company: "ShinePro",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Office Cleaning",
      price: "\$40",
      duration: "2.5h",
      company: "CleanMaster",
      image: Assets.images.test.test.path,
    ),
    ServiceModel(
      title: "Carpet Cleaning",
      price: "\$35",
      duration: "1.5h",
      company: "ProWash",
      image: Assets.images.test.test.path,
    ),
  ];
}