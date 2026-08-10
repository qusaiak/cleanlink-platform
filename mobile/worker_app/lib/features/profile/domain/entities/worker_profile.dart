import 'package:equatable/equatable.dart';

/// The worker's status, shown/selected on the profile screen.
///
/// Only [available] and [off] are user-settable (via `PUT /api/worker-profiles`
/// `status`); [busy] is DERIVED on the client and never sent to or read from
/// the API — see [effectiveWorkerStatus].
/// - [available] ("متاح")   → green
/// - [busy]      ("مشغول")  → amber (derived: the worker has an active order)
/// - [off]       ("غير متاح") → grey
enum WorkerAvailability { available, busy, off }

/// The single source of truth for the status shown in the UI.
///
/// [busy] takes precedence: whenever the worker has at least one active order
/// (an order/task not yet completed), they display as [busy] regardless of
/// their chosen [base] value. When no active order remains, the chosen [base]
/// ([available]/[off]) shows again — so it must be preserved, never overwritten
/// by the derived [busy].
WorkerAvailability effectiveWorkerStatus(
  WorkerAvailability base,
  bool hasActiveOrder,
) => hasActiveOrder ? WorkerAvailability.busy : base;

/// A skill attached to the worker (`worker_profile.skills[]`). Both localized
/// names are kept so the chip re-resolves automatically when the app language
/// changes (the profile isn't re-fetched on a locale switch).
class WorkerSkill extends Equatable {
  final int id;
  final String nameAr;
  final String nameEn;

  const WorkerSkill({
    required this.id,
    required this.nameAr,
    required this.nameEn,
  });

  /// The display name for [languageCode] ('ar' → [nameAr], else [nameEn]),
  /// falling back to the other language when one is missing.
  String nameFor(String languageCode) {
    if (languageCode == 'ar') return nameAr.isNotEmpty ? nameAr : nameEn;
    return nameEn.isNotEmpty ? nameEn : nameAr;
  }

  @override
  List<Object?> get props => [id, nameAr, nameEn];
}

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
  final String address;
  final String phone;

  /// Years of experience from `worker_profile.experience_years` (0 when the
  /// worker has no worker_profile yet).
  final int experienceYears;

  /// Whether the worker is a team leader (`worker_profile.is_leader`).
  final bool isLeader;

  /// Skills from `worker_profile.skills` (empty when null/absent).
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
