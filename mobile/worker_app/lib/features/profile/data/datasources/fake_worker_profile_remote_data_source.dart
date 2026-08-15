import 'package:image_picker/image_picker.dart';

import '../../domain/entities/worker_profile.dart';
import '../models/worker_profile_model.dart';
import 'worker_profile_remote_data_source.dart';

/// In-memory mock of [WorkerProfileRemoteDataSource] (no backend yet).
/// Persists availability changes for the session. Sample content matches the
/// worker design.
class FakeWorkerProfileRemoteDataSource
    implements WorkerProfileRemoteDataSource {
  WorkerProfileModel _profile = const WorkerProfileModel(
    id: '1',
    name: 'أحمد محمد',
    role: 'في صيانة',
    avatarUrl: 'https://i.pravatar.cc/300?img=12',
    isVerified: true,
    employeeId: 'EMP-8821',
    email: 'ahmed.m@company.com',
    rating: 4.8,
    completedTasks: 24,
    availability: WorkerAvailability.available,
    address: 'Street 98, Cairo, Egypt',
    phone: '+201260075841',
    experienceYears: 3,
    isLeader: false,
    skills: [
      WorkerSkill(
        id: 2,
        nameAr: 'التنظيف العميق وإزالة الدهون المستعصية',
        nameEn: 'Deep Cleaning & Degreasing Operations',
      ),
      WorkerSkill(
        id: 4,
        nameAr: 'تعقيم وتطهير الحمامات والمسطحات البيضاء',
        nameEn: 'Advanced Bathroom Disinfection',
      ),
    ],
  );

  /// Full in-memory skill catalogue (what `GET /api/skills` would return).
  static const List<WorkerSkill> _allSkills = [
    WorkerSkill(id: 1, nameAr: 'التنظيف العام', nameEn: 'General Cleaning'),
    WorkerSkill(
      id: 2,
      nameAr: 'التنظيف العميق وإزالة الدهون المستعصية',
      nameEn: 'Deep Cleaning & Degreasing Operations',
    ),
    WorkerSkill(id: 3, nameAr: 'تنظيف النوافذ والزجاج', nameEn: 'Window & Glass Cleaning'),
    WorkerSkill(
      id: 4,
      nameAr: 'تعقيم وتطهير الحمامات والمسطحات البيضاء',
      nameEn: 'Advanced Bathroom Disinfection',
    ),
    WorkerSkill(id: 5, nameAr: 'تنظيف السجاد والمفروشات', nameEn: 'Carpet & Upholstery Cleaning'),
    WorkerSkill(id: 6, nameAr: 'تلميع الأرضيات', nameEn: 'Floor Polishing'),
    WorkerSkill(id: 7, nameAr: 'تنظيف ما بعد البناء', nameEn: 'Post-Construction Cleaning'),
  ];

  Future<void> _delay() => Future.delayed(const Duration(milliseconds: 500));

  @override
  Future<WorkerProfileModel> getProfile() async {
    await _delay();
    return _profile;
  }

  @override
  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  ) async {
    await _delay();
    _profile = WorkerProfileModel.fromEntity(
      _profile.copyWith(availability: availability),
    );
    return _profile;
  }

  @override
  Future<WorkerProfileModel> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  }) async {
    await _delay();
    _profile = WorkerProfileModel.fromEntity(
      _profile.copyWith(
        name: fullname,
        email: email,
        address: address,
        phone: phone,
        experienceYears: experienceYears,
        availability: status,
      ),
    );
    return _profile;
  }

  @override
  Future<WorkerProfileModel> updateProfileImage(XFile image) async {
    await _delay();
    // [image] is ignored offline — the avatar widget only loads network URLs,
    // so the current picture is kept until the backend is reachable.
    return _profile;
  }

  @override
  Future<WorkerProfileModel> persistProfileImage(String storedImagePath) async {
    await _delay();
    // Offline there is no uploaded file to point at, so the stored path can't
    // resolve to anything loadable; the current picture is kept, mirroring
    // [updateProfileImage].
    return _profile;
  }

  @override
  Future<List<WorkerSkill>> getAllSkills() async {
    await _delay();
    return _allSkills;
  }

  /// Mirrors the real endpoint's ADD semantics: the ids are added to whatever
  /// the worker already has (never replacing the set), and the full profile is
  /// returned — the same contract the live source honours.
  @override
  Future<WorkerProfileModel> attachSkills(List<int> skillIds) async {
    await _delay();
    final owned = {for (final s in _profile.skills) s.id};
    final added = _allSkills.where(
      (s) => skillIds.contains(s.id) && !owned.contains(s.id),
    );
    return _storeSkills([..._profile.skills, ...added]);
  }

  @override
  Future<WorkerProfileModel> detachSkills(List<int> skillIds) async {
    await _delay();
    return _storeSkills(
      _profile.skills.where((s) => !skillIds.contains(s.id)).toList(),
    );
  }

  /// Persists the new set in memory (so it survives for the session, like the
  /// other fake mutations) and returns the updated profile.
  WorkerProfileModel _storeSkills(List<WorkerSkill> skills) {
    _profile = WorkerProfileModel.fromEntity(_profile.copyWith(skills: skills));
    return _profile;
  }
}
