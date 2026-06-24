import 'package:equatable/equatable.dart';

import 'user_entity.dart';

class AuthEntity extends Equatable {
  final UserEntity user;
  final String accessToken;

  const AuthEntity({
    required this.user,
    required this.accessToken,
  });

  @override
  List<Object?> get props => [user, accessToken];
}
