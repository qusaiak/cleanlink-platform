import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';

class WorkerAvailabilityUi {
  final String label;
  final Color color;

  const WorkerAvailabilityUi({required this.label, required this.color});

  factory WorkerAvailabilityUi.of(
    BuildContext context,
    WorkerAvailability availability,
  ) {
    final l = AppLocalizations.of(context)!;
    switch (availability) {
      case WorkerAvailability.available:
        return WorkerAvailabilityUi(
          label: l.availability_available,
          color: AppColor.successColor,
        );
      case WorkerAvailability.busy:
        return WorkerAvailabilityUi(
          label: l.availability_busy,
          color: AppColor.warningColor,
        );
      case WorkerAvailability.off:
        return WorkerAvailabilityUi(
          label: l.availability_off,
          color: AppColor.gray500,
        );
    }
  }
}
