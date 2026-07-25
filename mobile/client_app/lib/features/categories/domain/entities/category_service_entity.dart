import 'package:equatable/equatable.dart';

/// A service belonging to a category (as returned by `GET /categories/{id}`).
///
/// Kept separate from the richer `services` feature `ServiceEntity` because the
/// category endpoint returns a simpler, single-language payload.
class CategoryServiceEntity extends Equatable {
  final int id;
  final int companyId;
  final int categoryId;
  final String name;
  final String description;
  final String rating;
  final int minDuration;
  final int maxDuration;
  final String price;
  final String image;
  final String discount;

  const CategoryServiceEntity({
    required this.id,
    required this.companyId,
    required this.categoryId,
    required this.name,
    required this.description,
    required this.rating,
    required this.minDuration,
    required this.maxDuration,
    required this.price,
    required this.image,
    required this.discount,
  });

  bool get hasDiscount {
    final value = double.tryParse(discount) ?? 0;
    return value > 0;
  }

  @override
  List<Object?> get props => [
    id,
    companyId,
    categoryId,
    name,
    description,
    rating,
    minDuration,
    maxDuration,
    price,
    image,
    discount,
  ];
}
