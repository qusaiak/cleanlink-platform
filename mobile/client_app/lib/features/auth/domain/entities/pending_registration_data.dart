import 'package:equatable/equatable.dart';

class PendingRegistrationData extends Equatable {
  final String fullname;
  final String email;
  final String password;

  const PendingRegistrationData({
    required this.fullname,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [fullname, email, password];
}
