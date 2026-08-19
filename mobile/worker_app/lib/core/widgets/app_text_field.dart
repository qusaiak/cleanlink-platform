import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../config/theme/app_decoration.dart';
import '../../config/theme/colors.dart';
import '../../config/theme/styles.dart';

/// Glass-morphism styled text field shared across the whole app.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.prefix,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.obscureText = false,
    this.maxLength,
    this.inputFormatters,
    this.validator,
    this.focusNode,
    this.onFieldSubmitted,
    this.onChanged,
    this.readOnly = false,
    this.onTap,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
    this.autofocus = false,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final Widget? prefix;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool obscureText;
  final int? maxLength;
  final List<TextInputFormatter>? inputFormatters;
  final FormFieldValidator<String>? validator;
  final FocusNode? focusNode;
  final ValueChanged<String>? onFieldSubmitted;
  final ValueChanged<String>? onChanged;
  final bool readOnly;
  final VoidCallback? onTap;
  final AutovalidateMode autovalidateMode;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 4.w, right: 4.w, bottom: 8.h),
          child: Text(
            label,
            style: Styles.textStyle12.copyWith(
              color: theme.onSurface.withValues(alpha: 0.75),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          obscureText: obscureText,
          maxLength: maxLength,
          inputFormatters: inputFormatters,
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          readOnly: readOnly,
          onTap: onTap,
          autovalidateMode: autovalidateMode,
          cursorColor: AppColor.primaryColor,
          style: Styles.textStyle14.copyWith(
            color: theme.onSurface,
            fontWeight: FontWeight.w500,
            overflow: TextOverflow.visible,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: hint,
            hintStyle: Styles.textStyle14.copyWith(
              color: theme.onSurface.withValues(alpha: 0.5),
            ),
            prefixIcon: prefix,
            suffixIcon: suffix,
            isDense: true,
            filled: true,
            fillColor: theme.onSurface.withValues(alpha: 0.045),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 16.h,
            ),
            border: _border(theme.onSurface.withValues(alpha: 0.3)),
            enabledBorder: _border(theme.onSurface.withValues(alpha: 0.3)),
            focusedBorder: _border(
              AppColor.primaryColor.withValues(alpha: 0.9),
              width: 1.4,
            ),
            errorBorder: _border(AppColor.errorDark, width: 1),
            focusedErrorBorder: _border(AppColor.errorDark, width: 1.4),
            errorStyle: Styles.textStyle11.copyWith(
              color: AppColor.errorDark,
              overflow: TextOverflow.visible,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}
