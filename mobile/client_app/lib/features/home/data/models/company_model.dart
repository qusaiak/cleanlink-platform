import '../../../../core/utils/gen/assets.gen.dart';

class CompanyModel {
  final String name;
  final String location;
  final double rating;
  final String image;

  const CompanyModel({
    required this.name,
    required this.location,
    required this.rating,
    required this.image,
  });
}
class CompaniesData {
  static final List<CompanyModel> all = [
    CompanyModel(
      name: "SparkleClean",
      location: "New York",
      rating: 4.9,
      image: Assets.images.test.test.path,
    ),
    CompanyModel(
      name: "ShinePro",
      location: "London",
      rating: 4.8,
      image: Assets.images.test.test.path,
    ),
    CompanyModel(
      name: "CleanMaster",
      location: "Berlin",
      rating: 4.7,
      image: Assets.images.test.test.path,
    ),
    CompanyModel(
      name: "ProWash",
      location: "Paris",
      rating: 4.6,
      image: Assets.images.test.test.path,
    ),
  ];
}