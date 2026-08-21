import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/styles.dart';
import '../../l10n/app_localizations.dart';
import '../utils/gen/assets.gen.dart';
import 'custom_elevated_button.dart';
import 'custom_image_view.dart';
import 'custom_outlined_button.dart';

class CustomDialog extends StatelessWidget {
  const CustomDialog({
    super.key,
    required this.title,
    required this.body,
    this.onTap,
    this.onCancel,
    this.isTwoButtons = true,
    this.isBackButtonDismiss = true,
    this.cancelButtonText,
    this.doneButtonText,
    this.isLoading = false,
  });

  final String? title;
  final String? body;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;
  final bool isTwoButtons;
  final bool isBackButtonDismiss;
  final String? cancelButtonText;
  final String? doneButtonText;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return PopScope(
      canPop: isBackButtonDismiss,
      child: AlertDialog(
        shadowColor: theme.surface,
        surfaceTintColor: theme.surface,
        backgroundColor: theme.surface,
        buttonPadding: EdgeInsets.zero,
        contentPadding: EdgeInsets.zero,
        actionsAlignment: MainAxisAlignment.center,
        content: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
          child: Container(
            width: MediaQuery.sizeOf(context).width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50.r),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                CustomImageView(
                  imagePath: Assets.icons.appIcon.path,
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
                      color: Colors.grey,
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
                        backgroundColor: Colors.white,
                        side: BorderSide(color: theme.primary, width: 2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: isLoading ? null : onCancel,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        shadowColor: Colors.white,
                      ),
                      isDisabled: isLoading,
                      rightIcon: isLoading
                          ? SizedBox(
                              width: 14.w,
                              height: 14.w,
                              child: CircularProgressIndicator.adaptive(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  theme.onPrimary,
                                ),
                              ),
                            )
                          : null,
                      onPressed: isLoading ? null : onTap,
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
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        shadowColor: Colors.white,
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
