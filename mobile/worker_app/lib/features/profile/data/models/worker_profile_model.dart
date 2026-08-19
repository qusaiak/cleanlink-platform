import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/worker_profile.dart';
import 'skill_model.dart';

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
    required super.address,
    required super.phone,
    super.experienceYears,
    super.isLeader,
    super.skills,
  });

  /// Parses the `GET /api/worker-profiles/me` response:
  /// `{status, message, data: {id, fullname, email, role, profile: {image,
  /// address, phone}, worker_profile: {experience_years, rating, status,
  /// is_leader, skills: [{id, name_ar, name_en}]}}}`.
  ///
  /// `profile`, `worker_profile` and `skills` may be null for some users, and
  /// `profile.image` may be null — every field is parsed null-safely with a
  /// sensible default. `worker_profile.status` maps onto the availability
  /// shown on the profile screen. Each skill keeps both `name_ar` and
  /// `name_en` (the `pivot` object is ignored) so the UI can re-localize when
  /// the app language changes.
  factory WorkerProfileModel.fromMeJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? Map<String, dynamic>.from(json['data'] as Map)
        : json;
    final profile = data['profile'] is Map
        ? Map<String, dynamic>.from(data['profile'] as Map)
        : const <String, dynamic>{};
    final workerProfile = data['worker_profile'] is Map
        ? Map<String, dynamic>.from(data['worker_profile'] as Map)
        : const <String, dynamic>{};

    return WorkerProfileModel(
      id: (data['id'] ?? '').toString(),
      name: (data['fullname'] ?? '').toString(),
      role: (data['role'] ?? '').toString(),
      // Rewrites localhost image hosts so they load on emulators/devices.
      avatarUrl: ApiUrlParameters.resolveImageUrl(
        (profile['image'] ?? '').toString(),
      ),
      isVerified: false,
      // The employee id shown on the profile is the user's id.
      employeeId: (data['id'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      // Tolerant on purpose. Laravel serializes `decimal` columns as STRINGS
      // ("4.20"), and an `as num` cast on one throws a TypeError — which, on
      // the attach/detach path, would turn a request the server had ALREADY
      // applied into a reported failure and roll the change back on screen.
      rating: _toDouble(workerProfile['rating']),
      completedTasks: 0,
      availability: availabilityFromCode(workerProfile['status']?.toString()),
      address: (profile['address'] ?? '').toString(),
      phone: (profile['phone'] ?? '').toString(),
      experienceYears: _toInt(workerProfile['experience_years']),
      isLeader: workerProfile['is_leader'] == true,
      skills: skillsFromJson(workerProfile['skills']),
    );
  }

  /// A double from `4.2`, `"4.20"`, `4` or nothing at all. Never throws — see
  /// the note on `rating` in [WorkerProfileModel.fromMeJson].
  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString().trim() ?? '') ?? 0;
  }

  /// An int from `35`, `"35"`, `35.0` or nothing at all. Never throws.
  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    final text = value?.toString().trim() ?? '';
    return int.tryParse(text) ?? double.tryParse(text)?.toInt() ?? 0;
  }

  /// Pulls the image value out of a response EXACTLY as the server wrote it.
  ///
  /// Accepts every shape the API uses for it — `data.profile.image`,
  /// `data.image`, `data.path` or a bare `{image: ...}` — and returns the
  /// string untouched: no trimming, no unescaping, no backslash→slash
  /// conversion. This is the value that must be echoed back to
  /// `POST /api/worker-profiles/update-image`, so any "cleanup" here would make
  /// the server reject it or store a path that resolves to nothing.
  static String rawImageFrom(dynamic body) {
    if (body is! Map) return '';
    final envelope = Map<String, dynamic>.from(body);
    final data = envelope['data'] is Map
        ? Map<String, dynamic>.from(envelope['data'] as Map)
        : envelope;
    final profile = data['profile'] is Map
        ? Map<String, dynamic>.from(data['profile'] as Map)
        : const <String, dynamic>{};

    final value =
        profile['image'] ?? data['image'] ?? data['path'] ?? envelope['image'];
    return value?.toString() ?? '';
  }

  /// Parses the `POST /api/worker-profiles/update-image` response.
  ///
  /// The endpoint may echo the whole worker object or just the stored image —
  /// both are handled. The image the SERVER returned is the source of truth;
  /// [sentPath] (the path we posted) is only a fallback for a response that
  /// confirms the update without repeating the value.
  factory WorkerProfileModel.fromImageUpdateJson(
    dynamic body, {
    required String sentPath,
  }) {
    final envelope = body is Map
        ? Map<String, dynamic>.from(body)
        : const <String, dynamic>{};
    final data = envelope['data'] is Map
        ? Map<String, dynamic>.from(envelope['data'] as Map)
        : envelope;

    // A full worker payload → reuse the canonical parser.
    if (data['fullname'] != null ||
        data['worker_profile'] != null ||
        data['email'] != null) {
      return WorkerProfileModel.fromMeJson(envelope);
    }

    final raw = rawImageFrom(body);
    return WorkerProfileModel.avatarOnly(
      ApiUrlParameters.resolveImageUrl(raw.isNotEmpty ? raw : sentPath),
    );
  }

  /// A model carrying ONLY the avatar; every other field is left at its neutral
  /// default. The photo endpoints answer about the photo alone, so the caller
  /// merges just this field onto the profile it already holds (see
  /// `WorkerProfileBloc._onSaveProfileImage`) — merging the whole object would
  /// let these defaults overwrite real values.
  ///
  /// An empty [avatarUrl] is meaningful: "the photo changed, but the server did
  /// not say where it now lives".
  factory WorkerProfileModel.avatarOnly(String avatarUrl) => WorkerProfileModel(
    id: '',
    name: '',
    role: '',
    avatarUrl: avatarUrl,
    isVerified: false,
    employeeId: '',
    email: '',
    rating: 0,
    completedTasks: 0,
    availability: WorkerAvailability.available,
    address: '',
    phone: '',
  );

  /// Parses the `GET /api/skills` DICTIONARY response (`{status, message,
  /// data: [{id, name}]}` — a single, server-localized `name`).
  ///
  /// [languageCode] is the language the dictionary was requested in, i.e. the
  /// `Accept-Language` that produced these names; it decides which side of the
  /// entity the localized string lands on. Defaults to the current language.
  static List<WorkerSkill> skillsListFromResponse(
    dynamic body, {
    String? languageCode,
  }) => SkillModel.listFrom(body, languageCode: languageCode);

  /// Parses a worker's own `skills` list (`[{id, name_ar, name_en, pivot}]`).
  /// Null, malformed or id-less entries are skipped, and BOTH shapes are
  /// accepted — see [SkillModel.fromJson].
  static List<WorkerSkill> skillsFromJson(dynamic value) =>
      SkillModel.listFrom(value);

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    // The real API wraps every resource in a top-level "data" envelope (see
    // LoginModel.fromJson); the fake/in-memory source hands over a flat map.
    // Accept both so this parses correctly regardless of the source.
    final data = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;

    return WorkerProfileModel(
      id: (data['id'] ?? data['user_id']).toString(),
      name: (data['name'] ?? '').toString(),
      role: (data['role'] ?? '').toString(),
      // 'image' is the worker-profile table's column name; 'avatarUrl' /
      // 'avatar_url' cover the other shapes the app has parsed historically.
      avatarUrl:
          (data['avatarUrl'] ?? data['avatar_url'] ?? data['image'] ?? '')
              .toString(),
      isVerified: data['isVerified'] ?? data['is_verified'] ?? false,
      employeeId: (data['employeeId'] ?? data['employee_id'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),
      rating: _toDouble(data['rating']),
      completedTasks: _toInt(data['completedTasks'] ?? data['completed_tasks']),
      availability: availabilityFromCode(data['availability']?.toString()),
      address: (data['address'] ?? '').toString(),
      phone: (data['phone'] ?? '').toString(),
      experienceYears: _toInt(
        data['experienceYears'] ?? data['experience_years'],
      ),
      isLeader: data['isLeader'] ?? data['is_leader'] ?? false,
      skills: skillsFromJson(data['skills']),
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
    'address': address,
    'phone': phone,
    'experienceYears': experienceYears,
    'isLeader': isLeader,
    'skills': [
      for (final s in skills)
        {'id': s.id, 'name_ar': s.nameAr, 'name_en': s.nameEn},
    ],
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
    address: p.address,
    phone: p.phone,
    experienceYears: p.experienceYears,
    isLeader: p.isLeader,
    skills: p.skills,
  );

  /// Maps the API `status` to the worker's chosen BASE availability. The API
  /// only ever carries `available` / `off` (`offline` is accepted as a legacy
  /// alias); `busy` is derived on the client (see [effectiveWorkerStatus]) and
  /// deliberately never produced here, so the base value is never clobbered.
  static WorkerAvailability availabilityFromCode(String? code) {
    switch (code) {
      case 'off':
      case 'offline':
        return WorkerAvailability.off;
      case 'available':
      default:
        return WorkerAvailability.available;
    }
  }

  static String availabilityCode(WorkerAvailability availability) {
    switch (availability) {
      case WorkerAvailability.available:
        return 'available';
      // Guarded upstream (UseCase/UI) so it is never actually sent, but mapped
      // for completeness.
      case WorkerAvailability.busy:
        return 'busy';
      case WorkerAvailability.off:
        return 'off';
    }
  }
}
