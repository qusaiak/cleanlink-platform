import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class UpdateProfileParams extends Equatable {
  final String? fullname;
  final String? email;
  final String? address;
  final String? phone;
  final int? experienceYears;
  final WorkerAvailability? status;

  const UpdateProfileParams({
    this.fullname,
    this.email,
    this.address,
    this.phone,
    this.experienceYears,
    this.status,
  });

  @override
  List<Object?> get props => [
    fullname,
    email,
    address,
    phone,
    experienceYears,
    status,
  ];
}

class UpdateWorkerProfileUseCase
    implements UseCase<Either<Failure, WorkerProfile>, UpdateProfileParams> {
  final WorkerProfileRepository repository;

  UpdateWorkerProfileUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({UpdateProfileParams? params}) {
    return repository.updateProfile(
      fullname: params?.fullname,
      email: params?.email,
      address: params?.address,
      phone: params?.phone,
      experienceYears: params?.experienceYears,
      status: params?.status,
    );
  }
}
