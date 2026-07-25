import 'package:dio/dio.dart';

import '../../../../config/constants/api_url_parameters.dart';
import '../../domain/entities/worker_profile.dart';
import '../models/worker_profile_model.dart';

/// Remote data source contract for the worker profile. Implementations return
/// a model or throw a [DioException]; the repository maps to `Either<Failure,T>`.
abstract class WorkerProfileRemoteDataSource {
  Future<WorkerProfileModel> getProfile();

  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  );

  /// Patches the editable profile fields; only the non-null ones are sent.
  Future<WorkerProfileModel> updateProfile({
    String? email,
    String? employeeId,
  });
}

/// Real Dio-backed implementation (production path). Wire this in place of the
/// fake source in `injection_container.dart` once the API base URL is set.
class WorkerProfileRemoteDataSourceImpl
    implements WorkerProfileRemoteDataSource {
  final Dio dio;

  WorkerProfileRemoteDataSourceImpl(this.dio);

  @override
  Future<WorkerProfileModel> getProfile() async {
    final response = await dio.get(ApiUrlParameters.workerProfile);
    return WorkerProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WorkerProfileModel> updateAvailability(
    WorkerAvailability availability,
  ) async {
    final response = await dio.patch(
      ApiUrlParameters.workerAvailability,
      data: {'availability': WorkerProfileModel.availabilityCode(availability)},
    );
    return WorkerProfileModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<WorkerProfileModel> updateProfile({
    String? email,
    String? employeeId,
  }) async {
    final response = await dio.patch(
      ApiUrlParameters.workerProfile,
      data: {
        if (email != null) 'email': email,
        if (employeeId != null) 'employeeId': employeeId,
      },
    );
    return WorkerProfileModel.fromJson(response.data as Map<String, dynamic>);
  }
}
