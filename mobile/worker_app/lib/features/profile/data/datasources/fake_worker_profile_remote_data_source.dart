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
  );

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
    String? email,
    String? employeeId,
  }) async {
    await _delay();
    _profile = WorkerProfileModel.fromEntity(
      _profile.copyWith(email: email, employeeId: employeeId),
    );
    return _profile;
  }
}
