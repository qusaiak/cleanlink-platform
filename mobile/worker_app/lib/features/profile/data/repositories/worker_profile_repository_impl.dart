import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/network/network_info.dart';
import '../../domain/entities/worker_profile.dart';
import '../../domain/repositories/worker_profile_repository.dart';
import '../datasources/worker_profile_remote_data_source.dart';

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
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  }) => _guard(
    () => remoteDataSource.updateProfile(
      fullname: fullname,
      email: email,
      address: address,
      phone: phone,
      experienceYears: experienceYears,
      status: status,
    ),
  );

  @override
  Future<Either<Failure, WorkerProfile>> updateProfileImage(XFile image) =>
      _guard(() => remoteDataSource.updateProfileImage(image));

  @override
  Future<Either<Failure, List<WorkerSkill>>> getAllSkills() =>
      _guard(() => remoteDataSource.getAllSkills());

  @override
  Future<Either<Failure, WorkerProfile>> attachSkills(List<int> skillIds) =>
      _guard(() => remoteDataSource.attachSkills(skillIds));

  @override
  Future<Either<Failure, WorkerProfile>> detachSkills(List<int> skillIds) =>
      _guard(() => remoteDataSource.detachSkills(skillIds));
}
