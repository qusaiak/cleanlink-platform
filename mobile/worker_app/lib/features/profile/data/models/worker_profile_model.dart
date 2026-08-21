import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/worker_profile.dart';
import 'skill_model.dart';

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

      avatarUrl: ApiUrlParameters.resolveImageUrl(
        (profile['image'] ?? '').toString(),
      ),
      isVerified: false,

      employeeId: (data['id'] ?? '').toString(),
      email: (data['email'] ?? '').toString(),

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

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    return double.tryParse(value?.toString().trim() ?? '') ?? 0;
  }

  static int _toInt(dynamic value) {
    if (value is num) return value.toInt();
    final text = value?.toString().trim() ?? '';
    return int.tryParse(text) ?? double.tryParse(text)?.toInt() ?? 0;
  }

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

  static List<WorkerSkill> skillsListFromResponse(
    dynamic body, {
    String? languageCode,
  }) => SkillModel.listFrom(body, languageCode: languageCode);

  static List<WorkerSkill> skillsFromJson(dynamic value) =>
      SkillModel.listFrom(value);

  factory WorkerProfileModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] is Map
        ? json['data'] as Map<String, dynamic>
        : json;

    return WorkerProfileModel(
      id: (data['id'] ?? data['user_id']).toString(),
      name: (data['name'] ?? '').toString(),
      role: (data['role'] ?? '').toString(),

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

      case WorkerAvailability.busy:
        return 'busy';
      case WorkerAvailability.off:
        return 'off';
    }
  }
}
