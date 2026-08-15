import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/error/failure.dart';
import '../../../../core/utils/map_address_normalizer.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import '../../../locations/domain/entities/selected_map_location.dart';
import '../../../locations/domain/usecases/locations_usecases.dart';

part 'personal_details_event.dart';
part 'personal_details_state.dart';

class PersonalDetailsBloc
    extends Bloc<PersonalDetailsEvent, PersonalDetailsState> {
  final UpdateProfileUseCase _updateProfileUseCase;
  final ImagePicker _imagePicker;
  final AddLocationUseCase _addLocationUseCase;

  PersonalDetailsBloc(
    this._updateProfileUseCase,
    this._imagePicker,
    this._addLocationUseCase,
  ) : super(const PersonalDetailsState()) {
    on<PersonalDetailsImagePicked>(_onImagePicked);
    on<PersonalDetailsLocationChanged>(_onLocationChanged);
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

  void _onLocationChanged(
    PersonalDetailsLocationChanged event,
    Emitter<PersonalDetailsState> emit,
  ) {
    emit(state.copyWith(location: event.location, status: null));
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
    if (state.location == null || state.phone.trim().isEmpty) {
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.validationError,
          error: const ServerFailure('select_service_location', ''),
        ),
      );
      return;
    }

    emit(state.copyWith(status: PersonalDetailsStatus.loading));

    try {
      final address = normalizeGoogleMapAddress(
        state.location!.formattedAddress,
      );
      final profile = await _updateProfileUseCase(
        UpdateProfileParams(
          image: state.imagePath.isEmpty ? null : File(state.imagePath),
          latitude: state.location!.latitude,
          longitude: state.location!.longitude,
          address: address,
          phone: state.phone.trim(),
        ),
      );
      await _addLocationUseCase(
        localName: 'home',
        address: address,
        latitude: state.location!.latitude,
        longitude: state.location!.longitude,
      );
      emit(
        state.copyWith(
          status: PersonalDetailsStatus.success,
          location: state.location,
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
