import 'dart:async';

import 'package:client_app/firebase_api.dart';
import 'package:client_app/features/auth/presentation/bloc/auth_form_controllers.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/error/failure.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/entities/pending_registration_data.dart';
import '../../domain/usecases/change_password_usecase.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/register_usecase.dart';
import '../../domain/usecases/resend_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  static const int otpResendCountdownSeconds = 60;

  final LoginUseCase _loginUseCase;
  final RegisterUseCase _registerUseCase;
  final VerifyOtpUseCase _verifyOtpUseCase;
  final ResendOtpUseCase _resendOtpUseCase;
  final ChangePasswordUseCase _changePasswordUseCase;
  Timer? _otpCountdownTimer;

  AuthBloc(
    this._loginUseCase,
    this._registerUseCase,
    this._verifyOtpUseCase,
    this._resendOtpUseCase,
    this._changePasswordUseCase,
  ) : forms = AuthFormControllers(),
      super(
        const AuthState().copyWith(
          status: AuthStatus.initial,
          isPasswordVis: false,
          isOldPasswordVis: false,
          isNewPasswordVis: false,
          isConfirmPasswordVis: false,
          isLoadingLogin: false,
          isLoadingRegister: false,
          isVerifyAccountLoading: false,
          isRequestResendVerificationCodeLoading: false,
        ),
      ) {
    on<Login>(onLogin);
    on<Register>(onRegister);
    on<VerifyAccount>(_onVerifyAccount);
    on<RequestResendVerificationCode>(_onResendVerificationCode);
    on<OtpChanged>(_onOtpChanged);
    on<OtpCountdownStarted>(_onOtpCountdownStarted);
    on<OtpCountdownTicked>(_onOtpCountdownTicked);
    on<OtpFlowCancelled>(_onOtpFlowCancelled);
    on<AuthMessagesCleared>(_onAuthMessagesCleared);
    on<AuthStatusHandled>(_onAuthStatusHandled);
    on<AuthSessionCleared>(_onAuthSessionCleared);
    on<ChangePasswordView>(onChangePasswordView);
    on<SubmitChangePassword>(onSubmitChangePassword);
  }

  final AuthFormControllers forms;

  Future<void> onLogin(Login event, Emitter<AuthState> emit) async {
    emit(state.copyWith(status: AuthStatus.loadingLogin));

    try {
      final auth = await _loginUseCase(
        LoginParams(email: event.email, password: event.password),
      );
      unawaited(_syncFcmTokenAfterAuth('login'));

      emit(
        state.copyWith(
          status: AuthStatus.successLogin,
          token: auth.accessToken,
          user: auth.user,
        ),
      );
    } on Failure catch (failure) {
      emit(state.copyWith(status: AuthStatus.errorLogin, error: failure));
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorLogin,
          error: const ServerFailure("Login failed", ""),
        ),
      );
    }
  }

  Future<void> onRegister(Register event, Emitter<AuthState> emit) async {
    if (state.status == AuthStatus.loadingRegister) return;
    emit(
      state.copyWith(
        status: AuthStatus.loadingRegister,
        isLoadingRegister: true,
        clearError: true,
        clearSuccessMessage: true,
        clearPendingRegistration: true,
      ),
    );

    try {
      final result = await _registerUseCase(
        RegisterParams(
          fullname: event.userName,
          email: event.email,
          password: event.password,
        ),
      );
      emit(
        state.copyWith(
          status: AuthStatus.successRegister,
          isLoadingRegister: false,
          successMessage: result.message,
          resendSecondsRemaining: otpResendCountdownSeconds,
          pendingRegistration: PendingRegistrationData(
            fullname: event.userName,
            email: result.email,
            password: event.password,
          ),
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: AuthStatus.errorRegister,
          isLoadingRegister: false,
          error: failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorRegister,
          isLoadingRegister: false,
          error: const ServerFailure("Registration failed", ""),
        ),
      );
    }
  }

  Future<void> _onVerifyAccount(
    VerifyAccount event,
    Emitter<AuthState> emit,
  ) async {
    if (state.isVerifyAccountLoading == true ||
        state.pendingRegistration == null) {
      return;
    }
    final code = event.verificationCode.replaceAll(RegExp(r'\D'), '');
    if (code.length != 6) {
      emit(
        state.copyWith(
          status: AuthStatus.errorVerifyAccount,
          error: const ServerFailure('', 'OTP_INCOMPLETE'),
          clearSuccessMessage: true,
        ),
      );
      return;
    }

    final pending = state.pendingRegistration!;
    emit(
      state.copyWith(
        status: AuthStatus.loadingVerifyAccount,
        isVerifyAccountLoading: true,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );
    try {
      final auth = await _verifyOtpUseCase(
        VerifyOtpParams(
          fullname: pending.fullname,
          email: pending.email,
          password: pending.password,
          otpCode: code,
        ),
      );
      await _syncFcmTokenAfterAuth('OTP verification');
      _cancelOtpCountdown();
      forms.otpCode.clear();
      forms.registerPassword.clear();
      forms.registerConfirmPassword.clear();
      emit(
        state.copyWith(
          status: AuthStatus.successVerifyAccount,
          isVerifyAccountLoading: false,
          token: auth.accessToken,
          user: auth.user,
          successMessage: auth.message,
          resendSecondsRemaining: 0,
          clearPendingRegistration: true,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: AuthStatus.errorVerifyAccount,
          isVerifyAccountLoading: false,
          error: failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorVerifyAccount,
          isVerifyAccountLoading: false,
          error: const ServerFailure('OTP verification failed', ''),
        ),
      );
    }
  }

  Future<void> _onResendVerificationCode(
    RequestResendVerificationCode event,
    Emitter<AuthState> emit,
  ) async {
    if (!state.canResendOtp || state.pendingRegistration == null) return;
    final pending = state.pendingRegistration!;
    emit(
      state.copyWith(
        status: AuthStatus.loadingResendVerificationCode,
        isRequestResendVerificationCodeLoading: true,
        clearError: true,
        clearSuccessMessage: true,
      ),
    );
    try {
      final result = await _resendOtpUseCase(
        ResendOtpParams(fullname: pending.fullname, email: pending.email),
      );
      forms.otpCode.clear();
      _startOtpCountdown(otpResendCountdownSeconds);
      emit(
        state.copyWith(
          status: AuthStatus.successResendVerificationCode,
          isRequestResendVerificationCodeLoading: false,
          successMessage: result.message,
          resendSecondsRemaining: otpResendCountdownSeconds,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: AuthStatus.errorResendVerificationCode,
          isRequestResendVerificationCodeLoading: false,
          error: failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorResendVerificationCode,
          isRequestResendVerificationCodeLoading: false,
          error: const ServerFailure('Failed to resend verification code', ''),
        ),
      );
    }
  }

  void _onOtpChanged(OtpChanged event, Emitter<AuthState> emit) {
    if (state.status == AuthStatus.errorVerifyAccount || state.error != null) {
      emit(state.copyWith(clearError: true, clearSuccessMessage: true));
    }
  }

  void _onOtpCountdownStarted(
    OtpCountdownStarted event,
    Emitter<AuthState> emit,
  ) {
    final seconds = event.seconds < 0 ? 0 : event.seconds;
    _startOtpCountdown(seconds);
    emit(
      state.copyWith(
        status: state.status == AuthStatus.successRegister
            ? AuthStatus.initial
            : state.status,
        resendSecondsRemaining: seconds,
        clearSuccessMessage: state.status == AuthStatus.successRegister,
      ),
    );
  }

  void _onOtpCountdownTicked(
    OtpCountdownTicked event,
    Emitter<AuthState> emit,
  ) {
    final remaining = state.resendSecondsRemaining;
    final resetResendSuccess =
        state.status == AuthStatus.successResendVerificationCode;
    if (remaining <= 1) {
      _cancelOtpCountdown();
      emit(
        state.copyWith(
          status: resetResendSuccess ? AuthStatus.initial : state.status,
          resendSecondsRemaining: 0,
          clearSuccessMessage: resetResendSuccess,
        ),
      );
      return;
    }
    emit(
      state.copyWith(
        status: resetResendSuccess ? AuthStatus.initial : state.status,
        resendSecondsRemaining: remaining - 1,
        clearSuccessMessage: resetResendSuccess,
      ),
    );
  }

  void _onOtpFlowCancelled(OtpFlowCancelled event, Emitter<AuthState> emit) {
    if (state.status == AuthStatus.successVerifyAccount) return;
    _cancelOtpCountdown();
    forms.otpCode.clear();
    emit(
      state.copyWith(
        status: AuthStatus.initial,
        isVerifyAccountLoading: false,
        isRequestResendVerificationCodeLoading: false,
        resendSecondsRemaining: 0,
        clearError: true,
        clearSuccessMessage: true,
        clearPendingRegistration: true,
      ),
    );
  }

  void _onAuthMessagesCleared(
    AuthMessagesCleared event,
    Emitter<AuthState> emit,
  ) {
    if (state.error != null || state.successMessage != null) {
      emit(state.copyWith(clearError: true, clearSuccessMessage: true));
    }
  }

  void _onAuthStatusHandled(AuthStatusHandled event, Emitter<AuthState> emit) {
    emit(state.copyWith(status: AuthStatus.initial, clearSuccessMessage: true));
  }

  void _onAuthSessionCleared(
    AuthSessionCleared event,
    Emitter<AuthState> emit,
  ) {
    _cancelOtpCountdown();
    forms.clearSensitiveRegistrationData();
    emit(
      state.copyWith(
        status: AuthStatus.loggedOut,
        clearToken: true,
        clearUser: true,
        clearPendingRegistration: true,
        clearError: true,
        clearSuccessMessage: true,
        resendSecondsRemaining: 0,
      ),
    );
  }

  void _startOtpCountdown(int seconds) {
    _cancelOtpCountdown();
    if (seconds <= 0) return;
    _otpCountdownTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => add(const OtpCountdownTicked()),
    );
  }

  void _cancelOtpCountdown() {
    _otpCountdownTimer?.cancel();
    _otpCountdownTimer = null;
  }

  Future<void> _syncFcmTokenAfterAuth(String source) async {
    try {
      if (!GetIt.I.isRegistered<FirebaseApi>()) return;
      await GetIt.I<FirebaseApi>().syncFcmTokenWithBackend();
    } catch (_) {
      debugPrint('FCM sync after $source failed.');
    }
  }

  void onChangePasswordView(
    ChangePasswordView event,
    Emitter<AuthState> emit,
  ) async {
    if (event.currentTextFormField == 'login_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isPasswordVis: !state.isPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'old_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isOldPasswordVis: !state.isOldPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'new_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isNewPasswordVis: !state.isNewPasswordVis!,
        ),
      );
    } else if (event.currentTextFormField == 'confirm_password') {
      emit(
        state.copyWith(
          status: AuthStatus.changePassword,
          isConfirmPasswordVis: !state.isConfirmPasswordVis!,
        ),
      );
    }
  }

  Future<void> onSubmitChangePassword(
    SubmitChangePassword event,
    Emitter<AuthState> emit,
  ) async {
    if (event.oldPassword.isEmpty ||
        event.newPassword.isEmpty ||
        event.newPasswordConfirmation.isEmpty) {
      emit(
        state.copyWith(
          status: AuthStatus.errorChangePassword,
          changePasswordMessage: 'validation_required',
          clearError: true,
        ),
      );
      return;
    }

    if (event.newPassword.length < 8) {
      emit(
        state.copyWith(
          status: AuthStatus.errorChangePassword,
          changePasswordMessage: 'validation_password_short',
          clearError: true,
        ),
      );
      return;
    }

    if (event.newPassword != event.newPasswordConfirmation) {
      emit(
        state.copyWith(
          status: AuthStatus.errorChangePassword,
          changePasswordMessage: 'validation_passwords_no_match',
          clearError: true,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AuthStatus.loadingChangePassword,
        isChangingPassword: true,
        clearError: true,
        clearChangePasswordMessage: true,
      ),
    );

    try {
      final message = await _changePasswordUseCase(
        ChangePasswordParams(
          oldPassword: event.oldPassword,
          newPassword: event.newPassword,
          newPasswordConfirmation: event.newPasswordConfirmation,
        ),
      );
      forms.changeOldPassword.clear();
      forms.changeNewPassword.clear();
      forms.changeConfirmPassword.clear();
      emit(
        state.copyWith(
          status: AuthStatus.successChangePassword,
          isChangingPassword: false,
          changePasswordMessage: message,
        ),
      );
    } on Failure catch (failure) {
      emit(
        state.copyWith(
          status: AuthStatus.errorChangePassword,
          isChangingPassword: false,
          error: failure,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          status: AuthStatus.errorChangePassword,
          isChangingPassword: false,
          error: const ServerFailure("Password change failed", ""),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _cancelOtpCountdown();
    forms.dispose();
    return super.close();
  }
}
