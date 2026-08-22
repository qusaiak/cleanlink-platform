import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/utils/functions/spinkit.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../core/widgets/custom_image_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/booking_entity.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_status_badge.dart';
import '../../../payments/presentation/bloc/payments_bloc.dart';

class OrderDetailsPage extends StatefulWidget {
  final int orderId;
  const OrderDetailsPage({super.key, required this.orderId});

  @override
  State<OrderDetailsPage> createState() => _OrderDetailsPageState();
}

class _OrderDetailsPageState extends State<OrderDetailsPage> {
  @override
  void initState() {
    super.initState();
    final payments = context.read<PaymentsBloc>();
    if (payments.state.orderId != widget.orderId) {
      payments.add(const ResetPaymentState());
    }
    context.read<BookingsBloc>().add(ShowOrderEvent(widget.orderId));
  }

  void _startPayment() {
    final payments = context.read<PaymentsBloc>();
    if (payments.state.isBusy) return;
    payments.add(
      PayForOrder(
        orderId: widget.orderId,
        darkMode: Theme.of(context).brightness == Brightness.dark,
      ),
    );
  }

  String _paymentMethodLabel(OrderEntity order) {
    final l10n = AppLocalizations.of(context)!;
    return switch (order.paymentMethodNormalized) {
      'cash' || 'manual' => l10n.cash,
      'electric' => l10n.electronic_payment,
      _ => order.paymentMethod ?? '—',
    };
  }

  String _paymentStatusLabel(OrderEntity order) {
    final l10n = AppLocalizations.of(context)!;
    return switch (order.paymentStatusNormalized) {
      'pending' => l10n.pending_payment,
      'held' => l10n.payment_authorized,
      'paid' || 'captured' => l10n.paid,
      'refunded' => l10n.refunded,
      'failed' => l10n.payment_failed,
      _ => order.paymentStatus ?? '—',
    };
  }

  String _attributeValue(OrderAttributeEntity attribute) {
    final type = attribute.type.trim().toLowerCase();
    if (type == 'boolean' || type == 'bool') {
      return (attribute.qty ?? 0) > 0
          ? AppLocalizations.of(context)!.yes
          : AppLocalizations.of(context)!.no;
    }
    return '${attribute.qty ?? 0}';
  }

