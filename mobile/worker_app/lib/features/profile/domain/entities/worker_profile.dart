import 'package:equatable/equatable.dart';

enum WorkerAvailability { available, busy, off }

WorkerAvailability effectiveWorkerStatus(
  WorkerAvailability base,
  bool hasActiveOrder,
) => hasActiveOrder ? WorkerAvailability.busy : base;

class WorkerSkill extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;

  const WorkerSkill({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  String nameFor(String languageCode) {
    if (languageCode == 'ar') return nameAr.isNotEmpty ? nameAr : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}

class WorkerProfile extends Equatable {
  final String id;
  final String name;

  final String role;
  final String avatarUrl;

  final bool isVerified;
  final String employeeId;
  final String email;
  final double rating;
  final int completedTasks;
  final WorkerAvailability availability;
  final String address;
  final String phone;

  final int experienceYears;

  final bool isLeader;

  final List<WorkerSkill> skills;

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
    required this.address,
    required this.phone,
    this.experienceYears = 0,
    this.isLeader = false,
    this.skills = const [],
  });

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
    String? address,
    String? phone,
    int? experienceYears,
    bool? isLeader,
    List<WorkerSkill>? skills,
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
      address: address ?? this.address,
      phone: phone ?? this.phone,
      experienceYears: experienceYears ?? this.experienceYears,
      isLeader: isLeader ?? this.isLeader,
      skills: skills ?? this.skills,
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
    address,
    phone,
    experienceYears,
    isLeader,
    skills,
  ];
}
