import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_decoration.dart';
import '../../config/theme/styles.dart';
import '../../l10n/app_localizations.dart';
import '../utils/gen/assets.gen.dart';
import 'custom_elevated_button.dart';
import 'custom_image_view.dart';
import 'custom_outlined_button.dart';

class CustomDialog extends StatelessWidget {
  CustomDialog({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
    this.onCancel,
    this.isTwoButtons = true,
    this.isBackButtonDismiss = true,
    this.cancelButtonText,
    this.doneButtonText,
  });

  String? title;
  String? body;
  VoidCallback? onTap;
  VoidCallback? onCancel;
  final bool isTwoButtons;
  final bool isBackButtonDismiss;
  String? cancelButtonText;
  String? doneButtonText;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return PopScope(
      onPopInvokedWithResult: (didPop, dynamic) async {
        if (!isBackButtonDismiss) {
          SystemNavigator.pop();
        }
      },
      canPop: isBackButtonDismiss,
      child: AlertDialog(
        surfaceTintColor: Colors.transparent,
        backgroundColor: theme.surfaceContainerHighest,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.dialog),
        buttonPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: Assets.images.logo.appLogo.path,
                  width: 40.w,
                ),
                title!.isNotEmpty
                    ? Padding(
                        padding: EdgeInsets.symmetric(vertical: 10.h),
                        child: Text(
                          title ?? '',
                          style: Styles.textStyle12.copyWith(
                            color: theme.onSurface,
                            fontWeight: FontWeight.w500,
                          ),
                          maxLines: 100,
                        ),
                      )
                    : SizedBox.shrink(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 5.h),
                  child: Text(
                    body ?? '',
                    style: Styles.textStyle12.copyWith(
                      color: theme.onSurfaceVariant,
                      fontWeight: FontWeight.w400,
                    ),
                    maxLines: 100,
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          isTwoButtons
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CustomOutlinedButton(
                      text:
                          cancelButtonText ?? AppLocalizations.of(context)!.no,
                      width: 110.w,
                      height: 25.h,
                      buttonTextStyle: Styles.textStyle12.copyWith(
                        color: theme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                      buttonStyle: OutlinedButton.styleFrom(
                        backgroundColor: theme.surfaceContainerHighest,
                        side: BorderSide(color: theme.primary, width: 1.4),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: onCancel,
                    ),
                    CustomElevatedButton(
                      text: doneButtonText ?? AppLocalizations.of(context)!.yes,
                      width: 110.w,
                      height: 25.h,
                      buttonTextStyle: Styles.textStyle12.copyWith(
                        color: theme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button,
                        ),
                        // The theme's 14.h vertical padding is taller than
                        // this 25.h button, which clipped the label away
                        // entirely (the "Done" button looked empty).
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onTap,
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomElevatedButton(
                      text: doneButtonText ?? AppLocalizations.of(context)!.ok,
                      width: 80.w,
                      height: 25.h,
                      buttonTextStyle: Styles.textStyle12.copyWith(
                        color: theme.onPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: AppRadius.button,
                        ),
                        padding: EdgeInsets.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: onTap,
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
