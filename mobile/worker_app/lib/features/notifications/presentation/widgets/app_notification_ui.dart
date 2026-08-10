import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../domain/entities/app_notification.dart';

/// Presentation metadata for an [AppNotificationType]: the icon + accent colour
/// used by the tile. Colours come from the project palette — not literal design
/// colours.
class AppNotificationUi {
  final IconData icon;
  final Color color;

  const AppNotificationUi({required this.icon, required this.color});

  factory AppNotificationUi.of(AppNotificationType type) {
    switch (type) {
      case AppNotificationType.clientRequest:
        return const AppNotificationUi(
          icon: Icons.handshake_rounded,
          color: AppColor.primaryColor,
        );
      case AppNotificationType.taskAssigned:
        return const AppNotificationUi(
          icon: Icons.assignment_turned_in_rounded,
          color: AppColor.successColor,
        );
      case AppNotificationType.taskReminder:
        return const AppNotificationUi(
          icon: Icons.alarm_rounded,
          color: AppColor.warningColor,
        );
      case AppNotificationType.general:
        return const AppNotificationUi(
          icon: Icons.notifications_rounded,
          color: AppColor.infoColor,
        );
    }
  }
}
