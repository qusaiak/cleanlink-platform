import 'dart:async';
import 'dart:io';

import 'package:client_app/firebase_api.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../config/language/app_language_info.dart';
import '../../../../config/theme/app_theme_info.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/session/user_session.dart';
import '../../../auth/domain/entities/user_entity.dart';
import '../../domain/usecases/profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateClientProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final UserSession _session;
  final ImagePicker _imagePicker;

  ProfileBloc(
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._session,
    this._imagePicker,
  ) : super(
        ProfileState(
          status: ProfileStatus.initial,
          isLight: AppThemeInfo.isLight,
          languageCode: AppLanguageInfo.languageCode,
        ),
      ) {
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadProfileDataEvent>(_onLoadProfileData);
    on<PickProfileImageEvent>(_onPickProfileImage);
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
  }

  Future<void> _onChangeTheme(
    ChangeThemeEvent event,
    Emitter<ProfileState> emit,
  ) async {
    await AppThemeInfo.toggleTheme();

    emit(
      state.copyWith(
        status: ProfileStatus.changeTheme,
        isLight: AppThemeInfo.isLight,
      ),
    );
  }

  Future<void> _onChangeLanguage(
    ChangeLanguageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    String languageCode = AppLanguageInfo.languageCode;

    languageCode = languageCode == "en" ? "ar" : "en";

    await AppLanguageInfo.setLanguageCode(languageCode);
    unawaited(_syncFcmTokenAfterLanguageChange());

    // sl<ClientWrapper>().updateHeader(
    //   HttpHeader.acceptLanguage,
    //   languageCode.toUpperCase(),
    // );

    emit(
      state.copyWith(
        status: ProfileStatus.changeLanguage,
        languageCode: languageCode,
      ),
    );
  }

  Future<void> _syncFcmTokenAfterLanguageChange() async {
    try {
      if (!GetIt.I.isRegistered<FirebaseApi>()) return;
      await GetIt.I<FirebaseApi>().syncFcmTokenWithBackend();
    } catch (e) {
      debugPrint('FCM sync after language change failed: $e');
    }
  }

  Future<void> _onLoadProfileData(
    LoadProfileDataEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(status: ProfileStatus.loadingProfile, errorMessage: null),
    );
    await _session.load();
    emit(
      state.copyWith(
        status: ProfileStatus.profileLoaded,
        fullname: _session.fullname ?? '',
        email: _session.email ?? '',
        phone: _session.phone ?? '',
        address: _session.address ?? '',
        image: _session.image ?? '',
        clearImageFile: true,
        errorMessage: null,
      ),
    );
  }

  Future<void> _onPickProfileImage(
    PickProfileImageEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(
      state.copyWith(status: ProfileStatus.pickingImage, errorMessage: null),
    );
    try {
      final image = await _imagePicker.pickImage(source: ImageSource.gallery);
      emit(
        state.copyWith(
          status: ProfileStatus.imagePicked,
          image: image?.path ?? state.image,
          imageFile: image == null ? state.imageFile : File(image.path),
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'failed_to_pick_image',
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    final fullname = event.fullname.trim();
    final email = event.email.trim();
    final phone = event.phone.trim();
    final address = event.address.trim();

    if (fullname.isEmpty || email.isEmpty || phone.isEmpty || address.isEmpty) {
      emit(
        state.copyWith(
          status: ProfileStatus.validationError,
          errorMessage: 'fill_required_fields',
        ),
      );
      return;
    }

    if (!RegExp(r'^[\w\-\.]+@([\w\-]+\.)+[\w\-]{2,4}$').hasMatch(email)) {
      emit(
        state.copyWith(
          status: ProfileStatus.validationError,
          errorMessage: 'validation_email_invalid',
        ),
      );
      return;
    }

    emit(
      state.copyWith(status: ProfileStatus.updatingProfile, errorMessage: null),
    );
    try {
      final user = await _updateProfileUseCase(
        UpdateClientProfileParams(
          fullname: fullname,
          email: email,
          address: address,
          phone: phone,
          image: state.imageFile,
        ),
      );
      emit(
        state.copyWith(
          status: ProfileStatus.updateSuccess,
          user: user,
          fullname: user.fullname,
          email: user.email,
          phone: user.profile?.phone ?? phone,
          address: user.profile?.address ?? address,
          image: user.profile?.image ?? state.image,
          clearImageFile: true,
          successMessage: 'profile_updated_successfully',
          errorMessage: null,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'failed_to_update_profile',
        ),
      );
    }
  }

  Future<void> _onLogout(LogoutEvent event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(status: ProfileStatus.loggingOut, errorMessage: null));
    try {
      final message = await _logoutUseCase();
      emit(
        state.copyWith(
          status: ProfileStatus.logoutSuccess,
          successMessage: message,
          errorMessage: null,
        ),
      );
    } on Failure catch (failure) {
      if (failure.errorCode == '401' || failure.errorCode == '403') {
        await _session.clear();
        emit(
          state.copyWith(
            status: ProfileStatus.logoutSuccess,
            successMessage: 'logout_successfully',
            errorMessage: null,
          ),
        );
        return;
      }
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: ProfileStatus.failure,
          errorMessage: 'failed_to_logout',
        ),
      );
    }
  }
}
