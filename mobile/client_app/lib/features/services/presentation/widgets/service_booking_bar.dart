import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../l10n/app_localizations.dart';

class ServiceBookingBar extends StatelessWidget {
  final String packageName;
  final double price;
  final double priceAfterDiscount;
  final VoidCallback onBook;

  const ServiceBookingBar({
    super.key,
    required this.packageName,
    required this.price,
    required this.priceAfterDiscount,
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // Expanded(
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         "$price ${AppLocalizations.of(context)!.sp}",
            //         style: Styles.textStyle18.copyWith(
            //           fontWeight: FontWeight.bold,
            //           color: theme.primary,
            //         ),
            //       ),
            //       Text(
            //         packageName,
            //         maxLines: 2,
            //         style: Styles.textStyle11.copyWith(
            //           color: theme.onSurface.withOpacity(0.7),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (price != priceAfterDiscount) ...[
                    Row(
                      children: [
                        Text(
                          "$price ${AppLocalizations.of(context)!.sp}",
                          style: Styles.textStyle18.copyWith(
                            color: theme.primary.withValues(alpha: 0.7),
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.lineThrough,
                            decorationColor: Colors.red.shade400,
                            decorationThickness: 1,
                          ),
                        ),

                        SizedBox(width: 8.w),

                        Text(
                          "$priceAfterDiscount ${AppLocalizations.of(context)!.sp}",
                          style: Styles.textStyle18.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primary,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 4.h),

                    // Text(
                    //   "$priceAfterDiscount ${AppLocalizations.of(context)!.sp}",
                    //   style: Styles.textStyle20.copyWith(
                    //     fontWeight: FontWeight.bold,
                    //     color: theme.primary,
                    //   ),
                    // ),
                  ] else
                    Text(
                      "$price ${AppLocalizations.of(context)!.sp}",
                      style: Styles.textStyle18.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primary,
                      ),
                    ),

                  SizedBox(height: 4.h),

                  Text(
                    packageName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Styles.textStyle11.copyWith(
                      color: theme.onSurface.withValues(alpha: .7),
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
