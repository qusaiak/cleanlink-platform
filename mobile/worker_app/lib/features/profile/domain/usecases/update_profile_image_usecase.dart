import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

class UpdateProfileImageUseCase
    implements UseCase<Either<Failure, WorkerProfile>, XFile> {
  final WorkerProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({XFile? params}) {
    return repository.updateProfileImage(params!);
  }
}
