import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

class BookingDetailsPage extends StatefulWidget {
  final String packageName;
  final double price;

  const BookingDetailsPage({
    super.key,
    required this.packageName,
    required this.price,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  num get _total => (widget.price).clamp(0, 1000000);

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? now.add(const Duration(days: 1)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _selectedDate = picked);
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();

    final initialTime =
        _selectedTime ?? TimeOfDay(hour: now.hour, minute: now.minute);

    final picked = await showTimePicker(
      context: context,
      initialTime: initialTime,

      builder: (context, child) {
        final theme = Theme.of(context);

        return Theme(
          data: theme.copyWith(
            colorScheme: theme.colorScheme.copyWith(
              primary: theme.colorScheme.primary,
              surface: theme.colorScheme.surface,
              onSurface: theme.colorScheme.onSurface,
            ),

            timePickerTheme: TimePickerThemeData(
              backgroundColor: theme.colorScheme.surface,

              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),

              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),

              dayPeriodShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),

              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return theme.colorScheme.primary;
                }

                return theme.colorScheme.primary.withOpacity(.08);
              }),

              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white;
                }

                return theme.colorScheme.onSurface;
              }),
              dayPeriodBorderSide: BorderSide.none,

              // dayPeriodTextStyle: Styles.textStyle14.copyWith(color: Colors.white),
              hourMinuteTextStyle: Styles.textStyle22.copyWith(
                fontWeight: FontWeight.bold,
              ),

              helpTextStyle: Styles.textStyle12.copyWith(
                fontWeight: FontWeight.w600,
              ),

              confirmButtonStyle: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
              ),

              cancelButtonStyle: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.onSurface.withOpacity(.6),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  // Future<void> _pickTime() async {
  //   final picked = await showTimePicker(
  //     context: context,
  //     initialTime: _selectedTime ?? const TimeOfDay(hour: 10, minute: 0),
  //   );
  //   if (picked != null) setState(() => _selectedTime = picked);
  // }

  Future<void> _confirmBooking() async {
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.validation_required),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => Center(child: CircularProgressIndicator()),
    );

    // Simulate network/save delay
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    Navigator.of(context).pop();

    await showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.booking_successful),
        content: Text(
          AppLocalizations.of(context)!.booking_successful_message,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      ),
    );

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.booking_details),
        backgroundColor: theme.surface,
        elevation: 0,
        foregroundColor: theme.onSurface,
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 20.h),
        decoration: BoxDecoration(
          color: theme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Row(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.total_label,
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurface.withOpacity(0.7),
                    ),
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    "\$$_total",
                    style: Styles.textStyle22.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                ],
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: CustomElevatedButton(
                  text: AppLocalizations.of(context)!.confirm_booking,
                  buttonTextStyle: Styles.textStyle16.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  buttonStyle: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(theme.primary),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  onPressed: _confirmBooking,
                ),
              ),
            ],
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
              hint: widget.packageName,
              suffix: Text(
                "${widget.price} ${AppLocalizations.of(context)!.sp}",
                style: Styles.textStyle14.copyWith(color: theme.primary),
                textAlign: TextAlign.center,
              ),
              readOnly: true,
            ),

            SizedBox(height: 16.h),
            AppTextField(
              label: AppLocalizations.of(context)!.date_label,
              hint: _selectedDate != null
                  ? _formatDate(_selectedDate!)
                  : AppLocalizations.of(context)!.select_date,
              onTap: _pickDate,
              suffix: Icon(
                Icons.calendar_month_rounded,
                size: 20.sp,
                color: theme.primary,
              ),
              readOnly: true,
            ),

            SizedBox(height: 16.h),

            AppTextField(
              label: AppLocalizations.of(context)!.time_label,
              hint: _selectedTime != null
                  ? _selectedTime!.format(context)
                  : AppLocalizations.of(context)!.select_time,
              onTap: _pickTime,
              suffix: Icon(
                Icons.schedule_rounded,
                size: 20.sp,
                color: theme.primary,
              ),
              readOnly: true,
            ),

            SizedBox(height: 16.h),
            AppTextField(
              controller: _addressController,
              label: AppLocalizations.of(context)!.address_label,
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
              hint: AppLocalizations.of(context)!.optional,
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthName(d.month)} ${d.year}';

  String _monthName(int m) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return months[m - 1];
  }
}
