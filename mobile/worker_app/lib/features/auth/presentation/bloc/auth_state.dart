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
  final bool? isLoadingLogin;
  final bool? isLoadingRegister;
  final bool? isVerifyAccountLoading;
  final bool? isRequestResendVerificationCodeLoading;
  final bool? isPasswordVis;
  final bool? isOldPasswordVis;
  final bool? isNewPasswordVis;
  final bool? isConfirmPasswordVis;
  final Failure? error;

  const AuthState({
    this.status,
    this.token,
    this.isLoadingLogin,
    this.isLoadingRegister,
    this.isVerifyAccountLoading,
    this.isRequestResendVerificationCodeLoading,
    this.isPasswordVis,
    this.isOldPasswordVis,
    this.isNewPasswordVis,
    this.isConfirmPasswordVis,
    this.error,
  });

  AuthState copyWith({
    AuthStatus? status,
    String? token,
    bool? isLoadingLogin,
    bool? isLoadingRegister,
    bool? isVerifyAccountLoading,
    bool? isRequestResendVerificationCodeLoading,
    bool? isPasswordVis,
    bool? isOldPasswordVis,
    bool? isNewPasswordVis,
    bool? isConfirmPasswordVis,
    Failure? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
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
      // Transient — an error belongs to the emit that produced it and is
      // cleared on every following emit (same convention as
      // [WorkerProfileState]). `error ?? this.error` made it impossible to
      // clear: the loading state of a RETRY still carried the previous
      // failure, and so did the eventual success state.
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    status,
    token,
    isLoadingLogin,
    isLoadingRegister,
    isVerifyAccountLoading,
    isRequestResendVerificationCodeLoading,
    isPasswordVis,
    isOldPasswordVis,
    isNewPasswordVis,
    isConfirmPasswordVis,
    error,
  ];
}
