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
    this.error,
  });

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
    Failure? error,
  }) {
    return AuthState(
      status: status ?? this.status,
      token: token ?? this.token,
      user: user ?? this.user,
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
      error: error ?? this.error,
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
    error,
  ];
}
