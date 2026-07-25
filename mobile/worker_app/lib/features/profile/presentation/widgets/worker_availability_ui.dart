import 'package:flutter/material.dart';

import '../../../../config/theme/colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/worker_profile.dart';

/// Presentation metadata for a [WorkerAvailability]: localized [label] + the
/// indicator [color]. Colours come from the project palette
/// (success / warning / grey) — not the design's literal colours.
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
      case WorkerAvailability.offline:
        return WorkerAvailabilityUi(
          label: l.availability_offline,
          color: AppColor.gray500,
        );
    }
  }
}