  Future<void> _confirmCancel() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(l10n.cancel_order),
        content: Text(l10n.cancel_order_confirmation),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.no),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<BookingsBloc>().add(CancelOrderEvent(widget.orderId));
    }
  }

  String _date(BuildContext context, DateTime? value) => value == null
      ? '—'
      : DateFormat(
          'MMM d, y - h:mm a',
          Localizations.localeOf(context).languageCode,
        ).format(value.toLocal());

  Future<void> _callLeader(String phoneNumber) async {
    final cleanedPhone = phoneNumber.trim();

    if (cleanedPhone.isEmpty) {
      AppSnackBar.showError(
        context: context,
        title: AppLocalizations.of(context)!.error,
        message: AppLocalizations.of(context)!.could_not_open_phone,
      );
      return;
    }

    final uri = Uri(scheme: 'tel', path: cleanedPhone);

    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched && mounted) {
        AppSnackBar.showError(
          context: context,
          title: AppLocalizations.of(context)!.error,
          message: AppLocalizations.of(context)!.could_not_open_phone,
        );
      }
    } catch (_) {
      if (!mounted) return;

      AppSnackBar.showError(
        context: context,
        title: AppLocalizations.of(context)!.error,
        message: AppLocalizations.of(context)!.could_not_open_phone,
      );
    }
  }

  Widget _leaderCard(OrderLeaderEntity leader) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final phone = leader.phone?.trim() ?? '';
    final hasPhone = phone.isNotEmpty;

    return Container(
      margin: EdgeInsets.only(top: 16.h, bottom: 4.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colors.primary),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.team_leader,
            style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
          ),

          SizedBox(height: 12.h),

          Row(
            children: [
              CustomImageView(
                imagePath: leader.image!,
                width: 50.w,
                height: 50.w,
                fit: BoxFit.cover,
                radius: BorderRadius.all(Radius.circular(50.r)),
              ),

              SizedBox(width: 12.w),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      leader.fullname.isEmpty ? '—' : leader.fullname,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Styles.textStyle14.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colors.onSurface,
                      ),
                    ),

                    SizedBox(height: 4.h),

                    if (hasPhone)
                      InkWell(
                        onTap: () => _callLeader(phone),
                        borderRadius: BorderRadius.circular(8.r),
                        child: Text(
                          phone,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Styles.textStyle12.copyWith(
                            color: colors.primary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    else
                      Text(
                        '—',
                        style: Styles.textStyle12.copyWith(
                          color: colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),

              if (hasPhone)
                IconButton(
                  tooltip: l10n.call,
                  onPressed: () => _callLeader(phone),
                  icon: Icon(
                    Icons.call_outlined,
                    color: colors.primary,
                    size: 22.sp,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(IconData icon, String label, String value) => Padding(
    padding: EdgeInsets.symmetric(vertical: 7.h),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20.sp),
        SizedBox(width: 10.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Styles.textStyle11),
              Text(
                value.isEmpty ? '—' : value,
                style: Styles.textStyle14.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    ),
  );
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return BlocListener<PaymentsBloc, PaymentsState>(
      listenWhen: (previous, current) => previous.stage != current.stage,
      listener: (context, paymentState) {
        final l10n = AppLocalizations.of(context)!;
        if (paymentState.stage == PaymentStage.succeeded) {
          AppSnackBar.showSuccess(
            context: context,
            title: l10n.success,
            message: l10n.payment_confirmed,
          );
        } else if (paymentState.stage == PaymentStage.pendingConfirmation) {
          AppSnackBar.showWarning(
            context: context,
            title: l10n.payment_processing,
            message: l10n.payment_processing_message,
          );
        } else if (paymentState.stage == PaymentStage.cancelled) {
          AppSnackBar.showWarning(
            context: context,
            title: l10n.payment_cancelled,
            message: l10n.payment_cancelled_message,
          );
        } else if (paymentState.stage == PaymentStage.failed) {
          AppSnackBar.showError(
            context: context,
            title: l10n.payment_failed,
            message: paymentState.errorMessage?.trim().isNotEmpty == true
                ? paymentState.errorMessage!
                : l10n.payment_failed_message,
          );
        }
        if (paymentState.stage == PaymentStage.succeeded ||
            paymentState.stage == PaymentStage.pendingConfirmation ||
            paymentState.stage == PaymentStage.cancelled ||
            paymentState.stage == PaymentStage.failed) {
          context.read<BookingsBloc>().add(ShowOrderEvent(widget.orderId));
        }
      },
      child: BlocConsumer<BookingsBloc, BookingsState>(
        listenWhen: (a, b) =>
            a.cancelSuccess != b.cancelSuccess ||
            a.errorMessage != b.errorMessage,
        listener: (context, state) {
          final message = state.cancelSuccess
              ? l10n.order_canceled_successfully
              : state.errorMessage;
          if (message != null) {
            if (state.cancelSuccess) {
              AppSnackBar.showSuccess(
                context: context,
                title: l10n.success,
                message: message,
              );
            } else {
              AppSnackBar.showError(
                context: context,
                title: l10n.error,
                message: message,
              );
            }
          }
        },
        builder: (context, state) {
          final order = state.selectedOrder;
          final paymentState = context.watch<PaymentsBloc>().state;
          Color accent() {
            switch (order?.statusType) {
              case OrderStatus.pending:
                return Colors.orange;
              case OrderStatus.assigned:
                return AppColor.primaryColor;
              case OrderStatus.onTheWay:
                return Colors.blue;
              case OrderStatus.inProcess:
                return Colors.purple;
              case OrderStatus.completed:
                return AppColor.success;
              case OrderStatus.canceled:
                return AppColor.error;
              case OrderStatus.unknown:
              case null:
                return Colors.grey;
            }
          }

          return Scaffold(
            appBar: customAppBar(
              l10n.order_details,
              null,
              const [],
              () => Navigator.maybePop(context),
              colors.onSurface,
            ),
            bottomNavigationBar:
                order?.canCancel == true || order?.canRetryPayment == true
                ? SafeArea(
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: Row(
                        children: [
                          if (order?.canRetryPayment == true)
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: paymentState.isBusy
                                    ? null
                                    : _startPayment,
                                icon: paymentState.isBusy
                                    ? SizedBox.square(
                                        dimension: 18,
                                        child: spinKitApp(colors.onPrimary),
                                      )
                                    : const Icon(Icons.credit_card),
                                label: Text(
                                  paymentState.isBusy
                                      ? l10n.payment_processing
                                      : l10n.pay_now,
                                ),
                              ),
                            ),
                          if (order?.canRetryPayment == true &&
                              order?.canCancel == true)
                            SizedBox(width: 12.w),
                          if (order?.canCancel == true)
                            Expanded(
                              child: OutlinedButton(
                                onPressed:
                                    state.isCancelingOrder ||
                                        paymentState.isBusy
                                    ? null
                                    : _confirmCancel,
                                child: state.isCancelingOrder
                                    ? SizedBox.square(
                                        dimension: 20,
                                        child: spinKitApp(colors.primary),
                                      )
                                    : Text(l10n.cancel_order),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                : null,
            body: state.isLoadingOrderDetails
                ? Center(child: spinKitApp(colors.primary))
                : order == null
                ? Center(
                    child: AppEmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: state.errorMessage ?? l10n.order_not_found,
                    ),
                  )
                : ListView(
                    padding: EdgeInsets.all(16.w),
                    children: [
                      if (order.package?.service?.image?.isNotEmpty == true)
                        ClipRRect(
                          borderRadius: BorderRadius.circular(18.r),
                          child: CustomImageView(
                            imagePath: order.package!.service!.image!,
                            height: 190.h,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      SizedBox(height: 16.h),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              order.package?.service?.name ??
                                  order.package?.name ??
                                  '',
                              maxLines: 2,
                              style: Styles.textStyle18.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          BookingStatusBadge(
                            status: order.status,
                            color: accent(),
                          ),
                        ],
                      ),
                      if (order.package?.name.isNotEmpty == true)
                        Text(
                          order.package!.name,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      if (order.package?.service?.company?.name.isNotEmpty ==
                          true)
                        Text(
                          order.package!.service!.company!.name,
                          style: Styles.textStyle14.copyWith(
                            fontWeight: FontWeight.w500,
                            color: colors.onSurfaceVariant,
                          ),
                        ),
                      SizedBox(height: 14.h),
                      _row(
                        Icons.play_circle_outline,
                        l10n.start_time,
                        _date(context, order.startTime),
                      ),
                      _row(
                        Icons.stop_circle_outlined,
                        order.travelBufferMinutes > 0
                            ? l10n.worker_return
                            : l10n.end_time,
                        _date(context, order.endTime),
                      ),
                      _row(
                        Icons.schedule,
                        l10n.duration,
                        '${order.package?.isOpenPackage == true ? order.duration : (order.package?.duration ?? order.duration)} ${l10n.minutes}',
                      ),
                      if (order.travelBufferMinutes > 0)
                        _row(
                          Icons.route_outlined,
                          l10n.travel_allocation,
                          '${order.travelBufferMinutes} ${l10n.minutes}',
                        ),
                      _row(
                        Icons.payments_outlined,
                        l10n.total_price,
                        '${order.totalPrice.toStringAsFixed(2)} ${l10n.sp}',
                      ),
                      _row(
                        Icons.account_balance_wallet_outlined,
                        l10n.payment_method,
                        _paymentMethodLabel(order),
                      ),
                      _row(
                        Icons.verified_outlined,
                        l10n.payment_status,
                        _paymentStatusLabel(order),
                      ),
                      _row(
                        Icons.location_on_outlined,
                        l10n.location,
                        order.location,
                      ),
                      if (order.note?.isNotEmpty == true)
                        _row(Icons.notes, l10n.note, order.note!),
                      if (order
                              .package
                              ?.service
                              ?.company
                              ?.location
                              .isNotEmpty ==
                          true)
                        _row(
                          Icons.business,
                          l10n.company_location,
                          order.package!.service!.company!.location,
                        ),
                      if (order.package?.isOpenPackage != true &&
                          order.package?.details.isNotEmpty == true) ...[
                        SizedBox(height: 12.h),
                        Text(
                          l10n.package_details,
                          style: Styles.textStyle16.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        ...order.package!.details.map(
                          (feature) => Padding(
                            padding: EdgeInsets.only(bottom: 8.h),
                            child: Row(
                              children: [
                                Icon(Icons.check_circle_outline, size: 20.sp),
                                SizedBox(width: 10.w),
                                Expanded(
                                  child: Text(
                                    feature,
                                    maxLines: 5,
                                    style: Styles.textStyle12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                      if (order.package?.isOpenPackage == true) ...[
                        SizedBox(height: 12.h),
                        Row(
                          children: [
                            Text(
                              l10n.package_details,
                              style: Styles.textStyle16.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                "(${l10n.selected_configuration})",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: Styles.textStyle12.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: colors.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.h),
                        if (order.attributes.isEmpty)
                          Text(l10n.no_attributes_available),
                        ...order.attributes.map(
                          (attribute) => Padding(
                            padding: EdgeInsets.only(bottom: 6.h),
                            child: _row(
                              Icons.tune,
                              attribute.name,
                              _attributeValue(attribute),
                            ),
                          ),
                        ),
                      ],
                      if (order.leader != null) _leaderCard(order.leader!),
                      SizedBox(height: 24.h),
                    ],
                  ),
          );
        },
      ),
    );
  }
}
