import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/models/country.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../core/utils/gen/assets.gen.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_image_view.dart';

class AuthPhoneField extends StatelessWidget {
  const AuthPhoneField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.initialCountry = kDefaultCountry,
    this.onCountryChanged,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final Country initialCountry;
  final ValueChanged<Country>? onCountryChanged;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;
    return AppTextField(
      controller: controller,
      label: label,
      hint: hint,
      keyboardType: TextInputType.phone,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        _PhoneNumberFormatter(),
      ],
      validator: (v) => AppValidators.phone(v, context),
      prefix: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomImageView(imagePath: Assets.icons.syria.path, width: 25.w),
          SizedBox(width: 6.w),
          Text(
            initialCountry.dialCode,
            style: Styles.textStyle14.copyWith(
              color: theme.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          Container(
            width: 1,
            height: 22.h,
            margin: EdgeInsetsDirectional.only(start: 15.w),
            color: theme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

class _PhoneNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    var digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    if (digits.length > 9) digits = digits.substring(0, 9);
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      buffer.write(digits[i]);
      if (i == 2 || i == 5) {
        if (i != digits.length - 1) buffer.write(' ');
      }
    }
    final formatted = buffer.toString();
    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: formatted.length),
    );
  }
}

String stripPhone(String value) => value.replaceAll(RegExp(r'\D'), '');

String fullPhone(Country country, String localPart) =>
    '${country.dialCode}${stripPhone(localPart)}';
