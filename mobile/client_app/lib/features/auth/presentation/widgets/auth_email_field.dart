import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_text_field.dart';

class AuthEmailField extends StatelessWidget {
  const AuthEmailField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.focusNode,
    this.textInputAction,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final String label;
  final String? hint;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context).colorScheme;

    return AppTextField(
      controller: controller,
      label: label,
      hint: hint ?? 'example@email.com',
      keyboardType: TextInputType.emailAddress,
      textInputAction: textInputAction ?? TextInputAction.next,
      focusNode: focusNode,
      onFieldSubmitted: onFieldSubmitted,

      validator: (v) => AppValidators.email(v, context),

      prefix: Icon(
        Icons.alternate_email,
        color: theme.onSurface.withValues(alpha: 0.55),
        size: 20.r,
      ),
    );
  }
}
