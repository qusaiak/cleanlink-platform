import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking_entity.dart';

class BookingStatusBadge extends StatelessWidget {
  final String status;
  final Color? color;

  const BookingStatusBadge({super.key, required this.status, this.color});

  String _label(AppLocalizations l10n, OrderStatus statusType) {
    switch (statusType) {
      case OrderStatus.pending:
        return l10n.pending;
      case OrderStatus.assignedToWorker:
        return l10n.assigned;
      case OrderStatus.inProgress:
        return l10n.in_process;
      case OrderStatus.completed:
        return l10n.completed;
      case OrderStatus.canceled:
        return l10n.canceled;
      case OrderStatus.unknown:
        return l10n.unknown_status;
    }
  }

  Color _color(OrderStatus statusType) {
    switch (statusType) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.assignedToWorker:
        return AppColor.primaryColor;
      case OrderStatus.inProgress:
        return Colors.purple;
      case OrderStatus.completed:
        return AppColor.success;
      case OrderStatus.canceled:
        return AppColor.error;
      case OrderStatus.unknown:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final statusType = orderStatusFromApi(status);
    final badgeColor = color ?? _color(statusType);
    final label = statusType == OrderStatus.unknown
        ? formatUnknownOrderStatus(status)
        : _label(l10n, statusType);

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label.toUpperCase(),
        style: Styles.textStyle11.copyWith(
          color: badgeColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
