import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/functions/validator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../l10n/app_localizations.dart';

class AddressField extends StatelessWidget {
  const AddressField({
    super.key,
    required this.controller,
    this.focusNode,
    this.textInputAction = TextInputAction.next,
    this.onFieldSubmitted,
  });

  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onFieldSubmitted;

  @override
  Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return AppTextField(
      controller: controller,
      focusNode: focusNode,
      label: l.address_label,
      hint: l.address_hint,
      keyboardType: TextInputType.streetAddress,
      textInputAction: textInputAction,
      validator: (v) => AppValidators.required(v, context),
      onFieldSubmitted: onFieldSubmitted,
      prefix: Icon(
        Icons.location_on_outlined,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.55),
        size: 20.r,
      ),
    );
  }
}
