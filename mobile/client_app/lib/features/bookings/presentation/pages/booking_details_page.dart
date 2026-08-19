import 'dart:async';

import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/error/failure.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../injection_container.dart';
import '../../../base/presentation/bloc/base_bloc.dart';
import '../../../services/domain/entities/package_entity.dart';
import '../../../services/domain/entities/attribute_entity.dart';
import '../../domain/entities/open_package_entities.dart';
import '../bloc/bookings_bloc.dart';
import '../widgets/booking_location_selector.dart';
import '../../../locations/domain/entities/selected_map_location.dart';
import '../../../locations/domain/entities/client_location_entity.dart';
import '../../../locations/presentation/bloc/locations_bloc.dart';
import '../../../payments/domain/entities/payment_entities.dart';
import '../../../payments/presentation/bloc/payments_bloc.dart';
import '../widgets/booking_location_sheet.dart';

class BookingDetailsPage extends StatefulWidget {
  final PackageEntity package;
  final List<AttributeEntity> attributes;

  const BookingDetailsPage({
    super.key,
    required this.package,
    this.attributes = const [],
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final TextEditingController _notesController = TextEditingController();
  StreamSubscription<LocationsState>? _locationsSubscription;
  PaymentMethodType _paymentMethod = PaymentMethodType.manual;

  Future<void> _selectLocation() async {
    final bookingBloc = context.read<BookingsBloc>();
    final locationsBloc = sl<LocationsBloc>();
    if (!locationsBloc.state.hasLoaded) {
      locationsBloc.add(const LoadLocationsEvent());
    }
    final choice = await showModalBottomSheet<Object>(
      context: context,
      isScrollControlled: true,
      showDragHandle: false,
      builder: (_) => BlocProvider.value(
        value: locationsBloc,
        child: BookingLocationSheet(
          selectedLocation: bookingBloc.state.selectedLocation,
        ),
      ),
    );
    if (!mounted || choice == null) return;

    SelectedMapLocation? location;
    if (choice is SelectedMapLocation) {
      location = choice;
    } else if (choice == BookingLocationSheetAction.chooseOnMap) {
      location = await context.push<SelectedMapLocation>(
        AppRouter.kMapLocationPicker,
        extra: bookingBloc.state.selectedLocation,
      );
    } else if (choice == BookingLocationSheetAction.addSaved) {
      final created = await context.push<ClientLocationEntity>(
        AppRouter.kAddLocation,
      );
      location = created?.toSelectedMapLocation();
    }
    if (!mounted || location == null) return;
    bookingBloc.add(
      SelectBookingLocation(packageId: widget.package.id, location: location),
    );
  }

  String _localizedSlotFailure(BuildContext context, Failure failure) {
    final l = AppLocalizations.of(context)!;
    final message = failure.message.trim().toLowerCase();
    if (message.contains('company location is not configured')) {
      return l.company_location_missing;
    }
    if (message.contains('unable to calculate travel time')) {
      return l.travel_time_temporarily_unavailable;
    }
    if (message.contains('far distance')) {
      return l.route_unavailable_for_location;
    }
    if (message.contains('not enough eligible workers')) {
      return l.no_qualified_workgroup;
    }
    return switch (failure.type) {
      AppFailureType.noInternet => l.network_no_internet_description,
      AppFailureType.timeout => l.network_timeout_description,
      AppFailureType.server =>
        failure.message.trim().isEmpty
            ? l.network_server_description
            : failure.message,
      _ => l.network_generic_description,
    };
  }

  DateTime? _selectedStartTime(BookingsState state) {
    if (state.selectedDay == null || state.selectedTime == null) return null;
    final parts = state.selectedTime!.split(':');
    if (parts.length < 2) return null;
    return DateTime(
      state.selectedDay!.date.year,
      state.selectedDay!.date.month,
      state.selectedDay!.date.day,
      int.tryParse(parts[0]) ?? 0,
      int.tryParse(parts[1]) ?? 0,
      parts.length > 2 ? int.tryParse(parts[2]) ?? 0 : 0,
    );
  }

  void _confirmBooking() {
    final state = context.read<BookingsBloc>().state;
    final location = state.selectedLocation;
    final startTime = _selectedStartTime(state);
    final l = AppLocalizations.of(context)!;
    if (widget.package.isOpenPackage &&
        !state.isOpenPackageConfigurationChecked) {
      AppSnackBar.showWarning(
        context: context,
        title: l.warning,
        message: l.please_check_price_duration_again,
      );
      return;
    }
    if (location == null) {
      AppSnackBar.showWarning(
        context: context,
        title: l.warning,
        message: l.please_select_service_location,
      );
      return;
    }
    if (state.selectedDay == null) {
      AppSnackBar.showWarning(
        context: context,
        title: l.warning,
        message: l.please_select_date,
      );
      return;
    }
    if (startTime == null) {
      AppSnackBar.showWarning(
        context: context,
        title: l.warning,
        message: l.please_select_available_time,
      );
      return;
    }
    context.read<BookingsBloc>().add(
      BookOrderEvent(
        packageId: widget.package.id,
        location: location.formattedAddress,
        latitude: location.latitude,
        longitude: location.longitude,
        startTime: startTime,
        note: _notesController.text.trim(),
        paymentMethod: _paymentMethod,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    final bloc = context.read<BookingsBloc>();
    context.read<PaymentsBloc>().add(const ResetPaymentState());
    bloc.add(
      ConfigureBookingPackage(
        package: widget.package,
        attributes: widget.attributes,
      ),
    );
    final locationsBloc = sl<LocationsBloc>();
    _locationsSubscription = locationsBloc.stream.listen((locationsState) {
      final selected = bloc.state.selectedLocation;
      final savedId = selected?.savedLocationId;
      if (savedId == null) return;
      ClientLocationEntity? current;
      for (final location in locationsState.locations) {
        if (location.id == savedId) {
          current = location;
          break;
        }
      }
      if (current == null &&
          locationsState.mutation == LocationMutation.deleted) {
        bloc.add(const ClearBookingLocation());
      } else if (current != null &&
          locationsState.mutation == LocationMutation.updated &&
          current.toSelectedMapLocation() != selected) {
        bloc.add(
          SelectBookingLocation(
            packageId: widget.package.id,
            location: current.toSelectedMapLocation(),
          ),
        );
      }
    });
    final location = bloc.state.selectedLocation;
    if (location != null &&
        (!widget.package.isOpenPackage ||
            bloc.state.isOpenPackageConfigurationChecked)) {
      bloc.add(
        LoadAvailableSlots(
          packageId: widget.package.id,
          latitude: location.latitude,
          longitude: location.longitude,
        ),
      );
    }
  }

  void _completeBooking() {
    if (!mounted) return;
    context.read<PaymentsBloc>().add(const ResetPaymentState());
    context.read<BookingsBloc>().add(const ResetBookingStateEvent());
    context.read<BaseBloc>().add(const ChangeBottomNavBarIndex(2));
    AppRouter.router.go(AppRouter.kBookings);
  }

  void _openCreatedOrder(int orderId) {
    if (!mounted) return;
    context.read<PaymentsBloc>().add(const ResetPaymentState());
    context.read<BookingsBloc>().add(const ResetBookingStateEvent());
    context.read<BaseBloc>().add(const ChangeBottomNavBarIndex(2));
    AppRouter.router.go(AppRouter.orderDetailsPath(orderId));
  }

  String _localizedBookingError(BuildContext context, String rawMessage) {
    final l = AppLocalizations.of(context)!;
    final message = rawMessage.trim().toLowerCase();
    if (message.contains('company location is not configured')) {
      return l.company_location_missing;
    }
    if (message.contains('unable to calculate travel time')) {
      return l.travel_time_temporarily_unavailable;
    }
    if (message.contains('far distance')) {
      return l.route_unavailable_for_location;
    }
    if (message.contains('not enough eligible workers')) {
      return l.no_qualified_workgroup;
    }
    if (message.contains('no internet')) {
      return l.network_no_internet_description;
    }
    if (message.contains('timeout')) return l.network_timeout_description;
    return rawMessage.trim().isEmpty
        ? l.network_generic_description
        : rawMessage;
  }

  @override
  void dispose() {
    _locationsSubscription?.cancel();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return MultiBlocListener(
      listeners: [
        BlocListener<BookingsBloc, BookingsState>(
          listenWhen: (previous, current) =>
              previous.bookingSuccess != current.bookingSuccess ||
              previous.errorMessage != current.errorMessage,
          listener: (context, state) {
            if (state.bookingSuccess) {
              final order = state.selectedOrder;
              if (order?.paymentMethod == PaymentMethodType.electric.apiValue) {
                context.read<PaymentsBloc>().add(
                  PayForOrder(
                    orderId: order!.id,
                    darkMode: Theme.of(context).brightness == Brightness.dark,
                  ),
                );
              } else {
                AppSnackBar.showSuccess(
                  context: context,
                  title: AppLocalizations.of(context)!.success,
                  message: AppLocalizations.of(
                    context,
                  )!.booking_successful_message,
                );
                _completeBooking();
              }
            } else if (state.errorMessage != null) {
              AppSnackBar.showError(
                context: context,
                title: AppLocalizations.of(context)!.error,
                message: _localizedBookingError(context, state.errorMessage!),
              );
            }
          },
        ),
        BlocListener<PaymentsBloc, PaymentsState>(
          listenWhen: (previous, current) => previous.stage != current.stage,
          listener: (context, state) {
            final l = AppLocalizations.of(context)!;
            if (state.stage == PaymentStage.succeeded) {
              AppSnackBar.showSuccess(
                context: context,
                title: l.success,
                message: l.payment_confirmed,
              );
              _openCreatedOrder(
                state.order?.id ??
                    context.read<BookingsBloc>().state.selectedOrder!.id,
              );
            } else if (state.stage == PaymentStage.pendingConfirmation) {
              AppSnackBar.showWarning(
                context: context,
                title: l.payment_processing,
                message: l.payment_processing_message,
              );
              _openCreatedOrder(
                state.order?.id ??
                    context.read<BookingsBloc>().state.selectedOrder!.id,
              );
            } else if (state.stage == PaymentStage.cancelled) {
              AppSnackBar.showWarning(
                context: context,
                title: l.payment_cancelled,
                message: l.payment_cancelled_message,
              );
              _openCreatedOrder(
                state.order?.id ??
                    context.read<BookingsBloc>().state.selectedOrder!.id,
              );
            } else if (state.stage == PaymentStage.failed) {
              AppSnackBar.showError(
                context: context,
                title: l.payment_failed,
                message: state.errorMessage?.trim().isNotEmpty == true
                    ? state.errorMessage!
                    : l.payment_failed_message,
              );
              _openCreatedOrder(
                state.order?.id ??
                    context.read<BookingsBloc>().state.selectedOrder!.id,
              );
            }
          },
        ),
      ],
      child: Scaffold(
        appBar: customAppBar(
          AppLocalizations.of(context)!.booking_details,
          null,
          [],
          () {},
          theme.onSurface,
        ),
        bottomNavigationBar: Container(
          padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: theme.surface,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 12,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: SafeArea(
            top: false,
            child: BlocBuilder<PaymentsBloc, PaymentsState>(
              builder: (context, paymentState) =>
                  BlocBuilder<BookingsBloc, BookingsState>(
                    builder: (context, state) {
                      final disabled =
                          state.isBookingOrder ||
                          paymentState.isBusy ||
                          state.bookingSuccess;
                      final text = switch (paymentState.stage) {
                        PaymentStage.creatingIntent => AppLocalizations.of(
                          context,
                        )!.creating_payment,
                        PaymentStage.preparingSheet ||
                        PaymentStage.presentingSheet => AppLocalizations.of(
                          context,
                        )!.preparing_payment,
                        PaymentStage.awaitingBackend => AppLocalizations.of(
                          context,
                        )!.payment_processing,
                        _ when state.isBookingOrder => AppLocalizations.of(
                          context,
                        )!.booking_in_progress,
                        _ => AppLocalizations.of(context)!.confirm_booking,
                      };
                      return CustomElevatedButton(
                        text: text,
                        buttonTextStyle: Styles.textStyle12.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        buttonStyle: ButtonStyle(
                          backgroundColor: WidgetStateProperty.all(
                            theme.primary,
                          ),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.r),
                            ),
                          ),
                          elevation: WidgetStateProperty.all(0),
                        ),
                        isDisabled: disabled,
                        onPressed: _confirmBooking,
                      );
                    },
                  ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BlocBuilder<BookingsBloc, BookingsState>(
                builder: (context, state) {
                  return AppTextField(
                    label: AppLocalizations.of(context)!.selected_package_label,
                    labelStyle: Styles.textStyle16.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    hint: widget.package.name,
                    suffix: Text(
                      widget.package.isOpenPackage
                          ? "${state.openPackageQuote?.totalPrice ?? 0}"
                          : "${widget.package.price} ${AppLocalizations.of(context)!.sp}",
                      style: Styles.textStyle14.copyWith(color: theme.primary),
                      textAlign: TextAlign.center,
                    ),
                    readOnly: true,
                  );
                },
              ),

              if (widget.package.isOpenPackage) ...[
                SizedBox(height: 16.h),
                BlocBuilder<BookingsBloc, BookingsState>(
                  buildWhen: (previous, current) =>
                      previous.openPackageAttributeQuantities !=
                          current.openPackageAttributeQuantities ||
                      previous.openPackageQuote != current.openPackageQuote ||
                      previous.isCheckingOpenPackagePrice !=
                          current.isCheckingOpenPackagePrice,
                  builder: (context, state) => OpenPackageCustomizer(
                    attributes: state.serviceAttributes,
                    quantities: state.openPackageAttributeQuantities,
                    quote: state.openPackageQuote,
                    isCalculating: state.isCheckingOpenPackagePrice,
                  ),
                ),
              ],

              SizedBox(height: 16.h),

              BlocBuilder<BookingsBloc, BookingsState>(
                buildWhen: (previous, current) =>
                    previous.selectedLocation != current.selectedLocation,
                builder: (context, state) => BookingLocationSelector(
                  location: state.selectedLocation,
                  onTap: _selectLocation,
                ),
              ),

              BlocBuilder<BookingsBloc, BookingsState>(
                buildWhen: (previous, current) =>
                    previous.selectedLocation != current.selectedLocation,
                builder: (context, state) => state.selectedLocation == null
                    ? const SizedBox.shrink()
                    : Container(
                        margin: EdgeInsets.only(top: 10.h),
                        padding: EdgeInsets.all(12.r),
                        decoration: BoxDecoration(
                          color: theme.primaryContainer.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.route_outlined, color: theme.primary),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: Text(
                                AppLocalizations.of(
                                  context,
                                )!.travel_considered_message,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),
              ),

              SizedBox(height: 16.h),

              BlocBuilder<BookingsBloc, BookingsState>(
                buildWhen: (previous, current) =>
                    previous.isLoadingSlots != current.isLoadingSlots ||
                    previous.availableDays != current.availableDays ||
                    previous.selectedDay != current.selectedDay ||
                    previous.selectedLocation != current.selectedLocation ||
                    previous.slotsFailure != current.slotsFailure,
                builder: (context, state) {
                  if (state.selectedLocation == null) {
                    return const SizedBox.shrink();
                  }
                  if (state.isLoadingSlots) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: spinKitApp(theme.primary),
                      ),
                    );
                  }

                  if (state.slotsFailure != null) {
                    final message = _localizedSlotFailure(
                      context,
                      state.slotsFailure!,
                    );
                    return _SlotsErrorCard(
                      message: message,
                      onRetry: () {
                        final location = state.selectedLocation!;
                        context.read<BookingsBloc>().add(
                          LoadAvailableSlots(
                            packageId: widget.package.id,
                            latitude: location.latitude,
                            longitude: location.longitude,
                          ),
                        );
                      },
                      onChangeLocation: _selectLocation,
                    );
                  }

                  final hasAnySlots = state.availableDays.any(
                    (day) => day.hasAvailableSlots,
                  );

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.date_label,
                        style: Styles.textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      !hasAnySlots
                          ? AppEmptyState(
                              icon: Icons.event_busy_outlined,
                              title: AppLocalizations.of(
                                context,
                              )!.no_available_slots_for_location,
                              body: AppLocalizations.of(
                                context,
                              )!.no_available_slots_for_location_message,
                            )
                          : SizedBox(
                              height: 74.h,
                              child: ListView.separated(
                                scrollDirection: Axis.horizontal,
                                itemCount: state.availableDays.length,
                                separatorBuilder: (_, _) =>
                                    SizedBox(width: 12.w),
                                itemBuilder: (_, index) {
                                  final day = state.availableDays[index];
                                  final selected = day == state.selectedDay;

                                  return GestureDetector(
                                    onTap: day.hasAvailableSlots
                                        ? () {
                                            context.read<BookingsBloc>().add(
                                              SelectDate(day),
                                            );
                                          }
                                        : null,
                                    child: Container(
                                      width: 74.w,
                                      decoration: BoxDecoration(
                                        color: selected
                                            ? theme.primary
                                            : theme.surface,
                                        borderRadius: BorderRadius.circular(
                                          16.r,
                                        ),
                                        border: Border.all(
                                          color: selected
                                              ? theme.primary
                                              : theme.outline.withValues(
                                                  alpha: 0.25,
                                                ),
                                        ),
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            DateFormat("EEE").format(day.date),
                                            style: Styles.textStyle12.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            DateFormat("dd").format(day.date),
                                            style: Styles.textStyle16.copyWith(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),

                                          const SizedBox(height: 4),

                                          Text(
                                            DateFormat("MMM").format(day.date),
                                            style: Styles.textStyle12.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),

              BlocBuilder<BookingsBloc, BookingsState>(
                buildWhen: (previous, current) =>
                    previous.isLoadingSlots != current.isLoadingSlots ||
                    previous.selectedDay != current.selectedDay ||
                    previous.selectedTime != current.selectedTime,
                builder: (context, state) {
                  if (state.isLoadingSlots ||
                      state.slotsFailure != null ||
                      state.selectedDay == null) {
                    return const SizedBox.shrink();
                  }

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.time_label,
                        style: Styles.textStyle16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      SizedBox(height: 12.h),

                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: state.selectedDay!.slots.map((slot) {
                          final selected = slot == state.selectedTime;

                          return GestureDetector(
                            onTap: () {
                              context.read<BookingsBloc>().add(
                                SelectTime(slot),
                              );
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: selected ? theme.primary : theme.surface,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: selected
                                      ? theme.primary
                                      : theme.outline.withValues(alpha: 0.25),
                                ),
                              ),
                              child: Text(
                                slot,
                                style: Styles.textStyle14.copyWith(
                                  color: selected
                                      ? Colors.white
                                      : theme.onSurface,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 16.h),
              _PaymentMethodSelector(
                value: _paymentMethod,
                onChanged: (value) => setState(() => _paymentMethod = value),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _notesController,
                label: AppLocalizations.of(context)!.notes_label,
                labelStyle: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                maxLines: 5,
                hint: AppLocalizations.of(context)!.optional,
              ),
              SizedBox(height: 16.h),
            ],
          ),
        ),
      ),
    );
  }
}

class OpenPackageCustomizer extends StatelessWidget {
  const OpenPackageCustomizer({
    super.key,
    required this.attributes,
    required this.quantities,
    required this.quote,
    required this.isCalculating,
  });

  final List<AttributeEntity> attributes;
  final Map<int, int> quantities;
  final OpenPackageQuote? quote;
  final bool isCalculating;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(18.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l.customize_your_service,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          SizedBox(height: 12.h),
          if (attributes.isEmpty)
            Text(l.no_attributes_available)
          else
            for (final attribute in attributes)
              Padding(
                padding: EdgeInsets.only(bottom: 10.h),
                child: attribute.isBoolean
                    ? CheckboxListTile(
                        key: ValueKey('open-package-boolean-${attribute.id}'),
                        value: (quantities[attribute.id] ?? 0) > 0,
                        onChanged: (value) => context.read<BookingsBloc>().add(
                          UpdateOpenPackageAttributeQty(
                            attributeId: attribute.id,
                            qty: value == true ? 1 : 0,
                          ),
                        ),
                        title: Text(attribute.name),
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        controlAffinity: ListTileControlAffinity.trailing,
                      )
                    : Row(
                        key: ValueKey('open-package-number-${attribute.id}'),
                        children: [
                          Expanded(child: Text(attribute.name)),
                          IconButton(
                            tooltip: l.decrease,
                            onPressed: (quantities[attribute.id] ?? 0) == 0
                                ? null
                                : () => context.read<BookingsBloc>().add(
                                    UpdateOpenPackageAttributeQty(
                                      attributeId: attribute.id,
                                      qty: (quantities[attribute.id] ?? 0) - 1,
                                    ),
                                  ),
                            icon: const Icon(Icons.remove_circle_outline),
                          ),
                          SizedBox(
                            width: 28.w,
                            child: Text(
                              '${quantities[attribute.id] ?? 0}',
                              textAlign: TextAlign.center,
                            ),
                          ),
                          IconButton(
                            tooltip: l.increase,
                            onPressed: () => context.read<BookingsBloc>().add(
                              UpdateOpenPackageAttributeQty(
                                attributeId: attribute.id,
                                qty: (quantities[attribute.id] ?? 0) + 1,
                              ),
                            ),
                            icon: const Icon(Icons.add_circle_outline),
                          ),
                        ],
                      ),
              ),
          SizedBox(height: 8.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: isCalculating
                  ? null
                  : () => context.read<BookingsBloc>().add(
                      CheckOpenPackagePrice(
                        context.read<BookingsBloc>().state.package!.id,
                      ),
                    ),
              child: isCalculating
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colors.onPrimary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(l.checking_price_duration),
                      ],
                    )
                  : Text(l.check_price_duration),
            ),
          ),
          if (quote != null) Divider(color: colors.outlineVariant),
          if (quote != null)
            Text(
              '${l.estimated_price}: ${quote!.totalPrice} ${l.sp}\n${l.estimated_duration}: ${quote!.duration} ${l.track_minutes_short}',
            ),
        ],
      ),
    );
  }
}

class _PaymentMethodSelector extends StatelessWidget {
  const _PaymentMethodSelector({required this.value, required this.onChanged});

  final PaymentMethodType value;
  final ValueChanged<PaymentMethodType> onChanged;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l.payment_method,
          style: Styles.textStyle16.copyWith(
            fontWeight: FontWeight.bold,
            color: colors.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
        for (final method in PaymentMethodType.values)
          Padding(
            padding: EdgeInsets.only(bottom: 8.h),
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              onTap: () => onChanged(method),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: method == value
                      ? colors.primary.withValues(alpha: isDark ? 0.18 : 0.10)
                      : colors.surface,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: method == value
                        ? colors.primary
                        : colors.onSurfaceVariant,
                    width: method == value ? 1.5 : 1,
                  ),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                  leading: Icon(
                    method == PaymentMethodType.manual
                        ? Icons.payments_outlined
                        : Icons.credit_card_outlined,
                    color: method == value
                        ? colors.primary
                        : colors.onSurfaceVariant,
                  ),
                  title: Text(
                    method == PaymentMethodType.manual
                        ? l.cash
                        : l.credit_debit_card,
                    style: Styles.textStyle16.copyWith(
                      fontWeight: method == value
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: colors.onSurface,
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _SlotsErrorCard extends StatelessWidget {
  const _SlotsErrorCard({
    required this.message,
    required this.onRetry,
    required this.onChangeLocation,
  });

  final String message;
  final VoidCallback onRetry;
  final VoidCallback onChangeLocation;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: colors.errorContainer.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.route_outlined, color: colors.error, size: 30.sp),
          SizedBox(height: 10.h),
          Text(
            message,
            maxLines: 5,
            textAlign: TextAlign.center,
            style: Styles.textStyle12.copyWith(color: colors.onSurface),
          ),
          SizedBox(height: 10.h),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.w,
            children: [
              TextButton(
                onPressed: onChangeLocation,
                child: Text(
                  l.change_location,
                  style: Styles.textStyle14.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              FilledButton(
                onPressed: onRetry,
                style: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(Colors.white),
                ),
                child: Text(
                  l.retry,
                  style: Styles.textStyle14.copyWith(
                    color: colors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
