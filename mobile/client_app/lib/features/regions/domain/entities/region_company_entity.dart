import 'package:equatable/equatable.dart';

/// A company belonging to a region (as returned by `GET /regions/{id}`).
class RegionCompanyEntity extends Equatable {
  final int id;
  final int managerId;
  final int regionId;
  final String name;
  final String description;
  final String image;
  final String location;
  final double rating;
  final bool isOpen;
  final String startHour;
  final String closeHour;

  const RegionCompanyEntity({
    required this.id,
    required this.managerId,
    required this.regionId,
    required this.name,
    required this.description,
    required this.image,
    required this.location,
    required this.rating,
    required this.isOpen,
    required this.startHour,
    required this.closeHour,
  });

  String get workingHours => "$startHour - $closeHour";

  @override
  List<Object?> get props => [
        id,
        managerId,
        regionId,
        name,
        description,
        image,
        location,
        rating,
        isOpen,
        startHour,
        closeHour,
      ];
}
