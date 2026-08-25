import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/payment_entities.dart';
import '../bloc/payment_history_bloc.dart';

class PaymentHistoryPage extends StatefulWidget {
  const PaymentHistoryPage({super.key});

  @override
  State<PaymentHistoryPage> createState() => _PaymentHistoryPageState();
}

class _PaymentHistoryPageState extends State<PaymentHistoryPage> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    context.read<PaymentHistoryBloc>().add(const LoadPaymentHistory());
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 240) {
      context.read<PaymentHistoryBloc>().add(const LoadMorePayments());
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: customAppBar(
        l.payment_history,
        null,
        const [],
        () => context.pop(),
        colors.onSurface,
      ),
      body: BlocBuilder<PaymentHistoryBloc, PaymentHistoryState>(
        builder: (context, state) {
          return Column(
            children: [
              _Filters(state: state),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    final bloc = context.read<PaymentHistoryBloc>()
                      ..add(const LoadPaymentHistory());
                    await bloc.stream.firstWhere((value) => !value.isLoading);
                  },
                  child: _body(context, state),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _body(BuildContext context, PaymentHistoryState state) {
    final l = AppLocalizations.of(context)!;
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (state.errorMessage != null && state.payments.isEmpty) {
      return ListView(
        children: [
          AppEmptyState(
            icon: Icons.error_outline,
            title: l.payment_failed,
            body: state.errorMessage,
            action: FilledButton(
              onPressed: () => context.read<PaymentHistoryBloc>().add(
                const LoadPaymentHistory(),
              ),
              child: Text(l.try_again),
            ),
          ),
        ],
      );
    }
    if (state.payments.isEmpty) {
      return ListView(
        children: [
          AppEmptyState(
            icon: Icons.receipt_long_outlined,
            title: l.no_payments,
            body: l.no_payments_message,
          ),
        ],
      );
    }
    return ListView.separated(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
      itemCount: state.payments.length + (state.isLoadingMore ? 1 : 0),
      separatorBuilder: (_, _) => SizedBox(height: 10.h),
      itemBuilder: (context, index) {
        if (index == state.payments.length) {
          return const Center(child: CircularProgressIndicator());
        }
        return _PaymentCard(payment: state.payments[index]);
      },
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.state});
  final PaymentHistoryState state;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final hasFilters =
        state.statusFilter != null || state.paymentMethodFilter != null;
    return SizedBox(
      height: 48.h,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.fromLTRB(16.w, 5.h, 16.w, 4.h),
        children: [
          _FilterMenu(
            icon: Icons.tune_rounded,
            title: l.payment_status,
            selectedValue: state.statusFilter,
            options: [
              (value: '', label: l.all),
              (value: 'pending', label: l.payment_status_pending),
              (value: 'held', label: l.payment_status_held),
              (value: 'captured', label: l.payment_status_captured),
              (value: 'refunded', label: l.payment_status_refunded),
              (value: 'failed', label: l.payment_status_failed),
            ],
            onSelected: (value) => context.read<PaymentHistoryBloc>().add(
              ChangePaymentHistoryFilters(
                status: value.isEmpty ? null : value,
                paymentMethod: state.paymentMethodFilter,
              ),
            ),
          ),
          SizedBox(width: 8.w),
          _FilterMenu(
            icon: Icons.account_balance_wallet_outlined,
            title: l.payment_method,
            selectedValue: state.paymentMethodFilter,
            options: [
              (value: '', label: l.all),
              (value: 'cash', label: l.cash),
              (value: 'card', label: l.card),
            ],
            onSelected: (value) => context.read<PaymentHistoryBloc>().add(
              ChangePaymentHistoryFilters(
                status: state.statusFilter,
                paymentMethod: value.isEmpty ? null : value,
              ),
            ),
          ),
          if (hasFilters) ...[
            SizedBox(width: 8.w),
            Tooltip(
              message: l.search_clear_filters,
              child: Material(
                color: colors.errorContainer.withValues(alpha: .65),
                borderRadius: BorderRadius.circular(999),
                child: InkWell(
                  borderRadius: BorderRadius.circular(999),
                  onTap: () => context.read<PaymentHistoryBloc>().add(
                    const ChangePaymentHistoryFilters(),
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Icon(
                      Icons.filter_alt_off_rounded,
                      size: 19.r,
                      color: colors.onErrorContainer,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _FilterMenu extends StatelessWidget {
  const _FilterMenu({
    required this.icon,
    required this.title,
    required this.selectedValue,
    required this.options,
    required this.onSelected,
  });

  final IconData icon;
  final String title;
  final String? selectedValue;
  final List<({String value, String label})> options;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final selectedLabel = options
        .where((option) => option.value == (selectedValue ?? ''))
        .map((option) => option.label)
        .firstOrNull;
    final active = selectedValue != null;
    return PopupMenuButton<String>(
      tooltip: title,
      initialValue: selectedValue ?? '',
      onSelected: onSelected,
      position: PopupMenuPosition.under,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      itemBuilder: (context) => options
          .map(
            (option) => PopupMenuItem<String>(
              value: option.value,
              child: Row(
                children: [
                  Icon(
                    option.value == (selectedValue ?? '')
                        ? Icons.check_circle_rounded
                        : Icons.circle_outlined,
                    size: 18.r,
                    color: option.value == (selectedValue ?? '')
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  SizedBox(width: 10.w),
                  Flexible(child: Text(option.label)),
                ],
              ),
            ),
          )
          .toList(growable: false),
      child: Container(
        constraints: BoxConstraints(maxWidth: 190.w),
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
        decoration: BoxDecoration(
          color: active ? colors.primaryContainer : colors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(999),
          border: Border.all(
            color: active ? colors.primary : colors.outlineVariant,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16.r,
              color: active ? colors.primary : colors.onSurfaceVariant,
            ),
            SizedBox(width: 5.w),
            Flexible(
              child: Text(
                active ? selectedLabel ?? title : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w600,
                  color: active ? colors.onPrimaryContainer : colors.onSurface,
                ),
              ),
            ),
            SizedBox(width: 3.w),
            Icon(Icons.keyboard_arrow_down_rounded, size: 16.r),
          ],
        ),
      ),
    );
  }
}

class _PaymentCard extends StatelessWidget {
  const _PaymentCard({required this.payment});
  final ClientPaymentEntity payment;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final serviceName = _localizedName(
      context,
      direct: payment.serviceName,
      ar: payment.serviceNameAr,
      en: payment.serviceNameEn,
    );
    final packageName = _localizedName(
      context,
      direct: payment.packageName,
      ar: payment.packageNameAr,
      en: payment.packageNameEn,
    );
    final companyName = _localizedName(
      context,
      direct: payment.companyName,
      ar: payment.companyNameAr,
      en: payment.companyNameEn,
    );
    final date = payment.createdAt == null
        ? '—'
        : DateFormat.yMMMd(
            Localizations.localeOf(context).languageCode,
          ).format(payment.createdAt!.toLocal());
    return Card(
      elevation: 0,
      color: colors.surfaceContainerLow,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
        side: BorderSide(color: colors.outlineVariant.withValues(alpha: .45)),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 44.r,
                  height: 44.r,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        colors.primary,
                        colors.primary.withValues(alpha: .72),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    color: colors.onPrimary,
                    size: 23.r,
                  ),
                ),
                SizedBox(width: 11.w),
                Expanded(
                  child: Text(
                    '\$${payment.amount.toStringAsFixed(2)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: colors.primary,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                SizedBox(width: 8.w),
                _StatusChip(status: payment.paymentStatus),
              ],
            ),
            SizedBox(height: 15.h),
            _CardDetail(
              icon: Icons.cleaning_services_outlined,
              label: l.detail_service,
              value: serviceName ?? '—',
            ),
            SizedBox(height: 9.h),
            _CardDetail(
              icon: Icons.inventory_2_outlined,
              label: l.package_label,
              value: packageName ?? '—',
            ),
            if (companyName != null) ...[
              SizedBox(height: 9.h),
              _CardDetail(
                icon: Icons.business_outlined,
                label: l.company_label,
                value: companyName,
              ),
            ],
            SizedBox(height: 12.h),
            Divider(
              height: 1,
              color: colors.outlineVariant.withValues(alpha: .5),
            ),
            SizedBox(height: 12.h),
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                _MetaPill(
                  icon: payment.isCard
                      ? Icons.credit_card_rounded
                      : Icons.payments_outlined,
                  label: payment.isCard ? l.card : l.cash,
                ),
                _MetaPill(icon: Icons.calendar_today_outlined, label: date),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

String? _localizedName(
  BuildContext context, {
  String? direct,
  String? ar,
  String? en,
}) {
  String? usable(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }

  final language = Localizations.localeOf(context).languageCode;
  return usable(direct) ??
      (language == 'ar' ? usable(ar) ?? usable(en) : usable(en) ?? usable(ar));
}

class _CardDetail extends StatelessWidget {
  const _CardDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17.r, color: colors.primary),
        SizedBox(width: 8.w),
        SizedBox(
          width: 68.w,
          child: Text(
            label,
            style: TextStyle(fontSize: 11.sp, color: colors.onSurfaceVariant),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}

class _MetaPill extends StatelessWidget {
  const _MetaPill({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      constraints: BoxConstraints(maxWidth: 240.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 7.h),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: .7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15.r, color: colors.onSurfaceVariant),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11.sp, color: colors.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});
  final PaymentStatusType status;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final label = switch (status) {
      PaymentStatusType.pending => l.payment_status_pending,
      PaymentStatusType.held => l.payment_status_held,
      PaymentStatusType.captured => l.payment_status_captured,
      PaymentStatusType.refunded => l.payment_status_refunded,
      PaymentStatusType.failed => l.payment_status_failed,
    };
    final color = switch (status) {
      PaymentStatusType.captured => Colors.green,
      PaymentStatusType.held => Colors.blue,
      PaymentStatusType.failed || PaymentStatusType.refunded => Colors.red,
      PaymentStatusType.pending => Colors.orange,
    };
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: .12),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontSize: 11.sp),
      ),
    );
  }
}
