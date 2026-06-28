import 'pivot_entity.dart';

class AttributeEntity {
  final int id;

  final String nameAr;

  final String nameEn;

  final String type;

  final DateTime createdAt;

  final DateTime updatedAt;

  final PivotEntity pivot;

  const AttributeEntity({
    required this.id,
    required this.nameAr,
    required this.nameEn,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });
}