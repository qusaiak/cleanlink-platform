import '../../domain/entities/worker_profile.dart';

/// Data-layer representation of [WorkerProfile] with JSON (de)serialization.
/// Availability maps to/from stable string codes shared with the backend.
class WorkerProfileModel extends WorkerProfile {
  const WorkerProfileModel({
    required super.id,
    required super.name,
    required super.role,
    required super.avatarUrl,
    required super.isVerified,
    required super.employeeId,
    required super.email,
    required super.rating,
    required super.completedTasks,
    required super.availability,
  });

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    return WorkerProfileModel(
      id: json['id'].toString(),
      name: (json['name'] ?? '').toString(),
      role: (json['role'] ?? '').toString(),
      avatarUrl: (json['avatarUrl'] ?? json['avatar_url'] ?? '').toString(),
      isVerified: json['isVerified'] ?? json['is_verified'] ?? false,
      employeeId: (json['employeeId'] ?? json['employee_id'] ?? '').toString(),
      email: (json['email'] ?? '').toString(),
      rating: (json['rating'] ?? 0).toDouble(),
      completedTasks: (json['completedTasks'] ?? json['completed_tasks'] ?? 0)
          as int,
      availability: availabilityFromCode(json['availability']?.toString()),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'role': role,
    'avatarUrl': avatarUrl,
    'isVerified': isVerified,
    'employeeId': employeeId,
    'email': email,
    'rating': rating,
    'completedTasks': completedTasks,
    'availability': availabilityCode(availability),
  };

  factory WorkerProfileModel.fromEntity(WorkerProfile p) => WorkerProfileModel(
    id: p.id,
    name: p.name,
    role: p.role,
    avatarUrl: p.avatarUrl,
    isVerified: p.isVerified,
    employeeId: p.employeeId,
    email: p.email,
    rating: p.rating,
    completedTasks: p.completedTasks,
    availability: p.availability,
  );

  static WorkerAvailability availabilityFromCode(String? code) {
    switch (code) {
      case 'busy':
        return WorkerAvailability.busy;
      case 'offline':
        return WorkerAvailability.offline;
      case 'available':
      default:
        return WorkerAvailability.available;
    }
  }

  static String availabilityCode(WorkerAvailability availability) {
    switch (availability) {
      case WorkerAvailability.available:
        return 'available';
      case WorkerAvailability.busy:
        return 'busy';
      case WorkerAvailability.offline:
        return 'offline';
    }
  }
}
