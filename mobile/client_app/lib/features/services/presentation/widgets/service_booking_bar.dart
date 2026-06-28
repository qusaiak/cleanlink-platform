import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceBookingBar extends StatelessWidget {
  final String packageName;
  final double price;
  final VoidCallback onBook;

  const ServiceBookingBar({
    super.key,
    required this.packageName,
    required this.price,
    required this.onBook,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: theme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "$price ${AppLocalizations.of(context)!.sp}",
                    style: Styles.textStyle18.copyWith(
                      fontWeight: FontWeight.bold,
                      color: theme.primary,
                    ),
                  ),
                  Text(
                    packageName,
                    maxLines: 2,
                    style: Styles.textStyle11.copyWith(
                      color: theme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 5.w),
            Expanded(
              child: CustomElevatedButton(
                text: AppLocalizations.of(context)!.book_now,
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
                onPressed: onBook,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
