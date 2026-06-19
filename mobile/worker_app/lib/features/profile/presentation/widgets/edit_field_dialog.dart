import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../config/theme/styles.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_elevated_button.dart';
import '../../../../core/widgets/custom_outlined_button.dart';
import '../../../../l10n/app_localizations.dart';

/// A small dialog that lets the worker edit a single text field (e.g. email or
/// employee id) and save it. Returns the trimmed new value via
/// `Navigator.pop`, or null when cancelled / unchanged.
///
/// Use [showEditFieldDialog] rather than constructing this directly.
class EditFieldDialog extends StatefulWidget {
  final String title;
  final String label;
  final String initialValue;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  const EditFieldDialog({
    super.key,
    required this.title,
    required this.label,
    required this.initialValue,
    this.keyboardType = TextInputType.text,
    this.validator,
  });

  @override
  State<EditFieldDialog> createState() => _EditFieldDialogState();
}

class _EditFieldDialogState extends State<EditFieldDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialValue);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final value = _controller.text.trim();
    // Treat "no change" as a cancel so callers don't fire a needless save.
    Navigator.of(context).pop(value == widget.initialValue.trim() ? null : value);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    final l = AppLocalizations.of(context)!;

    // Use a plain [Dialog] (not [AlertDialog]): AlertDialog wraps its content in
    // an IntrinsicWidth, and a Row with Expanded children can't report an
    // intrinsic width — which previously crashed this dialog during paint.
    // Dialog gives the child bounded (but non-intrinsic) width, so Expanded is
    // happy. The content is scrollable to stay safe when the keyboard shows.
    return Dialog(
      backgroundColor: theme.surface,
      surfaceTintColor: theme.surface,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.title,
                style: Styles.textStyle16.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16.h),
              AppTextField(
                controller: _controller,
                label: widget.label,
                keyboardType: widget.keyboardType,
                textInputAction: TextInputAction.done,
                autofocus: true,
                validator: widget.validator,
                onFieldSubmitted: (_) => _save(),
              ),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Expanded(
                    child: CustomOutlinedButton(
                      text: l.cancel,
                      height: 44.h,
                      onPressed: () => Navigator.of(context).pop(),
                      buttonTextStyle: Styles.textStyle14.copyWith(
                        color: theme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                      buttonStyle: OutlinedButton.styleFrom(
                        side: BorderSide(color: theme.primary),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: CustomElevatedButton(
                      text: l.save,
                      height: 44.h,
                      onPressed: _save,
                      buttonTextStyle: Styles.textStyle14.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                      buttonStyle: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shows an [EditFieldDialog] and resolves to the new (trimmed) value, or null
/// if the worker cancelled or left it unchanged.
Future<String?> showEditFieldDialog(
  BuildContext context, {
  required String title,
  required String label,
  required String initialValue,
  TextInputType keyboardType = TextInputType.text,
  FormFieldValidator<String>? validator,
}) {
  return showDialog<String>(
    context: context,
    builder: (_) => EditFieldDialog(
      title: title,
      label: label,
      initialValue: initialValue,
      keyboardType: keyboardType,
      validator: validator,
    ),
  );
}
