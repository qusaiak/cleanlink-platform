import 'package:equatable/equatable.dart';

/// The worker's current availability, shown/selected on the profile screen.
/// - [available] ("متاح")     → green
/// - [busy]      ("مشغول")    → amber
/// - [offline]   ("غير متصل") → grey
enum WorkerAvailability { available, busy, offline }

/// Profile of the signed-in worker, backing the worker profile screen
/// (avatar, name/role, availability, rating, completed count, job id, email).
///
/// Pure domain entity (only [Equatable]); no Flutter/data dependencies.
class WorkerProfile extends Equatable {
  final String id;
  final String name;

  /// Job role/specialty, e.g. "في صيانة" / "In Maintenance" (server-provided).
  final String role;
  final String avatarUrl;

  /// Whether the worker's account/identity is verified (green check badge).
  final bool isVerified;
  final String employeeId;
  final String email;
  final double rating;
  final int completedTasks;
  final WorkerAvailability availability;

  const WorkerProfile({
    required this.id,
    required this.name,
    required this.role,
    required this.avatarUrl,
    required this.isVerified,
    required this.employeeId,
    required this.email,
    required this.rating,
    required this.completedTasks,
    required this.availability,
  });

  /// Returns a copy with selected fields overridden. Used after a backend
  /// confirms a status change or a profile edit (email / employee id).
  WorkerProfile copyWith({
    String? name,
    String? role,
    String? avatarUrl,
    bool? isVerified,
    String? employeeId,
    String? email,
    double? rating,
    int? completedTasks,
    WorkerAvailability? availability,
  }) {
    return WorkerProfile(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isVerified: isVerified ?? this.isVerified,
      employeeId: employeeId ?? this.employeeId,
      email: email ?? this.email,
      rating: rating ?? this.rating,
      completedTasks: completedTasks ?? this.completedTasks,
      availability: availability ?? this.availability,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    role,
    avatarUrl,
    isVerified,
    employeeId,
    email,
    rating,
    completedTasks,
    availability,
  ];
}
