import 'package:equatable/equatable.dart';

class OtpDispatchEntity extends Equatable {
  final int status;
  final String message;
  final String email;

  const OtpDispatchEntity({
    required this.status,
    required this.message,
    required this.email,
  });

  @override
  List<Object?> get props => [status, message, email];
}
