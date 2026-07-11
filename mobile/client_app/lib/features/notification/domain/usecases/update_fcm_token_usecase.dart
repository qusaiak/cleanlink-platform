import 'package:equatable/equatable.dart';

import '../repositories/notification_repo.dart';

class UpdateFcmTokenUseCase {
  final NotificationsRepository repo;

  const UpdateFcmTokenUseCase(this.repo);

  Future<void> call(UpdateFcmTokenParams params) {
    return repo.updateFcmToken(
      fcmToken: params.fcmToken,
      deviceType: params.deviceType,
      lang: params.lang,
    );
  }
}

class UpdateFcmTokenParams extends Equatable {
  final String fcmToken;
  final String deviceType;
  final String lang;

  const UpdateFcmTokenParams({
    required this.fcmToken,
    required this.deviceType,
    required this.lang,
  });

  @override
  List<Object?> get props => [fcmToken, deviceType, lang];
}
