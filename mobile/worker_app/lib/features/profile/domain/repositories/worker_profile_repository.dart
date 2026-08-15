import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../entities/worker_profile.dart';

/// Domain contract for loading and updating the worker's profile.
/// Returns `Either<Failure, T>` consistent with the rest of the app.
abstract class WorkerProfileRepository {
  Future<Either<Failure, WorkerProfile>> getProfile();

  Future<Either<Failure, WorkerProfile>> updateAvailability(
    WorkerAvailability availability,
  );

  /// Updates editable profile fields (only the non-null ones are sent) and
  /// returns the profile as confirmed by the backend. Used by the inline
  /// edits on the name / email / address / phone / experience rows, the status
  /// selector ([status]).
  Future<Either<Failure, WorkerProfile>> updateProfile({
    String? fullname,
    String? email,
    String? address,
    String? phone,
    int? experienceYears,
    WorkerAvailability? status,
  });

  /// Updates ONLY the profile photo ([image] is the picked [XFile], uploaded as
  /// multipart with no other fields) and returns the profile confirmed by the
  /// backend (its `data.profile.image` carries the new URL).
  Future<Either<Failure, WorkerProfile>> updateProfileImage(XFile image);

  /// The skills DICTIONARY — every assignable skill, localized by the server
  /// for the app's current language. Re-fetched whenever that language changes.
  Future<Either<Failure, List<WorkerSkill>>> getAllSkills();

  /// Attaches [skillIds] to the worker and returns the worker as the server
  /// confirmed it (the response carries the full updated user).
  Future<Either<Failure, WorkerProfile>> attachSkills(List<int> skillIds);

  /// Detaches [skillIds] from the worker; same return contract as
  /// [attachSkills].
  Future<Either<Failure, WorkerProfile>> detachSkills(List<int> skillIds);
}
