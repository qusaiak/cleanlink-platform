import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../../domain/usecases/update_profile_usecase.dart';

part 'personal_details_event.dart';
part 'personal_details_state.dart';

class PersonalDetailsBloc
    extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final ImagePicker _imagePicker;

  PersonalDetailsBloc(this._updateProfileUseCase, this._imagePicker)
    : super(const PersonalDetailsState()) {
    on<PersonalDetailsImagePicked>(_onImagePicked);
    on<PersonalDetailsAddressChanged>(_onAddressChanged);
    on<PersonalDetailsPhoneChanged>(_onPhoneChanged);
    on<PersonalDetailsSubmitted>(_onSubmitted);
  }

  Future<void> _onImagePicked(
    PersonalDetailsImagePicked event,
    Emitter<PersonalDetailsState> emit,
  ) async {
    emit(state.copyWith(status: PersonalDetailsStatus.pickingImage));
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.imagePicked,
          imagePath: image?.path ?? '',
        ),
      );
    } catch (_) {
      emit(state.copyWith(status: PersonalDetailsStatus.imagePickError));
    }
  }

  void _onAddressChanged(
    PersonalDetailsAddressChanged event,
    Emitter<PersonalDetailsState> emit,
  ) {
    emit(state.copyWith(address: event.address, status: null));
  }

  void _onPhoneChanged(
    PersonalDetailsPhoneChanged event,
    Emitter<PersonalDetailsState> emit,
  ) {
    emit(state.copyWith(phone: event.phone, status: null));
  }

  Future<void> _onSubmitted(
    PersonalDetailsSubmitted event,
    Emitter<PersonalDetailsState> emit,
  ) async {
    if (state.address.trim().isEmpty || state.phone.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.validationError,
          error: const ServerFailure('Address and phone are required', ''),
        ),
      );
      return;
    }

    emit(state.copyWith(status: PersonalDetailsStatus.loading));

    try {
      final profile = await _updateProfileUseCase(
        UpdateProfileParams(
          image: state.imagePath.isEmpty ? null : File(state.imagePath),
          address: state.address.trim(),
          phone: state.phone.trim(),
        ),
      );
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.success,
          address: profile.address ?? state.address.trim(),
          phone: profile.phone ?? state.phone.trim(),
          imagePath: profile.image ?? state.imagePath,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(status: PersonalDetailsStatus.failure, error: failure),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.failure,
          error: const ServerFailure('Failed to complete profile', ''),
        ),
      );
    }
  }
}
