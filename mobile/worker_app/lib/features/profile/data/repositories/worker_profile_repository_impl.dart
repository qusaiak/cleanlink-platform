import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/worker_profile.dart';
import '../../domain/repositories/worker_profile_repository.dart';
import '../datasources/worker_profile_remote_data_source.dart';

/// Concrete [WorkerProfileRepository]: connectivity guard + Dio→Failure mapping,
/// mirroring `TasksRepositoryImpl`.
class WorkerProfileRepositoryImpl implements WorkerProfileRepository {
  final WorkerProfileRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  WorkerProfileRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });

  Future<Either<Failure, T>> _guard<T>(Future<T> Function() action) async {
    if (!await networkInfo.isConnected) {
      return const Left(
        ConnectionFailure('No Internet Connection', ErrorCode.noInternet),
      );
    }
    try {
      return Right(await action());
    } on DioException catch (e) {
      return Left(ServerFailure.fromDioError(e));
    } catch (e) {
      return Left(ServerFailure(e.toString(), ''));
    }
  }

  @override
  Future<Either<Failure, WorkerProfile>> getProfile() =>
      _guard(() => remoteDataSource.getProfile());

  @override
  Future<Either<Failure, WorkerProfile>> updateAvailability(
    WorkerAvailability availability,
  ) => _guard(() => remoteDataSource.updateAvailability(availability));

  @override
  Future<Either<Failure, WorkerProfile>> updateProfile({
    String? email,
    String? employeeId,
  }) => _guard(
    () => remoteDataSource.updateProfile(email: email, employeeId: employeeId),
  );
}
