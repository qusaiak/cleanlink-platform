import 'pivot_entity.dart';

class AttributeEntity {
  final int id;

  final String name;

  final String type;

  final DateTime createdAt;

  final DateTime updatedAt;

  final PivotEntity pivot;

  const AttributeEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.pivot,
  });
}
