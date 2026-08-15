import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../domain/entities/worker_profile.dart';
import '../models/worker_profile_model.dart';
import 'worker_profile_remote_data_source.dart';

/// A [WorkerProfileRemoteDataSource] that prefers live data from the
/// backend/database but transparently falls back to the current in-memory data
/// when the server is not reachable.
///
/// See [FallbackTasksRemoteDataSource] for the rationale: live data when the
/// server (and its database) is running, the current data otherwise. Genuine
/// HTTP error responses are left to propagate.
class FallbackWorkerProfileRemoteDataSource
    implements WorkerProfileRemoteDataSource {
  /// Real Dio-backed source (GET/PATCH against the backend → database).
  final WorkerProfileRemoteDataSource primary;

  /// In-memory source used when the backend can't be reached.
  final WorkerProfileRemoteDataSource fallback;

  FallbackWorkerProfileRemoteDataSource({
    required this.primary,
    required this.fallback,
  });

  bool _isServerUnreachable(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionError:
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
      case DioExceptionType.unknown:
        return true;
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
        return false;
    }
  }

  Future<T> _preferLive<T>(
    Future<T> Function() live,
    Future<T> Function() offline,
  ) async {
    try {
      return await live();
    } on DioException catch (e) {
      if (_isServerUnreachable(e)) return await offline();
      rethrow;
    }
  }

  @override
  Future<WorkerProfileModel> getProfile() =>
      _preferLive(primary.getProfile, fallback.getProfile);

  @override
  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  ) => _preferLive(
    () => primary.updateAvailability(availability),
    () => fallback.updateAvailability(availability),
  );

  @override
  Future<WorkerProfileModel> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  }) => _preferLive(
    () => primary.updateProfile(
      fullname: fullname,
      email: email,
      address: address,
      phone: phone,
      experienceYears: experienceYears,
      status: status,
    ),
    () => fallback.updateProfile(
      fullname: fullname,
      email: email,
      address: address,
      phone: phone,
      experienceYears: experienceYears,
      status: status,
    ),
  );

  @override
  Future<WorkerProfileModel> updateProfileImage(XFile image) => _preferLive(
    () => primary.updateProfileImage(image),
    () => fallback.updateProfileImage(image),
  );

  @override
  Future<WorkerProfileModel> persistProfileImage(String storedImagePath) =>
      _preferLive(
        () => primary.persistProfileImage(storedImagePath),
        () => fallback.persistProfileImage(storedImagePath),
      );

  @override
  Future<List<WorkerSkill>> getAllSkills() =>
      _preferLive(primary.getAllSkills, fallback.getAllSkills);

  // Skills mutations deliberately do NOT go through [_preferLive].
  //
  // Falling back to the in-memory source on an unreachable server is right for
  // a READ (show something rather than an empty screen) and badly wrong for a
  // WRITE: the fake source happily "succeeds", so the app reported "Skill
  // added", adopted the FAKE worker as the new source of truth — overwriting
  // the real skills, rating and avatar in state and in the cached session —
  // and then the next real profile fetch silently undid it all. From the
  // worker's side that is exactly "adding a skill does nothing".
  //
  // A write that did not reach the backend must fail loudly instead, so the
  // repository turns it into a Failure and the screen shows the real reason
  // and rolls the chip back.

  @override
  Future<WorkerProfileModel> attachSkills(List<int> skillIds) =>
      primary.attachSkills(skillIds);

  @override
  Future<WorkerProfileModel> detachSkills(List<int> skillIds) =>
      primary.detachSkills(skillIds);
}
