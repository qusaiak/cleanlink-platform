import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/worker_profile.dart';
import '../repositories/worker_profile_repository.dart';

/// Updates ONLY the worker's profile photo (`PUT /api/worker-profiles`, sent as
/// multipart with just the `image` field). Kept separate from
/// [UpdateWorkerProfileUseCase] so the field edits and the photo upload stay
/// independent. [params] is the picked [XFile] (never converted to a raw
/// File/path, so it stays web-compatible).
class UpdateProfileImageUseCase
    implements UseCase<Either<Failure, WorkerProfile>, XFile> {
  final WorkerProfileRepository repository;

  UpdateProfileImageUseCase(this.repository);

  @override
  Future<Either<Failure, WorkerProfile>> call({XFile? params}) {
    return repository.updateProfileImage(params!);
  }
}
