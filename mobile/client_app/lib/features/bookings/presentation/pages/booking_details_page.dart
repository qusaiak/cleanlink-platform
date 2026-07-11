import 'package:client_app/core/utils/functions/spinkit.dart';
import 'package:client_app/core/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_empty_state.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_toast.dart';
import '../../../../config/routes/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../base/presentation/bloc/base_bloc.dart';
import '../../../services/domain/entities/package_entity.dart';
import '../bloc/bookings_bloc.dart';

class BookingDetailsPage extends StatefulWidget {
  final PackageEntity package;

  const BookingDetailsPage({super.key, required this.package});

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

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
    final location = _addressController.text.trim();
    final startTime = _selectedStartTime(state);
    if (location.isEmpty || startTime == null) {
      AppSnackBar.showWarning(
        context: context,
        title: AppLocalizations.of(context)!.warning,
        message: AppLocalizations.of(context)!.validation_required,
      );
      return;
    }
    context.read<BookingsBloc>().add(
      BookOrderEvent(
        packageId: widget.package.id,
        location: location,
        startTime: startTime,
        note: _notesController.text.trim(),
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    context.read<BookingsBloc>().add(LoadAvailableSlots(widget.package.id));
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return BlocListener<BookingsBloc, BookingsState>(
      listenWhen: (previous, current) =>
          previous.bookingSuccess != current.bookingSuccess ||
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.bookingSuccess) {
          AppSnackBar.showSuccess(
            context: context,
            title: AppLocalizations.of(context)!.success,
            message: AppLocalizations.of(context)!.booking_successful_message,
          );
          context.read<BookingsBloc>().add(const ResetBookingStateEvent());
          context.read<BaseBloc>().add(const ChangeBottomNavBarIndex(2));
          AppRouter.router.go(AppRouter.kBookings);
        } else if (state.errorMessage != null) {
          AppSnackBar.showError(
            context: context,
            title: AppLocalizations.of(context)!.error,
            message: state.errorMessage!,
          );
        }
      },
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
            child: BlocBuilder<BookingsBloc, BookingsState>(
              buildWhen: (previous, current) =>
                  previous.isBookingOrder != current.isBookingOrder,
              builder: (context, state) => CustomElevatedButton(
                text: state.isBookingOrder
                    ? AppLocalizations.of(context)!.booking_in_progress
                    : AppLocalizations.of(context)!.confirm_booking,
                buttonTextStyle: Styles.textStyle12.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                buttonStyle: ButtonStyle(
                  backgroundColor: WidgetStateProperty.all(theme.primary),
                  shape: WidgetStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                  ),
                  elevation: WidgetStateProperty.all(0),
                ),
                onPressed: state.isBookingOrder ? null : _confirmBooking,
              ),
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextField(
                label: AppLocalizations.of(context)!.selected_package_label,
                labelStyle: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                hint: widget.package.name,
                suffix: Text(
                  "${widget.package.price} ${AppLocalizations.of(context)!.sp}",
                  style: Styles.textStyle14.copyWith(color: theme.primary),
                  textAlign: TextAlign.center,
                ),
                readOnly: true,
              ),

              SizedBox(height: 16.h),

              BlocBuilder<BookingsBloc, BookingsState>(
                buildWhen: (previous, current) =>
                    previous.isLoadingSlots != current.isLoadingSlots ||
                    previous.availableDays != current.availableDays ||
                    previous.selectedDay != current.selectedDay,
                builder: (context, state) {
                  if (state.isLoadingSlots) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.h),
                        child: spinKitApp(theme.primary),
                      ),
                    );
                  }

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

                      state.availableDays.isEmpty
                          ? AppEmptyState(
                              icon: Icons.event_busy_outlined,
                              title: AppLocalizations.of(
                                context,
                              )!.no_available_dates,
                              body: AppLocalizations.of(
                                context,
                              )!.no_available_dates_message,
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
                  if (state.isLoadingSlots || state.selectedDay == null) {
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
              AppTextField(
                controller: _addressController,
                label: AppLocalizations.of(context)!.address_label,
                labelStyle: Styles.textStyle16.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                hint: AppLocalizations.of(context)!.address_hint,
                suffix: Icon(
                  Icons.location_on_outlined,
                  size: 20.sp,
                  color: theme.primary,
                ),
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
