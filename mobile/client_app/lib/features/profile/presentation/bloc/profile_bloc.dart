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
import '../../../locations/presentation/bloc/locations_bloc.dart';
import '../../../locations/domain/entities/selected_map_location.dart';
import '../../domain/usecases/profile_usecase.dart';
import '../../domain/entities/dashboard_summary_entity.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UpdateClientProfileUseCase _updateProfileUseCase;
  final LogoutUseCase _logoutUseCase;
  final GetDashboardSummaryUseCase _getDashboardSummaryUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  final UserSession _session;
  final ImagePicker _imagePicker;
  final FirebaseApi _firebaseApi;

  ProfileBloc(
    this._updateProfileUseCase,
    this._logoutUseCase,
    this._getDashboardSummaryUseCase,
    this._deleteAccountUseCase,
    this._session,
    this._imagePicker,
    FirebaseApi firebaseApi,
  ) : _firebaseApi = firebaseApi,
      super(
        ProfileState(
          status: ProfileStatus.initial,
          isLight: AppThemeInfo.isLight,
          languageCode: AppLanguageInfo.languageCode,
          notificationsEnabled: firebaseApi.notificationsEnabled,
        ),
      ) {
    on<ChangeThemeEvent>(_onChangeTheme);
    on<ChangeLanguageEvent>(_onChangeLanguage);
    on<LoadProfileDataEvent>(_onLoadProfileData);
    on<PickProfileImageEvent>(_onPickProfileImage);
    on<SelectProfileLocationEvent>((event, emit) {
      emit(
        state.copyWith(
          selectedMapLocation: event.location,
          address: event.location.formattedAddress,
        ),
      );
    });
    on<UpdateProfileEvent>(_onUpdateProfile);
    on<LogoutEvent>(_onLogout);
    on<GetDashboardSummaryEvent>(_onGetDashboardSummary);
    on<RefreshProfileEvent>(_onRefreshProfile);
    on<DeleteAccountEvent>(_onDeleteAccount);
    on<LoadNotificationPreferenceEvent>(_onLoadNotificationPreference);
    on<SetNotificationPreferenceEvent>(_onSetNotificationPreference);
    on<OpenNotificationSettingsEvent>((event, emit) async {
      await _firebaseApi.openNotificationSettings();
    });
    on<ClearNotificationFeedbackEvent>((event, emit) {
      emit(state.copyWith(clearNotificationMessage: true));
    });
    on<ClearDeleteAccountResultEvent>((event, emit) {
      emit(
        state.copyWith(
          clearDeleteAccountError: true,
          clearDeleteAccountSuccessMessage: true,
        ),
      );
    });
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

  void _onLoadNotificationPreference(
    LoadNotificationPreferenceEvent event,
    Emitter<ProfileState> emit,
  ) {
    emit(
      state.copyWith(
        notificationsEnabled: _firebaseApi.notificationsEnabled,
        notificationPermissionStatus: _firebaseApi.notificationsEnabled
            ? NotificationPermissionStatus.authorized
            : null,
      ),
    );
  }

  Future<void> _onSetNotificationPreference(
    SetNotificationPreferenceEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isUpdatingNotificationPreference ||
        state.notificationsEnabled == event.enabled) {
      return;
    }
    final previousValue = state.notificationsEnabled;
    emit(
      state.copyWith(
        isUpdatingNotificationPreference: true,
        clearNotificationMessage: true,
      ),
    );
    try {
      if (!event.enabled) {
        await _firebaseApi.disableNotifications();
        emit(
          state.copyWith(
            notificationsEnabled: false,
            isUpdatingNotificationPreference: false,
            notificationMessage: 'notifications_disabled_message',
            notificationPermissionStatus:
                NotificationPermissionStatus.authorized,
            notificationUpdateRevision: state.notificationUpdateRevision + 1,
          ),
        );
        return;
      }

      final result = await _firebaseApi.enableNotifications();
      emit(
        state.copyWith(
          notificationsEnabled: result.enabled,
          isUpdatingNotificationPreference: false,
          notificationPermissionStatus: result.permissionStatus,
          notificationMessage: result.enabled
              ? 'notifications_enabled_message'
              : result.syncFailed
              ? 'notification_sync_failed'
              : 'notification_permission_disabled',
          notificationUpdateRevision: state.notificationUpdateRevision + 1,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          notificationsEnabled: previousValue,
          isUpdatingNotificationPreference: false,
          notificationMessage: 'notification_sync_failed',
          notificationUpdateRevision: state.notificationUpdateRevision + 1,
        ),
      );
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

    if (fullname.isEmpty || email.isEmpty || phone.isEmpty) {
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
          phone: phone,
          address: state.selectedMapLocation?.formattedAddress ?? state.address,
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
          address: state.address,
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
      _clearLocationsSession();
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
        _clearLocationsSession();
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

  Future<void> _onGetDashboardSummary(
    GetDashboardSummaryEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isLoadingDashboardSummary) return;
    emit(
      state.copyWith(
        isLoadingDashboardSummary: true,
        clearDashboardError: true,
      ),
    );
    try {
      final summary = await _getDashboardSummaryUseCase();
      emit(
        state.copyWith(
          dashboardSummary: summary,
          isLoadingDashboardSummary: false,
          clearDashboardError: true,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          isLoadingDashboardSummary: false,
          dashboardSummaryError: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoadingDashboardSummary: false,
          dashboardSummaryError: 'could_not_load_profile_summary',
        ),
      );
    }
  }

  Future<void> _onRefreshProfile(
    RefreshProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isRefreshingProfile) return;
    emit(state.copyWith(isRefreshingProfile: true, clearDashboardError: true));
    await _session.load();
    try {
      final summary = await _getDashboardSummaryUseCase();
      emit(
        state.copyWith(
          dashboardSummary: summary,
          isRefreshingProfile: false,
          fullname: _session.fullname ?? '',
          email: _session.email ?? '',
          phone: _session.phone ?? '',
          address: _session.address ?? '',
          image: _session.image ?? '',
          clearDashboardError: true,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          isRefreshingProfile: false,
          dashboardSummaryError: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isRefreshingProfile: false,
          dashboardSummaryError: 'could_not_load_profile_summary',
        ),
      );
    }
  }

  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<ProfileState> emit,
  ) async {
    if (state.isDeletingAccount) return;
    emit(
      state.copyWith(isDeletingAccount: true, clearDeleteAccountError: true),
    );
    try {
      final message = await _deleteAccountUseCase();
      _clearLocationsSession();
      emit(
        state.copyWith(
          isDeletingAccount: false,
          deleteAccountSuccessMessage: message,
          clearDeleteAccountError: true,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          isDeletingAccount: false,
          deleteAccountError: failure.message,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isDeletingAccount: false,
          deleteAccountError: 'failed_to_delete_account',
        ),
      );
    }
  }

  void _clearLocationsSession() {
    if (!GetIt.I.isRegistered<LocationsBloc>()) return;
    GetIt.I<LocationsBloc>().add(const ClearLocationsSessionEvent());
  }
}
