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
  final String gsm;

  const RequestResendVerificationCode(this.gsm);

  @override
  List<Object> get props => [gsm];
}

class VerifyAccount extends AuthEvent {
  final String gsm;
  final String verificationCode;

  const VerifyAccount(this.gsm, this.verificationCode);

  @override
  List<Object> get props => [gsm, verificationCode];
}

class ChangePasswordView extends AuthEvent {
  final String currentTextFormField;
  const ChangePasswordView(this.currentTextFormField);
  @override
  List<Object> get props => [currentTextFormField];
}
