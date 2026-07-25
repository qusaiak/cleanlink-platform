part of 'auth_bloc.dart';

enum AuthStatus {
  initial,
  loadingLogin,
  successLogin,
  errorLogin,
  loadingRegister,
  successRegister,
  errorRegister,
  loadingVerifyAccount,
  successVerifyAccount,
  errorVerifyAccount,
  loadingResendVerificationCode,
  successResendVerificationCode,
  errorResendVerificationCode,
  noInternet,
  loggedOut,
  changePassword,
  loadingChangePassword,
  successChangePassword,
  errorChangePassword,
}

class AuthState extends Equatable {
  final AuthStatus? status;
  final String? token;
  final UserEntity? user;
  final bool? isLoadingLogin;
  final bool? isLoadingRegister;
  final bool? isVerifyAccountLoading;
  final bool? isRequestResendVerificationCodeLoading;
  final bool? isPasswordVis;
  final bool? isOldPasswordVis;
  final bool? isNewPasswordVis;
  final bool? isConfirmPasswordVis;
  final bool isChangingPassword;
  final String? changePasswordMessage;
  final String? successMessage;
  final PendingRegistrationData? pendingRegistration;
  final int resendSecondsRemaining;
  final Failure? error;

  const AuthState({
    this.status,
    this.token,
    this.user,
    this.isLoadingLogin,
    this.isLoadingRegister,
    this.isVerifyAccountLoading,
    this.isRequestResendVerificationCodeLoading,
    this.isPasswordVis,
    this.isOldPasswordVis,
    this.isNewPasswordVis,
    this.isConfirmPasswordVis,
    this.isChangingPassword = false,
    this.changePasswordMessage,
    this.successMessage,
    this.pendingRegistration,
    this.resendSecondsRemaining = 0,
    this.error,
  });

  bool get canResendOtp =>
      resendSecondsRemaining == 0 &&
      isRequestResendVerificationCodeLoading != true;

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    UserEntity? user,
    bool? isLoadingLogin,
    bool? isLoadingRegister,
    bool? isVerifyAccountLoading,
    bool? isRequestResendVerificationCodeLoading,
    bool? isPasswordVis,
    bool? isOldPasswordVis,
    bool? isNewPasswordVis,
    bool? isConfirmPasswordVis,
    bool? isChangingPassword,
    String? changePasswordMessage,
    String? successMessage,
    PendingRegistrationData? pendingRegistration,
    int? resendSecondsRemaining,
    Failure? error,
    bool clearError = false,
    bool clearChangePasswordMessage = false,
    bool clearSuccessMessage = false,
    bool clearPendingRegistration = false,
    bool clearToken = false,
    bool clearUser = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: clearToken ? null : token ?? this.token,
      user: clearUser ? null : user ?? this.user,
      isLoadingLogin: isLoadingLogin ?? this.isLoadingLogin,
      isLoadingRegister: isLoadingRegister ?? this.isLoadingRegister,
      isVerifyAccountLoading:
          isVerifyAccountLoading ?? this.isVerifyAccountLoading,
      isRequestResendVerificationCodeLoading:
          isRequestResendVerificationCodeLoading ??
          this.isRequestResendVerificationCodeLoading,
      isPasswordVis: isPasswordVis ?? this.isPasswordVis,
      isOldPasswordVis: isOldPasswordVis ?? this.isOldPasswordVis,
      isNewPasswordVis: isNewPasswordVis ?? this.isNewPasswordVis,
      isConfirmPasswordVis: isConfirmPasswordVis ?? this.isConfirmPasswordVis,
      isChangingPassword: isChangingPassword ?? this.isChangingPassword,
      changePasswordMessage: clearChangePasswordMessage
          ? null
          : changePasswordMessage ?? this.changePasswordMessage,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
      pendingRegistration: clearPendingRegistration
          ? null
          : pendingRegistration ?? this.pendingRegistration,
      resendSecondsRemaining:
          resendSecondsRemaining ?? this.resendSecondsRemaining,
      error: clearError ? null : error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    token,
    user,
    isLoadingLogin,
    isLoadingRegister,
    isVerifyAccountLoading,
    isRequestResendVerificationCodeLoading,
    isPasswordVis,
    isOldPasswordVis,
    isNewPasswordVis,
    isConfirmPasswordVis,
    isChangingPassword,
    changePasswordMessage,
    successMessage,
    pendingRegistration,
    resendSecondsRemaining,
    error,
  ];
}
