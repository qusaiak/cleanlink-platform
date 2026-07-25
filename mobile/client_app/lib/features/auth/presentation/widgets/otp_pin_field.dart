import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';

import '../../../../config/theme/colors.dart';
import '../../../../config/theme/styles.dart';

class OtpPinField extends StatelessWidget {
  const OtpPinField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.forceErrorState,
    required this.onChanged,
    required this.onCompleted,
    this.length = 6,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final bool forceErrorState;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onCompleted;
  final int length;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    final defaultPin = PinTheme(
      width: 48.w,
      height: 56.h,
      textStyle: Styles.textStyle18.copyWith(
        color: theme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      decoration: BoxDecoration(
        color: theme.onSurface.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: theme.onSurface.withValues(alpha: 0.08)),
      ),
    );

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Pinput(
        controller: controller,
        focusNode: focusNode,
        length: length,
        autofocus: true,
        keyboardType: TextInputType.number,
        enableInteractiveSelection: false,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          const _ManualOtpEntryFormatter(),
        ],
        defaultPinTheme: defaultPin,
        focusedPinTheme: defaultPin.copyDecorationWith(
          border: Border.all(color: AppColor.primaryColor, width: 1.4),
          color: AppColor.primaryColor.withValues(alpha: 0.08),
        ),
        submittedPinTheme: defaultPin.copyDecorationWith(
          border: Border.all(
            color: AppColor.primaryColor.withValues(alpha: 0.6),
          ),
          color: AppColor.primaryColor.withValues(alpha: 0.05),
        ),
        errorPinTheme: defaultPin.copyDecorationWith(
          border: Border.all(color: AppColor.errorDark, width: 1.4),
          color: AppColor.errorDark.withValues(alpha: 0.08),
        ),
        forceErrorState: forceErrorState,
        showCursor: true,
        separatorBuilder: (_) => SizedBox(width: 6.w),
        pinAnimationType: PinAnimationType.scale,
        onChanged: onChanged,
        onCompleted: onCompleted,
      ),
    );
  }
}

class _ManualOtpEntryFormatter extends TextInputFormatter {
  const _ManualOtpEntryFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final insertedCharacters = newValue.text.length - oldValue.text.length;
    return insertedCharacters > 1 ? oldValue : newValue;
  }
}
