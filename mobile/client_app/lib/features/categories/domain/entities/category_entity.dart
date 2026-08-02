import 'package:client_app/features/services/domain/entities/service_entity.dart';
import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final int id;
  final String name;
  final String description;
  final String image;
  final List<ServiceEntity> services;

  const CategoryEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    this.services = const [],
  });

  int get serviceCount => services.length;

  @override
  List<Object?> get props => [id, name, description, image, services];
}
