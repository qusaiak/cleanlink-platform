import 'package:equatable/equatable.dart';

class AttributeEntity extends Equatable {
  final int id;

  final String name;

  final String type;

  final DateTime createdAt;

  final DateTime updatedAt;

  final double price;
  final int duration;

  const AttributeEntity({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.price,
    required this.duration,
  });

  bool get isBoolean => type.trim().toLowerCase() == 'boolean';

  @override
  List<Object?> get props => [id, name, type, price, duration];
}
