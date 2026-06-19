import 'package:dio/dio.dart';

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
    String? email,
    String? employeeId,
  }) => _preferLive(
    () => primary.updateProfile(email: email, employeeId: employeeId),
    () => fallback.updateProfile(email: email, employeeId: employeeId),
  );
}
