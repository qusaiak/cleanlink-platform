import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/worker_profile.dart';
import '../../domain/usecases/get_worker_profile_usecase.dart';
import '../../domain/usecases/update_availability_usecase.dart';
import '../../domain/usecases/update_worker_profile_usecase.dart';

part 'worker_profile_event.dart';
part 'worker_profile_state.dart';

/// Drives the worker profile screen: loads the profile and updates the
/// worker's availability. Kept separate from [ProfileBloc] (theme/language) so
/// concerns stay isolated.
class WorkerProfileBloc extends Bloc<WorkerProfileEvent, WorkerProfileState> {
  final GetWorkerProfileUseCase getProfile;
  final UpdateAvailabilityUseCase updateAvailability;
  final UpdateWorkerProfileUseCase updateProfile;

  WorkerProfileBloc({
    required this.getProfile,
    required this.updateAvailability,
    required this.updateProfile,
  }) : super(const WorkerProfileState()) {
    on<LoadWorkerProfile>(_onLoad);
    on<ChangeAvailability>(_onChangeAvailability);
    on<SaveProfileField>(_onSaveProfileField);
  }

  Future<void> _onLoad(
    LoadWorkerProfile event,
    Emitter<WorkerProfileState> emit,
  ) async {
    emit(state.copyWith(status: WorkerProfileStatus.loading));
    final result = await getProfile();
    result.fold(
      (failure) =>
          emit(state.copyWith(status: WorkerProfileStatus.error, error: failure)),
      (profile) => emit(
        state.copyWith(status: WorkerProfileStatus.loaded, profile: profile),
      ),
    );
  }

  Future<void> _onChangeAvailability(
    ChangeAvailability event,
    Emitter<WorkerProfileState> emit,
  ) async {
    // No-op if it's already the current availability.
    if (state.profile?.availability == event.availability) return;

    emit(
      state.copyWith(
        status: WorkerProfileStatus.updating,
        updatingTo: event.availability,
      ),
    );

    final result = await updateAvailability(params: event.availability);
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WorkerProfileStatus.updateFailure,
          error: failure,
        ),
      ),
      (profile) {
        // Success → snackbar, then settle into the loaded state.
        emit(
          state.copyWith(
            status: WorkerProfileStatus.updateSuccess,
            profile: profile,
          ),
        );
        emit(state.copyWith(status: WorkerProfileStatus.loaded, profile: profile));
      },
    );
  }

  Future<void> _onSaveProfileField(
    SaveProfileField event,
    Emitter<WorkerProfileState> emit,
  ) async {
    final current = state.profile;
    // No-op if nothing actually changed (avoids a needless round-trip).
    final unchanged =
        (event.email == null || event.email == current?.email) &&
        (event.employeeId == null || event.employeeId == current?.employeeId);
    if (unchanged) return;

    emit(state.copyWith(status: WorkerProfileStatus.savingField));

    final result = await updateProfile(
      params: UpdateProfileParams(
        email: event.email,
        employeeId: event.employeeId,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: WorkerProfileStatus.saveFieldFailure,
          error: failure,
        ),
      ),
      (profile) {
        emit(
          state.copyWith(
            status: WorkerProfileStatus.saveFieldSuccess,
            profile: profile,
          ),
        );
        emit(state.copyWith(status: WorkerProfileStatus.loaded, profile: profile));
      },
    );
  }
}
