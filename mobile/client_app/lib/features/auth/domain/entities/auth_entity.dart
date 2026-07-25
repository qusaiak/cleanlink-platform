import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class AuthEntity extends Equatable {
  final UserEntity user;
  final String accessToken;
  final int? status;
  final String? message;

  const AuthEntity({
    required this.user,
    required this.accessToken,
    this.status,
    this.message,
  });

  @override
  List<Object?> get props => [user, accessToken, status, message];
}
