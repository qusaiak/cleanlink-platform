import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/chat_action.dart';

class ChatActionView extends StatelessWidget {
  const ChatActionView({
    super.key,
    required this.action,
    required this.onSend,
    required this.onViewBooking,
    required this.onPay,
    this.isPaying = false,
  });

  final ChatAction action;
  final ValueChanged<String> onSend;
  final ValueChanged<int> onViewBooking;
  final ValueChanged<int> onPay;
  final bool isPaying;

  @override
  Widget build(BuildContext context) {
    if (action.summary case final ChatBookingSummary summary) {
      return _SummaryCard(action: action, summary: summary, onSend: onSend);
    }
    if (action.options.isNotEmpty) {
      final isArabic = Localizations.localeOf(context).languageCode == 'ar';
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.sizeOf(context).width * .86,
          ),
          margin: EdgeInsets.only(bottom: 12.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (action.electronicPaymentWarning) ...[
                const _ElectronicPaymentNotice(),
                SizedBox(height: 10.h),
              ],
              Wrap(
                spacing: 8.w,
                runSpacing: 8.h,
                children: action.options
                    .map(
                      (option) => ActionChip(
                        label: Text(option.localizedLabel(isArabic)),
                        onPressed: () =>
                            onSend(option.localizedMessage(isArabic)),
                      ),
                    )
                    .toList(growable: false),
              ),
            ],
          ),
        ),
      );
    }
    if (action.isBookingResult && action.orderId != null) {
      final orderId = action.orderId!;
      final l = AppLocalizations.of(context)!;
      return Align(
        alignment: AlignmentDirectional.centerStart,
        child: Card(
          margin: EdgeInsets.only(bottom: 12.h),
          child: Padding(
            padding: EdgeInsets.all(14.r),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  action.requiresPayment
                      ? l.chat_payment_pending
                      : l.chat_booking_created,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                SizedBox(height: 10.h),
                if (action.electronicPaymentWarning) ...[
                  const _ElectronicPaymentNotice(),
                  SizedBox(height: 10.h),
                ],
                if (action.requiresPayment)
                  FilledButton.icon(
                    onPressed: isPaying ? null : () => onPay(orderId),
                    icon: isPaying
                        ? SizedBox.square(
                            dimension: 16.r,
                            child: const CircularProgressIndicator(
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.credit_card_rounded),
                    label: Text(l.pay_now),
                  ),
                OutlinedButton(
                  onPressed: () => onViewBooking(orderId),
                  child: Text(l.chat_view_booking),
                ),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.action,
    required this.summary,
    required this.onSend,
  });
  final ChatAction action;
  final ChatBookingSummary summary;
  final ValueChanged<String> onSend;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    final payment = summary.paymentMethod == 'card' ? l.card : l.cash;
    final rows = <(String, String)>[
      (l.company_label, summary.company.resolve(isArabic)),
      (l.detail_service, summary.service.resolve(isArabic)),
      (l.package_label, summary.package.resolve(isArabic)),
      (l.location, summary.locationName),
      (l.detail_address, summary.address),
      (l.detail_date, summary.date),
      (l.detail_time, summary.time),
      (l.detail_duration, '${summary.durationMinutes} ${l.minutes}'),
      (l.payment_method, payment),
      (
        l.note,
        summary.note?.isNotEmpty == true ? summary.note! : l.chat_no_note,
      ),
      (l.total_price, '${summary.total} ${summary.currency}'),
    ];
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Card(
        margin: EdgeInsets.only(bottom: 12.h),
        child: Padding(
          padding: EdgeInsets.all(16.r),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.chat_booking_summary,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              SizedBox(height: 12.h),
              for (final row in rows)
                Padding(
                  padding: EdgeInsets.only(bottom: 7.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 112.w,
                        child: Text(
                          row.$1,
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ),
                      Expanded(child: Text(row.$2)),
                    ],
                  ),
                ),
              if (summary.paymentMethod == 'card') ...[
                SizedBox(height: 4.h),
                const _ElectronicPaymentNotice(),
              ],
              SizedBox(height: 6.h),
              FilledButton(
                onPressed: () =>
                    onSend(action.confirmMessage ?? 'Confirm booking'),
                child: Text(l.confirm_booking),
              ),
              OutlinedButton(
                onPressed: () =>
                    onSend(action.changeMessage ?? 'Change booking details'),
                child: Text(l.chat_change_details),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ElectronicPaymentNotice extends StatelessWidget {
  const _ElectronicPaymentNotice();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;
    return Container(
      padding: EdgeInsets.all(10.r),
      decoration: BoxDecoration(
        color: colors.tertiaryContainer,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.schedule_rounded,
            size: 19.r,
            color: colors.onTertiaryContainer,
          ),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              l.electronic_payment_expiry_notice,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colors.onTertiaryContainer,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
