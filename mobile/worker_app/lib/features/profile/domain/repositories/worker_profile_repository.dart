import 'package:dartz/dartz.dart';

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
  /// edit on the email / employee-id rows.
  Future<Either<Failure, WorkerProfile>> updateProfile({
    String? email,
    String? employeeId,
  });
}
