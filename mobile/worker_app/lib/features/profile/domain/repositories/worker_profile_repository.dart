import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../entities/worker_profile.dart';

abstract class WorkerProfileRepository {
  Future<Either<Failure, WorkerProfile>> getProfile();

  Future<Either<Failure, WorkerProfile>> updateAvailability(
    WorkerAvailability availability,
  );

  Future<Either<Failure, WorkerProfile>> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  });

  Future<Either<Failure, WorkerProfile>> updateProfileImage(XFile image);

  Future<Either<Failure, List<WorkerSkill>>> getAllSkills();

  Future<Either<Failure, WorkerProfile>> attachSkills(List<int> skillIds);

  Future<Either<Failure, WorkerProfile>> detachSkills(List<int> skillIds);
}
