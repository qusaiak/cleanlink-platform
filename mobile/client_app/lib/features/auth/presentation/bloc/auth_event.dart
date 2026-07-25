part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class Login extends AuthEvent {
  final String email;
  final String password;

  const Login(this.email, this.password);

  @override
  List<Object> get props => [email, password];
}

class Register extends AuthEvent {
  final String userName;
  final String email;
  final String password;

  const Register(this.userName, this.email, this.password);

  @override
  List<Object> get props => [userName, email, password];
}

class RequestResendVerificationCode extends AuthEvent {
  const RequestResendVerificationCode();

  @override
  List<Object> get props => [];
}

class VerifyAccount extends AuthEvent {
  final String verificationCode;

  const VerifyAccount(this.verificationCode);

  @override
  List<Object> get props => [verificationCode];
}

class OtpChanged extends AuthEvent {
  final String code;

  const OtpChanged(this.code);

  @override
  List<Object> get props => [code];
}

class OtpCountdownStarted extends AuthEvent {
  final int seconds;

  const OtpCountdownStarted({this.seconds = 60});

  @override
  List<Object> get props => [seconds];
}

class OtpCountdownTicked extends AuthEvent {
  const OtpCountdownTicked();

  @override
  List<Object> get props => [];
}

class OtpFlowCancelled extends AuthEvent {
  const OtpFlowCancelled();

  @override
  List<Object> get props => [];
}

class AuthMessagesCleared extends AuthEvent {
  const AuthMessagesCleared();

  @override
  List<Object> get props => [];
}

class AuthStatusHandled extends AuthEvent {
  const AuthStatusHandled();

  @override
  List<Object> get props => [];
}

class AuthSessionCleared extends AuthEvent {
  const AuthSessionCleared();

  @override
  List<Object> get props => [];
}

class ChangePasswordView extends AuthEvent {
  final String currentTextFormField;
  const ChangePasswordView(this.currentTextFormField);
  @override
  List<Object> get props => [currentTextFormField];
}

class SubmitChangePassword extends AuthEvent {
  final String oldPassword;
  final String newPassword;
  final String newPasswordConfirmation;

  const SubmitChangePassword({
    required this.oldPassword,
    required this.newPassword,
    required this.newPasswordConfirmation,
  });

  @override
  List<Object> get props => [oldPassword, newPassword, newPasswordConfirmation];
}
